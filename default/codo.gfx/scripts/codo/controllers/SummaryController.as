package codo.controllers
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.utils.Logger;
   import com.society.comscore.DAXDispatcher;
   
   public class SummaryController extends SummaryBaseController
   {
      
      public function SummaryController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.listen(BCCommonEvent.EVT_CLOSE_SUMMARY,this.onCloseSummaryHandle);
         this.listen(BCCommonEvent.EVT_QUIT_GAME,this.onQuitGameHandle);
         this.listen(BCEvent.GOTO_FIRST_PAGE,this.onInitHandle);
         this.listen(BCEvent.LOBBY_OPEN_PRESTIGE_UNLOCK,this.openPrestigeUnlockPopup);
         this.listen(BCEvent.LOBBY_CLOSE_SUMMARY,this.onCloseLobbySummary);
         this.addDP(DataID.IS_NOTIFICATION_UNLOCKED_WEAPON_CUSTOMIZATION,this.isWeaponCustomizationUnlocked);
      }
      
      public function onInitHandle(cEvt:ParaEvent) : void
      {
      }
      
      public function openPrestigeUnlockPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_FSG_PRESTIGE_UNLOCKED);
      }
      
      public function onCloseLobbySummary(cEvt:ParaEvent) : void
      {
         var clientConnectionTime:int = 0;
         try
         {
            Logger.print("*** DAXDispatcher:Stay in game, retention");
            clientConnectionTime = CFunctionCommonContainer.GetDWConnectionTime();
            DAXDispatcher.queue("action_type","return_offer");
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
         this.prevPage();
      }
      
      public function onQuitGameHandle(cEvt:ParaEvent) : void
      {
         var clientConnectionTime:int = 0;
         this.broadcast(BCEvent.EVT_CLOSING_GAME);
         try
         {
            Logger.print("*** DAXDispatcher: Exit Game");
            clientConnectionTime = CFunctionCommonContainer.GetDWConnectionTime();
            DAXDispatcher.queue("duration_total",String(clientConnectionTime));
            DAXDispatcher.queue("action_type","game_exit");
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
         this.gotoPage(CodoPageViewDB.PAGE_QUIT);
      }
      
      public function onCloseSummaryHandle(cEvt:ParaEvent) : void
      {
         this.prevPage();
      }
      
      private function isWeaponCustomizationUnlocked() : Boolean
      {
         return CFunctionCommonContainer.AS_IsNotificationUnlocked("un_weapon_customization") as Boolean;
      }
   }
}

