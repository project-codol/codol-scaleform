package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.QuickMatchType;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.localization.DictRoom;
   import codo.objects.PlayListObj;
   import codo.objects.ProductObj;
   import codo.objects.RewardItemList;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import codo.services.MatchService;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import components.fsggamemodes_part.FsgFilterListItem;
   import flash.display.MovieClip;
   import flash.events.Event;
   import fsg.GameMode.fsgGameModeReward;
   import fsg.gamemodes.fsgFilterListItem;
   import fsg.gamemodes.fsgRewardsListItem;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.BehaviourTooltip;
   import fsg.util.FsgAudioUtil;
   
   public class FsgGameModesMapRewardView extends BaseView
   {
      
      private static var mInitialFilters:Vector.<String>;
      
      public static var InitialTab:int = 0;
      
      private static const FILTERS:Vector.<String> = new <String>[DictRoom.MAP_TYPE_ALL,DictRoom.MODE_SPECIFIC,Dict.REWARD_GOLD,Dict.REWARD_SILVER,Dict.REWARD_BRONZE];
      
      private static const FILTERS_HERO_OPS:Vector.<String> = new <String>[DictRoom.MAP_TYPE_ALL,DictRoom.MODE_SPECIFIC];
      
      private const SELECTION_ALL:int = 0;
      
      private const SELECTION_MODE_SPECIFIC:int = 1;
      
      private const SELECTION_GOLD:int = 2;
      
      private const SELECTION_SILVER:int = 3;
      
      private const SELECTION_BRONZE:int = 4;
      
      private const SELECTION_MODE_ULTIMATE:int = 5;
      
      public var myTitleText:MovieClip;
      
      public var mySubtitleText:MovieClip;
      
      public var myFinishBtn:Button;
      
      public var myPointsTabs:MovieClip;
      
      public var myMapDescriptionText:MovieClip;
      
      public var myModeTitleText:MovieClip;
      
      public var myRewardScrollPanel:MovieClip;
      
      public var mScrollGrid:ScrollGrid;
      
      public var myFilterList:MovieClip;
      
      private var m_goldTab:MovieClip;
      
      private var m_silverTab:MovieClip;
      
      private var m_bronzeTab:MovieClip;
      
      private var m_maps:Array;
      
      private var m_randomRewardsByMap:Vector.<RewardItemList>;
      
      private var m_randomRewardsForMode:RewardItemList;
      
      private var m_uniqueRandomRewardsForMode:RewardItemList;
      
      private var m_ultimateRandomRewardsForMode:RewardItemList;
      
      private var m_scoresByMode:Array = [];
      
      private var m_scoresByMap:Array = [];
      
      private var m_numValidMapScores:int;
      
      private var m_medalClickable:Array = [];
      
      private var m_medalToolTips:Array = [];
      
      private var m_currentlySelected:FsgFilterListItem;
      
      private var m_rewardMovieCache:Vector.<fsgGameModeReward>;
      
      private var m_rewardListMovieCache:Vector.<fsgRewardsListItem>;
      
      private var _itemsData:Array;
      
      private var mHeaders:Vector.<ScrollListHeaderObj>;
      
      private var mMatchType:QuickMatchType;
      
      private var mPlaylist:PlayListObj;
      
      public function FsgGameModesMapRewardView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         var clickable:BehaviourClickable = null;
         var tooltip:BehaviourTooltip = null;
         super.onInit();
         this.m_maps = new Array();
         this.m_randomRewardsByMap = new Vector.<RewardItemList>();
         this.m_randomRewardsForMode = new RewardItemList();
         this.m_uniqueRandomRewardsForMode = new RewardItemList();
         this.m_ultimateRandomRewardsForMode = new RewardItemList();
         try
         {
            this.m_goldTab = this.myPointsTabs.GoldTab;
            this.m_goldTab.gotoAndStop(1);
            this.m_goldTab.myPointsTypeTitle.myMedalText.text = Dict.REWARD_GOLD;
            clickable = new BehaviourClickable(this.m_goldTab);
            clickable.addMouseOverCallback(this.onPointTabMouseOver);
            clickable.addMouseOutCallback(this.onPointTabMouseOut);
            clickable.addMouseDownCallback(this.onPointTabClick,this.m_goldTab);
            this.m_medalClickable.push(clickable);
            tooltip = new BehaviourTooltip(clickable,"",this.m_goldTab);
            this.m_medalToolTips.push(tooltip);
            this.m_silverTab = this.myPointsTabs.SilverTab;
            this.m_silverTab.gotoAndStop(2);
            this.m_silverTab.myPointsTypeTitle.myMedalText.text = Dict.REWARD_SILVER;
            clickable = new BehaviourClickable(this.m_silverTab);
            clickable.addMouseOverCallback(this.onPointTabMouseOver);
            clickable.addMouseOutCallback(this.onPointTabMouseOut);
            clickable.addMouseDownCallback(this.onPointTabClick,this.m_silverTab);
            this.m_medalClickable.push(clickable);
            tooltip = new BehaviourTooltip(clickable,"",this.m_silverTab);
            this.m_medalToolTips.push(tooltip);
            this.m_bronzeTab = this.myPointsTabs.BronzeTab;
            this.m_bronzeTab.gotoAndStop(3);
            this.m_bronzeTab.myPointsTypeTitle.myMedalText.text = Dict.REWARD_BRONZE;
            clickable = new BehaviourClickable(this.m_bronzeTab);
            clickable.addMouseOverCallback(this.onPointTabMouseOver);
            clickable.addMouseOutCallback(this.onPointTabMouseOut);
            clickable.addMouseDownCallback(this.onPointTabClick,this.m_bronzeTab);
            this.m_medalClickable.push(clickable);
            tooltip = new BehaviourTooltip(clickable,"",this.m_bronzeTab);
            this.m_medalToolTips.push(tooltip);
         }
         catch(e:Error)
         {
         }
         this.myFinishBtn.registerClickEvent(this.onClickFinish);
         this.myFinishBtn.label = LocalizeUtil.localize("@SF_UI_FINISH");
         var label:TextField = this.mySubtitleText.myLabel;
         label.text = "@SF_UI_TREASURE_BOX_PRIZES";
         this.m_rewardMovieCache = new Vector.<fsgGameModeReward>();
         this.m_rewardListMovieCache = new Vector.<fsgRewardsListItem>();
         this.mScrollGrid = this.myRewardScrollPanel.myScrollGrid;
         var listSettings:ScrollGridSettings = new ScrollGridSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         var itemRenderer:Function = MarketFactory.GET_BUILD_MARKET_ITEM_CARD_FUNC(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false,false,false);
         listSettings.buildGridItemRenderMethod = itemRenderer;
         listSettings.useNavArrows = false;
         this.mScrollGrid.initGrid(listSettings,434,true,4);
         this.mScrollGrid.visible = true;
         this.mHeaders = new Vector.<ScrollListHeaderObj>(0);
      }
      
      override protected function showView() : void
      {
         var filter:FsgFilterListItem = null;
         super.showView();
         this.mMatchType = getDP(DataID.CURRENT_MATCH_TYPE);
         this.mPlaylist = PlayListObj.getSelectedPlaylist();
         if(!this.mMatchType.isHeroOps())
         {
            mInitialFilters = FILTERS;
            this.myPointsTabs.visible = true;
         }
         else
         {
            mInitialFilters = FILTERS_HERO_OPS;
            this.myPointsTabs.visible = false;
         }
         this.myTitleText.text_txt.text = LocalizeUtil.param("@SF_UI_MAP_REWARDS",[LocalizeUtil.localize(this.mMatchType.modeLabel())]);
         this.gatherMapInfo();
         this.gatherRandomRewards();
         this.populateFilterList();
         if(ScaleformUtil.isScaleform)
         {
            this.m_numValidMapScores = 0;
            this.gatherScoreData();
            filter = this.myFilterList.getChildAt(InitialTab) as FsgFilterListItem;
            if(Boolean(filter))
            {
               filter.select();
            }
         }
         if(currentFrame == 1)
         {
            gotoAndPlay(2);
         }
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
            gotoAndPlay(2);
         }
      }
      
      override protected function hideView() : void
      {
         gotoAndPlay("close");
         addEventListener(Event.ENTER_FRAME,this.onCheckFrame,false,0,true);
      }
      
      private function onCheckFrame(evt:Event) : void
      {
         if(evt.currentTarget.currentFrame == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
            super.hideView();
         }
      }
      
      private function onClickFinish() : void
      {
         broadcast(BCEvent.GOTO_PREV_PAGE);
      }
      
      private function onPointTabClick(usrData:Object) : void
      {
         var filter:FsgFilterListItem = null;
         var index:int = -1;
         if(usrData == this.m_goldTab)
         {
            index = this.SELECTION_GOLD;
         }
         else if(usrData == this.m_silverTab)
         {
            index = this.SELECTION_SILVER;
         }
         else if(usrData == this.m_bronzeTab)
         {
            index = this.SELECTION_BRONZE;
         }
         if(index != -1)
         {
            filter = this.myFilterList.getChildAt(index) as FsgFilterListItem;
            if(Boolean(filter))
            {
               FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_PROCEED);
               filter.select();
            }
         }
      }
      
      private function onPointTabMouseOver() : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         FsgAudioUtil.getInstance().playSound("ui_reward_infobar_rollover");
      }
      
      private function onPointTabMouseOut() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function gatherMapInfo() : void
      {
         var mapArray:Array = null;
         var bAlreadyAdded:Boolean = false;
         var k:int = 0;
         this.m_maps.length = 0;
         if(this.mMatchType.isHeroOps() || this.mMatchType.isBattleCity)
         {
            mapArray = [];
         }
         else
         {
            mapArray = this.mPlaylist.maps;
         }
         for(var j:int = 0; j < mapArray.length; j++)
         {
            bAlreadyAdded = false;
            for(k = 0; k < this.m_maps.length; k++)
            {
               if(this.m_maps[k].name == mapArray[j].name)
               {
                  bAlreadyAdded = true;
                  break;
               }
            }
            if(bAlreadyAdded == false)
            {
               this.m_maps.push(mapArray[j]);
            }
         }
      }
      
      private function gatherRandomRewards() : void
      {
         var list:RewardItemList = null;
         var matchTypeString:String = !this.mMatchType.isHeroOps() ? MatchService.getPlaylistRewardID(this.mPlaylist) : QuickMatchType.ID_COOP_HERO_OPS_SURVIVAL;
         var numSpliced:int = 0;
         this.m_randomRewardsByMap.length = 0;
         var numMaps:int = int(this.m_maps.length);
         for(var i:int = 0; i < numMaps; i++)
         {
            list = new RewardItemList();
            list.SetData(CFunctionContainer.AS_GetRewardsForModeAndMap(matchTypeString,this.m_maps[i - numSpliced].id,false),true);
            if(list.all.length > 0)
            {
               this.m_randomRewardsByMap.push(list);
            }
            else
            {
               this.m_maps.splice(i - numSpliced,1);
               numSpliced++;
            }
         }
         this.m_randomRewardsForMode.SetData(CFunctionContainer.AS_GetRewardsForModeAndMap(matchTypeString,"all",false),false);
         this.m_uniqueRandomRewardsForMode.SetData(CFunctionContainer.AS_GetRewardsForModeAndMap(matchTypeString,"all",true),true);
         if(this.mMatchType.isBattleCity)
         {
            this.m_ultimateRandomRewardsForMode.SetData(CFunctionContainer.AS_GetRewardsForModeAndMap("bcu","all",true),true);
         }
      }
      
      private function gatherScoreData() : void
      {
         var mapScores:Array = null;
         var j:int = 0;
         var matchType:Array = [];
         matchType[0] = !this.mMatchType.isHeroOps() ? MatchService.getPlaylistRewardID(this.mPlaylist) : QuickMatchType.ID_COOP_HERO_OPS_SURVIVAL;
         this.m_scoresByMode.length = 0;
         this.m_scoresByMap.length = 0;
         var scoreArray:Array = CFunctionContainer.AS_GetScoresForMode(matchType);
         var scoresForMode:Array = scoreArray[0];
         var scoresForMaps:Array = scoreArray[1];
         this.m_scoresByMode = scoresForMode;
         for each(mapScores in scoresForMaps)
         {
            j = 0;
            while(j < this.m_maps.length)
            {
               if(mapScores[0] == this.m_maps[j].id)
               {
                  this.m_scoresByMap[j] = [this.m_maps[j].name,mapScores[1],mapScores[2],mapScores[3]];
                  ++this.m_numValidMapScores;
                  break;
               }
               j++;
            }
         }
      }
      
      private function populateFilterList() : void
      {
         var forEach:Function;
         var i:int;
         var numButtons:int;
         var j:int;
         var filterButton:FsgFilterListItem = null;
         var iOffsetted:int = 0;
         var filter:FsgFilterListItem = null;
         while(this.myFilterList.numChildren > 0)
         {
            this.myFilterList.removeChildAt(0);
         }
         forEach = function(filter:String, index:uint, vec:Vector.<String>):void
         {
            filterButton = new fsgFilterListItem();
            if(filter != DictRoom.MODE_SPECIFIC && filter != DictRoom.MODE_ULTIMATE)
            {
               filterButton.setText(filter);
            }
            else
            {
               filterButton.setText(LocalizeUtil.localize(mMatchType.modeLabel()) + "-" + LocalizeUtil.localize(filter));
            }
            myFilterList.addChild(filterButton);
            filterButton.y = filterButton.height * index;
            filterButton.addSelectedCallback(showMapInfo,index);
         };
         mInitialFilters.forEach(forEach,this);
         for(i = 0; i < this.m_maps.length; i++)
         {
            iOffsetted = i + mInitialFilters.length;
            if(this.myFilterList.numChildren > iOffsetted)
            {
               filterButton = this.myFilterList.getChildAt(iOffsetted) as fsgFilterListItem;
            }
            else
            {
               filterButton = new fsgFilterListItem();
               this.myFilterList.addChild(filterButton);
               filterButton.y = filterButton.height * iOffsetted;
            }
            filterButton.setText(this.m_maps[i].name);
            filterButton.addSelectedCallback(this.showMapInfo,iOffsetted);
         }
         numButtons = mInitialFilters.length + this.m_maps.length;
         while(this.myFilterList.numChildren > numButtons)
         {
            this.myFilterList.removeChildAt(this.myFilterList.numChildren - 1);
         }
         for(j = 0; j < numButtons; j++)
         {
            filter = this.myFilterList.getChildAt(j) as FsgFilterListItem;
            filter.unselect();
         }
      }
      
      private function SetHeaderInformationForMode() : void
      {
         var i:int = 0;
         var scores:Array = null;
         var mapName:String = null;
         var j:int = 0;
         var toolTipString:Array = ["","",""];
         if(this.m_numValidMapScores == 0)
         {
            this.m_goldTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMode[0][3]]);
            this.m_silverTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMode[0][2]]);
            this.m_bronzeTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMode[0][1]]);
         }
         else
         {
            for(i = 0; i < this.m_scoresByMap.length; i++)
            {
               scores = this.m_scoresByMap[i];
               if(scores != null)
               {
                  mapName = scores[0];
                  for(j = 0; j < scores.length; j++)
                  {
                     toolTipString[j] += LocalizeUtil.localize(mapName) + ": " + scores[3 - j] + "\n";
                  }
               }
            }
            this.myPointsTabs.GoldTab.myPointsCountText.myText.text = "@SF_UI_MORE_INFO";
            this.myPointsTabs.SilverTab.myPointsCountText.myText.text = "@SF_UI_MORE_INFO";
            this.myPointsTabs.BronzeTab.myPointsCountText.myText.text = "@SF_UI_MORE_INFO";
         }
         for(var k:int = 0; k < 3; k++)
         {
            this.m_medalToolTips[k].tipText = toolTipString[k];
         }
      }
      
      protected function refreshItems() : void
      {
         var item:ProductObj = null;
         var items:Vector.<Object> = new Vector.<Object>();
         for(var i:int = 0; i < this._itemsData.length; i++)
         {
            item = this._itemsData[i];
            item.disableExtendOptionForOnboarding = true;
            items.push(item);
         }
         this.mScrollGrid.addItemsByVector(items);
      }
      
      private function addHeader(title:String, desc:String, beforeIndex:int, count:int) : void
      {
         var header:ScrollListHeaderObj = null;
         header = new ScrollListHeaderObj();
         header.beforeIndex = beforeIndex;
         header.count = count;
         header.label = LocalizeUtil.localize(title) + ":" + LocalizeUtil.localize(desc);
         this.mHeaders.push(header);
      }
      
      private function setHeaders() : void
      {
         this.mScrollGrid.setHeaders(this.mHeaders);
      }
      
      private function showMapInfo(index:int) : void
      {
         var newSelection:FsgFilterListItem;
         var rewardTierSelected:int;
         var tierItems:Array;
         var forEachFunc:Function;
         var currentLength:int = 0;
         var randomRewardsByMapEntry:RewardItemList = null;
         var mapDescText:String = null;
         var mapIndex:int = 0;
         var randomRewardsByMode:RewardItemList = null;
         var modeItemList:Array = null;
         var selectedItemList:Array = null;
         var randomRewardsByMode2:RewardItemList = null;
         var modeItemList2:Array = null;
         var ultimateRewardsByMode:RewardItemList = null;
         var ultimateItemList:Array = null;
         var medalLoc:String = null;
         var mapName:String = null;
         var k:int = 0;
         currentLength = 0;
         this._itemsData = new Array();
         this.mHeaders = new Vector.<ScrollListHeaderObj>(0);
         newSelection = this.myFilterList.getChildAt(index) as FsgFilterListItem;
         if(Boolean(this.m_currentlySelected) && this.m_currentlySelected != newSelection)
         {
            this.m_currentlySelected.unselect();
         }
         this.m_currentlySelected = newSelection;
         rewardTierSelected = index - 2;
         tierItems = [[],[],[],[]];
         if(index == this.SELECTION_ALL)
         {
            mapDescText = "@SF_UI_MAPSPECIFICREWARDS_DESCRIPTION";
            this.SetHeaderInformationForMode();
            for(mapIndex = 0; mapIndex < this.m_maps.length; mapIndex++)
            {
               randomRewardsByMapEntry = this.m_randomRewardsByMap[mapIndex];
               selectedItemList = new Array();
               switch(rewardTierSelected)
               {
                  case Common.REWARD_TIER_GOLD:
                     selectedItemList = randomRewardsByMapEntry.all;
                     break;
                  case Common.REWARD_TIER_SILVER:
                     selectedItemList = randomRewardsByMapEntry.bronze.concat(randomRewardsByMapEntry.silver);
                     break;
                  case Common.REWARD_TIER_BRONZE:
                     selectedItemList = randomRewardsByMapEntry.bronze;
                     break;
                  default:
                     selectedItemList = randomRewardsByMapEntry.all;
               }
               if(selectedItemList.length > 0)
               {
                  this._itemsData = this._itemsData.concat(selectedItemList);
                  this.addHeader(this.m_maps[mapIndex].name,Dict.RANDOM_REWARDS_MAP_DESCRIPTION,currentLength,selectedItemList.length);
                  currentLength += selectedItemList.length;
               }
            }
            randomRewardsByMode = this.m_uniqueRandomRewardsForMode;
            modeItemList = randomRewardsByMode.all;
            this._itemsData = this._itemsData.concat(modeItemList);
            this.addHeader(DictRoom.MODE_SPECIFIC,Dict.RANDOM_REWARDS_MODE_DESRIPTION,currentLength,modeItemList.length);
            currentLength += modeItemList.length;
         }
         else if(index == this.SELECTION_MODE_SPECIFIC)
         {
            mapDescText = "@SF_UI_MAPSPECIFICREWARDS_DESCRIPTION";
            this.SetHeaderInformationForMode();
            randomRewardsByMode2 = this.m_uniqueRandomRewardsForMode;
            modeItemList2 = randomRewardsByMode2.all;
            this._itemsData = this._itemsData.concat(modeItemList2);
            this.addHeader(DictRoom.MODE_SPECIFIC,Dict.RANDOM_REWARDS_MODE_DESRIPTION,currentLength,modeItemList2.length);
            currentLength += modeItemList2.length;
         }
         else if(index == this.SELECTION_MODE_ULTIMATE)
         {
            mapDescText = "@SF_UI_MAPULTIMATE_DESCRIPTION";
            this.SetHeaderInformationForMode();
            ultimateRewardsByMode = this.m_ultimateRandomRewardsForMode;
            ultimateItemList = ultimateRewardsByMode.all;
            this._itemsData = this._itemsData.concat(ultimateItemList);
            this.addHeader(DictRoom.MODE_ULTIMATE,mapDescText,currentLength,ultimateItemList.length);
            currentLength += ultimateItemList.length;
         }
         else if(index <= this.SELECTION_BRONZE)
         {
            medalLoc = LocalizeUtil.localize(mInitialFilters[index]);
            mapDescText = LocalizeUtil.param("@SF_UI_TIERSPECIFICREWARDS_DESCRIPTION",[medalLoc]);
            this.SetHeaderInformationForMode();
         }
         else
         {
            index -= mInitialFilters.length;
            mapName = this.m_maps[index].name;
            mapDescText = this.m_maps[index].description;
            if(this.m_randomRewardsByMap[index].all.length > 0)
            {
               this._itemsData = this._itemsData.concat(this.m_randomRewardsByMap[index].all);
               this.addHeader(mapName,Dict.RANDOM_REWARDS_MAP_DESCRIPTION,currentLength,this.m_randomRewardsByMap[index].all.length);
               currentLength += this.m_randomRewardsByMap[index].all.length;
            }
            for(k = 0; k < 3; k++)
            {
               this.m_medalToolTips[k].tipText = "";
            }
            if(this.m_scoresByMap.length < index || this.m_scoresByMap[index] == null)
            {
               this.m_goldTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMode[0][3]]);
               this.m_silverTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMode[0][2]]);
               this.m_bronzeTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMode[0][1]]);
            }
            else
            {
               this.m_goldTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMap[index][3]]);
               this.m_silverTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMap[index][2]]);
               this.m_bronzeTab.myPointsCountText.myText.text = LocalizeUtil.param("@SF_UI_REWARD_REQUIREMENTS",[this.m_scoresByMap[index][1]]);
            }
         }
         this.myMapDescriptionText.myTextTF.text = mapDescText;
         if(rewardTierSelected == Common.REWARD_TIER_ALL && this.mMatchType.isHeroOps())
         {
            rewardTierSelected = Common.REWARD_TIER_HERO_OPS;
         }
         switch(rewardTierSelected)
         {
            case Common.REWARD_TIER_HERO_OPS:
               tierItems[3] = tierItems[3].concat(this.m_randomRewardsForMode.bronze);
               break;
            case Common.REWARD_TIER_ALL:
            case Common.REWARD_TIER_GOLD:
               tierItems[Common.REWARD_TIER_GOLD] = tierItems[Common.REWARD_TIER_GOLD].concat(this.m_randomRewardsForMode.gold);
            case Common.REWARD_TIER_SILVER:
               tierItems[Common.REWARD_TIER_SILVER] = tierItems[Common.REWARD_TIER_SILVER].concat(this.m_randomRewardsForMode.silver);
            case Common.REWARD_TIER_BRONZE:
               tierItems[Common.REWARD_TIER_BRONZE] = tierItems[Common.REWARD_TIER_BRONZE].concat(this.m_randomRewardsForMode.bronze);
         }
         forEachFunc = function(items:Array, tier:int, arr:Array):void
         {
            var description:String = null;
            if(items.length <= 0)
            {
               return;
            }
            _itemsData = _itemsData.concat(items);
            switch(tier)
            {
               case Common.REWARD_TIER_GOLD:
                  addHeader(Dict.REWARD_GOLD,Dict.RANDOM_REWARDS_GOLD_DESCRIPTION,currentLength,items.length);
                  break;
               case Common.REWARD_TIER_SILVER:
                  description = LocalizeUtil.param(Dict.RANDOM_REWARDS_TIER_DESCRIPTION,[LocalizeUtil.localize(Dict.REWARD_SILVER)]);
                  addHeader(Dict.REWARD_SILVER,description,currentLength,items.length);
                  break;
               case Common.REWARD_TIER_BRONZE:
                  description = LocalizeUtil.param(Dict.RANDOM_REWARDS_TIER_DESCRIPTION,[LocalizeUtil.localize(Dict.REWARD_BRONZE)]);
                  addHeader(Dict.REWARD_BRONZE,description,currentLength,items.length);
                  break;
               default:
                  description = LocalizeUtil.param(Dict.RANDOM_REWARDS_TIER_DESCRIPTION,[LocalizeUtil.localize(DictMarket.CATEGORY_OTHER)]);
                  addHeader(DictMarket.CATEGORY_OTHER,DictMarket.CATEGORY_OTHER,currentLength,items.length);
            }
            currentLength += items.length;
         };
         tierItems.forEach(forEachFunc,this);
         this.myModeTitleText.myTextTF.text = newSelection.myLabelText.myTextTF.text;
         this.setHeaders();
         this.refreshItems();
      }
   }
}

