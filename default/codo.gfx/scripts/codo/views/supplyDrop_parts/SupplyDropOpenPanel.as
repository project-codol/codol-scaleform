package codo.views.supplyDrop_parts
{
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.services.MarketService;
   import codo.style.SupplyDropGuide;
   import codo.utils.LocalizeUtil;
   import flash.utils.Dictionary;
   
   public class SupplyDropOpenPanel extends SupplyDropBasePanel
   {
      
      public var myLSD:SupplyDropItem;
      
      public var myASD:SupplyDropItem;
      
      public var myBSD:SupplyDropItem;
      
      private var mSupplyDrops:Vector.<SupplyDropItem>;
      
      private var pendingConsumeSupplyDrop:int;
      
      private var pendingConsumeSupplyDropQuantity:int;
      
      public function SupplyDropOpenPanel()
      {
         super();
         var headerTxt:String = DictMarket.SUPPLY_DROP_OPEN_A_SUPPLY_DROP;
         if(inDebugMode)
         {
            headerTxt = "OPEN A SUPPLY DROP";
         }
         setPanelHeader(headerTxt);
         this.myLSD.dropID = MarketMenuData.SUPPLY_DROP_EVENT;
         this.myLSD.title = LocalizeUtil.localize(Dict.SUPPLY_DROP_EVENT_NAME);
         this.myLSD.itemImage = SupplyDropItem.TYPE_EVENT_CRATE_PATH;
         this.myLSD.myLSDBackground.visible = true;
         this.myLSD.myTitleTF.textStyle = SupplyDropGuide.styleSupplyDropItemLSDTitle;
         this.myASD.dropID = MarketMenuData.SUPPLY_DROP_ADVANCED;
         this.myASD.title = LocalizeUtil.localize(Dict.SUPPLY_DROP_ADVANCED_NAME);
         this.myASD.itemImage = SupplyDropItem.TYPE_ADVANCED_CRATE_PATH;
         this.myBSD.dropID = MarketMenuData.SUPPLY_DROP_BASIC;
         this.myBSD.title = LocalizeUtil.localize(Dict.SUPPLY_DROP_BASIC_NAME);
         this.myBSD.itemImage = SupplyDropItem.TYPE_BASIC_CRATE_PATH;
         this.mSupplyDrops = new Vector.<SupplyDropItem>();
         this.mSupplyDrops.push(this.myLSD);
         this.mSupplyDrops.push(this.myASD);
         this.mSupplyDrops.push(this.myBSD);
      }
      
      override public function active() : void
      {
         super.active();
         for(var i:int = 0; i < this.mSupplyDrops.length; i++)
         {
            this.mSupplyDrops[i].visible = false;
         }
         bind(DataID.SUPPLY_DROP_COUNT,this.updatePanel);
         listen(BCEvent.EVT_BSD_DUST_CHANGED,this.onBSDDustChanged);
         listen(BCEvent.EVT_ASD_DUST_CHANGED,this.onASDDustChanged);
         listen(BCEvent.EVT_LSD_DUST_CHANGED,this.onLSDDustChanged);
         listen(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onMarketPurchaseTaskSuccess);
         listen(BCEvent.EVT_MARKET_PURCHASE_POPUP_CLOSE_SUCCESS,this.onMarketPurchasePopupCloseSuccess);
         this.onBSDDustChanged(null);
         this.onASDDustChanged(null);
         this.onLSDDustChanged(null);
         broadcast(BCEvent.EVT_SUPPLY_DROP_REFRESH);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         broadcast(BCEvent.EVT_SHOW_PERSISTENT_VIEW);
         unbind(DataID.SUPPLY_DROP_COUNT,this.updatePanel);
         unlisten(BCEvent.EVT_BSD_DUST_CHANGED,this.onBSDDustChanged);
         unlisten(BCEvent.EVT_ASD_DUST_CHANGED,this.onASDDustChanged);
         unlisten(BCEvent.EVT_LSD_DUST_CHANGED,this.onLSDDustChanged);
         unlisten(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onMarketPurchaseTaskSuccess);
         unlisten(BCEvent.EVT_MARKET_PURCHASE_POPUP_CLOSE_SUCCESS,this.onMarketPurchasePopupCloseSuccess);
      }
      
      public function forceRefresh() : void
      {
         this.myLSD.dropID = MarketMenuData.SUPPLY_DROP_EVENT;
         this.myASD.dropID = MarketMenuData.SUPPLY_DROP_ADVANCED;
         this.myBSD.dropID = MarketMenuData.SUPPLY_DROP_BASIC;
         broadcast(BCEvent.EVT_SUPPLY_DROP_REFRESH);
      }
      
      public function registerToggleItemPreviewBoxHandler(handler:Function) : void
      {
         for(var i:int = 0; i < this.mSupplyDrops.length; i++)
         {
            this.mSupplyDrops[i].setToggleItemPreviewBoxHandler(handler);
         }
      }
      
      private function getSupplyDropValidProducts() : Dictionary
      {
         var itemIdx:int = 0;
         var product:ProductObj = null;
         var itemId:int = 0;
         var i:int = 0;
         var supplyDropValidProducts:Dictionary = new Dictionary();
         for(var prodData:Array = MarketService.getInstance().getItemListByCategory(MarketMenuData.GRP_SUPPLY_DROP_BUNDLE,Common.LIST_TYPE_MARKET_OR_EQUIPPABLE); itemIdx < prodData.length; )
         {
            product = prodData[itemIdx];
            itemId = 0;
            for(i = 0; i < product.itemsList.length; i++)
            {
               itemId = int(product.itemsList[i].id);
               if(itemId != MarketMenuData.SUPPLY_DROP_EVENT && itemId != MarketMenuData.SUPPLY_DROP_ADVANCED && itemId != MarketMenuData.SUPPLY_DROP_BASIC)
               {
               }
            }
            if(itemId != 0)
            {
               if(supplyDropValidProducts[itemId] === undefined)
               {
                  supplyDropValidProducts[itemId] = new Array();
               }
               supplyDropValidProducts[itemId].push(product);
            }
            itemIdx++;
         }
         return supplyDropValidProducts;
      }
      
      private function updateSupplyDropItem(crate:SupplyDropItem, quantity:int, prod:ProductObj) : void
      {
         crate.quantity = quantity;
         crate.dust = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[crate.dropID]);
         crate.setProductObj(prod);
         crate.visible = false;
         if(crate.quantity > 0)
         {
            crate.visible = true;
         }
         else if(prod != null)
         {
            crate.visible = true;
         }
      }
      
      private function updatePanel(cRes:Object) : void
      {
         var supplyDropValidProducts:Dictionary = this.getSupplyDropValidProducts();
         var lsdProd:ProductObj = supplyDropValidProducts[MarketMenuData.SUPPLY_DROP_EVENT] !== undefined ? supplyDropValidProducts[MarketMenuData.SUPPLY_DROP_EVENT][0] : null;
         var asdProd:ProductObj = supplyDropValidProducts[MarketMenuData.SUPPLY_DROP_ADVANCED] !== undefined ? supplyDropValidProducts[MarketMenuData.SUPPLY_DROP_ADVANCED][0] : null;
         var bsdProd:ProductObj = supplyDropValidProducts[MarketMenuData.SUPPLY_DROP_BASIC] !== undefined ? supplyDropValidProducts[MarketMenuData.SUPPLY_DROP_BASIC][0] : null;
         this.updateSupplyDropItem(this.myLSD,cRes.data.event,lsdProd);
         this.updateSupplyDropItem(this.myASD,cRes.data.adv,asdProd);
         this.updateSupplyDropItem(this.myBSD,cRes.data.basic,bsdProd);
         this.layoutSupplyDropItems();
      }
      
      private function layoutSupplyDropItems() : void
      {
         var crate:SupplyDropItem = null;
         var padding:int = 10;
         var x:int = 0;
         for(var i:int = 0; i < this.mSupplyDrops.length; i++)
         {
            crate = this.mSupplyDrops[i];
            if(crate.visible)
            {
               crate.x = x;
               x += crate.width + padding;
            }
         }
      }
      
      private function onBSDDustChanged(ev:ParaEvent) : void
      {
         this.myBSD.dust = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[MarketMenuData.SUPPLY_DROP_BASIC]);
      }
      
      private function onASDDustChanged(ev:ParaEvent) : void
      {
         this.myASD.dust = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[MarketMenuData.SUPPLY_DROP_ADVANCED]);
      }
      
      private function onLSDDustChanged(ev:ParaEvent) : void
      {
         this.myLSD.dust = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[MarketMenuData.SUPPLY_DROP_EVENT]);
      }
      
      private function onMarketPurchaseTaskSuccess(ev:ParaEvent) : void
      {
         this.pendingConsumeSupplyDrop = 0;
         this.pendingConsumeSupplyDropQuantity = 0;
         var purchasedItem:int = ev.myPara as int;
         var itemIDs:Array = CFunctionContainer.AS_GetItemIDsFromProduct(purchasedItem);
         var supportMultipleConsume:Boolean = false;
         for(var i:int = 0; i < itemIDs.length; i++)
         {
            if(Boolean(CFunctionContainer.AS_IsSupplyDropMultipleConsumable(itemIDs[i])))
            {
               supportMultipleConsume = true;
            }
         }
         if(!supportMultipleConsume)
         {
            return;
         }
         var quantity:int = CFunctionContainer.GetItemQuantityByProductAndItemIndex(purchasedItem,0);
         if(itemIDs.indexOf(MarketMenuData.SUPPLY_DROP_BASIC) >= 0)
         {
            this.pendingConsumeSupplyDrop = MarketMenuData.SUPPLY_DROP_BASIC;
            this.pendingConsumeSupplyDropQuantity = quantity;
         }
         else if(itemIDs.indexOf(MarketMenuData.SUPPLY_DROP_ADVANCED) >= 0)
         {
            this.pendingConsumeSupplyDrop = MarketMenuData.SUPPLY_DROP_ADVANCED;
            this.pendingConsumeSupplyDropQuantity = quantity;
         }
         else if(itemIDs.indexOf(MarketMenuData.SUPPLY_DROP_EVENT) >= 0)
         {
            this.pendingConsumeSupplyDrop = MarketMenuData.SUPPLY_DROP_EVENT;
            this.pendingConsumeSupplyDropQuantity = quantity;
         }
      }
      
      private function onMarketPurchasePopupCloseSuccess(ev:ParaEvent) : void
      {
         if(this.pendingConsumeSupplyDropQuantity == 0)
         {
            return;
         }
         if(this.pendingConsumeSupplyDrop == MarketMenuData.SUPPLY_DROP_BASIC)
         {
            this.myBSD.consumeSupplyDrop(this.pendingConsumeSupplyDropQuantity);
         }
         else if(this.pendingConsumeSupplyDrop == MarketMenuData.SUPPLY_DROP_ADVANCED)
         {
            this.myASD.consumeSupplyDrop(this.pendingConsumeSupplyDropQuantity);
         }
         else if(this.pendingConsumeSupplyDrop == MarketMenuData.SUPPLY_DROP_EVENT)
         {
            this.myLSD.consumeSupplyDrop(this.pendingConsumeSupplyDropQuantity);
         }
      }
   }
}

