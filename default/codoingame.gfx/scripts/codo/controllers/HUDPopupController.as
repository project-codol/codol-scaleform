package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.CodoInGamePageDB;
   import codo.manager.PageInGameManager;
   
   public class HUDPopupController extends BaseController
   {
      
      public function HUDPopupController()
      {
         super();
      }
      
      public function cppOpenZHuntShoppingMenu() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_ZHUNT_SHOPPING_POPUP);
      }
      
      public function cppCloseZHuntShoppingMenu() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_ZHUNT_SHOPPING_POPUP.owner);
      }
      
      public function cppOpenZHuntBossResultMenu() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_ZHUNT_BOSS_RESULT_POPUP);
      }
      
      public function cppCloseZHuntBossResultMenu() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_ZHUNT_BOSS_RESULT_POPUP.owner);
      }
      
      public function cppOpenFullScreenBinkPlayerMenu() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_FULL_SCREEN_BINK_PLAYER_POPUP);
      }
      
      public function cppCloseFullScreenBinkPlayerMenu() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_FULL_SCREEN_BINK_PLAYER_POPUP.owner);
      }
      
      public function cppOpenSplashMenu(menuName:String) : void
      {
         this.cppCloseSplashMenu();
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_SPLASH_POPUP);
      }
      
      public function cppCloseSplashMenu() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_SPLASH);
      }
      
      public function cppOpenTopSplashMenu(menuName:String) : void
      {
         this.cppCloseSplashMenu();
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TOP_SPLASH_POPUP);
      }
      
      public function cppCloseTopSplashMenu() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_TOP_SPLASH);
      }
      
      public function cppOpenSpyWantedPopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_SPY_WANTED_POPUP);
      }
      
      public function cppCloseWantedPopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_SPY_WANTED_POPUP.owner);
      }
      
      public function cppShowVIPVoteInfoPopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_VIP_VOTE_INFO_POPUP);
      }
      
      public function cppHideVIPVoteInfoPopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_HUD_POPUP);
      }
      
      public function cppShowVIPSelectCharacterPopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_VIP_SELECT_CHARACTER_POPUP);
      }
      
      public function cppHideVIPSelectCharacterPopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_HUD_POPUP);
      }
      
      public function cppShowTdLoadoutPopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TD_LOADOUT);
      }
      
      public function cppHideTdLoadoutPopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_LOADOUT);
      }
      
      public function cppShowTdInventoryPopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TD_INVENTORY);
      }
      
      public function cppHideTdInventoryPopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_LOADOUT);
      }
      
      public function cppShowTdTurretManagePopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TD_TURRET_MANAGE);
      }
      
      public function cppHideTdTurretManagePopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_LOADOUT);
      }
      
      public function cppShowTdTurretUpgradePopup() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TD_TURRET_UPGRADE);
      }
      
      public function cppHideTdTurretUpgradePopup() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_LOADOUT);
      }
   }
}

