package codo.component.marketplaceitem
{
   import codo.localization.DictMarket;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class MarketplaceDiscountItemPromoTag extends Sprite
   {
      
      public var myLabelTF:TextField;
      
      public function MarketplaceDiscountItemPromoTag()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myLabelTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function set discount(value:String) : void
      {
         var discountTxt:String = LocalizeUtil.localize(DictMarket.SHOP_DISCOUNT_LABEL);
         this.myLabelTF.htmlText = value + "<font face=\"$font_3\">" + discountTxt + "</font>";
      }
   }
}

