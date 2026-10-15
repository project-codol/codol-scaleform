package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.objects.SystemMsgObj;
   import codo.objects.UserObj;
   import components.fsggamelobby_part.FsgGameLobbyConsts;
   
   public class ComplaintController extends BaseController
   {
      
      private static const STATE_IDLE:uint = 0;
      
      private static const STATE_WARNING_MSG:uint = 1;
      
      private static const STATE_COMPLAINT_WINDOW:uint = 2;
      
      private var mState:uint;
      
      private var mPreSelectedPlayer:Object;
      
      private var mPlayerList:Array;
      
      protected var mActiveMessage:SystemMsgObj;
      
      public function ComplaintController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.reset();
         addDP(DataID.GET_ACTIVE_PLAYER_LIST,CFunctionCommonContainer.GetMemberInfoList);
         listen(BCEvent.EVT_REPORT_ACTIVE_PLAYER,this.onReportActivePlayerHandle);
         listen(BCEvent.EVT_REPORT_PLAYER,this.onReportPlayerHandle);
         listen(BCEvent.EVT_COMPLAINT_CANCEL,this.onComplaintCancel);
         listen(BCEvent.EVT_COMPLAINT_CONFIRM,this.onComplaintConfirm);
         listen(BCEvent.EVT_SEND_BAD_LANGUAGE_TLOG,this.onSendBadLanguage);
      }
      
      protected function reset() : void
      {
         unlisten(BCEvent.GOTO_PREV_PAGE,this.reset);
         this.mState = STATE_IDLE;
         this.mPreSelectedPlayer = null;
         this.mPlayerList = null;
         this.mActiveMessage = null;
      }
      
      private function fileComplaint(target:Object, playerList:Array) : void
      {
         if(this.mState != STATE_IDLE || playerList == null || playerList.length == 0)
         {
            return;
         }
         this.mPreSelectedPlayer = target;
         this.mPlayerList = playerList;
         for(var i:int = this.mPlayerList.length - 1; i >= 0; i--)
         {
            if(this.mPlayerList[i].team == FsgGameLobbyConsts.TEAM_SPECTATOR || Boolean(this.mPlayerList[i].isMe))
            {
               this.mPlayerList.splice(i,1);
            }
         }
         this.mState = STATE_WARNING_MSG;
         this.mActiveMessage = showMsg(Dict.COMPLAINT_WARNING,MsgBtnCount.TWO,SystemMsgPriority.WARNING,this.onWarningConfirm,DictSystem.CONFIRM,this.onWarningCancel,DictSystem.CANCEL);
      }
      
      protected function showComplaintWindow(data:Object) : void
      {
      }
      
      protected function hideComplaintWindow() : void
      {
      }
      
      protected function showSubmittedComplaintMsg() : void
      {
         showMsg(Dict.COMPLAINT_SUBMITTED_DESC,MsgBtnCount.ONE,SystemMsgPriority.NORMAL,null,DictSystem.CONFIRM,null,"",null,"",0,false,Dict.COMPLAINT_SUBMITTED_TITLE);
      }
      
      private function onReportPlayerHandle(cEvt:ParaEvent) : void
      {
         var target:Object = cEvt.myPara.target;
         var filterFunc:Function = function(user:Object, index:int, arr:Array):Boolean
         {
            return !user.isMe;
         };
         var playerList:Array = cEvt.myPara.playerList.filter(filterFunc,this);
         this.fileComplaint(target,playerList);
      }
      
      private function onReportActivePlayerHandle(cEvt:ParaEvent) : void
      {
         this.fileComplaint(cEvt.myPara,CFunctionCommonContainer.GetMemberInfoList());
      }
      
      private function onWarningCancel() : void
      {
         hideSpecificMsg(this.mActiveMessage);
         this.reset();
      }
      
      private function onComplaintCancel(cEvt:ParaEvent) : void
      {
         this.reset();
         this.hideComplaintWindow();
      }
      
      private function onWarningConfirm() : void
      {
         if(this.mState != STATE_WARNING_MSG)
         {
            return;
         }
         this.mState = STATE_COMPLAINT_WINDOW;
         hideSpecificMsg(this.mActiveMessage);
         this.showComplaintWindow({
            "preSelection":this.mPreSelectedPlayer,
            "userList":this.mPlayerList,
            "mode":"complaint"
         });
         listen(BCEvent.GOTO_PREV_PAGE,this.reset);
         this.mPreSelectedPlayer = null;
         this.mPlayerList = null;
      }
      
      private function onComplaintConfirm(cEvt:ParaEvent) : void
      {
         var targetUser:UserObj = cEvt.myPara.user;
         var options:uint = uint(cEvt.myPara.options);
         var msg:String = cEvt.myPara.message;
         if(this.mState != STATE_COMPLAINT_WINDOW || targetUser == null || targetUser.name.length == 0 || targetUser.name == "")
         {
            return;
         }
         unlisten(BCEvent.GOTO_PREV_PAGE,this.reset);
         CFunctionCommonContainer.TencentReportPlayer(targetUser.id,options,msg);
         this.hideComplaintWindow();
         this.showSubmittedComplaintMsg();
         this.reset();
      }
      
      private function onSendBadLanguage(cEvt:ParaEvent) : void
      {
         var para:Object = cEvt.myPara;
         CFunctionCommonContainer.TencentReportBadLanguage(para.id,para.name,para.message,para.history);
      }
   }
}

