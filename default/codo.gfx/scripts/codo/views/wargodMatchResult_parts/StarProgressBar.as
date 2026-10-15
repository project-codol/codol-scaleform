package codo.views.wargodMatchResult_parts
{
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodMatchResultObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import codo.utils.WarGodUtility;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   
   public class StarProgressBar extends WarGodAnimateElement
   {
      
      public static const ANIMATION_PHASE_NOT_STARTED:int = 0;
      
      public static const ANIMATION_PHASE_STAR:int = 1;
      
      public static const ANIMATION_PHASE_WAITING_PROMOTED:int = 2;
      
      public static const ANIMATION_PHASE_WAITING_HV:int = 3;
      
      public static const ANIMATION_PHASE_HV_STAR:int = 4;
      
      public static const ANIMATION_PHASE_FINAL_CORRECTION:int = 5;
      
      public var myHeader:TextField;
      
      private var beforeMatchRank:PlayerWarGodRank;
      
      private var afterMatchRank:PlayerWarGodRank;
      
      private var currentPlayerRank:PlayerWarGodRank;
      
      private var currentRankWrapper:PlayerRankWrapper;
      
      private var uselessRankWrapper:PlayerRankWrapper;
      
      private var numStarChangeDueToResult:int;
      
      private var numStarChangeDueToHV:int;
      
      private var numRemainStarChangeDueToResult:int;
      
      private var numRemainStarChangeDueToHV:int;
      
      private var animationPhase:int = 0;
      
      public function StarProgressBar()
      {
         super();
         this.myHeader.text = LocalizeUtil.localize("@UI_WARGOD_HERO_VALUE_PROGRESS");
      }
      
      override public function startAni() : void
      {
         super.startAni();
         TweenLite.to(this,0.5,{"alpha":1});
         SoundUtil.getInstance().playSound("ui_wgmr_start_rank_appear");
      }
      
      public function setData(result:WarGodMatchResultObj) : void
      {
         this.beforeMatchRank = result.beforeRank;
         this.afterMatchRank = result.afterRank;
         this.numRemainStarChangeDueToResult = this.numStarChangeDueToResult = result.numStarChangeDueToResult;
         this.numRemainStarChangeDueToHV = this.numStarChangeDueToHV = result.numStarChangeDueToHV;
         this.layoutCurrentPlayerRank(this.beforeMatchRank);
         mSoundEffect = "ui_star_match_appear";
      }
      
      public function getAnimationPhase() : int
      {
         return this.animationPhase;
      }
      
      private function layoutCurrentPlayerRank(rank:PlayerWarGodRank) : void
      {
         if(Boolean(this.currentRankWrapper) && Boolean(this.currentRankWrapper.parent))
         {
            this.currentRankWrapper.parent.removeChild(this.currentRankWrapper);
         }
         this.currentRankWrapper = new PlayerRankWrapper();
         this.currentRankWrapper.init();
         this.currentRankWrapper.setRank(rank);
         this.currentRankWrapper.alpha = 1;
         addChild(this.currentRankWrapper);
      }
      
      public function setAnimationPhase(phase:int) : void
      {
         this.animationPhase = phase;
      }
      
      public function playAnimationByPresetData() : void
      {
         this.currentPlayerRank = this.beforeMatchRank;
         this.realStartStarAnimation();
      }
      
      public function tryContinueAnimation() : void
      {
         if(this.numRemainStarChangeDueToResult > 0)
         {
            this.currentPlayerRank = WarGodUtility.incrementStar(this.currentPlayerRank);
            this.currentPlayerRank = WarGodUtility.decreamentStar(this.currentPlayerRank);
            this.layoutCurrentPlayerRank(this.currentPlayerRank);
            this.realStartStarAnimation();
         }
      }
      
      public function tryContinueHVStarAnimation(forceLayout:Boolean = false) : void
      {
         if(this.numRemainStarChangeDueToHV > 0)
         {
            if(forceLayout)
            {
               this.currentPlayerRank = WarGodUtility.incrementStar(this.currentPlayerRank);
               this.currentPlayerRank = WarGodUtility.decreamentStar(this.currentPlayerRank);
               this.layoutCurrentPlayerRank(this.currentPlayerRank);
            }
            this.setAnimationPhase(ANIMATION_PHASE_HV_STAR);
            this.playRewardStarAnimation(this.numRemainStarChangeDueToHV);
         }
         else if(this.needFinalCorrection())
         {
            this.setAnimationPhase(ANIMATION_PHASE_FINAL_CORRECTION);
            this.onStarChangeAnimationPaused();
            this.layoutCurrentPlayerRank(this.afterMatchRank);
         }
         else
         {
            this.onStarChangeAnimationCompleted();
         }
      }
      
      private function needFinalCorrection() : Boolean
      {
         if(!WarGodUtility.rankEqual(this.currentPlayerRank,this.afterMatchRank))
         {
            if(this.currentPlayerRank.tier != this.afterMatchRank.tier || this.currentPlayerRank.division != this.afterMatchRank.division)
            {
               return true;
            }
         }
         return false;
      }
      
      private function realStartStarAnimation() : void
      {
         if(this.numRemainStarChangeDueToResult > 0)
         {
            this.setAnimationPhase(ANIMATION_PHASE_STAR);
            this.playRewardStarAnimation(this.numRemainStarChangeDueToResult);
         }
         else if(this.numRemainStarChangeDueToResult < 0)
         {
            this.setAnimationPhase(ANIMATION_PHASE_STAR);
            this.playDeductStarAnimation(Math.abs(this.numRemainStarChangeDueToResult));
         }
         else
         {
            this.setAnimationPhase(ANIMATION_PHASE_WAITING_HV);
            this.onStarChangeAnimationPaused();
         }
      }
      
      public function getCurrentRank() : PlayerWarGodRank
      {
         return this.currentPlayerRank;
      }
      
      private function onStarChangeAnimationPaused() : void
      {
         pause();
      }
      
      private function onStarChangeAnimationCompleted() : void
      {
         this.setAnimationPhase(ANIMATION_PHASE_NOT_STARTED);
         complete();
      }
      
      private function playRewardStarAnimation(count:int) : void
      {
         var keptPlayerRank:PlayerWarGodRank = null;
         var animateStar:AnimateStar = null;
         var durationForNow:Number = NaN;
         var starIndex:int = 0;
         var timeline:TimelineLite = new TimelineLite();
         var pausedByPromotedAnimation:Boolean = false;
         for(var i:int = 0; i < count; i++)
         {
            keptPlayerRank = this.currentPlayerRank;
            this.currentPlayerRank = WarGodUtility.incrementStar(this.currentPlayerRank);
            if(!(keptPlayerRank.tier == this.currentPlayerRank.tier && keptPlayerRank.division == this.currentPlayerRank.division && keptPlayerRank.star != this.currentPlayerRank.star))
            {
               this.currentPlayerRank = keptPlayerRank;
               durationForNow = timeline.duration;
               for(starIndex = 0; starIndex < this.currentPlayerRank.star; starIndex++)
               {
                  animateStar = this.currentRankWrapper.getStarByIndex(starIndex);
                  timeline.insert(animateStar.playShineStar(),durationForNow);
               }
               pausedByPromotedAnimation = true;
               break;
            }
            if(this.currentPlayerRank.tier != PlayerWarGodRank.TIER_HEROIC)
            {
               animateStar = this.currentRankWrapper.getStarByIndex(this.currentPlayerRank.star - 1);
               timeline.append(animateStar.playRewardStarAnimation());
            }
            else
            {
               timeline.append(this.currentRankWrapper.myHeroicMeter.playStarChangeAnimation(this.currentPlayerRank.star));
            }
            if(this.numRemainStarChangeDueToResult > 0)
            {
               --this.numRemainStarChangeDueToResult;
            }
            else if(this.numRemainStarChangeDueToHV > 0)
            {
               --this.numRemainStarChangeDueToHV;
            }
         }
         if(pausedByPromotedAnimation)
         {
            this.setAnimationPhase(ANIMATION_PHASE_WAITING_PROMOTED);
            timeline.append(TweenLite.to(this,0.5,{"onComplete":this.onStarChangeAnimationPaused}));
         }
         else if(this.animationPhase == ANIMATION_PHASE_HV_STAR)
         {
            timeline.append(TweenLite.to(this,0.5,{"onComplete":this.onStarChangeAnimationCompleted}));
         }
         else
         {
            this.setAnimationPhase(ANIMATION_PHASE_WAITING_HV);
            timeline.append(TweenLite.to(this,0.5,{"onComplete":this.onStarChangeAnimationPaused}));
         }
      }
      
      public function playDeductStarAnimation(count:int) : void
      {
         var timeline:TimelineLite = null;
         var tempPlayerRank:PlayerWarGodRank = null;
         var keptPlayerRank:PlayerWarGodRank = null;
         var animateStar:AnimateStar = null;
         var rankWrapper:PlayerRankWrapper = null;
         var tweens:Array = null;
         timeline = new TimelineLite();
         for(var i:int = 0; i < count; i++)
         {
            if(count > 0)
            {
               ++this.numRemainStarChangeDueToResult;
            }
            tempPlayerRank = this.currentPlayerRank;
            keptPlayerRank = this.currentPlayerRank;
            this.currentPlayerRank = WarGodUtility.decreamentStar(this.currentPlayerRank);
            if(keptPlayerRank.tier == this.currentPlayerRank.tier && keptPlayerRank.division == this.currentPlayerRank.division && keptPlayerRank.star != this.currentPlayerRank.star)
            {
               if(this.currentPlayerRank.tier == PlayerWarGodRank.TIER_HEROIC)
               {
                  timeline.append(this.currentRankWrapper.myHeroicMeter.playStarChangeAnimation(this.currentPlayerRank.star));
               }
               else
               {
                  animateStar = this.currentRankWrapper.getStarByIndex(tempPlayerRank.star - 1);
                  timeline.append(animateStar.playDeductStarAnimation());
               }
            }
            else
            {
               rankWrapper = new PlayerRankWrapper();
               rankWrapper.init();
               rankWrapper.alpha = 0;
               rankWrapper.setRank(this.currentPlayerRank,1);
               animateStar = rankWrapper.getStarByIndex(4);
               addChild(rankWrapper);
               tweens = [TweenLite.to(this.currentRankWrapper,0.3,{
                  "alpha":0,
                  "onComplete":this.onTransferComplete
               }),TweenLite.to(rankWrapper,0.3,{"alpha":1})];
               this.uselessRankWrapper = this.currentRankWrapper;
               this.currentRankWrapper = rankWrapper;
               timeline.appendMultiple(tweens,0.5);
               if(this.currentPlayerRank.star != 5)
               {
                  timeline.append(animateStar.playDeductStarAnimation(true));
               }
            }
         }
         timeline.append(TweenLite.to(this,0.5,{"onComplete":this.onStarChangeAnimationPaused}));
         this.setAnimationPhase(ANIMATION_PHASE_WAITING_HV);
      }
      
      public function remainHVStarAnimationOnly() : Boolean
      {
         return this.numRemainStarChangeDueToHV > 0 && this.numRemainStarChangeDueToResult == 0;
      }
      
      private function onTransferComplete() : void
      {
         if(this.uselessRankWrapper.parent != null)
         {
            removeChild(this.uselessRankWrapper);
         }
      }
   }
}

