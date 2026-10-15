package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.GameInfo;
   import flash.display.MovieClip;
   
   public class ShoutcastUtil
   {
      
      private static var _instance:ShoutcastUtil;
      
      private var registeredViews:Array = new Array();
      
      private var PIPSCREENX_RATIO:Number = 0;
      
      private var PIPSCREENY_RATIO:Number = 0;
      
      private var PIPSCREENW_RATIO:Number = 0;
      
      private var PIPSCREENH_RATIO:Number = 0;
      
      private var changeToFullScreen:Boolean = false;
      
      public function ShoutcastUtil()
      {
         super();
         CFunctionCommonContainer.AS_RegisterShoutcastUtil(this);
         this.PIPSCREENX_RATIO = CFunctionCommonContainer.Dvar_GetFloat("cl_shoutcast_pipxratio");
         this.PIPSCREENY_RATIO = CFunctionCommonContainer.Dvar_GetFloat("cl_shoutcast_pipyratio");
         this.PIPSCREENW_RATIO = CFunctionCommonContainer.Dvar_GetFloat("cl_shoutcast_pipwratio");
         this.PIPSCREENH_RATIO = CFunctionCommonContainer.Dvar_GetFloat("cl_shoutcast_piphratio");
      }
      
      public static function getInstance() : ShoutcastUtil
      {
         if(_instance == null)
         {
            _instance = new ShoutcastUtil();
         }
         return _instance;
      }
      
      public function registerView(view:MovieClip) : void
      {
         var mv:MovieClip = null;
         for each(mv in this.registeredViews)
         {
            if(mv == view)
            {
               return;
            }
         }
         this.registeredViews.push(view);
      }
      
      public function resizeViews(changeToFullScreen:Boolean) : void
      {
         var mv:MovieClip = null;
         for each(mv in this.registeredViews)
         {
            if(changeToFullScreen)
            {
               this.changeToVewport(mv,0,0,1,1);
            }
            else
            {
               this.changeToVewport(mv,this.PIPSCREENX_RATIO,this.PIPSCREENY_RATIO,this.PIPSCREENW_RATIO,this.PIPSCREENH_RATIO);
            }
         }
      }
      
      private function changeToVewport(mv:MovieClip, xratio:Number, yratio:Number, widthratio:Number, heightratio:Number) : void
      {
         var movieClipOrgX:int = 0;
         var movieClipOrgY:int = 0;
         var windowWidthInFlash:int = GameInfo.stageSize.x;
         var windowHeightInFlash:int = GameInfo.stageSize.y;
         var windowXInFlash:int = GameInfo.stagePosition.x;
         var windowYInFlash:int = GameInfo.stagePosition.y;
         var flashLeftTopPositionX_Ratio:Number = (movieClipOrgX - GameInfo.stagePosition.x) / windowWidthInFlash;
         var flashLeftTopPositionY_Ratio:Number = (movieClipOrgY - GameInfo.stagePosition.y) / windowHeightInFlash;
         var pipMovieClipOrgX:int = windowXInFlash + windowWidthInFlash * xratio + windowWidthInFlash * widthratio * flashLeftTopPositionX_Ratio;
         var pipMovieClipOrgY:int = windowYInFlash + windowHeightInFlash * yratio + windowHeightInFlash * heightratio * flashLeftTopPositionY_Ratio;
         var tscalex:Number = widthratio;
         var tscaley:Number = heightratio;
         var posoffsetX:int = pipMovieClipOrgX - movieClipOrgX;
         var posoffsetY:int = pipMovieClipOrgY - movieClipOrgY;
         mv.scaleX = tscalex;
         mv.scaleY = tscaley;
         mv.x = posoffsetX;
         mv.y = posoffsetY;
      }
   }
}

