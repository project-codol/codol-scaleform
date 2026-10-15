package codo.style
{
   public class TutorialGuide
   {
      
      public static const OVERLAY_ALPHA:Number = 0.8;
      
      public static const DESCRIPTION_TEXT_COLOR:uint = 16777215;
      
      public function TutorialGuide()
      {
         super();
      }
      
      public static function get styleTextTitle() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = 34;
         style.wordWrap = style.multiLine = true;
         return style;
      }
      
      public static function get styleTextTitleSmall() : TextStyle
      {
         var style:TextStyle = null;
         style = styleTextTitle;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         return style;
      }
      
      public static function get styleTextTitleAlignRight() : TextStyle
      {
         var style:TextStyle = null;
         style = styleTextTitle;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         return style;
      }
      
      public static function get styleTextTitleAlignCenter() : TextStyle
      {
         var style:TextStyle = styleTextTitle;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleTextDescriptionAlignRight() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextDescription;
         style.fontColor = DESCRIPTION_TEXT_COLOR;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         return style;
      }
      
      public static function get styleTextTitleSingleLine() : TextStyle
      {
         var style:TextStyle = styleTextTitle;
         style.wordWrap = style.multiLine = false;
         style.fontColor = DESCRIPTION_TEXT_COLOR;
         return style;
      }
      
      public static function get styleTextDescription() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextDescription;
         style.fontColor = DESCRIPTION_TEXT_COLOR;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         return style;
      }
      
      public static function get styleTextDescriptionMedium() : TextStyle
      {
         var style:TextStyle = styleTextDescription;
         style.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         return style;
      }
      
      public static function get styleTextDescriptionAlignCenter() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextDescription;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.fontColor = DESCRIPTION_TEXT_COLOR;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         return style;
      }
   }
}

