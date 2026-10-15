package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class WarGodGuide extends GlobalGuide
   {
      
      public static const WIN_COLOR:uint = 3789724;
      
      public static const LOSE_COLOR:uint = 13518159;
      
      public static const DRAW_COLOR:uint = 297672;
      
      public static const MATCH_INDICATOR_UNMATCH_FRAME:int = 1;
      
      public static const MATCH_INDICATOR_MATCHED_FRAME:int = 2;
      
      public static const MATCH_INDICATOR_PENDING_FRAME:int = 3;
      
      public function WarGodGuide()
      {
         super();
      }
      
      public static function get styleMeterLabel() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMeterValue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 50;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSeasonName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 43;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSeasonDuration() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 16;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSeasonState() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 40;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleTierRewardLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleMatchIndex() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 24;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleMatchCardType() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMatchTime() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMatchScore() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 48;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMatchResult() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleRemainDay() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 80;
         style.fontColor = CODO_BLUE_LIGHT;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleRemainDayLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 35;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleStateLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleDetailDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.multiLine = true;
         style.wordWrap = true;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMatchInfo() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleHeroicComLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 16;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleHeroicComFactorLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleHeroicComFactorValue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         return style;
      }
      
      public static function get styleHeroicComTotal() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 22;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         return style;
      }
      
      public static function get styleWarGodCommonLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleWarGodProgressTextIndicator() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get stylePromotionStatusLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get stylePromotionWinCount() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 68;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleHeroicTierStarMeter() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 48;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleStarNumInRankMeter() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 28;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleTierNameInRankMeter() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get stylePromoScoreInRankMeter() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = 8040397;
         return style;
      }
      
      public static function get styleWarGodLeaderboardItem() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleWarGodLeaderboardItemForSelf() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = CODO_YELLOW;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleWarGodLeaderboardHeaderStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = GRAY_80;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleMetroIndex() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 25;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroTime() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroGameType() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroMap() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 16;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroNumberValue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = 30;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroStarChange() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroHeroicValueLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMetroHeroicValue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMatchLogLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleTipSeasonName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 24;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleTipSeasonDura() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleTipSeasonDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 14;
         style.fontColor = GRAY_80;
         return style;
      }
      
      public static function get styleSeasonEndTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 48;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSeasonEndSubTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 32;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSeasonEndContent() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         style.multiLine = true;
         return style;
      }
      
      public static function get styleTopWarGodLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 36;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMatchHistoryLabelStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = CODO_BLUE_LIGHT;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleMatchHistoryValueStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleRewardTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 48;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleRewardName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 28;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleRewardTime() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 28;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleRewardDescription() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.multiLine = true;
         style.wordWrap = true;
         style.autoSize = TextFieldAutoSize.NONE;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = 24;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleMatchLogPhaseStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleClanSeasonRewardItemName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 28;
         style.autoSize = TextFieldAutoSize.NONE;
         style.wordWrap = false;
         style.multiLine = false;
         return style;
      }
      
      public static function get styleClanChallengeRewardItemName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = CODO_BLACK;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.wordWrap = false;
         style.multiLine = false;
         return style;
      }
   }
}

