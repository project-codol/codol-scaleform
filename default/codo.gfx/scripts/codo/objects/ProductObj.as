package codo.objects
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.DataID;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.manager.DataManager;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   
   public dynamic class ProductObj extends ItemObj
   {
      
      private static var _marketDetailsItem:ProductObj;
      
      private static var _marketDetailsEquippingAttach:Boolean;
      
      public static const PRODUCT_NOT_ENOUGHT_RANK:int = 1;
      
      public static const PRODUCT_NO_CHALLENGE:int = 2;
      
      public static const PRODUCT_ALREADY_HAVE:int = 3;
      
      public static const PRODUCT_NO_PRODUCT:int = 4;
      
      public static const PRODUCT_NO_SKU:int = 5;
      
      public static const TIER_BASIC:int = 0;
      
      public static const TIER_COMMON:int = 1;
      
      public static const TIER_RARE:int = 2;
      
      public static const TIER_EPIC:int = 3;
      
      public static const TIER_LEGENDARY:int = 4;
      
      public static const PRODUCT_NORMAL:int = 0;
      
      public static const PRODUCT_NEW:int = 1;
      
      public static const PRODUCT_HOT:int = 2;
      
      public static const SKU_ON_SALE:int = 1 << 0;
      
      public static const SKU_RANDOM_REWARD:int = 1 << 1;
      
      public static const SKU_FUTURE_TIME:int = 1 << 2;
      
      public static const UF_WARGOD_EXCLUSIVE:String = "uf_wargod_rank";
      
      public static const ACTION_NONE:uint = 0;
      
      public static const ACTION_BUY:uint = 1;
      
      public static const ACTION_EQUIP:uint = 2;
      
      public static const ACTION_DETAILS:uint = 3;
      
      public static const ACTION_COMPARE:uint = 4;
      
      public static const ACTION_PREVIEW:uint = 5;
      
      public static const ACTION_UNEQUIP:uint = 6;
      
      public static const ACTION_CONSUME:uint = 7;
      
      public static const ACTION_DEPENDENCY:uint = 8;
      
      public static const ACTION_NOTFORSALE:uint = 9;
      
      public var cartExclude:Boolean = false;
      
      public var showBreadcrumb:Boolean;
      
      public var purchasable:Boolean = true;
      
      public var isInBundle:Boolean = false;
      
      public var showPurchaseInProgressMsg:Boolean = true;
      
      public var purchasedTimes:int;
      
      public var purchaseLimit:int;
      
      public var exclusiveProductID:int;
      
      public var SKUs:Array;
      
      public var promoType:uint = 0;
      
      public var currentSKUIndex:uint = 0;
      
      public var saveForLater:Boolean;
      
      public var CPSKUIndex:uint = 4294967295;
      
      public var GPSKUIndex:uint = 4294967295;
      
      public var HPSKUIndex:uint = 4294967295;
      
      public var EHPSKUIndex:uint = 4294967295;
      
      public var levelRewardGP:int = -1;
      
      public var isGP:Boolean;
      
      public var salesNumber:int = 0;
      
      public var skuTypes:int = SKU_FUTURE_TIME;
      
      public var disableExtendOptionForOnboarding:Boolean = false;
      
      public var tier:int = 0;
      
      public var itemBuffs:Array;
      
      public var beingPreviewed:Boolean;
      
      public var beingCompared:Boolean;
      
      public var listSiblings:Vector.<ProductObj>;
      
      public var exclusiveFlag:String;
      
      public var exclusiveUnlockRank:int;
      
      public var itemDependencies:Array = [];
      
      public var notForSaleObj:NotForSaleObj;
      
      public var isEquippableBundle:Boolean = false;
      
      public var ignoreDiscount:Boolean = false;
      
      public var noExpiredItemInBundle:Boolean = true;
      
      public var supplyDropRentalDurationSeconds:uint;
      
      public function ProductObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public static function setMarketDetailsItem(item:ProductObj, equippingAttach:Boolean = false) : void
      {
         _marketDetailsItem = item;
         _marketDetailsEquippingAttach = equippingAttach;
      }
      
      public static function inMarketDetails() : Boolean
      {
         return _marketDetailsItem != null;
      }
      
      public static function makeCurrencyObj(obj:Object, type:int, amount:int) : ProductObj
      {
         switch(type)
         {
            case MarketMenuData.CURRENCY_GAME_POINT:
               obj.name = String(amount) + " " + LocalizeUtil.localize(Dict.GP);
               obj.imageURL = "scaleform_ash/miscicons/gold_coin_s";
               obj.isGP = true;
               break;
            case MarketMenuData.CURRENCY_HERO_POINT:
               obj.name = String(amount) + " " + LocalizeUtil.localize(Dict.HP);
               obj.imageURL = "scaleform_ash/miscicons/hp_icon";
               break;
            case MarketMenuData.CURRENCY_EPIC_HERO_POINT:
               obj.name = String(amount) + " " + LocalizeUtil.localize(Dict.EHP);
               obj.imageURL = "scaleform_ash/miscicons/ehp_icon";
         }
         obj.stackable = true;
         return obj as ProductObj;
      }
      
      public static function makeGpObj(obj:Object, gp:int) : ProductObj
      {
         return makeCurrencyObj(obj,MarketMenuData.CURRENCY_GAME_POINT,gp);
      }
      
      public static function makeItemOrGp(itemID:int, gp:int) : ProductObj
      {
         if(itemID > 0)
         {
            return CFunctionCommonContainer.GetItemInfo(itemID);
         }
         if(gp > 0)
         {
            return makeGpObj(new ProductObj(),gp);
         }
         return null;
      }
      
      override public function toString() : String
      {
         return "<ProductObject id:" + id + ">";
      }
      
      public function isReachPurchaseLimit() : Boolean
      {
         if(this.purchaseLimit != 0)
         {
            return this.purchasedTimes >= this.purchaseLimit;
         }
         return false;
      }
      
      public function isOwnedPermanent() : Boolean
      {
         if((nameid == "cnc_token" || nameid == "stat_reset_token") && stackNumber > 0)
         {
            return true;
         }
         return isBought && isPermanentHave;
      }
      
      public function isOwnedRental() : Boolean
      {
         return isBought && remainSecond > 0;
      }
      
      public function isOwned() : Boolean
      {
         return this.isOwnedPermanent() || this.isOwnedRental() || stackNumber > 0;
      }
      
      public function isEquipped() : Boolean
      {
         return CFunctionContainer.AS_IsItemEquipped(id,group != "" ? group : type) as Boolean;
      }
      
      public function equipUiEnabled() : Boolean
      {
         if(!ScaleformUtil.inFrontendLoadout && !ScaleformUtil.inLobbyLoadout)
         {
            return false;
         }
         if(!this.isOwned())
         {
            return false;
         }
         if(!equippable && type != MarketMenuData.TYPE_CHARACTER)
         {
            return false;
         }
         if(type == MarketMenuData.TYPE_WEAPON && this.isEquipped())
         {
            return false;
         }
         if(type == MarketMenuData.TYPE_ATTACH)
         {
            if(inMarketDetails() && !_marketDetailsEquippingAttach)
            {
               return false;
            }
            if(ScaleformUtil.inStorage)
            {
               return false;
            }
         }
         return true;
      }
      
      public function useIconHolderForImage() : Boolean
      {
         if(this.isGameModeIcon() || type == MarketMenuData.TYPE_PERK || type == MarketMenuData.TYPE_CALLSIGN_BADGE || group == MarketMenuData.TYPE_CALLSIGN_CHANGE_NAME || type == MarketMenuData.TYPE_CALLSIGN_NAMEPLATE)
         {
            return true;
         }
         if(type == MarketMenuData.TYPE_CALLSIGN_EMBLEM && !this.isAnimatedEmblem())
         {
            return true;
         }
         return false;
      }
      
      public function isGameModeIcon() : Boolean
      {
         if(type != MarketMenuData.TYPE_GAMEMODE)
         {
            return false;
         }
         return group == MarketMenuData.TYPE_GAMEMODE_TOKEN || group == MarketMenuData.GRP_EQUIPPABLE_TOKEN;
      }
      
      public function isAnimatedBackground() : Boolean
      {
         return type == MarketMenuData.TYPE_CALLSIGN_BKG && imageURL.indexOf("pcab_") >= 0;
      }
      
      public function isAnimatedEmblem() : Boolean
      {
         return imageURL.indexOf("pcai_") >= 0;
      }
      
      public function isAnimatedFrame() : Boolean
      {
         return imageURL.indexOf("pcaf_") >= 0;
      }
      
      public function purchaseUiEnabled(checkLocked:Boolean = true) : Boolean
      {
         if(this.SKUs == null || this.SKUs.length == 0)
         {
            return false;
         }
         if(checkLocked && !this.purchasable)
         {
            return false;
         }
         if(this.group == MarketMenuData.GRP_LOADOUT_BUNDLE && this.isOwned() && this.noExpiredItemInBundle)
         {
            return false;
         }
         if(this.isOwnedPermanent())
         {
            return false;
         }
         if(this.isOwnedRental() && (this.skuTypes & ProductObj.SKU_ON_SALE) == 0)
         {
            return false;
         }
         return true;
      }
      
      public function isNotForSaleActionEnabled() : Boolean
      {
         if(null == this.notForSaleObj)
         {
            return false;
         }
         return true;
      }
      
      public function compareUiEnabled() : Boolean
      {
         return !this.isWarGodExclusive() && type == MarketMenuData.TYPE_WEAPON;
      }
      
      public function detailsUiEnabled() : Boolean
      {
         if(this.purchaseUiEnabled() && !this.fullscreenDetailsEnabled())
         {
            return false;
         }
         return true;
      }
      
      public function previewUiEnabled() : Boolean
      {
         if(this.isEquipped())
         {
            return false;
         }
         if(ScaleformUtil.inLobbyLoadout)
         {
            return false;
         }
         if(!this.canPreviewForCurrentUIViewerCharacter())
         {
            return false;
         }
         if(type == ItemType.CHA)
         {
            return !this.isOwned();
         }
         if(type == ItemType.CAT || type == ItemType.ITM && group == MarketMenuData.GRP_EMOTE || group == MarketMenuData.GRP_OUTFIT)
         {
            return true;
         }
         if(ScaleformUtil.inFrontendLoadout)
         {
            return type == ItemType.PCT || type == ItemType.PCI || type == ItemType.PCB || type == ItemType.PCN || type == ItemType.PCF;
         }
         return type == ItemType.WEAPON;
      }
      
      public function consumeUiEnabled() : Boolean
      {
         if((nameid == "cnc_token" || nameid == "stat_reset_token") && stackNumber > 0)
         {
            return true;
         }
         return false;
      }
      
      public function getExclusiveEquippedItemName() : String
      {
         var exclusiveEquippedItem:ProductObj = null;
         if(type == MarketMenuData.TYPE_ATTACH || type == MarketMenuData.TYPE_CALLSIGN_BADGE || type == MarketMenuData.TYPE_KILLSTREAK || group == MarketMenuData.GRP_WILDCARD)
         {
            if(this.equipUiEnabled())
            {
               exclusiveEquippedItem = new ProductObj(CFunctionContainer.AS_GetExclusiveEquippedItem(id));
               if(Boolean(exclusiveEquippedItem) && exclusiveEquippedItem.name != "")
               {
                  return exclusiveEquippedItem.name;
               }
            }
         }
         return null;
      }
      
      public function isWarGodExclusive() : Boolean
      {
         return this.exclusiveFlag == UF_WARGOD_EXCLUSIVE;
      }
      
      public function fullscreenDetailsEnabled() : Boolean
      {
         var isWarGodRoom:Boolean = false;
         if(type == ItemType.WEAPON || type == ItemType.CHA || type == ItemType.EQU)
         {
            if(Boolean(DataManager.getInstance().getDP(DataID.IS_IN_AAR)))
            {
               return false;
            }
            isWarGodRoom = CFunctionContainer.AS_IsWarGodRoom() as Boolean;
            if(Boolean(DataManager.getInstance().getDP(DataID.IS_IN_ROOM)) && !isWarGodRoom)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function canPreviewForCurrentUIViewerCharacter() : Boolean
      {
         var isBundle:Boolean = group == MarketMenuData.GRP_OUTFIT || group == MarketMenuData.GRP_WEAPON_BUNDLE || group == MarketMenuData.GRP_SUPPLY_DROP_BUNDLE || group == MarketMenuData.GRP_GIFTBOX || group == MarketMenuData.GRP_LOADOUT_BUNDLE;
         return CFunctionContainer.CL_CanItemBeEquippedByUIViewerCharacter(isBundle,id) as Boolean;
      }
      
      public function getPrimaryAction() : uint
      {
         if(ScaleformUtil.inFrontendLoadout || ScaleformUtil.inLobbyLoadout)
         {
            if(ScaleformUtil.inStorage)
            {
               return ACTION_DEPENDENCY;
            }
            if(type == MarketMenuData.TYPE_WEAPON && this.isEquipped())
            {
               return ACTION_NONE;
            }
            if((type == MarketMenuData.TYPE_KILLSTREAK || type == ItemType.CAT || type == ItemType.BDG || type == ItemType.PCN || type == ItemType.PCF || group == MarketMenuData.GRP_EMOTE || group == MarketMenuData.GRP_EQUIPPABLE_TOKEN || group == MarketMenuData.GRP_OUTFIT || group == MarketMenuData.GRP_KNIFE) && this.isEquipped() && ScaleformUtil.isMe)
            {
               return ACTION_UNEQUIP;
            }
         }
         if(this.isWarGodExclusive())
         {
            if(this.purchasable)
            {
               return ACTION_BUY;
            }
            return ACTION_NONE;
         }
         if(this.equipUiEnabled() && ScaleformUtil.isMe)
         {
            return ACTION_EQUIP;
         }
         if(this.consumeUiEnabled())
         {
            return ACTION_CONSUME;
         }
         if(this.purchaseUiEnabled() && !this.fullscreenDetailsEnabled())
         {
            return ACTION_BUY;
         }
         if(this.detailsUiEnabled())
         {
            return ACTION_DETAILS;
         }
         return ACTION_NONE;
      }
   }
}

