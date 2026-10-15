package codo.views.hudZombieArena
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.VideoRender;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import scaleform.gfx.DisplayObjectEx;
   
   public class ZombieArenaIntro extends MovieClip
   {
      
      public var myVideoContainer:MovieClip;
      
      public function ZombieArenaIntro()
      {
         super();
         this.initStage();
      }
      
      public function initStage() : void
      {
         var bitmapData:BitmapData = new BitmapData(1706,960,true,0);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         this.myVideoContainer = new MovieClip();
         addChild(this.myVideoContainer);
         this.myVideoContainer.addChild(bitmap);
         this.myVideoContainer.mouseChildren = false;
         this.myVideoContainer.mouseEnabled = false;
         this.myVideoContainer.x = -200;
         this.myVideoContainer.y = 0;
         DisplayObjectEx.setRendererString(this.myVideoContainer,VideoRender.RENDER_WITH_ALPHA);
      }
      
      public function playIntro() : void
      {
         CFunctionCommonContainer.playvideo("codo_za_splash",false);
      }
   }
}

