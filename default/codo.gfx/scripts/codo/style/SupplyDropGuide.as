package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class SupplyDropGuide extends GlobalGuide
   {
      
      public function SupplyDropGuide()
      {
         super();
      }
      
      public static function get styleSupplyDropHeader() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM;
         return style;
      }
      
      public static function get styleSupplyDropViewItemsButton() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontSize = 16;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleSupplyDropFeaturePanelHeader() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.fontSize = FONT_SIZE_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.font = FONT_FACE_BOLD;
         return style;
      }
      
      public static function get styleSupplyDropFeaturePanelDescription() : TextStyle
      {
         var style:TextStyle = styleTextSubHeader;
         style.fontColor = CODO_BLUE_HIGHLIGHT;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.multiLine = style.wordWrap = true;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSupplyDropFeatureItemButtonLabel() : TextStyle
      {
         var style:TextStyle = styleTextSmall;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleSupplyDropItemsToWinHeader() : TextStyle
      {
         var style:TextStyle = styleSupplyDropHeader;
         style.fontSize = FONT_SIZE_HUGE;
         return style;
      }
      
      public static function get styleSupplyDropItemsToWinTitle() : TextStyle
      {
         var style:TextStyle = styleTextSubHeader;
         style.font = FONT_FACE_BOLD;
         return style;
      }
      
      public static function get styleSupplyDropItemFilterTitle() : TextStyle
      {
         var style:TextStyle = styleSupplyDropItemsToWinTitle;
         style.fontSize = 27;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSupplyDropItemTitle() : TextStyle
      {
         var style:TextStyle = styleSupplyDropItemsToWinTitle;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSupplyDropItemLSDTitle() : TextStyle
      {
         var style:TextStyle = styleSupplyDropItemsToWinTitle;
         style.fontSize = 18;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get styleSupplyDropDustPanelTitle() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.fontSize = FONT_SIZE_SMALL;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.CENTER;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleSupplyDropDusts() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.fontSize = FONT_SIZE_MEDIUM;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
      
      public static function get styleSupplyDropDustProgress() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_HUGE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.autoSize = TextFieldAutoSize.RIGHT;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.bold = true;
         return style;
      }
      
      public static function get styleSupplyDropDustTotalProgress() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_HUGE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.bold = true;
         return style;
      }
      
      public static function get styleSupplyDropDustGlowProgress() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = WHITE;
         style.fontSize = 80;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.autoSize = TextFieldAutoSize.RIGHT;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.bold = true;
         return style;
      }
      
      public static function get styleSupplyDropItemNextDrop() : TextStyle
      {
         var style:TextStyle = styleSupplyDropItemsToWinTitle;
         style.fontSize = 15;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleSupplyDropItemsToWinDescription() : TextStyle
      {
         var style:TextStyle = styleSupplyDropHeader;
         style.multiLine = style.wordWrap = true;
         return style;
      }
      
      public static function get styleSupplyDropDustQuantity() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_LARGE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.autoSize = TextFieldAutoSize.LEFT;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.bold = true;
         return style;
      }
      
      public static function get styleAddSupplyDropTF() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = WHITE;
         style.fontSize = 80;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.bold = true;
         return style;
      }
   }
}

