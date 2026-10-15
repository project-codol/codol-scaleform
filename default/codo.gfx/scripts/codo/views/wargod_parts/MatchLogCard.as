package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.objects.WarGodMatchObj;
   import codo.style.WarGodGuide;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class MatchLogCard extends MovieClip
   {
      
      private static const WON_COLOR:int = 3789724;
      
      private static const LOSE_COLOR:int = 13518159;
      
      private static const DRAW_COLOR:int = 297672;
      
      public static const BG_NO_MATCH_FRAME:int = 1;
      
      public static const BG_MATCH_FRAME:int = 2;
      
      public var myMatchIndex:TextField;
      
      public var myMatchType:TextField;
      
      public var myMatchTime:TextField;
      
      public var myMatchScore:TextField;
      
      public var myMatchResult:TextField;
      
      public var myBg:MovieClip;
      
      public var myFrame:MovieClip;
      
      public function MatchLogCard()
      {
         super();
         this.myMatchIndex.textStyle = WarGodGuide.styleMatchIndex;
         this.myMatchIndex.width = 28;
         this.myMatchIndex.height = 32;
         this.myMatchIndex.x = 7;
         this.myMatchIndex.y = 1;
         this.myMatchType.textStyle = WarGodGuide.styleMatchCardType;
         this.myMatchType.width = 176;
         this.myMatchType.height = 25;
         this.myMatchType.x = 1;
         this.myMatchType.y = 15;
         this.myMatchTime.textStyle = WarGodGuide.styleMatchTime;
         this.myMatchTime.width = 176;
         this.myMatchTime.height = 20;
         this.myMatchTime.x = 1;
         this.myMatchTime.y = 38;
         this.myMatchScore.textStyle = WarGodGuide.styleMatchScore;
         this.myMatchScore.width = 176;
         this.myMatchScore.height = 58;
         this.myMatchScore.x = 1;
         this.myMatchScore.y = 59;
         this.myMatchResult.textStyle = WarGodGuide.styleMatchResult;
         this.myMatchResult.width = 176;
         this.myMatchResult.height = 25;
         this.myMatchResult.x = 1;
         this.myMatchResult.y = 112;
      }
      
      public function setMatch(match:WarGodMatchObj) : Boolean
      {
         var matchValid:Boolean = false;
         var matchResult:int = 0;
         var colorFrame:int = 0;
         matchValid = Boolean(match) && WarGodUtility.isMatchValid(match.map);
         this.myBg.gotoAndStop(matchValid ? BG_MATCH_FRAME : BG_NO_MATCH_FRAME);
         this.myMatchType.visible = matchValid;
         this.myMatchTime.visible = matchValid;
         this.myMatchScore.visible = matchValid;
         this.myMatchResult.visible = matchValid;
         this.myFrame.visible = matchValid;
         if(matchValid)
         {
            if(match.timeStamp > 3600)
            {
               this.myMatchTime.text = WarGodUtility.getFormattedTime(match.timeStamp);
            }
            else
            {
               this.myMatchTime.text = WarGodUtility.getFormattedDuration(match.timeStamp);
            }
            this.myMatchType.text = "@" + match.modeName;
            this.myMatchScore.text = String(match.score);
            matchResult = WarGodUtility.getMatchResultByFactors(match.isWinner,match.isDraw,match.isDisconnected);
            colorFrame = this.getFrameColorFrame(matchResult);
            this.myMatchResult.text = WarGodUtility.getLocalizedMatchResult(matchResult);
            this.myFrame.gotoAndStop(colorFrame);
            this.myMatchResult.fontColor = this.getFrameColor(matchResult);
         }
         return matchValid;
      }
      
      protected function getFrameColorFrame(result:int) : int
      {
         if(result == WarGodMatchObj.RESULT_WIN)
         {
            return 1;
         }
         if(result == WarGodMatchObj.RESULT_DRAW)
         {
            return 3;
         }
         return 2;
      }
      
      protected function getFrameColor(result:int) : int
      {
         if(result == WarGodMatchObj.RESULT_WIN)
         {
            return WON_COLOR;
         }
         if(result == WarGodMatchObj.RESULT_DRAW)
         {
            return DRAW_COLOR;
         }
         return LOSE_COLOR;
      }
      
      public function setIndex(index:int) : void
      {
         this.myMatchIndex.text = String(index);
      }
   }
}

