package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class OnboardingGuide extends GlobalGuide
   {
      
      public function OnboardingGuide()
      {
         super();
      }
      
      public static function get styleWelcomeHeader() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.wordWrap = true;
         style.multiLine = true;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleGeneralHeaderLarge() : TextStyle
      {
         var style:TextStyle = styleWelcomeHeader;
         style.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         return style;
      }
      
      public static function get styleCreateGamerTagTextField() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextDescription;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.multiLine = style.wordWrap = false;
         return style;
      }
      
      public static function get styleSelectCharacterCallToAction() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleCreateGameTagWarningText() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextDescription;
         style.fontColor = CODO_RED;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.multiLine = style.wordWrap = false;
         return style;
      }
   }
}

