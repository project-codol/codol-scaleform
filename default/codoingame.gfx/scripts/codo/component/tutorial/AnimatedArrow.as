package codo.component.tutorial
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AnimatedArrow extends TourBaseComponent
   {
      
      private static const ARROW_REPLAY_LOOP:uint = 10000;
      
      public var myArrowTop:Sprite;
      
      public var myArrowMid:Sprite;
      
      public var myArrowBottom:Sprite;
      
      public var myAnimatedGlow:MovieClip;
      
      private var mReplayTimer:Timer;
      
      public function AnimatedArrow()
      {
         super();
         mouseEnabled = mouseChildren = false;
         visible = false;
      }
      
      override public function active() : void
      {
         super.active();
         this.mReplayTimer = new Timer(ARROW_REPLAY_LOOP);
         this.mReplayTimer.addEventListener(TimerEvent.TIMER,this.animateArrow);
         this.animateArrow();
      }
      
      override public function deactive() : void
      {
         super.deactive();
         if(this.mReplayTimer != null)
         {
            this.mReplayTimer.stop();
            this.mReplayTimer.removeEventListener(TimerEvent.TIMER,this.reset);
            this.mReplayTimer = null;
         }
      }
      
      private function animateArrow(e:TimerEvent = null) : void
      {
         this.reset();
         visible = true;
         this.myAnimatedGlow.alpha = 0;
         var PADDING:uint = 15;
         var midArrowEndY:uint = (this.myArrowTop.height + PADDING) * 0.5;
         var botArrowEndY:uint = midArrowEndY + (this.myArrowMid.height + PADDING) * 0.5;
         mTransitionTimeline = new TimelineLite();
         if(this.myAnimatedGlow != null)
         {
            TweenLite.to(this.myAnimatedGlow,1,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":0.8
            });
         }
         mTransitionTimeline.append(new TweenLite(this.myArrowBottom,0.2,{
            "alpha":0.5,
            "y":botArrowEndY,
            "ease":Cubic.easeOut
         }));
         mTransitionTimeline.append(new TweenLite(this.myArrowMid,0.3,{
            "alpha":0.8,
            "y":midArrowEndY,
            "ease":Cubic.easeOut
         }));
         mTransitionTimeline.append(new TweenLite(this.myArrowTop,0.4,{
            "alpha":1,
            "y":0,
            "ease":Cubic.easeOut,
            "onStart":this.onAnimationStart,
            "onComplete":this.onAnimationComplete
         }));
         mTransitionTimeline.play();
      }
      
      override protected function onAnimationComplete() : void
      {
         if(this.mReplayTimer == null || this.mReplayTimer.currentCount == 0)
         {
            super.onAnimationComplete();
         }
         if(this.myAnimatedGlow != null)
         {
            this.myAnimatedGlow.gotoAndPlay(2);
         }
      }
      
      override protected function onAnimationStart() : void
      {
         if(this.mReplayTimer == null || this.mReplayTimer.currentCount == 0)
         {
            super.onAnimationStart();
         }
      }
      
      override public function reset() : void
      {
         var child:DisplayObject = null;
         var i:uint = 0;
         var len:uint = uint(this.numChildren);
         visible = false;
         super.reset();
         this.myAnimatedGlow.gotoAndStop(1);
         for(this.myArrowBottom.alpha = this.myAnimatedGlow.alpha = 0; i < len; )
         {
            child = getChildAt(i);
            if(child is Sprite && child != this.myAnimatedGlow)
            {
               if(child == this.myArrowBottom)
               {
                  child.y += 40;
               }
               else
               {
                  child.alpha = 0;
                  child.y += 20;
               }
            }
            i++;
         }
      }
   }
}

