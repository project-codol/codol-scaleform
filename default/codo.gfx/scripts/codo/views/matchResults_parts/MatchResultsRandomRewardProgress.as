package codo.views.matchResults_parts
{
   import codo.common.CFunctionContainer;
   import codo.component.aar.MatchResultsProgressArrowDisplay;
   import codo.localization.DictMatchResults;
   import codo.localization.DictOnBoard;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   public class MatchResultsRandomRewardProgress extends MatchResultProgressBase
   {
      
      public var myArrow:MatchResultsProgressArrowDisplay;
      
      public var myResultGlow:Sprite;
      
      public var myScoreValueBronzeTF:TextField;
      
      public var myScoreValueSilverTF:TextField;
      
      public var myScoreValueGoldTF:TextField;
      
      public var myBarBkg:MovieClip;
      
      public var myBarFillBkg:MovieClip;
      
      private var mCratePulse:TweenMax;
      
      private var mIsPulsing:Boolean = false;
      
      private var mGlower:GlowFilter;
      
      private var mOpenRewardClickCallback:Function;
      
      public function MatchResultsRandomRewardProgress()
      {
         super();
         this.myArrow.hideSep();
         this.mGlower = new GlowFilter(4325368,0.5,16,16);
         if(this.myResultGlow != null)
         {
            this.myResultGlow.alpha = 0;
            this.myResultGlow.visible = false;
         }
         if(inDebugMode)
         {
            this.myArrow.x = myFillBar.x + this.myArrow.width;
            this.configureDisplay(234234);
            this.rewardQuantity = 10;
            resultIcon = "reward_crate_gold";
         }
         this.myScoreValueBronzeTF.alpha = this.myScoreValueSilverTF.alpha = this.myScoreValueGoldTF.alpha = 0.5;
         this.enable = false;
      }
      
      override public function set rewardQuantity(qty:int) : void
      {
         super.rewardQuantity = qty;
         myQuantityTF.text = StringUtil.addZero(qty);
         this.myResultGlow.visible = enable;
         if(enable)
         {
            if(!this.mIsPulsing)
            {
               if(this.mCratePulse == null)
               {
                  this.mCratePulse = new TweenMax(this.myResultGlow,0.5,{
                     "alpha":1,
                     "yoyo":true,
                     "repeat":-1
                  });
               }
               this.mIsPulsing = true;
               this.mCratePulse.play();
            }
         }
         else
         {
            this.mCratePulse = null;
            this.mIsPulsing = false;
            this.myResultGlow.alpha = 0;
         }
      }
      
      public function configureDisplay(rewardScore:int, clickCallBack:Function = null) : void
      {
         var thisTierScore:int = 0;
         var lastTierScore:int = 0;
         var reducedScore:Number = NaN;
         var reducedTarget:Number = NaN;
         var tierProgress:Number = NaN;
         var offset:int = 0;
         var pos:int = 0;
         if(inDebugMode)
         {
            progress = 0.5;
            this.myArrow.setProgressValDisplay(rewardScore,0,"POINTS");
            this.myArrow.orientLeft();
            return;
         }
         var NUM_TIERS:int = 3;
         var scoreBronze:int = 0;
         var scoreSilver:int = 0;
         var scoreGold:int = 0;
         var tier:int = CFunctionContainer.AS_GetAARRandomRewardTier();
         var tierScores:Array = CFunctionContainer.AS_GetScoresForCurrentMode();
         if(null == tierScores || tierScores.length != 3)
         {
            trace("TREASURE BOX NOT SETUP CORRECTLY");
            return;
         }
         scoreBronze = int(tierScores[0]);
         scoreSilver = int(tierScores[1]);
         scoreGold = int(tierScores[2]);
         this.myScoreValueBronzeTF.text = scoreBronze.toString();
         this.myScoreValueSilverTF.text = scoreSilver.toString();
         this.myScoreValueGoldTF.text = scoreGold.toString();
         this.myScoreValueBronzeTF.alpha = rewardScore >= scoreBronze ? 1 : 0.5;
         this.myScoreValueSilverTF.alpha = rewardScore >= scoreSilver ? 1 : 0.5;
         this.myScoreValueGoldTF.alpha = rewardScore >= scoreGold ? 1 : 0.5;
         this.setTierDropBoxIcon(tier);
         this.myArrow.setProgressValDisplay(rewardScore,0,LocalizeUtil.localize(DictOnBoard.ONBOARD_TRAINING_RESULTS_POINTS));
         this.mOpenRewardClickCallback = clickCallBack;
         var totalProgress:Number = 0;
         var tierSplit:Number = 1 / NUM_TIERS;
         var scoreRemainder:Number = rewardScore;
         for(var i:int = 0; i < NUM_TIERS; i++)
         {
            thisTierScore = int(tierScores[i]);
            lastTierScore = i > 0 ? int(tierScores[i - 1]) : 0;
            if(rewardScore < thisTierScore)
            {
               reducedScore = rewardScore - lastTierScore;
               reducedTarget = thisTierScore - lastTierScore;
               tierProgress = reducedScore / reducedTarget;
               totalProgress += tierProgress * tierSplit;
               break;
            }
            totalProgress += tierSplit;
         }
         setCopy(LocalizeUtil.localize("@SF_UI_TREASURE_BOX_PRIZES"),LocalizeUtil.param(DictMatchResults.RANDOM_REWARD_DESCRIPTION,[rewardScore]));
         progress = totalProgress;
         if(totalProgress < 1)
         {
            offset = myFillBar.x + myFillBar.width;
            pos = myFillBar.x + this.myArrow.width;
            if(pos > offset)
            {
               this.myArrow.orientLeft();
            }
            this.myArrow.x = offset;
            this.myArrow.visible = true;
         }
         else
         {
            this.myArrow.visible = false;
         }
      }
      
      public function configureDisplayHeroOps(clickCallBack:Function = null) : void
      {
         this.mOpenRewardClickCallback = clickCallBack;
         this.myArrow.visible = this.myScoreValueBronzeTF.visible = this.myScoreValueSilverTF.visible = this.myScoreValueGoldTF.visible = this.myBarBkg.visible = false;
         this.myBarFillBkg.gotoAndStop(2);
         setCopy(LocalizeUtil.localize("@SF_UI_TREASURE_BOX_PRIZES"),"");
         progress = 1;
         resultIcon = "reward_crate_bronze";
      }
      
      private function setTierDropBoxIcon(tier:int) : void
      {
         switch(tier)
         {
            case 1:
               resultIcon = "reward_crate_silver";
               break;
            case 2:
               resultIcon = "reward_crate_gold";
               break;
            case 3:
               resultIcon = "reward_crate_purple";
               break;
            default:
               resultIcon = "reward_crate_bronze";
         }
      }
      
      override protected function onClickHandler(e:MouseEvent) : void
      {
         if(enable)
         {
            this.mOpenRewardClickCallback();
         }
      }
      
      override public function set enable(value:Boolean) : void
      {
         super.enable = value;
         myHitArea.visible = value;
      }
   }
}

