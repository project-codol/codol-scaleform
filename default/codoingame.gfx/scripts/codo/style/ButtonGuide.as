package codo.style
{
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class ButtonGuide extends GlobalGuide
   {
      
      public static var BUTTON_OFF_FILTER:Array = [new DropShadowFilter(5,120,1268104,1,25,25)];
      
      public static var BUTTON_ON_FILTER:Array = BUTTON_OFF_FILTER.concat([new GlowFilter(NAV_TEXT_BLUE,1,25,25)]);
      
      public static var BUTTON_BASE_GLOWFILTER:Array = [new GlowFilter(NAV_TEXT_BLUE,1,5,5)];
      
      public static var NUMBER_BUTTON_GLOWFILTER:Array = [new GlowFilter(NAV_TEXT_BLUE,0.75,10,10)];
      
      public function ButtonGuide()
      {
         super();
      }
      
      public static function get styleButtonCommon() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         style.allCaps = true;
         return style;
      }
      
      public static function get styleSupplyDropItemOpenButtonCounter() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = BLACK;
         style.fontSize = 12;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         style.allCaps = true;
         return style;
      }
      
      public static function get styleMatchSelectOption() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_SMALL;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.autoSize = TextFieldAutoSize.NONE;
         style.allCaps = true;
         return style;
      }
      
      public static function get stylePrimaryNavButton() : TextStyle
      {
         var style:TextStyle = styleButtonCommon;
         style.font = FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = NAV_TEXT_BLUE;
         style.autoSize = TextStyle.HALIGN_LEFT;
         style.fontSize = 20;
         return style;
      }
      
      public static function get styleSecondaryNavButton() : TextStyle
      {
         var style:TextStyle = stylePrimaryNavButton;
         style.fontSize = 17;
         return style;
      }
      
      public static function get styleFilterCategoryButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_SMALL;
         return style;
      }
      
      public static function get styleSmallFilterCategoryButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_TINY;
         return style;
      }
      
      public static function get styleCheckBoxLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleReplenishButton() : TextStyle
      {
         var style:TextStyle = styleButtonCommon;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleNumberButton() : TextStyle
      {
         var style:TextStyle = styleButtonCommon;
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         return style;
      }
      
      public static function get styleScrollListTabButton() : TextStyle
      {
         var style:TextStyle = styleNumberButton;
         style.font = FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get styleFilterToggleButton() : TextStyle
      {
         var style:TextStyle = styleNumberButton;
         style.font = FONT_FACE_MEDIUM;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get stylePageSelectorButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.autoSize = TextFieldAutoSize.NONE;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_SMALL;
         return style;
      }
      
      public static function get styleSocialTabButton() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
   }
}

