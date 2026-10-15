package components.fsgcareermode_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.ContentContainer;
   import codo.component.ScrollGrid;
   import codo.component.aar.MatchResultsProgressArrowDisplay;
   import codo.component.factory.MarketFactory;
   import codo.constants.DataCommonID;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.manager.DataManager;
   import codo.objects.PlayerObj;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgUtil;
   
   public class FsgCareerProgressPart extends MovieClip
   {
      
      public var myPreviousRank:MovieClip;
      
      public var myNextRank:MovieClip;
      
      public var myBar:MovieClip;
      
      public var myRewardsLabel:TextField;
      
      public var myPreviousRankLabel:TextField;
      
      public var myNextRankLabel:TextField;
      
      public var myNoRewardsLabel:TextField;
      
      public var myOverlayMask:MovieClip;
      
      public var myFillBG:MovieClip;
      
      public var myRewardList:ScrollGrid;
      
      public var myNavArrowRight:MovieClip;
      
      public var myNavArrowLeft:MovieClip;
      
      public var myArrow:MatchResultsProgressArrowDisplay;
      
      public var myRewardsContainer:ContentContainer;
      
      private var mUnlockArray:Array;
      
      private var mUnlocksPerPrestige:Array;
      
      private var mCurrentUnlockIndex:int;
      
      private var mPlayerPrestigeLevel:int;
      
      private var mPlayerLevel:int;
      
      private var m_currentPresigeLevel:int;
      
      private var m_nextPresigeLevel:int;
      
      private var m_leftNavClickable:BehaviourClickable;
      
      private var m_leftNavAnimClickable:BehaviourAnimatedClickable;
      
      private var m_leftNavAudio:BehaviourAudio;
      
      private var m_rightNavClickable:BehaviourClickable;
      
      private var m_rightNavAnimClickable:BehaviourAnimatedClickable;
      
      private var m_rightNavAudio:BehaviourAudio;
      
      private var m_rewards:Array;
      
      private var m_rewardsClickables:Array;
      
      private var m_rewardTooltips:Array;
      
      private var mBarMidPoint:int;
      
      private var mIsInitialised:Boolean;
      
      public function FsgCareerProgressPart()
      {
         super();
         if(!ScaleformUtil.isScaleform)
         {
            this.refreshRewards();
         }
      }
      
      public function init() : void
      {
         this.m_leftNavClickable = new BehaviourClickable(this.myNavArrowLeft.myHitArea);
         this.m_leftNavAnimClickable = new BehaviourAnimatedClickable(this.myNavArrowLeft,this.m_leftNavClickable,1,2,3);
         this.m_leftNavClickable.addClickCallback(this.onNavLeft);
         this.m_leftNavAudio = new BehaviourAudio(this.m_leftNavClickable);
         this.m_rightNavClickable = new BehaviourClickable(this.myNavArrowRight.myHitArea);
         this.m_rightNavAnimClickable = new BehaviourAnimatedClickable(this.myNavArrowRight,this.m_rightNavClickable,1,2,3);
         this.m_rightNavClickable.addClickCallback(this.onNavRight);
         this.m_rightNavAudio = new BehaviourAudio(this.m_rightNavClickable);
         this.mIsInitialised = false;
         this.m_rewardTooltips = [];
         this.m_rewards = [];
         this.m_rewardsClickables = [];
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         gridSettings.buildGridItemRenderMethod = MarketFactory.GET_BUILD_MARKET_ITEM_CARD_FUNC(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false,true,false);
         this.myRewardList.initGrid(gridSettings,2,false,4);
         this.myRewardsContainer.width = 1009;
         this.myRewardsContainer.myContainer.gotoAndStop(3);
         this.myRewardList.setFrame(this.myRewardsContainer,54,0);
         this.myNoRewardsLabel.text = LocalizeUtil.localize("@SF_UI_NO_REWARD_HINT");
         this.mBarMidPoint = this.myOverlayMask.x + this.myOverlayMask.width * 0.5;
      }
      
      public function initialiseData() : Boolean
      {
         var length:int = 0;
         var i:int = 0;
         if(this.mIsInitialised)
         {
            this.refreshProgressPanel();
            return true;
         }
         this.mPlayerLevel = CFunctionCommonContainer.GetPlayerLevel();
         this.mPlayerPrestigeLevel = CFunctionCommonContainer.GetPlayerPrestige();
         this.mUnlocksPerPrestige = [];
         var unlocksCount:int = 0;
         var lastLevel:int = -1;
         this.mUnlockArray = [];
         this.mUnlockArray = DataManager.getInstance().getDP(DataCommonID.CAREER_UNLOCK_OBJ_ALL_FOR_REAL);
         if(this.mUnlockArray != null)
         {
            length = int(this.mUnlockArray.length);
            for(i = 0; i < length; i++)
            {
               if(this.mUnlockArray[i] != null)
               {
                  if(this.mUnlockArray[i].level < lastLevel)
                  {
                     this.mUnlocksPerPrestige.push(unlocksCount);
                  }
                  unlocksCount++;
                  lastLevel = int(this.mUnlockArray[i].level);
               }
            }
         }
         this.mUnlocksPerPrestige.push(unlocksCount);
         if(this.mUnlockArray != null && this.mUnlockArray.length > 0)
         {
            this.mCurrentUnlockIndex = this.mPlayerPrestigeLevel == 0 ? 0 : int(this.mUnlocksPerPrestige[this.mPlayerPrestigeLevel - 1]);
            while(Boolean(this.mUnlockArray[this.mCurrentUnlockIndex + 2]) && Boolean(this.mUnlockArray[this.mCurrentUnlockIndex].level < this.mPlayerLevel) && this.mUnlockArray[this.mCurrentUnlockIndex + 1].level <= this.mPlayerLevel)
            {
               ++this.mCurrentUnlockIndex;
            }
            this.refreshProgressPanel();
            this.mIsInitialised = true;
            return true;
         }
         this.refreshDecoupledProgressPanel();
         return false;
      }
      
      private function refreshDecoupledProgressPanel() : void
      {
         var ratio:Number = NaN;
         var playerObj:PlayerObj = null;
         var rank:String = null;
         var iRank:int = 0;
         var prestige:int = 0;
         if(ScaleformUtil.isScaleform)
         {
            playerObj = PlayerObj.getObj();
            rank = playerObj.careerData.currentLevel;
            iRank = parseInt(rank);
            prestige = int(playerObj.careerData.prestige);
            this.myPreviousRank.myValueTF.text = "";
            this.myNextRank.myValueTF.text = "";
            this.myRewardsLabel.text = LocalizeUtil.param("@SF_UI_CAREER_UNLOCKS_LABEL",[iRank + 1]);
            var xpMin:int = CFunctionCommonContainer.GetXpForRank(iRank - 1,prestige);
            var xpMax:int = CFunctionCommonContainer.GetTargetXpForRank(iRank - 1,prestige);
            var xpCurrent:int = CFunctionCommonContainer.GetPlayerXP();
            ratio = (xpCurrent - xpMin) / (xpMax - xpMin);
            ratio = Math.min(1,Math.max(0,ratio));
            this.myNavArrowLeft.visible = false;
            this.myNavArrowRight.visible = false;
            this.myOverlayMask.width = this.myFillBG.width * ratio;
            this.myBar.gotoAndStop(prestige == 0 ? 1 : 2);
            this.hideArrow();
            return;
         }
      }
      
      private function refreshProgressPanel() : void
      {
         this.getCurrentAndNextPrestigeLevels();
         this.setRank();
         this.setBarInfo();
         this.refreshRewards();
      }
      
      private function showArrow() : void
      {
         this.hideArrow();
         this.myArrow.visible = true;
         this.myArrow.x = this.myOverlayMask.x + this.myOverlayMask.width;
         if(this.myArrow.x <= this.mBarMidPoint)
         {
            this.myArrow.orientLeft();
         }
         TweenLite.to(this.myArrow,0.4,{"alpha":1});
      }
      
      private function hideArrow() : void
      {
         this.myArrow.alpha = 0;
         this.myArrow.visible = false;
      }
      
      private function getCurrentAndNextPrestigeLevels() : void
      {
         var prestigeLevel:int = 0;
         var prestigeNextLevel:int = 0;
         var index:int = 0;
         while(index < this.mUnlocksPerPrestige.length)
         {
            if(this.mCurrentUnlockIndex >= this.mUnlocksPerPrestige[index])
            {
               prestigeLevel++;
            }
            if(this.mCurrentUnlockIndex + 1 >= this.mUnlocksPerPrestige[index])
            {
               prestigeNextLevel++;
            }
            index++;
         }
         this.m_currentPresigeLevel = prestigeLevel;
         this.m_nextPresigeLevel = prestigeNextLevel;
      }
      
      private function setRank() : void
      {
         var rank:String = CFunctionCommonContainer.GetDisplayLevel(this.mUnlockArray[this.mCurrentUnlockIndex].level);
         var nextRank:String = "";
         if(this.mCurrentUnlockIndex < this.mUnlockArray.length - 1)
         {
            nextRank = CFunctionCommonContainer.GetDisplayLevel(this.mUnlockArray[this.mCurrentUnlockIndex + 1].level);
            this.myNextRankLabel.text = PlayerObj.getRankName(this.mUnlockArray[this.mCurrentUnlockIndex + 1].level);
            this.myNextRank.myValueTF.text = nextRank;
         }
         else
         {
            this.myNextRankLabel.text = " ";
            this.myNextRank.myValueTF.text = "--";
         }
         this.myPreviousRank.myValueTF.text = rank;
         this.myPreviousRank.myImgHolder.setImage(FsgUtil.getPrestigeIcon(this.m_currentPresigeLevel));
         this.myPreviousRankLabel.text = PlayerObj.getRankName(this.mUnlockArray[this.mCurrentUnlockIndex].level);
         if(this.m_nextPresigeLevel > 0)
         {
            this.myRewardsLabel.text = LocalizeUtil.param("@SF_UI_CAREER_PRESTIGE_LEVEL_UNLOCKS",[this.m_nextPresigeLevel,nextRank]);
         }
         else
         {
            this.myRewardsLabel.text = LocalizeUtil.param("@SF_UI_CAREER_UNLOCKS_LABEL",[nextRank]);
         }
         if(this.m_nextPresigeLevel > CFunctionCommonContainer.GetPlayerMaxPrestige())
         {
            this.myNextRank.myImgHolder.setImage("");
         }
         else
         {
            this.myNextRank.myImgHolder.setImage(FsgUtil.getPrestigeIcon(this.m_nextPresigeLevel));
         }
      }
      
      private function setBarInfo() : void
      {
         var xpMin:int = 0;
         var xpMax:int = 0;
         var ratio:Number = NaN;
         var xpCurrent:int = CFunctionCommonContainer.GetPlayerXP();
         if(this.mPlayerPrestigeLevel > this.m_currentPresigeLevel)
         {
            ratio = 1;
         }
         else if(this.mPlayerPrestigeLevel < this.m_currentPresigeLevel)
         {
            ratio = 0;
         }
         else
         {
            xpMin = CFunctionCommonContainer.GetXpForRank(this.mUnlockArray[this.mCurrentUnlockIndex].level,this.mPlayerPrestigeLevel);
            if(this.m_currentPresigeLevel == 0)
            {
               xpMax = CFunctionCommonContainer.GetTargetXpForRank(this.mUnlockArray[this.mCurrentUnlockIndex].level,0);
            }
            else if(this.m_currentPresigeLevel < this.m_nextPresigeLevel)
            {
               xpMax = CFunctionCommonContainer.GetTargetXpForRank(this.mUnlockArray[this.mCurrentUnlockIndex].level,this.mPlayerPrestigeLevel);
            }
            else
            {
               xpMax = CFunctionCommonContainer.GetXpForRank(this.mUnlockArray[this.mCurrentUnlockIndex + 1].level,this.mPlayerPrestigeLevel);
            }
            if(xpCurrent > xpMax)
            {
               ratio = 1;
            }
            else
            {
               ratio = (xpCurrent - xpMin) / (xpMax - xpMin);
               ratio = Math.min(1,Math.max(0,ratio));
            }
         }
         this.myOverlayMask.width = this.myFillBG.width * ratio;
         this.myBar.gotoAndStop(this.m_currentPresigeLevel == 0 ? 1 : 2);
         this.myNavArrowLeft.visible = true;
         this.myNavArrowRight.visible = true;
         if(this.mUnlockArray[this.mCurrentUnlockIndex].level == this.mPlayerLevel)
         {
            this.myArrow.setProgressValDisplay(xpCurrent - xpMin,xpMax - xpMin,LocalizeUtil.localize(Dict.XP));
            this.showArrow();
         }
         else
         {
            this.hideArrow();
         }
      }
      
      private function onNavLeft() : void
      {
         if(this.mCurrentUnlockIndex > 0)
         {
            --this.mCurrentUnlockIndex;
            this.refreshProgressPanel();
            if(this.mCurrentUnlockIndex == 0)
            {
               if(this.m_rightNavClickable.isEnabled() == false)
               {
                  this.m_rightNavClickable.setEnabled(true);
               }
            }
         }
      }
      
      private function onNavRight() : void
      {
         if(this.mCurrentUnlockIndex + 1 <= this.mUnlockArray.length - 1)
         {
            ++this.mCurrentUnlockIndex;
            this.refreshProgressPanel();
            if(this.mCurrentUnlockIndex == this.mUnlockArray.length - 1)
            {
               if(this.m_leftNavClickable.isEnabled() == false)
               {
                  this.m_leftNavClickable.setEnabled(true);
               }
            }
         }
      }
      
      public function refreshRewards() : void
      {
         var itemArray:Array = null;
         var len:int = 0;
         var unlockLvl:uint = 0;
         var awards:Vector.<Object> = null;
         var data:Object = null;
         var itemData:ProductObj = null;
         var i:int = 0;
         if(this.mUnlockArray == null)
         {
            return;
         }
         this.myRewardList.visible = false;
         this.myNoRewardsLabel.visible = true;
         this.myRewardsContainer.height = 380;
         if(this.mCurrentUnlockIndex + 1 < this.mUnlockArray.length)
         {
            itemArray = this.mUnlockArray[this.mCurrentUnlockIndex + 1].items;
            len = int(itemArray.length);
            if(len > 0)
            {
               unlockLvl = this.mUnlockArray[this.mCurrentUnlockIndex + 1].level + 1;
               awards = new Vector.<Object>();
               for(i = 0; i < len; i++)
               {
                  data = itemArray[i];
                  itemData = CFunctionCommonContainer.GetItemInfo(data.id);
                  itemData.unlockLevel = unlockLvl;
                  itemData.prestigeLevel = this.m_nextPresigeLevel;
                  if(itemData.group == MarketMenuData.GRP_LOADOUT_SLOT)
                  {
                     awards.unshift(itemData);
                  }
                  else
                  {
                     awards.push(itemData);
                  }
               }
               this.myRewardList.addItemsByVector(awards);
               this.myRewardList.visible = true;
               this.myNoRewardsLabel.visible = false;
            }
         }
      }
   }
}

