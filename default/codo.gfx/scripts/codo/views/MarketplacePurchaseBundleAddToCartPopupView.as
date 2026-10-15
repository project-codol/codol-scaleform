package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.MarketplacePriceSelector;
   import codo.component.PlayerAccountInfo;
   import codo.component.ScrollBar;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.TLogUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class MarketplacePurchaseBundleAddToCartPopupView extends PopupView
   {
      
      private const MAX_DISPLAY_ROWS:int = 2;
      
      public var myPlayerAccountInfo:PlayerAccountInfo;
      
      public var myPriceSelector:MarketplacePriceSelector;
      
      public var myBundleDesc:TextField;
      
      public var myItemsListScrollbar:ScrollBar;
      
      public var myItemsListMask:MovieClip;
      
      public var myItemsList:MovieClip;
      
      public var myPurchaseOptionsTitle:TextField;
      
      public var mySaleLimit:TextField;
      
      private var mItemData:ProductObj;
      
      private var mItemCards:Vector.<MarketplaceItem> = new Vector.<MarketplaceItem>(0);
      
      private var mDisablePurchase:Boolean;
      
      private var mBaseItemsListY:Number;
      
      public function MarketplacePurchaseBundleAddToCartPopupView()
      {
         super();
         myPopup.myCloseButton.setClickCallback(this.onCancel,null,true);
         this.myPlayerAccountInfo.displayCurrencyOnly = true;
         this.myPriceSelector.showButtons(false);
         this.myPurchaseOptionsTitle.text = DictMarket.PURCHASE_OPTIONS;
         this.myPriceSelector.myLabel.visible = false;
         this.myPriceSelector.myHeader.visible = false;
         this.mBaseItemsListY = this.myItemsList.y;
         var scrollBarSettings:Object = new Object();
         scrollBarSettings.hitArea = this;
         scrollBarSettings.scrollCallback = this.onScroll;
         this.myItemsListScrollbar.init(scrollBarSettings);
         this.myPriceSelector.showDuration = false;
      }
      
      private function onCancel() : void
      {
         closePopupView();
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CANCEL);
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mySaleLimit.visible = false;
         this.myItemsListScrollbar.visible = false;
         this.myItemsListMask.visible = true;
         this.mItemData = data.itemData as ProductObj;
         this.mDisablePurchase = false;
         if(Boolean(data.bDisablePurchase))
         {
            this.mDisablePurchase = true;
         }
         var isDetailsPopup:Boolean = !this.mItemData.purchaseUiEnabled() || this.mDisablePurchase;
         this.setPopupMode(isDetailsPopup);
         this.refreshCurrentBundle();
      }
      
      override protected function showView() : void
      {
         super.showView();
         listen(BCEvent.EVT_EQUIPPED,this.onEquiped);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCEvent.EVT_EQUIPPED,this.onEquiped);
      }
      
      private function setPopupMode(isDetailsPopup:Boolean) : void
      {
         headerTitle = LocalizeUtil.localize(this.mItemData.name).replace(/[\n\r]/g,"-") + " " + LocalizeUtil.localize(Dict.BUNDLE_CONTENT);
         if(isDetailsPopup)
         {
            this.myPriceSelector.visible = false;
            this.myPurchaseOptionsTitle.visible = false;
            myPopup.setErrorMode(this.onCancel);
            if(this.mItemData.isEquippableBundle)
            {
               myPopup.configConfirmButton(Dict.EQUIP_ITEM,this.onEquip,true,SE_ID.UI_MARKET_EQUIP_CLICK);
            }
            return;
         }
         this.myPriceSelector.visible = true;
         this.myPurchaseOptionsTitle.visible = true;
         this.myPriceSelector.setData(this.mItemData);
         myPopup.resetButtons();
         myPopup.configConfirmButton(DictMarket.PURCHASE,this.onPurchaseItem,true,SE_ID.UI_MARKET_PURCHASE_CONFIRM_CLICK);
         if(this.mItemData.isEquippableBundle)
         {
            myPopup.configConfirmButton(DictMarket.BUY_AND_EQUIP,this.onPurchaseEquip,true,SE_ID.UI_MARKET_PURCHASE_CONFIRM_CLICK);
         }
      }
      
      private function refreshCurrentBundle() : void
      {
         var itemCard:MarketplaceItem = null;
         var i:int = 0;
         var MAX_ITEMS_PER_ROW:Number = NaN;
         var ITEM_CARD_HEIGHT:Number = NaN;
         var ITEM_CARD_X_PADDING:Number = NaN;
         var ITEM_CARD_Y_PADDING:Number = NaN;
         var SALE_LIMIT_PADDING:Number = NaN;
         var maskRowCount:int = 0;
         var id:int = 0;
         var item:ProductObj = null;
         var itemClass:Class = null;
         var purchasedTimes:int = 0;
         this.myItemsList.y = this.mBaseItemsListY;
         this.myItemsListScrollbar.setPosition(0,false);
         for(i = 0; i < this.mItemCards.length; i++)
         {
            itemCard = this.mItemCards[i];
            this.myItemsList.removeChild(itemCard);
         }
         this.mItemCards = new Vector.<MarketplaceItem>(0);
         this.myBundleDesc.text = this.mItemData.description;
         var itemIDs:Array = CFunctionContainer.AS_GetItemIDsFromProduct(this.mItemData.id);
         MAX_ITEMS_PER_ROW = 5;
         var ITEM_CARD_WIDTH:Number = 220;
         ITEM_CARD_HEIGHT = 160;
         ITEM_CARD_X_PADDING = 11.5;
         ITEM_CARD_Y_PADDING = 18;
         var MAX_ITEM_LIST_WIDTH:Number = 1146;
         var RAW_POPUP_HEIGHT:Number = 160;
         SALE_LIMIT_PADDING = 5;
         for(i = 0; i < itemIDs.length; i++)
         {
            id = int(itemIDs[i]);
            item = CFunctionCommonContainer.GetItemInfo(id);
            item.stackNumber = 0;
            if(item.stackable)
            {
               item.displayQuantity = CFunctionCommonContainer.AS_GetItemQuantityFromBundle(id,this.mItemData.id);
            }
            else
            {
               item.remainSecond = CFunctionCommonContainer.AS_GetItemDurationFromBundle(id,this.mItemData.id) * 86400;
            }
            itemClass = getDefinitionByName("codo.shared.marketplace.MarketplaceItem") as Class;
            itemCard = new itemClass() as MarketplaceItem;
            this.myItemsList.addChild(itemCard);
            this.mItemCards.push(itemCard);
            itemCard.isInteractiveEnabled = true;
            itemCard.setCardStyle(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false);
            itemCard.withOwnStateHint = false;
            itemCard.withCallToArms = false;
            itemCard.withDiscountTag = false;
            itemCard.setData(item);
         }
         var firstRowItemCount:int = this.mItemCards.length < MAX_ITEMS_PER_ROW ? int(this.mItemCards.length) : int(MAX_ITEMS_PER_ROW);
         var totalWidth:int = firstRowItemCount * ITEM_CARD_WIDTH + (firstRowItemCount - 1) * ITEM_CARD_X_PADDING;
         var totalRowCount:int = 0;
         if(this.mItemCards.length > 0)
         {
            totalRowCount = Math.floor((this.mItemCards.length - 1) / MAX_ITEMS_PER_ROW) + 1;
         }
         var xOffset:int = (MAX_ITEM_LIST_WIDTH - totalWidth) / 2;
         var yOffset:int = 0;
         for(i = 0; i < this.mItemCards.length; i++)
         {
            this.mItemCards[i].x = xOffset + Math.floor(i % MAX_ITEMS_PER_ROW) * (ITEM_CARD_WIDTH + ITEM_CARD_X_PADDING);
            this.mItemCards[i].y = yOffset + Math.floor(i / MAX_ITEMS_PER_ROW) * (ITEM_CARD_HEIGHT + ITEM_CARD_Y_PADDING);
         }
         maskRowCount = totalRowCount < this.MAX_DISPLAY_ROWS ? totalRowCount : this.MAX_DISPLAY_ROWS;
         this.myItemsListMask.x = xOffset + this.myItemsList.x;
         this.myItemsListMask.y = this.myItemsList.y;
         this.myItemsListMask.width = this.myItemsList.width;
         this.myItemsListMask.height = maskRowCount * (ITEM_CARD_HEIGHT + ITEM_CARD_Y_PADDING);
         if(totalRowCount > this.MAX_DISPLAY_ROWS)
         {
            this.myItemsListScrollbar.visible = true;
            this.myItemsListScrollbar.setEnabled(true);
            this.myItemsListScrollbar.x = this.myItemsListMask.x + (ITEM_CARD_WIDTH + ITEM_CARD_X_PADDING) * MAX_ITEMS_PER_ROW;
            this.myItemsListScrollbar.y = this.myItemsListMask.y;
            this.myItemsListScrollbar.height = ITEM_CARD_HEIGHT * this.MAX_DISPLAY_ROWS + ITEM_CARD_Y_PADDING * (this.MAX_DISPLAY_ROWS - 1);
            this.myItemsListScrollbar.setBarLength(this.myItemsListMask.height,this.myItemsList.height);
         }
         else
         {
            this.myItemsListScrollbar.visible = false;
            this.myItemsListScrollbar.setEnabled(false);
         }
         this.mySaleLimit.visible = this.mItemData.purchaseLimit > 0;
         if(Boolean(this.mItemData.exclusiveProductID) && Boolean(CFunctionContainer.IsPermanentOwnedProduct(this.mItemData.exclusiveProductID)))
         {
            this.mySaleLimit.text = LocalizeUtil.localize(DictMarket.ALREADY_HAVE_PERMANENT);
         }
         else
         {
            purchasedTimes = this.mItemData.purchaseLimit - this.mItemData.purchasedTimes;
            this.mySaleLimit.text = LocalizeUtil.param(DictMarket.SALE_LIMIT_DESC,[String(this.mItemData.purchaseLimit),String(purchasedTimes < 0 ? 0 : purchasedTimes)]);
         }
         if(this.mySaleLimit.visible)
         {
            myPopup.height = RAW_POPUP_HEIGHT + this.myItemsListMask.height + ITEM_CARD_Y_PADDING + this.myPriceSelector.myBackground.height + this.mySaleLimit.textHeight + SALE_LIMIT_PADDING;
         }
         else
         {
            myPopup.height = RAW_POPUP_HEIGHT + this.myItemsListMask.height + ITEM_CARD_Y_PADDING + this.myPriceSelector.myBackground.height;
         }
         this.myPurchaseOptionsTitle.y = RAW_POPUP_HEIGHT + this.myItemsListMask.height + 2 * ITEM_CARD_Y_PADDING;
         this.myPriceSelector.y = this.myPurchaseOptionsTitle.y - SALE_LIMIT_PADDING;
         this.mySaleLimit.y = this.myPriceSelector.y + this.myPriceSelector.myBackground.height + SALE_LIMIT_PADDING;
      }
      
      private function onPurchaseItem() : void
      {
         this.startPurchase(false);
         closePopupView();
      }
      
      private function onPurchaseEquip() : void
      {
         this.startPurchase(true);
      }
      
      private function startPurchase(equip:Boolean) : void
      {
         var tlogBtn:uint = 0;
         var purchasedTimes:int = 0;
         if(Boolean(this.mItemData.exclusiveProductID) && Boolean(CFunctionContainer.IsPermanentOwnedProduct(this.mItemData.exclusiveProductID)))
         {
            showMsg(LocalizeUtil.localize(DictMarket.ALREADY_HAVE_PERMANENT),MsgBtnCount.ONE);
            return;
         }
         if(this.mItemData.isReachPurchaseLimit())
         {
            purchasedTimes = this.mItemData.purchaseLimit - this.mItemData.purchasedTimes;
            showMsg(LocalizeUtil.param(DictMarket.SALE_LIMIT_DESC,[String(this.mItemData.purchaseLimit),String(purchasedTimes < 0 ? 0 : purchasedTimes)]),MsgBtnCount.ONE);
            return;
         }
         var prod:ProductObj = this.myPriceSelector.getProduct();
         var selectedSKU:SKUObj = prod.SKUs[prod.currentSKUIndex] as SKUObj;
         if(selectedSKU.cc > 0)
         {
            tlogBtn = equip ? ButtonTLog.BUTTON_PURCHASECONFIRM_BUYEQUIP_CC : ButtonTLog.BUTTON_PURCHASECONFIRM_BUY_CC;
         }
         else
         {
            tlogBtn = equip ? ButtonTLog.BUTTON_PURCHASECONFIRM_BUYEQUIP_CP : ButtonTLog.BUTTON_PURCHASECONFIRM_BUY_CP;
         }
         TLogUtil.TLog_UserInput(tlogBtn,this.mItemData.id);
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY,{
            "item":this.mItemData,
            "closeAfterPurchase":false,
            "equip":equip
         });
      }
      
      private function onEquip() : void
      {
         broadcast(BCEvent.EVT_EQUIP,{"item":this.mItemData});
      }
      
      private function onEquiped(evt:ParaEvent) : void
      {
         closePopupView();
         broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{"page":PageID.FSG_LOADOUT});
      }
      
      protected function onScroll(position:Number) : void
      {
         this.myItemsList.y = this.mBaseItemsListY - (this.myItemsList.height - this.myItemsListMask.height) * position;
      }
   }
}

