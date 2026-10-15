package codo.views.wargod_parts
{
   import codo.objects.PlayerWarGodRank;
   import codo.objects.PromotionScoreBarParameter;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargodMatchResult_parts.WarGodAnimateElement;
   import flash.text.TextField;
   
   public class SeniorWarGodPromotionScoreBar extends WarGodAnimateElement
   {
      
      public var myBeforeRank:TierMeter;
      
      public var myBeforeRankName:TextField;
      
      public var myAfterRank:TierMeter;
      
      public var myAfterRankName:TextField;
      
      public var myProgressTF:TextField;
      
      public var mySeniorPromotionScoreMeter:SeniorPromotionScoreMeter;
      
      public var myHeroicTierStarMeter:HeroicTierStarMeter;
      
      private var mPromotionScoreConfig:Array;
      
      private var mCurrentAnimationIndex:int;
      
      public function SeniorWarGodPromotionScoreBar()
      {
         super();
         this.mySeniorPromotionScoreMeter.setCustomizedLabel(this.myProgressTF);
         this.mySeniorPromotionScoreMeter.registerCompleteHandler(this.onPromotionScoreMeterAnimationComplete);
         this.myHeroicTierStarMeter.registerCompleteHandler(this.onPromotionScoreMeterAnimationComplete);
         this.mySeniorPromotionScoreMeter.visible = false;
         this.myHeroicTierStarMeter.visible = false;
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
         return this.mySeniorPromotionScoreMeter.getRank();
      }
      
      private function triggerAnimations() : void
      {
         var psbp:PromotionScoreBarParameter = null;
         if(this.mCurrentAnimationIndex < this.mPromotionScoreConfig.length)
         {
            psbp = this.mPromotionScoreConfig[this.mCurrentAnimationIndex];
            ++this.mCurrentAnimationIndex;
            this.layout(psbp);
            if(this.mySeniorPromotionScoreMeter.visible)
            {
               this.mySeniorPromotionScoreMeter.setRank(psbp.prevRank);
               this.mySeniorPromotionScoreMeter.playAnimation(psbp.startValue,psbp.endValue,psbp.threshold);
            }
            else
            {
               this.myHeroicTierStarMeter.playAnimation(psbp.startValue,psbp.endValue);
            }
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
         var beforeRank:PlayerWarGodRank = null;
         var afterRank:PlayerWarGodRank = null;
         var compareRes:int = WarGodUtility.compareRank(psbp.prevRank,psbp.rank);
         if(compareRes <= 0)
         {
            if(psbp.prevRank.tier < PlayerWarGodRank.TIER_HEROIC)
            {
               this.myBeforeRank.visible = true;
               this.myBeforeRankName.visible = true;
               this.myAfterRank.visible = true;
               this.myAfterRankName.visible = true;
               this.myProgressTF.visible = true;
               this.mySeniorPromotionScoreMeter.visible = true;
               this.myHeroicTierStarMeter.visible = false;
               beforeRank = psbp.prevRank;
               afterRank = WarGodUtility.increaseSeniorWarGodDivision(psbp.prevRank);
               this.myBeforeRank.setData(beforeRank.tier);
               this.myBeforeRankName.text = LocalizeUtil.localize(WarGodUtility.getTierName(beforeRank.tier));
               if(beforeRank.tier != PlayerWarGodRank.TIER_HEROIC)
               {
                  this.myBeforeRankName.appendText(LocalizeUtil.localize(WarGodUtility.getDivisionName(beforeRank.division)));
               }
               this.myAfterRank.setData(afterRank.tier);
               this.myAfterRankName.text = LocalizeUtil.localize(WarGodUtility.getTierName(afterRank.tier));
               if(afterRank.tier != PlayerWarGodRank.TIER_HEROIC)
               {
                  this.myAfterRankName.appendText(LocalizeUtil.localize(WarGodUtility.getDivisionName(afterRank.division)));
               }
               this.mySeniorPromotionScoreMeter.setProgress(psbp.startValue,psbp.threshold);
            }
            else
            {
               this.myBeforeRank.visible = false;
               this.myBeforeRankName.visible = false;
               this.myAfterRank.visible = false;
               this.myAfterRankName.visible = false;
               this.myProgressTF.visible = false;
               this.mySeniorPromotionScoreMeter.visible = false;
               this.myHeroicTierStarMeter.visible = true;
               this.myHeroicTierStarMeter.setScore(psbp.startValue);
            }
         }
         else if(psbp.prevRank.tier < PlayerWarGodRank.TIER_HEROIC)
         {
            this.myBeforeRank.visible = true;
            this.myBeforeRankName.visible = true;
            this.myAfterRank.visible = true;
            this.myAfterRankName.visible = true;
            this.myProgressTF.visible = true;
            this.mySeniorPromotionScoreMeter.visible = true;
            this.myHeroicTierStarMeter.visible = false;
            beforeRank = WarGodUtility.increaseSeniorWarGodDivision(psbp.rank);
            afterRank = psbp.rank;
            this.myBeforeRank.setData(beforeRank.tier);
            this.myBeforeRankName.text = LocalizeUtil.localize(WarGodUtility.getTierName(beforeRank.tier));
            if(beforeRank.tier != PlayerWarGodRank.TIER_HEROIC)
            {
               this.myBeforeRankName.appendText(LocalizeUtil.localize(WarGodUtility.getDivisionName(beforeRank.division)));
            }
            this.myAfterRank.setData(afterRank.tier);
            this.myAfterRankName.text = LocalizeUtil.localize(WarGodUtility.getTierName(afterRank.tier));
            if(afterRank.tier != PlayerWarGodRank.TIER_HEROIC)
            {
               this.myAfterRankName.appendText(LocalizeUtil.localize(WarGodUtility.getDivisionName(afterRank.division)));
            }
            this.mySeniorPromotionScoreMeter.setProgress(psbp.startValue,psbp.threshold);
         }
         else
         {
            this.myBeforeRank.visible = false;
            this.myBeforeRankName.visible = false;
            this.myAfterRank.visible = false;
            this.myAfterRankName.visible = false;
            this.myProgressTF.visible = false;
            this.mySeniorPromotionScoreMeter.visible = false;
            this.myHeroicTierStarMeter.visible = true;
            this.myHeroicTierStarMeter.setScore(psbp.startValue);
         }
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

