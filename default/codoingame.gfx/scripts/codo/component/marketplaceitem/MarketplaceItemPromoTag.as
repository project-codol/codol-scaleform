package codo.component.marketplaceitem
{
   import codo.component.TextField;
   import codo.localization.DictMarket;
   import codo.style.MarketGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   
   public class MarketplaceItemPromoTag extends MovieClip
   {
      
      public static const TEMPLATE_HOT_ITEM:uint = 1;
      
      public static const TEMPLATE_RECOMMENDED:uint = 2;
      
      public static const TEMPLATE_POPUPLAR:uint = 3;
      
      public static const TEMPLATE_NEW:uint = 4;
      
      public static const PROMO_TAGS_BY_NAME:Dictionary = BUILD_PROMO_TAGS_BY_ID();
      
      public var myLabelTF:TextField;
      
      public var myHighlightBars:Sprite;
      
      public function MarketplaceItemPromoTag()
      {
         super();
         this.myLabelTF.textStyle = MarketGuide.marketItemPromoTag;
         this.myLabelTF.myTextClip.autoSize = TextFieldAutoSize.NONE;
         this.myLabelTF.myTextClip.width = 50;
         this.myLabelTF.myTextClip.multiline = this.myLabelTF.myTextClip.wordWrap = false;
      }
      
      private static function BUILD_PROMO_TAGS_BY_ID() : Dictionary
      {
         var promoTagsByName:Dictionary = new Dictionary(true);
         promoTagsByName[TEMPLATE_HOT_ITEM] = DictMarket.MARKETPLACE_HOT;
         promoTagsByName[TEMPLATE_RECOMMENDED] = DictMarket.MARKETPLACE_RECOMMENDED;
         promoTagsByName[TEMPLATE_POPUPLAR] = DictMarket.MARKETPLACE_POPULAR;
         promoTagsByName[TEMPLATE_NEW] = DictMarket.MARKETPLACE_NEW_ITEM;
         return promoTagsByName;
      }
      
      public static function GET_PROMO_TYPE_NAME_BY_ID(id:int) : String
      {
         return PROMO_TAGS_BY_NAME[id];
      }
      
      public function set promoType(typeID:uint) : void
      {
         var txtFilter:DropShadowFilter = null;
         var templateColor:uint = 0;
         var colorTransform:ColorTransform = null;
         txtFilter = MarketGuide.MARKET_PROMO_DROP_SHADOW;
         colorTransform = new ColorTransform();
         visible = true;
         switch(typeID)
         {
            case TEMPLATE_HOT_ITEM:
               templateColor = MarketGuide.MARKET_ITEM_PROMO_HOT_COLOR;
               break;
            case TEMPLATE_RECOMMENDED:
               templateColor = MarketGuide.MARKET_ITEM_PROMO_RECOMMENDED_COLOR;
               break;
            case TEMPLATE_POPUPLAR:
               templateColor = MarketGuide.MARKET_ITEM_PROMO_POPULAR_COLOR;
               break;
            default:
               visible = false;
         }
         colorTransform.color = templateColor;
         this.myHighlightBars.transform.colorTransform = colorTransform;
         this.myLabelTF.text = GET_PROMO_TYPE_NAME_BY_ID(typeID);
         if(txtFilter != null)
         {
            txtFilter.color = templateColor;
            this.myLabelTF.myTextClip.filters = [txtFilter];
         }
         this.myLabelTF.myTextClip.textColor = templateColor;
      }
   }
}

