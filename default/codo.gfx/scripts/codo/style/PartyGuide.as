package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class PartyGuide extends GlobalGuide
   {
      
      public function PartyGuide()
      {
         super();
      }
      
      public static function get stylePartyHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_LARGE;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleInviteFriendIntroduction() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get styleInviteCountDown() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = CODO_COLOR_HIGHLIGHT_ORANGE;
         style.fontSize = FONT_SIZE_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.bold = true;
         style.italic = true;
         return style;
      }
      
      public static function get styleMiniClientTag() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = CODO_BLUE_LIGHT;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.bold = true;
         style.italic = true;
         return style;
      }
   }
}

