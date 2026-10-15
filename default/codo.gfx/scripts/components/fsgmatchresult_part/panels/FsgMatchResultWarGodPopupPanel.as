package components.fsgmatchresult_part.panels
{
   import codo.constants.DataID;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.ResultObj;
   import codo.objects.UnlockItemObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.objects.WarGodPlayerObj;
   import codo.utils.ScaleformUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargodMatchResult_parts.HeroicValueMeterAnimation;
   import codo.views.wargodMatchResult_parts.JuniorWarGodPromotionDetailPanel;
   import codo.views.wargodMatchResult_parts.JuniorWarGodPromotionScoreBar;
   import codo.views.wargodMatchResult_parts.JuniorWarGodResult;
   import codo.views.wargodMatchResult_parts.NoStarResult;
   import codo.views.wargodMatchResult_parts.PlacementProgress;
   import codo.views.wargodMatchResult_parts.PlacementResult;
   import codo.views.wargodMatchResult_parts.PromotionProgress;
   import codo.views.wargodMatchResult_parts.PromotionResult;
   import codo.views.wargodMatchResult_parts.Result;
   import codo.views.wargodMatchResult_parts.SeniorWarGodPromotionDetailPanel;
   import codo.views.wargodMatchResult_parts.StarProgressBar;
   import codo.views.wargodMatchResult_parts.StarToPromotionResult;
   import codo.views.wargodMatchResult_parts.Title;
   import codo.views.wargodMatchResult_parts.WarGodAnimateElement;
   import codo.views.wargodMatchResult_parts.WarGodAnimationTimeLine;
   import codo.views.wargodMatchResult_parts.WarGodMatchResultPromotionPanel;
   import codo.views.wargodMatchResult_parts.WarGodPunishmentStrip;
   import codo.views.wargod_parts.SeniorWarGodPromotionScoreBar;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import flash.geom.Point;
   
   public class FsgMatchResultWarGodPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      private var mGlobalSetting:WarGodGlobalSettingObj;
      
      private var mMatchResult:WarGodMatchResultObj;
      
      private var mAnimationTimeLine:WarGodAnimationTimeLine;
      
      private var mAnimated:Boolean = false;
      
      private var mPromotionAnimationPlaying:Boolean = false;
      
      public var myTitle:Title;
      
      public var myResult:Result;
      
      public var myNoStarResult:NoStarResult;
      
      public var myPlacementProgress:PlacementProgress;
      
      public var myPlacementResult:PlacementResult;
      
      public var myPromotionProgress:PromotionProgress;
      
      public var myPromotionResult:PromotionResult;
      
      public var myStarProgress:StarProgressBar;
      
      public var myStarToPromotionResult:StarToPromotionResult;
      
      public var myHeroicValueMeter:HeroicValueMeterAnimation;
      
      public var myJuniorWarGodResult:JuniorWarGodResult;
      
      public var myJuniorWarGodPromotionScoreBar:JuniorWarGodPromotionScoreBar;
      
      public var myJuniorWarGodPromotionDetailPanel:JuniorWarGodPromotionDetailPanel;
      
      public var mySeniorWarGodPromotionScoreBar:SeniorWarGodPromotionScoreBar;
      
      public var mySeniorWarGodPromotionDetailPanel:SeniorWarGodPromotionDetailPanel;
      
      public var myPunishmentStrip:WarGodPunishmentStrip;
      
      public var myPromoted:WarGodMatchResultPromotionPanel;
      
      private var mFullScreenOpenStateChangeCallback:Function;
      
      private var mRoundAwards:Vector.<UnlockItemObj>;
      
      public function FsgMatchResultWarGodPopupPanel()
      {
         var i:int = 0;
         var rank:PlayerWarGodRank = null;
         var testMatchObj:WarGodMatchObj = null;
         super();
         this.mAnimationTimeLine = new WarGodAnimationTimeLine();
         addChild(this.mAnimationTimeLine);
         this.myTitle.visible = false;
         this.myResult.visible = false;
         this.myNoStarResult.visible = false;
         this.myJuniorWarGodResult.visible = false;
         this.myJuniorWarGodPromotionScoreBar.visible = false;
         this.mySeniorWarGodPromotionScoreBar.visible = false;
         this.myPlacementProgress.visible = false;
         this.myPlacementResult.visible = false;
         this.myPromotionProgress.visible = false;
         this.myPromotionResult.visible = false;
         this.myStarProgress.visible = false;
         this.myStarToPromotionResult.visible = false;
         this.myHeroicValueMeter.visible = false;
         this.myPromoted.visible = false;
         this.myJuniorWarGodPromotionDetailPanel.visible = false;
         this.mySeniorWarGodPromotionDetailPanel.visible = false;
         this.myPunishmentStrip.visible = false;
         this.myPromoted.registerStateChangeCallback(this.onPromotedStateChangeCallback);
         this.mGlobalSetting = getDP(DataID.WARGOD_GLOBAL_SETTING);
         if(!ScaleformUtil.isScaleform)
         {
            this.mGlobalSetting = new WarGodGlobalSettingObj();
            this.mGlobalSetting.hvExchangeRate = [50,75,100,150,200,300];
            this.mGlobalSetting.hvProtectionRate = [15,30,40,60,80,120];
            this.mGlobalSetting.promotionScore = [100,200,200,200,200,200,300,300,300,400,400,400,600,600,600,800,800,800];
            this.mGlobalSetting.seniorWargodPromotionScore = [100,200,200,200,200,200,300,300,300,400,400,400,600,600,600,800,800,800];
            this.mMatchResult = new WarGodMatchResultObj();
            this.mMatchResult.numPlacementComplete = 6;
            this.mMatchResult.numPromotionComplete = 2;
            this.mMatchResult.beforeScore = 0;
            this.mMatchResult.beforePhase = WarGodPlayerObj.PHASE_STAR;
            this.mMatchResult.result = WarGodMatchObj.RESULT_WIN;
            this.mMatchResult.numStarChangeDueToResult = 3;
            this.mMatchResult.numStarChangeDueToHV = 1;
            this.mMatchResult.beforeHV = 20;
            this.mMatchResult.HVGainLose = 30;
            this.mMatchResult.afterScore = 100;
            this.mMatchResult.afterPhase = WarGodPlayerObj.PHASE_STAR;
            this.mMatchResult.beforePromotionScore = 95;
            this.mMatchResult.afterPromotionScore = 102;
            this.mMatchResult.matchResultFromDvar = [10,-10,0,0,8,10,1290,3000];
            this.mMatchResult.hasPunishment = true;
            this.mMatchResult.matchHistroy = [];
            for(i = 0; i < 10; i++)
            {
               testMatchObj = new WarGodMatchObj();
               testMatchObj.isWinner = 1;
               this.mMatchResult.matchHistroy.push(testMatchObj);
            }
            this.mMatchResult.numMatchHistroy = 10;
            rank = new PlayerWarGodRank();
            rank.tier = 1;
            rank.division = 1;
            rank.star = 3;
            this.mMatchResult.beforeRank = rank;
            rank = new PlayerWarGodRank();
            rank.tier = 1;
            rank.division = 2;
            rank.star = 1;
            this.mMatchResult.afterRank = rank;
         }
      }
      
      override public function setData(data:*) : void
      {
         this.mMatchResult = data;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.LOBBY_SUMMARY_ROUNDAWARD,this.bind_lobbysummaryRoundAward);
         if(this.mAnimated)
         {
            return;
         }
         this.mAnimated = true;
         if(this.mMatchResult.beforePhase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            this.processPlacementPhase();
         }
         else if(this.mMatchResult.beforePhase == WarGodPlayerObj.PHASE_STAR)
         {
            if(WarGodUtility.isJuniorWarGodByScore(this.mMatchResult.beforeScore))
            {
               this.processJuniorWarGodStarPhase();
            }
            else
            {
               this.processStarPhase();
            }
         }
         else if(this.mMatchResult.beforePhase == WarGodPlayerObj.PHASE_PROMOTION)
         {
            this.processPromotionPhase();
         }
         this.positionPromotedPopup();
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.LOBBY_SUMMARY_ROUNDAWARD,this.bind_lobbysummaryRoundAward);
      }
      
      private function bind_lobbysummaryRoundAward(result:ResultObj) : void
      {
         this.mRoundAwards = result.data;
      }
      
      public function registerFullScreenOpenStateCallback(callback:Function) : void
      {
         this.mFullScreenOpenStateChangeCallback = callback;
      }
      
      public function playingPromotionAnimation() : Boolean
      {
         return this.mPromotionAnimationPlaying;
      }
      
      private function positionPromotedPopup() : void
      {
         var stageOriginal:Point = globalToLocal(new Point(0,0));
         this.myPromoted.x = stageOriginal.x;
         this.myPromoted.y = stageOriginal.y;
      }
      
      private function processPlacementPhase() : void
      {
         this.myTitle.setText(WarGodUtility.getPhaseName(this.mMatchResult.beforePhase));
         this.mAnimationTimeLine.add(this.myTitle,0);
         this.myNoStarResult.setResult(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myNoStarResult,1);
         this.myPunishmentStrip.setData(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myPunishmentStrip,1);
         this.myPlacementProgress.setData(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myPlacementProgress,0.5);
         if(this.mMatchResult.numPlacementComplete == 6)
         {
            this.myPromoted.setRank(this.mMatchResult.afterRank.tier,this.mMatchResult.afterRank.division);
            this.myPromoted.setUserName(ScaleformUtil.isScaleform ? getDP(DataID.PLAYER_USER_NAME) : "Call of Duty Online");
            this.mAnimationTimeLine.add(this.myPromoted,4);
         }
         this.mAnimationTimeLine.start();
      }
      
      private function processJuniorWarGodStarPhase() : void
      {
         var scoreDifference:int = 0;
         this.mAnimationTimeLine.registerSubElementComplete(this.onJuniorWarGodSubElementAnimationComplete);
         this.mAnimationTimeLine.registerSubElementPause(this.onJuniorWarGodSubElementAnimationPause);
         this.myTitle.setText(WarGodUtility.getPhaseName(this.mMatchResult.beforePhase));
         this.mAnimationTimeLine.add(this.myTitle,0);
         this.myPunishmentStrip.setData(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myPunishmentStrip,2);
         var scoreBarAnimationParameters:Array = new Array();
         scoreDifference = WarGodUtility.getJuniorWarGodPromotionScoreBarParameter(this.mMatchResult,scoreBarAnimationParameters);
         this.myJuniorWarGodPromotionScoreBar.setData(scoreBarAnimationParameters);
         this.mAnimationTimeLine.add(this.myJuniorWarGodPromotionScoreBar,1);
         this.myPunishmentStrip.setData(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myPunishmentStrip,1);
         this.myJuniorWarGodResult.setData(this.mMatchResult);
         this.myJuniorWarGodResult.setScoreDifference(scoreDifference);
         this.mAnimationTimeLine.add(this.myJuniorWarGodResult,0.5);
         this.mAnimationTimeLine.addBehindElement(this.myPromoted,null);
         this.myJuniorWarGodPromotionDetailPanel.setData(this.mMatchResult,this.mRoundAwards);
         this.mAnimationTimeLine.addBehindElement(this.myJuniorWarGodPromotionDetailPanel,this.myJuniorWarGodPromotionScoreBar);
         this.mAnimationTimeLine.start();
      }
      
      private function processStarPhase() : void
      {
         var scoreDifference:int = 0;
         this.mAnimationTimeLine.registerSubElementComplete(this.onStarPhaseSubElementAnimationComplete);
         this.mAnimationTimeLine.registerSubElementPause(this.onStarPhaseSubElementAnimationPause);
         this.myTitle.setText(WarGodUtility.getPhaseName(this.mMatchResult.beforePhase));
         this.mAnimationTimeLine.add(this.myTitle,0);
         var scoreBarAnimationParameters:Array = new Array();
         scoreDifference = WarGodUtility.getSeniorWarGodPromotionScoreBarParamater(this.mMatchResult,scoreBarAnimationParameters);
         this.mySeniorWarGodPromotionScoreBar.setData(scoreBarAnimationParameters);
         this.mAnimationTimeLine.add(this.mySeniorWarGodPromotionScoreBar,1);
         this.myJuniorWarGodResult.setData(this.mMatchResult);
         this.myJuniorWarGodResult.setScoreDifference(scoreDifference);
         this.mAnimationTimeLine.add(this.myJuniorWarGodResult,0.5);
         this.mAnimationTimeLine.addBehindElement(this.myPromoted,null);
         this.mySeniorWarGodPromotionDetailPanel.setData(this.mMatchResult,this.mRoundAwards);
         this.mAnimationTimeLine.addBehindElement(this.mySeniorWarGodPromotionDetailPanel,this.mySeniorWarGodPromotionScoreBar);
         this.mAnimationTimeLine.start();
      }
      
      private function onJuniorWarGodSubElementAnimationPause(element:WarGodAnimateElement) : void
      {
         var currentRank:PlayerWarGodRank = null;
         var newRank:PlayerWarGodRank = null;
         if(element == this.myJuniorWarGodPromotionScoreBar)
         {
            currentRank = this.myJuniorWarGodPromotionScoreBar.getCurrentRank();
            this.myPromoted.setOldRank(currentRank.tier,currentRank.division);
            newRank = WarGodUtility.increaseJuniorWarGodDivision(currentRank);
            this.myPromoted.setRank(newRank.tier,newRank.division);
            this.myPromoted.setUserName(ScaleformUtil.isScaleform ? getDP(DataID.PLAYER_USER_NAME) : "Call of Duty Online");
            this.mAnimationTimeLine.manualTriggerAni(this.myPromoted);
         }
      }
      
      private function onJuniorWarGodSubElementAnimationComplete(element:WarGodAnimateElement) : void
      {
         if(element == this.myJuniorWarGodResult)
         {
            this.myJuniorWarGodPromotionScoreBar.playAnimationByPresetData();
         }
         else if(element == this.myPromoted)
         {
            this.myJuniorWarGodPromotionScoreBar.continueAnimation();
         }
      }
      
      private function onStarPhaseSubElementAnimationPause(element:WarGodAnimateElement) : void
      {
         var currentRank:PlayerWarGodRank = null;
         var newRank:PlayerWarGodRank = null;
         if(element == this.mySeniorWarGodPromotionScoreBar)
         {
            currentRank = this.mySeniorWarGodPromotionScoreBar.getCurrentRank();
            this.myPromoted.setOldRank(currentRank.tier,currentRank.division);
            newRank = WarGodUtility.increaseSeniorWarGodDivision(currentRank);
            this.myPromoted.setRank(newRank.tier,newRank.division);
            this.myPromoted.setUserName(ScaleformUtil.isScaleform ? getDP(DataID.PLAYER_USER_NAME) : "Call of Duty Online");
            this.mAnimationTimeLine.manualTriggerAni(this.myPromoted);
         }
      }
      
      private function onStarPhaseSubElementAnimationComplete(element:WarGodAnimateElement) : void
      {
         switch(element)
         {
            case this.myJuniorWarGodResult:
               this.mySeniorWarGodPromotionScoreBar.playAnimationByPresetData();
               break;
            case this.myPromoted:
               this.mySeniorWarGodPromotionScoreBar.continueAnimation();
         }
      }
      
      private function processPromotionPhase() : void
      {
         this.myTitle.setText(WarGodUtility.getPhaseName(this.mMatchResult.beforePhase));
         this.mAnimationTimeLine.add(this.myTitle,0);
         this.myNoStarResult.setResult(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myNoStarResult,1);
         this.myPromotionProgress.setData(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myPromotionProgress,2);
         this.myPunishmentStrip.setData(this.mMatchResult);
         this.mAnimationTimeLine.add(this.myPunishmentStrip,1);
         if(this.mMatchResult.beforeRank.tier != this.mMatchResult.afterRank.tier)
         {
            if(this.mMatchResult.afterRank.tier > this.mMatchResult.beforeRank.tier)
            {
               this.myPromoted.setRank(this.mMatchResult.afterRank.tier,this.mMatchResult.afterRank.division);
               this.myPromoted.setUserName(ScaleformUtil.isScaleform ? getDP(DataID.PLAYER_USER_NAME) : "Call of Duty Online");
               this.mAnimationTimeLine.add(this.myPromoted,5.5);
            }
            else
            {
               this.myPromotionResult.setData(this.mMatchResult.afterRank,this.mMatchResult.afterRank.tier > this.mMatchResult.beforeRank.tier);
               this.mAnimationTimeLine.add(this.myPromotionResult,5.5);
            }
         }
         this.mAnimationTimeLine.start();
      }
      
      private function onPromotedStateChangeCallback(isOpen:Boolean) : void
      {
         this.mPromotionAnimationPlaying = isOpen;
         if(this.mFullScreenOpenStateChangeCallback is Function)
         {
            this.mFullScreenOpenStateChangeCallback(isOpen);
         }
      }
   }
}

