package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionContainer;
   import codo.component.MarketplacePriceSelector;
   import codo.component.PlayerAccountInfo;
   import codo.component.Popup;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.constants.MsgBtnCount;
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class MarketplacePurchaseAddToCartPopupView extends PopupView
   {
      
      private static const PADDING:uint = 20;
      
      private static const PRICE_SELECTOR_PADDING:Number = 50;
      
      private static const PURCHASE_LIMIT_Y:int = 376;
      
      public var myPriceSelector:MarketplacePriceSelector;
      
      public var myDescription:TextField;
      
      public var mySaleLimit:TextField;
      
      public var myPlayerAccountInfo:PlayerAccountInfo;
      
      public var myMarketItemCardHolder:Sprite;
      
      public var myRenewItemSwitcher:MovieClip;
      
      private var mItemData:ProductObj;
      
      private var myItemCard:MarketplaceItem;
      
      private var mDisablePurchase:Boolean;
      
      private var mRenewItems:Vector.<ProductObj>;
      
      private var mCurrRenewItem:uint;
      
      public function MarketplacePurchaseAddToCartPopupView()
      {
         super();
         myPopup.myCloseButton.setClickCallback(this.onCancel,null,true);
         this.myPlayerAccountInfo.displayCurrencyOnly = true;
         this.myPriceSelector.showButtons(false);
         this.myDescription.textStyle = GlobalGuide.styleTextDescription;
         this.myDescription.x = this.myMarketItemCardHolder.x + this.myMarketItemCardHolder.width + PADDING;
         this.myPriceSelector.x = this.myDescription.x;
         this.myDescription.width = myPopup.popupWidth - this.myDescription.x - PADDING;
         this.mySaleLimit.textStyle = GlobalGuide.styleTextSaleLimit;
         this.mySaleLimit.x = this.myDescription.x;
         this.mySaleLimit.width = this.myDescription.width;
         this.mySaleLimit.visible = false;
         this.myRenewItemSwitcher.visible = false;
         this.myRenewItemSwitcher.myLeftArrow.setClickCB(this.renewItemScrollLeft);
         this.myRenewItemSwitcher.myRightArrow.setClickCB(this.renewItemScrollRight);
         this.myRenewItemSwitcher.myCountTF.mouseEnabled = false;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mDisablePurchase = false;
         if(data.expiredItems != null)
         {
            if(data.expiredItems.length == 0)
            {
               broadcast(BCEvent.EVT_PROCESS_NOTHING_EXPIRED);
               return;
            }
            this.mRenewItems = data.expiredItems;
            this.mCurrRenewItem = 0;
            this.mItemData = this.mRenewItems[this.mCurrRenewItem];
         }
         else
         {
            this.mRenewItems = new Vector.<ProductObj>();
            this.mItemData = data.itemData as ProductObj;
            if(Boolean(data.bDisablePurchase))
            {
               this.mDisablePurchase = true;
            }
         }
         this.refreshViewForCurrentItem();
      }
      
      private function refreshViewForCurrentItem() : void
      {
         var desc:String = null;
         var purchasedTimes:int = 0;
         this.myPriceSelector.setData(this.mItemData);
         this.myPlayerAccountInfo.switchShowCurrencyMode(this.myPriceSelector.hasHPEHP() ? PlayerAccountInfo.HPEHPMode : PlayerAccountInfo.CPGPMode);
         if(this.mItemData.type == ItemType.PCT)
         {
            desc = this.mItemData.name;
         }
         else
         {
            desc = this.mItemData.description;
         }
         if(ScaleformUtil.IsLogItemIDEnabled())
         {
            desc = this.mItemData.id.toString() + ": " + LocalizeUtil.localize(desc);
         }
         this.myDescription.text = desc;
         this.myPriceSelector.y = this.myDescription.y + this.myDescription.textHeight + PRICE_SELECTOR_PADDING;
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
         var saleY:Number = this.myPriceSelector.y + this.myPriceSelector.height + PADDING;
         this.mySaleLimit.y = PURCHASE_LIMIT_Y >= saleY ? PURCHASE_LIMIT_Y : saleY;
         var error:String = null;
         var isDetailsPopup:Boolean = !this.mItemData.purchaseUiEnabled() || this.mDisablePurchase;
         var isRenewMode:Boolean = this.mRenewItems.length > 0;
         if(this.mItemData.type == ItemType.WAT && !CFunctionContainer.AS_IsDependencyOwnedForItem(this.mItemData.id))
         {
            error = DictMarket.MARKETPLACE_ITEM_REQUIRES_WEAPON_PURCHASE;
         }
         else if(this.mItemData.type == ItemType.CAT && !CFunctionContainer.AS_IsDependencyOwnedForItem(this.mItemData.id))
         {
            error = DictMarket.MARKETPLACE_ITEM_REQUIRES_CHARACTER_PURCHASE;
         }
         else if(this.mItemData.type == ItemType.BUNDLE && !CFunctionContainer.AS_IsDependencyOwnedForBundle(this.mItemData.id))
         {
            error = DictMarket.MARKETPLACE_ITEM_REQUIRES_CHARACTER_PURCHASE;
         }
         this.setPopupMode(error,isDetailsPopup,isRenewMode);
         if(ScaleformUtil.isScaleform)
         {
            this.myItemCard = MarketFactory.BUILD_MARKET_ITEM_LARGE_CARD() as MarketplaceItem;
            this.myItemCard.isInteractiveEnabled = false;
            this.myItemCard.setData(this.mItemData);
            this.myPlayerAccountInfo.myPlayerPrivileges.showPlayerPrivileges(1,2);
            while(this.myMarketItemCardHolder.numChildren > 0)
            {
               this.myMarketItemCardHolder.removeChildAt(0);
            }
            this.myMarketItemCardHolder.addChild(this.myItemCard);
         }
         myPopup.height = this.myMarketItemCardHolder.y + Math.max(this.myItemCard.height,this.myDescription.textHeight + (this.myPriceSelector.visible ? this.myPriceSelector.height + PRICE_SELECTOR_PADDING : 0) + (this.mySaleLimit.visible ? this.mySaleLimit.textHeight + PRICE_SELECTOR_PADDING : 0));
         var BANNER_OFFSET:int = 3;
         this.myPlayerAccountInfo.startXPos = myPopup.x + myPopup.width - (BANNER_OFFSET + Popup.CORNER_WIDTH);
         this.myPlayerAccountInfo.active();
      }
      
      private function setPopupMode(error:String, isDetailsPopup:Boolean, isRenewMode:Boolean) : void
      {
         var sBuyButtonText:String = null;
         var allowBuyEquip:Boolean = false;
         var characterID:int = 0;
         var previewItems:Array = null;
         var len:int = 0;
         var previewItem:ProductObj = null;
         var i:int = 0;
         this.myPriceSelector.visible = true;
         this.myRenewItemSwitcher.visible = false;
         if(this.mRenewItems.length > 1)
         {
            this.myRenewItemSwitcher.myCountTF.text = (this.mCurrRenewItem + 1).toString() + "/" + this.mRenewItems.length.toString();
            this.myRenewItemSwitcher.visible = true;
         }
         if(isDetailsPopup)
         {
            this.myPriceSelector.visible = false;
            myPopup.setErrorMode(this.onCancel);
            headerTitle = isRenewMode ? DictMarket.ITEM_EXPIRED : Dict.SHOW_ITEM_DETAIL_INFO;
            return;
         }
         if(error != null)
         {
            myPopup.setErrorMode(this.onCancel);
            myPopup.header.setErrorMode(error);
         }
         else
         {
            headerTitle = isRenewMode ? DictMarket.ITEM_EXPIRED : DictMarket.MARKET_SELECT_A_PURCHASE_OPTION;
            sBuyButtonText = isRenewMode ? Dict.RENEW : (this.mItemData.isOwnedRental() ? DictMarket.EXTEND : DictMarket.PURCHASE);
            myPopup.resetButtons();
            myPopup.configConfirmButton(sBuyButtonText,this.onPurchaseItem,true,SE_ID.UI_MARKET_PURCHASE_CONFIRM_CLICK);
            if(!isRenewMode)
            {
               allowBuyEquip = this.mItemData.group == MarketMenuData.GRP_EMOTE;
               if(this.mItemData.type == ItemType.CAT || this.mItemData.group == MarketMenuData.GRP_OUTFIT)
               {
                  allowBuyEquip = true;
                  characterID = CFunctionContainer.CL_GetCurrentCharacterID();
                  if(this.mItemData.type == ItemType.CAT && !CFunctionContainer.AS_IsDependencyRelation(this.mItemData.id,characterID))
                  {
                     allowBuyEquip = false;
                  }
                  if(this.mItemData.group == MarketMenuData.GRP_OUTFIT && !CFunctionContainer.AS_CanCharacterWearBundle(this.mItemData.id,characterID))
                  {
                     allowBuyEquip = false;
                  }
                  previewItems = getDP(DataID.MARKET_PREVIEW_ITEMS);
                  len = int(previewItems.length);
                  for(i = 0; i < len; i++)
                  {
                     previewItem = new ProductObj(previewItems[i]);
                     if(previewItem.type == ItemType.CHA)
                     {
                        allowBuyEquip = false;
                        break;
                     }
                  }
               }
               if(allowBuyEquip)
               {
                  myPopup.configConfirmButton(DictMarket.BUY_AND_EQUIP,this.onPurchaseEquip,true,SE_ID.UI_MARKET_PURCHASE_CONFIRM_CLICK);
               }
            }
            myPopup.configCancelButton(Dict.CANCEL,this.onCancel,SE_ID.UI_MARKET_PURCHASE_CANCEL_CLICK);
         }
         this.myPriceSelector.setAvailableMode(error == null);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onRenewSuccess);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         this.mItemData = null;
         this.myPlayerAccountInfo.deactive();
         unlisten(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.onRenewSuccess);
      }
      
      private function onRenewSuccess(evt:ParaEvent) : void
      {
         var renewalProductID:int = 0;
         var itemIDs:Array = null;
         if(this.mRenewItems.length > 0)
         {
            renewalProductID = evt.myPara as int;
            itemIDs = CFunctionContainer.AS_GetItemIDsFromProduct(renewalProductID);
            if(itemIDs.indexOf(this.mItemData.id) >= 0)
            {
               this.removeCurrentRenewal();
            }
         }
      }
      
      private function onPurchaseItem() : void
      {
         this.startPurchase(false);
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
         var bMoreToRenew:Boolean = this.mRenewItems.length > 1;
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY,{
            "item":this.mItemData,
            "closeAfterPurchase":!bMoreToRenew,
            "equip":equip
         });
      }
      
      private function onPurchaseEquip() : void
      {
         this.startPurchase(true);
      }
      
      private function onCancel() : void
      {
         if(this.mRenewItems.length > 0)
         {
            this.removeCurrentRenewal();
         }
         else
         {
            closePopupView();
         }
         broadcast(BCEvent.EVT_MARKET_PURCHASE_CANCEL);
      }
      
      private function removeCurrentRenewal() : void
      {
         this.mRenewItems.splice(this.mCurrRenewItem,1);
         if(this.mRenewItems.length == 0)
         {
            closePopupView();
            return;
         }
         this.renewItemScrollLeft();
      }
      
      private function renewItemScrollLeft() : void
      {
         --this.mCurrRenewItem;
         if(this.mCurrRenewItem >= this.mRenewItems.length)
         {
            this.mCurrRenewItem = this.mRenewItems.length - 1;
         }
         this.updateSelectedRenewal();
      }
      
      private function renewItemScrollRight() : void
      {
         ++this.mCurrRenewItem;
         if(this.mCurrRenewItem >= this.mRenewItems.length)
         {
            this.mCurrRenewItem = 0;
         }
         this.updateSelectedRenewal();
      }
      
      private function updateSelectedRenewal() : void
      {
         this.mItemData = this.mRenewItems[this.mCurrRenewItem];
         this.refreshViewForCurrentItem();
      }
   }
}

