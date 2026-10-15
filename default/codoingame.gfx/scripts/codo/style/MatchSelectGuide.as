package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class MatchSelectGuide extends GlobalGuide
   {
      
      public function MatchSelectGuide()
      {
         super();
      }
      
      public static function get styleHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleModeName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 54;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleModeOption() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 32;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleInfoLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.bold = true;
         return style;
      }
      
      public static function get stylePlaylistLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleDetailModeName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 28;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleDetailGameName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleLimitLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = 2984118;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleLimitText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.bold = true;
         style.fontSize = 28;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleModeDescription() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = WHITE;
         style.fontSize = 18;
         style.multiLine = true;
         style.autoSize = TextFieldAutoSize.NONE;
         style.wordWrap = true;
         return style;
      }
      
      public static function get styleNoLevelProgressLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = CODO_BLUE_LIGHT;
         style.fontSize = 18;
         style.multiLine = true;
         style.autoSize = TextFieldAutoSize.NONE;
         style.wordWrap = true;
         return style;
      }
      
      public static function get styleDifficultyHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = CODO_BLUE_LIGHT;
         style.fontSize = 18;
         return style;
      }
      
      public static function get styleMapDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = WHITE;
         style.fontSize = 18;
         style.multiLine = true;
         style.autoSize = TextFieldAutoSize.NONE;
         style.wordWrap = true;
         return style;
      }
      
      public static function get styleGetRoomFilterButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = WHITE;
         style.fontSize = 15;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleRoomSettingLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = CODO_BLUE_LIGHT;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleRoomName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleRoomPlayerNum() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = 22;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleNoRoomModeInfo() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         style.font = FONT_FACE_BOLD;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleCustomHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontColor = GlobalGuide.WHITE;
         style.fontSize = 18;
         style.font = FONT_FACE_BOLD;
         return style;
      }
   }
}

