package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.constants.BCEvent;
   import codo.constants.PageID;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.views.recommended_loadout_parts.RecommendedLoadoutPurchaseRemainderItem;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class RecommendedLoadoutPurchaseRemainderItemsPopupView extends PopupView
   {
      
      public var myTotalPriceTF:TextField;
      
      public var myCPIcon:MovieClip;
      
      public var myCPPrice:TextField;
      
      public var myGPIcon:MovieClip;
      
      public var myGPPrice:TextField;
      
      public var myItemsHolder:MovieClip;
      
      public var myBuyBtn:CallToActionButton;
      
      private var mDisplayItems:Array;
      
      private var mSKUs:Array;
      
      public function RecommendedLoadoutPurchaseRemainderItemsPopupView()
      {
         super();
         myPopup.myHeaderbar.title = DictMarket.BUY;
         this.myBuyBtn.label = DictMarket.BUY;
         this.myBuyBtn.setClickCallback(this.onBuyBtnClicked);
         this.myCPIcon.gotoAndStop(2);
         this.myGPIcon.gotoAndStop(1);
         this.myTotalPriceTF.text = DictMarket.TOTAL_PRICE;
      }
      
      override public function set routeData(data:*) : void
      {
         var totalCP:int = 0;
         var totalGP:int = 0;
         var productObj:ProductObj = null;
         var sku:Object = null;
         var itemClass:Class = null;
         var itemCard:RecommendedLoadoutPurchaseRemainderItem = null;
         super.routeData = data;
         while(this.myItemsHolder.numChildren > 0)
         {
            this.myItemsHolder.removeChildAt(0);
         }
         this.mDisplayItems = [];
         this.mSKUs = [];
         totalCP = 0;
         totalGP = 0;
         var items:Array = data.items as Array;
         var isSkuId:Boolean = data.isSkuId as Boolean;
         for(var i:int = 0; i < items.length; i++)
         {
            productObj = null;
            if(isSkuId)
            {
               productObj = CFunctionCommonContainer.GetItemInfoBySku(items[i]);
            }
            else
            {
               productObj = CFunctionCommonContainer.GetItemInfo(items[i]);
            }
            if(!productObj.isOwned())
            {
               if(isSkuId)
               {
                  this.selectBestSKU(productObj,items[i]);
               }
               else
               {
                  this.selectBestSKU(productObj,0);
               }
               if(!(productObj.SKUs == null || productObj.SKUs.length == 0))
               {
                  sku = productObj.SKUs[productObj.currentSKUIndex];
                  this.mSKUs.push(sku);
                  totalCP += sku.cc;
                  totalGP += sku.cp;
                  itemClass = getDefinitionByName("recommendedLoadoutPurchaseRemainderItem") as Class;
                  itemCard = new itemClass();
                  itemCard.setData(productObj);
                  itemCard.x = this.mDisplayItems.length % 4 * 240;
                  itemCard.y = Math.floor(this.mDisplayItems.length / 4) * 200;
                  this.myItemsHolder.addChild(itemCard);
                  this.mDisplayItems.push(itemCard);
               }
            }
         }
         myPopup.width = Math.min(this.mDisplayItems.length,4) * 240 + 100;
         myPopup.height = Math.floor(Math.floor((this.mDisplayItems.length - 1) / 4) + 1) * 200 + 220;
         this.myBuyBtn.x = myPopup.width - 180;
         this.myBuyBtn.y = myPopup.height - 70;
         this.myTotalPriceTF.x = this.myCPIcon.x = this.myCPPrice.x = this.myGPIcon.x = this.myGPPrice.x = this.myBuyBtn.x;
         this.myTotalPriceTF.y = this.myCPIcon.y = this.myCPPrice.y = this.myGPIcon.y = this.myGPPrice.y = this.myBuyBtn.y + 10;
         this.myCPIcon.visible = this.myCPPrice.visible = this.myGPIcon.visible = this.myGPPrice.visible = false;
         if(totalGP > 0)
         {
            this.myGPPrice.visible = true;
            this.myGPPrice.text = totalGP.toString();
            this.myGPPrice.x = this.myBuyBtn.x - this.myGPPrice.textWidth - 10;
            this.myGPIcon.visible = true;
            this.myGPIcon.x = this.myGPPrice.x - this.myGPIcon.width - 5;
         }
         if(totalCP > 0)
         {
            this.myCPPrice.visible = true;
            this.myCPPrice.text = totalCP.toString();
            this.myCPPrice.x = this.myBuyBtn.x - this.myCPPrice.textWidth - 20;
            this.myCPIcon.visible = true;
            this.myCPIcon.x = this.myCPPrice.x - this.myCPIcon.width - 5;
         }
         this.myTotalPriceTF.x = Math.min(this.myCPIcon.x,this.myGPIcon.x) - this.myTotalPriceTF.textWidth - 10;
      }
      
      private function selectBestSKU(productObj:ProductObj, skuId:int) : void
      {
         var i:int = 0;
         var sku1:Object = null;
         var sku2:Object = null;
         var sku:Object = null;
         productObj.currentSKUIndex = 0;
         if(skuId == 0)
         {
            for(i = 0; i < productObj.SKUs.length; i++)
            {
               sku1 = productObj.SKUs[i];
               sku2 = productObj.SKUs[productObj.currentSKUIndex];
               if(sku1.cc > sku2.cc)
               {
                  productObj.currentSKUIndex = i;
               }
               else if(sku1.cc == sku2.cc)
               {
                  if(sku1.cp > sku2.cp)
                  {
                     productObj.currentSKUIndex = i;
                  }
               }
            }
         }
         else
         {
            for(i = 0; i < productObj.SKUs.length; i++)
            {
               sku = productObj.SKUs[i];
               if(sku.id == skuId)
               {
                  productObj.currentSKUIndex = i;
                  break;
               }
            }
         }
      }
      
      private function onBuyBtnClicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY_SKU_LIST,{"SKUs":this.mSKUs});
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.MARKET_PURCHASE_ADD_TO_CART});
      }
   }
}

