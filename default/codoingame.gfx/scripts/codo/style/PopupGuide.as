package codo.style
{
   import codo.component.popup.PopupHeader;
   import flash.text.TextFieldAutoSize;
   
   public class PopupGuide extends GlobalGuide
   {
      
      public var myHeader:PopupHeader;
      
      public function PopupGuide()
      {
         super();
      }
      
      public static function get stylePopupHeader() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get stylePopupButton() : TextStyle
      {
         var style:TextStyle = ButtonGuide.styleButtonCommon;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.wordWrap = style.multiLine = false;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleActivityRewardPopupMsg() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_SMALL;
         style.wordWrap = style.multiLine = true;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleActivityRewardQuantity() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_HUGE;
         style.fontColor = WHITE;
         return style;
      }
   }
}

