package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCEvent;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.ResultObj;
   import codo.utils.Logger;
   import codo.utils.SoundUtil;
   import com.society.comscore.DAXDispatcher;
   
   public class MarketBaseController extends BaseController
   {
      
      protected var m_closePurchasePopupOnComplete:Boolean;
      
      protected var m_inventoryDirtyDueToDisconnect:Boolean;
      
      protected var m_dax_button_name:String = "buy";
      
      public function MarketBaseController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         listen(BCEvent.EVT_TRY_BUY_ASYM_ROBOT,this.onBuyAsymRobot);
         listen(BCEvent.EVT_CANCEL_BUY_ASYM_ROBOT,this.onCancelBuyAsymRobot);
         listen(BCEvent.EVT_MARKET_TRY_BUY_WITHOUT_EQUIP,this.onMarketTryBuyHandle);
         listen(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY,this.onMarketPurchaseConfirmBuyHandle);
         listen(BCEvent.EVT_MARKET_PURCHASE_CONFIRM_BUY_SKU_LIST,this.onMarketPurchaseConfirmBuySKUListHandle);
         listen(BCEvent.EVT_MARKET_PURCHASE_POPUP,this.onMarketPurchasePopupHandle);
         listen(BCEvent.EVT_MARKET_ADD_TO_CART_CONFIRM,this.onMarketAddToCartConfirmHandle);
         listen(BCEvent.EVT_MARKET_REMOVE_FROM_CART,this.onMarketRemoveFromCartHandle);
         listen(BCEvent.EVT_MARKET_PURCHASE_CART,this.onMarketPurchaseCartHandle);
         listen(BCEvent.EVT_MARKET_CLEAR_CART,this.onMarketClearCartHandle);
         listen(BCEvent.EVT_MARKET_EQUIP_COMPLETED_PURCHASE,this.onMarketEquipCompletedPurchaseHandle);
      }
      
      protected function onBuyCompleteHandle(cResult:ResultObj) : void
      {
         if(cResult.result == ResultObj.RESULT_SUCCESS)
         {
            try
            {
               this.dax_handleOnBuyTracking(cResult.params,this.m_dax_button_name,this.getPageNameToSendForTracking());
            }
            catch(e:Error)
            {
               Logger.print("*** DAXDispatcher: " + e.message);
            }
            this.refreshInventoryWhenBuy();
         }
         else
         {
            if(Boolean(cResult.data) && Boolean(cResult.data.purchaseInterrupted))
            {
               this.m_inventoryDirtyDueToDisconnect = true;
               closePopupPage(PageID.MARKET_PURCHASE_ADD_TO_CART);
               broadcast(BCEvent.GOTO_FIRST_PAGE);
            }
            this.onBuyFail();
         }
      }
      
      protected function onBuyItemWhenInventoryUpdated(cResult:ResultObj, soundOverriden:Boolean = false) : void
      {
         if(cResult.result == ResultObj.RESULT_SUCCESS)
         {
            if(!soundOverriden)
            {
               this.playSound(SE_ID.UI_PURCHASE_SUCCESS);
            }
            if(this.m_closePurchasePopupOnComplete)
            {
               this.closePageOnPurchaseComplete();
            }
            hideMsg();
            broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
            this.showPurchaseSuccess();
         }
         else
         {
            closePopupPage(PageID.MARKET_PURCHASE_ADD_TO_CART);
            hideMsg();
            broadcast(BCEvent.GOTO_FIRST_PAGE);
            showMsg(Dict.POST_PURCHASE_INVENTORY_REFRESH_FAILED,MsgBtnCount.ONE);
         }
         broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP_CLOSE_SUCCESS);
      }
      
      protected function closePageOnPurchaseComplete() : void
      {
         closePopupPage(PageID.MARKET_PURCHASE_ADD_TO_CART);
      }
      
      protected function showPurchaseSuccess() : void
      {
         showMsg(Dict.PURCHASE_SKUS_SUCCESS,MsgBtnCount.ONE,0,this.onShowPurchaseSuccessComplete);
      }
      
      protected function playSound(seID:String) : void
      {
         SoundUtil.getInstance().playSound(seID);
      }
      
      protected function onBuyFail() : void
      {
         SoundUtil.getInstance().playSound(SE_ID.UI_PURCHASE_FAIL[0]);
      }
      
      protected function onBuyAsymRobot(cEvt:ParaEvent) : void
      {
      }
      
      protected function onCancelBuyAsymRobot(cEvt:ParaEvent) : void
      {
      }
      
      protected function dax_handleOnBuyTracking(data:Object, purchaseButton:String, purchasePage:String) : void
      {
         var currentSKUIndex:Number = NaN;
         var itemDuration:Number = NaN;
         var itemPrice:Number = NaN;
         var purchaseType:String = null;
         var purchase_currency:String = null;
         try
         {
            currentSKUIndex = data.currentSKUIndex as Number;
            itemDuration = Number(data["SKUs"][currentSKUIndex].duration);
            itemPrice = Number(data["SKUs"][currentSKUIndex].price);
            purchaseType = "";
            if(itemDuration == 0)
            {
               purchaseType = "permanent_buy";
            }
            else
            {
               purchaseType = "rent";
            }
            purchase_currency = data["SKUs"][currentSKUIndex].currency == Dict.CP ? "CP" : "GP";
            DAXDispatcher.queue("item_name",data.name);
            DAXDispatcher.queue("item_type",data.type);
            DAXDispatcher.queue("purchase_type",purchaseType);
            DAXDispatcher.queue("price",String(itemPrice));
            DAXDispatcher.queue("purchase_button",purchaseButton);
            DAXDispatcher.queue("purchase_page",purchasePage);
            DAXDispatcher.queue("purchase_currency",purchase_currency);
            DAXDispatcher.queue("action_type","purchase");
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      protected function refreshInventoryWhenBuy() : void
      {
      }
      
      protected function onMarketPurchaseConfirmBuyHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketPurchaseConfirmBuySKUListHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketPurchasePopupHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketAddToCartConfirmHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketRemoveFromCartHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketPurchaseCartHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketClearCartHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketEquipCompletedPurchaseHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onMarketTryBuyHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onShowPurchaseSuccessComplete() : void
      {
      }
      
      protected function getPageNameToSendForTracking() : String
      {
         return "";
      }
   }
}

