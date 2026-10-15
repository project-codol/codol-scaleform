package codo.views.wargod_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodMatchObj;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MatchLogMetro extends MovieClip
   {
      
      private static const BG_LOSE_FRAME:int = 1;
      
      private static const BG_LEAVE_FRAME:int = 2;
      
      private static const BG_WIN_FRAME:int = 3;
      
      private static const BG_DRAW_FRAME:int = 4;
      
      private static const BG_EMPTY_FRAME:int = 5;
      
      public var myIndex:TextField;
      
      public var myDuration:TextField;
      
      public var myGameType:TextField;
      
      public var myMap:TextField;
      
      public var myScoreLabel:TextField;
      
      public var myScore:TextField;
      
      public var myKDRLabel:TextField;
      
      public var myKDR:TextField;
      
      public var myPlaceLabel:TextField;
      
      public var myPlace:TextField;
      
      public var myStar:MovieClip;
      
      public var myStarChange:TextField;
      
      public var myHVLabel:TextField;
      
      public var myHV:TextField;
      
      public var myPSLabel:TextField;
      
      public var myPS:TextField;
      
      public var myPhase:TextField;
      
      public var myPunishment:TextField;
      
      public var myFrame:MovieClip;
      
      public var myBG:MovieClip;
      
      public var myDuoIcon:MovieClip;
      
      private var mIndex:int;
      
      public function MatchLogMetro()
      {
         super();
         this.mIndex = 0;
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myScoreLabel.text = DictWarGod.WARGOD_MATCH_SCORE;
         this.myKDRLabel.text = DictWarGod.WARGOD_MATCH_KD;
         this.myPlaceLabel.text = DictWarGod.WARGOD_MATCH_PLACE;
         this.myHVLabel.text = DictWarGod.WARGOD_MATCH_HEROIC_VALUE;
         this.myDuoIcon.myText.text = DictWarGod.WARGOD_MATCH_LOG_IS_PARTY;
         this.myPunishment.text = DictWarGod.CONTAIN_PUNISHMENT;
         this.showDataControls(false);
      }
      
      private function showDataControls(bShow:Boolean) : void
      {
         for(var i:int = 0; i < numChildren; i++)
         {
            getChildAt(i).visible = bShow;
         }
         this.myBG.visible = true;
         this.myBG.gotoAndStop(BG_EMPTY_FRAME);
         this.myFrame.visible = true;
         this.myFrame.gotoAndStop(BG_EMPTY_FRAME);
      }
      
      public function setData(data:WarGodMatchObj) : void
      {
         if(data == null || data.map == 0)
         {
            this.showDataControls(false);
            return;
         }
         this.showDataControls(true);
         this.myDuration.text = WarGodUtility.getFormattedDuration(data.timeStamp);
         this.myGameType.text = "@" + data.modeName;
         this.myMap.text = "@" + data.mapName;
         var kills:int = data.kills;
         var deaths:int = data.deaths;
         this.myKDR.text = WarGodUtility.getMatchKDByFactors(kills,deaths);
         this.myScore.text = data.score.toString();
         var oldScore:int = data.ladderScoreBeforeMatch;
         var newScore:int = data.ladderScoreAfterMatch;
         var isJuniorWG:Boolean = data.ladderScoreBeforeMatch < PlayerWarGodRank.MINIMUM_BRONZE_SCORE;
         var isPlacement:Boolean = data.isPlacement == 1;
         var isPromotion:Boolean = data.isPromotion == 1;
         var version:int = data.version;
         if(Boolean(data.isWinner))
         {
            this.myFrame.gotoAndStop(BG_WIN_FRAME);
            this.myBG.gotoAndStop(BG_WIN_FRAME);
            this.myDuoIcon.gotoAndStop(BG_WIN_FRAME);
         }
         else if(Boolean(data.isDisconnected))
         {
            this.myFrame.gotoAndStop(BG_LEAVE_FRAME);
            this.myBG.gotoAndStop(BG_LEAVE_FRAME);
            this.myDuoIcon.gotoAndStop(BG_LEAVE_FRAME);
         }
         else if(Boolean(data.isDraw))
         {
            this.myFrame.gotoAndStop(BG_DRAW_FRAME);
            this.myBG.gotoAndStop(BG_DRAW_FRAME);
            this.myDuoIcon.gotoAndStop(BG_DRAW_FRAME);
         }
         else
         {
            this.myFrame.gotoAndStop(BG_LOSE_FRAME);
            this.myBG.gotoAndStop(BG_LOSE_FRAME);
            this.myDuoIcon.gotoAndStop(BG_LOSE_FRAME);
         }
         if(isPlacement || isPromotion)
         {
            this.myStar.visible = false;
            this.myStarChange.visible = false;
            this.myHVLabel.visible = false;
            this.myHV.visible = false;
            this.myPSLabel.visible = false;
            this.myPS.visible = false;
            this.myPhase.visible = true;
            this.myPunishment.x = 71;
            if(isPlacement)
            {
               this.myPhase.text = DictWarGod.WARGOD_PLACEMENT_MATCH;
            }
            else if(isPromotion)
            {
               this.myPhase.text = DictWarGod.WARGOD_PROMOTION_MATCH;
            }
         }
         else if(isJuniorWG)
         {
            this.myPhase.visible = false;
            this.myStar.visible = false;
            this.myStarChange.visible = false;
            this.myHVLabel.visible = false;
            this.myHV.visible = false;
            this.myPSLabel.visible = true;
            this.myPS.visible = true;
            this.myPunishment.x = 31;
         }
         else if(version == 0)
         {
            this.myPhase.visible = false;
            this.myPSLabel.visible = false;
            this.myPS.visible = false;
            this.myStar.visible = true;
            this.myStarChange.visible = true;
            this.myHVLabel.visible = true;
            this.myHV.visible = true;
            this.myHVLabel.text = DictWarGod.WARGOD_MATCH_HEROIC_VALUE;
            this.myPunishment.x = 1;
         }
         else
         {
            this.myPhase.visible = false;
            this.myStar.visible = false;
            this.myStarChange.visible = false;
            this.myHVLabel.visible = false;
            this.myHV.visible = false;
            this.myPSLabel.visible = true;
            this.myPS.visible = true;
            this.myPunishment.x = 31;
         }
         var starChange:int = WarGodUtility.calculateStarOffset(oldScore,newScore);
         this.myStarChange.text = (starChange < 0 ? "" : "+") + starChange.toString();
         this.myHV.text = String(data.heroicValueGain);
         this.myPS.text = String(data.heroicValueGain);
         this.myPlace.text = String(data.place);
         this.myDuoIcon.visible = !data.isSolo;
         this.myPunishment.visible = Boolean(data.isPunishment);
      }
      
      public function set index(index:int) : void
      {
         this.mIndex = index;
         this.myIndex.text = String(this.mIndex + 1);
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
   }
}

