package codo.controllers
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SE_ID;
   import codo.constants.SystemMsgPriority;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.manager.PageInGameManager;
   import codo.objects.ItemObj;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.objects.SystemMsgObj;
   import codo.utils.InGameTokenUtil;
   
   public class MarketInGameController extends MarketBaseController
   {
      
      private static const PURCHASE_FAIL:uint = 0;
      
      private static const PURCHASE_SUCCESS:uint = 1;
      
      private static const PURCHASE_TOKEN:uint = 2;
      
      private static const PURCHASE_RAMPAGE_TOKEN:uint = 3;
      
      private var mPendingPurchaseItem:ItemObj;
      
      private var mPendingTransaction:uint = 4294967295;
      
      public function MarketInGameController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         listen(BCEvent.EVT_CLOSE_OPTION,this.onCloseTokenPopup);
         listen(BCEvent.EVT_TRY_SPEND_TOKEN,this.onSpendToken);
         listen(BCEvent.EVT_CLOSE_POPUP_PAGE,this.closeMarketPopupPage);
         addDP(DataID.IS_CP_COUNT_ENABLED,this.isCpCountEnabled);
      }
      
      override protected function onMarketTryBuyHandle(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.MKT_RequestAccountInfo();
         CodoInGamePageDB.PAGE_LAYER_RESPAWN.instance.visible = false;
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART,false,ViewState.ACTIVATED,{"itemData":cEvt.myPara.data});
         CodoInGamePageDB.PAGE_LAYER_POPUP.instance.showATField();
      }
      
      override protected function onMarketPurchaseConfirmBuyHandle(cEvt:ParaEvent) : void
      {
         var itemObj:ItemObj = this.mPendingPurchaseItem = cEvt.myPara.item as ItemObj;
         var prod:SKUObj = itemObj.SKUs[itemObj.currentSKUIndex] as SKUObj;
         var msgObj:SystemMsgObj = new SystemMsgObj();
         msgObj.message = Dict.PURCHASE_IN_PROGRESS;
         msgObj.alwaysShowSpinner = true;
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_SYS_MSG_FSG,false,ViewState.ACTIVATED,msgObj);
         CodoInGamePageDB.PAGE_LAYER_NOTIFICATION.instance.showATField();
         broadcast(BCEvent.EVT_SET_SYS_VIEW_MSG,msgObj);
         CFunctionCommonContainer.ScriptMenuResponse("respawnpopupmenurevive","purchaseSku_".concat(prod.id));
         m_dax_button_name = "buy";
      }
      
      override protected function onMarketPurchaseConfirmBuySKUListHandle(cEvt:ParaEvent) : void
      {
      }
      
      public function cppOnTransactionComplete(result:int) : void
      {
         var i:int = 0;
         var msgObj:SystemMsgObj = new SystemMsgObj();
         var productObj:ProductObj = null;
         if(!InGameTokenUtil.InGamePurchaseAllowed())
         {
            return;
         }
         switch(result)
         {
            case PURCHASE_TOKEN:
            case PURCHASE_RAMPAGE_TOKEN:
               this.mPendingTransaction = result;
               CFunctionInGameContainer.BindUIKeyCatcher(true);
               CFunctionCommonContainer.MKT_RequestAccountInfo();
               CodoInGamePageDB.PAGE_LAYER_RESPAWN.instance.visible = false;
               productObj = this.getTokenProductData(result);
               productObj.ignoreDiscount = true;
               for(i = 0; i < productObj.SKUs.length; i++)
               {
                  productObj.SKUs[i].ignoreDiscount = true;
               }
               PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART,false,ViewState.ACTIVATED,{"itemData":productObj});
               CodoInGamePageDB.PAGE_LAYER_POPUP.instance.showATField();
               break;
            case PURCHASE_FAIL:
               playSound(SE_ID.UI_PURCHASE_FAIL[1]);
               msgObj.message = Dict.PURCHASE_SKUS_FAILED;
               msgObj.btnCount = MsgBtnCount.ONE;
               msgObj.priority = SystemMsgPriority.ERROR;
               msgObj.btn0Handle = this.onBuyFail;
               this.checkUpdateTokenDisplay(false);
               broadcast(BCEvent.EVT_SET_SYS_VIEW_MSG,msgObj);
               break;
            case PURCHASE_SUCCESS:
               playSound(SE_ID.UI_PURCHASE_SUCCESS);
               dax_handleOnBuyTracking(this.mPendingPurchaseItem,m_dax_button_name,this.getPageNameToSendForTracking());
               this.mPendingPurchaseItem = null;
               this.checkUpdateTokenDisplay(true);
               broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.MARKET_PURCHASE_ADD_TO_CART});
         }
      }
      
      private function checkUpdateTokenDisplay(success:Boolean) : void
      {
         if(this.mPendingTransaction != PURCHASE_TOKEN && this.mPendingTransaction != PURCHASE_RAMPAGE_TOKEN)
         {
            return;
         }
         var args:Object = {
            "success":success,
            "isRampage":this.mPendingTransaction == PURCHASE_RAMPAGE_TOKEN
         };
         this.mPendingTransaction = uint.MAX_VALUE;
         broadcast(BCEvent.EVT_TOKEN_UPDATE_DISPLAY,args);
      }
      
      private function getTokenProductData(typeID:int) : ProductObj
      {
         var itemID:int = 0;
         var PRICE_ARRAY:Array = null;
         var i:uint = 0;
         var prod:SKUObj = null;
         if(typeID == PURCHASE_TOKEN)
         {
            itemID = CFunctionCommonContainer.GetReviveTokenID();
         }
         else if(typeID == PURCHASE_RAMPAGE_TOKEN)
         {
            itemID = CFunctionCommonContainer.GetRampageTokenID();
         }
         var itemInfo:Object = CFunctionCommonContainer.GetItemInfo(itemID);
         var prodObj:ProductObj = new ProductObj(itemInfo);
         CFunctionCommonContainer.AS_SetupAndReturnMinSkus(prodObj);
         if(typeID == PURCHASE_TOKEN)
         {
            PRICE_ARRAY = [15827,15831,15832];
            for(i = 0; i < prodObj.SKUs.length; i++)
            {
               prod = prodObj.SKUs[i] as SKUObj;
               prod.productId = PRICE_ARRAY[i];
            }
         }
         return prodObj;
      }
      
      override protected function onBuyFail() : void
      {
         super.onBuyFail();
         playSound(SE_ID.UI_PURCHASE_FAIL[0]);
         this.checkUpdateTokenDisplay(false);
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.MARKET_PURCHASE_ADD_TO_CART});
      }
      
      private function onSpendToken(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("respawnpopupmenurevive","use_token");
      }
      
      protected function onCloseTokenPopup(cEvt:ParaEvent = null) : void
      {
         PageInGameManager.getInstance().showRevivePrompt(false);
      }
      
      override protected function getPageNameToSendForTracking() : String
      {
         return "ingame_token_spend";
      }
      
      private function closeMarketPopupPage(cEvt:ParaEvent) : void
      {
         var pageID:String = cEvt.myPara.pageID;
         if(pageID == PageID.MARKET_PURCHASE_ADD_TO_CART)
         {
            CFunctionInGameContainer.BindUIKeyCatcher(false);
            PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_POPUP);
            PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_NOTIFICATION);
            CodoInGamePageDB.PAGE_LAYER_RESPAWN.instance.visible = true;
            CFunctionCommonContainer.ScriptMenuResponse("respawnpopupmenurevive","cancelPurchase");
         }
      }
      
      private function isCpCountEnabled() : Boolean
      {
         var cpCounterLock:Boolean = this.getDvarBool("ui_lockCPCounter");
         return !cpCounterLock;
      }
   }
}

