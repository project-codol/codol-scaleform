package codo.views.option_sub
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.DictSetting;
   import codo.objects.VideoObj;
   import flash.events.Event;
   import fsg.shared.ComboBox;
   import fsg.shared.ConfigSlider;
   
   public class FsgOptionVideoBasicPanel extends FsgOptionVideoBase
   {
      
      public var myCBDisplayMode:ComboBox;
      
      public var myCBResolution:ComboBox;
      
      public var myCBGraphicsQuality:ComboBox;
      
      public var myPBBrightness:ConfigSlider;
      
      private var cachedDisplayResolutions:Array;
      
      private var cachedDisplayResolutionIndex:int;
      
      private var cachedRenderResolutions:Array;
      
      private var cachedRenderResolutionIndex:int;
      
      public function FsgOptionVideoBasicPanel()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myCBDisplayMode.label = DictSetting.DISPLAY_MODE;
         this.myCBResolution.label = DictSetting.RESOLUTION;
         this.myCBGraphicsQuality.label = DictSetting.GRAPHICS_QUALITY;
         this.myPBBrightness.setText(DictSetting.BRIGHTNESS,null);
      }
      
      override protected function onInitListener() : void
      {
         this.myCBDisplayMode.addEventListener(ComboBox.EVT_CHANGE,this.onDisplayModeChanged);
      }
      
      override public function RefreshSettings(settings:VideoObj) : void
      {
         this.cachedDisplayResolutions = settings.resolutions.concat();
         this.cachedDisplayResolutionIndex = settings.idxResolution;
         this.cachedRenderResolutions = settings.renderResolutions.concat();
         this.cachedRenderResolutionIndex = settings.idxRenderResolution;
         this.myCBDisplayMode.dataProvider = settings.screenModes;
         this.myCBDisplayMode.selectedIndex = settings.idxDisplayMode;
         this.myCBGraphicsQuality.dataProvider = settings.graphicsQualityLevels;
         this.myCBGraphicsQuality.selectedIndex = settings.idxGraphicsQuality;
         var gammaRange:Object = this.getDP(DataID.GAMMA_RANGE);
         if(gammaRange != null)
         {
            this.myPBBrightness.initialise(settings.ui_r_brightness,gammaRange.min,gammaRange.max,0.1);
         }
      }
      
      override public function ApplySettings(settingsToUpdate:VideoObj, isCurrentTab:Boolean) : void
      {
         settingsToUpdate.ui_r_displayMode = this.myCBDisplayMode.selectedValue.id;
         settingsToUpdate.ui_r_graphicsQuality = this.myCBGraphicsQuality.selectedValue.id;
         if(this.myCBDisplayMode.selectedValue.id == VideoObj.DISPLAY_MODE_BORDERLESS_WINDOWED)
         {
            settingsToUpdate.ui_r_renderResolutionIndex = this.myCBResolution.selectedValue.id;
         }
         else
         {
            settingsToUpdate.ui_r_customMode = this.myCBResolution.selectedValue.id;
         }
         this.broadcast(BCEvent.EVT_SET_BRIGHTNESS,this.myPBBrightness.getValue());
      }
      
      private function onDisplayModeChanged(event:Event) : void
      {
         if(this.myCBDisplayMode.selectedValue.id == VideoObj.DISPLAY_MODE_BORDERLESS_WINDOWED)
         {
            this.myCBResolution.dataProvider = this.cachedRenderResolutions;
            this.myCBResolution.selectedIndex = this.cachedRenderResolutionIndex;
         }
         else
         {
            this.myCBResolution.dataProvider = this.cachedDisplayResolutions;
            this.myCBResolution.selectedIndex = this.cachedDisplayResolutionIndex;
         }
      }
   }
}

