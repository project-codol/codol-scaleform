package codo.views.playerDetailInfo_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.TabNavigation;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.diagram.ColumnDiagram;
   import codo.component.factory.ButtonFactory;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutSwitchTabButton;
   import codo.component.loadout.PlayerDetailLoadoutDisplay;
   import codo.component.loadout.PlayerDetailLoadoutMeleeDisplay;
   import codo.constants.BCEvent;
   import codo.localization.Dict;
   import codo.localization.DictCareer;
   import codo.localization.DictInGame;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   
   public class PlayerOverallInfo extends BaseSubElement
   {
      
      private const PRIMARY_LOADOUT_TAB_INDEX:int = 1;
      
      private const MELEE_LOADOUT_TAB_INDEX:int = 2;
      
      public var myRankLabel:TextField;
      
      public var myKDALabel:TextField;
      
      public var myKillsLabel:TextField;
      
      public var myHeadShotsLabel:TextField;
      
      public var myWinLabel:TextField;
      
      public var myTotalScoreLabel:TextField;
      
      public var myTotalGameTimeLabel:TextField;
      
      public var myWinStreakLabel:TextField;
      
      public var myAccuracyLabel:TextField;
      
      public var myMostPlayedModeLabel:TextField;
      
      public var myTopThreeTimesLabel:TextField;
      
      public var myFirstBloodTimesLabel:TextField;
      
      public var myLastKillTimesLabel:TextField;
      
      public var myMostKillStreakKillsLabel:TextField;
      
      public var myKillstreaksLabel:TextField;
      
      public var myMostKillStreakLabel:TextField;
      
      public var myRank:TextField;
      
      public var myKDA:TextField;
      
      public var myKills:TextField;
      
      public var myHeadshots:TextField;
      
      public var myWin:TextField;
      
      public var myTotalScore:TextField;
      
      public var myTotalGameTime:TextField;
      
      public var myWinStreak:TextField;
      
      public var myAccuracy:TextField;
      
      public var myMostPlayedMode:TextField;
      
      public var myTopThreeTimes:TextField;
      
      public var myFirstBloodTimes:TextField;
      
      public var myLastKillTimes:TextField;
      
      public var myMostKillStreakKills:TextField;
      
      public var myMostKillStreak:TextField;
      
      public var myWeaponKillChartLabel:TextField;
      
      public var myWeaponUsageChart:ColumnDiagram;
      
      public var myPrimaryLoadoutTab:LoadoutSwitchTabButton;
      
      public var myMeleeLoadoutTab:LoadoutSwitchTabButton;
      
      public var myLoadout:PlayerDetailLoadoutDisplay;
      
      public var myLoadoutMelee:PlayerDetailLoadoutMeleeDisplay;
      
      public var myTabNavigation:TabNavigation;
      
      public var _classes:Array;
      
      private var mIsFullVersion:Boolean = false;
      
      public var myKillStreak0:LoadoutButton;
      
      public var myKillStreak1:LoadoutButton;
      
      public var myKillStreak2:LoadoutButton;
      
      public function PlayerOverallInfo()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myRankLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myKDALabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myKillsLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myHeadShotsLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myWinLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myTotalScoreLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myTotalGameTimeLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myWinStreakLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myAccuracyLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myMostPlayedModeLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myTopThreeTimesLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myLastKillTimesLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myFirstBloodTimesLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myMostKillStreakKillsLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myKillstreaksLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myMostKillStreakLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myRankLabel.text = Dict.PLAYER_INFO_TOTAL_RANK_LABEL;
         this.myKDALabel.text = Dict.PLAYER_INFO_TOTAL_KDA_LABEL;
         this.myKillsLabel.text = Dict.PLAYER_INFO_TOTAL_KILL_LABEL;
         this.myHeadShotsLabel.text = Dict.PLAYER_INFO_TOTAL_HEADSHOT_LABEL;
         this.myWinLabel.text = Dict.PLAYER_INFO_TOTAL_WIN_LABEL;
         this.myTotalScoreLabel.text = Dict.PLAYER_INFO_TOTAL_SCORE_LABEL;
         this.myTotalGameTimeLabel.text = Dict.PLAYER_INFO_TOTAL_GAME_TIME_LABEL;
         this.myWinStreakLabel.text = Dict.PLAYER_INFO_WIN_STREAK_LABEL;
         this.myAccuracyLabel.text = Dict.PLAYER_INFO_TOTAL_ACCURACY_LABEL;
         this.myMostPlayedModeLabel.text = Dict.PLAYER_INFO_MOST_PLAYED_MODE_LABEL;
         this.myTopThreeTimesLabel.text = Dict.PLAYER_INFO_TOP_THREE_LABEL;
         this.myLastKillTimesLabel.text = Dict.PLAYER_INFO_LAST_KILL_LABEL;
         this.myFirstBloodTimesLabel.text = Dict.PLAYER_INFO_FIRST_BLOOD_LABEL;
         this.myMostKillStreakKillsLabel.text = Dict.PLAYER_INFO_MOST_KILLSTREAK_KILL_LABEL;
         this.myKillstreaksLabel.text = Dict.PLAYER_INFO_KILL_STREAKS_LABEL;
         this.myMostKillStreakLabel.text = Dict.PLAYER_INFO_MOST_KILLSTREAK_LABEL;
         this.myRank.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myRank.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myKDA.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myKills.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myHeadshots.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myWin.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myTotalScore.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myTotalGameTime.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myTotalGameTime.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myWinStreak.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myAccuracy.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myMostPlayedMode.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myMostPlayedMode.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myLastKillTimes.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myLastKillTimes.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myMostKillStreakKills.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myMostKillStreakKills.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myFirstBloodTimes.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myFirstBloodTimes.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myTopThreeTimes.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myTopThreeTimes.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myMostKillStreak.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myMostKillStreak.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myWeaponKillChartLabel.textStyle = ClanGuide.stylePlayerDetailCategoryLabelStyle;
         this.myWeaponUsageChart.myColumnLabel0.text = DictMarket.CATEGORY_ASSAULT_RIFLE;
         this.myWeaponUsageChart.myColumnLabel1.text = DictMarket.CATEGORY_SMG;
         this.myWeaponUsageChart.myColumnLabel2.text = DictMarket.CATEGORY_LMG;
         this.myWeaponUsageChart.myColumnLabel3.text = DictMarket.CATEGORY_SNIPER;
         this.myWeaponUsageChart.myColumnLabel4.text = DictMarket.CATEGORY_SHOTGUN;
         this.myWeaponKillChartLabel.text = Dict.PLAYER_INFO_WEAPON_TYPE_KILL_LABEL;
         this.myLoadout.myPrimaryWeaponSlot.myItemLevelDisplay.visible = false;
         this.myLoadout.mySecondaryWeaponSlot.myItemLevelDisplay.visible = false;
         this.myLoadoutMelee.myPrimaryMeleeWeaponSlot.myItemLevelDisplay.visible = false;
         this.myLoadoutMelee.mySecondaryMeleeWeaponSlot.myItemLevelDisplay.visible = false;
         this.myLoadout.registerFocusEvent(this.onLoadoutSlotFocused);
         this.myLoadout.registerUnfocusEvent(this.onLoadoutSlotUnfocused);
         this.myLoadoutMelee.registerFocusEvent(this.onLoadoutMeleeSlotFocused);
         this.myLoadoutMelee.registerUnfocusEvent(this.onLoadoutMeleeSlotUnfocused);
         this.myKillStreak0.registerFocusEvent(this.onLoadoutSlotFocused,this.myKillStreak0);
         this.myKillStreak1.registerFocusEvent(this.onLoadoutSlotFocused,this.myKillStreak1);
         this.myKillStreak2.registerFocusEvent(this.onLoadoutSlotFocused,this.myKillStreak2);
         this.myKillStreak0.registerUnfocusEvent(this.onLoadoutSlotUnfocused);
         this.myKillStreak1.registerUnfocusEvent(this.onLoadoutSlotUnfocused);
         this.myKillStreak2.registerUnfocusEvent(this.onLoadoutSlotUnfocused);
         this.myLoadout.registerClickEvent(this.onLoadoutSlotClicked);
         this.myLoadoutMelee.registerClickEvent(this.onLoadoutSlotClicked);
         this.myKillStreak0.registerClickEvent(this.onLoadoutSlotClicked,this.myKillStreak0);
         this.myKillStreak1.registerClickEvent(this.onLoadoutSlotClicked,this.myKillStreak1);
         this.myKillStreak2.registerClickEvent(this.onLoadoutSlotClicked,this.myKillStreak2);
         var tabs:Array = new Array();
         tabs.push({
            "id":0,
            "label":DictInGame.Customize1
         });
         tabs.push({
            "id":1,
            "label":DictInGame.Customize2
         });
         tabs.push({
            "id":2,
            "label":DictInGame.Customize3
         });
         var tabData:Object = new Object();
         tabData.tabClickedCallback = this.onSelectLoadout;
         tabData.tabs = tabs;
         tabData.tabLinkage = ButtonFactory.SCROLL_LIST_TAB_BUTTON_LINKAGE;
         this.myTabNavigation.setData(tabData);
         this.myPrimaryLoadoutTab.selected = true;
         this.myPrimaryLoadoutTab.label = DictMarket.ITEM_MENU_PRIMARY;
         this.myPrimaryLoadoutTab.index = this.PRIMARY_LOADOUT_TAB_INDEX;
         this.myPrimaryLoadoutTab.tabSelectedCallback = this.setSelectedTab;
         this.myMeleeLoadoutTab.selected = false;
         this.myMeleeLoadoutTab.label = DictMarket.ITEM_MENU_MELEE;
         this.myMeleeLoadoutTab.index = this.MELEE_LOADOUT_TAB_INDEX;
         this.myMeleeLoadoutTab.tabSelectedCallback = this.setSelectedTab;
         this.myLoadout.visible = true;
         this.myLoadoutMelee.visible = false;
      }
      
      protected function setSelectedTab(index:int) : void
      {
         if(index == this.PRIMARY_LOADOUT_TAB_INDEX)
         {
            this.myLoadout.visible = true;
            this.myLoadoutMelee.visible = false;
            this.myMeleeLoadoutTab.selected = false;
         }
         else
         {
            this.myLoadout.visible = false;
            this.myLoadoutMelee.visible = true;
            this.myPrimaryLoadoutTab.selected = false;
         }
      }
      
      private function onSelectLoadout(idx:int) : void
      {
         this.myLoadout.setLoadoutData(Boolean(this._classes) ? this._classes[idx] : null);
         this.myLoadoutMelee.setLoadoutData(Boolean(this._classes) ? this._classes[idx] : null);
      }
      
      private function onLoadoutSlotFocused(item:UIInteractiveComponent) : void
      {
         if(!item.getData())
         {
            return;
         }
         var slotItemID:int = Boolean(item.getData().item_id) ? int(item.getData().item_id) : int(item.getData().id);
         var data:ProductObj = slotItemID > 0 ? CFunctionCommonContainer.GetItemInfo(slotItemID) : null;
         if(Boolean(data))
         {
            broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":data,
               "compare":true
            });
         }
      }
      
      private function onLoadoutMeleeSlotFocused(item:UIInteractiveComponent) : void
      {
         if(!item.getData())
         {
            return;
         }
         var slotItemID:int = Boolean(item.getData().item_id) ? int(item.getData().item_id) : int(item.getData().id);
         var data:ProductObj = slotItemID > 0 ? CFunctionCommonContainer.GetItemInfo(slotItemID) : null;
         if(Boolean(data))
         {
            broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":data,
               "compare":true
            });
         }
      }
      
      private function onLoadoutSlotUnfocused() : void
      {
         broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      private function onLoadoutMeleeSlotUnfocused() : void
      {
         broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      private function onLoadoutSlotClicked(item:UIInteractiveComponent) : void
      {
         var prodData:ProductObj = item.getData() as ProductObj;
         if(null != prodData && 0 != prodData.id)
         {
            broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prodData});
         }
      }
      
      public function setData(data:*) : void
      {
         this.myKDA.visible = this.myKDALabel.visible = this.IsFullVersion;
         this.myRank.text = this.formatRank(data.prestige,data.rank);
         this.myKDA.text = String(Number(data.kda).toFixed(2));
         this.myKills.text = data.kills;
         this.myHeadshots.text = data.headshots;
         this.myWin.text = data.wins;
         this.myTotalScore.text = data.score;
         this.myTotalGameTime.text = (data.timePlayedTotal / 3600).toFixed(0).toString() + LocalizeUtil.localize(Dict.HOUR);
         this.myWinStreak.text = data.winStreak;
         this.myAccuracy.text = Number(data.accuracy / 100).toFixed(2) + "%";
         var mostPlayedGameModeRef:String = data.mostPlayedMode as String;
         if(mostPlayedGameModeRef.length > 0)
         {
            this.myMostPlayedMode.text = LocalizeUtil.localize("@" + mostPlayedGameModeRef);
         }
         else
         {
            this.myMostPlayedMode.text = Dict.PLAYER_INFO_NOT_AVAILABLE;
         }
         this.myWeaponUsageChart.setData([data.astKill,data.smgKill,data.lmgKill,data.snpKill,data.shoKill]);
         this.myKDALabel.visible = this.myKDA.visible = this.mIsFullVersion;
         this.myMostKillStreakKills.text = data.mostKillstreakKills;
         this.myFirstBloodTimes.text = data.firstBloodTimes;
         this.myLastKillTimes.text = data.lastKillTimes;
         this.myTopThreeTimes.text = data.topThreeTimes;
         this.myMostKillStreak.text = data.killStreak;
         this._classes = data.loadouts;
         this.myTabNavigation.SetSelectedIndex(0);
         this.onSelectLoadout(0);
         var killStreaks:Array = data.killstreaks;
         if(Boolean(killStreaks))
         {
            this.myKillStreak0.setData(CFunctionCommonContainer.GetItemInfo(int(killStreaks[0])));
            this.myKillStreak1.setData(CFunctionCommonContainer.GetItemInfo(int(killStreaks[1])));
            this.myKillStreak2.setData(CFunctionCommonContainer.GetItemInfo(int(killStreaks[2])));
         }
      }
      
      private function formatRank(prestige:int, rank:int) : String
      {
         var levelStr:String = CFunctionCommonContainer.GetDisplayLevel(rank);
         if(prestige == 0)
         {
            return LocalizeUtil.param(DictCareer.CAREER_X_LEVEL,[levelStr]);
         }
         return LocalizeUtil.param(DictCareer.CAREER_X_PRESTIGE,[String(prestige),levelStr]);
      }
      
      public function set IsFullVersion(isFull:Boolean) : void
      {
         this.mIsFullVersion = isFull;
      }
      
      public function get IsFullVersion() : Boolean
      {
         return this.mIsFullVersion;
      }
      
      public function playAnimation() : void
      {
         this.myWeaponUsageChart.playAnimation();
      }
      
      override public function active() : void
      {
         super.active();
         this.playAnimation();
      }
   }
}

