package codo.views.recommended_loadout_parts
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.objects.ProductObj;
   import codo.utils.MarketItemUtil;
   import codo.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class RecommendedLoadoutPurchaseRemainderItem extends UIInteractiveComponent
   {
      
      public var myDuration:TextField;
      
      public var myPrice:TextField;
      
      public var myCurrencyIcon:MovieClip;
      
      public var myItemCard:MarketplaceItemCard;
      
      public function RecommendedLoadoutPurchaseRemainderItem()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         var productObj:ProductObj = null;
         var sku:Object = null;
         super.setData(data);
         productObj = data as ProductObj;
         this.myItemCard.setCardStyle(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false);
         this.myItemCard.withOwnStateHint = false;
         this.myItemCard.withDiscountTag = false;
         this.myItemCard.setData(productObj);
         this.myItemCard.myTimeRemainingTF.visible = false;
         sku = productObj.SKUs[productObj.currentSKUIndex];
         if(sku.duration > 0)
         {
            this.myDuration.text = TimeUtil.convertTimeRemainingToHHMMSS(sku.duration);
         }
         else
         {
            this.myDuration.text = TimeUtil.forever();
         }
         this.myPrice.visible = true;
         if(sku.cc > 0)
         {
            this.myCurrencyIcon.gotoAndStop(2);
            this.myPrice.text = sku.cc.toString();
         }
         else if(sku.cp > 0)
         {
            this.myCurrencyIcon.gotoAndStop(1);
            this.myPrice.text = sku.cp.toString();
         }
         else
         {
            this.myPrice.visible = false;
         }
         this.myPrice.x = this.myItemCard.width - this.myPrice.textWidth - 20;
         this.myCurrencyIcon.x = this.myPrice.x - this.myCurrencyIcon.width - 5;
      }
   }
}

