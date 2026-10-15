package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class MOTDGuide extends GlobalGuide
   {
      
      public function MOTDGuide()
      {
         super();
      }
      
      public static function get styleMOTDTitle() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.fontSize = 34;
         style.multiLine = style.wordWrap = false;
         return style;
      }
      
      public static function get styleRewardDurationTitle() : TextStyle
      {
         var style:TextStyle = styleMOTDTitle;
         style.multiLine = style.wordWrap = false;
         return style;
      }
      
      public static function get styleMOTDTitleLarge() : TextStyle
      {
         var style:TextStyle = null;
         style = styleMOTDTitle;
         style.fontSize = FONT_SIZE_GIGANTIC;
         return style;
      }
      
      public static function get styleMOTDDate() : TextStyle
      {
         var style:TextStyle = styleNumericTextSmall;
         style.fontSize = FONT_SIZE_MEDIUM;
         return style;
      }
      
      public static function get styleMOTDFilterOptionTitle() : TextStyle
      {
         var style:TextStyle = null;
         style = styleTextHeader;
         style.fontSize = 16;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMOTDFilterOptionDescription() : TextStyle
      {
         var style:TextStyle = null;
         style = styleTextSmall;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.fontColor = CODO_BLUE_HIGHLIGHT;
         style.multiLine = style.wordWrap = false;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMOTDFilterOptionDate() : TextStyle
      {
         var style:TextStyle = styleNumericTextSmall;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.fontColor = GRAY_80;
         style.fontSize = 16;
         return style;
      }
   }
}

