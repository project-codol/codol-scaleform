package codo.objects
{
   public dynamic class VideoObj extends CustomObject
   {
      
      public static const DISPLAY_MODE_FULLSCREEN:int = 0;
      
      public static const DISPLAY_MODE_BORDERLESS_WINDOWED:int = 1;
      
      public static const DISPLAY_MODE_WINDOWED:int = 2;
      
      public static const DEFAULT_FPS_LIMIT:int = 200;
      
      public var is_belowMinSpec:Boolean = false;
      
      public var disable_adv_option:Boolean = false;
      
      public var ui_r_displayMode:int = 1;
      
      public var ui_r_customMode:String = "";
      
      public var ui_r_graphicsQuality:int = 0;
      
      public var ui_r_brightness:Number = 0;
      
      public var ui_r_fov:int = 80;
      
      public var ui_r_aspectRatio:String = "";
      
      public var ui_r_aaSamples:int = 0;
      
      public var ui_r_fpsLimit:int = 200;
      
      public var ui_r_displayRefresh:String = "";
      
      public var ui_r_vsync:Boolean = false;
      
      public var ui_sm_enable:Boolean = false;
      
      public var ui_r_specular:Boolean = false;
      
      public var ui_r_dof_enable:Boolean = false;
      
      public var ui_r_zFeather:Boolean = false;
      
      public var ui_ragdoll_enable:Boolean = false;
      
      public var ui_fx_marks:Boolean = false;
      
      public var ui_r_picmip_manual:Boolean = false;
      
      public var ui_r_picmip:int = 0;
      
      public var ui_r_picmip_bump:int = 0;
      
      public var ui_r_picmip_spec:int = 0;
      
      public var ui_r_ssao:int = 0;
      
      public var ui_r_distortion:Boolean = false;
      
      public var ui_r_glow_allowed:Boolean = false;
      
      public var ui_r_dlightlimit:int = 0;
      
      public var ui_r_renderResolutionIndex:int = 0;
      
      public var screenModes:Array = [];
      
      public var resolutions:Array = [];
      
      public var graphicsQualityLevels:Array = [];
      
      public var aspectRatios:Array = [];
      
      public var antiAliasings:Array = [];
      
      public var fpsLimits:Array = [];
      
      public var displayRefreshes:Array = [];
      
      public var texQualities:Array = [];
      
      public var texResolutions:Array = [];
      
      public var normalMapResolutions:Array = [];
      
      public var specularMapResolutions:Array = [];
      
      public var ssaos:Array = [];
      
      public var dynamicLights:Array = [];
      
      public var renderResolutions:Array = [];
      
      public var idxDisplayMode:int = 0;
      
      public var idxResolution:int = 0;
      
      public var idxGraphicsQuality:int = 0;
      
      public var idxAspectRatio:int = 0;
      
      public var idxAntiAliasing:int = 0;
      
      public var idxFpsLimit:int = 0;
      
      public var idxDisplayRefresh:int = 0;
      
      public var idxTextureQuality:int = 0;
      
      public var idxSSAO:int = 0;
      
      public var idxDynamicLight:int = 0;
      
      public var idxRenderResolution:int = 0;
      
      public function VideoObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

