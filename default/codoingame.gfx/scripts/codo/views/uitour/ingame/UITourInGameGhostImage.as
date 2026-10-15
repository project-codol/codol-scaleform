package codo.views.uitour.ingame
{
   import codo.component.tutorial.TourBaseComponent;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Elastic;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class UITourInGameGhostImage extends TourBaseComponent
   {
      
      public var myMask:Sprite;
      
      private var mStartPosition:Point;
      
      private var mTargetPosition:Point;
      
      private var mTransitionOutDelay:Number = 0;
      
      private var mBypassAnimation:Boolean = false;
      
      public function UITourInGameGhostImage()
      {
         super();
         this.mStartPosition = new Point(441,291);
         this.mTargetPosition = new Point(108,0);
         this.myMask.x = this.mStartPosition.x;
         this.myMask.y = this.mStartPosition.y;
      }
      
      override public function reset() : void
      {
         TweenLite.killTweensOf(this.myMask);
         this.myMask.x = this.mStartPosition.x;
         this.myMask.y = this.mStartPosition.y;
      }
      
      public function set transitionOutDelay(delay:Number) : void
      {
         this.mTransitionOutDelay = delay;
      }
      
      public function set byPassAnimation(doBypass:Boolean) : void
      {
         this.mBypassAnimation = doBypass;
      }
      
      override public function active() : void
      {
         super.active();
         TweenLite.to(this.myMask,0.8,{
            "x":this.mTargetPosition.x,
            "y":this.mTargetPosition.y,
            "ease":Elastic.easeOut
         });
      }
      
      public function hide() : void
      {
         TweenLite.to(this.myMask,0.5,{
            "x":this.mStartPosition.x,
            "y":this.mStartPosition.y,
            "ease":Cubic.easeIn,
            "delay":this.mTransitionOutDelay,
            "onComplete":deactive
         });
      }
   }
}

