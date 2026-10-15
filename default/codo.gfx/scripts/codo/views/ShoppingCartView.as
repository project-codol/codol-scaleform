package codo.views
{
   import codo.base.BaseView;
   import codo.component.Button;
   import codo.component.ComboBox;
   import codo.component.ScrollList;
   import codo.component.ShoppingCartRow;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.cpp.UiCppItemListView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.objects.ScrollListSettings;
   import codo.utils.ScaleformUtil;
   
   public class ShoppingCartView extends BaseView
   {
      
      public var myScrollList:ScrollList;
      
      public var myBackButton:Button;
      
      public var myPurchaseButton:Button;
      
      public var myClearButton:Button;
      
      public var mySortingSelector:ComboBox;
      
      public var myItemCount:TextField;
      
      public var myGPTotal:TextField;
      
      public var myCPTotal:TextField;
      
      private var mItems:Vector.<Object> = new Vector.<Object>();
      
      public function ShoppingCartView()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var CART_RENDERER_LINKAGE:String = null;
         CART_RENDERER_LINKAGE = "codo.views.shoppingCart.shoppingCartRow";
         this.myBackButton.label = Dict.BACK;
         this.myPurchaseButton.label = "PURCHASE";
         this.myClearButton.label = "CLEAR";
         this.myBackButton.registerClickEvent(this.onBackClicked);
         this.myPurchaseButton.registerClickEvent(this.onPurchaseClicked);
         this.myClearButton.registerClickEvent(this.onClearClicked);
         var sortingOptions:Array = [{
            "id":UiCppItemListView.SORT_DEFAULT,
            "enabled":true,
            "label":DictMarket.SORT_DEFAULT
         },{
            "id":UiCppItemListView.SORT_CP,
            "enabled":true,
            "label":Dict.CP
         },{
            "id":UiCppItemListView.SORT_GP,
            "enabled":true,
            "label":Dict.GP
         }];
         this.mySortingSelector.dataProvider = sortingOptions;
         this.mySortingSelector.addEventListener(ComboBox.EVT_CHANGE,this.onSortingChanged);
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.itemLinkage = CART_RENDERER_LINKAGE;
         this.myScrollList.settings = listSettings;
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(ScaleformUtil.isScaleform)
         {
            this.updateList();
            this.updateTotals();
         }
      }
      
      private function updateList() : void
      {
         var itemData:ProductObj = null;
         var cartItems:Array = getDP(DataID.MARKET_SHOPPING_CART_LIST);
         var len:int = int(cartItems.length);
         this.mItems = new Vector.<Object>();
         for(var i:int = 0; i < len; i++)
         {
            itemData = cartItems[i];
            itemData.removeCallback = this.onRowRemoveClicked;
            itemData.saveCallback = this.onRowSaveClicked;
            itemData.skuSelectedCallback = this.onSKUSelected;
            this.mItems.push(itemData);
         }
         this.myScrollList.addItemsByVector(this.mItems);
      }
      
      private function updateTotals() : void
      {
         var sku:SKUObj = null;
         var item:ProductObj = null;
         var cpTotal:int = 0;
         var gpTotal:int = 0;
         var itemList:Vector.<Object> = this.myScrollList.listData;
         if(null == itemList)
         {
            this.myCPTotal.text = "0";
            this.myGPTotal.text = "0";
            return;
         }
         var len:int = int(itemList.length);
         for(var i:int = 0; i < len; i++)
         {
            item = itemList[i] as ProductObj;
            sku = item.SKUs[item.currentSKUIndex] as SKUObj;
            if(!item.saveForLater)
            {
               if(sku.currency == Dict.CP)
               {
                  cpTotal += sku.price;
               }
               else if(sku.currency == Dict.GP)
               {
                  gpTotal += sku.price;
               }
            }
         }
         this.myItemCount.text = "SHOPPING CART (" + itemList.length.toString() + ")";
         this.myCPTotal.text = cpTotal.toString();
         this.myGPTotal.text = gpTotal.toString();
      }
      
      private function onSortingChanged(e:ParaEvent) : void
      {
         trace("SORTING NOT IMPLEMENTED");
      }
      
      private function onBackClicked() : void
      {
         trace("GO BACK");
      }
      
      private function onClearClicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_CLEAR_CART);
      }
      
      private function onPurchaseClicked() : void
      {
         var item:ProductObj = null;
         var items:Vector.<Object> = this.myScrollList.listData;
         var itemsToPurchase:Vector.<Object> = new Vector.<Object>();
         var excludedItems:Array = new Array();
         var len:int = int(items.length);
         for(var i:int = 0; i < len; i++)
         {
            item = items[i] as ProductObj;
            if(false == item.saveForLater)
            {
               itemsToPurchase.push({
                  "item":item,
                  "sku":item.SKUs[item.currentSKUIndex]
               });
            }
            else
            {
               excludedItems.push(item.SKUs[item.currentSKUIndex]);
            }
         }
         if(0 < itemsToPurchase.length)
         {
            broadcast(BCEvent.EVT_CONFIRM_SHOPPING_CART,{
               "items":itemsToPurchase,
               "excludedItems":excludedItems,
               "cpTotal":this.myCPTotal.text,
               "gpTotal":this.myGPTotal.text
            });
         }
      }
      
      private function onRowRemoveClicked(row:ShoppingCartRow) : void
      {
         var prod:ProductObj = row.getProduct();
         broadcast(BCEvent.EVT_MARKET_REMOVE_FROM_CART,{
            "item":prod,
            "sku":prod.SKUs[prod.currentSKUIndex]
         });
         this.updateList();
         this.updateTotals();
      }
      
      private function onRowSaveClicked(row:ShoppingCartRow) : void
      {
         this.updateTotals();
      }
      
      private function onSKUSelected(row:ShoppingCartRow) : void
      {
         this.updateTotals();
      }
   }
}

