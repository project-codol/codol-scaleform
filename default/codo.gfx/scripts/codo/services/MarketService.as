package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.MarketSlots;
   import codo.constants.ServiceID;
   import codo.localization.Dict;
   import codo.models.DataProvider;
   import codo.objects.AccountObj;
   import codo.objects.MailAttachmentObj;
   import codo.objects.ResultObj;
   import codo.utils.ScaleformUtil;
   
   public class MarketService extends ServiceBase
   {
      
      private static var instance:MarketService;
      
      private var _fakeMailAttachments:Array = [];
      
      private var _fakeMarketFavorites:Array;
      
      private var m_cachedNewItems:Array = [];
      
      public function MarketService()
      {
         super(ServiceID.MARKET);
      }
      
      public static function getInstance() : MarketService
      {
         if(MarketService.instance == null)
         {
            MarketService.instance = new MarketService();
         }
         return MarketService.instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.MARKET_BUY,this.buyMarketItem);
         this.register(DataID.MARKET_UPDATE_INVENTORY,this.updateInventroy);
         this.register(DataID.DATA_RECEIVE);
         this.register(DataID.PURCHASE_GIFT,this.purchaseGift);
         this.register(DataID.CLAIM_COUPON,this.claimCoupon);
         this.register(DataID.TRANSFER_COUPON,this.transferCoupon);
         this.register(DataID.REDEEM_COUPON,this.redeemCoupon);
         this.register(DataID.UPDATE_COUPON,this.updateCoupon);
         this.register(DataID.FETCH_MAIL_ATTACHMENTS,this.fetchMailAttachments);
         this.register(DataID.REDEEM_CHANGE_NAME,this.redeemChangeName);
         this.register(DataID.REDEEM_STAT_RESET,this.redeemStatReset);
         this.register(DataID.CLAIM_ONBOARDING_REWARD,this.claimOnboardingReward);
         this.requestMarketFavorites();
      }
      
      public function isExclusiveCategory(category:String) : Boolean
      {
         return category.indexOf(MarketMenuData.GRP_CLAN) == 0 || category.indexOf(MarketMenuData.GRP_WARGOD) == 0;
      }
      
      public function isNotSaleCategory(category:String) : Boolean
      {
         return category.indexOf(MarketMenuData.GRP_NOTSALE) == 0;
      }
      
      public function isWeaponBrandCategory(category:String) : Boolean
      {
         return category.indexOf("brand") == 0;
      }
      
      public function getItemListByCategory(cCategoryNameID:String, cTypeFilter:uint, inMarketDetails:Boolean = false, inMarketStorage:Boolean = false) : Array
      {
         var currentListDP:Array = null;
         var fakeDP:Array = null;
         trace("@@@@@@@@@@@@@@@@ getItemListByCategory");
         trace(cCategoryNameID,cTypeFilter,inMarketDetails,inMarketStorage);
         if(ScaleformUtil.isScaleform)
         {
            if(Boolean(MarketSlots.MARKET_CATEGORY_MAPPING[cCategoryNameID]))
            {
               currentListDP = this.getMarketDPs(MarketSlots.MARKET_CATEGORY_MAPPING[cCategoryNameID],cTypeFilter,inMarketDetails,inMarketStorage);
            }
            else
            {
               currentListDP = this.getMarketDP(cCategoryNameID,cTypeFilter,inMarketDetails,inMarketStorage);
            }
            return currentListDP;
         }
         fakeDP = [];
         this.fillFakeListDataForCategory(fakeDP,cCategoryNameID);
         return fakeDP;
      }
      
      public function initMarketFavorites() : void
      {
         var item:Object = null;
         this._fakeMarketFavorites = [];
         var favoritesItemID:Array = CFunctionContainer.MKT_GetFavoriteItems();
         for(var i:int = 0; i < favoritesItemID.length; i++)
         {
            item = this.getItemInfoObj(favoritesItemID[i]);
            this._fakeMarketFavorites.push(item);
         }
         this.requestMarketFavorites();
      }
      
      public function saveMarketFavorites() : void
      {
         var favoritesItemID:Array = null;
         var i:int = 0;
         var item:Object = null;
         if(this._fakeMarketFavorites != null)
         {
            favoritesItemID = [];
            for(i = 0; i < this._fakeMarketFavorites.length; i++)
            {
               item = this._fakeMarketFavorites[i];
               favoritesItemID.push(item.id);
            }
            CFunctionContainer.MKT_SetFavoriteItems(favoritesItemID);
         }
      }
      
      private function requestMarketFavorites() : void
      {
         if(this._fakeMarketFavorites == null)
         {
            this._fakeMarketFavorites = [];
         }
         this.setData(ResultObj.getObj(DataID.MARKET_FAVORITES,this._fakeMarketFavorites));
      }
      
      public function getItemInfoObj(cID:int) : Object
      {
         if(ScaleformUtil.isScaleform && cID > 0 && Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
         {
            return CFunctionCommonContainer.GetItemInfo(cID);
         }
         return null;
      }
      
      public function getItemIDByName(cName:String) : int
      {
         if(ScaleformUtil.isScaleform)
         {
            return CFunctionCommonContainer.GetItemIDByName(cName);
         }
         return -1;
      }
      
      public function requestMyAccount() : void
      {
         var account:AccountObj = null;
         if(ScaleformUtil.isScaleform == false)
         {
            account = new AccountObj();
            account.moneyPoint = 5;
            account.codPoint = 5;
            this.setData(ResultObj.getObj(DataID.MY_ACCOUNT,account));
         }
         else
         {
            CFunctionCommonContainer.MKT_RequestAccountInfo();
         }
      }
      
      public function buyMarketItem(cParams:Object) : void
      {
         var account:AccountObj = null;
         var itemNum:int = 0;
         if(ScaleformUtil.isScaleform == false)
         {
            account = new AccountObj();
            account.moneyPoint = Math.floor(Math.random() * 50);
            account.codPoint = Math.floor(Math.random() * 50);
            this.setData(ResultObj.getObj(DataID.MY_ACCOUNT,account));
         }
         if(cParams.isShoppingCart == false)
         {
            itemNum = 1;
            if(cParams.hasOwnProperty("itemNum"))
            {
               itemNum = int(cParams.itemNum);
            }
            if(this.createTask(DataID.MARKET_BUY,AsyncTaskGroup.MARKET,cParams))
            {
               if(cParams.disableFeedback != true)
               {
                  this.showMsg(Dict.PURCHASE_IN_PROGRESS);
               }
            }
         }
         else
         {
            CFunctionContainer.MKT_BuyCart(cParams.excludes);
         }
      }
      
      public function updateInventroy() : void
      {
         CFunctionContainer.MKT_UpdateInventory();
      }
      
      private function purchaseGift(cParams:Object) : void
      {
         if(this.createTask(DataID.PURCHASE_GIFT,AsyncTaskGroup.MARKET,cParams))
         {
            this.showMsg(Dict.PURCHASE_GIFT_IN_PROGRESS);
         }
      }
      
      private function claimCoupon(couponIDArray:Array) : void
      {
         if(this.createTask(DataID.CLAIM_COUPON,AsyncTaskGroup.MARKET,couponIDArray))
         {
            this.showMsg(Dict.CLAIM_COUPON_IN_PROGRESS);
         }
      }
      
      private function transferCoupon(cParams:Object) : void
      {
         if(this.createTask(DataID.TRANSFER_COUPON,AsyncTaskGroup.MARKET,cParams))
         {
            this.showMsg(Dict.TRANSFER_COUPON_IN_PROGRESS);
         }
      }
      
      private function redeemCoupon(couponIDArray:Array) : void
      {
         if(this.createTask(DataID.REDEEM_COUPON,AsyncTaskGroup.MARKET,couponIDArray))
         {
         }
      }
      
      private function updateCoupon() : void
      {
         this.createTask(DataID.UPDATE_COUPON,AsyncTaskGroup.MARKET);
      }
      
      private function redeemChangeName(cParams:Object) : void
      {
         this.createTask(DataID.REDEEM_CHANGE_NAME,AsyncTaskGroup.REDEEM_CHANGE_NAME,cParams);
      }
      
      private function redeemStatReset() : void
      {
         this.createTask(DataID.REDEEM_STAT_RESET,AsyncTaskGroup.REDEEM_STAT_RESET);
      }
      
      private function claimOnboardingReward(cParams:Object) : void
      {
         this.createTask(DataID.CLAIM_ONBOARDING_REWARD,AsyncTaskGroup.CLAIM_ONBOARDING_REWARD,cParams);
      }
      
      private function fetchMailAttachments() : void
      {
         this.createTask(DataID.FETCH_MAIL_ATTACHMENTS,AsyncTaskGroup.MARKET,{"feedback":false},this.fakeMailAttachments);
      }
      
      private function get fakeMailAttachments() : Array
      {
         var i:uint = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeMailAttachments.length <= 0)
         {
            for(i = 1; i <= 15; i++)
            {
               this._fakeMailAttachments.push(new MailAttachmentObj({
                  "id":String(11111 * i),
                  "name":"Coupon Item Name",
                  "description":"Coupon Item Description",
                  "imageURL":"Coupon Image URL"
               }));
            }
         }
         return this._fakeMailAttachments;
      }
      
      public function getMarketDPs(marketSlotNameIDs:Array, cFilter:uint, inMarketDetails:Boolean = false, inMarketStorage:Boolean = false) : Array
      {
         var slotNameID:String = null;
         var dp:Array = null;
         var i:int = 0;
         var dpArray:Array = new Array();
         for each(slotNameID in marketSlotNameIDs)
         {
            dp = this.getMarketDP(slotNameID,cFilter,inMarketDetails,inMarketStorage);
            if(Boolean(dp))
            {
               for(i = 0; i < dp.length; i++)
               {
                  dpArray.push(dp[i]);
               }
            }
         }
         return dpArray;
      }
      
      public function GetProductList(categoryid:String, filter:uint, inMarketDetails:Boolean = false, inMarketStorage:Boolean = false) : Array
      {
         var resultArray:Array = null;
         if(Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
         {
            resultArray = CFunctionContainer.AS_GetItemList(categoryid,filter,inMarketDetails,inMarketStorage) as Array;
         }
         if(resultArray == null)
         {
            return null;
         }
         return resultArray;
      }
      
      public function GetProductListByTag(cFilter:uint) : Array
      {
         var resultArray:Array = CFunctionContainer.AS_GetItemListByTag(cFilter);
         if(resultArray == null)
         {
            return null;
         }
         return resultArray;
      }
      
      public function getCouponDP(cFilter:uint) : Array
      {
         if(cFilter == Common.LIST_TYPE_All)
         {
            return new DataProvider(null);
         }
         return this.GetProductList("coupon",cFilter);
      }
      
      public function getMarketDP(marketSlotNameID:String, cFilter:uint, inMarketDetails:Boolean = false, inMarketStorage:Boolean = false) : Array
      {
         if(marketSlotNameID.substr(0,5) == "clan_")
         {
            return this.GetProductList(marketSlotNameID,Common.LIST_TYPE_CLAN_MKT,false,false);
         }
         if(marketSlotNameID.substr(0,7) == "wargod_")
         {
            return this.GetProductList(marketSlotNameID,Common.LIST_TYPE_WARGOD_MKT,false,false);
         }
         if(marketSlotNameID.substr(0,8) == "notsale_")
         {
            return this.GetProductList(marketSlotNameID,Common.LIST_TYPE_NOTSALE_MKT,false,false);
         }
         if(marketSlotNameID.substr(0,6) == "brand_")
         {
            return this.GetProductList(marketSlotNameID,Common.LIST_TYPE_BRANDWEAPON_MKT,false,false);
         }
         switch(MarketSlots.MARKET_DP_MAPPING[marketSlotNameID])
         {
            case "weapon":
            case "sword":
            case "perk":
            case "equipment":
            case "killstreak":
            case "avatar":
            case "deathstreak":
            case "weaponattach":
            case "item":
            case "callsign":
            case "bundle":
               return this.GetProductList(marketSlotNameID,cFilter,inMarketDetails,inMarketStorage);
            case "coupon":
               return this.getCouponDP(cFilter) as Array;
            default:
               return null;
         }
      }
      
      public function getNewItems() : Array
      {
         return this.m_cachedNewItems;
      }
      
      public function isNewItem(id:int) : Boolean
      {
         if(this.m_cachedNewItems == null)
         {
            return false;
         }
         var numNewItems:int = int(this.m_cachedNewItems.length);
         if(numNewItems == 0)
         {
            return false;
         }
         for(var index:int = 0; index < numNewItems; index++)
         {
            if(this.m_cachedNewItems[index].id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function registerNewItems(newItems:Array) : void
      {
         this.m_cachedNewItems = newItems;
      }
      
      public function isGameDataReady() : Boolean
      {
         var playerInventoryDataReady:Boolean = CFunctionCommonContainer.IsPlayerdataReady() as Boolean;
         var marketDataReady:Boolean = CFunctionCommonContainer.IsMarketplaceReady() as Boolean;
         return playerInventoryDataReady && marketDataReady;
      }
      
      private function fillFakeListDataForCategory(tempDP:Array, categoryNameID:String) : void
      {
         this.fillFakeListData(tempDP);
         for(var i:uint = 0; i < tempDP.length; i++)
         {
            tempDP[i].name = categoryNameID + tempDP[i].name;
         }
      }
      
      public function fillFakeListData(tempDP:Array) : void
      {
         for(var i:uint = 0; i < 6; i++)
         {
            tempDP.push({
               "id":i,
               "nameid":"item_" + i,
               "name":"Item " + i,
               "description":"desc desc desc desc desc desc desc desc",
               "properties":[{
                  "key":"@SF_WEAPON_ACCURACY",
                  "val":Math.floor(Math.random() * 50 + 50)
               },{
                  "key":"@SF_WEAPON_DAMAGE",
                  "val":Math.floor(Math.random() * 50 + 50)
               },{
                  "key":"@SF_WEAPON_RANGE",
                  "val":Math.floor(Math.random() * 50 + 50)
               },{
                  "key":"@SF_WEAPON_FIRERATE",
                  "val":Math.floor(Math.random() * 50 + 50)
               },{
                  "key":"@SF_WEAPON_MOBILITY",
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
   }
}

