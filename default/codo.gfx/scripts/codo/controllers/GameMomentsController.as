package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.VideoObj;
   
   public class GameMomentsController extends BaseController
   {
      
      private var gamemoments_status:int = 0;
      
      public function GameMomentsController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCCommonEvent.EVT_GAMEMOMENTS_EDIT,this.onEditGameMomentsVideo);
         this.listen(BCEvent.EVT_GAMEMOMENTS_TOGGLE,this.onToggleGameMoments);
         this.addDP(DataID.IS_GAMEMOMENTS_DISABLED,this.isGameMomentsDisabled);
         CFunctionCommonContainer.GameMomentsPreInit();
      }
      
      private function isGameMomentsDisabled() : Boolean
      {
         this.gamemoments_status = CFunctionCommonContainer.GetGameMomentsStatus();
         return this.gamemoments_status <= Common.GAMEMOMENTS_FAILED_STATUS;
      }
      
      private function onToggleGameMoments(cEvt:ParaEvent) : void
      {
         CFunctionInGameContainer.ToggleRecordVideo();
      }
      
      private function onEditGameMomentsVideo(cEvt:ParaEvent) : void
      {
         var displayMode:int = CFunctionCommonContainer.Dvar_GetInt("r_displayMode");
         if(displayMode == VideoObj.DISPLAY_MODE_FULLSCREEN)
         {
            this.showMsg(Dict.EDIT_GAMEMOMENTS_VIDEO,MsgBtnCount.TWO,SystemMsgPriority.NORMAL,this.onQuitEditConfirm,Dict.GAMEMOMENTS_QUIT_EDIT);
         }
         else
         {
            this.showMsg(Dict.EDIT_GAMEMOMENTS_VIDEO,MsgBtnCount.THREE,SystemMsgPriority.NORMAL,this.onQuitEditConfirm,Dict.GAMEMOMENTS_QUIT_EDIT,this.onEditConfirm,Dict.GAMEMOMENTS_EDIT);
         }
         CFunctionCommonContainer.GameMomentsClearRecordedVideo();
      }
      
      private function onQuitEditConfirm() : void
      {
         CFunctionCommonContainer.GameMomentsEditRecordedVideo(true);
      }
      
      private function onEditConfirm() : void
      {
         CFunctionCommonContainer.GameMomentsEditRecordedVideo(false);
      }
      
      public function cppOnGameMomentsStatusChanged() : void
      {
         this.gamemoments_status = CFunctionCommonContainer.GetGameMomentsStatus();
         if(this.gamemoments_status == Common.GAMEMOMENTS_QUIT_CLIENT)
         {
            this.broadcast(BCCommonEvent.EVT_QUIT_GAME);
         }
         else
         {
            this.broadcast(BCEvent.EVT_GAMEMOMENTS_STATUS_CHANGED,this.gamemoments_status);
         }
      }
   }
}

