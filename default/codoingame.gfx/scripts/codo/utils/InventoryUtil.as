package codo.utils
{
   import codo.constants.BCEvent;
   import codo.constants.table.UINotifications;
   import codo.manager.EventManager;
   import codo.services.TutorialService;
   
   public class InventoryUtil
   {
      
      public static var changeLoadoutTab:Function;
      
      public static const HOME_TAB:int = 0;
      
      public static const GEAR_TAB:int = 1;
      
      public static const SCORESTREAKS_TAB:int = 2;
      
      public static const REQUISITION_TAB:int = 3;
      
      public static const PLAYERCARD_TAB:int = 4;
      
      public static const CRAFTING_TAB:int = 5;
      
      public static const STORAGE_TAB:int = 6;
      
      public static const NUM_TABS:int = 7;
      
      private static var _currentTab:int = HOME_TAB;
      
      public function InventoryUtil()
      {
         super();
      }
      
      public static function getCurrentTab() : int
      {
         return _currentTab;
      }
      
      public static function setCurrentTab(tab:int) : void
      {
         if(tab == InventoryUtil.CRAFTING_TAB)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_ZHCRAFTING);
            return;
         }
         var old:int = _currentTab;
         if(old == tab)
         {
            return;
         }
         _currentTab = tab;
         var tutServ:TutorialService = TutorialService.getInstance();
         tutServ.enableToolTip(UINotifications.ONBOARD_HELP_LOADOUT_WEAPON,tab == InventoryUtil.HOME_TAB);
         tutServ.enableToolTip(UINotifications.ONBOARD_HELP_LOADOUT_ATTACHMENT,tab == InventoryUtil.HOME_TAB);
         tutServ.enableToolTip(UINotifications.ONBOARD_HELP_LOADOUT_ATTACHMENT_2,tab == InventoryUtil.HOME_TAB);
         tutServ.enableToolTip(UINotifications.ONBOARD_HELP_EDIT_LOADOUT,tab == InventoryUtil.HOME_TAB);
         tutServ.enableToolTip(UINotifications.ONBOARD_HELP_EDIT_PERKS,tab == InventoryUtil.HOME_TAB);
         tutServ.enableToolTip(UINotifications.ONBOARD_HELP_WILDCARDS,tab == InventoryUtil.HOME_TAB);
         EventManager.getInstance().broadcast(BCEvent.EVT_REFRESH_HELP_TIP);
         if(changeLoadoutTab != null)
         {
            changeLoadoutTab(old,tab);
         }
      }
   }
}

