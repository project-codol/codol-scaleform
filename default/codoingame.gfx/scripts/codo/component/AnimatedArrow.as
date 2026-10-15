package codo.component
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class AnimatedArrow extends MovieClip
   {
      
      private static const SLIDE_DURATION:Number = 0.5;
      
      public var myLeftMask:Sprite;
      
      public var myRightMask:Sprite;
      
      public function AnimatedArrow()
      {
         super();
      }
      
      public function show() : void
      {
         TweenLite.killTweensOf(this.myLeftMask);
         TweenLite.killTweensOf(this.myRightMask);
         TweenLite.to(this.myRightMask,SLIDE_DURATION,{"y":-1});
         TweenLite.to(this.myLeftMask,SLIDE_DURATION,{"y":-1});
      }
      
      public function hide() : void
      {
         TweenLite.killTweensOf(this.myLeftMask);
         TweenLite.killTweensOf(this.myRightMask);
         TweenLite.to(this.myRightMask,SLIDE_DURATION,{"y":-21});
         TweenLite.to(this.myLeftMask,SLIDE_DURATION,{"y":19});
      }
   }
}

