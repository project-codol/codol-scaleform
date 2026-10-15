package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class SystemMessageGuide extends GlobalGuide
   {
      
      public static const BUTTON_WIDTH:int = 107;
      
      public static const BUTTON_HEIGHT:int = 36;
      
      public function SystemMessageGuide()
      {
         super();
      }
      
      public static function get styleAnnouncement() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleBigLoudSpeaker() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.fontColor = CODO_YELLOW;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleNewMailNotificationTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = 44;
         style.fontColor = WHITE;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         return style;
      }
      
      public static function get styleSenderName() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleTimeStamp() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = GRAY_80;
         style.alignmentVertical = TextStyle.VALIGN_BOTTOM;
         return style;
      }
      
      public static function get styleSubject() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.autoSize = TextFieldAutoSize.NONE;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleMessage() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.multiLine = true;
         style.wordWrap = true;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         return style;
      }
      
      public static function get styleAttachmentCount() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
   }
}