import codo.objects.PlayerWarGodRank;
import codo.utils.WarGodUtility;
import codo.views.wargodMatchResult_parts.AnimateStar;
import codo.views.wargodMatchResult_parts.MatchResultHeroicMeter;
import codo.views.wargod_parts.DivisionMeter;
import codo.views.wargod_parts.TierMeter;
import flash.display.MovieClip;
import flash.utils.getDefinitionByName;

class PlayerRankWrapper extends MovieClip
{
   
   private static const TIER_STAR_OFFSET_X:int = 75;
   
   private static const STAR_Y:int = 11;
   
   public var myTier:TierMeter;
   
   public var myDivision:DivisionMeter;
   
   public var myStars:Vector.<AnimateStar>;
   
   public var myHeroicMeter:MatchResultHeroicMeter;
   
   public function PlayerRankWrapper()
   {
      super();
   }
   
   public function init() : void
   {
      var cls:Class = null;
      var aStar:AnimateStar = null;
      cls = getDefinitionByName("codo.wargod.tierMeter") as Class;
      this.myTier = new cls() as TierMeter;
      cls = getDefinitionByName("codo.wargod.divisionMeter") as Class;
      this.myDivision = new cls() as DivisionMeter;
      this.myStars = new Vector.<AnimateStar>();
      cls = getDefinitionByName("codo.wargod.result.animatestar") as Class;
      for(var i:int = 0; i < 5; i++)
      {
         aStar = new cls() as AnimateStar;
         this.myStars.push(aStar);
      }
      cls = getDefinitionByName("codo.wargod.result.matchresultheroicmeter") as Class;
      this.myHeroicMeter = new cls() as MatchResultHeroicMeter;
      this.myTier.x = -47;
      this.myTier.y = -27;
      this.myDivision.x = 130;
      this.myDivision.y = 105;
      addChild(this.myTier);
      addChild(this.myDivision);
      addChild(this.myHeroicMeter);
      this.myHeroicMeter.x = 240;
      var curX:Number = this.myDivision.x + TIER_STAR_OFFSET_X;
      for(i = 0; i < 5; i++)
      {
         this.myStars[i].x = curX;
         this.myStars[i].y = STAR_Y;
         addChild(this.myStars[i]);
         curX += this.myStars[i].width;
      }
   }
   
