package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.constants.DataInGameID;
   import codo.constants.QuickMatchType;
   import codo.constants.table.Challenge;
   import codo.event.ParaEvent;
   import codo.objects.AARChallengeObj;
   import codo.objects.CodoPageObj;
   import codo.objects.RecentMatchStatsObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   
   public class MainMenuAARController extends BaseController
   {
      
      public static const MAX_CHALLENGES:int = 3;
      
      public static const MAX_RECENT_MATCHES:int = 15;
      
      private static const CHALLENGE_FIELD_VIS:int = 0;
      
      private static const CHALLENGE_FIELD_KEY:int = 1;
      
      private static const CHALLENGE_FIELD_LEVEL:int = 2;
      
      private static const CHALLENGE_FIELD_START:int = 3;
      
      private static const CHALLENGE_FIELD_GAIN:int = 4;
      
      private static const CHALLENGE_FIELD_TARGET:int = 5;
      
      private static const CHALLENGE_FIELD_START_PCT:int = 6;
      
      private static const CHALLENGE_FIELD_GAIN_PCT:int = 7;
      
      private var challenges:Vector.<AARChallengeObj> = null;
      
      public function MainMenuAARController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         var mapID:String = CFunctionCommonContainer.Dvar_GetString("ui_played_mapname");
         var modeID:String = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
         if(mapID == "" || modeID != QuickMatchType.ID_FUTURE_CYBORGS)
         {
            return;
         }
         this.addDP(DataID.SCALES_LINES_DAT,this.getScalesLinesDat);
         this.addDP(DataID.TOTAL_POINTS_LINE_DAT,this.getTotalPointsLineDat);
         this.addDP(DataInGameID.MATCH_RESULT,this.getMatchResult);
         this.addDP(DataID.AAR_CHALLENGES,this.getChallenges);
         this.addDP(DataInGameID.AAR_RECENT_SCORES,this.getRecentMatchStats);
         this.addDP(DataInGameID.AAR_RECENT_AVG,this.getAverageScore);
         this.addDP(DataInGameID.EARLY_EXIT_DELAY,this.getEarlyExitDelay);
         this.addDP(DataID.PREV_MATCH_DIFFICULITIES,this.getPrevMatchDifficulties);
         this.listen(BCEvent.EVT_STOP_CONTROLLER_RUMBLE,this.onStopControllerRumbleHandle);
         this.listen(BCInGameEvent.BACK_TO_ROOM,this.onCloseAARPopup);
         this.listen(BCEvent.EVT_PAGE_CHANGED,this.onPageChangedHandle);
         this.listen(BCEvent.EVT_PRESS_ESC_CLOSE_WINDOW,this.onESC);
      }
      
      private function onPageChangedHandle(cEvt:ParaEvent) : void
      {
         var currentPageObj:CodoPageObj = cEvt.myPara.pageObj;
         if(currentPageObj == CodoPageViewDB.PAGE_ADV_FSG_MATCH_RESULT)
         {
            this.setBindData(DataCommonID.HUD_SCORE_BOARD,CFunctionContainer.AS_GetScoreBoard_Main());
            this.setBindData(DataCommonID.MATCH_STATUS,CFunctionContainer.AS_GetScoreBoard_MapType_Main());
            this.setBindData(DataID.ZM_MATCH_GPXPGAINED,this.getXPGPGained());
            this.setBindData(DataCommonID.OBJECTIVES,CFunctionContainer.AS_GetObjectives_Main());
         }
      }
      
      private function getXPGPGained() : Object
      {
         var zmGameBonus:Object = new Object();
         zmGameBonus.cpGained = CFunctionCommonContainer.Dvar_GetString("zm_eog_cpgained");
         zmGameBonus.charxpGained = CFunctionCommonContainer.Dvar_GetString("zm_eog_charxp");
         zmGameBonus.careerxpGained = CFunctionCommonContainer.Dvar_GetString("zm_eog_xp");
         return zmGameBonus;
      }
      
      private function onCloseAARPopup(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.setdvar("ui_eog_show","0");
         this.prevPage();
      }
      
      private function onESC(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.setdvar("ui_eog_show","0");
      }
      
      public function getEarlyExitDelay() : int
      {
         return 0;
      }
      
      private function getPrevMatchDifficulties() : int
      {
         return this.getDvarInt("g_difficulty");
      }
      
      private function getMatchResult() : int
      {
         var result:int = this.getDvarInt("ui_eog_victory");
         if(result > 0)
         {
            return DataInGameID.MATCH_RESULT_VICTORY;
         }
         if(result == 0)
         {
            return DataInGameID.MATCH_RESULT_DEFEAT;
         }
         return DataInGameID.MATCH_RESULT_TIE;
      }
      
      private function initChallengeData() : void
      {
         var str:String = null;
         var fields:Array = null;
         var key:String = null;
         var name:String = null;
         var level:String = null;
         var challenge:AARChallengeObj = null;
         var desc:String = null;
         var target:String = null;
         this.challenges = new Vector.<AARChallengeObj>();
         for(var i:int = 0; i < MAX_CHALLENGES; i++)
         {
            str = CFunctionCommonContainer.Dvar_GetString("ui_eog_ch" + String(i));
            CFunctionCommonContainer.setdvar("ui_eog_ch" + String(i),"");
            Logger.print("MainMenuAARController::getChallenges" + str);
            fields = str.split("|");
            if(!(fields[CHALLENGE_FIELD_VIS] == "0" || fields.length <= 0))
            {
               key = fields[CHALLENGE_FIELD_KEY];
               if(!(key == null || key.length <= 0))
               {
                  name = "@" + CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.KEY,key,Challenge.NAME);
                  name = LocalizeUtil.localize(name);
                  level = "@" + CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.KEY,key,Challenge.LEVEL_STR);
                  level += "_" + fields[CHALLENGE_FIELD_LEVEL];
                  level = LocalizeUtil.localize(level);
                  challenge = new AARChallengeObj();
                  challenge.title = name + level;
                  desc = "@" + CFunctionCommonContainer.StringTableLookup(Challenge.PATH,Challenge.KEY,key,Challenge.DESCRIPTION);
                  desc = LocalizeUtil.localize(desc);
                  target = fields[CHALLENGE_FIELD_TARGET];
                  challenge.description = LocalizeUtil.replaceConversionString(desc,[target]);
                  challenge.progressStart = Number(fields[CHALLENGE_FIELD_START_PCT]);
                  challenge.progressGain = Number(fields[CHALLENGE_FIELD_GAIN_PCT]);
                  this.challenges.push(challenge);
               }
            }
         }
      }
      
      private function getChallenges() : Object
      {
         if(this.challenges == null)
         {
            this.initChallengeData();
         }
         return this.challenges;
      }
      
      public function getRecentMatchStats(cGameType:int = 0) : Array
      {
         var currentMatchStats:RecentMatchStatsObj = null;
         var myPosition:Number = NaN;
         var fullRecentMatchStats:Array = CFunctionContainer.AS_GetRecentMatchStats();
         var returnedList:Array = new Array();
         for(var i:uint = fullRecentMatchStats.length - MAX_RECENT_MATCHES; i < fullRecentMatchStats.length; i++)
         {
            currentMatchStats = new RecentMatchStatsObj(fullRecentMatchStats[i]);
            if(currentMatchStats.empty == false)
            {
               if(currentMatchStats.averageScore == 0)
               {
                  returnedList.push(Boolean(currentMatchStats.topScore) ? currentMatchStats.score / currentMatchStats.topScore : 0);
               }
               else
               {
                  myPosition = currentMatchStats.score / currentMatchStats.averageScore;
                  myPosition = myPosition > 2 ? 2 : myPosition;
                  returnedList.push(myPosition / 2);
               }
            }
         }
         return returnedList;
      }
      
      private function getAverageScore() : int
      {
         var currentMatchStats:RecentMatchStatsObj = null;
         var fullRecentMatchStats:Array = CFunctionContainer.AS_GetRecentMatchStats();
         var sum:int = 0;
         var count:int = 0;
         for(var i:uint = fullRecentMatchStats.length - MAX_RECENT_MATCHES; i < fullRecentMatchStats.length; i++)
         {
            currentMatchStats = new RecentMatchStatsObj(fullRecentMatchStats[i]);
            if(currentMatchStats.empty == false)
            {
               sum += currentMatchStats.score;
               count++;
            }
         }
         return count == 0 ? 0 : int(sum / count);
      }
      
      private function onStopControllerRumbleHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.execnow("stopControllerRumble");
      }
      
      private function getScalesLinesDat() : String
      {
         return CFunctionCommonContainer.Dvar_GetString("ui_eog_r8");
      }
      
      private function getTotalPointsLineDat() : String
      {
         return CFunctionCommonContainer.Dvar_GetString("ui_eog_r9");
      }
   }
}

