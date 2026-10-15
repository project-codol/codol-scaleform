package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class LeaderBoardGuide extends GlobalGuide
   {
      
      public static const ITEM_BTN_WIDTH:Number = 76;
      
      public static const ITEM_BTN_HEIGHT:Number = 26;
      
      public static const SELF_COLOR:uint = 16776960;
      
      public function LeaderBoardGuide()
      {
         super();
      }
      
      public static function get styleModeButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleTitle() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_LARGE;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleItemRender() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleItemNumberRender() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleRankNumberRender() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.CENTER;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = GRAY_80;
         return style;
      }
      
      public static function get styleNotice() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         return style;
      }
   }
}

