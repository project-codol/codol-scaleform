package codo.views.battlecityLeagueAward_parts
{
   import codo.objects.BattleCityLeagueMatchResultObj;
   import codo.utils.SoundUtil;
   import codo.views.battlecity_parts.BattleCityRewardProgress;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   
   public class BattleCityLeagueAwardProgress extends BattleCityRewardProgress
   {
      
      private static const FILL_DELAY_DURATION:Number = 1;
      
      private static const FILL_DURATION:Number = 0.5;
      
      private static const SHINE_DURATION:Number = 0.4;
      
      public var myBarGlow:MovieClip;
      
      public var myCaseGlow:MovieClip;
      
      private var mBeforeValue:int;
      
      private var mAfterValue:int;
      
      private var mFullValue:int;
      
      private var mRewardPool:int;
      
      private var mCompleteHandler:Function;
      
      private var mFillAnimationTweenLite:TweenLite;
      
      public function BattleCityLeagueAwardProgress()
      {
         super();
         this.myCaseGlow.visible = false;
         this.myBarGlow.visible = false;
      }
      
      public function setData(data:BattleCityLeagueMatchResultObj, completeHandler:Function = null) : void
      {
         this.mBeforeValue = data.beforeProgress;
         this.mAfterValue = data.afterProgress;
         this.mFullValue = data.fullProgress;
         this.mRewardPool = data.rewardPoolType;
         this.mCompleteHandler = completeHandler;
         if(this.mAfterValue > this.mFullValue)
         {
            this.mAfterValue = this.mFullValue;
         }
      }
      
      public function playAnimation() : void
      {
         setProgress(this.mBeforeValue,this.mFullValue);
         var seconds:Number = (this.mAfterValue - this.mBeforeValue) / this.mFullValue * FILL_DURATION;
         this.mFillAnimationTweenLite = TweenLite.to(this,seconds,{
            "delay":FILL_DELAY_DURATION,
            "onStart":this.onFillAnimationStart,
            "onUpdate":this.onFillAnimationUpdate,
            "onComplete":this.onFillAnimationComplete
         });
      }
      
      private function onFillAnimationStart() : void
      {
         SoundUtil.getInstance().playSound("UI_Progress_Up");
      }
      
      private function onFillAnimationUpdate() : void
      {
         var progress:Number = 0;
         if(Boolean(this.mFillAnimationTweenLite) && this.mFillAnimationTweenLite.duration != 0)
         {
            progress = this.mFillAnimationTweenLite.currentTime / this.mFillAnimationTweenLite.duration;
         }
         var animatedValue:Number = this.mBeforeValue + progress * (this.mAfterValue - this.mBeforeValue);
         setProgress(animatedValue,this.mFullValue);
      }
      
      private function onFillAnimationComplete() : void
      {
         SoundUtil.getInstance().stopSound();
         if(this.mAfterValue >= this.mFullValue && this.mRewardPool != BattleCityLeagueMatchResultObj.REWARD_TYPE_UNKNOWN)
         {
            this.playShineAnimation();
         }
         else if(this.mCompleteHandler is Function)
         {
            this.mCompleteHandler(false);
         }
      }
      
      private function playShineAnimation() : void
      {
         this.myCaseGlow.visible = true;
         this.myBarGlow.visible = true;
         this.myCaseGlow.alpha = 0;
         this.myBarGlow.alpha = 0;
         SoundUtil.getInstance().playSound("UI_Progress_Full1");
         TweenMax.to(this.myBarGlow,SHINE_DURATION,{
            "alpha":1,
            "yoyo":true,
            "repeat":1,
            "onComplete":this.onBarAnimationComplete
         });
      }
      
      private function onBarAnimationComplete() : void
      {
         SoundUtil.getInstance().playSound("UI_Progress_Full2");
         TweenMax.to(this.myCaseGlow,SHINE_DURATION,{
            "alpha":1,
            "yoyo":true,
            "repeat":1,
            "onComplete":this.onShineAnimationComplete
         });
      }
      
      public function onShineAnimationComplete() : void
      {
         if(this.mCompleteHandler is Function)
         {
            this.mCompleteHandler(true);
         }
      }
   }
}

