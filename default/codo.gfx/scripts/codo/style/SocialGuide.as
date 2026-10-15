package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class SocialGuide extends GlobalGuide
   {
      
      public function SocialGuide()
      {
         super();
      }
      
      public static function get styleLevelWidget() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleSelfLevelWidget() : TextStyle
      {
         var style:TextStyle = styleLevelWidget;
         style.fontColor = CODO_YELLOW;
         return style;
      }
      
      public static function get styleLevelPending() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleLeaderboardToggleButtonMouseHover() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = GRAY_80;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleLeaderboardToggleButtonInactive() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = GRAY_50;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleLeaderboardToggleButtonActive() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 20;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
   }
}

