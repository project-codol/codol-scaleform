package codo.views.clan_sub
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.social.InputBox;
   import codo.component.social.SocialMainTab;
   import codo.component.social.SocialTabButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.NotificationState;
   import codo.localization.DictClan;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.InputBoxSettings;
   import codo.objects.ProductObj;
   import codo.objects.SocialTabSetting;
   import codo.services.TutorialService;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import codo.views.clan_sub.search_sub.ClanBestPanel;
   import codo.views.clan_sub.search_sub.ClanNameSearchPanel;
   import codo.views.clan_sub.search_sub.ClanNewPanel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class ClanSearchPanel extends BaseSubElement
   {
      
      private static const XP_BOOST_TYPE_0:int = 0;
      
      private static const XP_BOOST_TYPE_1:int = 1;
      
      private static const INPUT_HEIGHT:int = 30;
      
      private static const SEARCH_BTN_WIDTH:int = 155;
      
      private static const SEARCH_BTN_HEIGHT:int = 33;
      
      private static const SEARCH_INPUT_WIDTH:int = 798;
      
      public var myBenefitStrip:MovieClip;
      
      public var mySearchInputBox:InputBox;
      
      public var mySearchClanBtn:Button;
      
      public var myCreateClanBtn:Button;
      
      public var myNavigationTab:SocialMainTab;
      
      public var myBenefitArrow:Sprite;
      
      private var mNavigateData:SocialTabSetting;
      
      private var mBestClanDataRequested:Boolean = false;
      
      private var mNewClanDataRequested:Boolean = false;
      
      private var myCurrentSubPanel:BaseSubElement;
      
      private var myCurrentSubPanels:Array;
      
      public var myBestClanPanel:ClanBestPanel;
      
      public var myNewClanPanel:ClanNewPanel;
      
      public var mySearchResultPanel:ClanNameSearchPanel;
      
      public function ClanSearchPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var item:ProductObj = null;
         var imageLoader:FsgImageHolder = null;
         this.mNavigateData = new SocialTabSetting();
         this.mNavigateData.labels = [DictClan.BEST_CLAN_LABEL,DictClan.NEW_CLAN_LABEL,DictClan.SEARCH_CLAN_LABEL];
         this.mNavigateData.tabSelectedCallback = this.onTabSelectedCallback;
         this.mNavigateData.fixedTabWidth = 115;
         this.myBenefitArrow = this.myBenefitStrip.myBenefitArrow;
         var myClanBenefit1:TextField = this.myBenefitStrip.myClanBenefit1;
         var myClanBenefit2:TextField = this.myBenefitStrip.myClanBenefit2;
         var myClanBenefit3:TextField = this.myBenefitStrip.myClanBenefit3;
         myClanBenefit1.textStyle = ClanGuide.styleClanHeader;
         myClanBenefit1.width = 300;
         myClanBenefit1.height = 30;
         myClanBenefit1.text = DictClan.CLAN_BENEFIT1_LABEL;
         myClanBenefit2.textStyle = ClanGuide.styleClanLabel;
         myClanBenefit2.width = 300;
         myClanBenefit2.width = 30;
         var xpBoostPercent0:Number = getDP(DataID.CLAN_XP_BOOST_VALUE,[XP_BOOST_TYPE_0]);
         var xpBoostPercent0Str:String = String(Math.round(xpBoostPercent0 * 100)) + "%";
         myClanBenefit2.text = LocalizeUtil.param(DictClan.CLAN_BENEFIT2_LABEL,[xpBoostPercent0Str]);
         myClanBenefit3.textStyle = ClanGuide.styleClanLabel;
         myClanBenefit3.width = 300;
         myClanBenefit3.height = 30;
         var xpBoostPercent1:Number = getDP(DataID.CLAN_XP_BOOST_VALUE,[XP_BOOST_TYPE_1]);
         var xpBoostPercent1Str:String = String(Math.round(xpBoostPercent1 * 100)) + "%";
         myClanBenefit3.text = LocalizeUtil.param(DictClan.CLAN_BENEFIT3_LABEL,[xpBoostPercent1Str]);
         this.myBenefitArrow.x = myClanBenefit2.x + myClanBenefit2.textWidth + 25;
         myClanBenefit3.x = this.myBenefitArrow.x + this.myBenefitArrow.width + GlobalGuide.COMPONENT_PADDING;
         var searchInputSetting:InputBoxSettings = new InputBoxSettings();
         searchInputSetting.width = SEARCH_INPUT_WIDTH;
         searchInputSetting.height = INPUT_HEIGHT;
         searchInputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         searchInputSetting.hintText = DictClan.CLAN_SEARCH_INPUT_HINT;
         searchInputSetting.highlightAsDefault = true;
         this.mySearchInputBox.settings = searchInputSetting;
         this.mySearchClanBtn.width = SEARCH_BTN_WIDTH;
         this.mySearchClanBtn.height = SEARCH_BTN_HEIGHT;
         this.mySearchClanBtn.label = DictClan.SEARCH_CLAN;
         this.mySearchClanBtn.registerClickEvent(this.onSearchClanConfirm);
         this.myCreateClanBtn.width = SEARCH_BTN_WIDTH;
         this.myCreateClanBtn.height = SEARCH_BTN_HEIGHT;
         this.myCreateClanBtn.label = DictClan.CREATE_CLAN;
         this.myCreateClanBtn.registerClickEvent(this.onCreateClanConfirm);
         this.myBestClanPanel.deactive();
         this.myNewClanPanel.deactive();
         this.mySearchResultPanel.deactive();
         this.myNavigationTab.setTabType(SocialTabButton.TYPE_BIG);
         this.myNavigationTab.setData(this.mNavigateData);
         if(ScaleformUtil.isScaleform)
         {
            item = TutorialService.getInstance().getClanOnboardingReward();
            imageLoader = this.myBenefitStrip.myRewardImage;
            imageLoader.setImage(item.imageURL);
         }
      }
      
      override public function active() : void
      {
         var item:ProductObj = null;
         var itemName:String = null;
         var duration:int = 0;
         var xpBoostPercent1:Number = NaN;
         var xpBoostPercent1Str:String = null;
         super.active();
         if(Boolean(getDP(DataID.LOCK_BEST_CLAN)))
         {
            this.myCurrentSubPanels = [this.myNewClanPanel,this.mySearchResultPanel];
         }
         else
         {
            this.myCurrentSubPanels = [this.myBestClanPanel,this.myNewClanPanel,this.mySearchResultPanel];
         }
         this.myNavigationTab.selectTab(0);
         this.myNewClanPanel.switchCheckJoinable(false);
         listen(BCEvent.EVT_TUTORIAL_STATE,this.onTutorial);
         if(getDP(DataID.NOTIFICATION_STATE,["onboard_clan_tutorial_reward"]) == NotificationState.NEED_NOTIFICATION)
         {
            item = TutorialService.getInstance().getClanOnboardingReward();
            itemName = LocalizeUtil.localize(item.name);
            duration = int((getDP(DataID.CLAN_GLOBAL_CONFIG) as ClanGlobalConfig).joinRewardItemDuration);
            this.myBenefitStrip.myClanBenefit2.text = LocalizeUtil.param(DictClan.CLAN_BENEFIT4_LABEL,[itemName,duration]);
            this.myBenefitStrip.myRewardImage.visible = true;
         }
         else
         {
            xpBoostPercent1 = getDP(DataID.CLAN_XP_BOOST_VALUE,[XP_BOOST_TYPE_1]);
            xpBoostPercent1Str = String(Math.round(xpBoostPercent1 * 100)) + "%";
            this.myBenefitStrip.myClanBenefit2.text = LocalizeUtil.param(DictClan.CLAN_BENEFIT2_LABEL,[xpBoostPercent1Str]);
            this.myBenefitStrip.myRewardImage.visible = false;
         }
      }
      
      override public function deactive() : void
      {
         this.myNavigationTab.clearSelectedTab();
         unlisten(BCEvent.EVT_TUTORIAL_STATE,this.onTutorial);
         super.deactive();
      }
      
      private function onTutorial() : void
      {
         this.myNavigationTab.selectTab(1);
         this.myNewClanPanel.switchCheckJoinable(true);
         unlisten(BCEvent.EVT_TUTORIAL_STATE,this.onTutorial);
      }
      
      private function onCreateClanConfirm() : void
      {
         var lockStr:String = null;
         if(!getDP(DataID.IS_CLAN_CREATE_UNLOCKED))
         {
            lockStr = LocalizeUtil.param(LocalizeUtil.localize(DictClan.CLAN_CREATE_LEVEL_NOT_MATCH),[getDP(DataID.OWN_CLAN_UNLOCKED_LEVEL)]);
            showMsg(lockStr,1);
            return;
         }
         if(!getDP(DataID.IS_CLAN_CREATE_COOL_DOWN_COMPLETE))
         {
            lockStr = LocalizeUtil.param(LocalizeUtil.localize(DictClan.CLAN_CREATE_COOL_DOWN_NOT_COMPLETE),[getDP(DataID.CLAN_CREATE_COOL_DOWN_DAYS)]);
            showMsg(lockStr,1);
            return;
         }
         this.broadcast(BCEvent.EVT_OPEN_CREATE_CLAN_CONFIRM);
      }
      
      private function onSearchClanConfirm() : void
      {
         var keyword:String = StringUtil.trim(this.mySearchInputBox.text);
         if(keyword == "")
         {
            this.mySearchInputBox.warningUser();
            return;
         }
         this.mySearchResultPanel.startNewSearch(keyword);
         this.myNavigationTab.selectTab(2);
      }
      
      private function onTabSelectedCallback(index:int) : void
      {
         if(Boolean(this.myCurrentSubPanel))
         {
            this.myCurrentSubPanel.deactive();
         }
         if(Boolean(this.myCurrentSubPanels[index]))
         {
            this.myCurrentSubPanel = this.myCurrentSubPanels[index] as BaseSubElement;
            this.myCurrentSubPanel.active();
            this.tryRequestData(this.myCurrentSubPanels[index]);
         }
      }
      
      public function resetBestAndNewSearchSession() : void
      {
         this.mBestClanDataRequested = false;
         this.mNewClanDataRequested = false;
      }
      
      private function tryRequestData(subPanel:BaseSubElement) : void
      {
         if(subPanel == this.myBestClanPanel && !this.mBestClanDataRequested)
         {
            this.myBestClanPanel.startNewSearch();
            this.mBestClanDataRequested = true;
         }
         else if(subPanel == this.myNewClanPanel && !this.mNewClanDataRequested)
         {
            this.myNewClanPanel.startNewSearch();
            this.mNewClanDataRequested = true;
         }
      }
   }
}

