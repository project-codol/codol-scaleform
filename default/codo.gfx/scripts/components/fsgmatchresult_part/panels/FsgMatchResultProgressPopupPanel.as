package components.fsgmatchresult_part.panels
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.constants.QuickMatchType;
   import codo.constants.UITourVOSoundAliases;
   import codo.constants.UITutorialFlags;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.DictMarket;
   import codo.localization.DictMatchResults;
   import codo.objects.AARProgressObj;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.ItemObj;
   import codo.objects.LevelRewardObj;
   import codo.objects.ProductObj;
   import codo.objects.RewardObjComplete;
   import codo.objects.ZHuntKillZombieRewardObj;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.views.matchResults_parts.MatchResultBuddyName;
   import codo.views.matchResults_parts.MatchResultLeagueRewardClaim;
   import codo.views.matchResults_parts.MatchResultProgressBase;
   import codo.views.matchResults_parts.MatchResultsProgressUnlocksList;
   import codo.views.matchResults_parts.MatchResultsRandomRewardProgress;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import components.fsgmatchresult_part.FsgCurrencyRewardBox;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import components.fsgmatchresult_part.FsgMatchResultRankBar;
   import components.fsgmatchresult_part.FsgMatchResultsListBase;
   import components.fsgmatchresult_part.FsgRandomRewardPresentation;
   import components.fsgmatchresult_part.HPEHPRewardBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.util.FsgUtil;
   
   public class FsgMatchResultProgressPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      private static const BOX_FADE_DURATION:Number = 0.1;
      
      private static const PROGRESS_CONTAINER_SLIDE_DURATION:Number = 0.5;
      
      private static const PROGRESS_CONTAINER_SLIDE_START_Y:Number = 244;
      
      private static const DEFAULT_PROGRESS_CONTAINER_SLIDE_END_Y:Number = 134;
      
      private static const SUPPLY_DROP_PROGRESS_CONTAINER_SLIDE_END_Y:Number = 100;
      
      private static const COUNT_DURATION:Number = 1.8;
      
      private static const BONUS_FADE_DURATION:Number = 0.1;
      
      public var myRandomRewardContainer:FsgRandomRewardPresentation;
      
      public var myRandomRewardProgress:MatchResultsRandomRewardProgress;
      
      public var myLeagueRewardProgress:MatchResultLeagueRewardClaim;
      
      public var myBuddyName:MatchResultBuddyName;
      
      public var myProgressContainer:MovieClip;
      
      public var myScrim:Sprite;
      
      private var myRewardBox:FsgCurrencyRewardBox;
      
      private var myProgressBar:FsgMatchResultRankBar;
      
      private var myHPEHPRewardBox:HPEHPRewardBox;
      
      private var myRewardXPContainer:MovieClip;
      
      private var myCombatScoreValueTF:TextField;
      
      private var myXPIcon:MovieClip;
      
      private var myXPBonusValue:TextField;
      
      private var myXPBonusLabel:TextField;
      
      private var myBonusContainer:MovieClip;
      
      private var mySupplyDropProgress:MatchResultProgressBase;
      
      private var myUnlockList:MatchResultsProgressUnlocksList;
      
      public var mCurrentXP:Number = 0;
      
      public var mCurrentXPBonus:Number = 0;
      
      public var mTargetXP:Number = 0;
      
      public var mBonusTarget:Number = 0;
      
      public var mAnimateGPReward:Boolean = false;
      
      private var mSkipped:Boolean = false;
      
      private var mClaimButtonActive:Boolean = false;
      
      private var mClaimButtonClicked:Boolean = false;
      
      private var mAnimationHasPlayed:Boolean = false;
      
      private var mCurrentlySelectedList:FsgMatchResultsListBase;
      
      private var mUnlockableItems:Vector.<Object>;
      
      private var mTimelineAnim:TimelineMax;
      
      private var mProgressData:AARProgressObj;
      
      private var mBonusCounterTween:TweenLite;
      
      private var mRewardsData:Array = [];
      
      private var mIsOnboarding:Boolean;
      
      private var mSlideEndY:Number = 134;
      
      private var mDMZLReward:RewardObjComplete;
      
      private var mNumberRewardsClaim:int = 0;
      
      private var mPresentationCompleteCallback:Function;
      
      private var mOnClaimButtonClicked:Function;
      
      private var mZHuntKillZombieRewards:Array;
      
      private var mTDRewards:Array;
      
      public function FsgMatchResultProgressPopupPanel()
      {
         super();
         this.mUnlockableItems = new Vector.<Object>(0);
         this.mZHuntKillZombieRewards = [];
         this.mTDRewards = [];
         this.myScrim.visible = false;
         this.myProgressBar = this.myProgressContainer["myProgressBar"];
         this.myRewardBox = this.myProgressContainer["myRewardBox"];
         this.myHPEHPRewardBox = this.myProgressContainer["myHPEHPRewardBox"];
         this.myUnlockList = this.myProgressContainer.getChildByName("myUnlockList") as MatchResultsProgressUnlocksList;
         this.myRewardXPContainer = this.myProgressContainer["myRewardXPContainer"];
         this.myCombatScoreValueTF = this.myRewardXPContainer["myCombatScoreValueTF"];
         this.myXPIcon = this.myRewardXPContainer["myXPIcon"];
         this.mySupplyDropProgress = this.myProgressContainer["mySupplyDropProgress"];
         this.mySupplyDropProgress.resultIcon = "supplyDropCrate";
         this.mySupplyDropProgress.setCopy(LocalizeUtil.localize(DictMarket.MARKET_SUPPLY_DROP_PROGRESS_LABEL).toUpperCase(),LocalizeUtil.replaceConversionString(LocalizeUtil.localize(DictMarket.SUPPLY_DROP_NEXT_DROP_DESCRIPTION),[CFunctionCommonContainer.Dvar_GetInt("scr_supply_drop_reward_daily_limit")]));
         this.mySupplyDropProgress.deactive();
         this.myBonusContainer = this.myRewardXPContainer["myBonusContainer"];
         this.myXPBonusLabel = this.myBonusContainer["myBonusLabel"];
         this.myXPBonusValue = this.myBonusContainer["myBonusValue"];
         this.myXPBonusLabel.text = inDebugMode ? "MATCH BONUS" : LocalizeUtil.localize(DictMatchResults.BONUS_LABEL);
         this.mSlideEndY = SUPPLY_DROP_PROGRESS_CONTAINER_SLIDE_END_Y;
         this.myCombatScoreValueTF.text = "0";
         this.myRewardXPContainer.alpha = 0;
         this.myBonusContainer.alpha = 0;
         this.hideScrim();
         this.myRandomRewardContainer.setOnCompleteCallback(this.onRandomRewardPresentationComplete);
         this.myRandomRewardContainer.visible = this.myUnlockList.visible = false;
         this.myRandomRewardProgress.deactive();
         this.myLeagueRewardProgress.deactive();
         this.myBuddyName.deactive();
         this.myLeagueRewardProgress.registerCarteClickHandler(this.onLeagueRewardClicked);
         this.mySupplyDropProgress.y = this.myRandomRewardProgress.y = this.myUnlockList.y;
         if(inDebugMode)
         {
            this.injectFakeData();
         }
      }
      
      private static function generateProgressFakeData() : AARProgressObj
      {
         var result:AARProgressObj = new AARProgressObj();
         DataUtil.CopyData(result,{
            "multiplier":1,
            "expLabels":[{
               "fullLabel":"Lv1",
               "displayLevel":"1"
            },{
               "fullLabel":"Lv2",
               "displayLevel":"2"
            },{
               "fullLabel":"Lv3",
               "displayLevel":"3"
            },{
               "fullLabel":"Lv4",
               "displayLevel":"4"
            },{
               "fullLabel":"Lv5",
               "displayLevel":"5"
            }],
            "gainedExpValue":1000,
            "prestige":1,
            "gpMultiplier":1,
            "gainedGpValue":2200,
            "bonusXP":500,
            "bonusGP":233,
            "startPercent":0,
            "bonusEndPercent":1.5,
            "normalEndPercent":1.25,
            "prestigedIndex":-1
         });
         return result;
      }
      
      private static function generateRandomAwardData() : Array
      {
         var itemData:Object = null;
         var data:Array = [];
         for(var i:int = 0; i < 10; i++)
         {
            itemData = dummyAwardData();
            itemData.text = String("award: " + i);
            data.push(itemData);
         }
         return data;
      }
      
      private static function dummyAwardData() : Object
      {
         return {
            "text":"1title",
            "description":"1desc",
            "imgUrl":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png",
            "reward":"99XP",
            "count":10
         };
      }
      
      public function setProgressData(data:AARProgressObj) : void
      {
         this.mProgressData = data;
         this.mAnimateGPReward = 0 < data.gainedGpValue;
         this.bindMatchScore(data);
         this.myProgressBar.setData(data);
         this.myHPEHPRewardBox.setData(CFunctionContainer.AS_GetPromotionScoreDetails());
         var startingSupplyDropProgress:Number = Number(this.mProgressData.supplyDropRewardProgress) - this.mProgressData.supplyDropRewardProgressGained;
         var supplyDropCount:int = this.mProgressData.supplyDropsGained;
         if(startingSupplyDropProgress < 0)
         {
            startingSupplyDropProgress = 0;
         }
         this.mySupplyDropProgress.rewardQuantity = supplyDropCount;
         this.mySupplyDropProgress.progress = startingSupplyDropProgress;
      }
      
      public function setZHuntKillZombieRewards(data:Array) : void
      {
         this.mZHuntKillZombieRewards = data;
      }
      
      public function setTDRewards(data:Array) : void
      {
         this.mTDRewards = data;
      }
      
      override public function active() : void
      {
         var rewardScore:int = 0;
         var matchType:QuickMatchType = null;
         var rewardsDataAvailable:Boolean = false;
         var obj:Object = null;
         var showRewards:Boolean = false;
         super.active();
         listen(BCEvent.EVT_HIDE_BATTLECITY_LEAGUE_AWARD,this.continueBlockedAnimation);
         if(!this.mAnimationHasPlayed)
         {
            rewardScore = CFunctionContainer.AS_GetAARRandomRewardScore();
            matchType = getDP(DataID.CURRENT_MATCH_TYPE);
            if(matchType.isMpMap())
            {
               this.myRandomRewardProgress.deactive();
            }
            rewardsDataAvailable = !inDebugMode ? Boolean(CFunctionCommonContainer.IsMarketplaceReady()) : true;
            this.mRewardsData = [];
            if(rewardsDataAvailable)
            {
               for each(obj in CFunctionContainer.AS_GetRandomRewards())
               {
                  this.mRewardsData.push(new ProductObj(obj));
               }
            }
            if(rewardScore > 0)
            {
               this.myRandomRewardProgress.active();
               this.mySupplyDropProgress.deactive();
               showRewards = CFunctionContainer.AS_AARShouldShowRandomReward() as Boolean;
               if(this.mRewardsData.length > 0)
               {
                  this.myRandomRewardProgress.rewardQuantity = this.mNumberRewardsClaim = Math.ceil(this.mRewardsData.length / FsgRandomRewardPresentation.REWARDS_PER_BOX);
               }
               if(matchType.isHeroOps())
               {
                  this.myRandomRewardProgress.configureDisplayHeroOps(this.onClaimButtonClicked);
               }
               else
               {
                  this.myRandomRewardProgress.configureDisplay(rewardScore,this.onClaimButtonClicked);
               }
               this.mClaimButtonActive = showRewards;
               this.mClaimButtonClicked = !this.mClaimButtonActive;
            }
            if(!matchType.isPvp())
            {
               this.mySupplyDropProgress.deactive();
            }
            if(getDP(DataID.BATTLE_CITY_LEAGUE_MATCH_RESULT_OBJ) == null)
            {
               this.startAnimation();
            }
         }
      }
      
      override public function deactive() : void
      {
         super.deactive();
         listen(BCEvent.EVT_HIDE_BATTLECITY_LEAGUE_AWARD,this.continueBlockedAnimation);
         if(null != this.mTimelineAnim)
         {
            return;
         }
         this.myProgressBar.allowPlaySound(false);
         this.myRandomRewardContainer.killPresentation();
      }
      
      public function setOnboardMission(isOnboarding:Boolean) : void
      {
         this.mIsOnboarding = isOnboarding;
         this.myProgressBar.onboardingEnabled(isOnboarding);
         if(isOnboarding)
         {
            listen(BCEvent.EVT_MATCH_RESULTS_SHOW_ONBOARDING_REWARDS,this.onOnboardingStep);
            this.myRewardXPContainer.visible = false;
         }
         else if(CFunctionCommonContainer.SupplyDropsEnabled() && CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS) == null)
         {
            this.mySupplyDropProgress.active();
         }
         else
         {
            this.mySupplyDropProgress.deactive();
         }
      }
      
      private function onProgressAnimationDone(levelUp:Boolean) : void
      {
         var rewardObjComplete:RewardObjComplete = null;
         if(levelUp)
         {
            this.setupUnlockList();
         }
         var startY:Number = this.myUnlockList.y;
         var allItems:Vector.<Object> = new Vector.<Object>(0);
         var allRewards:Vector.<Object> = Vector.<Object>(CFunctionContainer.AS_GetMatchChallengeRewards());
         allItems = allItems.concat(allRewards);
         allItems = allItems.concat(this.mUnlockableItems);
         allItems = allItems.concat(Vector.<Object>(this.mTDRewards));
         for(var i:int = 0; i < this.mZHuntKillZombieRewards.length; i++)
         {
            if(this.mZHuntKillZombieRewards[i].convertedGP == 0)
            {
               rewardObjComplete = new RewardObjComplete(this.mZHuntKillZombieRewards[i].rewardType,this.mZHuntKillZombieRewards[i].rewardEntity,this.mZHuntKillZombieRewards[i].rewardParam);
               allItems.push(new ZHuntKillZombieRewardObj(rewardObjComplete,this.mZHuntKillZombieRewards[i].monsterID,this.mZHuntKillZombieRewards[i].partID,this.mZHuntKillZombieRewards[i].typeString,this.mZHuntKillZombieRewards[i].nameString,this.mZHuntKillZombieRewards[i].isBossReward));
            }
         }
         if(null != allItems && 0 < allItems.length)
         {
            this.myUnlockList.setData(allItems);
            this.myUnlockList.visible = true;
            startY += this.myUnlockList.height + 20;
         }
         if(this.mySupplyDropProgress.visible || this.myRandomRewardProgress.visible)
         {
            this.mySupplyDropProgress.y = this.myRandomRewardProgress.y = startY;
            startY += 150;
         }
         var playedGametype:String = CFunctionCommonContainer.Dvar_GetString("ui_played_gametype");
         var isDMZ:Boolean = CFunctionContainer.AS_IsDMZGametype(playedGametype) as Boolean;
         var buddyInfo:Object = CFunctionContainer.AS_GetBattleCityBuddyInfo();
         if(isDMZ && Boolean(buddyInfo))
         {
            this.myBuddyName.active();
            this.myBuddyName.setBuddy(buddyInfo.id,buddyInfo.name);
            this.myBuddyName.y = startY;
         }
      }
      
      private function onOnboardingStep(evt:ParaEvent) : void
      {
         var newUserPresentationStep:uint = evt.myPara.step as uint;
         var animationCompleteCallback:Function = evt.myPara.callback;
         switch(newUserPresentationStep)
         {
            case UITutorialFlags.TOUR_AAR_STEP_SHOW_XP:
               this.myRewardBox.skipAnimation();
               this.myRewardXPContainer.visible = true;
               this.initXPRewardAnimation();
               break;
            case UITutorialFlags.TOUR_AAR_STEP_SHOW_LEVEL_REWARD:
               this.mTimelineAnim.complete();
               this.intiLevelXPRewardAnimation(animationCompleteCallback);
               break;
            case UITutorialFlags.TOUR_AAR_STEP_END:
               this.mTimelineAnim.complete();
               UITutorialFlags.setNextOnboardingStep(UITutorialFlags.NULL);
               this.mPresentationCompleteCallback();
         }
      }
      
      private function setupUnlockList() : void
      {
         var levelReward:LevelRewardObj = null;
         var productID:int = 0;
         var itemIDs:Array = null;
         var itemID:int = 0;
         var unlocksAtRank:Array = null;
         var unlockReward:LevelRewardObj = null;
         this.mUnlockableItems = new Vector.<Object>(0);
         var rewardItems:Array = [];
         var currentLevel:int = this.myProgressBar.getCurrentLevel();
         var levelRewards:Array = CFunctionContainer.AS_GetLevelRewards(this.mProgressData.prestige,currentLevel);
         this.mUnlockableItems = this.mUnlockableItems.concat(Vector.<Object>(levelRewards));
         for(var i:int = 0; i < levelRewards.length; i++)
         {
            levelReward = levelRewards[i];
            if(levelReward.type == ChallengeRewardObj.REWARD_TYPE_SKU)
            {
               productID = CFunctionContainer.AS_GetProductIDFromSKU(levelReward.entityId);
               if(Boolean(CFunctionContainer.IsBundleProduct(productID)))
               {
                  rewardItems.push(CFunctionCommonContainer.GetBundleInfo(productID) as ProductObj);
               }
               else
               {
                  itemIDs = CFunctionContainer.AS_GetItemIDsFromProduct(productID);
                  if(itemIDs != null && itemIDs.length > 0)
                  {
                     itemID = int(itemIDs[0]);
                     rewardItems.push(itemID);
                  }
               }
            }
         }
         var unlocks:Array = getDP(DataCommonID.CAREER_UNLOCK_OBJ_ALL_FOR_REAL);
         var len:uint = unlocks.length;
         var unlockIndex:int = -1;
         for(i = 0; i < len; i++)
         {
            if(unlocks[i].level == currentLevel && unlocks[i].prestige == this.mProgressData.prestige)
            {
               unlockIndex = i;
               break;
            }
         }
         if(unlockIndex > -1)
         {
            unlocksAtRank = unlocks[unlockIndex].items;
            for(i = 0; i < unlocksAtRank.length; i++)
            {
               if(rewardItems.indexOf(unlocksAtRank[i].id) == -1)
               {
                  unlockReward = new LevelRewardObj();
                  unlockReward.category = LevelRewardObj.CATEGORY_UNLOCK;
                  unlockReward.type = ChallengeRewardObj.REWARD_TYPE_ITEM;
                  unlockReward.entityId = unlocksAtRank[i].id;
                  this.mUnlockableItems.push(unlockReward);
               }
            }
         }
      }
      
      private function bindMatchScore(progressData:AARProgressObj) : void
      {
         var xp:uint = uint(progressData.gainedExpValue);
         this.mCurrentXP = 0;
         this.mCurrentXPBonus = 0;
         this.mBonusTarget = progressData.bonusXP;
         this.mTargetXP = xp - this.mBonusTarget;
         this.myRewardBox.setData(progressData);
         if(this.mBonusTarget > 0)
         {
            this.myXPBonusValue.text = "+".concat(FsgUtil.commaFormatNumber(Math.round(this.mBonusTarget)));
         }
         else
         {
            this.myBonusContainer.visible = false;
         }
      }
      
      public function skipAnimation() : void
      {
         this.mAnimationHasPlayed = true;
         this.mSkipped = true;
         if(null != this.mTimelineAnim)
         {
            this.mTimelineAnim.complete();
            this.mTimelineAnim = null;
         }
         if(null != this.mBonusCounterTween)
         {
            this.mBonusCounterTween.complete(false,true);
         }
         this.myProgressBar.skipAnimation();
         this.myProgressBar.visible = true;
         this.myProgressBar.alpha = 1;
         this.mySupplyDropProgress.alpha = 1;
         this.myRewardBox.skipAnimation();
         this.myRewardBox.scaleX = 1;
         this.myRewardBox.scaleY = 1;
         this.myRewardXPContainer.alpha = 1;
         if(null != this.mCurrentlySelectedList)
         {
            this.mCurrentlySelectedList.showList();
         }
         this.myXPBonusValue.text = String("+" + FsgUtil.commaFormatNumber(Math.round(this.mBonusTarget)));
         this.myCombatScoreValueTF.text = this.mTargetXP.toString();
      }
      
      public function continueBlockedAnimation() : void
      {
         if(this.mAnimationHasPlayed)
         {
            return;
         }
         this.startAnimation();
      }
      
      public function startAnimation() : void
      {
         this.myProgressBar.setAnimationCompleteCallback(this.onProgressAnimationDone);
         this.myProgressBar.allowPlaySound(true);
         this.mTimelineAnim = new TimelineMax();
         if(true == this.mAnimateGPReward)
         {
            this.myRewardBox.startAnimation();
            if(!this.mIsOnboarding)
            {
               this.mTimelineAnim.append(new TweenLite(this.myRewardXPContainer,BOX_FADE_DURATION,{"alpha":1}));
            }
         }
         else
         {
            this.myRewardBox.x = 0;
            this.myRewardBox.y = 0;
            this.mTimelineAnim.append(new TweenLite(this.myRewardXPContainer,BOX_FADE_DURATION,{"alpha":1}));
         }
         if(!this.mIsOnboarding)
         {
            this.mTimelineAnim.append(new TweenLite(this,COUNT_DURATION,{
               "mCurrentXP":this.mTargetXP,
               "onStart":this.startProgressAnimation,
               "onUpdate":this.onCounterAnimUpdate,
               "ease":Linear.easeInOut
            }));
            this.mTimelineAnim.append(new TweenLite(this.mySupplyDropProgress,BOX_FADE_DURATION,{"alpha":1}));
            if(this.mProgressData.bonusXP > 0)
            {
               this.mTimelineAnim.append(new TweenLite(this.myBonusContainer,BONUS_FADE_DURATION,{"alpha":1}));
               this.myProgressBar.setBonusAnimationCallback(this.onProgressAnimationComplete);
            }
            else
            {
               this.mTimelineAnim.append(TweenLite.delayedCall(0,this.onCounterAnimComplete));
            }
         }
         else
         {
            this.mTimelineAnim.append(TweenLite.delayedCall(0,this.onCounterAnimComplete));
         }
      }
      
      private function startProgressAnimation() : void
      {
         this.myProgressBar.startAnimation();
         this.myHPEHPRewardBox.startAnimation();
      }
      
      private function initXPRewardAnimation() : void
      {
         this.mTimelineAnim.append(new TweenLite(this.myRewardXPContainer,BOX_FADE_DURATION,{"alpha":1}));
         this.mTimelineAnim.append(new TweenLite(this,COUNT_DURATION,{
            "mCurrentXP":this.mTargetXP,
            "onUpdate":this.onCounterAnimUpdate,
            "ease":Linear.easeInOut
         }));
         this.mTimelineAnim.play();
         playSound("ui_earnlevelxp_countup_01");
      }
      
      private function initSupplyDropAnimation() : void
      {
         SOUND_UTIL.playSound(UITourVOSoundAliases.AAR_EARNED_SUPPLY_DROP);
         this.mTimelineAnim = new TimelineMax();
         this.mTimelineAnim.append(new TweenLite(this.mySupplyDropProgress,BOX_FADE_DURATION,{"alpha":1}));
         this.mTimelineAnim.play();
      }
      
      private function intiLevelXPRewardAnimation(onAnimCompleteCallback:Function) : void
      {
         this.mTimelineAnim = new TimelineMax();
         this.mTimelineAnim.append(TweenLite.to(this,COUNT_DURATION,{
            "mCurrentXP":this.mTargetXP,
            "onStart":this.startProgressAnimation(),
            "onComplete":onAnimCompleteCallback,
            "ease":Linear.easeInOut
         }));
         this.mTimelineAnim.play();
      }
      
      public function onProgressAnimationComplete() : void
      {
         this.mBonusCounterTween = new TweenLite(this,COUNT_DURATION,{
            "mCurrentXPBonus":this.mBonusTarget,
            "onUpdate":this.onBonusCounterAnimUpdate,
            "onComplete":this.onCounterAnimComplete,
            "ease":Linear.easeInOut
         });
      }
      
      private function onAnimationComplete() : void
      {
         this.mAnimationHasPlayed = true;
      }
      
      private function hideScrim() : void
      {
         this.myScrim.visible = false;
         this.myScrim.alpha = 0;
      }
      
      private function onCounterAnimComplete() : void
      {
         if(this.mIsOnboarding)
         {
            this.onAnimationComplete();
            return;
         }
         this.mTimelineAnim = new TimelineMax();
         if(null != this.mCurrentlySelectedList && false == this.mSkipped)
         {
            this.myProgressContainer.y = PROGRESS_CONTAINER_SLIDE_START_Y;
            this.mCurrentlySelectedList.setOnCompleteCallback(this.onAnimationComplete);
            this.mTimelineAnim.append(new TweenLite(this.myProgressContainer,PROGRESS_CONTAINER_SLIDE_DURATION,{"y":this.mSlideEndY}));
            this.mTimelineAnim.append(new TweenLite(this.mCurrentlySelectedList,BOX_FADE_DURATION,{
               "alpha":1,
               "onComplete":this.mCurrentlySelectedList.startAnimation
            }));
         }
         else
         {
            this.onAnimationComplete();
         }
      }
      
      private function onCounterAnimUpdate() : void
      {
         this.myCombatScoreValueTF.text = Math.round(this.mCurrentXP).toString();
      }
      
      private function onBonusCounterAnimUpdate() : void
      {
         if(null != this.mTimelineAnim)
         {
            this.myXPBonusValue.text = String("+" + FsgUtil.commaFormatNumber(Math.round(this.mCurrentXPBonus)));
         }
      }
      
      private function onClaimButtonClicked() : void
      {
         this.myRandomRewardContainer.visible = true;
         this.myRandomRewardContainer.showRandomReward(this.mRewardsData);
         this.mClaimButtonClicked = true;
         this.mOnClaimButtonClicked();
      }
      
      public function set onClaimButtonClickedCallback(callback:Function) : void
      {
         this.mOnClaimButtonClicked = callback;
      }
      
      override public function canAdvance() : Boolean
      {
         if(this.mIsOnboarding)
         {
            return true;
         }
         var canAdvance:Boolean = false;
         if(!this.mAnimationHasPlayed)
         {
            this.skipAnimation();
         }
         else if(this.mClaimButtonActive && !this.mClaimButtonClicked)
         {
            this.onClaimButtonClicked();
            this.mClaimButtonActive = false;
         }
         else
         {
            canAdvance = true;
         }
         return canAdvance;
      }
      
      public function set presentationCompleteCallback(callback:Function) : void
      {
         this.mPresentationCompleteCallback = callback;
      }
      
      private function onRandomRewardPresentationComplete() : void
      {
         --this.mNumberRewardsClaim;
         if(this.mNumberRewardsClaim <= 0)
         {
            this.mNumberRewardsClaim = 0;
            this.myRandomRewardProgress.rewardQuantity = 0;
            this.mRewardsData.length = 0;
            this.mPresentationCompleteCallback();
            return;
         }
         this.myRandomRewardProgress.rewardQuantity = this.mNumberRewardsClaim;
         var spliceAmount:uint = this.mRewardsData.length - FsgRandomRewardPresentation.REWARDS_PER_BOX > 0 ? uint(FsgRandomRewardPresentation.REWARDS_PER_BOX) : 1;
         this.mRewardsData.splice(0,spliceAmount);
         if(this.mRewardsData.length > 0)
         {
            this.myRandomRewardContainer.showRandomReward(this.mRewardsData);
         }
         else
         {
            this.myRandomRewardContainer.visible = false;
         }
      }
      
      private function onLeagueRewardClicked() : void
      {
         this.myRandomRewardContainer.visible = true;
         this.myRandomRewardContainer.showRandomReward([this.mDMZLReward.getWrappedObj()],3);
      }
      
      private function injectFakeData() : void
      {
         this.visible = true;
         var i1:ItemObj = new ItemObj();
         var i2:ItemObj = new ItemObj();
         var i3:ItemObj = new ItemObj();
         var i4:ItemObj = new ItemObj();
         var i5:ItemObj = new ItemObj();
         var i6:ItemObj = new ItemObj();
         var i7:ItemObj = new ItemObj();
         var i8:ItemObj = new ItemObj();
         var i9:ItemObj = new ItemObj();
         var i10:ItemObj = new ItemObj();
         i1.name = "ITEM 1";
         i2.name = "ITEM 2";
         i3.name = "ITEM 3";
         i4.name = "ITEM 4";
         i5.name = "ITEM 5";
         i6.name = "ITEM 6";
         i7.name = "ITEM 7";
         i8.name = "ITEM 8";
         i9.name = "ITEM 9";
         i10.name = "ITEM 10";
         this.mRewardsData = [i1,i2,i3,i4,i5,i6,i7];
         var scoreArray:Array = new Array();
         scoreArray[0] = [["evac",100,200,300]];
         scoreArray[1] = [["evac",100,500,1200]];
         this.myRandomRewardProgress.rewardQuantity = this.mNumberRewardsClaim = Math.ceil(this.mRewardsData.length / FsgRandomRewardPresentation.REWARDS_PER_BOX);
         this.myRandomRewardProgress.active();
         var fakeResult:AARProgressObj = generateProgressFakeData();
         this.myRewardBox.setData(fakeResult);
         this.mProgressData = fakeResult;
         this.mAnimateGPReward = true;
         this.mCurrentXP = 0;
         this.mBonusTarget = fakeResult.bonusXP;
         this.mTargetXP = fakeResult.gainedExpValue - this.mBonusTarget;
         this.myProgressBar.setData(fakeResult);
         this.startAnimation();
      }
   }
}

