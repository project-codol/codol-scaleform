package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.factory.ButtonFactory;
   import codo.component.matchselect.MatchSelectCustomizeRoom;
   import codo.component.matchselect.MatchSelectPVEPanel2;
   import codo.component.matchselect.MatchSelectPVPPanel2;
   import codo.component.matchselect.MatchSelectTheatrePanel;
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.QuickMatchType;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppOnboarding;
   import codo.cpp.UiCppView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.PlayListObj;
   import codo.views.uitour.UITutorialMatchSelectView;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class MatchSelectView extends BaseView
   {
      
      public var mySecondaryNavMenu:NavigationMenu;
      
      public var myPVPPanel:MatchSelectPVPPanel2;
      
      public var myPVEPanel:MatchSelectPVEPanel2;
      
      public var myBattleCityPanel:BattleCityPanel;
      
      public var myTheatrePanel:MatchSelectTheatrePanel;
      
      public var myWarGodPanel:WarGodPanel;
      
      public var myRoomPanel:MatchSelectCustomizeRoom;
      
      public var myUITutorial:UITutorialMatchSelectView;
      
      public function MatchSelectView()
      {
         this.initBattleCityPanel();
         this.initWarGodPanel();
         super();
         this.initStage();
         this.initDedicateTutorialLayer();
      }
      
      public static function GetDefaultMatchType() : QuickMatchType
      {
         return QuickMatchType.makeDefault();
      }
      
      public static function GetDefaultPveType() : QuickMatchType
      {
         return QuickMatchType.makeSurvival();
      }
      
      private function initBattleCityPanel() : void
      {
         var battleCityClass:Class = getDefinitionByName("codo.battlecity.battleCityPanel") as Class;
         this.myBattleCityPanel = new battleCityClass();
         addChild(this.myBattleCityPanel);
      }
      
      private function initWarGodPanel() : void
      {
         var warGodClass:Class = getDefinitionByName("codo.wargod.wargodPanel") as Class;
         this.myWarGodPanel = new warGodClass();
         addChild(this.myWarGodPanel);
      }
      
      private function initStage() : void
      {
         var secondaryButtons:Vector.<NavigationObj> = null;
         secondaryButtons = new <NavigationObj>[new NavigationObj(UiCppMatchSelectView.ROOT_IDX_PVP,Dict.MATCH_SELECT_MENU_OPTION_PVP),new NavigationObj(UiCppMatchSelectView.ROOT_IDX_PVE,Dict.MATCH_SELECT_MENU_OPTION_PVE),new NavigationObj(UiCppMatchSelectView.ROOT_IDX_BATTLECITY,Dict.MATCH_SELECT_MENU_OPTION_BATTLECITY),new NavigationObj(UiCppMatchSelectView.ROOT_IDX_WARGOD,Dict.MATCH_SELECT_MENU_OPTION_WARGOD),new NavigationObj(UiCppMatchSelectView.ROOT_IDX_ROOMS,Dict.MATCH_SELECT_MENU_OPTION_ROOMS),new NavigationObj(UiCppMatchSelectView.ROOT_IDX_TRAINING,"@MPUI_TRAIN")];
         secondaryButtons[UiCppMatchSelectView.ROOT_IDX_ROOMS].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_ROOMS);
         if(CFunctionCommonContainer.TheaterEnabled())
         {
            secondaryButtons.push(new NavigationObj(UiCppMatchSelectView.ROOT_IDX_THEATRE,Dict.MATCH_SELECT_MENU_OPTION_THEATER));
            secondaryButtons[UiCppMatchSelectView.ROOT_IDX_THEATRE].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_THEATER);
         }
         this.mySecondaryNavMenu.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
         this.mySecondaryNavMenu.setData(secondaryButtons);
         this.myPVPPanel.setView(this);
         this.myPVEPanel.setView(this);
         this.myBattleCityPanel.setView(this);
         this.myWarGodPanel.setView(this);
         this.myTheatrePanel.setView(this);
         this.myRoomPanel.setView(this);
      }
      
      private function initDedicateTutorialLayer() : void
      {
         var localPoint:Point = null;
         var cls:Class = getDefinitionByName("codo.matchselect.uiTutorialMatchSelectView") as Class;
         if(null == cls)
         {
            return;
         }
         this.myUITutorial = new cls() as UITutorialMatchSelectView;
         localPoint = globalToLocal(new Point(0,0));
         this.myUITutorial.x = localPoint.x;
         this.myUITutorial.y = localPoint.y;
         addChild(this.myUITutorial);
         this.myUITutorial.visible = false;
      }
      
      public function tryPlayTutorial(tutorialType:int) : void
      {
         if(null == this.myUITutorial)
         {
            return;
         }
         var onboardPvpNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_PVP]);
         var onboardPveNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_PVE]);
         var onboardWarGodNotified:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_MATCH_SELECT_WARGOD]);
         if(tutorialType == UITutorialMatchSelectView.TUTORIAL_PVP && !onboardPvpNotified)
         {
            this.myUITutorial.showPvpToolTip();
            this.myUITutorial.visible = true;
            return;
         }
         if(tutorialType == UITutorialMatchSelectView.TUTORIAL_PVE && !onboardPveNotified)
         {
            this.myUITutorial.showPveToolTip();
            this.myUITutorial.visible = true;
            return;
         }
         if(tutorialType == UITutorialMatchSelectView.TUTORIAL_WARGOD && !onboardWarGodNotified)
         {
            this.myUITutorial.showWarGodToolTip1();
            this.myUITutorial.visible = true;
            return;
         }
         this.myUITutorial.visible = false;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var playlist:PlayListObj = data as PlayListObj;
         UiCppMatchSelectView(_uiCpp).SetInitialPlaylist(playlist);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mySecondaryNavMenu.showMenu();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mySecondaryNavMenu.hideMenu();
         this.myUITutorial.visible = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.SET_MATCH_SELECT_TAB,this.onTabEvent);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.SET_MATCH_SELECT_TAB,this.onTabEvent);
      }
      
      private function onTabEvent(evt:ParaEvent) : void
      {
         var idx:uint = evt.myPara;
         this.mySecondaryNavMenu.onMenuItemSelected(this.mySecondaryNavMenu.getNavButtonByIndex(idx));
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppMatchSelectView(this);
      }
   }
}

