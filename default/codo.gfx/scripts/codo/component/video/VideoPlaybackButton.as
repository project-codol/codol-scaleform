package codo.component.video
{
   import codo.component.Button;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class VideoPlaybackButton extends Button
   {
      
      public static var ICON_FRAME_PLAY:int = 1;
      
      public static var ICON_FRAME_PAUSE:int = 2;
      
      public static var ICON_FRAME_STOP:int = 3;
      
      public static var ICON_FRAME_FULLSCREEN:int = 4;
      
      public static var ICON_FRAME_EXIT_FULLSCREEN:int = 5;
      
      public static var ICON_FRAME_REPLAY_VIDEO:int = 6;
      
      private static var ANIM_SCALE:Number = 1.2;
      
      private static var ANIM_SPEED:Number = 0.3;
      
      private static var ANIM_ALPHA:Number = 0.3;
      
      public var myIcon:Sprite;
      
      public var myIconCircle:Sprite;
      
      private var mIconClip:MovieClip;
      
      public function VideoPlaybackButton()
      {
         super();
         this.myIconCircle.alpha = ANIM_ALPHA;
         enabled = false;
         this.mIconClip = this.myIcon.getChildAt(0) as MovieClip;
      }
      
      public function set controlType(type:int) : void
      {
         this.mIconClip.gotoAndStop(type);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         TweenLite.to(this.myIcon,ANIM_SPEED,{
            "scaleX":ANIM_SCALE,
            "scaleY":ANIM_SCALE,
            "overwrite":0
         });
         TweenLite.to(this.myIconCircle,ANIM_SPEED,{
            "alpha":1,
            "scaleX":ANIM_SCALE,
            "scaleY":ANIM_SCALE,
            "delay":0.1,
            "overwrite":1
         });
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         TweenLite.to(this.myIcon,ANIM_SPEED,{
            "scaleX":1,
            "scaleY":1,
            "delay":0.1,
            "overwrite":0
         });
         TweenLite.to(this.myIconCircle,ANIM_SPEED,{
            "alpha":ANIM_ALPHA,
            "scaleX":1,
            "scaleY":1,
            "overwrite":1
         });
      }
      
      public function reset() : void
      {
         this.myIcon.alpha = this.myIconCircle.alpha = 1;
      }
   }
}

