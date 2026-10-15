package codo.views.wargodMatchResult_parts
{
   import codo.objects.PlayerWarGodRank;
   import codo.objects.PromotionScoreBarParameter;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.PromotionScoreMeter;
   import codo.views.wargod_parts.TierMeter;
   import flash.text.TextField;
   
   public class JuniorWarGodPromotionScoreBar extends WarGodAnimateElement
   {
      
      public var myBeforeRank:TierMeter;
      
      public var myBeforeRankName:TextField;
      
      public var myAfterRank:TierMeter;
      
      public var myAfterRankName:TextField;
      
      public var myProgressTF:TextField;
      
      public var myPromotionScoreMeter:PromotionScoreMeter;
      
      private var mPromotionScoreConfig:Array;
      
      private var mCurrentAnimationIndex:int;
      
      public function JuniorWarGodPromotionScoreBar()
      {
         super();
         this.myPromotionScoreMeter.setCustomizedLabel(this.myProgressTF);
         this.myPromotionScoreMeter.registerCompleteHandler(this.onPromotionScoreMeterAnimationComplete);
      }
      
      public function setData(animationParameter:Array) : void
      {
         this.mPromotionScoreConfig = animationParameter;
      }
      
      override public function startAni() : void
      {
         var psbp:PromotionScoreBarParameter = null;
         super.startAni();
         if(this.mCurrentAnimationIndex < this.mPromotionScoreConfig.length)
         {
            psbp = this.mPromotionScoreConfig[this.mCurrentAnimationIndex];
            this.layout(psbp);
         }
      }
      
      public function playAnimationByPresetData() : void
      {
         this.mCurrentAnimationIndex = 0;
         this.triggerAnimations();
      }
      
      public function getCurrentRank() : PlayerWarGodRank
      {
         return this.myPromotionScoreMeter.getRank();
      }
      
      private function triggerAnimations() : void
      {
         var psbp:PromotionScoreBarParameter = null;
         if(this.mCurrentAnimationIndex < this.mPromotionScoreConfig.length)
         {
            psbp = this.mPromotionScoreConfig[this.mCurrentAnimationIndex];
            this.layout(psbp);
            this.myPromotionScoreMeter.setRank(psbp.prevRank);
            this.myPromotionScoreMeter.playAnimation(psbp.startValue,psbp.endValue,psbp.threshold);
            ++this.mCurrentAnimationIndex;
         }
         else
         {
            this.animationComplete();
         }
      }
      
      public function continueAnimation() : void
      {
         this.triggerAnimations();
      }
      
      private function animationComplete() : void
      {
         complete();
      }
      
      private function animationPaused() : void
      {
         pause();
      }
      
      private function layout(psbp:PromotionScoreBarParameter) : void
      {
         var beforeRank:PlayerWarGodRank = psbp.prevRank;
         var afterRank:PlayerWarGodRank = WarGodUtility.increaseJuniorWarGodDivision(psbp.prevRank);
         this.myBeforeRank.setData(beforeRank.tier);
         this.myBeforeRankName.text = LocalizeUtil.localize(WarGodUtility.getTierName(beforeRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(beforeRank.division));
         this.myAfterRank.setData(afterRank.tier);
         this.myAfterRankName.text = LocalizeUtil.localize(WarGodUtility.getTierName(afterRank.tier)) + " " + LocalizeUtil.localize(WarGodUtility.getDivisionName(afterRank.division));
         this.myPromotionScoreMeter.setProgress(psbp.startValue,psbp.threshold);
      }
      
      private function onPromotionScoreMeterAnimationComplete(isFull:Boolean) : void
      {
         if(isFull)
         {
            this.animationPaused();
         }
         else
         {
            this.triggerAnimations();
         }
      }
   }
}

