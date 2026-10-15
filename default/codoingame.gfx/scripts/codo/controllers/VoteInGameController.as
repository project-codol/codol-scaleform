package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataInGameID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.constants.ViewState;
   import codo.constants.VoteType;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.manager.PageInGameManager;
   import codo.objects.SystemMsgObj;
   import codo.objects.UserObj;
   import components.fsggamelobby_part.FsgGameLobbyConsts;
   
   public class VoteInGameController extends BaseController
   {
      
      private static const STATE_IDLE:uint = 0;
      
      private static const STATE_WARNING_MSG:uint = 1;
      
      private static const STATE_VOTE_WINDOW:uint = 2;
      
      private var mState:uint;
      
      private var mPreSelectedPlayer:Object;
      
      private var mPlayerList:Array;
      
      protected var mActiveMessage:SystemMsgObj;
      
      public function VoteInGameController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.reset();
         listen(BCEvent.EVT_VOTE_ACTIVE_PLAYER,this.onVoteActivePlayerHandle);
         listen(BCEvent.EVT_VOTE_CANCEL,this.onVoteCancel);
         listen(BCEvent.EVT_VOTE_CONFIRM,this.onVoteConfirm);
         addDP(DataInGameID.GET_CURRENT_VOTE_TYPE,this.getCurrentVoteType);
      }
      
      protected function reset() : void
      {
         unlisten(BCEvent.GOTO_PREV_PAGE,this.reset);
         this.mState = STATE_IDLE;
         this.mPreSelectedPlayer = null;
         this.mPlayerList = null;
         this.mActiveMessage = null;
      }
      
      private function onVoteActivePlayerHandle(cEvt:ParaEvent) : void
      {
         this.fileVote(cEvt.myPara,CFunctionCommonContainer.GetMemberInfoList());
      }
      
      private function fileVote(target:Object, playerList:Array) : void
      {
         if(this.mState != STATE_IDLE)
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
         var voteTypeInfo:Object = CFunctionInGameContainer.AS_GetVoteTypeInfo(this.getCurrentVoteType());
         if(!voteTypeInfo.warning)
         {
            return;
         }
         this.mActiveMessage = showMsg("@" + voteTypeInfo.warning,MsgBtnCount.TWO,SystemMsgPriority.WARNING,this.onWarningConfirm,DictSystem.CONFIRM,this.onWarningCancel,DictSystem.CANCEL);
      }
      
      private function onWarningConfirm() : void
      {
         if(this.mState != STATE_WARNING_MSG)
         {
            return;
         }
         this.mState = STATE_VOTE_WINDOW;
         hideSpecificMsg(this.mActiveMessage);
         this.showVoteWindow({
            "preSelection":this.mPreSelectedPlayer,
            "userList":this.mPlayerList,
            "mode":"vote"
         });
         listen(BCEvent.GOTO_PREV_PAGE,this.reset);
         this.mPreSelectedPlayer = null;
         this.mPlayerList = null;
      }
      
      private function onWarningCancel() : void
      {
         hideSpecificMsg(this.mActiveMessage);
         this.reset();
      }
      
      private function showVoteWindow(data:Object) : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_POPUP_COMPLAINT_WINDOW,false,ViewState.ACTIVATED,data);
         broadcast(BCInGameEvent.SHOW_NOTIFICATION_POPUP);
      }
      
      private function hideVoteWindow() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_POPUP_COMPLAINT_WINDOW.owner);
         broadcast(BCInGameEvent.HIDE_NOTIFICATION_POPUP);
      }
      
      private function onVoteCancel(cEvt:ParaEvent) : void
      {
         this.reset();
         this.hideVoteWindow();
      }
      
      private function onVoteConfirm(cEvt:ParaEvent) : void
      {
         var targetUser:UserObj = cEvt.myPara.user;
         var options:uint = uint(cEvt.myPara.options);
         var msg:String = cEvt.myPara.message;
         msg = "+" + msg;
         if(this.mState != STATE_VOTE_WINDOW || targetUser == null || targetUser.name.length == 0 || targetUser.name == "")
         {
            return;
         }
         unlisten(BCEvent.GOTO_PREV_PAGE,this.reset);
         CFunctionInGameContainer.AS_SendVoteRequestToDS(targetUser.id,options,msg);
         this.hideVoteWindow();
         this.reset();
      }
      
      private function getCurrentVoteType() : int
      {
         if(Boolean(getDP(DataInGameID.IS_SPY)))
         {
            return VoteType.KICK;
         }
         if(Boolean(getDP(DataInGameID.IS_ZHUNT)))
         {
            return VoteType.KILL;
         }
         return VoteType.KICK;
      }
      
      public function cppVote(input:String) : void
      {
         broadcast(BCInGameEvent.EVT_PLAYER_VOTE,input);
      }
   }
}

