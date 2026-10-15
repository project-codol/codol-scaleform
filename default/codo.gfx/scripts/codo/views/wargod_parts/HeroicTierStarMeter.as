package codo.views.wargod_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HeroicTierStarMeter extends MovieClip implements IWarGodUIElement
   {
      
      private static const ANIMATION_DURATION_SECOND:int = 2;
      
      private static const MAX_ANIMATION_DURATION_SCORE:int = 100;
      
      private static const SCORE_AREA_X:Number = 282;
      
      private static const SCORE_AREA_WIDTH:Number = 286;
      
      public var myTier:TierMeter;
      
      public var myPromoScore:TextField;
      
      public var myPromoScoreStatic:TextField;
      
      public var myTierName:TextField;
      
      private var mUpdateAnimationTween:TweenLite;
      
      private var mAnimationCompleteHandler:Function;
      
      public function HeroicTierStarMeter()
      {
         super();
         this.myTier.gotoAndStop(12);
         this.myTierName.text = DictWarGod.TIER_HEROIC;
         this.myPromoScoreStatic.text = DictWarGod.PROMOTION_SCORE_STATIC;
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         this.setScore(playerObj.promotionScore);
      }
      
      public function setScore(score:int) : void
      {
         this.myPromoScore.text = score.toString();
         var totalTextWidth:Number = this.myPromoScore.textWidth + this.myPromoScoreStatic.textWidth + 3;
         var offset:Number = (SCORE_AREA_WIDTH - totalTextWidth) * 0.5;
         this.myPromoScore.x = SCORE_AREA_X + offset;
         this.myPromoScoreStatic.x = this.myPromoScore.x + this.myPromoScore.textWidth + 3;
      }
      
      public function playAnimation(startScore:Number, endScore:Number) : void
      {
         var duration:Number = Math.abs(endScore - startScore) / MAX_ANIMATION_DURATION_SCORE * ANIMATION_DURATION_SECOND;
         this.mUpdateAnimationTween = TweenLite.to(this,duration,{
            "onUpdate":this.onUpdateScoreAnim,
            "onUpdateParams":[startScore,endScore],
            "onComplete":this.onUpdateScoreAnimCompleted
         });
      }
      
      private function onUpdateScoreAnim(startScore:Number, endScore:Number) : void
      {
         if(this.mUpdateAnimationTween == null)
         {
            return;
         }
         var progress:Number = this.mUpdateAnimationTween.currentTime / this.mUpdateAnimationTween.totalDuration;
         var totalScore:int = endScore - startScore;
         var currentDeltaScore:int = int(totalScore * progress);
         var currentScore:int = startScore + currentDeltaScore;
         this.setScore(currentScore);
      }
      
      public function registerCompleteHandler(handler:Function) : void
      {
         this.mAnimationCompleteHandler = handler;
      }
      
      private function onUpdateScoreAnimCompleted() : void
      {
         if(this.mAnimationCompleteHandler != null)
         {
            this.mAnimationCompleteHandler(false);
         }
      }
   }
}

