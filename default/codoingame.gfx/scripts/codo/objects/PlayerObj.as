package codo.objects
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.utils.TableUtil;
   
   public dynamic class PlayerObj extends UserObj
   {
      
      private static var _playerObj:PlayerObj;
      
      public var careerData:CareerObj = new CareerObj();
      
      public function PlayerObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public static function getObj() : PlayerObj
      {
         if(_playerObj == null)
         {
            makePlayerObj();
         }
         _playerObj.careerData.wargodPlayerInfo = CFunctionContainer.AS_GetWarGodPlayerData();
         return _playerObj;
      }
      
      public static function updateCallsignInfo(doBroadcast:Boolean = true) : void
      {
         var playerObj:PlayerObj = getObj();
         var data:Object = CFunctionCommonContainer.GetPlayerCallSignInfo();
         playerObj.callSignObj = new CallSignObj(data);
         if(doBroadcast)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_CALLSIGN_REFRESH,playerObj.callSignObj);
         }
      }
      
      public static function updateBadgeInfo(doBroadcast:Boolean = true) : void
      {
         var playerObj:PlayerObj = getObj();
         var data:Array = CFunctionCommonContainer.GetPlayerBadgeInfo();
         playerObj.badgeObj = new BadgeObj(data[0]);
         if(doBroadcast)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_BADGE_REFRESH,data);
         }
      }
      
      public static function updatePlayerClanInfo(doBroadcast:Boolean = true) : void
      {
         var playerObj:PlayerObj = getObj();
         var clanObj:Object = CFunctionCommonContainer.GetClanInfo();
         if(clanObj != null)
         {
            playerObj.clanID = clanObj.id;
            playerObj.clanName = clanObj.name;
            playerObj.clanTag = clanObj.clantag;
         }
         else
         {
            playerObj.clanID = "";
            playerObj.clanName = "";
            playerObj.clanTag = "";
         }
         if(doBroadcast)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_ON_CAREER_INFO_UPDATED);
         }
      }
      
      private static function makePlayerObj() : void
      {
         _playerObj = new PlayerObj();
         _playerObj.name = DataManager.getInstance().getDP(DataID.PLAYER_USER_NAME);
         _playerObj.id = CFunctionCommonContainer.GetPlayerID();
         var currentLevel:uint = CFunctionCommonContainer.GetPlayerLevel();
         var xpNextLevel:int = CFunctionCommonContainer.GetXpForNextLevel();
         _playerObj.careerData.currentLevel = CFunctionCommonContainer.GetDisplayLevel(currentLevel);
         _playerObj.careerData.prestige = CFunctionCommonContainer.GetPlayerPrestige();
         _playerObj.careerData.timePlayed = CFunctionCommonContainer.GetPlayerDataInt("timePlayedOverAll",true);
         _playerObj.careerData.assists = CFunctionCommonContainer.GetPlayerDataInt("assists",true);
         _playerObj.careerData.totalEarnedXP = CFunctionCommonContainer.GetPlayerXP();
         _playerObj.careerData.xpEarned = _playerObj.careerData.xpEarned;
         _playerObj.careerData.xpRequired = xpNextLevel - _playerObj.careerData.xpEarned;
         _playerObj.careerData.scoreEarned = CFunctionCommonContainer.GetPlayerDataInt("score",true);
         _playerObj.careerData.wins = CFunctionCommonContainer.GetPlayerDataFloat("wins",true);
         _playerObj.careerData.losses = CFunctionCommonContainer.GetPlayerDataInt("losses",true);
         _playerObj.careerData.ties = CFunctionCommonContainer.GetPlayerDataInt("ties",true);
         _playerObj.careerData.escapes = CFunctionCommonContainer.GetPlayerDataInt("escapes",true);
         _playerObj.careerData.winStreak = CFunctionCommonContainer.GetPlayerDataInt("winStreak",true);
         _playerObj.careerData.kills = CFunctionCommonContainer.GetPlayerDataFloat("kills",true);
         _playerObj.careerData.headshots = CFunctionCommonContainer.GetPlayerDataInt("headshots",true);
         _playerObj.careerData.killStreak = CFunctionCommonContainer.GetPlayerDataInt("killStreak",true);
         _playerObj.careerData.deaths = CFunctionCommonContainer.GetPlayerDataInt("deaths",true);
         _playerObj.careerData.winRatio = CFunctionCommonContainer.GetPlayerDataInt("winRatio",true) / 10;
         _playerObj.careerData.kdRatio = _playerObj.careerData.kills / Math.max(_playerObj.careerData.deaths,1);
         _playerObj.careerData.score = CFunctionCommonContainer.GetPlayerDataInt("score",true);
         _playerObj.careerData.accuracy = CFunctionCommonContainer.GetPlayerDataInt("accuracy",true) / 100;
         _playerObj.careerData.currentWinStreak = CFunctionCommonContainer.GetPlayerDataInt("currentWinStreak",true);
         _playerObj.careerData.objectives = CFunctionCommonContainer.GetPlayerDataInt("objectives",true);
         _playerObj.careerData.recentStatistics = CFunctionCommonContainer.GetRecentStatistics();
         _playerObj.careerData.weaponCategoryStatistics = CFunctionCommonContainer.GetWeaponCategoryStatistics();
         updatePlayerClanInfo(false);
         updateCallsignInfo(false);
         updateBadgeInfo(false);
      }
      
      public static function getRankName(rank:uint) : String
      {
         var RANK_TABLE:String = "mp/rankTable.csv";
         var RANK_ID_COL:int = 0;
         var FULL_RANK_NAME_COL:int = 5;
         var rankName:String = TableUtil.lookup(RANK_TABLE,RANK_ID_COL,rank.toString(),FULL_RANK_NAME_COL);
         return "@" + rankName;
      }
   }
}

