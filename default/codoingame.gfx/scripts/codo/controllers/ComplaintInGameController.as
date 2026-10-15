package codo.controllers
{
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.manager.PageInGameManager;
   import codo.objects.SystemMsgObj;
   
   public class ComplaintInGameController extends ComplaintController
   {
      
      private var mConfirmMessage:SystemMsgObj;
      
      public function ComplaintInGameController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         listen(BCInGameEvent.BACK_TO_GAME,this.onBackToGame);
         listen(BCInGameEvent.COMPLAINT_FORCED_EXIT,this.onForcedExit);
         addDP(DataID.IS_MAINMENU_COMPLAINT_CONTROLLER,this.isMainMenuComplaintController);
      }
      
      override protected function showComplaintWindow(data:Object) : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_POPUP_COMPLAINT_WINDOW,false,ViewState.ACTIVATED,data);
         broadcast(BCInGameEvent.SHOW_NOTIFICATION_POPUP);
      }
      
      override protected function hideComplaintWindow() : void
      {
         if(PageInGameManager.getInstance().currentFocusedPage != CodoInGamePageDB.PAGE_POPUP_COMPLAINT_WINDOW)
         {
            return;
         }
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_POPUP_COMPLAINT_WINDOW.owner);
         broadcast(BCInGameEvent.HIDE_NOTIFICATION_POPUP);
      }
      
      override protected function showSubmittedComplaintMsg() : void
      {
         this.mConfirmMessage = showMsg(Dict.COMPLAINT_SUBMITTED_DESC,MsgBtnCount.ONE,SystemMsgPriority.NORMAL,this.onMsgConfirm,DictSystem.CONFIRM,null,"",null,"",0,false,Dict.COMPLAINT_SUBMITTED_TITLE);
      }
      
      private function onMsgConfirm() : void
      {
         hideSpecificMsg(this.mConfirmMessage);
         this.mConfirmMessage = null;
      }
      
      private function onBackToGame(cEvt:ParaEvent) : void
      {
         hideSpecificMsg(mActiveMessage);
         hideSpecificMsg(this.mConfirmMessage);
         this.hideComplaintWindow();
         this.mConfirmMessage = null;
         reset();
      }
      
      private function onForcedExit(cEvt:ParaEvent) : void
      {
         hideSpecificMsg(mActiveMessage);
         hideSpecificMsg(this.mConfirmMessage);
         this.hideComplaintWindow();
         this.mConfirmMessage = null;
         reset();
      }
      
      private function isMainMenuComplaintController() : Boolean
      {
         return false;
      }
   }
}

