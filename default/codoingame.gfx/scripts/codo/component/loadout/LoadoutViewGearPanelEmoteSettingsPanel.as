package codo.component.loadout
{
   import codo.component.EmoteSettings;
   import codo.localization.DictMarket;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class LoadoutViewGearPanelEmoteSettingsPanel extends MovieClip
   {
      
      public var myTitle:TextField;
      
      public var mySettings:EmoteSettings;
      
      public function LoadoutViewGearPanelEmoteSettingsPanel()
      {
         super();
         this.myTitle.text = DictMarket.EMOTE_SETTING_PANEL_TITLE;
      }
      
      public function updateEmoteSetting() : void
      {
         this.mySettings.updateEmoteSetting();
      }
   }
}

