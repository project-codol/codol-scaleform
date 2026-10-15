package codo.component
{
   import codo.common.CFunctionContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   
   public class ShoppingCartRow extends UIInteractiveComponent
   {
      
      private static const WIDTH:Number = 734;
      
      private static const HEIGHT:Number = 204;
      
      public var myItemCard:MarketplaceItem;
      
      public var myPriceSelector:MarketplacePriceSelector;
      
      public var myRemoveButton:Button;
      
      public var mySaveForLaterButton:Button;
      
      private var mRemoveCallback:Function;
      
      private var mSaveCallback:Function;
      
      private var mSKUSelectedCallback:Function;
      
      public function ShoppingCartRow()
      {
         super();
         this.myRemoveButton.label = Dict.REMOVE;
         this.mySaveForLaterButton.label = Dict.SAVE;
         this.myRemoveButton.registerClickEvent(this.onRemoveButtonClicked);
         this.mySaveForLaterButton.registerClickEvent(this.onSaveButtonClicked);
         this.myItemCard = addChild(MarketFactory.BUILD_MARKET_ITEM_MEDIUM_CARD()) as MarketplaceItem;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var productData:ProductObj = data as ProductObj;
         productData.hideExtendedButtons = true;
         this.myItemCard.setData(productData);
         this.myPriceSelector.showButtons(false);
         this.myPriceSelector.setData(productData);
         this.myPriceSelector.addRadioSelectedCallback(this.onSKUChanged);
         if(null != productData.removeCallback)
         {
            this.mRemoveCallback = productData.removeCallback;
         }
         if(null != productData.saveCallback)
         {
            this.mSaveCallback = productData.saveCallback;
         }
         if(null != productData.skuSelectedCallback)
         {
            this.mSKUSelectedCallback = productData.skuSelectedCallback;
         }
      }
      
      public function getProduct() : ProductObj
      {
         return this.myPriceSelector.getProduct();
      }
      
      override public function get width() : Number
      {
         return WIDTH;
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
      
      private function onSKUChanged(prevSkuIdx:uint) : void
      {
         var prod:ProductObj = this.getProduct();
         CFunctionContainer.MKT_RemoveFromCart(prod.SKUs[prevSkuIdx].id,prod.SKUs[prod.currentSKUIndex].id);
         if(null != this.mSKUSelectedCallback)
         {
            this.mSKUSelectedCallback(this);
         }
      }
      
      private function onRemoveButtonClicked() : void
      {
         if(null != this.mRemoveCallback)
         {
            this.mRemoveCallback(this);
         }
      }
      
      private function onSaveButtonClicked() : void
      {
         var prod:ProductObj = this.getProduct();
         prod.saveForLater = !prod.saveForLater;
         this.mySaveForLaterButton.setToggled(prod.saveForLater);
         if(null != this.mSaveCallback)
         {
            this.mSaveCallback(this);
         }
      }
   }
}

