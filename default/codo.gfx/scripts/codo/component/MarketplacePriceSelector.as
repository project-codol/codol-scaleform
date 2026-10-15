package codo.component
{
   import codo.common.CFunctionContainer;
   import codo.component.factory.MarketFactory;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class MarketplacePriceSelector extends MovieClip
   {
      
      private static const BUTTON_WIDTH:Number = 200;
      
      private static const BUTTON_OFFSET_Y:Number = 3;
      
      public var myBuyButton:CallToActionButton;
      
      public var myAddToCartButton:Button;
      
      public var myRadioMount:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myHighlight:MovieClip;
      
      public var myLabel:TextField;
      
      public var myInputBlocker:Sprite;
      
      public var myDivider:Sprite;
      
      public var myHeader:MovieClip;
      
      private var mRadios:Array;
      
      private var mPurchaseCallback:Function;
      
      private var mCartCallback:Function;
      
      private var mRadioClickCallback:Function;
      
      private var mHasHPEHP:Boolean = false;
      
      private var mShowDuration:Boolean = true;
      
      protected var _data:ProductObj;
      
      public function MarketplacePriceSelector()
      {
         super();
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myLabel.width = BUTTON_WIDTH;
         this.myLabel.text = LocalizeUtil.localize(DictMarket.PURCHASE_OPTIONS).toUpperCase();
         this.myBuyButton.audioRef.overrideClickAudio(SE_ID.UI_MARKET_PURCHASE_CLICK);
         this.myBuyButton.registerClickEvent(this.onPurchaseClicked);
         this.myBuyButton.width = BUTTON_WIDTH;
         this.myInputBlocker.visible = false;
         this.myDivider.visible = false;
         this.myAddToCartButton.visible = false;
      }
      
      public function set showDuration(showDuration:Boolean) : void
      {
         this.mShowDuration = showDuration;
      }
      
      public function setData(itemData:ProductObj) : void
      {
         var skuData:SKUObj = null;
         var clip:MarketplacePriceSelectorRow = null;
         var isMultiConsumableSupplyDrop:Boolean = false;
         this._data = itemData;
         this.clearRadios();
         var i:int = 0;
         this.myLabel.text = LocalizeUtil.localize(DictMarket.PURCHASE_OPTIONS).toUpperCase();
         if(itemData.type == "bnd" && itemData.group == "sdb")
         {
            isMultiConsumableSupplyDrop = false;
            for(i = 0; i < itemData.itemsList.length; i++)
            {
               if(Boolean(CFunctionContainer.AS_IsSupplyDropMultipleConsumable(itemData.itemsList[i].id)))
               {
                  isMultiConsumableSupplyDrop = true;
                  break;
               }
            }
            if(isMultiConsumableSupplyDrop)
            {
               this.myLabel.text = LocalizeUtil.localize(DictMarket.PURCHASE_AND_OPEN).toUpperCase();
            }
         }
         if(null == this._data || null == this._data.SKUs)
         {
            return;
         }
         var skus:Array = new Array();
         var promoSkus:Array = new Array();
         var sortedSkus:Array = new Array();
         this.myDivider.visible = false;
         for(i = 0; i < itemData.SKUs.length; i++)
         {
            skuData = itemData.SKUs[i] as SKUObj;
            if(skuData.promoSkuId != 0)
            {
               promoSkus.push(skuData.promoSkuId);
            }
         }
         for(i = 0; i < itemData.SKUs.length; i++)
         {
            skuData = itemData.SKUs[i] as SKUObj;
            if(promoSkus.indexOf(skuData.id) == -1)
            {
               if(ItemUtil.isUsingNewDiscountSystem)
               {
                  if(skuData.promoSkuId != 0)
                  {
                     continue;
                  }
               }
               skus.push(skuData);
            }
         }
         var len:int = int(skus.length);
         var dividerIndex:int = 0;
         this.myDivider.visible = false;
         this.mHasHPEHP = false;
         for(var skuIdx:int = 0; skuIdx < len; skuIdx++)
         {
            skuData = skus[skuIdx] as SKUObj;
            skuData.indexInProduct = skuIdx;
            if(skuData.currency == Dict.CP)
            {
               sortedSkus.push(skuData);
            }
         }
         for(skuIdx = 0; skuIdx < len; skuIdx++)
         {
            skuData = skus[skuIdx] as SKUObj;
            if(skuData.currency == Dict.GP)
            {
               if(dividerIndex == 0)
               {
                  dividerIndex = int(sortedSkus.length);
               }
               sortedSkus.push(skuData);
            }
         }
         for(skuIdx = 0; skuIdx < len; skuIdx++)
         {
            skuData = skus[skuIdx] as SKUObj;
            skuData.indexInProduct = skuIdx;
            if(skuData.currency == Dict.EHP)
            {
               this.mHasHPEHP = true;
               sortedSkus.push(skuData);
            }
         }
         for(skuIdx = 0; skuIdx < len; skuIdx++)
         {
            skuData = skus[skuIdx] as SKUObj;
            if(skuData.currency == Dict.HP)
            {
               this.mHasHPEHP = true;
               if(dividerIndex == 0)
               {
                  dividerIndex = int(sortedSkus.length);
               }
               sortedSkus.push(skuData);
            }
         }
         var curY:Number = 0;
         var rowIsChecked:Boolean = false;
         for(i = 0; i < len; i++)
         {
            if(i != 0 && i == dividerIndex)
            {
               this.myDivider.visible = true;
               this.myDivider.y = curY;
               curY += this.myDivider.height;
            }
            skuData = sortedSkus[i] as SKUObj;
            clip = MarketFactory.BUILD_MARKET_PRICE_SELECTOR_ROW(this.mShowDuration);
            clip.y = curY;
            clip.index = i;
            clip.setData(skuData);
            clip.enabled = skuData.purchasable;
            this.mRadios.push(clip);
            this.myRadioMount.addChild(clip);
            if(skuData.indexInProduct == itemData.currentSKUIndex && skuData.purchasable)
            {
               clip.checked = rowIsChecked = true;
               this.myHighlight.y = clip.y;
            }
            else
            {
               clip.checked = false;
            }
            clip.addCheckedCallback(this.onRadioClicked,clip);
            curY += clip.height;
         }
         if(Boolean(!rowIsChecked) && Boolean(this.mRadios[0]) && Boolean(this.mRadios[0].getData().purchasable))
         {
            this.mRadios[0].checked = rowIsChecked = true;
            this.myHighlight.y = this.mRadios[0].y;
         }
         this.myHighlight.visible = len > 1 && rowIsChecked;
         this.myBackground.height = curY;
         this.myAddToCartButton.y = this.myBuyButton.y = curY + BUTTON_OFFSET_Y;
         this.myBuyButton.label = this._data.isOwnedRental() ? DictMarket.EXTEND : DictMarket.PURCHASE;
      }
      
      public function hasHPEHP() : Boolean
      {
         return this.mHasHPEHP;
      }
      
      public function setAvailableMode(available:Boolean) : void
      {
         if(available)
         {
            alpha = 1;
            this.myInputBlocker.visible = false;
         }
         else
         {
            alpha = 0.5;
            this.myInputBlocker.visible = true;
            this.myInputBlocker.height = this.height + this.myAddToCartButton.height;
            this.myInputBlocker.width = this.width;
         }
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height + this.myBuyButton.height;
      }
      
      public function getProduct() : ProductObj
      {
         return this._data;
      }
      
      public function showButtons(show:Boolean) : void
      {
         this.myBuyButton.visible = show;
      }
      
      public function addPurchaseCallback(func:Function) : void
      {
         this.mPurchaseCallback = func;
      }
      
      public function addCartCallback(func:Function) : void
      {
         this.mCartCallback = func;
      }
      
      public function addRadioSelectedCallback(func:Function) : void
      {
         this.mRadioClickCallback = func;
      }
      
      private function clearRadios() : void
      {
         while(this.myRadioMount.numChildren > 0)
         {
            this.myRadioMount.removeChildAt(0);
         }
         this.mRadios = new Array();
      }
      
      private function onPurchaseClicked() : void
      {
         if(null != this.mPurchaseCallback)
         {
            this.mPurchaseCallback();
         }
      }
      
      private function onCartClicked() : void
      {
         if(null != this.mCartCallback)
         {
            this.mCartCallback();
         }
      }
      
      private function onRadioClicked(row:MarketplacePriceSelectorRow) : void
      {
         var clip:MarketplacePriceSelectorRow = null;
         var prevSkuIdx:uint = this._data.currentSKUIndex;
         this._data.currentSKUIndex = (row.getData() as SKUObj).indexInProduct;
         var len:int = int(this.mRadios.length);
         for(var i:int = 0; i < len; i++)
         {
            clip = this.mRadios[i];
            if(clip == row)
            {
               clip.checked = true;
               this.myHighlight.y = clip.y;
            }
            else
            {
               clip.checked = false;
            }
         }
         if(null != this.mRadioClickCallback)
         {
            this.mRadioClickCallback(prevSkuIdx);
         }
      }
   }
}

