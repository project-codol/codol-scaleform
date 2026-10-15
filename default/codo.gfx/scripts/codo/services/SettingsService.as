package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.DataCommonID;
   import codo.constants.MsgBtnCount;
   import codo.constants.QuickMatchType;
   import codo.constants.ServiceID;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import codo.objects.SettingsOptionObj;
   import codo.objects.VideoObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class SettingsService extends ServiceBase
   {
      
      private static var _instance:SettingsService;
      
      private static const MAX_TEX_RESOLUTIONS:int = 3;
      
      private static var RENDER_RESOLUTION_ID_NATIVE:int = -2;
      
      private static var RENDER_RESOLUTION_ID_UNSET:int = -1;
      
      private static var RENDER_RESOLUTION_ID_DEFAULT:int = 0;
      
      private var _displayModes:Array = null;
      
      private var _resolutions:Array = null;
      
      private var _renderResolutions:Array = null;
      
      private var _graphicsQualityLevels:Array = null;
      
      private var _aspectRatios:Array = null;
      
      private var _antiAliasings:Array = null;
      
      private var _fpsLimits:Array = null;
      
      private var _displayRefreshes:Array = null;
      
      private var _texQualities:Array = null;
      
      private var _texResolutions:Array = null;
      
      private var _normalMapResolutions:Array = null;
      
      private var _specularMapResolutions:Array = null;
      
      private var _ssaos:Array = null;
      
      private var _dynamicLights:Array = null;
      
      private var m_TextureResolutionSettings:Vector.<SettingsOptionObj> = new <SettingsOptionObj>[new SettingsOptionObj(0,DictSetting.TEXTURE_RESOLUTION_EXTRA),new SettingsOptionObj(1,DictSetting.TEXTURE_RESOLUTION_HIGH),new SettingsOptionObj(2,DictSetting.TEXTURE_RESOLUTION_NORMAL),new SettingsOptionObj(3,DictSetting.TEXTURE_RESOLUTION_LOW)];
      
      public function SettingsService()
      {
         super(ServiceID.SETTINGS);
      }
      
      public static function getInstance() : SettingsService
      {
         if(SettingsService._instance == null)
         {
            SettingsService._instance = new SettingsService();
         }
         return SettingsService._instance;
      }
      
      override public function init() : void
      {
         this.addDP(DataCommonID.CURRENT_RESOLUTION,this.getCurrentRes);
      }
      
      private function getCurrentRes() : Array
      {
         var displayResolution:Array = null;
         if(this.currentDisplayMode == VideoObj.DISPLAY_MODE_BORDERLESS_WINDOWED)
         {
            displayResolution = CFunctionContainer.GetDisplayResolution();
            if(displayResolution != null)
            {
               return displayResolution;
            }
            return this.currentResolution.split("x");
         }
         return this.currentResolution.split("x");
      }
      
      public function retrieveVideoSetting() : Object
      {
         var videoObj:VideoObj = null;
         this.listDisplayMode();
         this.listResolution();
         this.listRenderResolutions();
         this.listGraphicsQualityLevels();
         this.listAspectRatio();
         this.listAntiAliasing();
         this.listFPSLimit();
         this.listScreenRefreshRate();
         this.listTextureQuality();
         this.listSSAOs();
         this.listDynamicLights();
         videoObj = new VideoObj();
         var belowMin:Boolean = this.getDvarBool("com_belowMinSpec");
         var lock:Boolean = this.getDvarBool("ui_lockLowSpecVideoSetting");
         videoObj.is_belowMinSpec = belowMin;
         videoObj.disable_adv_option = belowMin && lock;
         videoObj.ui_r_displayMode = this.currentDisplayMode;
         videoObj.ui_r_customMode = this.currentResolution;
         videoObj.ui_r_graphicsQuality = this.currentGraphicsQuality;
         videoObj.ui_r_brightness = this.currentBrightness;
         videoObj.ui_r_fov = this.currentFOV;
         videoObj.ui_r_aspectRatio = this.currentAspectRatio;
         videoObj.ui_r_aaSamples = this.currentAASamples;
         videoObj.ui_r_fpsLimit = this.currentFPSLimit;
         videoObj.ui_r_displayRefresh = this.currentDisplayRefresh;
         videoObj.ui_r_vsync = this.currentVSync;
         videoObj.ui_sm_enable = this.currentShadow;
         videoObj.ui_r_specular = this.currentSpecular;
         videoObj.ui_r_dof_enable = this.currentDOF;
         videoObj.ui_r_zFeather = this.currentSoftenSmokeEdges;
         videoObj.ui_ragdoll_enable = this.currentRagdoll;
         videoObj.ui_fx_marks = this.currentBulletImpacts;
         videoObj.ui_r_picmip_manual = this.currentTextureQuality;
         videoObj.ui_r_picmip = this.currentTextureRes;
         videoObj.ui_r_picmip_bump = this.currentNormalMapRes;
         videoObj.ui_r_picmip_spec = this.currentSpecularMapRes;
         videoObj.ui_r_ssao = this.currentSSAO;
         videoObj.ui_r_dlightlimit = this.currentDynamicLight;
         videoObj.ui_r_glow_allowed = this.currentGlowAllowed;
         videoObj.ui_r_distortion = this.currentDistortion;
         videoObj.ui_r_renderResolutionIndex = this.currentRenderResolutionID;
         videoObj.screenModes = this._displayModes;
         videoObj.resolutions = this._resolutions;
         videoObj.graphicsQualityLevels = this._graphicsQualityLevels;
         videoObj.aspectRatios = this._aspectRatios;
         videoObj.antiAliasings = this._antiAliasings;
         videoObj.fpsLimits = this._fpsLimits;
         videoObj.displayRefreshes = this._displayRefreshes;
         videoObj.texQualities = this._texQualities;
         videoObj.renderResolutions = this._renderResolutions;
         videoObj.texResolutions = this.returnTextureOptions(this.getDvarInt("r_picmip_limit"));
         videoObj.normalMapResolutions = this.returnTextureOptions(this.getDvarInt("r_picmip_bump_limit"));
         videoObj.specularMapResolutions = this.returnTextureOptions(this.getDvarInt("r_picmip_spec_limit"));
         videoObj.ssaos = this._ssaos;
         videoObj.dynamicLights = this._dynamicLights;
         videoObj.idxDisplayMode = this.getIndexByValue(this._displayModes,videoObj.ui_r_displayMode);
         videoObj.idxResolution = this.getIndexByValue(this._resolutions,videoObj.ui_r_customMode);
         videoObj.idxGraphicsQuality = this.getIndexByValue(this._graphicsQualityLevels,videoObj.ui_r_graphicsQuality);
         videoObj.idxAspectRatio = this.getIndexByValue(this._aspectRatios,videoObj.ui_r_aspectRatio);
         videoObj.idxAntiAliasing = this.getIndexByValue(this._antiAliasings,videoObj.ui_r_aaSamples);
         videoObj.idxFpsLimit = this.getIndexByValue(this._fpsLimits,videoObj.ui_r_fpsLimit);
         videoObj.idxDisplayRefresh = this.getIndexByValue(this._displayRefreshes,videoObj.ui_r_displayRefresh);
         videoObj.idxTextureQuality = videoObj.ui_r_picmip_manual ? 1 : 0;
         videoObj.idxSSAO = this.getIndexByValue(this._ssaos,videoObj.ui_r_ssao);
         videoObj.idxDynamicLight = this.getIndexByValue(this._dynamicLights,videoObj.ui_r_dlightlimit);
         videoObj.idxRenderResolution = this.getIndexByValue(videoObj.renderResolutions,videoObj.ui_r_renderResolutionIndex);
         return videoObj;
      }
      
      public function applyVideoSetting(cObj:Object) : void
      {
         var customGraphicsQuality:Boolean = false;
         var preVideo:VideoObj = cObj.pre;
         var curVideo:VideoObj = cObj.cur;
         if(preVideo.ui_r_displayMode != curVideo.ui_r_displayMode)
         {
            CFunctionCommonContainer.setdvar("r_displayMode",curVideo.ui_r_displayMode.toString());
         }
         if(preVideo.ui_r_customMode != curVideo.ui_r_customMode)
         {
            CFunctionCommonContainer.execnow("r_customMode \"\"");
            CFunctionCommonContainer.execnow("r_mode " + curVideo.ui_r_customMode);
         }
         var autoConfigAdvancedSettings:Boolean = false;
         if(preVideo.ui_r_graphicsQuality != curVideo.ui_r_graphicsQuality)
         {
            CFunctionCommonContainer.setdvar("com_graphicsTier",curVideo.ui_r_graphicsQuality.toString());
            if(curVideo.ui_r_graphicsQuality > 0)
            {
               CFunctionContainer.SetTierSetting();
               autoConfigAdvancedSettings = true;
            }
         }
         if(!autoConfigAdvancedSettings)
         {
            customGraphicsQuality = false;
            if(preVideo.ui_r_aspectRatio != curVideo.ui_r_aspectRatio)
            {
               CFunctionCommonContainer.setdvar("r_aspectRatio",curVideo.ui_r_aspectRatio);
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_aaSamples != curVideo.ui_r_aaSamples)
            {
               CFunctionCommonContainer.execnow("r_aaSamples " + curVideo.ui_r_aaSamples);
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_renderResolutionIndex != curVideo.ui_r_renderResolutionIndex)
            {
               CFunctionCommonContainer.setdvar("r_imageQualityMode",curVideo.ui_r_renderResolutionIndex.toString());
            }
            if(preVideo.ui_r_fpsLimit != curVideo.ui_r_fpsLimit)
            {
               CFunctionCommonContainer.setdvar("com_maxfps",curVideo.ui_r_fpsLimit.toString());
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_displayRefresh != curVideo.ui_r_displayRefresh)
            {
               CFunctionCommonContainer.setdvar("r_displayRefresh",curVideo.ui_r_displayRefresh);
               customGraphicsQuality = true;
            }
            if(preVideo.ui_sm_enable != curVideo.ui_sm_enable)
            {
               CFunctionCommonContainer.execnow("sm_enable " + String(curVideo.ui_sm_enable ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_specular != curVideo.ui_r_specular)
            {
               CFunctionCommonContainer.execnow("r_specular " + String(curVideo.ui_r_specular ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_dof_enable != curVideo.ui_r_dof_enable)
            {
               CFunctionCommonContainer.execnow("r_dof_enable " + String(curVideo.ui_r_dof_enable ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_zFeather != curVideo.ui_r_zFeather)
            {
               CFunctionCommonContainer.execnow("r_zFeather " + String(curVideo.ui_r_zFeather ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_ragdoll_enable != curVideo.ui_ragdoll_enable)
            {
               CFunctionCommonContainer.execnow("ragdoll_enable " + String(curVideo.ui_ragdoll_enable ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_fx_marks != curVideo.ui_fx_marks)
            {
               CFunctionCommonContainer.execnow("fx_marks " + String(curVideo.ui_fx_marks ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_glow_allowed != curVideo.ui_r_glow_allowed)
            {
               CFunctionCommonContainer.execnow("r_glow_allowed " + String(curVideo.ui_r_glow_allowed ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_distortion != curVideo.ui_r_distortion)
            {
               CFunctionCommonContainer.execnow("r_distortion " + String(curVideo.ui_r_distortion ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_picmip_manual != curVideo.ui_r_picmip_manual)
            {
               CFunctionCommonContainer.execnow("r_picmip_manual " + String(curVideo.ui_r_picmip_manual ? 1 : 0));
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_ssao != curVideo.ui_r_ssao)
            {
               CFunctionCommonContainer.setdvar("r_ssao",curVideo.ui_r_ssao.toString());
               customGraphicsQuality = true;
            }
            if(preVideo.ui_r_dlightlimit != curVideo.ui_r_dlightlimit)
            {
               CFunctionCommonContainer.execnow("r_dlightlimit " + curVideo.ui_r_dlightlimit);
               customGraphicsQuality = true;
            }
            if(curVideo.ui_r_picmip_manual)
            {
               CFunctionCommonContainer.execnow("r_picmip " + curVideo.ui_r_picmip);
               CFunctionCommonContainer.execnow("r_picmip_bump " + curVideo.ui_r_picmip_bump);
               CFunctionCommonContainer.execnow("r_picmip_spec " + curVideo.ui_r_picmip_spec);
               customGraphicsQuality = true;
            }
            if(customGraphicsQuality)
            {
               curVideo.ui_r_graphicsQuality = 0;
               curVideo.idxGraphicsQuality = this.getIndexByValue(this._graphicsQualityLevels,curVideo.ui_r_graphicsQuality);
               CFunctionCommonContainer.setdvar("com_graphicsTier",curVideo.ui_r_graphicsQuality.toString());
            }
         }
         if(preVideo.ui_r_vsync != curVideo.ui_r_vsync)
         {
            CFunctionCommonContainer.execnow("r_vsync " + String(curVideo.ui_r_vsync ? 1 : 0));
         }
         CFunctionContainer.SetVideoSetting();
         var bNeedRestartVideo:Boolean = preVideo.ui_r_displayMode != curVideo.ui_r_displayMode || preVideo.ui_r_customMode != curVideo.ui_r_customMode || autoConfigAdvancedSettings || preVideo.ui_r_aspectRatio != curVideo.ui_r_aspectRatio || preVideo.ui_r_aaSamples != curVideo.ui_r_aaSamples || preVideo.ui_r_renderResolutionIndex != curVideo.ui_r_renderResolutionIndex || preVideo.ui_r_fpsLimit != curVideo.ui_r_fpsLimit || preVideo.ui_r_displayRefresh != curVideo.ui_r_displayRefresh || preVideo.ui_r_vsync != curVideo.ui_r_vsync || preVideo.ui_r_ssao != curVideo.ui_r_ssao || preVideo.ui_r_picmip_manual != curVideo.ui_r_picmip_manual || preVideo.ui_r_picmip != curVideo.ui_r_picmip || preVideo.ui_r_picmip_bump != curVideo.ui_r_picmip_bump || preVideo.ui_r_picmip_spec != curVideo.ui_r_picmip_spec;
         if(bNeedRestartVideo)
         {
            this.restartVideo();
         }
      }
      
      public function applyBrightness(cValue:Number) : void
      {
         if(cValue != this.currentBrightness)
         {
            CFunctionCommonContainer.setdvar("profileMenuOption_gamma",cValue.toString());
            CFunctionCommonContainer.execnow("profile_menuDvarsFinish");
         }
      }
      
      public function applyFOV(cValue:int) : void
      {
         if(cValue != this.currentFOV)
         {
            CFunctionCommonContainer.setdvar("cg_fov",cValue.toString());
            CFunctionCommonContainer.execnow("profile_menuDvarsFinish");
         }
      }
      
      private function getIndexByValue(dataP:Array, cur:*) : uint
      {
         var curIdx:uint = 0;
         var len:int = int(dataP.length);
         for(var i:int = 0; i < len; i++)
         {
            if(dataP[i].id == cur)
            {
               curIdx = uint(i);
               break;
            }
         }
         return curIdx;
      }
      
      private function getEnumValues(enum:String) : Array
      {
         var enumV:String = null;
         var dataP:Array = new Array();
         var totalNum:Number = CFunctionCommonContainer.Dvar_GetEnumLength(enum);
         for(var idx:Number = 0; idx < totalNum; idx++)
         {
            enumV = CFunctionCommonContainer.Dvar_GetEnumValue(enum,idx);
            dataP.push({
               "label":enumV,
               "id":enumV
            });
         }
         return dataP;
      }
      
      public function listDisplayMode() : void
      {
         if(this._displayModes == null)
         {
            this._displayModes = new Array();
            this._displayModes.push({
               "label":DictSetting.DISPLAY_MODE_WINDOWED_BORDERLESS,
               "id":VideoObj.DISPLAY_MODE_BORDERLESS_WINDOWED
            });
            this._displayModes.push({
               "label":DictSetting.DISPLAY_MODE_WINDOWED,
               "id":VideoObj.DISPLAY_MODE_WINDOWED
            });
            this._displayModes.push({
               "label":DictSetting.DISPLAY_MODE_FULL_SCREEN,
               "id":VideoObj.DISPLAY_MODE_FULLSCREEN
            });
         }
      }
      
      public function listResolution() : void
      {
         var len:int = 0;
         var i:int = 0;
         var resW:int = 0;
         if(this._resolutions == null && this.getEnumValues("r_mode") != null)
         {
            this._resolutions = this.getEnumValues("r_mode");
            len = int(this._resolutions.length);
            for(i = 0; i < len; i++)
            {
               resW = parseInt(this._resolutions[i].id.split("x")[0]);
               if(resW < 1024)
               {
                  this._resolutions.splice(i,1);
               }
               else
               {
                  i++;
               }
            }
         }
      }
      
      public function listRenderResolutions() : void
      {
         var i:int = 0;
         if(this._renderResolutions == null)
         {
            this._renderResolutions = CFunctionContainer.GetRenderResolutions();
            for(i = 0; i < this._renderResolutions.length; i++)
            {
               if(this._renderResolutions[i].id == RENDER_RESOLUTION_ID_NATIVE)
               {
                  this._renderResolutions[i].label = LocalizeUtil.localize(DictSetting.NATIVE_RESOLUTION) + " (" + this._renderResolutions[i].label + ")";
               }
            }
         }
      }
      
      public function listGraphicsQualityLevels() : void
      {
         if(this._graphicsQualityLevels == null)
         {
            this._graphicsQualityLevels = new Array();
            this._graphicsQualityLevels.push({
               "label":DictSetting.GRAPHICS_QUALITY_VERY_LOW,
               "id":1
            });
            this._graphicsQualityLevels.push({
               "label":DictSetting.GRAPHICS_QUALITY_LOW,
               "id":2
            });
            this._graphicsQualityLevels.push({
               "label":DictSetting.GRAPHICS_QUALITY_MEDIUM,
               "id":3
            });
            this._graphicsQualityLevels.push({
               "label":DictSetting.GRAPHICS_QUALITY_HIGH,
               "id":4
            });
            this._graphicsQualityLevels.push({
               "label":DictSetting.GRAPHICS_QUALITY_VERY_HIGH,
               "id":5
            });
            this._graphicsQualityLevels.push({
               "label":DictSetting.GRAPHICS_QUALITY_CUSTOM,
               "id":0,
               "isHiddenValue":true
            });
         }
      }
      
      public function listAspectRatio() : void
      {
         if(this._aspectRatios == null)
         {
            this._aspectRatios = new Array();
            this._aspectRatios.push({
               "label":DictSetting.ASPECT_RATIO_AUTO,
               "id":"auto"
            });
            this._aspectRatios.push({
               "label":DictSetting.ASPECT_RATIO_STANDARD_4_3,
               "id":"standard"
            });
            this._aspectRatios.push({
               "label":DictSetting.ASPECT_RATIO_WIDE_16_10,
               "id":"wide 16:10"
            });
            this._aspectRatios.push({
               "label":DictSetting.ASPECT_RATIO_WIDE_16_9,
               "id":"wide 16:9"
            });
         }
      }
      
      public function listAntiAliasing() : void
      {
         if(this._antiAliasings == null)
         {
            this._antiAliasings = new Array();
            this._antiAliasings.push({
               "label":DictSetting.ANTI_ALIASING_OFF,
               "id":1
            });
            this._antiAliasings.push({
               "label":"2X",
               "id":2
            });
            this._antiAliasings.push({
               "label":"4X",
               "id":4
            });
            this._antiAliasings.push({
               "label":"8X",
               "id":8
            });
            this._antiAliasings.push({
               "label":"16X",
               "id":16
            });
         }
      }
      
      public function listFPSLimit() : void
      {
         if(this._fpsLimits == null)
         {
            this._fpsLimits = new Array();
            this._fpsLimits.push({
               "label":LocalizeUtil.param(DictSetting.FPS_NUM,[60]),
               "id":60
            });
            this._fpsLimits.push({
               "label":LocalizeUtil.param(DictSetting.FPS_NUM,[90]),
               "id":90
            });
            this._fpsLimits.push({
               "label":LocalizeUtil.param(DictSetting.FPS_NUM,[120]),
               "id":120
            });
            this._fpsLimits.push({
               "label":DictSetting.FPS_UNLOCKED,
               "id":200
            });
         }
      }
      
      public function listScreenRefreshRate() : void
      {
         if(this._displayRefreshes == null)
         {
            if(ScaleformUtil.isScaleform)
            {
               this._displayRefreshes = this.getEnumValues("r_displayRefresh");
            }
            else
            {
               this._displayRefreshes = new Array();
               this._displayRefreshes.push({
                  "label":"59 Hz",
                  "id":"59 Hz"
               });
               this._displayRefreshes.push({
                  "label":"60 Hz",
                  "id":"60 Hz"
               });
               this._displayRefreshes.push({
                  "label":"75 Hz",
                  "id":"75 Hz"
               });
            }
         }
      }
      
      public function listTextureQuality() : void
      {
         if(this._texQualities == null)
         {
            this._texQualities = new Array();
            this._texQualities.push({
               "label":DictSetting.TEXTURE_QUALITY_AUTOMATIC,
               "id":false
            });
            this._texQualities.push({
               "label":DictSetting.TEXTURE_QUALITY_MANUAL,
               "id":true
            });
         }
      }
      
      private function returnTextureOptions(res:int) : Array
      {
         var settingObj:SettingsOptionObj = null;
         var options:Array = [];
         var len:int = this.m_TextureResolutionSettings.length - 1;
         for(var i:int = len; i > -1; i--)
         {
            settingObj = new SettingsOptionObj(this.m_TextureResolutionSettings[i].id,this.m_TextureResolutionSettings[i].label);
            if(res > i)
            {
               settingObj.enabled = false;
            }
            options.push(settingObj);
         }
         return options.reverse();
      }
      
      public function listSSAOs() : void
      {
         if(this._ssaos == null)
         {
            this._ssaos = new Array();
            this._ssaos.push({
               "label":DictSetting.SSAO_OFF,
               "id":0
            });
            this._ssaos.push({
               "label":DictSetting.SSAO_LOW,
               "id":1
            });
            this._ssaos.push({
               "label":DictSetting.SSAO_HIGH,
               "id":2
            });
         }
      }
      
      public function listDynamicLights() : void
      {
         if(this._dynamicLights == null)
         {
            this._dynamicLights = new Array();
            this._dynamicLights.push({
               "label":0,
               "id":0
            });
            this._dynamicLights.push({
               "label":1,
               "id":1
            });
            this._dynamicLights.push({
               "label":2,
               "id":2
            });
            this._dynamicLights.push({
               "label":3,
               "id":3
            });
            this._dynamicLights.push({
               "label":4,
               "id":4
            });
         }
      }
      
      private function get currentDisplayMode() : int
      {
         return this.getDvarInt("r_displayMode");
      }
      
      private function get currentResolution() : String
      {
         var curRes:String = CFunctionCommonContainer.Dvar_GetString("r_mode");
         Logger.print("SettingsService::get currentResolution curRes: " + curRes);
         var resOverride:String = CFunctionCommonContainer.Dvar_GetString("r_customMode");
         curRes = resOverride != "" ? resOverride : curRes;
         Logger.print("SettingsService::get currentResolution curRes: " + curRes + ", resOverride: " + resOverride);
         return curRes;
      }
      
      private function get currentGraphicsQuality() : int
      {
         return this.getDvarInt("com_graphicsTier");
      }
      
      private function get currentBrightness() : Number
      {
         var gamma:Number = CFunctionCommonContainer.Dvar_GetFloat("profileMenuOption_gamma");
         if(!ScaleformUtil.isScaleform)
         {
            gamma = Number(this.gammaRange.val);
         }
         return Number(gamma.toFixed(1));
      }
      
      private function get currentFOV() : int
      {
         var fov:int = int(CFunctionCommonContainer.Dvar_GetFloat("cg_fov"));
         if(!ScaleformUtil.isScaleform)
         {
            fov = int(this.FOVRange.val);
         }
         return int(fov);
      }
      
      public function get gammaRange() : Object
      {
         return CFunctionContainer.GetGammaRange();
      }
      
      public function get FOVRange() : Object
      {
         return CFunctionContainer.GetFOVRange();
      }
      
      public function get sensitivityRange() : Object
      {
         return CFunctionContainer.GetSensitivityRange();
      }
      
      private function get currentAspectRatio() : String
      {
         return CFunctionCommonContainer.Dvar_GetString("r_aspectRatio");
      }
      
      private function get currentAASamples() : int
      {
         return this.getDvarInt("r_aaSamples");
      }
      
      private function get currentFPSLimit() : int
      {
         return this.getDvarInt("com_maxfps");
      }
      
      private function get currentDisplayRefresh() : String
      {
         return CFunctionCommonContainer.Dvar_GetString("r_displayRefresh");
      }
      
      private function get currentVSync() : Boolean
      {
         return this.getDvarBool("r_vsync");
      }
      
      private function get currentShadow() : Boolean
      {
         return this.getDvarBool("sm_enable");
      }
      
      private function get currentSpecular() : Boolean
      {
         return this.getDvarBool("r_specular");
      }
      
      private function get currentDOF() : Boolean
      {
         return this.getDvarBool("r_dof_enable");
      }
      
      private function get currentSoftenSmokeEdges() : Boolean
      {
         return this.getDvarBool("r_zFeather");
      }
      
      private function get currentRagdoll() : Boolean
      {
         return this.getDvarBool("ragdoll_enable");
      }
      
      private function get currentBulletImpacts() : Boolean
      {
         return this.getDvarBool("fx_marks");
      }
      
      private function get currentTextureQuality() : Boolean
      {
         return this.getDvarBool("r_picmip_manual");
      }
      
      private function get currentTextureRes() : int
      {
         return this.getDvarInt("r_picmip");
      }
      
      private function get currentNormalMapRes() : int
      {
         return this.getDvarInt("r_picmip_bump");
      }
      
      private function get currentSpecularMapRes() : int
      {
         return this.getDvarInt("r_picmip_spec");
      }
      
      private function get currentSSAO() : int
      {
         return this.getDvarInt("r_ssao");
      }
      
      private function get currentDynamicLight() : int
      {
         return this.getDvarInt("r_dlightLimit");
      }
      
      private function get currentGlowAllowed() : Boolean
      {
         return this.getDvarBool("r_glow_allowed");
      }
      
      private function get currentDistortion() : Boolean
      {
         return this.getDvarBool("r_distortion");
      }
      
      private function get currentRenderResolutionID() : int
      {
         var currentRenderResolutionID:int = this.getDvarInt("r_imageQualityMode");
         if(currentRenderResolutionID == RENDER_RESOLUTION_ID_UNSET)
         {
            currentRenderResolutionID = RENDER_RESOLUTION_ID_DEFAULT;
         }
         return currentRenderResolutionID;
      }
      
      private function execRestart(cmd:String) : void
      {
         CFunctionContainer.MainMenuWillReload();
         if(Boolean(CFunctionContainer.HasCharacter()))
         {
            CFunctionCommonContainer.setdvar("ui_played_mapname","");
         }
         else
         {
            this.showMsg(Dict.CANNOT_RESTART,MsgBtnCount.ONE);
         }
         QuickMatchType.clearPersistent();
         CFunctionCommonContainer.execnow(cmd);
      }
      
      public function restartRelogin() : void
      {
         this.execRestart("vid_restart_relogin");
      }
      
      public function restartVideo() : void
      {
         this.execRestart("vid_restart");
      }
      
      public function restartAudio() : void
      {
         this.execRestart("snd_restart");
      }
   }
}

