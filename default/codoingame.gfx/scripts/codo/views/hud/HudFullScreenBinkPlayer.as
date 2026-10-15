package codo.views.hud
{
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.constants.VideoRender;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import scaleform.gfx.DisplayObjectEx;
   
   public class HudFullScreenBinkPlayer extends HUDPopupComponent
   {
      
      public var myVideoContainer:MovieClip;
      
      public function HudFullScreenBinkPlayer()
      {
         super();
         this.initStage();
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.FULL_SCREEN_BINK_PLAYER;
      }
      
      private function initStage() : void
      {
         var bitmap:Bitmap = null;
         var stageSize:Point = GameInfo.stageSize;
         var stagePos:Point = GameInfo.stagePosition;
         var bitmapData:BitmapData = new BitmapData(stageSize.x,stageSize.y,true,16777215);
         bitmap = new Bitmap(bitmapData);
         this.myVideoContainer = new MovieClip();
         addChild(this.myVideoContainer);
         this.myVideoContainer.x = stagePos.x;
         this.myVideoContainer.y = stagePos.y;
         this.myVideoContainer.addChild(bitmap);
         DisplayObjectEx.setRendererString(this.myVideoContainer,VideoRender.RENDER_WITH_ALPHA);
      }
   }
}

