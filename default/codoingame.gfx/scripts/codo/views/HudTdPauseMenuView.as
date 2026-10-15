package codo.views
{
   import codo.constants.HUDPopupComponentTypes;
   import codo.localization.DictTD;
   import codo.views.hud.popups.hudTdLoadoutView_parts.HudTdLoadoutPanel;
   import flash.text.TextField;
   
   public class HudTdPauseMenuView extends HudPauseMenuPopupBase
   {
      
      public var myTitle:TextField;
      
      public var myLoadoutPanel:HudTdLoadoutPanel;
      
      public function HudTdPauseMenuView()
      {
         super();
         this.myTitle.text = DictTD.PACKAGE;
         myOptions.gotoAndStop(2);
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.TD_PAUSE_MENU;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myLoadoutPanel.show();
      }
      
      override protected function hideView() : void
      {
         this.myLoadoutPanel.hide();
         super.hideView();
      }
   }
}

