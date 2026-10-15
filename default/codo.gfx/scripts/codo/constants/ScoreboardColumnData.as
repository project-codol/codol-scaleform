package codo.constants
{
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.localization.DictMatchResults;
   import codo.utils.ClashPvpUtil;
   
   public final class ScoreboardColumnData
   {
      
      private static const COLUMN_IS_DEAD:int = 0;
      
      private static const COLUMN_RANK:int = 1;
      
      private static const COLUMN_PLAYER:int = 2;
      
      private static const COLUMN_CLAN:int = 3;
      
      private static const COLUMN_LEVEL:int = 4;
      
      private static const COLUMN_SCORE:int = 5;
      
      private static const COLUMN_KILLS:int = 6;
      
      private static const COLUMN_DEATHS:int = 7;
      
      private static const COLUMN_ASSISTS:int = 8;
      
      private static const COLUMN_HEADSHOTS:int = 9;
      
      private static const COLUMN_REVIVES:int = 10;
      
      private static const COLUMN_OBJECTIVE1:int = 11;
      
      private static const COLUMN_OBJECTIVE2:int = 12;
      
      private static const COLUMN_BUFFS:int = 13;
      
      private static const COLUMN_PING:int = 14;
      
      private static const COLUMN_XP:int = 15;
      
      private static const COLUMN_GP:int = 16;
      
      private static const COLUMN_EMPTY:int = 17;
      
      private static const COLUMN_WARGOD:int = 18;
      
      public static const KEY_RANK:String = "rank";
      
      public static const KEY_PLAYER:String = "player";
      
      public static const KEY_CLANNAME:String = "clanname";
      
      public static const KEY_SCORE:String = "score";
      
      public static const KEY_KILLS:String = "kills";
      
      public static const KEY_DEATHS:String = "deaths";
      
      public static const KEY_ASSISTS:String = "assists";
      
      public static const KEY_HEADSHOTS:String = "headshots";
      
      public static const KEY_REVIVES:String = "revives";
      
      public static const KEY_OBJECTIVE1:String = "objective1";
      
      public static const KEY_OBJECTIVE2:String = "objective2";
      
      public static const KEY_PING:String = "ping";
      
      public static const KEY_XPGAINED:String = "xpgained";
      
      public static const KEY_GPGAINED:String = "gpgained";
      
      public static const KEY_WARGOD:String = "*wargod";
      
      public static const KEY_IS_DEAD:String = "*isDead";
      
      public static const KEY_LEVEL:String = "*level";
      
      public static const KEY_BUFFS:String = "*buffs";
      
      public static const IN_GAME:String = "inGame";
      
      public static const POST_GAME:String = "postGame";
      
      public static const IN_GAME_WIDTH:uint = 1250;
      
      public static const POST_GAME_WIDTH:uint = 1250;
      
      public static const MAX_COLUMNS:uint = 13;
      
      private static const columnData:Vector.<Object> = new <Object>[{
         "modes":["zm","zarena","zsurv"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_HEADSHOTS,COLUMN_REVIVES,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,26.83,15.78,5.78,6.78,5.78,5.78,5.78,5.78,11,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_HEADSHOTS,COLUMN_REVIVES,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,24.17,15.35,5.35,6.35,5.35,5.35,5.35,5.35,11,6.35,6.35]
      },{
         "modes":["zchamp"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_HEADSHOTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,26.83,15.78,4.78,5.78,5.78,5.78,6.78,6.78,11,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_HEADSHOTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,24.17,15.35,5.35,5.35,5.35,5.35,5.35,6.35,11,6.35,6.35]
      },{
         "modes":["coop"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_REVIVES,COLUMN_OBJECTIVE1,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,26.83,15.78,5.78,6.78,5.78,5.78,5.78,5.78,11,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_REVIVES,COLUMN_OBJECTIVE1,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,24.17,15.35,5.35,6.35,5.35,5.35,5.35,5.35,11,6.35,6.35]
      },{
         "modes":["sd","sdp","sdc","dd","sab","dom","ctf","koth","clash_ctf","hostage","vip"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,5.78,6.78,5.78,5.78,5.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,5.35,6.35,5.35,5.35,5.35,5.35,13.44,6.35,6.35]
      },{
         "modes":["tjugg","sr","conf","tag"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,21.59,15.78,5.02,6.02,6.02,5.02,5.02,7.68,7.68,9.46,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,19.73,15.35,4.65,5.7,5.7,4.7,4.7,7.65,7.65,9.09,5.7,5.7]
      },{
         "modes":["asym"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[4.21,25.36,16.27,6.27,6.27,6.27,6.27,6.27,15.54,7.27],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.93,23.59,15.78,5.78,5.78,5.78,5.78,5.78,14.24,6.78,6.78]
      },{
         "modes":["infect","borg"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,5.78,6.78,5.78,5.78,5.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,5.35,6.35,5.35,5.35,5.35,5.35,13.44,6.35,6.35]
      },{
         "modes":["oic","sas"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_HEADSHOTS,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,3.78,6.78,5.78,7.78,5.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_HEADSHOTS,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,3.35,6.35,5.35,7.35,5.35,5.35,13.44,6.35,6.35]
      },{
         "modes":["gun"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_OBJECTIVE1,COLUMN_HEADSHOTS,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,5.78,6.78,5.78,5.78,5.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_OBJECTIVE1,COLUMN_HEADSHOTS,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,5.35,6.35,5.35,5.35,5.35,5.35,13.44,6.35,6.35]
      },{
         "modes":["nftbl"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_KILLS,COLUMN_SCORE,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,5.78,5.78,6.78,5.78,5.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_ASSISTS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_KILLS,COLUMN_SCORE,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,5.35,5.35,6.35,5.35,5.35,5.35,13.44,6.35,6.35]
      },{
         "modes":["robbery"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_KILLS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_SCORE,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,5.78,6.78,5.78,6.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_KILLS,COLUMN_OBJECTIVE1,COLUMN_OBJECTIVE2,COLUMN_SCORE,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,5.35,6.35,5.35,6.35,5.35,13.44,6.35,6.35]
      },{
         "modes":["DEFAULT"],
         "inGame":[COLUMN_IS_DEAD,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_ASSISTS,COLUMN_HEADSHOTS,COLUMN_BUFFS,COLUMN_PING],
         "inGameWidths":[3.93,23.59,15.78,5.78,6.78,5.78,5.78,5.78,5.78,14.24,6.78],
         "postGame":[COLUMN_RANK,COLUMN_PLAYER,COLUMN_CLAN,COLUMN_WARGOD,COLUMN_SCORE,COLUMN_KILLS,COLUMN_DEATHS,COLUMN_ASSISTS,COLUMN_HEADSHOTS,COLUMN_BUFFS,COLUMN_XP,COLUMN_GP],
         "postGameWidths":[3.68,21.73,15.35,5.35,6.35,5.35,5.35,5.35,5.35,13.44,6.35,6.35]
      }];
      
      public function ScoreboardColumnData()
      {
         super();
      }
      
      public static function getInGameHeaders(mode:String) : Array
      {
         return getHeaders(mode,IN_GAME);
      }
      
      public static function getPostGameHeaders(mode:String) : Array
      {
         return getHeaders(mode,POST_GAME);
      }
      
      public static function getInGameDataKeys(mode:String) : Array
      {
         return getDataKeys(mode,IN_GAME);
      }
      
      public static function getPostGameDataKeys(mode:String) : Array
      {
         return getDataKeys(mode,POST_GAME);
      }
      
      public static function getInGameWidths(mode:String) : Array
      {
         return getWidths(mode,IN_GAME);
      }
      
      public static function getPostGameWidths(mode:String) : Array
      {
         return getWidths(mode,POST_GAME);
      }
      
      private static function getHeaders(mode:String, scoreboardType:String) : Array
      {
         var columnsForMode:Array = getColumns(mode,scoreboardType);
         var column:int = 0;
         var header:String = "";
         var retHeaders:Array = [];
         for(var i:uint = 0; i < columnsForMode.length; i++)
         {
            column = int(columnsForMode[i]);
            header = getHeader(column,mode);
            retHeaders.push(header);
         }
         return retHeaders;
      }
      
      private static function getDataKeys(mode:String, scoreboardType:String) : Array
      {
         var columnsForMode:Array = getColumns(mode,scoreboardType);
         var column:int = 0;
         var key:String = "";
         var retKeys:Array = [];
         for(var i:uint = 0; i < columnsForMode.length; i++)
         {
            column = int(columnsForMode[i]);
            key = getDataKey(column);
            retKeys.push(key);
         }
         return retKeys;
      }
      
      private static function getHeader(column:int, mode:String) : String
      {
         var assistsMap:Object = null;
         var objective1Map:Object = null;
         var objective2Map:Object = null;
         if(mode == ClashPvpUtil.MODE_ID)
         {
            mode = ClashPvpUtil.getClashDetailModeString();
         }
         switch(column)
         {
            case COLUMN_EMPTY:
            case COLUMN_IS_DEAD:
               return "";
            case COLUMN_RANK:
               return DictMatchResults.RANK_COLUMN;
            case COLUMN_PLAYER:
               return DictInGame.ScoreboardName;
            case COLUMN_CLAN:
               return Dict.MATCH_RESULT_CLAN;
            case COLUMN_LEVEL:
               return DictInGame.ScoreboardRank;
            case COLUMN_SCORE:
               return DictInGame.ScoreboardScore;
            case COLUMN_WARGOD:
               return DictInGame.ScoreboardWargod;
            case COLUMN_KILLS:
               return DictInGame.ScoreboardKills;
            case COLUMN_DEATHS:
               return DictInGame.ScoreboardDeaths;
            case COLUMN_ASSISTS:
               assistsMap = {"nftbl":DictInGame.ScoreboardObjectivesKillEnemyBallCarrier};
               if(assistsMap.hasOwnProperty(mode))
               {
                  return assistsMap[mode];
               }
               return DictInGame.ScoreboardAssists;
               break;
            case COLUMN_HEADSHOTS:
               return DictInGame.ScoreboardHeadshots;
            case COLUMN_REVIVES:
               return Dict.CYBORG_STAT_REVIVES;
            case COLUMN_OBJECTIVE1:
               objective1Map = {
                  "sd":DictInGame.ScoreboardObjectivesSD,
                  "sdp":DictInGame.ScoreboardObjectivesSDP,
                  "sdc":DictInGame.ScoreboardObjectivesSDC,
                  "dd":DictInGame.ScoreboardObjectivesDD,
                  "sab":DictInGame.ScoreboardObjectivesSAB,
                  "dom":DictInGame.ScoreboardObjectivesDOM,
                  "ctf":DictInGame.ScoreboardObjectivesCTF,
                  "koth":DictInGame.ScoreboardObjectivesKOTH,
                  "conf":DictInGame.ScoreboardObjectivesCONF,
                  "tag":DictInGame.ScoreboardObjectivesTAG,
                  "tjugg":DictInGame.ScoreboardObjectivesTJUGG,
                  "asym":DictInGame.ScoreboardObjectivesASYM,
                  "sr":DictInGame.ScoreboardObjectivesSR,
                  "infect":DictInGame.ScoreboardObjectivesINFECT,
                  "borg":DictInGame.ScoreboardObjectivesBORG,
                  "oic":DictInGame.ScoreboardObjectivesOIC,
                  "coop":DictInGame.ScoreboardObjectivesSURVIVAL,
                  "zchamp":DictInGame.ScoreboardObjectivesZCHAMP,
                  "sas":DictInGame.ScoreboardObjectivesSAS,
                  "clash_ctf":DictInGame.ScoreboardObjectivesCTF,
                  "hostage":DictInGame.ScoreboardObjectivesHOSTAGE,
                  "gun":DictInGame.ScoreboardObjectivesGUN,
                  "nftbl":DictInGame.ScoreboardObjectivesGoalScore,
                  "vip":DictInGame.ScoreboardObjectivesVIP,
                  "robbery":DictInGame.ScoreboardObjectivesRobbery
               };
               return objective1Map[mode];
            case COLUMN_OBJECTIVE2:
               objective2Map = {
                  "conf":DictInGame.ScoreboardObjectivesCONF2,
                  "tag":DictInGame.ScoreboardObjectivesTAG2,
                  "tjugg":DictInGame.ScoreboardObjectivesTJUGG2,
                  "sr":DictInGame.ScoreboardObjectivesSR2,
                  "infect":DictInGame.ScoreboardObjectivesINFECT2,
                  "borg":DictInGame.ScoreboardObjectivesBORG2,
                  "oic":DictInGame.ScoreboardObjectivesOIC2,
                  "zchamp":DictInGame.ScoreboardObjectivesZCHAMP2,
                  "sas":DictInGame.ScoreboardObjectivesSAS2,
                  "nftbl":DictInGame.ScoreboardObjectivesRebound,
                  "robbery":DictInGame.ScoreboardObjectivesRobbery2
               };
               return objective2Map[mode];
            case COLUMN_BUFFS:
               return Dict.MATCH_RESULT_BUFF;
            case COLUMN_PING:
               return DictInGame.ScoreboardPing;
            case COLUMN_XP:
               return Dict.MATCH_RESULT_XP;
            case COLUMN_GP:
               return Dict.MATCH_RESULT_GP;
            default:
               return null;
         }
      }
      
      private static function getDataKey(column:int) : String
      {
         switch(column)
         {
            case COLUMN_EMPTY:
               return null;
            case COLUMN_IS_DEAD:
               return KEY_IS_DEAD;
            case COLUMN_RANK:
               return KEY_RANK;
            case COLUMN_PLAYER:
               return KEY_PLAYER;
            case COLUMN_CLAN:
               return KEY_CLANNAME;
            case COLUMN_LEVEL:
               return KEY_LEVEL;
            case COLUMN_WARGOD:
               return KEY_WARGOD;
            case COLUMN_SCORE:
               return KEY_SCORE;
            case COLUMN_KILLS:
               return KEY_KILLS;
            case COLUMN_DEATHS:
               return KEY_DEATHS;
            case COLUMN_ASSISTS:
               return KEY_ASSISTS;
            case COLUMN_HEADSHOTS:
               return KEY_HEADSHOTS;
            case COLUMN_REVIVES:
               return KEY_REVIVES;
            case COLUMN_OBJECTIVE1:
               return KEY_OBJECTIVE1;
            case COLUMN_OBJECTIVE2:
               return KEY_OBJECTIVE2;
            case COLUMN_BUFFS:
               return KEY_BUFFS;
            case COLUMN_PING:
               return KEY_PING;
            case COLUMN_XP:
               return KEY_XPGAINED;
            case COLUMN_GP:
               return KEY_GPGAINED;
            default:
               return null;
         }
      }
      
      private static function getColumns(mode:String, scoreboardType:String) : Array
      {
         var j:uint = 0;
         if(scoreboardType != IN_GAME && scoreboardType != POST_GAME)
         {
            return null;
         }
         if(mode == ClashPvpUtil.MODE_ID)
         {
            mode = ClashPvpUtil.getClashDetailModeString();
         }
         loop0:
         for(var i:uint = 0; i < columnData.length - 1; )
         {
            j = 0;
            while(true)
            {
               if(j >= columnData[i].modes.length)
               {
                  i++;
                  continue loop0;
               }
               if(columnData[i].modes[j] == mode)
               {
                  break;
               }
               j++;
            }
            if(scoreboardType == IN_GAME)
            {
               return columnData[i].inGame;
            }
            return columnData[i].postGame;
         }
         if(scoreboardType == IN_GAME)
         {
            return columnData[columnData.length - 1].inGame;
         }
         return columnData[columnData.length - 1].postGame;
      }
      
      private static function getWidths(mode:String, scoreboardType:String) : Array
      {
         var i:uint = 0;
         var j:uint = 0;
         if(scoreboardType != IN_GAME && scoreboardType != POST_GAME)
         {
            return null;
         }
         if(mode == ClashPvpUtil.MODE_ID)
         {
            mode = ClashPvpUtil.getClashDetailModeString();
         }
         var columnWidths:Array = [];
         var matchFound:Boolean = false;
         loop0:
         for(i = 0; i < columnData.length - 1; i++)
         {
            for(j = 0; j < columnData[i].modes.length; j++)
            {
               if(columnData[i].modes[j] == mode)
               {
                  if(scoreboardType == IN_GAME)
                  {
                     columnWidths = columnData[i].inGameWidths;
                  }
                  else
                  {
                     columnWidths = columnData[i].postGameWidths;
                  }
                  matchFound = true;
                  break loop0;
               }
            }
         }
         if(!matchFound)
         {
            if(scoreboardType == IN_GAME)
            {
               columnWidths = columnData[columnData.length - 1].inGameWidths;
            }
            else
            {
               columnWidths = columnData[columnData.length - 1].postGameWidths;
            }
         }
         for(var k:uint = 0; k < columnWidths.length; k++)
         {
            if(scoreboardType == IN_GAME)
            {
               columnWidths[k] *= IN_GAME_WIDTH / 100;
            }
            else
            {
               columnWidths[k] *= POST_GAME_WIDTH / 100;
            }
         }
         return columnWidths;
      }
   }
}

