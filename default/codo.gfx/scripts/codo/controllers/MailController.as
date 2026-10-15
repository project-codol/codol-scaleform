package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.DWServiceStatus;
   import codo.constants.DataID;
   import codo.constants.MailType;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SE_ID;
   import codo.constants.SanitizedType;
   import codo.event.ParaEvent;
   import codo.localization.DictAAS;
   import codo.localization.DictMail;
   import codo.localization.DictSystem;
   import codo.manager.AsyncTaskManager;
   import codo.objects.MailAttachmentObj;
   import codo.objects.MailObj;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.views.UITutorialBaseView;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import fsg.util.FsgAudioUtil;
   
   public class MailController extends BaseController
   {
      
      private static var TAG_A_0:String = "<A>";
      
      private static var TAG_A_1:String = "</A>";
      
      private static var TAG_T_0:String = "<T>";
      
      private static var TAG_T_1:String = "</T>";
      
      private static var TAG_M_0:String = "<M>";
      
      private static var TAG_M_1:String = "</M>";
      
      private static var TAG_S_0:String = "<S>";
      
      private static var TAG_S_1:String = "</S>";
      
      private var _mailDP:Array = [];
      
      private var _attachmentDP:Array = [];
      
      private var _mailToDel:Array = null;
      
      private var _mailToSend:MailObj = null;
      
      private var _mailToReturn:MailObj = null;
      
      private var _bFetchMailPending:Boolean = false;
      
      private var _newMailToBeShown:Object;
      
      private var _newMailAppearCheckTimer:Timer;
      
      public function MailController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
         this.listen(BCEvent.MESSAGE_MAILRAWDATA,this.onMailRawDataGet);
         this.listen(BCEvent.EVT_SEND_MAIL,this.onSendMailHandle);
         this.listen(BCEvent.EVT_DELETE_MAIL,this.onDeleteMailHandle);
         this.listen(BCEvent.EVT_RETURN_MAIL,this.onReturnMailHandle);
         this.listen(BCEvent.EVT_ON_MAIL_SELECTED,this.onMailSelectedHandle);
         this.listen(BCEvent.EVT_ON_MAIL_READ,this.onMailReadHandle);
         this.listen(BCEvent.EVT_ON_MAIL_READ_BATCH,this.onMailBatchReadHandle);
         this.listen(BCEvent.MESSAGE_ALERTED,this.onMessageAlerted);
         this.listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onMailSanitizedHandle);
         this.listen(BCEvent.EVT_RETURN_COUPON_CANCEL,this.onCancelReturnHandle);
         this.listen(BCEvent.EVT_ON_COUPON_CLAIMED,this.onCouponClaimedHandle);
         this.listen(BCEvent.CLOSE_MAILPENDING,this.onCloseMailPending);
         this.listen(BCEvent.EVT_MAIL_RECEIVEALLATTACHMENT,this.onRetrieveAllAttachment);
         this.listen(BCEvent.CLOSE_NEW_MAIL_NOTIFICATION,this.onCloseNewMailNotification);
         this.listen(BCEvent.SHOW_NEW_MAIL_NOTIFICATION,this.onShowNewMailNotification);
         this.bind(DataID.ON_NEW_MAIL,this.bind_onNewMail);
         this.bind(DataID.FETCH_MAIL_HEADERS,this.bind_mailHeaderDP);
         this.bind(DataID.EAsyncTaskID_Demonware,this.bind_demonwareMailStatusChange);
         this.addDP(DataID.NEW_MAIL_SHOWING,this.getShowingNewMail);
      }
      
      public function cppFetchMail() : void
      {
         this.fetchMail();
      }
      
      public function cppDeleteAllMails() : void
      {
         Logger.print("MailController::deleteAllMails");
         if(this._mailDP.length <= 0)
         {
            return;
         }
         var mailsToDelete:Array = [];
         for(var i:int = 0; i < this._mailDP.length; i++)
         {
            mailsToDelete.push(this._mailDP[i]);
         }
         this.onDeleteMailHandle(new ParaEvent(BCEvent.EVT_DELETE_MAIL,{
            "mails":mailsToDelete,
            "show":false
         }));
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(CFunctionContainer.GetAndClearMailPendingFlag(false)))
         {
            this.broadcast(BCEvent.EVT_ON_NEW_MAIL);
         }
         this.fetchMail();
      }
      
      private function onSendMailHandle(cEvt:ParaEvent) : void
      {
         this._mailToSend = cEvt.myPara;
         if(this._mailToSend == null)
         {
            return;
         }
         var userName:String = this.getDP(DataID.PLAYER_USER_NAME);
         for(var i:int = 0; i < this._mailToSend.receivers.length; i++)
         {
            if(this._mailToSend.receivers[i] == userName)
            {
               this.showMsg(DictMail.NOTE_MAIL_CANNOT_SEND_SELF,MsgBtnCount.ONE);
               return;
            }
         }
         var title:String = this._mailToSend.title;
         var message:String = this._mailToSend.message;
         this.showMailOperationPanel(true,DictMail.NOTE_MAIL_SENDING);
         if(title.length > 0)
         {
            Logger.print("MainController::onSendMailHandle sanitizemail title");
            this.sanitizeMail(SanitizedType.MAIL_TITLE,title);
         }
         else if(message.length > 0)
         {
            Logger.print("MainController::onSendMailHandle sanitizemail msg");
            this.sanitizeMail(SanitizedType.MAIL_MSG,message);
         }
      }
      
      private function onDeleteMailHandle(cEvt:ParaEvent) : void
      {
         this._mailToDel = cEvt.myPara.mails;
         if(this._mailToDel.length <= 0)
         {
            return;
         }
         if(Boolean(cEvt.myPara.show))
         {
            if(this.areMailsAttached(this._mailToDel))
            {
               this.showMsg(DictMail.NOTE_MAIL_DELETE_WITH_ATTACHMENT,MsgBtnCount.THREE,0,this.fetchAttachment,DictMail.MAIL_FETCH_ATTACHMENT,this.deleteMail,DictMail.MAIL_DELETE_ATTACHMENT,null,DictSystem.CANCEL);
               FsgAudioUtil.getInstance().playSound(SE_ID.UI_SOCIALPANEL_MSG_DELETECONFIRM);
            }
            else
            {
               this.showMsg(DictMail.NOTE_MAIL_DELETE,MsgBtnCount.TWO,0,this.deleteMail);
               FsgAudioUtil.getInstance().playSound(SE_ID.UI_SOCIALPANEL_MSG_DELETECONFIRM);
            }
         }
         else
         {
            this.deleteMail();
         }
      }
      
      private function onReturnCouponHandle(cEvt:ParaEvent) : void
      {
         this._mailToReturn = cEvt.myPara;
         if(this._mailToReturn != null)
         {
            this._mailToReturn.mailType = MailType.RETURN;
         }
      }
      
      private function onCouponClaimedHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(cEvt.myPara.mail))
         {
            this._mailToDel = cEvt.myPara.mail;
            this.deleteMail();
         }
      }
      
      private function onReturnMailHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara == 0)
         {
            this._mailToReturn = null;
            this.showMailOperationPanel(true,DictMail.NOTE_MAIL_RETURN_FAIL,true);
            return;
         }
         if(this._mailToReturn == null || !this._mailToReturn.isAttached)
         {
            return;
         }
         var tempTitle:String = this._mailToReturn.title;
         tempTitle = LocalizeUtil.localize(DictMail.MAIL_RETURN_TITLE) + tempTitle;
         this._mailToReturn.title = tempTitle;
         this.returnMail();
      }
      
      private function onMailReadHandle(cEvt:ParaEvent) : void
      {
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            CFunctionContainer.AS_MessageSetRead(cEvt.myPara.messageid);
         }
      }
      
      private function onMailBatchReadHandle(cEvt:ParaEvent) : void
      {
         var mailIds:Array = null;
         var mailObjs:Array = null;
         var mailCount:int = 0;
         var i:int = 0;
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            mailIds = [];
            mailObjs = cEvt.myPara;
            mailCount = int(mailObjs.length);
            for(i = 0; i < mailCount; i++)
            {
               mailIds.push(mailObjs[i].messageid);
            }
            CFunctionContainer.AS_MessageSetReadBatch(mailIds);
         }
      }
      
      private function onMailSelectedHandle(cEvt:ParaEvent) : void
      {
         Logger.print("MailController::onMailSelectedHandle cEvt.myPara.id: " + cEvt.myPara.id);
         var index:int = DataUtil.indexInArray(cEvt.myPara.id,this._mailDP);
         if(this._mailDP[index].isRead == false)
         {
            CFunctionContainer.ReadMail(this._mailDP[index].id);
         }
         this.broadcast(BCEvent.SHOW_MAIL_DETAIL,this._mailDP[index]);
      }
      
      private function onMessageAlerted(cEvt:ParaEvent) : void
      {
         var id:uint = cEvt.myPara as uint;
         CFunctionContainer.AS_MessageSetAlerted(id);
      }
      
      private function onMailSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type == SanitizedType.MAIL_TITLE)
         {
            Logger.print("MailController::onMailSanitizedHandle mail title: " + cEvt.myPara);
            this._mailToSend.title = cEvt.myPara.content;
            if(Boolean(cEvt.myPara.sanitized))
            {
               this.broadcast(BCEvent.EVT_ON_MAIL_SANITIZE_FAILED,this._mailToSend);
               this.showMsg(DictMail.NOTE_MAIL_SUBJECT_SANITIZED,MsgBtnCount.ONE);
               return;
            }
            if(this._mailToSend.message.length > 0)
            {
               this.sanitizeMail(SanitizedType.MAIL_MSG,this._mailToSend.message);
            }
            else
            {
               this.sendMail(this._mailToSend);
            }
         }
         else if(cEvt.myPara.type == SanitizedType.MAIL_MSG)
         {
            Logger.print("MailController::onMailSanitizedHandle mail message: " + cEvt.myPara);
            this._mailToSend.message = cEvt.myPara.content;
            if(Boolean(cEvt.myPara.sanitized))
            {
               this.broadcast(BCEvent.EVT_ON_MAIL_SANITIZE_FAILED,this._mailToSend);
               this.showMsg(DictMail.NOTE_MAIL_MESSAGE_SANITIZED,MsgBtnCount.ONE);
               return;
            }
            this.sendMail(this._mailToSend);
         }
      }
      
      private function bind_onNewMail(cRes:Object) : void
      {
         Logger.print("MailController::bind_onNewMail");
         this.broadcast(BCEvent.EVT_ON_NEW_MAIL);
         this.fetchMail();
      }
      
      private function bind_mailHeaderDP(cRes:Object) : void
      {
         var i:int = 0;
         var mailIndex:int = 0;
         if(!cRes.result)
         {
            this.showMailOperationPanel(true,DictMail.NOTE_MAIL_FETCH_FAIL,true);
            return;
         }
         var mailHeaders:Array = [];
         var maxMailSize:int = 0;
         for(i = cRes.data.length - 1; i >= 0; i--)
         {
            mailIndex = DataUtil.indexInArray(cRes.data[i].id,this._mailDP);
            if(mailIndex == -1)
            {
               mailHeaders.push(cRes.data[i]);
               this._mailDP.unshift(new MailObj(cRes.data[i]));
               maxMailSize = this._mailDP[0].mailSize > maxMailSize ? int(this._mailDP[0].mailSize) : maxMailSize;
            }
         }
         if(mailHeaders.length > 0)
         {
            for(i = 0; i < mailHeaders.length; i++)
            {
               mailHeaders[i].mailSize = maxMailSize;
            }
            this.request(DataID.FETCH_MAIL_BODIES,mailHeaders);
         }
         else
         {
            this.showMailOperationPanel(false);
         }
      }
      
      private function bind_demonwareMailStatusChange(cRes:Object) : void
      {
         var i:uint = 0;
         for(i = 0; i < cRes.data.length; i++)
         {
            if(cRes.data[i].name == "mail" && cRes.data[i].status == DWServiceStatus.UNRESPONSIVE)
            {
               Logger.print("MailController::bind_demonwareMailStatusChange: UNRESPONSIVE - timestamp: " + cRes.data[i].timestamp + "\n");
            }
         }
      }
      
      private function getShowingNewMail() : Object
      {
         return this._newMailToBeShown;
      }
      
      private function onMailRawDataGet(cEvt:ParaEvent) : void
      {
         var _mails:Array = null;
         var tmailobj:MailObj = null;
         var body:String = null;
         var tempattachmentString:String = null;
         var tempattachmentStringArray:Array = null;
         var ti:int = 0;
         var tempMailObj:MailObj = null;
         var hasAttachment:Boolean = false;
         var iMail:int = 0;
         _mails = cEvt.myPara as Array;
         this._mailDP.splice(0);
         for(var index:int = 0; index < _mails.length; index++)
         {
            tmailobj = new MailObj();
            this._mailDP.push(tmailobj);
            tmailobj.id = _mails[index].id;
            tmailobj.messageid = _mails[index].messageid;
            tmailobj.isAlerted = _mails[index].isAlerted;
            tmailobj.isRead = _mails[index].isRead;
            tmailobj.senderName = _mails[index].senderName;
            tmailobj.senderID = _mails[index].senderID;
            tmailobj.formattedTime = _mails[index].formattedTime;
            tmailobj.timeStamp = tmailobj.formattedTime;
            tmailobj.message = _mails[index].message;
            body = _mails[index].message;
            tempattachmentString = this.getAttachment(body);
            tempattachmentStringArray = tempattachmentString.split(",");
            for(ti = 0; ti < tempattachmentStringArray.length; ti++)
            {
               tempMailObj = this._mailDP[index];
               tempMailObj.addAttachment(tempattachmentStringArray[ti]);
            }
            tmailobj.isAttached = tmailobj.mailAttachmentArray.length > 0;
            Logger.print("tmailobj.isAttached: " + tmailobj.isAttached);
            tmailobj.title = this.getTitle(body);
            tmailobj.message = this.getMessage(body);
            tmailobj.mailType = this.getType(body);
            if(tmailobj.mailType == MailType.SYSTEM)
            {
               tmailobj.senderName = DictAAS.AAS_SYSTEM;
               tmailobj.senderID = "";
               tmailobj.title = CFunctionCommonContainer.Base64Decode(tmailobj.title);
               tmailobj.message = CFunctionCommonContainer.Base64Decode(tmailobj.message);
            }
            tmailobj.timeStamp = tmailobj.formattedTime;
         }
         if(this._mailDP.length > 0)
         {
            hasAttachment = false;
            for(iMail = 0; iMail < this._mailDP.length; iMail++)
            {
               if(Boolean(this._mailDP[iMail].isAttached))
               {
                  hasAttachment = true;
                  break;
               }
            }
            if(hasAttachment)
            {
               CFunctionContainer.MKT_RefreshPendingCoupon();
            }
            else
            {
               this.onMailReceived();
            }
         }
         else
         {
            this.onMailReceived();
         }
      }
      
      public function cppOnMailAttachmentRefreshed(data:Object) : void
      {
         var iMailAttach:int = 0;
         var isAttached:Boolean = false;
         var attachmentId:String = null;
         var index:int = 0;
         this._attachmentDP.splice(0);
         for(var iAttachment:int = 0; iAttachment < data.length; iAttachment++)
         {
            this._attachmentDP.push(new MailAttachmentObj(data[iAttachment]));
         }
         for(var iMail:int = 0; iMail < this._mailDP.length; iMail++)
         {
            if(Boolean(this._mailDP[iMail].isAttached))
            {
               for(iMailAttach = 0; iMailAttach < this._mailDP[iMail].mailAttachmentArray.length; iMailAttach++)
               {
                  isAttached = false;
                  attachmentId = this._mailDP[iMail].mailAttachmentArray[iMailAttach].attachment;
                  index = DataUtil.indexInArray(attachmentId,this._attachmentDP);
                  if(index != -1)
                  {
                     this._mailDP[iMail].mailAttachmentArray[iMailAttach].attachmentProdId = this._attachmentDP[index].prodID;
                     if(this._mailDP[iMail].title.length <= 0)
                     {
                        this._mailDP[iMail].title = LocalizeUtil.localize(this._attachmentDP[index].name);
                     }
                     isAttached = true;
                  }
                  else
                  {
                     this._mailDP[iMail].removeAttachmentByIdx(iMailAttach);
                     iMailAttach--;
                  }
                  this._mailDP[iMail].isAttached = isAttached;
               }
            }
         }
         this.onMailReceived();
      }
      
      private function onMailReceived() : void
      {
         this.showMailOperationPanel(false);
         this.setBindData(DataID.MAILS,this._mailDP);
      }
      
      private function onMailSent(cRes:Object) : void
      {
         var msg:String = null;
         Logger.print("MailController::onMailSent cRes.result: " + cRes.result);
         if(this._mailToReturn == null)
         {
            if(!this._mailToSend.isAttached)
            {
               msg = cRes.result == 1 ? DictMail.NOTE_MAIL_SEND_SUCCESS : (cRes.data <= 0 ? DictMail.NOTE_MAIL_SEND_FAIL_INVALID_USER : DictMail.NOTE_MAIL_SEND_FAIL);
               this.showMailOperationPanel(true,msg,true);
               this.showMsg(msg,MsgBtnCount.ONE);
            }
            this.broadcast(BCEvent.EVT_ON_MAIL_SENT,cRes);
         }
         else
         {
            if(cRes.result == 0)
            {
               this._mailToReturn = null;
               this.showMailOperationPanel(true,DictMail.NOTE_MAIL_RETURN_FAIL,true);
               return;
            }
            this._mailToDel = [this._mailToReturn];
            this.deleteMail();
         }
      }
      
      private function onMailDeleted(cRes:Object) : void
      {
         var resMsg:String = null;
         var i:int = 0;
         var index:int = 0;
         if(this._mailToReturn == null)
         {
            resMsg = cRes.result == 1 ? DictMail.NOTE_MAIL_DELETE_SUCCESS : DictMail.NOTE_MAIL_DELETE_FAIL;
         }
         else
         {
            this._mailToReturn = null;
            resMsg = cRes.result == 1 ? DictMail.NOTE_MAIL_RETURN_SUCCESS : DictMail.NOTE_MAIL_RETURN_FAIL;
         }
         this.showMailOperationPanel(true,resMsg,true);
         if(!cRes.result)
         {
            return;
         }
         if(Boolean(this._mailToDel) && this._mailToDel.length > 0)
         {
            for(i = 0; i < this._mailToDel.length; i++)
            {
               index = DataUtil.indexInArray(this._mailToDel[i].id,this._mailDP);
               if(index >= 0)
               {
                  this._mailDP.splice(index,1);
               }
            }
            this.broadcast(BCEvent.EVT_HIDE_MAIL_DETAIL,this._mailToDel);
            this._mailToDel = null;
            this.setBindData(DataID.MAILS,this._mailDP);
         }
      }
      
      public function cpponMailRead(mailread:Array) : void
      {
         var j:int = 0;
         for(var i:int = 0; i < mailread.length; i++)
         {
            for(j = 0; j < this._mailDP.length; j++)
            {
               if(this._mailDP[j].id == mailread[i].id)
               {
                  Logger.print("===cpponMailRead:" + i + "//" + mailread[i].isRead);
                  this._mailDP[j].isRead = mailread[i].isRead;
                  break;
               }
            }
         }
         this.setBindData(DataID.MAILS,this._mailDP);
      }
      
      private function fetchMail(cStartIndex:int = 0) : void
      {
         if(ScaleformUtil.isTempContentEnabled_3() == false)
         {
            Logger.print("MailController::fetchMail");
            this.showMailOperationPanel(true,DictMail.NOTE_MAIL_FETCHING);
            if(AsyncTaskManager.getInstance().canCreateTask(DataID.FETCH_MAIL_HEADERS,AsyncTaskGroup.MAIL))
            {
               this.request(DataID.FETCH_MAIL_HEADERS,cStartIndex);
               this._bFetchMailPending = false;
            }
            else
            {
               this._bFetchMailPending = true;
            }
         }
      }
      
      private function showMailOperationPanel(cShow:Boolean, cMsg:String = "", cShowBtn:Boolean = false) : void
      {
         this.broadcast(BCEvent.EVT_MAIL_OPERATION_PANEL,{
            "show":cShow,
            "msg":cMsg,
            "showBtn":cShowBtn
         });
      }
      
      private function areMailsAttached(mails:Array) : Boolean
      {
         for(var i:int = 0; i < mails.length; i++)
         {
            if(Boolean(mails[i].isAttached))
            {
               return true;
            }
         }
         return false;
      }
      
      private function sanitizeMail(type:uint, message:String) : void
      {
         this.broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
            "type":type,
            "content":message
         });
      }
      
      private function returnMail() : void
      {
         if(this._mailToReturn == null)
         {
            return;
         }
         this.showMailOperationPanel(true,DictMail.NOTE_MAIL_RETURNING);
         this._mailToReturn.receivers.push(this._mailToReturn.senderName);
         this.sendMail(this._mailToReturn);
      }
      
      private function fetchAttachment() : void
      {
         this.hideMsg();
         this.broadcast(BCEvent.EVT_CLAIM_COUPONARRAY,[this._mailToDel[0]]);
      }
      
      private function fetchAllAttachment() : void
      {
         var mailWithAttachment:Array = new Array();
         for(var i:int = 0; i < this._mailDP.length; i++)
         {
            if(Boolean(this._mailDP[i].isAttached))
            {
               mailWithAttachment.push(this._mailDP[i]);
            }
         }
         if(mailWithAttachment.length > 0)
         {
            this.broadcast(BCEvent.EVT_CLAIM_COUPONARRAY,mailWithAttachment);
         }
      }
      
      private function deleteMail() : void
      {
         if(this._mailToDel == null || this._mailToDel.length < 0)
         {
            return;
         }
         this.hideMsg();
         if(this._mailToReturn == null)
         {
            this.showMailOperationPanel(true,DictMail.NOTE_MAIL_DELETING);
         }
         for(var i:int = 0; i < this._mailToDel.length; i++)
         {
            CFunctionContainer.AS_MessageDelete(this._mailToDel[i].messageid);
         }
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_SOCIALPANEL_MSG_DELETED);
      }
      
      private function sendMail(mail:Object) : void
      {
      }
      
      private function getTitle(msg:String) : String
      {
         return this.getContent(msg,TAG_T_0,TAG_T_1);
      }
      
      private function getMessage(msg:String) : String
      {
         return this.getContent(msg,TAG_M_0,TAG_M_1);
      }
      
      private function getAttachment(msg:String) : String
      {
         return this.getContent(msg,TAG_A_0,TAG_A_1);
      }
      
      private function getType(msg:String) : int
      {
         var sType:String = this.getContent(msg,TAG_S_0,TAG_S_1);
         return sType == "" ? int(MailType.NORMAL) : int(parseInt(sType));
      }
      
      private function getContent(msg:String, tagStart:String, tagEnd:String) : String
      {
         var start:int = msg.indexOf(tagStart);
         var end:int = msg.indexOf(tagEnd);
         return start >= 0 && end > start ? msg.substring(start + tagStart.length,end) : "";
      }
      
      private function onCloseMailPending(event:ParaEvent) : void
      {
         CFunctionContainer.GetAndClearMailPendingFlag(true);
      }
      
      private function onRetrieveAllAttachment(event:ParaEvent) : void
      {
         this.fetchAllAttachment();
      }
      
      private function onCancelReturnHandle(event:ParaEvent) : void
      {
         this._mailToReturn = null;
      }
      
      override public function update(deltaTime:Number) : void
      {
         super.update(deltaTime);
         if(this._bFetchMailPending == true)
         {
            this.fetchMail();
         }
      }
      
      private function onCloseNewMailNotification(cEvt:ParaEvent) : void
      {
         this._newMailToBeShown = null;
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.NEW_MAIL_NOTIFICATION});
         broadcast(BCEvent.HIDE_NEW_MAIL_NOTIFICATION);
      }
      
      private function onShowNewMailNotification(cEvt:ParaEvent) : void
      {
         this._newMailToBeShown = cEvt.myPara;
         this.tryToShowNewMailNotification();
      }
      
      private function tryToShowNewMailNotification() : void
      {
         if(!this.checkNewMailAppearCondition())
         {
            this.tryCleanNewMailAppearCheckTimer();
            this._newMailAppearCheckTimer = new Timer(1000);
            this._newMailAppearCheckTimer.addEventListener(TimerEvent.TIMER,this.checkNewMailAppearInterval);
            this._newMailAppearCheckTimer.start();
         }
         else
         {
            this.realStartShowNotification();
         }
      }
      
      private function tryCleanNewMailAppearCheckTimer() : void
      {
         if(Boolean(this._newMailAppearCheckTimer))
         {
            this._newMailAppearCheckTimer.reset();
            this._newMailAppearCheckTimer.removeEventListener(TimerEvent.TIMER,this.checkNewMailAppearInterval);
            this._newMailAppearCheckTimer = null;
         }
      }
      
      private function checkNewMailAppearInterval() : void
      {
         if(this.checkNewMailAppearCondition())
         {
            this.tryCleanNewMailAppearCheckTimer();
            this.realStartShowNotification();
         }
      }
      
      private function checkNewMailAppearCondition() : Boolean
      {
         return !this.disabledForUITour() && Boolean(getDP(DataID.IS_MAIL_NOTIFICATION_READY));
      }
      
      private function realStartShowNotification() : void
      {
         broadcast(BCEvent.EVT_SHOW_MAIL_NOTIFICATION_VIEW,this._newMailToBeShown);
      }
      
      private function disabledForUITour() : Boolean
      {
         return !CFunctionCommonContainer.OnboardIntroDone() || UITutorialBaseView.isTutorialShowing();
      }
   }
}

