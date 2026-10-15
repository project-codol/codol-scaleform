package codo.views.wargod_parts
{
   import codo.objects.PlayerWarGodRank;
   import codo.utils.SoundUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SeniorPromotionScoreMeter extends MovieClip
   {
      
      private static const ANIMATION_DURATION_SECOND:int = 2;
      
      private static const FULL_MASK_WIDTH:Number = 609;
      
      public var myLabel:TextField;
      
      public var myMask:MovieClip;
      
      public var myHeadMark:MovieClip;
      
      public var myFullAnimation:MovieClip;
      
      public var myHeadLight:MovieClip;
      
      private var mAnimationTween:TweenLite;
      
      private var mAnimationStartValue:int;
      
      private var mAnimationEndValue:int;
      
      private var mAnimationThreshould:int;
      
      private var mAnimationCurrentRank:PlayerWarGodRank;
      
      private var mAnimationCompleteHandler:Function;
      
      public function SeniorPromotionScoreMeter()
      {
         super();
      }
      
      public function setCustomizedLabel(label:TextField) : void
      {
         this.myLabel.visible = false;
         this.myLabel = label;
         this.myLabel.visible = true;
      }
      
      public function setProgress(value:int, threshold:int) : void
      {
         var progress:Number = value / threshold;
         if(progress < 0)
         {
            progress = 0;
         }
         if(progress > 1)
         {
            progress = 1;
         }
         this.myMask.width = progress * FULL_MASK_WIDTH;
         this.myHeadMark.x = this.myMask.x + this.myMask.width;
         this.myHeadLight.x = this.myMask.x + this.myMask.width - this.myHeadLight.width;
         if(progress < 0.1)
         {
            this.myHeadLight.alpha = 0;
         }
         else if(progress < 0.3)
         {
            this.myHeadLight.alpha = 1 - (0.3 - progress) / (0.3 - 0.1);
         }
         else
         {
            this.myHeadLight.alpha = 1;
         }
         this.myLabel.text = String(value) + "/" + String(threshold);
      }
      
      public function playAnimation(startValue:int, endValue:int, threshold:int) : void
      {
         if(null != this.mAnimationTween)
         {
            this.mAnimationTween.kill();
            this.myFullAnimation.gotoAndStop(1);
         }
         this.mAnimationStartValue = startValue;
         this.mAnimationEndValue = endValue;
         this.mAnimationThreshould = threshold;
         this.setProgress(startValue,threshold);
         var duration:Number = Math.abs(endValue - startValue) / threshold * ANIMATION_DURATION_SECOND;
         this.mAnimationTween = TweenLite.to(this,duration,{
            "onUpdate":this.animationProgressHandler,
            "onComplete":this.animationCompleteHandler
         });
         SoundUtil.getInstance().playSound("ui_wgmr_countup_lp");
      }
      
      public function setRank(rank:PlayerWarGodRank) : void
      {
         this.mAnimationCurrentRank = rank;
      }
      
      public function getRank() : PlayerWarGodRank
      {
         return this.mAnimationCurrentRank;
      }
      
      public function registerCompleteHandler(handler:Function) : void
      {
         this.mAnimationCompleteHandler = handler;
      }
      
      private function animationProgressHandler() : void
      {
         var progress:Number = 0;
         if(Boolean(this.mAnimationTween) && this.mAnimationTween.duration != 0)
         {
            progress = this.mAnimationTween.currentTime / this.mAnimationTween.duration;
         }
         var currentValue:int = this.mAnimationStartValue + (this.mAnimationEndValue - this.mAnimationStartValue) * progress;
         this.setProgress(currentValue,this.mAnimationThreshould);
      }
      
      private function animationCompleteHandler() : void
      {
         SoundUtil.getInstance().stopSound();
         this.setProgress(this.mAnimationEndValue,this.mAnimationThreshould);
         if(this.mAnimationEndValue >= this.mAnimationThreshould)
         {
            SoundUtil.getInstance().playSound("ui_wgmr_meterfull");
            this.myFullAnimation.gotoAndPlay(1);
         }
         TweenLite.to(this,1,{"onComplete":this.onAnimationComplete});
      }
      
      private function onAnimationComplete() : void
      {
         if(this.mAnimationCompleteHandler is Function)
         {
            this.mAnimationCompleteHandler(this.mAnimationEndValue >= this.mAnimationThreshould);
         }
      }
   }
}

