package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataCommonID;
   import codo.constants.DataInGameID;
   import codo.constants.ServiceID;
   import codo.event.ParaEvent;
   import codo.objects.VideoObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class SettingsInGameService extends ServiceBase
   {
      
      private static var _instance:SettingsInGameService;
      
      public function SettingsInGameService()
      {
         super(ServiceID.SETTINGS_INGAME);
      }
      
      public static function getInstance() : SettingsInGameService
      {
         if(SettingsInGameService._instance == null)
         {
            SettingsInGameService._instance = new SettingsInGameService();
         }
         return SettingsInGameService._instance;
      }
      
      override public function init() : void
      {
         this.addDP(DataCommonID.CURRENT_RESOLUTION,this.getCurrentRes);
         this.addDP(DataInGameID.GAMMA,this.getGamma);
         this.addDP(DataInGameID.GAMMA_RANGE,this.getGammaRange);
         this.addDP(DataInGameID.FOV_RANGE,this.getFOVRange);
         this.addDP(DataInGameID.SENSITIVITY_RANGE,this.getSensitivityRange);
         this.addDP(DataInGameID.MOUSE_SENSITIVITY_X,this.getMouseSensitivityX);
         this.addDP(DataInGameID.MOUSE_SENSITIVITY_Y,this.getMouseSensitivityY);
         this.addDP(DataInGameID.MOUSE_INVERT,this.getMouseInvert);
         this.addDP(DataInGameID.IS_FULL_SCREEN,this.isFullScreen);
         this.listen(BCInGameEvent.EVT_SET_MOUSE_SENSITIVITY_X,this.onSetMouseSensitivityXHandle);
         this.listen(BCInGameEvent.EVT_SET_MOUSE_SENSITIVITY_X,this.onSetMouseSensitivityYHandle);
         this.listen(BCInGameEvent.EVT_SET_BRIGHTNESS,this.onSetBrightnessHandle);
         this.listen(BCInGameEvent.EVT_SET_MOUSE_INVERT,this.onSetMouseInvert);
      }
      
      private function getCurrentRes() : Array
      {
         var displayResolution:Array = null;
         if(this.currentDisplayMode == VideoObj.DISPLAY_MODE_BORDERLESS_WINDOWED)
         {
            displayResolution = CFunctionInGameContainer.GetDisplayResolution();
            if(displayResolution != null)
            {
               return displayResolution;
            }
            return this.currentResolution.split("x");
         }
         return this.currentResolution.split("x");
      }
      
      private function get currentDisplayMode() : int
      {
         return this.getDvarInt("r_displayMode");
      }
      
      private function get currentResolution() : String
      {
         var curRes:String = CFunctionCommonContainer.Dvar_GetString("r_mode");
         var resOverride:String = CFunctionCommonContainer.Dvar_GetString("r_customMode");
         return resOverride != "" ? resOverride : curRes;
      }
      
      private function getGamma() : Number
      {
         return ScaleformUtil.isScaleform ? Number(CFunctionCommonContainer.Dvar_GetFloat("profileMenuOption_gamma")) : 0.9;
      }
      
      private function getGammaRange() : Object
      {
         return CFunctionInGameContainer.GetGammaRange();
      }
      
      private function getFOVRange() : Object
      {
         return CFunctionInGameContainer.GetFOVRange();
      }
      
      private function getSensitivityRange() : Object
      {
         return CFunctionInGameContainer.GetSensitivityRange();
      }
      
      private function getMouseSensitivityX() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("cl_horizontal_sensitivity");
      }
      
      private function getMouseSensitivityY() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("cl_vertical_sensitivity");
      }
      
      private function getMouseInvert() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("m_pitch");
      }
      
      private function isFullScreen() : Boolean
      {
         return this.currentDisplayMode == VideoObj.DISPLAY_MODE_FULLSCREEN;
      }
      
      public function applyBrightness(cValue:Number) : void
      {
         Logger.print("SettingsInGameService::applyBrightness cValue: " + cValue);
         if(cValue != this.getGamma())
         {
            CFunctionCommonContainer.setdvar("profileMenuOption_gamma",cValue.toString());
            CFunctionCommonContainer.execnow("profile_menuDvarsFinish");
         }
      }
      
      private function onSetMouseSensitivityXHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != this.getMouseSensitivityX())
         {
            CFunctionCommonContainer.setdvar("cl_horizontal_sensitivity",cEvt.myPara.toString());
            CFunctionCommonContainer.As_markSettingChanged();
         }
      }
      
      private function onSetMouseSensitivityYHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != this.getMouseSensitivityY())
         {
            CFunctionCommonContainer.setdvar("cl_vertical_sensitivity",cEvt.myPara.toString());
            CFunctionCommonContainer.As_markSettingChanged();
         }
      }
      
      public function onSetBrightnessHandle(cEvt:ParaEvent) : void
      {
         this.applyBrightness(cEvt.myPara);
      }
      
      public function onSetMouseInvert(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != this.getMouseInvert())
         {
            CFunctionCommonContainer.setdvar("m_pitch",cEvt.myPara);
            CFunctionCommonContainer.As_markSettingChanged();
         }
      }
   }
}

