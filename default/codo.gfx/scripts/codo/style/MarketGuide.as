package codo.style
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class MarketGuide extends GlobalGuide
   {
      
      public static var MARKET_PROMO_DROP_SHADOW:DropShadowFilter = new DropShadowFilter(3,45,0,0.3,0,0);
      
      public static const MARKET_ITEM_PROMO_HOT_COLOR:uint = 15815448;
      
      public static const MARKET_ITEM_PROMO_POPULAR_COLOR:uint = 4375548;
      
      public static const MARKET_ITEM_PROMO_RECOMMENDED_COLOR:uint = 3188063;
      
      public static const MARKET_ITEM_PROMO_NEW_COLOR:uint = 1010604;
      
      private static const MARKET_ITEM_COMMON_TIER_COLOR:uint = 14868183;
      
      private static const MARKET_ITEM_UNCOMMON_TIER_COLOR:uint = 8837949;
      
      private static const MARKET_ITEM_RARE_TIER_COLOR:uint = 3525116;
      
      private static const MARKET_ITEM_EPIC_TIER_COLOR:uint = 12147967;
      
      private static const MARKET_ITEM_LEGENDARY_TIER_COLOR:uint = 16747264;
      
      public static const COLOR_BY_TIER:Array = [MARKET_ITEM_COMMON_TIER_COLOR,MARKET_ITEM_UNCOMMON_TIER_COLOR,MARKET_ITEM_RARE_TIER_COLOR,MARKET_ITEM_EPIC_TIER_COLOR,MARKET_ITEM_LEGENDARY_TIER_COLOR];
      
      public function MarketGuide()
      {
         super();
      }
      
      public static function get styleLoadoutWeaponName() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.fontColor = CODO_BLACK;
         style.autoSize = TextFieldAutoSize.NONE;
         return style;
      }
      
      public static function get styleMarketItemDetailsHeader() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.alignment = TextStyle.HALIGN_RIGHT;
         return style;
      }
      
      public static function get styleMarketButton() : TextStyle
      {
         var style:TextStyle = ButtonGuide.styleReplenishButton;
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = FONT_SIZE_TINY;
         style.multiLine = false;
         style.autoSize = TextFieldAutoSize.NONE;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get accountInfoCurrencyText() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleNumericTextSmall;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         return style;
      }
      
      public static function get marketItemPromoTag() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.allCaps = true;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         return style;
      }
      
      public static function get marketItemDiscountPromoTag() : TextStyle
      {
         var style:TextStyle = marketItemPromoTag;
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = FONT_SIZE_LARGE;
         return style;
      }
      
      public static function get marketItemPromoNewTag() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextHeader;
         style.font = FONT_FACE_BOLD;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.alignment = TextStyle.HALIGN_LEFT;
         style.alignmentVertical = TextStyle.VALIGN_TOP;
         style.fontColor = GlobalGuide.BLACK;
         return style;
      }
      
      public static function get stylePurchaseSuccessMsg() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleTextDescription;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get marketItemPreviewCount() : TextStyle
      {
         var style:TextStyle = GlobalGuide.styleNumericTextSmall;
         style.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         style.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
   }
}

