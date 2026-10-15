package components.ingameaar_part
{
   import codo.common.CFunctionContainerCommon;
   import codo.event.ParaEvent;
   import codo.localization.DictInGame;
   import codo.objects.AARXPDetailsObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import components.BaseButton;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class AARPanelXP extends AARPanelBase
   {
      
      public static var SHOW_DETAILS:String = "show_details";
      
      private static const COLOR_KILLS_ASSISTS:uint = 6608869;
      
      private static const COLOR_OBJECTIVES:uint = 13621071;
      
      private static const COLOR_CHALLENGES:uint = 14386516;
      
      private static const COLOR_MEDALS:uint = 12124159;
      
      private static const COLOR_KILLSTREAKS:uint = 16765440;
      
      private static const COLOR_BONUS:uint = 5276549;
      
      private static const COLOR_SCALE:uint = 7651444;
      
      private static const STAT_KILLS_AND_ASSISTS:int = 0;
      
      private static const STAT_OBJECTIVES:int = 1;
      
      private static const STAT_MEDALS:int = 2;
      
      private static const STAT_KILLSTREAKS:int = 3;
      
      private static const STAT_CHALLENGES:int = 4;
      
      private static const STAT_BONUS:int = 5;
      
      public var myProgressBar:AARProgressBar;
      
      public var myPieChart:AARXPPiechart;
      
      public var myNextLevelValueTF:TextField;
      
      public var myCurrentLevelValueTF:TextField;
      
      public var myNextLevelTitleTF:TextField;
      
      public var myCurrentLevelTitleTF:TextField;
      
      public var myPiechartLabelTF:TextField;
      
      public var myPiechartValueTF:TextField;
      
      public var myXPModBtn:AARXPModBtn;
      
      public var myKillsTF:TextField;
      
      public var myObjectivesTF:TextField;
      
      public var myChallengesTF:TextField;
      
      public var myMedalsTF:TextField;
      
      public var myKillstreaksTF:TextField;
      
      public var myBonusTF:TextField;
      
      public var myKillsValueTF:TextField;
      
      public var myObjectivesValueTF:TextField;
      
      public var myChallengesValueTF:TextField;
      
      public var myMedalsValueTF:TextField;
      
      public var myKillstreaksValueTF:TextField;
      
      public var myBonusValueTF:TextField;
      
      private var mStats:Dictionary;
      
      private var mTotalXpEarned:int;
      
      private var mXpScale:Number;
      
      private var _xpDetails:AARXPDetailsObj;
      
      public function AARPanelXP()
      {
         super();
         SetHeader(DictInGame.XP);
         this.myPiechartLabelTF.text = DictInGame.AAR_EXP_EARNED;
         this.myKillsTF.text = LocalizeUtil.localize(DictInGame.ScoreboardKills).concat("/ ",LocalizeUtil.localize(DictInGame.ScoreboardAssists));
         this.myObjectivesTF.text = DictInGame.AAR_XP_OBJECTIVES;
         this.myChallengesTF.text = DictInGame.AAR_CHALLENGES;
         this.myMedalsTF.text = DictInGame.AAR_XP_MEDALS;
         this.myKillstreaksTF.text = DictInGame.AAR_XP_KILLSTREAKS;
         this.myBonusTF.text = DictInGame.AAR_XP_BONUS;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myXPModBtn.addEventListener(BaseButton.EVT_CLICK,this.OnXPModClick);
      }
      
      private function OnXPModClick(event:ParaEvent) : void
      {
         this.dispatchEvent(new ParaEvent(SHOW_DETAILS,this._xpDetails));
      }
      
      public function SetXPData() : void
      {
         var statDvar:String = null;
         var statLine:String = null;
         var statTokens:Array = null;
         var playerRankTokens:Array = null;
         var rank:int = 0;
         var start:int = 0;
         var tgt:int = 0;
         var startFrac:Number = NaN;
         var gainedFrac:Number = NaN;
         var gain:int = 0;
         this.mStats = new Dictionary();
         var NUM_STATS:uint = 9;
         for(var statIndex:uint = 0; statIndex < NUM_STATS; statIndex++)
         {
            statDvar = "ui_eog_r" + (statIndex + 1);
            statLine = CFunctionContainerCommon.Dvar_GetString(statDvar);
            if(statLine != null && statLine.length > 0)
            {
               statTokens = statLine.split("|");
               this.generateStats(statIndex,statTokens);
            }
         }
         if(this.mStats != null && ScaleformUtil.isScaleform == true)
         {
            this.myKillsValueTF.text = this.mStats[STAT_KILLS_AND_ASSISTS];
            this.myObjectivesValueTF.text = this.mStats[STAT_OBJECTIVES];
            this.myChallengesValueTF.text = this.mStats[STAT_CHALLENGES];
            this.myMedalsValueTF.text = this.mStats[STAT_MEDALS];
            this.myKillstreaksValueTF.text = this.mStats[STAT_KILLSTREAKS];
            this.myBonusValueTF.text = this.mStats[STAT_BONUS];
         }
         this.myPiechartValueTF.text = this.mTotalXpEarned.toString();
         this._xpDetails = new AARXPDetailsObj();
         this._xpDetails.aasScale = parseFloat(CFunctionContainerCommon.Dvar_GetString("ui_eog_scale_AAS"));
         this._xpDetails.leagueScale = parseFloat(CFunctionContainerCommon.Dvar_GetString("ui_eog_scale_League"));
         this.myXPModBtn.visible = false;
         var pieChartPercents:Vector.<Number> = new <Number>[this.mStats[STAT_KILLS_AND_ASSISTS] / this.mTotalXpEarned,this.mStats[STAT_OBJECTIVES] / this.mTotalXpEarned,this.mStats[STAT_CHALLENGES] / this.mTotalXpEarned,this.mStats[STAT_MEDALS] / this.mTotalXpEarned,this.mStats[STAT_KILLSTREAKS] / this.mTotalXpEarned,this.mStats[STAT_BONUS] / this.mTotalXpEarned];
         var pieChartColors:Vector.<uint> = new <uint>[COLOR_KILLS_ASSISTS,COLOR_OBJECTIVES,COLOR_CHALLENGES,COLOR_MEDALS,COLOR_KILLSTREAKS,COLOR_BONUS];
         this.myPieChart.SetPieData(pieChartPercents,pieChartColors);
         var playerRankLine:String = CFunctionContainerCommon.Dvar_GetString("ui_eog_xp");
         Logger.print("exp:string: " + playerRankLine);
         if(playerRankLine != null && playerRankLine.length > 0)
         {
            playerRankTokens = playerRankLine.split("|");
            rank = this.validateNum(playerRankTokens[0],0);
            start = this.validateNum(playerRankTokens[1],0);
            tgt = this.validateNum(playerRankTokens[2],0);
            startFrac = this.validateNum(parseFloat(playerRankTokens[3]),0);
            gainedFrac = this.validateNum(parseFloat(playerRankTokens[4]),0);
            Logger.print("exp: start frac:" + startFrac + "\ngainedFrac:" + gainedFrac);
            gain = this.validateNum(playerRankTokens[5],0);
            this.updateRankText(rank,start,gain,tgt);
            this.updateRankBar(startFrac,gainedFrac);
         }
      }
      
      private function updateRankText(rank:int, start:int, gain:int, tgt:int) : void
      {
         this.myCurrentLevelValueTF.text = (rank + 1).toString();
         this.myNextLevelValueTF.text = (rank + 2).toString();
         var RANK_TABLE:String = "mp/rankTable.csv";
         var RANK_ID_COL:int = 0;
         var FULL_RANK_NAME_COL:int = 5;
         var currRank:String = CFunctionContainerCommon.StringTableLookup(RANK_TABLE,RANK_ID_COL,rank.toString(),FULL_RANK_NAME_COL);
         var nextRank:String = CFunctionContainerCommon.StringTableLookup(RANK_TABLE,RANK_ID_COL,(rank + 1).toString(),FULL_RANK_NAME_COL);
         if(nextRank == null || nextRank.length == 0)
         {
            nextRank = currRank;
         }
         this.myCurrentLevelTitleTF.text = "@" + currRank;
         this.myNextLevelTitleTF.text = "@" + nextRank;
      }
      
      private function updateRankBar(startFrac:Number, gainedFrac:Number) : void
      {
         this.myProgressBar.SetBarData(startFrac,gainedFrac);
      }
      
      private function validateNum(currValue:*, defaultValue:*) : *
      {
         if(isNaN(currValue))
         {
            return defaultValue;
         }
         return currValue;
      }
      
      private function generateStats(statIndex:uint, statTokens:Array) : void
      {
         var statXp:int = isNaN(parseInt(statTokens[2])) ? 0 : int(statTokens[2]);
         switch(statIndex)
         {
            case 0:
               this.setStat(STAT_OBJECTIVES,statXp);
               break;
            case 1:
            case 2:
               this.setStat(STAT_KILLS_AND_ASSISTS,statXp);
               break;
            case 3:
               this.setStat(STAT_MEDALS,statXp);
               break;
            case 4:
               this.setStat(STAT_KILLSTREAKS,statXp);
               break;
            case 5:
               this.setStat(STAT_CHALLENGES,statXp);
               break;
            case 6:
               this.setStat(STAT_BONUS,statXp);
               break;
            case 7:
               this.mXpScale = parseFloat(statTokens[2]);
               if(isNaN(this.mXpScale))
               {
                  this.mXpScale = 1;
               }
               break;
            case 8:
               this.mTotalXpEarned = statXp;
         }
      }
      
      private function setStat(statID:int, xp:int) : void
      {
         if(this.mStats != null)
         {
            if(this.mStats[statID] != undefined && this.mStats[statID] != null)
            {
               this.mStats[statID] += xp;
            }
            else
            {
               this.mStats[statID] = xp;
            }
         }
      }
   }
}

