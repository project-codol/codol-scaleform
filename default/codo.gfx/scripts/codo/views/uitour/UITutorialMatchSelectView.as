package codo.views.uitour
{
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.BCEvent;
   import codo.constants.table.UINotifications;
   import codo.localization.Dict;
   import codo.localization.DictUITutorial;
   import codo.manager.EventManager;
   import flash.display.MovieClip;
   
   public class UITutorialMatchSelectView extends MovieClip
   {
      
      public static const TUTORIAL_PVP:int = 0;
      
      public static const TUTORIAL_PVE:int = 1;
      
      public static const TUTORIAL_WARGOD:int = 2;
      
      public var myToolTip:UITourToolTip;
      
      public function UITutorialMatchSelectView()
      {
         super();
         this.myToolTip.setTipStyle(UITourToolTip.STYLE_1_BTN);
      }
      
      public function showPvpToolTip() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_UI_NOTIFICATION,{"notification":UINotifications.ONBOARD_MATCH_SELECT_PVP});
         this.myToolTip.setTipStyle(UITourToolTip.STYLE_1_BTN);
         this.myToolTip.setTipContent(Dict.MATCH_SELECT_MENU_OPTION_PVP,DictUITutorial.UI_TOUR_TOOL_TIP_MATCHSELECT_PVP_DESC,UITourToolTip.ARROW_UP);
         this.myToolTip.x = 161;
         this.myToolTip.y = 140;
         this.myToolTip.clickCallback = this.onPvpToolTipClicked;
         this.myToolTip.active();
      }
      
      public function showPveToolTip() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_UI_NOTIFICATION,{"notification":UINotifications.ONBOARD_MATCH_SELECT_PVP});
         EventManager.getInstance().broadcast(BCEvent.EVT_UI_NOTIFICATION,{"notification":UINotifications.ONBOARD_MATCH_SELECT_PVE});
         this.myToolTip.setTipStyle(UITourToolTip.STYLE_1_BTN);
         this.myToolTip.setTipContent(Dict.MATCH_SELECT_MENU_OPTION_PVE,DictUITutorial.UI_TOUR_TOOL_TIP_MATCHSELECT_PVE_DESC,UITourToolTip.ARROW_UP);
         this.myToolTip.x = 310;
         this.myToolTip.y = 140;
         this.myToolTip.clickCallback = this.onPveToolTipClicked;
         this.myToolTip.active();
      }
      
      public function showWarGodToolTip1() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_UI_NOTIFICATION,{"notification":UINotifications.ONBOARD_MATCH_SELECT_PVP});
         EventManager.getInstance().broadcast(BCEvent.EVT_UI_NOTIFICATION,{"notification":UINotifications.ONBOARD_MATCH_SELECT_PVE});
         EventManager.getInstance().broadcast(BCEvent.EVT_UI_NOTIFICATION,{"notification":UINotifications.ONBOARD_MATCH_SELECT_WARGOD});
         this.myToolTip.setTipStyle(UITourToolTip.STYLE_1_BTN);
         this.myToolTip.setTipContent(Dict.MATCH_SELECT_MENU_OPTION_WARGOD,DictUITutorial.UI_TOUR_TOOL_TIP_MATCHSELECT_WARGOD_DESC1,UITourToolTip.ARROW_UP);
         this.myToolTip.x = 460;
         this.myToolTip.y = 140;
         this.myToolTip.clickCallback = this.onWarGodToolTip1Clicked;
         this.myToolTip.active();
      }
      
      public function showWarGodToolTip2() : void
      {
         this.myToolTip.setTipStyle(UITourToolTip.STYLE_1_BTN);
         this.myToolTip.setTipContent(DictUITutorial.UI_TOUR_TOOL_TIP_MATCHSELECT_WARGOD_TITLE2,DictUITutorial.UI_TOUR_TOOL_TIP_MATCHSELECT_WARGOD_DESC2,UITourToolTip.ARROW_DOWN);
         this.myToolTip.x = 1500;
         this.myToolTip.y = 600;
         this.myToolTip.clickCallback = this.onWarGodToolTip2Clicked;
         this.myToolTip.active();
      }
      
      private function onPvpToolTipClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_MAIN_PVE);
      }
      
      private function onPveToolTipClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_MAIN_WARGOD);
      }
      
      private function onWarGodToolTip1Clicked() : void
      {
         this.showWarGodToolTip2();
      }
      
      private function onWarGodToolTip2Clicked() : void
      {
         visible = false;
      }
   }
}

