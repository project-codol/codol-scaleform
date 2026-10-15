package codo.views.wargod_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.LeaderboardToggleButton;
   import codo.component.TextField;
   import codo.component.social.PageListSelector;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.WebImgData;
   import codo.localization.Dict;
   import codo.localization.DictWarGod;
   import codo.objects.PageListSettings;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.style.TextStyle;
   import codo.style.WarGodGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import codo.views.leaderboard_sub.detail_sub.LeaderBoardPageList;
   
   public class WarGodLeaderboardPanel extends BaseSubElement
   {
      
      private static const WARGOD_LEADERBOARD_ITEM_LINKAGE:String = "codo.wargod.wargodLeaderboardItem";
      
      private static const PAGE_SIZE:int = 12;
      
      private static const LEADERBOARD_TYPE_ALL:int = 0;
      
      private static const LEADERBOARD_TYPE_ZONE:int = 1;
      
      private static const LEADERBOARD_TYPE_FRIENDS:int = 2;
      
      private static const MAX_SHOWN_SELF_RANK:int = 5000;
      
      private static const TAB_POS:Array = [25,143,261];
      
      private static const TAB_CONFIG_NORMAL:Array = [DictWarGod.TOP_100,DictWarGod.ZONE_TOP,DictWarGod.FRIENDS_AND_NEARBY];
      
      private static const TAB_CONFIG_NO_LOCAL:Array = [DictWarGod.TOP_100,DictWarGod.FRIENDS_AND_NEARBY];
      
      public var myTab0:LeaderboardToggleButton;
      
      public var myTab1:LeaderboardToggleButton;
      
      public var myTab2:LeaderboardToggleButton;
      
      public var myHeaderRank:TextField;
      
      public var myHeaderName:TextField;
      
      public var myLevel:TextField;
      
      public var myClanName:TextField;
      
      public var myHeaderWarGodScore:TextField;
      
      public var myPageList:LeaderBoardPageList;
      
      public var mySelfRank:TextField;
      
      public var mySelfRankMeter:LeaderBoardRankMeter;
      
      private var mPageListSetting:PageListSettings;
      
      private var mRequestInProgress:Boolean = false;
      
      private var mCurPage:int = 0;
      
      private var mOpenMode:int;
      
      private var mTabs:Array;
      
      private var mInitialQueried:Boolean;
      
      private var mTop100Data:Object;
      
      private var mTop100LocalZoneData:Object;
      
      private var mFriendsData:Object;
      
      private var mTop100TabIndex:int;
      
      private var mZoneTop100TabIndex:int;
      
      private var mFriendTabIndex:int;
      
      private var mGlobalSetting:WarGodGlobalSettingObj;
      
      private var mPerZoneTencentURL:String;
      
      private var mPlayerBasicInfoQueryUtil:PlayerBasicInfoQueryUtil;
      
      public function WarGodLeaderboardPanel()
      {
         super();
         this.mOpenMode = LEADERBOARD_TYPE_ALL;
         this.mTabs = [this.myTab0,this.myTab1,this.myTab2];
         var headerStyle:TextStyle = WarGodGuide.styleWarGodLeaderboardHeaderStyle;
         this.myHeaderRank.textStyle = headerStyle;
         this.myHeaderRank.text = Dict.LEADERBOARD_INDEX;
         this.myHeaderName.textStyle = headerStyle;
         this.myHeaderName.text = Dict.LEADERBOARD_USER_NAME;
         this.myLevel.textStyle = headerStyle;
         this.myLevel.text = Dict.LEADERBOARD_LEVEL;
         this.myClanName.width = 250;
         this.myClanName.textStyle = headerStyle;
         this.myClanName.text = Dict.LABEL_CLAN_NAME;
         this.myHeaderWarGodScore.textStyle = headerStyle;
         this.myHeaderWarGodScore.text = Dict.LEADERBOARD_WAR_GOD_RANKING;
         this.mySelfRank.textStyle = WarGodGuide.styleWarGodLeaderboardItem;
         this.mySelfRank.width = 300;
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = PAGE_SIZE;
         this.mPageListSetting.itemPadding = 12;
         this.mPageListSetting.renderLinkName = WARGOD_LEADERBOARD_ITEM_LINKAGE;
         this.mPageListSetting.customPageSelectorHandler = this.onPageSelectorClicked;
         this.myPageList.settings = this.mPageListSetting;
         this.myPageList.myPageListSelector.y = 566;
         this.myPageList.myPageListSelector.x = 20;
         this.mInitialQueried = false;
         this.mPlayerBasicInfoQueryUtil = new PlayerBasicInfoQueryUtil();
         this.mPlayerBasicInfoQueryUtil.registerPlayerBasicInfoHandler(this.onPlayerBasicInfo);
         this.mPlayerBasicInfoQueryUtil.registerCompleteHandler(this.onPlayerBasicInfoComplete);
      }
      
      override public function active() : void
      {
         super.active();
         this.clearLeaderboard();
         this.mRequestInProgress = false;
         this.mGlobalSetting = getDP(DataID.WARGOD_GLOBAL_SETTING);
         bind(DataID.WARGOD_LEADERBOARD_FRIENDS,this.onGetLeaderBoardFriendsData);
         bind(DataID.WARGOD_LEADERBOARD_TOP100,this.onGetLeaderBoardTop100Data);
         bind(DataID.WARGOD_LEADERBOARD_LOCAL_ZONE_TOP100,this.onGetLeaderBoardLocalZoneTop100Data);
         if(!this.mInitialQueried)
         {
            this.mCurPage = 0;
            this.mOpenMode = LEADERBOARD_TYPE_ALL;
            this.arrangeTabs();
            this.mInitialQueried = true;
         }
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.WARGOD_LEADERBOARD_FRIENDS,this.onGetLeaderBoardFriendsData);
         unbind(DataID.WARGOD_LEADERBOARD_TOP100,this.onGetLeaderBoardTop100Data);
         unbind(DataID.WARGOD_LEADERBOARD_LOCAL_ZONE_TOP100,this.onGetLeaderBoardLocalZoneTop100Data);
      }
      
      private function arrangeTabs() : void
      {
         var configInUse:Array = null;
         var enableLocalLeaderBoard:Boolean = false;
         var tabIndex:int = 0;
         var currentTab:LeaderboardToggleButton = null;
         if(this.mGlobalSetting.perZoneLBFromTencent)
         {
            this.mPerZoneTencentURL = CFunctionContainer.AS_GetWarGodZoneTopWebURL();
            enableLocalLeaderBoard = this.mPerZoneTencentURL != "";
         }
         else
         {
            enableLocalLeaderBoard = !this.mGlobalSetting.lockLocalLeaderboard;
         }
         if(enableLocalLeaderBoard)
         {
            configInUse = TAB_CONFIG_NORMAL;
            this.mTop100TabIndex = 0;
            this.mZoneTop100TabIndex = 1;
            this.mFriendTabIndex = 2;
         }
         else
         {
            configInUse = TAB_CONFIG_NO_LOCAL;
            this.mTop100TabIndex = 0;
            this.mFriendTabIndex = 1;
            this.mZoneTop100TabIndex = -1;
         }
         for(tabIndex = 0; tabIndex < this.mTabs.length; tabIndex++)
         {
            currentTab = this.mTabs[tabIndex];
            if(tabIndex < configInUse.length)
            {
               currentTab.text = configInUse[tabIndex];
               currentTab.registerClickEvent(this.onTabSelected,tabIndex);
               currentTab.setActive(tabIndex == 0);
               currentTab.showTabDivisor(tabIndex != 0);
               currentTab.visible = true;
               currentTab.x = TAB_POS[tabIndex];
            }
            else
            {
               currentTab.visible = false;
            }
         }
      }
      
      private function onGetLeaderBoardFriendsData(cResult:Object) : void
      {
         this.mFriendsData = cResult.data;
         this.refreshLeaderboard(this.mCurPage,this.mOpenMode);
      }
      
      private function onGetLeaderBoardTop100Data(cResult:Object) : void
      {
         this.mTop100Data = cResult.data;
         this.refreshLeaderboard(this.mCurPage,this.mOpenMode);
      }
      
      private function onGetLeaderBoardLocalZoneTop100Data(cResult:Object) : void
      {
         this.mTop100LocalZoneData = cResult.data;
         this.refreshLeaderboard(this.mCurPage,this.mOpenMode);
      }
      
      private function onTabSelected(index:int) : void
      {
         if(index == this.mZoneTop100TabIndex && this.mGlobalSetting.perZoneLBFromTencent)
         {
            this.openTencentPerZoneLB();
            return;
         }
         for(var i:int = 0; i < this.mTabs.length; i++)
         {
            this.mTabs[i].setActive(false);
         }
         this.mTabs[index].setActive(true);
         if(index == this.mTop100TabIndex)
         {
            this.mOpenMode = LEADERBOARD_TYPE_ALL;
         }
         else if(index == this.mZoneTop100TabIndex)
         {
            this.mOpenMode = LEADERBOARD_TYPE_ZONE;
         }
         else if(index == this.mFriendTabIndex)
         {
            this.mOpenMode = LEADERBOARD_TYPE_FRIENDS;
         }
         this.mCurPage = 0;
         this.refreshLeaderboard(this.mCurPage,this.mOpenMode);
      }
      
      private function onPageSelectorClicked(whichBtn:int) : void
      {
         var page:int = 0;
         if(whichBtn == PageListSelector.NEXT_BTN_INDEX)
         {
            page = this.mCurPage + 1;
         }
         else
         {
            page = this.mCurPage - 1;
         }
         this.refreshLeaderboard(page,this.mOpenMode);
      }
      
      private function clearLeaderboard() : void
      {
         this.myPageList.selfEntityId = null;
         this.myPageList.dataProvider = [];
         this.myPageList.hasPrevBtn = false;
         this.myPageList.hasNextBtn = false;
         this.mySelfRank.text = "";
         this.mySelfRankMeter.visible = false;
      }
      
      private function openTencentPerZoneLB() : void
      {
         var ret:Object = CFunctionCommonContainer.OpenWebPageCustom(this.mPerZoneTencentURL,WebImgData.WARGODLADDER1.x,WebImgData.WARGODLADDER1.y,WebImgData.WARGODLADDER1.width,WebImgData.WARGODLADDER1.height) as Object;
         if(Boolean(ret.succeed))
         {
            broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
               "data":WebImgData.WARGODLADDER1,
               "hideTitle":ret.hideTitle
            });
         }
      }
      
      public function refreshLeaderboard(page:int, openMode:int) : void
      {
         this.clearLeaderboard();
         var data:Object = null;
         if(openMode == LEADERBOARD_TYPE_ALL)
         {
            if(this.mTop100Data == null)
            {
               return;
            }
            data = this.mTop100Data;
         }
         if(openMode == LEADERBOARD_TYPE_ZONE)
         {
            if(this.mTop100LocalZoneData == null)
            {
               return;
            }
            data = this.mTop100LocalZoneData;
         }
         if(openMode == LEADERBOARD_TYPE_FRIENDS)
         {
            if(this.mFriendsData == null)
            {
               return;
            }
            data = this.mFriendsData;
         }
         if(data == null)
         {
            return;
         }
         if(!data.success)
         {
            return;
         }
         this.myPageList.selfEntityId = data.selfStats.entityID;
         this.myPageList.dataProvider = data.statsList.slice(page * PAGE_SIZE,(page + 1) * PAGE_SIZE);
         this.myPageList.hasPrevBtn = page > 0;
         this.myPageList.hasNextBtn = (page + 1) * PAGE_SIZE < data.statsList.length;
         this.mCurPage = page;
         this.mySelfRankMeter.visible = true;
         if(data.selfStats.rank == 0)
         {
            this.mySelfRank.text = Dict.UI_WARGOD_SELF_RANK_GREATER_THAN_5000;
            this.mySelfRankMeter.visible = false;
         }
         else if(data.selfStats.rank > MAX_SHOWN_SELF_RANK)
         {
            this.mySelfRank.text = Dict.UI_WARGOD_SELF_RANK_GREATER_THAN_5000;
            this.mySelfRankMeter.setData(data.selfStats.value);
         }
         else
         {
            this.mySelfRank.text = LocalizeUtil.param(Dict.UI_WARGOD_SELF_RANK,[data.selfStats.rank]);
            this.mySelfRankMeter.setData(data.selfStats.value);
         }
         this.mySelfRank.x = this.mySelfRankMeter.x - this.mySelfRank.textWidth - 2;
         if(data.selfStats.rank == 0)
         {
            this.mySelfRank.x = 1206 - this.mySelfRank.textWidth;
         }
         var playersIdArray:Array = new Array();
         for(var i:uint = 0; i < this.myPageList.dataProvider.length; i++)
         {
            playersIdArray.push(this.myPageList.dataProvider[i].entityID);
         }
         this.mPlayerBasicInfoQueryUtil.queryPlayerBasicInfo(playersIdArray);
      }
      
      public function onPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(!info.available)
         {
            return;
         }
         for(var i:uint = 0; i < this.myPageList.dataProvider.length; i++)
         {
            if(this.myPageList.dataProvider[i].entityID == info.entityID)
            {
               this.myPageList.dataProvider[i].level = info.level;
               this.myPageList.dataProvider[i].prestige = info.prestige;
               this.myPageList.dataProvider[i].clanName = info.clanName;
               break;
            }
         }
      }
      
      public function onPlayerBasicInfoComplete() : void
      {
         this.myPageList.refresh();
      }
   }
}

