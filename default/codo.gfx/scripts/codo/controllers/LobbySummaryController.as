package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.*;
   import codo.constants.table.Challenge;
   import codo.event.ParaEvent;
   import codo.objects.AARProgressLevelObj;
   import codo.objects.AARProgressObj;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.DailyChallengeObj;
   import codo.objects.MatchResultsChallengeObj;
   import codo.objects.UnlockItemObj;
   import codo.objects.WeeklyChallengeObj;
   import codo.services.ChallengeService;
   import codo.utils.*;
   import com.society.comscore.DAXDispatcher;
   
   public class LobbySummaryController extends BaseController
   {
      
      private static const TABLE_ROUND_REWARD:String = "mp/awardTable.csv";
      
      private static const ROUND_REWARD_ID_COLUMN:int = 0;
      
      private static const ROUND_REWARD_ICON_COLUMN:int = 2;
      
      private static const ROUND_REWARD_TITLE_COLUMN:int = 3;
      
      private static const ROUND_REWARD_DESC_COLUMN:int = 4;
      
      private var _primaryWeaponExpArray:Array = [];
      
      private var _secondaryWeaponExpArray:Array = [];
      
      private var _dataShowMatchResult:Boolean = false;
      
      private var _gameNormalComplete:Boolean = false;
      
      private var _xpData:AARProgressObj;
      
      private var mapID:String;
      
      public function LobbySummaryController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         if(ScaleformUtil.isScaleform)
         {
            this.mapID = CFunctionCommonContainer.Dvar_GetString("ui_played_mapname");
            if(this.mapID.length <= 0)
            {
               return;
            }
         }
         this._gameNormalComplete = this.getDvarInt("ui_match_complete") == 1;
         if(this.dataIsEOGScoreEnable())
         {
            this.setBindData(DataCommonID.HUD_SCORE_BOARD,CFunctionContainer.AS_GetScoreBoard_Main());
            this.addDP(DataCommonID.HUD_SCORE_BOARD,CFunctionContainer.AS_GetScoreBoard_Main);
         }
         this.initWeaponExpArray();
         this.setBindData(DataID.LOBBY_SUMMARY_WEAPONBOARD,this.get_weapons());
         this.setBindData(DataID.LOBBY_SUMMARY_ROUNDAWARD,this.get_roundAwards());
         this.addDP(DataID.LOBBY_SUMMARY_CHALLENGEBOARD,this.get_challenges);
         this.addDP(DataID.LOBBY_SUMMARY_EXPBOARD,this.get_EXPInfo);
         this.addDP(DataID.LOBBY_SUMMARY_WEAPONBOARD,this.get_weapons);
         this.addDP(DataID.EOG_SHOW_SCOREMATCH_RESULT,this.dataShowMatchResult);
         this.addDP(DataID.EOG_IS_SCOREBOARD_ENABLE,this.dataIsEOGScoreEnable);
         this.addDP(DataID.EOG_IS_CHALLENGE_ENABLE,this.dataIsEOGChallengeEnable);
         this.addDP(DataID.EOG_IS_SPY_SCOREBOARD_ENABLE,this.dataIsEOGSpyScoreEnable);
         this.listen(BCEvent.EVT_CLEAR_SHOW_MATCH_RESULT_DVAR,this.clearShowMatchResultDvar);
         this.dax_sendMatchResults();
      }
      
      private function dax_sendMatchResults() : void
      {
         var gameMap:String = null;
         var kills:Number = NaN;
         var deaths:Number = NaN;
         var xpEarned:Number = NaN;
         var gpEarned:Number = NaN;
         var maxPrestige:Number = NaN;
         var maxLevel:Number = NaN;
         var matchDuration:int = 0;
         var difficulty:Number = NaN;
         var scoreboardInfo:Object = null;
         var selfPlayer:Object = null;
         var alliePlayer:Object = null;
         var axisPlayer:Object = null;
         var gameDescriptorStrings:Array = null;
         try
         {
            gameMap = CFunctionCommonContainer.Dvar_GetString("ui_played_mapname");
            scoreboardInfo = CFunctionContainer.AS_GetScoreBoard_Main();
            for(alliePlayer in scoreboardInfo.alliesPlayers)
            {
               if(scoreboardInfo.alliesPlayers[alliePlayer].isSelf == true || scoreboardInfo.alliesPlayers[alliePlayer].isSelf == "true")
               {
                  selfPlayer = scoreboardInfo.alliesPlayers[alliePlayer];
               }
            }
            for(axisPlayer in scoreboardInfo.axisPlayers)
            {
               if(scoreboardInfo.axisPlayers[axisPlayer].isSelf == true || scoreboardInfo.axisPlayers[axisPlayer].isSelf == "true")
               {
                  selfPlayer = scoreboardInfo.axisPlayers[axisPlayer];
               }
            }
            kills = Number(selfPlayer.kills);
            deaths = Number(selfPlayer.deaths);
            xpEarned = Number(selfPlayer.xpgained);
            gpEarned = Number(selfPlayer.gpgained);
            maxPrestige = Number(selfPlayer.prestige);
            maxLevel = Number(selfPlayer.level);
            matchDuration = int(scoreboardInfo.clientConnectionTime);
            difficulty = this.getDP(DataID.PREV_MATCH_DIFFICULITIES);
            gameDescriptorStrings = DAXDispatcher.getGameVariantAndMode(scoreboardInfo.gametype);
            DAXDispatcher.queue("kills",String(kills));
            DAXDispatcher.queue("deaths",String(deaths));
            DAXDispatcher.queue("xp_earned",String(xpEarned));
            DAXDispatcher.queue("gp_earned",String(gpEarned));
            DAXDispatcher.queue("max_level",String(maxLevel));
            DAXDispatcher.queue("game_variant",String(gameDescriptorStrings[0]));
            DAXDispatcher.queue("game_mode",String(gameDescriptorStrings[1]));
            DAXDispatcher.queue("max_prestige",String(maxPrestige));
            DAXDispatcher.queue("match_duration",String(matchDuration));
            DAXDispatcher.queue("difficulty_level",String(difficulty));
            DAXDispatcher.queue("game_map",String(gameMap));
            DAXDispatcher.queue("action_type","match_end");
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      private function get_challenges() : Vector.<ChallengeBaseObj>
      {
         var i:int = 0;
         var dailies:Vector.<DailyChallengeObj> = null;
         var weeklies:Vector.<WeeklyChallengeObj> = null;
         var srcObj:Object = null;
         var destObj:MatchResultsChallengeObj = null;
         var id:String = null;
         var chalLevelIdx:int = 0;
         var category:String = null;
         var name:String = null;
         var level:String = null;
         var desc:String = null;
         var target:String = null;
         var iconUrl:String = null;
         var rewardXP:String = null;
         var rewardGP:String = null;
         var data:Vector.<ChallengeBaseObj> = new Vector.<ChallengeBaseObj>();
         if(!ChallengeService.getInstance().showOnboardingChecklist)
         {
            dailies = ChallengeService.getInstance().GetDailyChallenges();
            for(i = 0; i < dailies.length; i++)
            {
               if(dailies[i].gainedValue > 0)
               {
                  data.push(dailies[i]);
               }
            }
            weeklies = ChallengeService.getInstance().GetWeeklyChallenges();
            for(i = 0; i < weeklies.length; i++)
            {
               if(weeklies[i].gainedValue > 0)
               {
                  data.push(weeklies[i]);
               }
            }
         }
         var challenges:Array = CFunctionCommonContainer.FetchLobbySummary();
         for(i = 0; i < challenges.length; i++)
         {
            srcObj = challenges[i];
            destObj = new MatchResultsChallengeObj();
            destObj.id = srcObj.id;
            destObj.profileID = destObj.id;
            id = "" + srcObj.id;
            chalLevelIdx = int(srcObj.chalLevelIdx);
            category = CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.ID,id,Challenge.CATEGORY);
            if(category != "onboarding")
            {
               name = "@" + CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.ID,id,Challenge.NAME);
               name = LocalizeUtil.localize(name);
               level = "@" + CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.ID,id,Challenge.LEVEL_STR);
               level += "_" + (chalLevelIdx + 1);
               level = LocalizeUtil.localize(level);
               destObj.name = name + level;
               desc = "@" + CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.ID,id,Challenge.DESCRIPTION);
               desc = LocalizeUtil.localize(desc);
               target = srcObj.targetValue;
               destObj.description = LocalizeUtil.replaceConversionString(desc,[target]);
               iconUrl = CFunctionCommonContainer.StringTableLookup(Challenge.CATEGORY_TABLE_PATH,Challenge.CATEGORY_NAME,category,Challenge.CATEGORY_ICON);
               destObj.icon = iconUrl;
               destObj.startValue = Number(srcObj.startValue);
               destObj.gainedValue = Number(srcObj.gainValue);
               destObj.progress = destObj.startValue + destObj.gainedValue;
               destObj.target = srcObj.targetValue;
               destObj.currentProgress = Number(srcObj.currentProgress);
               destObj.targetProgress = Number(srcObj.targetProgress);
               rewardXP = CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.ID,id,int(Challenge.XP + 2 * chalLevelIdx));
               if(rewardXP != "" && rewardXP != "0")
               {
                  destObj.rewardXP = uint(rewardXP);
               }
               rewardGP = CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.ID,id,int(Challenge.CP1 + chalLevelIdx));
               if(rewardGP != "" && rewardGP != "0")
               {
                  destObj.rewardGP = uint(rewardGP);
               }
               data.push(destObj);
            }
         }
         return data;
      }
      
      private function get_EXPInfo() : AARProgressObj
      {
         var nExp:Number = NaN;
         var nMinExp:Number = NaN;
         var nMaxExp:Number = NaN;
         var label:String = null;
         var rankDisplayLevel:String = null;
         var remainingXp:Number = NaN;
         var rankLabel:String = null;
         var rankDisplay:String = null;
         if(this._xpData != null)
         {
            return this._xpData;
         }
         var data:AARProgressObj = new AARProgressObj();
         var xpgpGainedInfoObj:Object = CFunctionContainer.AS_GetXPGPInfo();
         if(xpgpGainedInfoObj == null)
         {
            return null;
         }
         data.bonusXP = xpgpGainedInfoObj.scaleActivityXP + xpgpGainedInfoObj.firstWinXP;
         data.bonusGP = xpgpGainedInfoObj.scaleActivityGP + xpgpGainedInfoObj.firstWinGP;
         data.supplyDropsGained = xpgpGainedInfoObj.supplyDropsGained;
         data.supplyDropRewardProgressGained = xpgpGainedInfoObj.supplyDropRewardProgressGained;
         data.supplyDropRewardProgress = CFunctionContainer.AS_GetSupplyDropRewardProgress();
         var expTableLabels:Vector.<AARProgressLevelObj> = new Vector.<AARProgressLevelObj>();
         var RANK_TABLE:String = "mp/rankTable.csv";
         var RANK_EXP_TABLE:String = "mp/rankExpTable.csv";
         var RANK_ID_COL:int = 0;
         var RANK_MIN_EXP_COL:int = 2;
         var RANK_NEXT_EXP_COL:int = 3;
         var RANK_MAX_EXP_COL:int = 7;
         var FULL_RANK_NAME_COL:int = 5;
         var RANK_DISPLAY_COL:int = 14;
         var RANK_EXP_ID_COL:int = 0;
         var RANK_EXP_MIN:int = 1;
         var RANK_EXP_TO_NEXT:int = 2;
         var RANK_EXP_MAX:int = 3;
         var COLUMN_COUNT_PER_PRESTIGE:int = 3;
         var prePrestige:Number = xpgpGainedInfoObj.prestige - 1;
         if(prePrestige < 0)
         {
            prePrestige = 0;
         }
         var prePrestigeMaxXpColumn:int = prePrestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_MAX;
         var rank_table_maxrow:int = CFunctionCommonContainer.GetPlayerMaxLevel() - 1;
         var prePrestigeMaxLevelXpTotal:Number = 0;
         if(xpgpGainedInfoObj.totalExp < xpgpGainedInfoObj.xpGained)
         {
            prePrestigeMaxLevelXpTotal = Number(CFunctionCommonContainer.StringTableLookup(RANK_EXP_TABLE,RANK_EXP_ID_COL,rank_table_maxrow.toString(),prePrestigeMaxXpColumn));
         }
         var startXp:Number = xpgpGainedInfoObj.totalExp - xpgpGainedInfoObj.xpGained + prePrestigeMaxLevelXpTotal;
         trace("\n\n************************** `ForMatchResults");
         trace("xpgpGainedInfoObj.totalExp = " + xpgpGainedInfoObj.totalExp);
         trace("xpgpGainedInfoObj.xpGained = " + xpgpGainedInfoObj.xpGained);
         trace("prePrestigeMaxLevelXpTotal = " + prePrestigeMaxLevelXpTotal);
         var startRank:Number = Number(xpgpGainedInfoObj.currentRank);
         var prestigedIndex:Number = -1;
         var bonusXp:Number = data.bonusXP;
         var bonusMovement:Number = 0;
         var normalMovement:Number = 0;
         var totalXp:Number = Number(xpgpGainedInfoObj.totalExp);
         var minXpColumn:int = xpgpGainedInfoObj.prestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_MIN;
         var nextXpColumn:int = xpgpGainedInfoObj.prestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_TO_NEXT;
         var maxXpColumn:int = xpgpGainedInfoObj.prestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_MAX;
         while(true)
         {
            nExp = parseInt(CFunctionCommonContainer.StringTableLookup(RANK_EXP_TABLE,RANK_ID_COL,startRank.toString(),maxXpColumn));
            nMinExp = parseInt(CFunctionCommonContainer.StringTableLookup(RANK_EXP_TABLE,RANK_ID_COL,startRank.toString(),minXpColumn));
            nMaxExp = parseInt(CFunctionCommonContainer.StringTableLookup(RANK_EXP_TABLE,RANK_ID_COL,startRank.toString(),nextXpColumn));
            trace("startXp = " + startXp);
            trace("prePrestigeMaxLevelXpTotal = " + prePrestigeMaxLevelXpTotal);
            trace("nExp = " + nExp);
            if(startXp - prePrestigeMaxLevelXpTotal >= nExp)
            {
               break;
            }
            label = CFunctionCommonContainer.StringTableLookup(RANK_TABLE,RANK_ID_COL,startRank.toString(),FULL_RANK_NAME_COL);
            rankDisplayLevel = CFunctionCommonContainer.StringTableLookup(RANK_TABLE,RANK_ID_COL,startRank.toString(),RANK_DISPLAY_COL);
            expTableLabels.unshift(new AARProgressLevelObj("@" + label,rankDisplayLevel,startRank));
            remainingXp = totalXp - nMinExp;
            totalXp -= remainingXp;
            trace("bonusXp = " + bonusXp);
            if(bonusXp > 0)
            {
               trace(bonusMovement + " += " + remainingXp + " / " + nMaxExp);
               bonusMovement += remainingXp / nMaxExp;
               if(remainingXp < bonusXp)
               {
                  bonusXp -= remainingXp;
                  remainingXp = 0;
               }
               else
               {
                  remainingXp -= bonusXp;
                  bonusXp = 0;
               }
            }
            if(remainingXp > 0)
            {
               normalMovement += remainingXp / nMaxExp;
            }
            data.startPercent = (startXp - nMinExp) / nMaxExp;
            if(startXp - prePrestigeMaxLevelXpTotal >= nMinExp)
            {
               break;
            }
            startRank -= 1;
            if(startRank < 0)
            {
               totalXp = prePrestigeMaxLevelXpTotal;
               prePrestigeMaxLevelXpTotal = 0;
               prestigedIndex = expTableLabels.length;
               startRank = rank_table_maxrow;
               minXpColumn = prePrestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_MIN;
               nextXpColumn = prePrestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_TO_NEXT;
               maxXpColumn = prePrestige * COLUMN_COUNT_PER_PRESTIGE + RANK_EXP_MAX;
            }
         }
         trace("last bonusMovement = " + bonusMovement);
         data.bonusEndPercent = bonusMovement;
         data.normalEndPercent = normalMovement;
         if(prestigedIndex != -1)
         {
            prestigedIndex = expTableLabels.length - prestigedIndex;
         }
         data.prestigedIndex = prestigedIndex;
         var isPlayerLevelMax:Boolean = false;
         startRank = xpgpGainedInfoObj.currentRank + 1;
         if(startRank > rank_table_maxrow)
         {
            startRank = 0;
            if(xpgpGainedInfoObj.prestige >= CFunctionCommonContainer.GetPlayerMaxPrestige())
            {
               isPlayerLevelMax = true;
            }
         }
         if(isPlayerLevelMax)
         {
            expTableLabels.push(new AARProgressLevelObj(" ","--",rank_table_maxrow,true));
         }
         else
         {
            rankLabel = CFunctionCommonContainer.StringTableLookup(RANK_TABLE,RANK_ID_COL,startRank.toString(),FULL_RANK_NAME_COL);
            rankDisplay = CFunctionCommonContainer.StringTableLookup(RANK_TABLE,RANK_ID_COL,startRank.toString(),RANK_DISPLAY_COL);
            expTableLabels.push(new AARProgressLevelObj("@" + rankLabel,rankDisplay,startRank));
         }
         data.expLabels = expTableLabels;
         data.gainedExpValue = xpgpGainedInfoObj.xpGained;
         data.prestige = xpgpGainedInfoObj.prestige;
         data.gainedGpValue = xpgpGainedInfoObj.gpGained;
         this._xpData = data;
         return data;
      }
      
      private function initWeaponExpArray() : void
      {
         var xpTable:String = "mp/coWeaponPrimaryRankTable.csv";
         var xpTableRowCount:int = CFunctionCommonContainer.StringTableRowCount(xpTable);
         for(var i:int = 0; i < xpTableRowCount; i++)
         {
            this._primaryWeaponExpArray.push(CFunctionCommonContainer.StringTableLookupByRow(xpTable,i,1));
         }
         xpTable = "mp/coWeaponSecondaryRankTable.csv";
         xpTableRowCount = CFunctionCommonContainer.StringTableRowCount(xpTable);
         for(i = 0; i < xpTableRowCount; i++)
         {
            this._secondaryWeaponExpArray.push(CFunctionCommonContainer.StringTableLookupByRow(xpTable,i,1));
         }
      }
      
      private function get_weapons() : Object
      {
         var i:uint = 0;
         var maxLevel:int = 0;
         var maxExp:int = 0;
         var data:Object = new Array();
         if(!ScaleformUtil.isScaleform)
         {
            data[0] = {
               "name":"AK-47",
               "imageURL":"url",
               "progressInfo":{
                  "levelValue":[0,100,200,300,400,500,600],
                  "currentLevel":7,
                  "targetLevel":7,
                  "srcExpValue":600,
                  "desExpValue":600
               },
               "unlockAttachment":[{
                  "name":"Att0",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att1",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att2",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att3",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att4",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att5",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att6",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att7",
                  "imageURL":"bar_SNIbasic_item_icon"
               },{
                  "name":"Att8",
                  "imageURL":"bar_SNIbasic_item_icon"
               }]
            };
            data[1] = {
               "name":"M16",
               "imageURL":"url",
               "progressInfo":{
                  "levelValue":[0,100,200,300,400,500,600],
                  "currentLevel":1,
                  "targetLevel":2,
                  "srcExpValue":0,
                  "desExpValue":100
               },
               "unlockAttachment":[]
            };
            data[2] = {
               "name":"M4A1",
               "imageURL":"url",
               "progressInfo":{
                  "levelValue":[0,100,200,300,400,500,600],
                  "currentLevel":1,
                  "targetLevel":6,
                  "srcExpValue":0,
                  "desExpValue":570
               },
               "unlockAttachment":[{
                  "name":"Att0",
                  "imageURL":"url"
               },{
                  "name":"Att1",
                  "imageURL":"url"
               }]
            };
         }
         else
         {
            if(Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
            {
               data = CFunctionContainer.AS_GetWeaponLevelup();
            }
            else
            {
               data = null;
            }
            if(data != null)
            {
               for(i = 0; i < data.length; i++)
               {
                  data[i].progressInfo.levelValue = Boolean(data[i].isPrimary) ? this._primaryWeaponExpArray : this._secondaryWeaponExpArray;
                  maxLevel = int(data[i].progressInfo.levelValue.length);
                  if(data[i].progressInfo.currentLevel > maxLevel)
                  {
                     data[i].progressInfo.currentLevel = maxLevel;
                  }
                  if(data[i].progressInfo.targetLevel > maxLevel)
                  {
                     data[i].progressInfo.targetLevel = maxLevel;
                  }
                  maxExp = int(data[i].progressInfo.levelValue[maxLevel - 1]);
                  if(data[i].progressInfo.srcExpValue > maxExp)
                  {
                     data[i].progressInfo.srcExpValue = maxExp;
                  }
                  if(data[i].progressInfo.desExpValue > maxExp)
                  {
                     data[i].progressInfo.desExpValue = maxExp;
                  }
               }
            }
         }
         return data;
      }
      
      private function get_roundAwards() : Vector.<UnlockItemObj>
      {
         var roundAwardStr:String = null;
         var obj:UnlockItemObj = null;
         var data:Vector.<UnlockItemObj> = new Vector.<UnlockItemObj>(0);
         var roundAwards:Array = CFunctionContainer.AS_GetRoundAward();
         for(var indexMedals:int = 0; indexMedals < roundAwards.length; indexMedals++)
         {
            roundAwardStr = roundAwards[indexMedals].toString();
            obj = new UnlockItemObj();
            obj.name = "@" + CFunctionCommonContainer.StringTableLookup(TABLE_ROUND_REWARD,ROUND_REWARD_ID_COLUMN,roundAwardStr,ROUND_REWARD_TITLE_COLUMN);
            obj.imageURL = CFunctionCommonContainer.StringTableLookup(TABLE_ROUND_REWARD,ROUND_REWARD_ID_COLUMN,roundAwardStr,ROUND_REWARD_ICON_COLUMN);
            obj.description = "@" + CFunctionCommonContainer.StringTableLookup(TABLE_ROUND_REWARD,ROUND_REWARD_ID_COLUMN,roundAwardStr,ROUND_REWARD_DESC_COLUMN);
            data.push(obj);
         }
         return data;
      }
      
      private function dataIsEOGScoreEnable() : Boolean
      {
         var gameType:String = null;
         var matchType:QuickMatchType = null;
         if(ScaleformUtil.isScaleform)
         {
            gameType = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
            matchType = getDP(DataID.CURRENT_MATCH_TYPE);
            return this._gameNormalComplete && !matchType.isHeroOps() && gameType != "spy" && gameType != "dmz" && gameType != "tdmz";
         }
         return true;
      }
      
      private function dataIsEOGChallengeEnable() : Boolean
      {
         var gameType:String = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
         return gameType != "dmz" && gameType != "tdmz";
      }
      
      private function dataIsEOGSpyScoreEnable() : Boolean
      {
         var gameType:String = null;
         if(ScaleformUtil.isScaleform)
         {
            gameType = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
            return gameType == "spy";
         }
         return true;
      }
      
      private function dataShowMatchResult() : Boolean
      {
         this._dataShowMatchResult = false;
         if(this.mapID != "")
         {
            if(getDvarInt("ui_eog_show") == 1)
            {
               this._dataShowMatchResult = true;
            }
            if(WarGodUtility.needWarGodResult())
            {
               this._dataShowMatchResult = true;
            }
         }
         return this._dataShowMatchResult;
      }
      
      private function clearShowMatchResultDvar(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.setdvar("ui_eog_show","0");
      }
   }
}

