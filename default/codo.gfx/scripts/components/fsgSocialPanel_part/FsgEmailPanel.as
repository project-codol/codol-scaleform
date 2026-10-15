package components.fsgSocialPanel_part
{
   import codo.base.BaseView;
   import codo.component.Button;
   import codo.component.CloseButton;
   import codo.component.ComboBox;
   import codo.component.social.SocialSimpleContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.InvitationType;
   import codo.constants.MsgBtnCount;
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMail;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.objects.SocialPanelFilterObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import components.fsgSocialPanel_part.FsgEmailHelper.FsgMailType;
   import components.fsgSocialPanel_part.FsgEmailHelper.MailDataAdapterClanInvites2Mail;
   import components.fsgSocialPanel_part.FsgEmailHelper.MailDataAdapterFriendInvites2Mail;
   import components.fsgSocialPanel_part.FsgEmailHelper.MailDataAdapterGameInvites2Mail;
   import components.fsgSocialPanel_part.FsgEmailHelper.MailDataAdapterLog2Mail;
   import components.fsgSocialPanel_part.FsgEmailHelper.MailDataAdapterMail2Mail;
   import components.fsgSocialPanel_part.FsgEmailHelper.MailDataAdapterSystemMessage2Mail;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import fsg.shared.BehaviourScrollPane;
   import fsg.shared.ScrollBar;
   import fsg.socialcontainer.fsgEmailItem;
   import fsg.util.FsgAudioUtil;
   import fsg.util.FsgUtil;
   
   public class FsgEmailPanel extends BaseView
   {
      
      private static const REFRESH_INTERVAL:uint = 10;
      
      private static const PER_PAGE_COUNT:uint = 15;
      
      private static const MAX_MAIL_ITEM_NUM:int = 10;
      
      public var myScrollBar:ScrollBar;
      
      public var myMask:MovieClip;
      
      public var myScrollArea:FsgEmailScrollArea;
      
      public var myNoDataHint:TextField;
      
      public var myRefreshBtn:Button;
      
      public var myBlackMask:MovieClip;
      
      public var myContentContainer:SocialSimpleContainer;
      
      public var myCloseBtn:CloseButton;
      
      public var myTitle:TextField;
      
      public var myFilter:ComboBox;
      
      public var myFilterLabel:TextField;
      
      public var myReadAllBtn:Button;
      
      public var myClaimAllRewardsBtn:Button;
      
      protected var m_scrollPaneBehaviour:BehaviourScrollPane;
      
      private var m_selectedMailObj:Object;
      
      private var m_selectedCategoryIndex:int = -1;
      
      private var m_mail2MailDA:MailDataAdapterMail2Mail = new MailDataAdapterMail2Mail();
      
      private var m_friendInvites2MailDA:MailDataAdapterFriendInvites2Mail = new MailDataAdapterFriendInvites2Mail();
      
      private var m_clanInvites2MailDA:MailDataAdapterClanInvites2Mail = new MailDataAdapterClanInvites2Mail();
      
      private var m_gameInvite2MailDA:MailDataAdapterGameInvites2Mail = new MailDataAdapterGameInvites2Mail();
      
      private var m_gameLog2MailDA:MailDataAdapterLog2Mail = new MailDataAdapterLog2Mail();
      
      private var m_systemMessage2MailDA:MailDataAdapterSystemMessage2Mail = new MailDataAdapterSystemMessage2Mail();
      
      public var m_EmailList:Array;
      
      public var m_DropList:Vector.<SocialPanelFilterObj>;
      
      public var m_DataList:Array;
      
      public var m_MinEmailHight:Number;
      
      public var m_MaxEmailHight:Number;
      
      public var m_padding:Number;
      
      public var m_selectedEmail:Number;
      
      public var m_currentMailLength:Number;
      
      private var m_selectedType:int = -2;
      
      private var m_firstDisplayItemIndex:int = 0;
      
      private var m_displayedMailDataNum:int = 0;
      
      private var m_mailClosedHeight:Number = 0;
      
      private var m_mailSelectedHeight:Number = 0;
      
      private var _refreshEnableTimer:Timer;
      
      private var _isRefreshEnable:Boolean = true;
      
      public function FsgEmailPanel()
      {
         super();
         var filter_mail_all:SocialPanelFilterObj = new SocialPanelFilterObj(0,DictMail.MAIL_TYPE_ALL,FsgMailType.MAIL_TYPE_ALL,new MailDataWrapper(DictMail.NO_MAIL_INVITE_HINT));
         var filter_mail_announcement:SocialPanelFilterObj = new SocialPanelFilterObj(1,DictMail.MAIL_TYPE_ANNOUNCEMENT,FsgMailType.MAIL_TENCENT_MAIL,new MailDataWrapper(DictMail.NO_MAIL_HINT));
         var filter_mail_system:SocialPanelFilterObj = new SocialPanelFilterObj(2,DictMail.MAIL_TYPE_SYSTEM,FsgMailType.MAIL_TYPE_SYSTEM,new MailDataWrapper(DictMail.NO_MSG_HINT));
         var filter_mail_game_invite:SocialPanelFilterObj = new SocialPanelFilterObj(3,DictMail.MAIL_TYPE_GAME_INVITE,FsgMailType.MAIL_TYPE_GAME_INVITE,new MailDataWrapper(DictMail.NO_INVITE_HINT));
         var filter_mail_friend_invite:SocialPanelFilterObj = new SocialPanelFilterObj(4,DictMail.MAIL_TYPE_FRIEND_INVITE,FsgMailType.MAIL_TYPE_FRIEND_INVITE,new MailDataWrapper(DictMail.NO_INVITE_HINT));
         var filter_mail_clan_invite:SocialPanelFilterObj = new SocialPanelFilterObj(5,DictMail.MAIL_TYPE_CLAN_INVITE,FsgMailType.MAIL_TYPE_CLAN_INVITE,new MailDataWrapper(DictMail.NO_INVITE_HINT));
         var filter_mail_rewards:SocialPanelFilterObj = new SocialPanelFilterObj(6,DictMail.MAIL_TYPE_REWARDS,FsgMailType.MAIL_TYPE_REWARD,new MailDataWrapper(DictMail.NO_REWARD_HINT));
         this.m_DropList = new <SocialPanelFilterObj>[filter_mail_all,filter_mail_announcement,filter_mail_system,filter_mail_game_invite,filter_mail_friend_invite,filter_mail_clan_invite,filter_mail_rewards];
         this.allocMailItemList();
         this.m_DataList = [];
         this.m_MinEmailHight = 47;
         this.m_MaxEmailHight = 230;
         this.m_padding = 10;
         this.m_selectedEmail = -1;
         this.m_currentMailLength = 0;
         this.myTitle.text = Dict.MAIN_MENU_LABEL_MAIL_SHORT_NAME;
         this.myContentContainer.width = 540;
         this.myContentContainer.height = 714;
         this.myFilter.width = 123;
         this.myFilter.singleOptionMode = true;
         this.myFilterLabel.text = Dict.FILTER_OPTION;
         var options:Array = [{
            "id":0,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_ALL
         },{
            "id":1,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_ANNOUNCEMENT
         },{
            "id":2,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_SYSTEM
         },{
            "id":3,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_GAME_INVITE
         },{
            "id":4,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_FRIEND_INVITE
         },{
            "id":5,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_CLAN_INVITE
         },{
            "id":6,
            "enabled":true,
            "label":DictMail.MAIL_TYPE_REWARDS
         }];
         this.myFilter.dataProvider = options;
         this.myFilter.label = DictMail.MAIL_TYPE_ALL;
         this.myFilter.addEventListener(ComboBox.EVT_CHANGE,this.onFilterChanged);
         this.myCloseBtn.registerClickEvent(this.onCloseButtonClickHandler);
         this.m_scrollPaneBehaviour = new BehaviourScrollPane(this.myScrollBar,this.myMask,this.myScrollArea,this.myScrollArea);
         this.m_scrollPaneBehaviour.setScrollCallback(this.listScrollHandler);
         this.myNoDataHint.visible = false;
         this._refreshEnableTimer = new Timer(1000);
         this._refreshEnableTimer.addEventListener(TimerEvent.TIMER,this.onRefreshTimerHandle);
         this.myRefreshBtn.width = 107;
         this.myRefreshBtn.height = 42;
         this.myRefreshBtn.label = Dict.REFRESH;
         this.myRefreshBtn.registerClickEvent(this.onRefreshBtnClickHandle);
         var textIconGap:int = 5;
         var hintTF:TextField = this.myBlackMask.myHintTF as TextField;
         hintTF.autoSize = TextFieldAutoSize.LEFT;
         hintTF.text = Dict.NOTE_LIST_MAIL;
         var totalWidth:Number = hintTF.width + this.myBlackMask.mySpinIcon.width + textIconGap;
         this.myBlackMask.mySpinIcon.x = hintTF.x + hintTF.width + textIconGap + this.myBlackMask.mySpinIcon.width / 2;
         this.switchInertState(false);
         if(this.m_selectedCategoryIndex == -1)
         {
            this.myFilter.selectedIndex = 0;
         }
         this.myReadAllBtn.width = 107;
         this.myReadAllBtn.height = 42;
         this.myReadAllBtn.label = Dict.READ_ALL;
         this.myReadAllBtn.registerClickEvent(this.onReadAllButtonClickHandler);
         this.myClaimAllRewardsBtn.width = 107;
         this.myClaimAllRewardsBtn.height = 42;
         this.myClaimAllRewardsBtn.label = Dict.CLAIM_ALL_REWARDS;
         this.myClaimAllRewardsBtn.registerClickEvent(this.onClaimAllRewardButtonClientHandler);
         bind(DataID.MAILS,this.bind_mailDP);
         bind(DataID.MESSAGE_FRIEND,this.bind_friendInvites);
         bind(DataID.MESSAGE_CLAN,this.bind_clanInvites);
         bind(DataID.MESSAGE_BOX,this.bind_roomInvites);
         bind(DataID.LOG_INFO,this.bind_logInfo);
         listen(BCEvent.HIDE_NEW_MAIL_NOTIFICATION,this.mailNotificationClosedHandler);
      }
      
      override protected function showView() : void
      {
         super.showView();
         x = 167;
         y = 363;
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      private function onFilterChanged(e:ParaEvent) : void
      {
         var option:Object = this.myFilter.selectedData;
         this.myFilter.label = option.label;
         this.sortList(option.id);
      }
      
      private function switchInertState(value:Boolean) : void
      {
         if(!value)
         {
            this.myBlackMask.visible = false;
            this.myBlackMask.mySpinIcon.gotoAndStop(1);
         }
         else
         {
            this.myBlackMask.visible = true;
            this.myBlackMask.mySpinIcon.gotoAndPlay(1);
         }
      }
      
      private function onRefreshBtnClickHandle() : void
      {
         if(this._isRefreshEnable == true)
         {
            this._isRefreshEnable = false;
            this.broadcast(BCEvent.MESSAGE_REFRESH_ALL);
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_PROCEED);
            this._refreshEnableTimer.start();
            this.myRefreshBtn.enabled = false;
            this.myRefreshBtn.alpha = 0.5;
            this.switchInertState(true);
         }
      }
      
      private function onRefreshTimerHandle(cEvt:TimerEvent) : void
      {
         var repeatCount:int = (cEvt.currentTarget as Timer).currentCount;
         if(repeatCount >= REFRESH_INTERVAL)
         {
            this._isRefreshEnable = true;
            this._refreshEnableTimer.reset();
            this.myRefreshBtn.enabled = true;
            this.myRefreshBtn.alpha = 1;
            this.myRefreshBtn.label = Dict.REFRESH;
         }
         else
         {
            this.myRefreshBtn.label = LocalizeUtil.localize(Dict.REFRESH) + String(REFRESH_INTERVAL - repeatCount);
         }
      }
      
      private function allocMailItemList() : void
      {
         var item:FsgEmailItem = null;
         if(this.m_EmailList != null && this.m_EmailList.length > 0)
         {
            return;
         }
         this.m_EmailList = new Array();
         for(var i:int = 0; i < MAX_MAIL_ITEM_NUM; i++)
         {
            item = new fsgEmailItem();
            item.setBtnCallback(this.selectedEmailItem);
            item.setDeleteCallback(this.deleteEmailItem);
            item.setAcceptCallback(this.acceptEmail);
            item.setDeclineCallback(this.declineEmail);
            item.setMailOpened(false);
            this.m_EmailList.push(item);
            this.myScrollArea.addChild(item);
            item.visible = false;
         }
         this.m_mailClosedHeight = this.m_EmailList[0].getEmailHeight();
      }
      
      private function bind_mailDP(cRes:Object) : void
      {
         var mails:Array = cRes.data;
         mails = this.m_mail2MailDA.adaptArray(mails);
         this.bindDataPostWork(mails,[FsgMailType.MAIL_TENCENT_MAIL,FsgMailType.MAIL_TYPE_REWARD]);
      }
      
      private function bind_friendInvites(cRes:Object) : void
      {
         var friendInvitations:Array = cRes.data.dp;
         friendInvitations = this.m_friendInvites2MailDA.adaptArray(friendInvitations);
         this.bindDataPostWork(friendInvitations,[FsgMailType.MAIL_TYPE_FRIEND_INVITE]);
      }
      
      private function bind_clanInvites(cRes:Object) : void
      {
         var clanInvites:Array = cRes.data.dp;
         clanInvites = this.m_clanInvites2MailDA.adaptArray(clanInvites);
         this.bindDataPostWork(clanInvites,[FsgMailType.MAIL_TYPE_CLAN_INVITE]);
      }
      
      private function bind_roomInvites(cRes:Object) : void
      {
         var logAndRoomInvites:Array = cRes.data.dp;
         logAndRoomInvites = this.m_gameInvite2MailDA.adaptArray(logAndRoomInvites);
         this.bindDataPostWork(logAndRoomInvites,[FsgMailType.MAIL_TYPE_GAME_INVITE]);
      }
      
      private function bind_logInfo(cRes:Object) : void
      {
         var log:Array = cRes.data.dp;
         log = this.m_gameLog2MailDA.adaptArray(log);
         this.bindDataPostWork(log,[FsgMailType.MAIL_TYPE_SYSTEM]);
      }
      
      private function bindDataPostWork(data:Array, concernedType:Array) : void
      {
         this.switchInertState(false);
         if(data == null)
         {
            return;
         }
         var needRefresh:Boolean = this.filterMail(data,concernedType);
         if(needRefresh)
         {
            this.m_selectedEmail = -1;
            this.refresh();
         }
         else
         {
            this.refreshEmailItemReadStatus();
            this.updateClaimAllRewardButtonEnableStatus();
            this.updateReadAllButtonEnableStatus();
         }
         this.checkNewMail();
      }
      
      private function mailNotificationClosedHandler(cEvt:ParaEvent) : void
      {
         this.checkNewMail();
      }
      
      private function checkNewMail() : void
      {
         var wrappedMail:Object = null;
         var allMails:Array = this.getTargetList(FsgMailType.MAIL_TYPE_ALL);
         var mailCount:int = int(allMails.length);
         var latestTimeStamp:String = "";
         var selectedMailIndex:int = -1;
         var newMailCount:int = 0;
         var newMailShowing:Object = getDP(DataID.NEW_MAIL_SHOWING);
         var newMailShowingStillExist:Boolean = false;
         for(var i:int = 0; i < mailCount; i++)
         {
            if(!allMails[i].rawData.isAlerted)
            {
               if(allMails[i].timeStamp > latestTimeStamp)
               {
                  latestTimeStamp = allMails[i].timeStamp;
                  selectedMailIndex = i;
               }
               allMails[i].rawData.isAlerted = true;
               broadcast(BCEvent.MESSAGE_ALERTED,allMails[i].rawData.messageid);
            }
            if(!allMails[i].isRead)
            {
               newMailCount++;
            }
            if(Boolean(newMailShowing) && !newMailShowingStillExist)
            {
               if(newMailShowing.fsgMailType == FsgMailType.MAIL_TYPE_SYSTEM)
               {
                  if(newMailShowing == allMails[i])
                  {
                     newMailShowingStillExist = true;
                  }
               }
               else if(newMailShowing.mailObj.rawData.messageid == allMails[i].rawData.messageid)
               {
                  newMailShowingStillExist = true;
               }
            }
         }
         if(Boolean(newMailShowing) && !newMailShowingStillExist)
         {
            broadcast(BCEvent.EVT_FORCE_HIDE_MAIL_NOTIFICATION_VIEW);
         }
         setBindData(DataID.TOTAL_UNREAD_MAIL_COUNT,newMailCount);
         if(selectedMailIndex != -1)
         {
            wrappedMail = new Object();
            wrappedMail.mailObj = allMails[selectedMailIndex];
            wrappedMail.readHandler = this.realReadMail;
            wrappedMail.acceptHandler = this.realAcceptEmail;
            wrappedMail.rejectHandler = this.realDeclineEmail;
            wrappedMail.deleteHandler = this.realDeleteEmailItem;
            broadcast(BCEvent.SHOW_NEW_MAIL_NOTIFICATION,wrappedMail);
         }
      }
      
      private function getTargetList(type:int) : Array
      {
         for(var i:int = 0; i < this.m_DropList.length; i++)
         {
            if(this.m_DropList[i].sort == type)
            {
               return (this.m_DropList[i].data as MailDataWrapper).mails;
            }
         }
         return null;
      }
      
      private function filterMail(mails:Array, concernedType:Array) : Boolean
      {
         var key:String = null;
         var mailStackLength:int = 0;
         var currentMailStackUnreadCount:int = 0;
         var targetList:Array = null;
         var mail:Object = null;
         var type:int = 0;
         var mailStack:Array = (this.m_DropList[this.m_selectedCategoryIndex].data as MailDataWrapper).mails;
         var prevCount:int = int(mailStack.length);
         Logger.print("Start filter mails, type, before count: ",concernedType,prevCount,mails.length);
         var mailCount:int = int(mails.length);
         var listBuffer:Dictionary = new Dictionary();
         for(var i_type:int = 0; i_type < concernedType.length; i_type++)
         {
            targetList = this.getTargetList(concernedType[i_type]);
            targetList.splice(0);
         }
         for(var i:int = 0; i < mailCount; i++)
         {
            mail = mails[i];
            type = int(mail.fsgMailType);
            if(listBuffer.hasOwnProperty(String(type)) == false)
            {
               targetList = this.getTargetList(type);
               listBuffer[String(type)] = targetList;
            }
            else
            {
               targetList = listBuffer[String(type)];
            }
            targetList.push(mail);
         }
         for(key in listBuffer)
         {
            listBuffer[key].sortOn(["timeStamp","messageid"],[Array.DESCENDING,Array.DESCENDING]);
         }
         this.combineAndSortAllCategory();
         Logger.print("After filter mails, after count: ",mailStack.length);
         mailStackLength = int(mailStack.length);
         currentMailStackUnreadCount = 0;
         for(i = 0; i < mailStackLength; i++)
         {
            if(mailStack[i].isRead == false)
            {
               currentMailStackUnreadCount++;
            }
         }
         var needRefresh:Boolean = false;
         if((this.m_DropList[this.m_selectedCategoryIndex].data as MailDataWrapper).newMailCount < currentMailStackUnreadCount)
         {
            needRefresh = true;
         }
         this.updateConcernTypeNewMailCount(concernedType);
         return needRefresh || mailStackLength != prevCount;
      }
      
      private function updateConcernTypeNewMailCount(types:Array) : void
      {
         var dropDownLen:int = 0;
         var j:int = 0;
         var dataWrapper:MailDataWrapper = null;
         var mailCount:int = 0;
         var unreadMailCount:int = 0;
         var k:int = 0;
         var typesCount:int = int(types.length);
         for(var i:int = 0; i < typesCount; i++)
         {
            dropDownLen = int(this.m_DropList.length);
            for(j = 0; j < dropDownLen; j++)
            {
               if(types[i] == this.m_DropList[j].sort || this.m_DropList[j].sort == FsgMailType.MAIL_TYPE_ALL)
               {
                  dataWrapper = this.m_DropList[j].data as MailDataWrapper;
                  mailCount = int(dataWrapper.mails.length);
                  unreadMailCount = 0;
                  for(k = 0; k < mailCount; k++)
                  {
                     if(dataWrapper.mails[k].isRead == false)
                     {
                        unreadMailCount++;
                     }
                  }
                  dataWrapper.newMailCount = unreadMailCount;
               }
            }
         }
      }
      
      private function combineAndSortAllCategory() : void
      {
         var subList:Array = null;
         var j:int = 0;
         var allStack:Array = this.getTargetList(-1);
         allStack.splice(0);
         for(var i:int = 1; i < this.m_DropList.length; i++)
         {
            subList = (this.m_DropList[i].data as MailDataWrapper).mails;
            for(j = 0; j < subList.length; j++)
            {
               allStack.push(subList[j]);
            }
         }
         allStack.sortOn(["timeStamp","messageid"],[Array.DESCENDING,Array.DESCENDING]);
      }
      
      private function listScrollHandler() : void
      {
         if(Math.abs(this.myScrollBar.getPosition() - 1) < 0.01)
         {
            if(this.m_displayedMailDataNum < this.m_DataList.length)
            {
               this.expandScrollArea();
               this.m_scrollPaneBehaviour.updateScrollBar();
            }
         }
         this.refreshDisplayMailItem(false);
      }
      
      public function refresh() : void
      {
         if(this.m_DataList.length > 0)
         {
            this.myNoDataHint.visible = false;
         }
         else
         {
            this.myNoDataHint.visible = true;
            this.myNoDataHint.text = (this.m_DropList[this.m_selectedCategoryIndex].data as MailDataWrapper).noDataHint;
         }
         this.m_displayedMailDataNum = 0;
         this.expandScrollArea();
         this.refreshDisplayMailItem(true);
         this.myScrollBar.setPosition(0);
         this.m_scrollPaneBehaviour.refreshScrollBar();
         this.updateClaimAllRewardButtonEnableStatus();
         this.updateReadAllButtonEnableStatus();
      }
      
      private function refreshDisplayMailItem(forceRefresh:Boolean) : void
      {
         var posInScrollArea:Number = NaN;
         var totalMailNum:Number = NaN;
         var selectedMailRelativeNum:Number = NaN;
         var mailItemOrder:int = 0;
         var i:int = 0;
         var mailItem:FsgEmailItem = null;
         if(this.m_displayedMailDataNum <= MAX_MAIL_ITEM_NUM)
         {
            this.m_firstDisplayItemIndex = 0;
         }
         else
         {
            posInScrollArea = this.myScrollBar.getPosition() * (this.myScrollArea.height - this.myMask.height) / this.myScrollArea.height;
            totalMailNum = this.m_displayedMailDataNum;
            if(this.m_selectedEmail != -1)
            {
               selectedMailRelativeNum = this.m_mailSelectedHeight / this.m_mailClosedHeight;
               totalMailNum += selectedMailRelativeNum - 1;
               this.m_firstDisplayItemIndex = posInScrollArea * totalMailNum;
               if(this.m_firstDisplayItemIndex >= this.m_selectedEmail)
               {
                  if(this.m_firstDisplayItemIndex < this.m_selectedEmail + selectedMailRelativeNum)
                  {
                     this.m_firstDisplayItemIndex = this.m_selectedEmail;
                  }
                  else
                  {
                     this.m_firstDisplayItemIndex -= selectedMailRelativeNum - 1;
                  }
               }
            }
            else
            {
               this.m_firstDisplayItemIndex = posInScrollArea * totalMailNum;
            }
            this.m_firstDisplayItemIndex = FsgUtil.clamp(this.m_firstDisplayItemIndex,0,this.m_displayedMailDataNum - MAX_MAIL_ITEM_NUM);
         }
         if(forceRefresh || this.m_firstDisplayItemIndex != this.m_EmailList[0].m_OrderNum)
         {
            mailItemOrder = 0;
            for(i = 0; i < this.m_EmailList.length; i++)
            {
               mailItem = this.m_EmailList[i];
               mailItemOrder = this.m_firstDisplayItemIndex + i;
               if(mailItemOrder < this.m_DataList.length)
               {
                  mailItem.visible = true;
                  this.fillMailData(mailItem,mailItemOrder);
                  mailItem.y = this.getMailItemPosY(mailItemOrder);
               }
               else
               {
                  this.m_EmailList[i].visible = false;
               }
            }
         }
      }
      
      private function getMailItemByOrderID(mailItemOrderID:int) : FsgEmailItem
      {
         var index:int = mailItemOrderID - this.m_firstDisplayItemIndex;
         if(index < 0 || index >= MAX_MAIL_ITEM_NUM)
         {
            return null;
         }
         return this.m_EmailList[mailItemOrderID - this.m_firstDisplayItemIndex];
      }
      
      private function getMailItemPosY(orderID:int) : Number
      {
         var itemPosY:Number = orderID * (this.m_padding + this.m_mailClosedHeight);
         if(this.m_selectedEmail != -1 && orderID > this.m_selectedEmail)
         {
            itemPosY += this.m_mailSelectedHeight - this.m_mailClosedHeight;
         }
         return itemPosY;
      }
      
      private function fillMailData(mailItem:FsgEmailItem, order:int) : void
      {
         var replacedTimeStamp:String = null;
         var data:Object = this.m_DataList[order];
         mailItem.m_OrderNum = order;
         mailItem.emailHeader = data.senderName;
         mailItem.emailSubject = data.title;
         mailItem.emailMessage = data.message;
         mailItem.emailRead = data.isRead;
         mailItem.emailAttached = data.isAttached;
         if(data.timeStamp == "")
         {
            replacedTimeStamp = Dict.INVALID_TIME;
         }
         else
         {
            replacedTimeStamp = data.timeStamp;
         }
         mailItem.emailTimeStamp = replacedTimeStamp;
         mailItem.emailAcceptable = Boolean(data.isAttached) || Boolean(data.isInvites);
         mailItem.emailExpire = data.rawData.type == InvitationType.EXPIRE_MESSAGE;
         if(data.RoomDLCLevel != null)
         {
            Logger.print("FsgEmailPanel::refresh roomdlclevel" + data.RoomDLCLevel);
            mailItem.m_invitationDLCLevel = data.RoomDLCLevel;
         }
         if(Boolean(data.isAttached))
         {
            mailItem.setAttachment(data.mailAttachmentArray);
         }
         mailItem.setMailOpened(order == this.m_selectedEmail,false);
      }
      
      private function expandScrollArea() : void
      {
         var mailToDisplayedNum:int = this.m_DataList.length - this.m_displayedMailDataNum;
         this.m_displayedMailDataNum += Math.min(PER_PAGE_COUNT,mailToDisplayedNum);
         this.refrechScrollAreaHeight();
      }
      
      private function refrechScrollAreaHeight() : void
      {
         var scrollAreaHeight:Number = 0;
         if(this.m_displayedMailDataNum > 0)
         {
            scrollAreaHeight = this.m_displayedMailDataNum * (this.m_mailClosedHeight + this.m_padding) - this.m_padding;
            if(this.m_selectedEmail != -1)
            {
               scrollAreaHeight += this.m_mailSelectedHeight - this.m_mailClosedHeight;
            }
         }
         this.myScrollArea.scrollAreaHeight = scrollAreaHeight;
      }
      
      public function selectedEmailItem(i_index:int) : void
      {
         var mailObj:Object = null;
         var lastSelectedEmail:FsgEmailItem = null;
         if(ScaleformUtil.isScaleform)
         {
            this.m_selectedMailObj = this.m_DataList[i_index];
            mailObj = this.m_DataList[i_index];
            if(ScaleformUtil.isTempContentEnabled_3() == true)
            {
               this.realReadMail(mailObj);
            }
            else if(mailObj.fsgMailType == FsgMailType.MAIL_TENCENT_MAIL || mailObj.fsgMailType == FsgMailType.MAIL_TYPE_REWARD)
            {
               this.broadcast(BCEvent.EVT_ON_MAIL_SELECTED,mailObj);
            }
         }
         if(this.m_selectedEmail != -1)
         {
            lastSelectedEmail = this.getMailItemByOrderID(this.m_selectedEmail);
            if(lastSelectedEmail != null)
            {
               lastSelectedEmail.setMailOpened(false);
            }
         }
         this.m_selectedEmail = i_index;
         this.m_mailSelectedHeight = this.getMailItemByOrderID(this.m_selectedEmail).getEmailHeight();
         this.refrechScrollAreaHeight();
         this.resetEmailItem();
         this.m_scrollPaneBehaviour.refreshScrollBar();
      }
      
      private function realReadMail(mailObj:Object) : void
      {
         if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_SYSTEM)
         {
            mailObj.isRead = true;
            this.broadcast(BCEvent.EVT_ON_LOG_READ,mailObj.rawData);
         }
         else if(mailObj.rawData.isRead == false)
         {
            this.broadcast(BCEvent.EVT_ON_MAIL_READ,mailObj.rawData);
         }
      }
      
      public function resetEmailItem() : void
      {
         var item:MovieClip = null;
         var m_Height:Number = NaN;
         var ypos:Number = this.getMailItemPosY(this.m_EmailList[0].m_OrderNum);
         var mailCount:int = int(this.m_EmailList.length);
         for(var i:int = 0; i < mailCount; i++)
         {
            item = this.m_EmailList[i];
            m_Height = Number(item.getEmailHeight());
            if(item.y != ypos)
            {
               item.y = ypos;
            }
            ypos += m_Height + this.m_padding;
         }
      }
      
      private function refreshEmailItemReadStatus() : void
      {
         var item:FsgEmailItem = null;
         var isEmailRead:Boolean = false;
         var mailCount:int = int(this.m_EmailList.length);
         for(var i:int = 0; i < mailCount; i++)
         {
            item = this.m_EmailList[i];
            if(item.visible)
            {
               isEmailRead = Boolean(this.m_DataList[item.m_OrderNum].isRead);
               if(item.emailRead != isEmailRead)
               {
                  item.emailRead = isEmailRead;
               }
            }
         }
      }
      
      private function updateReadAllButtonEnableStatus() : void
      {
         var mailData:MailDataWrapper = this.m_DropList[this.m_selectedCategoryIndex].data as MailDataWrapper;
         this.myReadAllBtn.enabled = mailData.newMailCount != 0;
         this.myReadAllBtn.alpha = this.myReadAllBtn.enabled ? 1 : 0.5;
      }
      
      private function updateClaimAllRewardButtonEnableStatus() : void
      {
         var mailObj:Object = null;
         var hasAttachment:Boolean = false;
         var mailData:MailDataWrapper = this.m_DropList[this.m_selectedCategoryIndex].data as MailDataWrapper;
         var mailDataLength:int = int(mailData.mails.length);
         for(var i:int = 0; i < mailDataLength; i++)
         {
            mailObj = mailData.mails[i];
            if(Boolean(mailObj.isAttached))
            {
               hasAttachment = true;
               break;
            }
         }
         this.myClaimAllRewardsBtn.enabled = hasAttachment;
         this.myClaimAllRewardsBtn.alpha = this.myClaimAllRewardsBtn.enabled ? 1 : 0.5;
      }
      
      public function sortList(i_index:int) : void
      {
         if(this.m_selectedCategoryIndex != i_index)
         {
            this.m_selectedCategoryIndex = i_index;
            this.m_DataList = (this.m_DropList[i_index].data as MailDataWrapper).mails;
            this.m_selectedType = this.m_DropList[i_index].sort;
            this.m_selectedEmail = -1;
            this.refresh();
         }
      }
      
      public function onCloseButtonClickHandler() : void
      {
         broadcast(BCEvent.EVT_CLOSE_MAIL);
      }
      
      private function acceptEmail(i_index:int) : void
      {
         var mailObj:Object = this.m_DataList[i_index];
         if(Boolean(mailObj))
         {
            this.realAcceptEmail(mailObj);
         }
      }
      
      private function realAcceptEmail(mailObj:Object) : void
      {
         var acceptInvitation:Function = null;
         var acceptHighLatency:Boolean = false;
         acceptInvitation = function():void
         {
            if(acceptHighLatency)
            {
               broadcast(BCEvent.BOOK_HIGH_LATENCY_TICKET,mailObj.rawData.targetID);
            }
            broadcast(BCEvent.EVT_ACCEPT_INVITATION,mailObj.rawData);
         };
         if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_REWARD)
         {
            this.broadcast(BCEvent.EVT_CLAIM_COUPONARRAY,[mailObj.rawData]);
         }
         else if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_FRIEND_INVITE || mailObj.fsgMailType == FsgMailType.MAIL_TYPE_CLAN_INVITE)
         {
            this.broadcast(BCEvent.EVT_ACCEPT_INVITATION,mailObj.rawData);
         }
         else if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_GAME_INVITE)
         {
            if(mailObj.rawData.gameType != "playlist" && getDP(DataID.DLC_GET_LEVEL) > mailObj.rawData.RoomDLClevel)
            {
               showMsg(DictRoom.ONENTER_LOWERDLC_ROOM,MsgBtnCount.TWO,0,acceptInvitation);
               return;
            }
            broadcast(BCEvent.BOOK_HIGH_LATENCY_TICKET,"0");
            acceptHighLatency = false;
            if(Boolean(getDP(DataID.IS_IN_CROSSZONE)) && (mailObj.rawData.joinableZones & getDP(DataID.JOINABLE_ZONES)) == 0)
            {
               acceptHighLatency = true;
               showMsg(DictRoom.ROOM_ACCEPT_INVITATION_CROSS_ZONE_WARNING,MsgBtnCount.TWO,0,acceptInvitation);
               return;
            }
            acceptInvitation();
         }
         else if(mailObj.rawData.type == InvitationType.EXPIRE_MESSAGE)
         {
            broadcast(BCEvent.EVT_REJECT_INVITATION,mailObj.rawData);
            broadcast(BCEvent.EVT_SHOW_EXPIRE_POPUP,mailObj.rawData.renewableItems);
         }
      }
      
      private function declineEmail(i_index:int) : void
      {
         var mailObj:Object = this.m_DataList[i_index];
         if(Boolean(mailObj))
         {
            this.realDeclineEmail(mailObj);
         }
      }
      
      private function realDeclineEmail(mailObj:Object) : void
      {
         if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_REWARD)
         {
            this.broadcast(BCEvent.EVT_DELETE_MAIL,{
               "mails":[mailObj.rawData],
               "show":true
            });
         }
         else if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_FRIEND_INVITE || mailObj.fsgMailType == FsgMailType.MAIL_TYPE_CLAN_INVITE || mailObj.fsgMailType == FsgMailType.MAIL_TYPE_GAME_INVITE)
         {
            this.broadcast(BCEvent.EVT_REJECT_INVITATION,mailObj.rawData);
         }
      }
      
      public function deleteEmailItem(i_index:int) : void
      {
         var mailObj:Object = this.m_DataList[i_index];
         if(Boolean(mailObj))
         {
            this.realDeleteEmailItem(mailObj);
         }
      }
      
      private function realDeleteEmailItem(mailObj:Object) : void
      {
         var doDelete:Function = null;
         doDelete = function():void
         {
            broadcast(BCEvent.EVT_REJECT_INVITATION,mailObj.rawData);
         };
         switch(mailObj.fsgMailType)
         {
            case FsgMailType.MAIL_TENCENT_MAIL:
               this.broadcast(BCEvent.EVT_DELETE_MAIL,{
                  "mails":[mailObj.rawData],
                  "show":true
               });
               break;
            case FsgMailType.MAIL_TYPE_REWARD:
               this.broadcast(BCEvent.EVT_DELETE_MAIL,{
                  "mails":[mailObj.rawData],
                  "show":true
               });
               break;
            case FsgMailType.MAIL_TYPE_SYSTEM:
               this.broadcast(BCEvent.EVT_REJECT_INVITATION,mailObj.rawData);
               break;
            case FsgMailType.MAIL_TYPE_FRIEND_INVITE:
            case FsgMailType.MAIL_TYPE_CLAN_INVITE:
            case FsgMailType.MAIL_TYPE_GAME_INVITE:
               this.showMsg(DictMail.CONFIRM_DELETE_INVITATION,MsgBtnCount.TWO,0,doDelete,DictSystem.CONFIRM,null,DictSystem.CANCEL);
         }
      }
      
      private function onReadAllButtonClickHandler() : void
      {
         var mailObj:Object = null;
         var unReadMailList:Array = [];
         var unReadLogList:Array = [];
         var mailData:MailDataWrapper = this.m_DropList[this.m_selectedCategoryIndex].data as MailDataWrapper;
         var mailDataLength:int = int(mailData.mails.length);
         for(var i:int = 0; i < mailDataLength; i++)
         {
            mailObj = mailData.mails[i];
            if(mailObj.fsgMailType == FsgMailType.MAIL_TYPE_SYSTEM)
            {
               if(!mailObj.isRead)
               {
                  mailObj.isRead = true;
                  unReadLogList.push(mailObj.rawData);
               }
            }
            else if(mailObj.rawData.isRead == false)
            {
               unReadMailList.push(mailObj.rawData);
            }
         }
         if(unReadMailList.length > 0)
         {
            broadcast(BCEvent.EVT_ON_MAIL_READ_BATCH,unReadMailList);
         }
         if(unReadLogList.length > 0)
         {
            broadcast(BCEvent.EVT_ON_LOG_READ_BATCH,unReadLogList);
         }
      }
      
      private function onClaimAllRewardButtonClientHandler() : void
      {
         this.broadcast(BCEvent.EVT_MAIL_RECEIVEALLATTACHMENT);
      }
   }
}

class MailDataWrapper
{
   
   public var mails:Array = [];
   
   public var newMailCount:int;
   
   public var noDataHint:String;
   
   public function MailDataWrapper(hint:String)
   {
      super();
      this.noDataHint = hint;
   }
}