   public function setRank(rank:PlayerWarGodRank, starCountAdjust:int = 0) : void
   {
      var numStar:int = 0;
      var numStarForUpgrade:int = 0;
      this.myTier.setData(rank.tier);
      var i:int = 0;
      if(rank.tier == PlayerWarGodRank.TIER_HEROIC)
      {
         this.myTier.visible = false;
         this.myDivision.visible = false;
         this.myHeroicMeter.visible = true;
         this.myHeroicMeter.setPlayerRank(rank);
         for(i = 0; i < 5; i++)
         {
            this.myStars[i].switchStar(i < numStar);
            this.myStars[i].visible = false;
         }
      }
      else
      {
         this.myHeroicMeter.visible = false;
         this.myTier.visible = true;
         this.myDivision.visible = true;
         this.myDivision.setData(true,rank.division);
         numStar = rank.star;
         numStar += starCountAdjust;
         numStarForUpgrade = WarGodUtility.getNumStarForUpgrade(rank.tier);
         for(i = 0; i < 5; i++)
         {
            if(i < numStarForUpgrade)
            {
               this.myStars[i].switchStar(i < numStar);
               this.myStars[i].visible = true;
            }
            else
            {
               this.myStars[i].visible = false;
            }
         }
      }
   }
   
   public function getStarByIndex(index:int) : AnimateStar
   {
      return this.myStars[index];
   }
}
