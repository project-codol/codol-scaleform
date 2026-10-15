package components.fsggamemodes_part.tutorial
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.shared.BehaviourClickable;
   
   public class GameModeTutorialVideoControl extends Sprite
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
      
      public var myHitarea:Sprite;
      
      public var myIcon:Sprite;
      
      public var myBkg:Sprite;
      
      private var mClickable:BehaviourClickable;
      
      private var mIconClip:MovieClip;
      
      public function GameModeTutorialVideoControl()
      {
         super();
         this.myBkg.alpha = ANIM_ALPHA;
         this.enable = false;
         this.mIconClip = this.myIcon.getChildAt(0) as MovieClip;
      }
      
      public function get clickable() : BehaviourClickable
      {
         return this.mClickable;
      }
      
      public function set enable(isEnable:Boolean) : void
      {
         this.visible = isEnable;
      }
      
      public function set controlType(type:int) : void
      {
         this.mIconClip.gotoAndStop(type);
      }
      
      public function set useMouseBehaviour(doMouseEvent:Boolean) : void
      {
         if(doMouseEvent)
         {
            this.mClickable = new BehaviourClickable(this.myHitarea);
            this.mClickable.setEnabled(doMouseEvent);
            this.mClickable.addMouseOverCallback(this.onMouseOver);
            this.mClickable.addMouseOutCallback(this.onMouseOut);
         }
      }
      
      public function onMouseOver() : void
      {
         TweenLite.to(this.myIcon,ANIM_SPEED,{
            "scaleX":ANIM_SCALE,
            "scaleY":ANIM_SCALE,
            "overwrite":0
         });
         TweenLite.to(this.myBkg,ANIM_SPEED,{
            "alpha":1,
            "scaleX":ANIM_SCALE,
            "scaleY":ANIM_SCALE,
            "delay":0.1,
            "overwrite":1
         });
      }
      
      public function onMouseOut() : void
      {
         TweenLite.to(this.myIcon,ANIM_SPEED,{
            "scaleX":1,
            "scaleY":1,
            "delay":0.1,
            "overwrite":0
         });
         TweenLite.to(this.myBkg,ANIM_SPEED,{
            "alpha":ANIM_ALPHA,
            "scaleX":1,
            "scaleY":1,
            "overwrite":1
         });
      }
      
      public function set customMouseOverHandler(callback:Function) : void
      {
         if(this.mClickable != null)
         {
            this.mClickable.addMouseOverCallback(callback);
         }
      }
      
      public function set customMouseOutHandler(callback:Function) : void
      {
         if(this.mClickable != null)
         {
            this.mClickable.addMouseOutCallback(callback);
         }
      }
      
      public function set clickCallback(callback:Function) : void
      {
         if(this.mClickable != null)
         {
            this.mClickable.addClickCallback(callback);
            this.mClickable.addDoubleClickCallback(callback);
         }
      }
      
      public function removeClickCallback(callback:Function) : void
      {
         if(this.mClickable != null)
         {
            this.mClickable.removeClickCallback(callback);
            this.mClickable.removeDoubleClickCallback(callback);
         }
      }
   }
}

