package codo.controllers
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.Common;
   import codo.constants.DWServiceStatus;
   import codo.constants.DataID;
   import codo.constants.InvitationType;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.PlayListType;
   import codo.constants.SE_ID;
   import codo.constants.SystemMsgPriority;
   import codo.constants.UITutorialFlags;
   import codo.constants.WebImgData;
   import codo.cpp.UiCppNewItems;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictAAS;
   import codo.localization.DictMail;
   import codo.localization.DictSystem;
   import codo.objects.CodoPageObj;
   import codo.objects.InvitationObj;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.NotForSaleObj;
   import codo.objects.PlayListObj;
   import codo.objects.ProductObj;
   import codo.objects.ResultObj;
   import codo.objects.SKUObj;
   import codo.objects.SystemMsgObj;
   import codo.objects.WarGodSeasonEndRewardObj;
   import codo.services.MarketService;
   import codo.services.MatchService;
   import codo.services.SettingsService;
   import codo.services.WeaponLoadoutService;
   import codo.utils.CommonUtil;
   import codo.utils.ItemUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import codo.utils.TimeUtil;
   import codo.views.UITutorialBaseView;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MarketController extends MarketBaseController
   {
      
      private static const REDEEM_COUPON_SUCCESS:int = 0;
      
      private static const CLAIM_COUPON_FAIL_WHENCLAIM:int = 1;
      
      private static const CLAIM_COUPON_FAIL_WHENUPDATE:int = 2;
      
      private static const CLAIM_COUPON_FAIL_WHENREDEEM:int = 3;
      
      private static const BD_MARKETPLACE_ITEM_MULTIPLE_PURCHASE_ERROR:int = 8010;
      
      private const CPU_TIMING_COMPENSATION:int = 1000;
      
      private const INVENTORY_UPDATE_PERIODIC:int = 60000;
      
      private const INVENTORY_UPDATE_RETRY_DELAY:int = 5000;
      
      private const INTERVAL_CHECK_DELAY:int = 5000;
      
      private const NFS_DATA_CHECK_INTERVAL:int = 1000;
      
      private var _initialExpirationTimer:Timer;
      
      private var _belatedInventoryUpdateTimer:Timer;
      
      private var _nfsDataCheckTimer:Timer;
      
      private var _pendingItemToEquip:Object = null;
      
      protected var _pendingPurchaseItem:Object;
      
      private var _purchaseWithEquipFunction:Boolean = true;
      
      private var m_obtainedTopSellerItemsForThisSession:Boolean = false;
      
      private var m_obtainedNewItemsForThisSession:Boolean = false;
      
      private var m_obtainedPopularItemsForThisSession:Boolean = false;
      
      private var m_obtainedRecommendedItemsForThisSession:Boolean = false;
      
      private var m_obtainedPromoHotItems:Boolean = false;
      
      private var m_obtainedPromoNewItems:Boolean = false;
      
      private var m_obtainedPromoPopularItems:Boolean = false;
      
      private var m_obtainedPromoRecommendedItems:Boolean = false;
      
      private var m_isNFSDataReady:Boolean = false;
      
      private var m_cachedTopSellerItems:Array = [];
      
      private var m_cachedPopularItems:Array = [];
      
      private var m_cachedRecommendedItems:Array = [];
      
      private var m_cachedPromoHotItems:Array = [];
      
      private var m_cachedPromoNewItems:Array = [];
      
      private var m_cachedPromoPopularItems:Array = [];
      
      private var m_cachedPromoRecommendedItems:Array = [];
      
      private var m_pendingWarGodRewards:Array = [];
      
      private var m_inventoryRefreshFailedMsg:SystemMsgObj = null;
      
      private var m_inventoryRefreshingMsg:SystemMsgObj = null;
      
      private var m_intervalCheckTimer:Timer;
      
      protected var _recommendedItems:Array;
      
      protected var _compareItem:ProductObj;
      
      protected var _previewItems:Array;
      
      protected var _checkinRewards:Vector.<MOTDCheckinRewardObj>;
      
      private var m_onboardingcouponRedeemTimer:Timer = null;
      
      public function MarketController()
      {
         super();
         this._previewItems = [];
         this._checkinRewards = new Vector.<MOTDCheckinRewardObj>();
         this._initialExpirationTimer = new Timer(100,1);
         this._initialExpirationTimer.addEventListener(TimerEvent.TIMER,this.timerInventoryUpdateHandler);
         this._belatedInventoryUpdateTimer = new Timer(this.INVENTORY_UPDATE_PERIODIC,1);
         this._belatedInventoryUpdateTimer.addEventListener(TimerEvent.TIMER,this.timerInventoryUpdateHandler);
         this._nfsDataCheckTimer = new Timer(this.NFS_DATA_CHECK_INTERVAL);
         this._nfsDataCheckTimer.addEventListener(TimerEvent.TIMER,this.nfsDataCheckHandler);
         this.m_intervalCheckTimer = new Timer(this.INTERVAL_CHECK_DELAY);
         this.m_intervalCheckTimer.addEventListener(TimerEvent.TIMER,this.intervalCheckTicked);
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         addDP(DataID.PURCHASE_WITH_EQUIP_FUNCTION,this.getPurchaseWithEquipFunction);
         addDP(DataID.IS_MARKETPLACE_MAINTAIN,this.isMarketplaceInMaintain);
         addDP(DataID.IS_REAL_MARKETPLACE_IN_MAINTAIN,this.isRealMarketplaceInMaintain);
         addDP(DataID.IS_MARKETPLACE_READY,this.isMarketplaceReady);
         addDP(DataID.IS_PLAYERDATA_READY,this.isPlayerDataReady);
         addDP(DataID.IS_DATA_AVAILABLE,this.isDataAvailable);
         addDP(DataID.IS_WEAPON_DATA_AVAILABLE,this.isWeaponDataAvailable);
         addDP(DataID.MARKETPLACE_UPDATE_STATE,this.getMarketplaceUpdateState);
         addDP(DataID.HOMEPAGE_MARKET_RECOMMEND_ITEM,this.getRecommendedItems);
         addDP(DataID.MARKET_COMPARE_ITEM,this.getCompareItem);
         addDP(DataID.MARKET_PREVIEW_ITEMS,this.getPreviewItems);
         addDP(DataID.CHECKIN_REWARDS,this.getCheckinRewards);
         addDP(DataID.CRAFTING_SHARD_COUNT,this.getCraftingShardCount);
         listen(BCEvent.EVT_MARKET_SHOW_DETAILS,this.onMarketShowDetails);
         listen(BCEvent.EVT_MARKET_SET_COMPARE_ITEM,this.setCompareItem);
         listen(BCEvent.EVT_MARKET_GIFT,this.onMarketTryGiftHandle);
         listen(BCEvent.EVT_INVENTORY_GIFT,this.onInventoryTryGiftHandle);
         listen(BCEvent.EVT_INVENTORY_SEND_COUPON,this.onInventoryTrySendCouponHandle);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangeHandle);
         listen(BCEvent.EVT_PURCHASE_CONFIRM_BUY_AND_EQUIP,this.onPurchaseConfirmBuyAndEquip);
         listen(BCEvent.EVT_TRY_BUY_TOKEN,this.onBuyToken);
         listen(BCEvent.EVT_MARKET_UPDATE_INVENTORY,this.onEvtUpdateInventory);
         listen(BCEvent.EVT_CHANGE_NAME_POPUP,this.onEvtChangeNamePopup);
         listen(BCEvent.EVT_CANCEL_CHANGE_NAME,this.onCancelChangeName);
         addDP(DataID.MARKET_WEAPON_CAREER,this.getWeaponCareer);
         listen(BCEvent.EVT_PAGE_CHANGED,this.onPageChangedHandle);
         addDP(DataID.ITEM_DATA_BY_ID,this.getItemDataByID);
         addDP(DataID.ITEM_ID_BY_NAME,this.getItemIDByName);
         addDP(DataID.MARKET_SHOPPING_CART_LIST,this.getMarketShoppingCartList);
         listen(BCEvent.GOTO_FIRST_PAGE,this.onEnterFirstPage);
         bind(DataID.POPUP_EXPIRED_ITEMS,this.bind_popUpExpiredItems);
         bind(DataID.EAsyncTaskID_Demonware,this.bind_demonwareMarketplaceStatusChange);
         bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         listen(BCEvent.EVT_PROCESS_EXPIRED_ITEMS,this.onProcessExpiredItem);
         listen(BCEvent.EVT_MARKET_GET_TOPSELLER_ITEMS,this.onGetTopSellerItems);
         listen(BCEvent.EVT_MARKET_GET_NEW_ITEMS,this.onGetNewItems);
         listen(BCEvent.EVT_MARKET_GET_POPULAR_ITEMS,this.onGetPopularItems);
         listen(BCEvent.EVT_HOMEPAGE_MARKET_RECOMMEND_REFRESH,this.onGetRecommendItems);
         listen(BCEvent.EVT_MARKET_GET_PROMO_HOT_ITEMS,this.onGetPromoHotItems);
         listen(BCEvent.EVT_MARKET_GET_PROMO_NEW_ITEMS,this.onGetPromoNewItems);
         listen(BCEvent.EVT_MARKET_GET_PROMO_POPULAR_ITEMS,this.onGetPromoPopularItems);
         listen(BCEvent.EVT_MARKET_GET_PROMO_RECOMMENDED_ITEMS,this.onGetPromoRecommendedItems);
         listen(BCEvent.EVT_PROCESS_NOTHING_EXPIRED,this.onProcessNothingExpired);
         listen(BCEvent.EVT_WEAPON_DATA_READY,this.handleMarketInventoryUpdate);
         listen(BCEvent.EVT_REDEEM_CHANGE_NAME,this.handleRedeemChangeName);
         listen(BCEvent.EVT_REDEEM_STAT_RESET,this.handleRedeemStatReset);
         listen(BCEvent.EVT_DW_CONNECTION_CHANGED,this.onDWConnectionChanged);
         listen(BCEvent.EVT_GOTO_SHOPPING_CART,this.onMarketGoToCartHandle);
         listen(BCEvent.EVT_SUPPLY_DROP_REFRESH,this.updateSupplyDropCount);
         listen(BCEvent.EVT_SHOW_EXPIRE_POPUP,this.showExpirePopup);
         listen(BCEvent.EVT_WANT_SHOW_WARGOD_CHALLENGE_REWARD,this.wantShowWarGodChallengeReward);
         listen(BCEvent.EVT_DO_NOTFORSALE_ACTION,this.notForSaleActionHandler);
         listen(BCEvent.EVT_SHOW_RECOMMENDED_LOADOUT_PURCHASE_REMAINDER_ITEMS_POPUP,this.showRecommendedLoadoutPurchaseRemainderItemsPopup);
         MarketService.getInstance().requestMyAccount();
         this.onUpdateHomepageItems();
         MarketService.getInstance().initMarketFavorites();
         ItemUtil.ignoreFutureSku = this.getDvarBool("dw_ignoreSKUFutureDate");
         ItemUtil.isUsingNewDiscountSystem = this.getDvarBool("dw_useNewDiscountSystem");
         ItemUtil.isChineseLanguage = CFunctionCommonContainer.IsChineseLanguage() as Boolean;
         Logger.print("MarketController: _initialExpirationTimer.start()");
         this._initialExpirationTimer.start();
         this.m_isNFSDataReady = CFunctionCommonContainer.IsNFSDataReady() as Boolean;
         if(!this.m_isNFSDataReady)
         {
            Logger.print("MarketController: _nfsDataCheckTimer.start()");
            this._nfsDataCheckTimer.start();
         }
      }
      
      public function cppShoppingCartFull() : void
      {
         showMsg(Dict.SHOPPINGCART_FULL,MsgBtnCount.ONE,SystemMsgPriority.ERROR);
      }
      
      public function cppRefreshShoppingCart() : void
      {
         broadcast(BCEvent.EVT_MARKET_CART_UPDATED);
      }
      
      public function cppRequestUpdateMarketInventory() : void
      {
         request(DataID.MARKET_UPDATE_INVENTORY,null,this.handleMarketInventoryUpdate);
      }
      
      public function cppOnMarketplaceUpdateStateChanged(state:int) : void
      {
         setBindData(DataID.MARKETPLACE_UPDATE_STATE,state);
      }
      
      public function cppOnPreviewListChanged(items:Array) : void
      {
         this._previewItems = items;
         broadcast(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,items);
      }
      
      public function cppOnboardingRewardCoupon(data:Object) : void
      {
         var couponIds:Array = null;
         var mstime:Number = NaN;
         if(Boolean(data.couponId) && Boolean(data.productId))
         {
            Logger.print("MarketController::cppOnboardingRewardCoupon product [" + data.productId + "] remaining time to redeem: " + data.remainingTime);
            if(data.remainingTime <= 0)
            {
               couponIds = new Array();
               couponIds.push(data.couponId);
               this.request(DataID.CLAIM_COUPON,couponIds,this.onRedeemCouponCompleted);
            }
            else
            {
               mstime = data.remainingTime * 1000;
               if(this.m_onboardingcouponRedeemTimer == null)
               {
                  this.m_onboardingcouponRedeemTimer = new Timer(mstime,1);
                  this.m_onboardingcouponRedeemTimer.addEventListener(TimerEvent.TIMER,this.updateOnboardingRewardCouponHandler);
                  this.m_onboardingcouponRedeemTimer.start();
               }
               else
               {
                  this.m_onboardingcouponRedeemTimer.reset();
                  this.m_onboardingcouponRedeemTimer.delay = mstime;
                  this.m_onboardingcouponRedeemTimer.start();
               }
            }
         }
      }
      
      public function cppUpdateCheckinRewards() : void
      {
         this._checkinRewards = CFunctionContainer.GetCheckinRewards();
         setBindData(DataID.CHECKIN_REWARDS,this._checkinRewards);
      }
      
      public function cppOnEntitlementUpdated() : void
      {
         broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
      }
      
      private function getCheckinRewards() : Vector.<MOTDCheckinRewardObj>
      {
         return this._checkinRewards;
      }
      
      private function onRedeemCouponCompleted(cRes:Object) : void
      {
         Logger.print("MarketController::onRedeemCouponCompleted errorCode: " + cRes.data.errorCode);
         var errorCode:int = int(cRes.data.errorCode);
         var detailCode:int = int(cRes.data.detailCode);
         this.hideMsg();
         var hasError:Boolean = false;
         var errorString:String = "";
         if(errorCode == REDEEM_COUPON_SUCCESS)
         {
            hasError = false;
            this.broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         else if(errorCode == CLAIM_COUPON_FAIL_WHENCLAIM)
         {
            hasError = true;
            errorString = Dict.REDEEM_COUPON_FAILED;
         }
         else if(errorCode == CLAIM_COUPON_FAIL_WHENUPDATE)
         {
            hasError = false;
         }
         else if(errorCode == CLAIM_COUPON_FAIL_WHENREDEEM)
         {
            hasError = false;
            if(detailCode == BD_MARKETPLACE_ITEM_MULTIPLE_PURCHASE_ERROR)
            {
               errorString = Dict.REDEEM_FAIL_EXIST_PERMANENT;
            }
            else
            {
               errorString = Dict.REDEEM_COUPON_FAILED;
            }
         }
         if(hasError)
         {
            this.showMsg(errorString,MsgBtnCount.ONE);
         }
         else
         {
            gotoPage(CodoPageViewDB.PAGE_POPUP_ONBOARD_RETURN_REWARDED);
         }
      }
      
      public function getPreviewItems() : Array
      {
         return this._previewItems;
      }
      
      public function cppOnMarketplaceInMaintainStateChanged(mainState:Boolean) : void
      {
         if(Boolean(mainState && !MatchService.getInstance().isInRoom && !MatchService.getInstance().isJoiningRoom()) && Boolean(CFunctionCommonContainer.OnboardIntroDone()) && getDP(DataID.CURRENT_BACKGROUND_POPUP_PAGE_ID) != PageID.FSG_MATCHRESULT)
         {
            UITutorialFlags.clearMarketTutorials();
            broadcast(BCEvent.EVT_GOTO_PLAY_MODE_SELECTION);
         }
         if(!mainState)
         {
            broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.MARKET_PURCHASE_ADD_TO_CART});
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.TOKEN_BUY});
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.MARKET_COMPARE});
         setBindData(DataID.MARKETPLACE_MAINTAIN_STATE,mainState);
         this.tryUpdatePromoData();
      }
      
      public function cppOnForceProcessExpireItems() : void
      {
         broadcast(BCEvent.EVT_PROCESS_EXPIRED_ITEMS);
      }
      
      public function cppItemRemovedFromInventory(itemId:int, itemWasEquipped:Boolean) : void
      {
         broadcast(BCEvent.EVT_ITEM_REMOVED_FROM_INVENTORY,{
            "id":itemId,
            "bWasEquipped":itemWasEquipped
         });
         var product:ProductObj = CFunctionCommonContainer.GetItemInfo(itemId);
         if(product != null && product.showBreadcrumb)
         {
            UiCppNewItems.instance.ClearNew(product);
         }
      }
      
      private function handleMarketInventoryUpdate() : void
      {
         Logger.print("MarketController::handleMarketInventoryUpdate");
         this._belatedInventoryUpdateTimer.reset();
         var delay:int = CFunctionContainer.AS_GetTimeInMillisecondsUntilNextBatchOfItemsExpire();
         if(delay > 0)
         {
            Logger.print("\tDELAY " + (delay + this.CPU_TIMING_COMPENSATION));
            this._belatedInventoryUpdateTimer.delay = delay + this.CPU_TIMING_COMPENSATION;
            this._belatedInventoryUpdateTimer.start();
            broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
         }
         else if(delay <= 0)
         {
            if(!getDP(DataID.IS_DATA_AVAILABLE) || !getDP(DataID.IS_WEAPON_DATA_AVAILABLE))
            {
               this._belatedInventoryUpdateTimer.delay = this.INVENTORY_UPDATE_PERIODIC;
               this._belatedInventoryUpdateTimer.start();
               return;
            }
            Logger.print("\tNOW");
            this.refreshExpirationPopup();
         }
         else
         {
            Logger.print("\tAll purchases are Permanent");
            this._belatedInventoryUpdateTimer.delay = this.INVENTORY_UPDATE_PERIODIC;
            this._belatedInventoryUpdateTimer.start();
            broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
         }
      }
      
      private function refreshInventoryOnReconnect() : void
      {
         hideSpecificMsg(this.m_inventoryRefreshFailedMsg);
         this.m_inventoryRefreshingMsg = showMsg(Dict.REFRESHING_INVENTORY,MsgBtnCount.ONE,SystemMsgPriority.ERROR,CommonUtil.quit,DictSystem.QUIT,null,"",null,"",0,true);
         request(DataID.MARKET_UPDATE_INVENTORY,null,this.onInventoryRefreshedAfterReconnect);
      }
      
      private function onDWConnectionChanged(cEvt:ParaEvent) : void
      {
         var dwReconnected:Boolean = Boolean(cEvt.myPara.isDWNowConnected);
         if(dwReconnected && m_inventoryDirtyDueToDisconnect)
         {
            this.refreshInventoryOnReconnect();
         }
      }
      
      private function timerInventoryUpdateHandler(event:TimerEvent) : void
      {
         this.handleMarketInventoryUpdate();
      }
      
      private function nfsDataCheckHandler(event:TimerEvent) : void
      {
         var isNFSReady:Boolean = false;
         if(this.m_isNFSDataReady == false)
         {
            isNFSReady = CFunctionCommonContainer.IsNFSDataReady() as Boolean;
            if(isNFSReady)
            {
               broadcast(BCEvent.EVT_NFS_DATA_READY);
               this._nfsDataCheckTimer.removeEventListener(TimerEvent.TIMER,this.nfsDataCheckHandler);
               this._nfsDataCheckTimer.reset();
               this.m_isNFSDataReady = isNFSReady;
            }
         }
      }
      
      private function handleRedeemChangeName(event:ParaEvent) : void
      {
         var newName:String = event.myPara;
         if(Boolean(CFunctionCommonContainer.IsInRoom()))
         {
            showMsg(Dict.CANNOT_CHANGE_NAME_IN_ROOM,MsgBtnCount.ONE);
            return;
         }
         if(Boolean(CFunctionContainer.IsTCLSLogOn()))
         {
            this.showMsg(Dict.REDEEM_NAME_IN_PROGRESS);
            this.request(DataID.REDEEM_CHANGE_NAME,{"newName":newName},this.onRedeemChangeNameComplete);
         }
         else
         {
            this.showMsg(Dict.CHANGE_NAME_TCLS_ONLY,MsgBtnCount.ONE);
         }
      }
      
      private function onRedeemChangeNameComplete(cRes:Object) : void
      {
         this.hideMsg();
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            CFunctionContainer.SavePlayerStats();
            this.prevPage();
            this.showMsg(Dict.POST_NAME_CHANGE_SUCCESS,MsgBtnCount.ONE,0,this.handleRestartNow,Dict.RESTART_NOW);
            Logger.print("Refresh Inventory after redeem change name card complete.");
            this.broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         else if(Boolean(cRes.data) && Boolean(cRes.data.operationInterrupted))
         {
            m_inventoryDirtyDueToDisconnect = true;
            closePopupPage(PageID.CHANGE_NAME);
         }
      }
      
      private function handleRedeemStatReset() : void
      {
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj("@SF_UI_STAT_RESET_WARNING",2,SystemMsgPriority.NORMAL,this.onStatResetConfirm,Dict.CONFIRM,null,Dict.CANCEL,null,"",0,0,DictSystem.WARNING);
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      private function onStatResetConfirm() : void
      {
         this.showMsg("@SF_UI_REDEEM_STAT_RESET_IN_PROGRESS");
         this.request(DataID.REDEEM_STAT_RESET,null,this.onRedeemStatResetComplete);
      }
      
      private function onRedeemStatResetComplete(cRes:Object) : void
      {
         this.hideMsg();
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            CFunctionContainer.SavePlayerStats();
            this.showMsg("@SF_UI_REDEEM_STAT_RESET_SUCCESS",MsgBtnCount.ONE,0,this.handleRestartNow,Dict.RESTART_NOW);
            this.broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         else
         {
            this.showMsg("@SF_UI_REDEEM_STAT_RESET_FAIL",MsgBtnCount.ONE,0,null,Dict.CONFIRM);
         }
      }
      
      private function handleRestartLater() : void
      {
         CFunctionContainer.AS_NameChangeRestartLater();
      }
      
      private function handleRestartNow() : void
      {
         var canRestart:Boolean = CFunctionContainer.CanRestartVideo() as Boolean;
         if(!canRestart)
         {
            this.listen(BCEvent.EVT_INIT_VID_RESTART,this.onVideoInitComplete);
            this.showMsg(Dict.NAME_CHANGE_CANNOT_RESTART);
            return;
         }
         canRestart = !this.getDP(DataID.IS_IN_ROOM) && !this.getDP(DataID.IS_IN_RANKED_MATCH) && !this.getDP(DataID.IS_IN_PARTY);
         if(!canRestart)
         {
            this.showMsg(Dict.IN_PARTY_CANNOT_RESTART,MsgBtnCount.ONE);
            return;
         }
         SettingsService.getInstance().restartRelogin();
      }
      
      private function onVideoInitComplete(cEvt:ParaEvent) : void
      {
         this.unlisten(BCEvent.EVT_INIT_VID_RESTART,this.onVideoInitComplete);
         this.prevPage();
         this.handleRestartNow();
      }
      
      public function getCompareItem() : ProductObj
      {
         return this._compareItem;
      }
      
      protected function setCompareItem(evt:ParaEvent) : void
      {
         this._compareItem = evt.myPara as ProductObj;
      }
      
      private function getPurchaseWithEquipFunction() : Boolean
      {
         return this._purchaseWithEquipFunction;
      }
      
      private function isMarketplaceInMaintain() : Boolean
      {
         var isMaintain:Boolean = CFunctionCommonContainer.IsMarketplaceInMaintain() as Boolean;
         var isMaintainWhitelist:Boolean = CFunctionCommonContainer.AS_IsWhitelistTester() as Boolean;
         if(isMaintain && isMaintainWhitelist)
         {
            isMaintain = false;
         }
         return isMaintain;
      }
      
      private function isRealMarketplaceInMaintain() : Boolean
      {
         return CFunctionCommonContainer.IsMarketplaceInMaintain() as Boolean;
      }
      
      private function isMarketplaceReady() : Boolean
      {
         return CFunctionCommonContainer.IsMarketplaceReady() as Boolean;
      }
      
      private function isPlayerDataReady() : Boolean
      {
         return CFunctionCommonContainer.IsPlayerdataReady() as Boolean;
      }
      
      private function isDataAvailable() : Boolean
      {
         return this.isMarketplaceReady() && this.isPlayerDataReady() && !this.isMarketplaceInMaintain();
      }
      
      private function isWeaponDataAvailable() : Boolean
      {
         return CFunctionCommonContainer.IsWeaponDataReady() as Boolean;
      }
      
      private function getMarketplaceUpdateState() : int
      {
         return CFunctionCommonContainer.GetMktUpdateState() as int;
      }
      
      private function onBuyTokenBase(tokenID:int) : void
      {
         var prodObj:ProductObj = CFunctionCommonContainer.GetItemInfo(tokenID);
         broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prodObj});
      }
      
      private function onBuyToken(cEvt:ParaEvent) : void
      {
         var tokenID:int = CFunctionCommonContainer.GetReviveTokenID();
         this.onBuyTokenBase(tokenID);
      }
      
      private function updateSupplyDropCount() : void
      {
         var numBasic:int = CFunctionCommonContainer.GetInventoryCount("supply_basic");
         var numAdv:int = CFunctionCommonContainer.GetInventoryCount("supply_advanced");
         var numEvent:int = CFunctionCommonContainer.GetInventoryCount("supply_limited");
         setBindData(DataID.SUPPLY_DROP_COUNT,{
            "basic":numBasic,
            "adv":numAdv,
            "event":numEvent,
            "total":numBasic + numAdv + numEvent
         });
      }
      
      private function showExpirePopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART,{"expiredItems":cEvt.myPara});
      }
      
      private function wantShowWarGodChallengeReward(cEvt:ParaEvent) : void
      {
         var rewards:Array = null;
         var i:int = 0;
         if(cEvt.myPara is Array)
         {
            rewards = cEvt.myPara as Array;
            for(i = 0; i < rewards.length; i++)
            {
               this.m_pendingWarGodRewards.push(cEvt.myPara[i]);
            }
         }
      }
      
      private function notForSaleActionHandler(evt:ParaEvent) : void
      {
         var ret:Object = null;
         var playlistNum:int = 0;
         var playlistObj:PlayListObj = null;
         var pageJumpEvt:String = null;
         var product:ProductObj = evt.myPara as ProductObj;
         var notForSaleObj:NotForSaleObj = product.notForSaleObj;
         if(null == notForSaleObj)
         {
            return;
         }
         if(notForSaleObj.type == NotForSaleObj.NOT_FOR_SALE_TYPE_OTH)
         {
            showMsg(notForSaleObj.message,MsgBtnCount.ONE);
         }
         else if(notForSaleObj.type == NotForSaleObj.NOT_FOR_SALE_TYPE_EVT)
         {
            ret = CFunctionCommonContainer.OpenWebPageCustom(notForSaleObj.url,WebImgData.NOTFORSALE_EVT.x,WebImgData.NOTFORSALE_EVT.y,WebImgData.NOTFORSALE_EVT.width,WebImgData.NOTFORSALE_EVT.height) as Object;
            if(Boolean(ret.succeed))
            {
               broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
                  "data":WebImgData.NOTFORSALE_EVT,
                  "hideTitle":true
               });
            }
         }
         else if(notForSaleObj.type == NotForSaleObj.NOT_FOR_SALE_TYPE_PVP || notForSaleObj.type == NotForSaleObj.NOT_FOR_SALE_TYPE_PVE)
         {
            playlistNum = CFunctionContainer.AS_GetPlayListNumForId(notForSaleObj.playlist);
            playlistObj = getDP(DataID.PLAY_LIST_OBJ,[playlistNum]);
            if(Boolean(playlistObj))
            {
               if(PlayListType.isPveType(playlistObj.type))
               {
                  pageJumpEvt = BCEvent.EVT_GOTO_MAIN_PVE;
               }
               else
               {
                  if(playlistObj.isBattleCityMode())
                  {
                     pageJumpEvt = BCEvent.EVT_GOTO_MAIN_BATTLECITY;
                  }
                  if(getDP(DataID.WARGOD_GLOBAL_SETTING).playlistId == notForSaleObj.playlist)
                  {
                     pageJumpEvt = BCEvent.EVT_GOTO_MAIN_WARGOD;
                  }
                  else
                  {
                     pageJumpEvt = BCEvent.EVT_GOTO_MAIN_PVP;
                  }
               }
               broadcast(pageJumpEvt,{"playlist":playlistObj});
            }
         }
      }
      
      private function showRecommendedLoadoutPurchaseRemainderItemsPopup(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_RECOMMENDED_LOADOUT_PURCHASE_REMAINDER_ITEMS,cEvt.myPara);
      }
      
      private function updateCraftingShardCount() : void
      {
         setBindData(DataID.CRAFTING_SHARD_COUNT,CFunctionCommonContainer.GetInventoryCount("currency_shard"));
      }
      
      private function getCraftingShardCount() : int
      {
         return CFunctionCommonContainer.GetInventoryCount("currency_shard");
      }
      
      override protected function onBuyAsymRobot(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_ASYM_PURCHASE,cEvt.myPara);
      }
      
      override protected function onCancelBuyAsymRobot(cEvt:ParaEvent) : void
      {
         closePopupPage(PageID.ASYM_PURCHASE_POPUP);
      }
      
      protected function onMarketShowDetails(cEvt:ParaEvent) : void
      {
         var prod:ProductObj = null;
         if(this.isDataAvailable())
         {
            prod = cEvt.myPara.itemData;
            if(prod.fullscreenDetailsEnabled())
            {
               gotoPage(CodoPageViewDB.PAGE_MARKET_ITEM_DETAILS,cEvt.myPara);
            }
            else if(prod.type != ItemType.BUNDLE || prod.group == MarketMenuData.GRP_OUTFIT || prod.group == MarketMenuData.GRP_SUPPLY_DROP_BUNDLE)
            {
               gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART,cEvt.myPara);
            }
            else
            {
               gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_BUNDLE_ADD_TO_CART,cEvt.myPara);
            }
            TLogUtil.TLog_Onboarding(TLogUtil.ONBOARD_VIEW_ITEM,prod.id,prod.isOwned() ? 1 : 0);
         }
         else
         {
            showMsg(Dict.DW_MARKETPLACE_MAINTAIN,MsgBtnCount.ONE,SystemMsgPriority.ERROR);
         }
      }
      
      private function onMarketTryGiftHandle(cEvt:ParaEvent) : void
      {
         this.showPurchaseGiftConfirm(cEvt.myPara.data);
      }
      
      private function onInventoryTryGiftHandle(cEvt:ParaEvent) : void
      {
         this.showPurchaseGiftConfirm(cEvt.myPara.data);
      }
      
      private function onInventoryTrySendCouponHandle(cEvt:ParaEvent) : void
      {
         this.showPurchaseGiftConfirm(cEvt.myPara.data);
      }
      
      private function onInventoryChangeHandle(cEvt:ParaEvent) : void
      {
         this.onGetRecommendItems();
         this.updateSupplyDropCount();
         this.updateCraftingShardCount();
         CFunctionContainer.MKT_InvalidatePreviewList();
      }
      
      private function showPurchaseGiftConfirm(data:Object) : void
      {
      }
      
      private function refreshExpirationPopup() : void
      {
         Logger.print("MarketplaceController::refreshExpirationPopup");
         if(Boolean(getDP(DataID.HAS_POPUP) || getDP(DataID.IS_SYSTEM_MSG_SHOWING) || CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null) || Boolean(!CFunctionCommonContainer.IsMarketplaceReady()) || UITutorialBaseView.isTutorialShowing())
         {
            this._belatedInventoryUpdateTimer.reset();
            this._belatedInventoryUpdateTimer.delay = this.INVENTORY_UPDATE_RETRY_DELAY;
            this._belatedInventoryUpdateTimer.start();
            Logger.print("\tSKIP HAS_POPUP: " + getDP(DataID.HAS_POPUP) + ", IS_SYSTEM_MSG_SHOWING: " + getDP(DataID.IS_SYSTEM_MSG_SHOWING) + ", PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP: " + CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj + ", IsMarketplaceReady: " + CFunctionCommonContainer.IsMarketplaceReady());
            return;
         }
         broadcast(BCEvent.EVT_UPDATE_EXPIRATION);
         CFunctionContainer.AS_ScanForPromptingExpiration();
      }
      
      private function bind_popUpExpiredItems(cRes:Object) : void
      {
         var expiredItem:* = undefined;
         var id:int = 0;
         var expired:Object = null;
         var itemObject:ProductObj = null;
         var iPiece:int = 0;
         var bundlePiece:Object = null;
         var alreadyExistInRenewableList:Boolean = false;
         var existRenewableItem:ProductObj = null;
         var expiredItems:Array = cRes.data;
         var renewableItems:Vector.<ProductObj> = new Vector.<ProductObj>();
         var expiryLastChecked:uint = 0;
         for each(expiredItem in expiredItems)
         {
            id = int(expiredItem.id);
            if(Boolean(expiredItem.bundle))
            {
               expired = CFunctionCommonContainer.GetBundleInfo(id);
               for(iPiece = 0; iPiece < expired.itemsList.length; iPiece++)
               {
                  bundlePiece = expired.itemsList[iPiece];
                  CFunctionContainer.AS_UnequipItemByIDFromAllCharacterLoadouts(bundlePiece.id);
               }
            }
            else
            {
               expired = CFunctionCommonContainer.GetItemInfo(id);
               CFunctionContainer.AS_UnequipItemByIDFromAllCharacterLoadouts(id);
            }
            itemObject = new ProductObj(expired);
            if(itemObject != null && itemObject.expireDateTime != uint.MAX_VALUE && expiryLastChecked < itemObject.expireDateTime)
            {
               expiryLastChecked = itemObject.expireDateTime;
            }
            if(itemObject.name != "")
            {
               if(itemObject.skuTypes != ProductObj.SKU_FUTURE_TIME && !itemObject.bHideFromMarket || (itemObject.skuTypes & ProductObj.SKU_RANDOM_REWARD) > 0 || itemObject.type == "cha" && itemObject.group == "cha")
               {
                  CFunctionCommonContainer.AS_SetupAndReturnMinSkus(itemObject);
                  alreadyExistInRenewableList = false;
                  for each(existRenewableItem in renewableItems)
                  {
                     if(existRenewableItem.id == itemObject.id)
                     {
                        alreadyExistInRenewableList = true;
                     }
                  }
                  if(!alreadyExistInRenewableList)
                  {
                     renewableItems.push(itemObject);
                  }
               }
            }
         }
         if(renewableItems.length > 0)
         {
            this.sendExpireNotificationAsMail(renewableItems);
            CFunctionContainer.AS_SetExpiryPopUpLastCheckedTimestamp(expiryLastChecked);
            this.onProcessExpiredItem();
         }
         else
         {
            broadcast(BCEvent.EVT_PROCESS_NOTHING_EXPIRED);
         }
      }
      
      private function sendExpireNotificationAsMail(renewableItems:Vector.<ProductObj>) : void
      {
         var mailObj:InvitationObj = new InvitationObj();
         mailObj.title = DictMail.NEW_EXPIRE_NOTIFICATION_LABEL;
         mailObj.message = DictMail.NEW_EXPIRE_NOTIFICATION_CONTENT;
         mailObj.targetName = DictAAS.AAS_SYSTEM;
         mailObj.senderName = DictAAS.AAS_SYSTEM;
         mailObj.formattedTime = TimeUtil.now();
         mailObj.type = InvitationType.EXPIRE_MESSAGE;
         mailObj.isLog = true;
         mailObj.renewableItems = renewableItems;
         mailObj.isAlerted = true;
         broadcast(BCEvent.ADD_NEW_INVITATION,mailObj);
      }
      
      private function bind_demonwareMarketplaceStatusChange(cRes:Object) : void
      {
         var data:* = undefined;
         for each(data in cRes.data)
         {
            if(data.name == "marketplace" && data.status == DWServiceStatus.UNRESPONSIVE)
            {
               Logger.print("MarketController::bind_demonwareMarketplaceStatusChange: UNRESPONSIVE - timestamp: " + data.timestamp + "\n");
            }
         }
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         var dataAvailable:Boolean = false;
         var dataWeaponAvailable:Boolean = false;
         Logger.print("MarketController:::bind_dataReceived success: " + cRes.result + ", data: " + cRes.data);
         if(cRes.result == 1 && (cRes.data == Common.MARKET_RECEIVED || cRes.data == Common.PLAYERDATA_RECEIVED))
         {
            dataAvailable = MarketService.getInstance().isGameDataReady();
            broadcast(BCEvent.EVT_GAME_DATA_STATE_CHANGE,dataAvailable);
         }
         if(cRes.data == Common.WEAPONS_RECEIVED)
         {
            dataWeaponAvailable = CFunctionCommonContainer.IsWeaponDataReady() as Boolean;
            broadcast(BCEvent.EVT_WEAPON_DATA_READY,dataWeaponAvailable);
         }
         this.tryUpdatePromoData();
         this.tryUpdateOnboardingRewardCoupon();
      }
      
      private function updateOnboardingRewardCouponHandler(event:TimerEvent) : void
      {
         this.tryUpdateOnboardingRewardCoupon();
      }
      
      private function tryUpdateOnboardingRewardCoupon() : void
      {
         var isMktDataReady:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         if(isMktDataReady)
         {
            CFunctionContainer.MKT_UpdateOnboardingPendingCoupon();
         }
      }
      
      private function tryUpdatePromoData() : void
      {
         var isMktDataReady:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         if(isMktDataReady)
         {
            this.resetFeaturedItemObtainedState();
            this.broadcast(BCEvent.EVT_NOTIFY_START_REQUEST_PROMO_DATA);
         }
      }
      
      private function onPageChangedHandle(cEvt:ParaEvent) : void
      {
         var claimRewards:Array = null;
         var currentPageObj:Object = cEvt.myPara.pageObj;
         if(ScaleformUtil.isScaleform == true)
         {
            if(currentPageObj == CodoPageViewDB.PAGE_HOME || currentPageObj == CodoPageViewDB.PAGE_MAIN_IN_ROOM)
            {
               claimRewards = CFunctionContainer.TencentClaimRewards();
               if(claimRewards != null && claimRewards.length > 0)
               {
                  Logger.print("MarketController::onPageChangedHandle claim reward:" + claimRewards.length);
                  broadcast(BCEvent.EVT_GOTO_SHOW_CLAIMREWARDS,claimRewards);
               }
            }
         }
      }
      
      private function getItemDataByID(cID:int) : Object
      {
         return MarketService.getInstance().getItemInfoObj(cID);
      }
      
      private function getItemIDByName(cName:String) : Object
      {
         return MarketService.getInstance().getItemIDByName(cName);
      }
      
      private function getMarketShoppingCartList() : Array
      {
         return CFunctionContainer.MKT_GetCartItemList();
      }
      
      private function onEnterFirstPage(cEvt:ParaEvent = null) : void
      {
         this.onUpdateHomepageItems(cEvt);
         this.m_intervalCheckTimer.start();
         this.intervalCheckTicked(null);
      }
      
      private function intervalCheckTicked(cEvt:TimerEvent) : void
      {
         var claimRewards:Array = null;
         var systemMsgShowing:Boolean = getDP(DataID.IS_SYSTEM_MSG_SHOWING) as Boolean;
         if(!systemMsgShowing)
         {
            claimRewards = CFunctionContainer.TencentClaimRewards();
            this.filterWarGodReward(claimRewards);
            if(claimRewards != null && claimRewards.length > 0)
            {
               Logger.print("Receive Tencent Rewards: ",claimRewards.length);
               broadcast(BCEvent.EVT_GOTO_SHOW_CLAIMREWARDS,claimRewards);
            }
            if(this.canShowWarGodReward())
            {
               broadcast(BCEvent.EVT_GOTO_SHOW_CLAIMREWARDS,this.m_pendingWarGodRewards);
               this.m_pendingWarGodRewards.splice(0,this.m_pendingWarGodRewards.length);
            }
         }
         var info:Object = CFunctionContainer.GetMarketMaintainInfo();
         if(Boolean(info))
         {
            broadcast(BCEvent.EVT_SHOW_MKT_MAINTAIN_MSG,info);
         }
      }
      
      private function filterWarGodReward(rawRewards:Array) : void
      {
         var reward:Object = null;
         if(rawRewards == null)
         {
            return;
         }
         for(var i:int = rawRewards.length - 1; i >= 0; i--)
         {
            reward = rawRewards[i];
            if(reward.type == WarGodSeasonEndRewardObj.CHALLENGE_REWARD)
            {
               rawRewards.splice(i,1);
               this.m_pendingWarGodRewards.push(reward);
            }
         }
      }
      
      private function canShowWarGodReward() : Boolean
      {
         if(getDP(DataID.CURRENT_BACKGROUND_POPUP_PAGE_ID) == PageID.FSG_MATCHRESULT)
         {
            return false;
         }
         if(this.m_pendingWarGodRewards.length <= 0)
         {
            return false;
         }
         return true;
      }
      
      private function onUpdateHomepageItems(cEvt:ParaEvent = null) : void
      {
         this.onGetRecommendItems();
      }
      
      private function concatUniqueItems(srcItemArray:Array, toConcatItemArray:Array) : Array
      {
         var concatItem:* = undefined;
         var srcItem:* = undefined;
         var duplicate:Boolean = false;
         for each(concatItem in toConcatItemArray)
         {
            duplicate = false;
            for each(srcItem in srcItemArray)
            {
               if(srcItem.id == concatItem.id)
               {
                  duplicate = true;
                  break;
               }
            }
            if(!duplicate)
            {
               srcItemArray.unshift(concatItem);
            }
         }
         return srcItemArray;
      }
      
      private function onGetRecommendItems(cEvt:ParaEvent = null) : void
      {
         var i:int = 0;
         var item:* = undefined;
         var productID:int = 0;
         var bundleInfo:Object = null;
         var itemInfo:Object = null;
         if(!getDP(DataID.IS_DATA_AVAILABLE))
         {
            return;
         }
         var recommendItems:Array = [];
         if(this.m_obtainedRecommendedItemsForThisSession)
         {
            for each(item in this.m_cachedRecommendedItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  bundleInfo = CFunctionCommonContainer.GetBundleInfo(productID);
                  bundleInfo.tagOrder = item.tagOrder;
                  recommendItems.push(bundleInfo);
               }
               else
               {
                  itemInfo = CFunctionCommonContainer.GetItemInfo(productID);
                  itemInfo.tagOrder = item.tagOrder;
                  recommendItems.push(itemInfo);
               }
            }
         }
         else
         {
            this.m_cachedRecommendedItems = [];
            if(ScaleformUtil.isScaleform)
            {
               recommendItems = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_RECOMMEND);
            }
            else
            {
               for(i = 0; i < 6; i++)
               {
                  recommendItems.push({
                     "id":i,
                     "nameid":"item_" + i,
                     "name":"Item " + i,
                     "description":"desc desc desc desc desc desc desc desc",
                     "properties":[{
                        "key":"ATK",
                        "val":Math.floor(Math.random() * 50 + 50)
                     },{
                        "key":"DEF",
                        "val":Math.floor(Math.random() * 50 + 50)
                     },{
                        "key":"DEX",
                        "val":Math.floor(Math.random() * 50 + 50)
                     },{
                        "key":"SPD",
                        "val":Math.floor(Math.random() * 50 + 50)
                     }],
                     "imageURL":"test_url",
                     "purchasable":true,
                     "isCoupon":true,
                     "type":"CAT",
                     "SKUs":[{
                        "name":"7",
                        "duration":7,
                        "price":25,
                        "currency":"CP"
                     },{
                        "name":"30",
                        "duration":30,
                        "price":150,
                        "currency":"CC"
                     },{
                        "name":"90",
                        "duration":90,
                        "price":2500,
                        "currency":"CP"
                     }],
                     "currentSKUIndex":0,
                     "equippable":Math.random() * 2 > 1,
                     "cantEquippableReasonList":[Math.random() * 2 > 1],
                     "level":12,
                     "currentExp":60,
                     "totalExp":100,
                     "requirementLevel":1,
                     "requirementChallenge":""
                  });
               }
            }
            if(recommendItems != null)
            {
               recommendItems.sortOn(["tagOrder"],[Array.NUMERIC]);
            }
            if(this.m_obtainedPromoRecommendedItems == false)
            {
               this.m_cachedPromoRecommendedItems = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_RECOMMEND);
               this.m_obtainedPromoRecommendedItems = true;
            }
            recommendItems = this.concatUniqueItems(recommendItems,this.m_cachedPromoRecommendedItems);
            this.m_cachedRecommendedItems = this.concatUniqueItems(this.m_cachedRecommendedItems,recommendItems);
            this.m_obtainedRecommendedItemsForThisSession = true;
         }
         if(recommendItems != null)
         {
            recommendItems.sortOn(["tagOrder"],[Array.NUMERIC]);
            this._recommendedItems = recommendItems;
            setBindData(DataID.HOMEPAGE_MARKET_RECOMMEND_ITEM,recommendItems);
         }
      }
      
      public function getRecommendedItems() : Array
      {
         return this._recommendedItems;
      }
      
      private function onGetTopSellerItems(cEvt:ParaEvent) : void
      {
         var itemNum:int;
         var result:Array;
         var item:* = undefined;
         var productID:int = 0;
         var bundleInfo:Object = null;
         var itemInfo:Object = null;
         var unsortedItemList:Array = null;
         var filterFunc:Function = null;
         if(!getDP(DataID.IS_DATA_AVAILABLE))
         {
            return;
         }
         itemNum = int(cEvt.myPara.itemNum);
         result = new Array();
         if(this.m_obtainedTopSellerItemsForThisSession == true)
         {
            for each(item in this.m_cachedTopSellerItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  bundleInfo = CFunctionCommonContainer.GetBundleInfo(productID);
                  bundleInfo.tagOrder = item.tagOrder;
                  result.push(bundleInfo);
               }
               else
               {
                  itemInfo = CFunctionCommonContainer.GetItemInfo(productID);
                  itemInfo.tagOrder = item.tagOrder;
                  result.push(itemInfo);
               }
            }
         }
         else
         {
            this.m_cachedTopSellerItems = [];
            if(ScaleformUtil.isScaleform)
            {
               if(Boolean(cEvt.myPara.isRoot))
               {
                  unsortedItemList = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_HOT);
               }
               else
               {
                  unsortedItemList = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_HOT);
                  if(unsortedItemList != null)
                  {
                     filterFunc = function(item:*, index:int, arr:Array):Boolean
                     {
                        return !(Boolean(item.enableInZombie) && !item.enableInTF141 && !item.enableInSC);
                     };
                     unsortedItemList.filter(filterFunc,this);
                  }
               }
               if(unsortedItemList != null)
               {
                  unsortedItemList.sortOn(["tagOrder"],[Array.NUMERIC]);
                  result = result.concat(unsortedItemList);
               }
               if(this.m_obtainedPromoHotItems == false)
               {
                  this.m_cachedPromoHotItems = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_HOT);
                  this.m_obtainedPromoHotItems = true;
               }
            }
            else
            {
               MarketService.getInstance().fillFakeListData(result);
            }
            this.m_obtainedTopSellerItemsForThisSession = true;
            this.m_cachedTopSellerItems = this.concatUniqueItems(this.m_cachedTopSellerItems,result);
         }
         itemNum = int(result.length);
         result.sortOn(["tagOrder"],[Array.NUMERIC]);
         setBindData(DataID.MARKET_TOP_SELLERS,result);
      }
      
      private function onGetNewItems(cEvt:ParaEvent) : void
      {
         var newItemArray:Array = null;
         var item:* = undefined;
         var productID:int = 0;
         var bundleInfo:Object = null;
         var itemInfo:Object = null;
         var unsortedItemList:Array = null;
         if(!getDP(DataID.IS_DATA_AVAILABLE))
         {
            return;
         }
         var result:Array = new Array();
         var itemNum:int = 0;
         if(this.m_obtainedNewItemsForThisSession)
         {
            newItemArray = MarketService.getInstance().getNewItems();
            for each(item in newItemArray)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  bundleInfo = CFunctionCommonContainer.GetBundleInfo(productID);
                  bundleInfo.tagOrder = item.tagOrder;
                  result.push(bundleInfo);
               }
               else
               {
                  itemInfo = CFunctionCommonContainer.GetItemInfo(productID);
                  itemInfo.tagOrder = item.tagOrder;
                  result.push(itemInfo);
               }
            }
         }
         else
         {
            if(ScaleformUtil.isScaleform)
            {
               unsortedItemList = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_NEW);
               if(unsortedItemList != null)
               {
                  unsortedItemList.sortOn(["tagOrder"],[Array.NUMERIC]);
                  result = result.concat(unsortedItemList);
               }
            }
            else
            {
               MarketService.getInstance().fillFakeListData(result);
            }
            if(this.m_obtainedPromoNewItems == false)
            {
               this.m_cachedPromoNewItems = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_NEW);
               this.m_obtainedPromoNewItems = true;
            }
            result = this.concatUniqueItems(result,this.m_cachedPromoNewItems);
            MarketService.getInstance().registerNewItems(result);
            this.m_obtainedNewItemsForThisSession = true;
         }
         itemNum = int(result.length);
         result.sortOn(["tagOrder"],[Array.NUMERIC]);
         setBindData(DataID.MARKET_NEW_SELLERS,result);
      }
      
      private function onGetPopularItems(cEvt:ParaEvent) : void
      {
         var item:* = undefined;
         var productID:int = 0;
         var bundleInfo:Object = null;
         var itemInfo:Object = null;
         var unsortedItemList:Array = null;
         if(!getDP(DataID.IS_DATA_AVAILABLE))
         {
            return;
         }
         var itemNum:int = 0;
         var result:Array = new Array();
         if(this.m_obtainedPopularItemsForThisSession)
         {
            for each(item in this.m_cachedPopularItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  bundleInfo = CFunctionCommonContainer.GetBundleInfo(productID);
                  bundleInfo.tagOrder = item.tagOrder;
                  result.push(bundleInfo);
               }
               else
               {
                  itemInfo = CFunctionCommonContainer.GetItemInfo(productID);
                  itemInfo.tagOrder = item.tagOrder;
                  result.push(itemInfo);
               }
            }
         }
         else
         {
            this.m_cachedPopularItems = [];
            if(ScaleformUtil.isScaleform)
            {
               unsortedItemList = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_POPULAR);
               if(unsortedItemList != null)
               {
                  unsortedItemList.sortOn(["tagOrder"],[Array.NUMERIC]);
                  result = result.concat(unsortedItemList);
               }
            }
            else
            {
               MarketService.getInstance().fillFakeListData(result);
            }
            if(this.m_obtainedPromoPopularItems == false)
            {
               this.m_cachedPromoPopularItems = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_POPULAR);
               this.m_obtainedPromoPopularItems = true;
            }
            result = this.concatUniqueItems(result,this.m_cachedPromoPopularItems);
            this.m_cachedPopularItems = this.concatUniqueItems(this.m_cachedPopularItems,result);
            this.m_obtainedPopularItemsForThisSession = true;
         }
         itemNum = int(result.length);
         result.sortOn(["tagOrder"],[Array.NUMERIC]);
         setBindData(DataID.MARKET_POPULAR_ITEMS,result);
      }
      
      private function onGetPromoHotItems(cEvt:ParaEvent) : void
      {
         var item:* = undefined;
         var productID:int = 0;
         var result:Array = new Array();
         if(this.m_obtainedPromoHotItems)
         {
            for each(item in this.m_cachedPromoHotItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  result.push(CFunctionCommonContainer.GetBundleInfo(productID));
               }
               else
               {
                  result.push(CFunctionCommonContainer.GetItemInfo(productID));
               }
            }
         }
         else
         {
            result = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_HOT);
            this.m_cachedPromoHotItems = this.concatUniqueItems(this.m_cachedPromoHotItems,result);
            this.m_obtainedPromoHotItems = true;
         }
         setBindData(DataID.MARKET_PROMO_HOT_ITEMS,result);
      }
      
      private function onGetPromoNewItems(cEvt:ParaEvent) : void
      {
         var item:* = undefined;
         var productID:int = 0;
         var result:Array = new Array();
         if(this.m_obtainedPromoNewItems)
         {
            for each(item in this.m_cachedPromoNewItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  result.push(CFunctionCommonContainer.GetBundleInfo(productID));
               }
               else
               {
                  result.push(CFunctionCommonContainer.GetItemInfo(productID));
               }
            }
         }
         else
         {
            result = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_NEW);
            this.m_cachedPromoNewItems = this.concatUniqueItems(this.m_cachedPromoNewItems,result);
            this.m_obtainedPromoNewItems = true;
         }
         setBindData(DataID.MARKET_PROMO_NEW_ITEMS,result);
      }
      
      private function onGetPromoPopularItems(cEvt:ParaEvent) : void
      {
         var item:* = undefined;
         var productID:int = 0;
         var result:Array = new Array();
         if(this.m_obtainedPromoPopularItems)
         {
            for each(item in this.m_cachedPromoPopularItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  result.push(CFunctionCommonContainer.GetBundleInfo(productID));
               }
               else
               {
                  result.push(CFunctionCommonContainer.GetItemInfo(productID));
               }
            }
         }
         else
         {
            result = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_POPULAR);
            this.m_cachedPromoPopularItems = this.concatUniqueItems(this.m_cachedPromoPopularItems,result);
            this.m_obtainedPromoPopularItems = true;
         }
         setBindData(DataID.MARKET_PROMO_POPULAR_ITEMS,result);
      }
      
      private function onGetPromoRecommendedItems(cEvt:ParaEvent) : void
      {
         var item:* = undefined;
         var productID:int = 0;
         var result:Array = new Array();
         if(this.m_obtainedPromoRecommendedItems)
         {
            for each(item in this.m_cachedPromoRecommendedItems)
            {
               productID = int(item.id);
               if(item.group == MarketMenuData.GRP_OUTFIT || item.group == MarketMenuData.GRP_GIFTBOX)
               {
                  result.push(CFunctionCommonContainer.GetBundleInfo(productID));
               }
               else
               {
                  result.push(CFunctionCommonContainer.GetItemInfo(productID));
               }
            }
         }
         else
         {
            result = MarketService.getInstance().GetProductListByTag(Common.SKU_TAG_AD_RECOMMEND);
            this.m_cachedPromoRecommendedItems = this.concatUniqueItems(this.m_cachedPromoRecommendedItems,result);
            this.m_obtainedPromoRecommendedItems = true;
         }
         setBindData(DataID.MARKET_PROMO_RECOMMENDED_ITEMS,result);
      }
      
      private function onProcessNothingExpired() : void
      {
         this._belatedInventoryUpdateTimer.reset();
         this._belatedInventoryUpdateTimer.delay = this.INVENTORY_UPDATE_PERIODIC;
         this._belatedInventoryUpdateTimer.start();
      }
      
      private function onProcessExpiredItem() : void
      {
         this._belatedInventoryUpdateTimer.reset();
         this._belatedInventoryUpdateTimer.delay = 1000;
         this._belatedInventoryUpdateTimer.start();
         var weaponLoadoutService:WeaponLoadoutService = WeaponLoadoutService.getInstance();
         var targetWeaponType:String = "primary";
         var currentWeaponLoadoutIndex:int = weaponLoadoutService.currentWeaponLoadoutIndex;
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) != PageID.MARKET_ITEM_DETAILS)
         {
            CFunctionContainer.WL_PreviewWeaponResetLoadoutSlot(currentWeaponLoadoutIndex,targetWeaponType);
         }
         CFunctionContainer.CL_RefreshCurrentCharacter();
         weaponLoadoutService.requestWeaponLoadout();
         setBindData(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,CFunctionContainer.CL_GetCurrentCharacterID());
         broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
      }
      
      override protected function onMarketPurchaseConfirmBuyHandle(cEvt:ParaEvent) : void
      {
         this._pendingPurchaseItem = cEvt.myPara.item;
         this._pendingItemToEquip = Boolean(cEvt.myPara.equip) ? this._pendingPurchaseItem : null;
         var itemNum:int = 1;
         if(Boolean(cEvt.myPara.hasOwnProperty("itemNum")))
         {
            itemNum = int(cEvt.myPara.itemNum);
         }
         var disableFeedback:Boolean = false;
         if(Boolean(cEvt.myPara.hasOwnProperty("disableFeedback")) && Boolean(cEvt.myPara.disableFeedback))
         {
            disableFeedback = true;
         }
         request(DataID.MARKET_BUY,{
            "item":cEvt.myPara.item,
            "itemNum":itemNum,
            "isShoppingCart":false,
            "disableFeedback":disableFeedback
         },this.onBuyCompleteHandle);
         m_closePurchasePopupOnComplete = cEvt.myPara.closeAfterPurchase == null ? true : Boolean(cEvt.myPara.closeAfterPurchase);
      }
      
      override protected function onMarketPurchaseConfirmBuySKUListHandle(cEvt:ParaEvent) : void
      {
         request(DataID.MARKET_BUY,cEvt.myPara.SKUs,this.onBuyCompleteHandle);
         m_closePurchasePopupOnComplete = cEvt.myPara.closeAfterPurchase == null ? true : Boolean(cEvt.myPara.closeAfterPurchase);
      }
      
      override protected function onMarketPurchasePopupHandle(cEvt:ParaEvent) : void
      {
         var prod:ProductObj = null;
         if(this.isDataAvailable())
         {
            prod = cEvt.myPara.itemData;
            if(prod.type != ItemType.BUNDLE || prod.group == MarketMenuData.GRP_OUTFIT || prod.group == MarketMenuData.GRP_SUPPLY_DROP_BUNDLE)
            {
               gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART,cEvt.myPara);
            }
            else
            {
               gotoPage(CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_BUNDLE_ADD_TO_CART,cEvt.myPara);
            }
            TLogUtil.TLog_Onboarding(TLogUtil.ONBOARD_VIEW_ITEM,prod.id,prod.isOwned() ? 1 : 0);
         }
         else
         {
            showMsg(Dict.DW_MARKETPLACE_MAINTAIN,MsgBtnCount.ONE,SystemMsgPriority.ERROR);
         }
      }
      
      override protected function onMarketAddToCartConfirmHandle(cEvt:ParaEvent) : void
      {
         var sku:SKUObj = cEvt.myPara.sku as SKUObj;
         CFunctionContainer.MKT_AddToCart(sku.id);
      }
      
      override protected function onMarketRemoveFromCartHandle(cEvt:ParaEvent) : void
      {
         var sku:SKUObj = cEvt.myPara.sku as SKUObj;
         CFunctionContainer.MKT_RemoveFromCart(sku.id);
      }
      
      override protected function onMarketClearCartHandle(cEvt:ParaEvent) : void
      {
         CFunctionContainer.MKT_ClearShoppingCart();
      }
      
      override protected function onMarketPurchaseCartHandle(cEvt:ParaEvent) : void
      {
         this.showMsg(Dict.PURCHASE_IN_PROGRESS);
         CFunctionContainer.MKT_BuyCart(cEvt.myPara);
      }
      
      private function onMarketGoToCartHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_SHOPPING_CART,cEvt.myPara);
      }
      
      override protected function onMarketEquipCompletedPurchaseHandle(cEvt:ParaEvent) : void
      {
         this.equipPendingItem();
         broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
         closePopupPage(PageID.MARKET_PURCHASE_CONFIRM);
         broadcast(BCEvent.GOTO_PREV_PAGE);
      }
      
      private function onPurchaseConfirmBuyAndEquip(cEvt:ParaEvent) : void
      {
         this._pendingItemToEquip = cEvt.myPara.item;
         request(DataID.MARKET_BUY,{
            "item":cEvt.myPara.item,
            "isShoppingCart":false
         },this.onBuyCompleteHandle);
         m_closePurchasePopupOnComplete = cEvt.myPara.closeAfterPurchase == null ? true : Boolean(cEvt.myPara.closeAfterPurchase);
      }
      
      override protected function refreshInventoryWhenBuy() : void
      {
         request(DataID.MARKET_UPDATE_INVENTORY,null,this.onBuyItemWhenInventoryUpdated);
      }
      
      override protected function onBuyCompleteHandle(cResult:ResultObj) : void
      {
         m_dax_button_name = this._pendingItemToEquip == null ? "buy" : "buy_and_equip";
         super.onBuyCompleteHandle(cResult);
      }
      
      override protected function closePageOnPurchaseComplete() : void
      {
         var newPopup:CodoPageObj = CodoPageViewDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART;
         if(newPopup.owner.currentPageObj == newPopup)
         {
            closePopupPage(newPopup.id);
            return;
         }
         if(getDP(DataID.CURRENT_MAIN_PAGE_ID) == PageID.MARKET_ITEM_DETAILS)
         {
            hideMsg();
            prevPage();
            return;
         }
      }
      
      override protected function showPurchaseSuccess() : void
      {
      }
      
      private function equipPendingItem() : void
      {
         if(this._pendingItemToEquip == null)
         {
            return;
         }
         if(this._pendingItemToEquip.group == "cnc")
         {
            return;
         }
         this._pendingItemToEquip = this._pendingItemToEquip.group == MarketMenuData.GRP_OUTFIT || this._pendingItemToEquip.group == MarketMenuData.GRP_LOADOUT_BUNDLE ? CFunctionCommonContainer.GetBundleInfo(this._pendingItemToEquip.id) : CFunctionCommonContainer.GetItemInfo(this._pendingItemToEquip.id);
         if(this._pendingItemToEquip != null && Boolean(this._pendingItemToEquip.showBreadcrumb))
         {
            UiCppNewItems.instance.ClearNew(this._pendingItemToEquip as ProductObj);
         }
         if(this._pendingItemToEquip.group != "cha")
         {
            broadcast(BCEvent.EVT_EQUIP,{"item":this._pendingItemToEquip});
         }
         else
         {
            broadcast(BCEvent.EVT_SET_DEFAULT_CHARACTER,{"character":this._pendingItemToEquip});
            broadcast(BCEvent.EVT_REFRESH_WEAPONLOADOUT_AND_LIST);
            broadcast(BCEvent.EVT_WEAPONLOADOUT_CHANGED,{"index":0});
         }
         this._pendingItemToEquip = null;
      }
      
      private function onEvtUpdateInventory(cEvt:ParaEvent) : void
      {
         request(DataID.MARKET_UPDATE_INVENTORY,null,this.onUpdateInventoryCompleteHandle);
      }
      
      private function onEvtChangeNamePopup(cEvt:ParaEvent) : void
      {
         if(!this.getDP(DataID.IS_IN_PARTY))
         {
            this.gotoPage(CodoPageViewDB.PAGE_CHANGE_NAME,cEvt.myPara);
         }
         else
         {
            this.showMsg(Dict.IN_PARTY_CANNOT_CHANGE_NAME,MsgBtnCount.ONE);
         }
      }
      
      private function onCancelChangeName(cEvt:ParaEvent) : void
      {
         this.prevPage();
      }
      
      override protected function getPageNameToSendForTracking() : String
      {
         var pageNameToSend:String = "unknown_PurchasePage";
         var currentPage:CodoPageObj = CodoPageViewDB.PAGE_LAYER_MAIN.currentPageObj;
         if(currentPage != null)
         {
            pageNameToSend = currentPage.id;
         }
         return pageNameToSend;
      }
      
      private function onUpdateInventoryCompleteHandle() : void
      {
         this.equipPendingItem();
         broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
      }
      
      private function onInventoryRefreshedAfterReconnect(cResult:ResultObj) : void
      {
         hideSpecificMsg(this.m_inventoryRefreshingMsg);
         if(cResult.result == ResultObj.RESULT_SUCCESS)
         {
            m_inventoryDirtyDueToDisconnect = false;
            this.onUpdateInventoryCompleteHandle();
         }
         else
         {
            this.m_inventoryRefreshFailedMsg = showMsg(Dict.INVENTORY_REFRESH_FAILED,MsgBtnCount.TWO,SystemMsgPriority.WARNING,CommonUtil.quit,DictSystem.QUIT,this.refreshInventoryOnReconnect,DictSystem.RETRY);
         }
      }
      
      override protected function onBuyItemWhenInventoryUpdated(cResult:ResultObj, soundOverriden:Boolean = false) : void
      {
         if(cResult.result == ResultObj.RESULT_SUCCESS)
         {
            if(this._pendingItemToEquip != null)
            {
               playSound(SE_ID.UI_PURCHASE_SUCCESS_EQUIP);
               soundOverriden = true;
            }
            this.equipPendingItem();
         }
         super.onBuyItemWhenInventoryUpdated(cResult,soundOverriden);
      }
      
      private function getWeaponCareer(weaponID:int) : Array
      {
         return CFunctionContainer.WL_GetWeaponCareerInfo(weaponID);
      }
      
      private function resetFeaturedItemObtainedState() : void
      {
         this.m_obtainedTopSellerItemsForThisSession = false;
         this.m_obtainedNewItemsForThisSession = false;
         this.m_obtainedPopularItemsForThisSession = false;
         this.m_obtainedRecommendedItemsForThisSession = false;
         this.m_obtainedPromoHotItems = false;
         this.m_obtainedPromoNewItems = false;
         this.m_obtainedPromoPopularItems = false;
         this.m_obtainedPromoRecommendedItems = false;
      }
      
      public function cppRefreshSupplyDropView() : void
      {
         broadcast(BCEvent.EVT_FORCE_REFRESH_SUPPLY_DROP_VIEW);
      }
   }
}

