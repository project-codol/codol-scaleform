package codo.views.battlecity_parts
{
   import codo.component.LeaderboardToggleButton;
   import codo.component.social.PageList;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictBattleCity;
   import codo.objects.PageListSettings;
   import codo.objects.PlayerBasicInfoObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import flash.text.TextField;
   
   public class BattleCityLeagueLeaderboard extends BattleCityBaseSubPanel
   {
      
      private static const WARGOD_LEADERBOARD_ITEM_LINKAGE:String = "codo.battlecity.battleCityLeaderboardItem";
      
      private static const PAGE_SIZE:int = 10;
      
      private static const LEADERBOARD_TYPE_ALL:int = 0;
      
      private static const LEADERBOARD_TYPE_FRIENDS:int = 1;
      
      public var myHeaderRank:TextField;
      
      public var myHeaderName:TextField;
      
      public var myHeaderLevel:TextField;
      
      public var myHeaderClan:TextField;
      
      public var myHeaderChampionPoints:TextField;
      
      public var myPlayerRank:TextField;
      
      public var myTop100Tab:LeaderboardToggleButton;
      
      public var myFriendsTab:LeaderboardToggleButton;
      
      public var myPageList:PageList;
      
      private var mOpenMode:int;
      
      private var mTabs:Array;
      
      private var mPageListSetting:PageListSettings;
      
      private var mTopLeaderBoardData:Object;
      
      private var mFriendLeaderBoardData:Object;
      
      private var mCurrentData:Object;
      
      private var mPlayerBasicInfoUtil:PlayerBasicInfoQueryUtil;
      
      public function BattleCityLeagueLeaderboard()
      {
         super();
         this.mTabs = [this.myTop100Tab,this.myFriendsTab];
         this.myTop100Tab.text = DictBattleCity.TOP_100;
         this.myTop100Tab.registerClickEvent(this.onTabSelected,0);
         this.myTop100Tab.setActive(true);
         this.myTop100Tab.showTabDivisor(false);
         this.myFriendsTab.text = DictBattleCity.FRIENDS_AND_NEARBY;
         this.myFriendsTab.registerClickEvent(this.onTabSelected,1);
         this.myFriendsTab.setActive(false);
         this.myHeaderRank.text = Dict.LEADERBOARD_INDEX;
         this.myHeaderName.text = Dict.LEADERBOARD_USER_NAME;
         this.myHeaderClan.text = Dict.LABEL_CLAN_NAME;
         this.myHeaderLevel.text = Dict.LEADERBOARD_LEVEL;
         this.myHeaderChampionPoints.text = DictBattleCity.LEADERBOARD_CHAMPION_POINTS;
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = PAGE_SIZE;
         this.mPageListSetting.itemPadding = 10;
         this.mPageListSetting.renderLinkName = WARGOD_LEADERBOARD_ITEM_LINKAGE;
         this.myPageList.settings = this.mPageListSetting;
         this.myPageList.myPageListSelector.y = 446;
         this.myPageList.myPageListSelector.x = 0;
         this.mOpenMode = LEADERBOARD_TYPE_ALL;
         this.myPlayerRank.visible = false;
         this.mPlayerBasicInfoUtil = new PlayerBasicInfoQueryUtil();
         this.mPlayerBasicInfoUtil.registerPlayerBasicInfoHandler(this.onReceivePlayerBasicInfo);
         this.mPlayerBasicInfoUtil.registerCompleteHandler(this.onQueryPlayerBasicInfoComplete);
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_TOP100,this.onBindTop100LeaderBoardData);
         bind(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_FRIEND,this.onBindFriendLeaderBoardData);
         broadcast(BCEvent.EVT_FETCH_BATTLECITY_LEAGUE_LEADERBOARD);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_TOP100,this.onBindTop100LeaderBoardData);
         unbind(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_FRIEND,this.onBindFriendLeaderBoardData);
      }
      
      private function onBindTop100LeaderBoardData(res:Object) : void
      {
         this.mTopLeaderBoardData = res.data;
         this.refreshLeaderboard(LEADERBOARD_TYPE_ALL,this.mTopLeaderBoardData);
         this.requestBasicInfo(this.mTopLeaderBoardData.statsList);
      }
      
      private function onBindFriendLeaderBoardData(res:Object) : void
      {
         this.mFriendLeaderBoardData = res.data;
         this.refreshLeaderboard(LEADERBOARD_TYPE_FRIENDS,this.mFriendLeaderBoardData);
         this.requestBasicInfo(this.mFriendLeaderBoardData.statsList);
      }
      
      private function onReceivePlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(!info.available)
         {
            return;
         }
         this.updatePlayerBasicInfoData(this.mTopLeaderBoardData,info);
         this.updatePlayerBasicInfoData(this.mFriendLeaderBoardData,info);
      }
      
      private function onQueryPlayerBasicInfoComplete() : void
      {
         this.refreshLeaderboard(this.mOpenMode,this.mCurrentData,true);
      }
      
      private function updatePlayerBasicInfoData(data:Object, info:PlayerBasicInfoObj) : void
      {
         var bufferedObj:Object = null;
         if(data == null)
         {
            return;
         }
         var bufferedList:Array = data.statsList;
         for(var i:int = 0; i < bufferedList.length; i++)
         {
            bufferedObj = bufferedList[i];
            if(bufferedObj.entityID == info.entityID)
            {
               bufferedObj.level = {
                  "level":info.level,
                  "prestige":info.prestige
               };
               bufferedObj.clanName = info.clanName;
            }
         }
      }
      
      private function requestBasicInfo(infoList:Array) : void
      {
         var userIdsArray:Array = [];
         for(var i:int = 0; i < infoList.length; i++)
         {
            userIdsArray.push(infoList[i].entityID);
         }
         this.mPlayerBasicInfoUtil.queryPlayerBasicInfo(userIdsArray);
      }
      
      public function refreshLeaderboard(openMode:int, data:Object, forceUpdate:Boolean = false) : void
      {
         if(this.mOpenMode != openMode && !forceUpdate)
         {
            return;
         }
         var statList:Array = [];
         if(Boolean(data))
         {
            statList = data.statsList;
            this.mCurrentData = data;
         }
         this.showPlayerRank();
         this.myPageList.dataProvider = statList;
      }
      
      private function onTabSelected(index:int) : void
      {
         if(this.mOpenMode == index)
         {
            return;
         }
         this.mOpenMode = index;
         for(var i:int = 0; i < this.mTabs.length; i++)
         {
            this.mTabs[i].setActive(false);
         }
         this.mTabs[index].setActive(true);
         if(this.mOpenMode == LEADERBOARD_TYPE_ALL)
         {
            this.refreshLeaderboard(this.mOpenMode,this.mTopLeaderBoardData);
         }
         else
         {
            this.refreshLeaderboard(this.mOpenMode,this.mFriendLeaderBoardData);
         }
      }
      
      private function showPlayerRank() : void
      {
         this.myPlayerRank.visible = true;
         var selfStats:Object = this.mCurrentData.selfStats;
         var playerRank:int = int(selfStats.rank);
         if(playerRank > 0)
         {
            this.myPlayerRank.text = LocalizeUtil.localize(DictBattleCity.BATTLECITY_LEADERBOARD_LABEL) + " " + String(playerRank);
         }
         else
         {
            this.myPlayerRank.text = LocalizeUtil.localize(DictBattleCity.BATTLECITY_LEADERBOARD_LABEL) + " " + LocalizeUtil.localize(DictBattleCity.BATTLECITY_NO_LEADERBOARD_RANK);
         }
      }
   }
}

