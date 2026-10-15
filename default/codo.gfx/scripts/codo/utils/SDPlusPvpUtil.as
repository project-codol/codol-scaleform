package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataInGameID;
   import codo.constants.MarketMenuData;
   import codo.manager.DataManager;
   import codo.objects.ProductObj;
   import codo.objects.SDPItemObj;
   import codo.objects.SDPSubGroupObj;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SDPlusPvpUtil
   {
      
      public static const GROUP_BOMBKITS:String = "bombkits";
      
      public static const FILTER_ALL:int = 0;
      
      public static const FILTER_ATTACKER:int = 1;
      
      public static const FILTER_DEFENDER:int = 2;
      
      public static const FILTER_OWNED:int = 3;
      
      public static const DISABLE_NEVER:int = 0;
      
      public static const DISABLE_OT:int = 1;
      
      private static const ITEM_TABLE:String = "mp/sdpWeapons.csv";
      
      private static const COL_IDX:int = 0;
      
      private static const COL_ID:int = 1;
      
      private static const COL_GROUP:int = 2;
      
      private static const COL_COST:int = 3;
      
      private static const COL_NAME:int = 4;
      
      private static const COL_DESC:int = 5;
      
      private static const COL_ICON:int = 6;
      
      private static const COL_FILTER:int = 7;
      
      private static const COL_DISABLE:int = 8;
      
      private static const VALUE_TABLE:String = "mp/sdpWeaponClassCosts.csv";
      
      private static const COL_CAT:int = 0;
      
      private static const COL_VAL:int = 1;
      
      private static const IDX_PICKUP_OFFSET:int = 10000;
      
      private static const IDX_LOADOUT_OFFSET:int = 1000;
      
      private static const IDX_LOADOUT_PRI:int = 0;
      
      private static const IDX_LOADOUT_SEC:int = 1;
      
      private static const IDX_LOADOUT_LET:int = 2;
      
      private static const IDX_LOADOUT_TAC:int = 3;
      
      private static const IDX_LOADOUT_PER:int = 4;
      
      private static const FILTER_ITEM_HEIGHT:Number = 60;
      
      private static const TRANSACTION_DEBOUNCE_TIME:Number = 150;
      
      private static var _instance:SDPlusPvpUtil = null;
      
      private var _items:Vector.<SDPItemObj>;
      
      private var _subGroups:Vector.<SDPSubGroupObj>;
      
      private var _canPurchase:Boolean;
      
      private var _slotID:String;
      
      private var _equippedItemIndeces:Array;
      
      private var _transactionDebounce:Timer;
      
      private var _inTransactionDebounce:Boolean;
      
      public function SDPlusPvpUtil()
      {
         super();
         this.init();
         this._equippedItemIndeces = [];
         this._transactionDebounce = new Timer(TRANSACTION_DEBOUNCE_TIME,1);
         this._transactionDebounce.addEventListener(TimerEvent.TIMER,this.onTransactionDebounceComplete);
         this._inTransactionDebounce = false;
      }
      
      public static function get instance() : SDPlusPvpUtil
      {
         if(_instance == null)
         {
            _instance = new SDPlusPvpUtil();
         }
         return _instance;
      }
      
      private static function getLoadoutItemValue(prod:ProductObj, attachments:Array) : int
      {
         var baseCost:int = parseInt(CFunctionCommonContainer.StringTableLookup(VALUE_TABLE,COL_CAT,prod.group,COL_VAL));
         var attEachCost:int = parseInt(CFunctionCommonContainer.StringTableLookup(VALUE_TABLE,COL_CAT,"attachment",COL_VAL));
         var tierEachCost:int = parseInt(CFunctionCommonContainer.StringTableLookup(VALUE_TABLE,COL_CAT,"tier",COL_VAL));
         var tier:int = prod.tier < 3 ? 0 : prod.tier;
         var numAttachments:uint = 0;
         var NUM_FUNC_ATTACH:uint = 3;
         var i:uint = 0;
         while(i < NUM_FUNC_ATTACH && i < attachments.length)
         {
            if(attachments[i].id > 0)
            {
               numAttachments++;
            }
            i++;
         }
         return baseCost + tierEachCost * tier + attEachCost * numAttachments;
      }
      
      private static function prodToSDPItem(prod:ProductObj, index:int, attachments:Array, tagFavorite:Boolean) : SDPItemObj
      {
         var item:SDPItemObj = new SDPItemObj();
         item.index = index;
         item.group = prod.type != MarketMenuData.TYPE_EQUIPMENT ? prod.type : prod.group;
         item.subGroup = prod.type == MarketMenuData.TYPE_WEAPON ? prod.group : null;
         item.limit = prod.type != MarketMenuData.TYPE_EQUIPMENT ? 1 : 2;
         item.cost = getLoadoutItemValue(prod,attachments);
         item.nameLoc = prod.name;
         item.descLoc = prod.description;
         item.icon = prod.imageURL;
         item.id = prod.id;
         item.attachments = attachments;
         item.filter = FILTER_ALL;
         item.disable = DISABLE_NEVER;
         item.favorite = tagFavorite;
         return item;
      }
      
      private static function itemsAreSame(id1:int, id2:int, attach1:Array, attach2:Array) : Boolean
      {
         var i:uint = 0;
         if(id1 != id2)
         {
            return false;
         }
         var sorted1:Array = [];
         var sorted2:Array = [];
         for(i = 0; i < attach1.length; i++)
         {
            if(attach1[i].id > 0)
            {
               sorted1.push(attach1[i].id);
            }
         }
         for(i = 0; i < attach2.length; i++)
         {
            if(attach2[i].id > 0)
            {
               sorted2.push(attach2[i].id);
            }
         }
         sorted1.sort();
         sorted2.sort();
         if(sorted1.length != sorted2.length)
         {
            return false;
         }
         for(i = 0; i < sorted1.length; i++)
         {
            if(sorted1[i] != sorted2[i])
            {
               return false;
            }
         }
         return true;
      }
      
      private function init() : void
      {
         var i:int = 0;
         var j:int = 0;
         var item:SDPItemObj = null;
         var subGroup:SDPSubGroupObj = null;
         var groupSplitIdx:int = 0;
         var groupID:String = null;
         var nameTokens:Array = null;
         var itemID:int = 0;
         this._items = new Vector.<SDPItemObj>();
         this._subGroups = new Vector.<SDPSubGroupObj>();
         var len:int = CFunctionCommonContainer.StringTableRowCount(ITEM_TABLE);
         for(i = 0; i < len; i++)
         {
            groupID = CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_GROUP);
            if(groupID.length > 0)
            {
               if(groupID != "group")
               {
                  item = new SDPItemObj();
                  item.index = parseInt(CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_IDX));
                  nameTokens = CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_ID).split("|");
                  item.id = CFunctionCommonContainer.GetItemIDByName(nameTokens[0]);
                  item.attachments = [];
                  for(j = 1; j < nameTokens.length; j++)
                  {
                     itemID = CFunctionCommonContainer.GetItemIDByName(nameTokens[j]);
                     item.attachments.push(CFunctionCommonContainer.GetItemInfo(itemID));
                  }
                  groupSplitIdx = groupID.indexOf("_");
                  if(groupSplitIdx >= 0)
                  {
                     item.group = groupID.substring(0,groupSplitIdx);
                     item.subGroup = groupID.substring(groupSplitIdx + 1,groupID.length);
                  }
                  else
                  {
                     item.group = groupID;
                  }
                  item.limit = item.group != MarketMenuData.GRP_LETHAL && item.group != MarketMenuData.GRP_TACTICAL ? 1 : 2;
                  item.cost = parseInt(CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_COST));
                  item.nameLoc = "@" + CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_NAME);
                  item.descLoc = "@" + CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_DESC);
                  item.icon = "texture_assets/ui/weapon_icons/" + CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_ICON);
                  item.filter = parseInt(CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_FILTER));
                  item.disable = parseInt(CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_DISABLE));
                  item.favorite = false;
                  this._items.push(item);
               }
               else
               {
                  groupID = CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_ID);
                  groupSplitIdx = groupID.indexOf("_");
                  if(groupSplitIdx >= 0)
                  {
                     subGroup = new SDPSubGroupObj();
                     subGroup.name = groupID.substring(groupSplitIdx + 1,groupID.length);
                     subGroup.parentGroup = groupID.substring(0,groupSplitIdx);
                     subGroup.label = "@" + CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_NAME);
                     subGroup.imageURL = "texture_assets/ui/weapon_icons/" + CFunctionCommonContainer.StringTableLookupByRow(ITEM_TABLE,i,COL_ICON);
                     subGroup.height = FILTER_ITEM_HEIGHT;
                     this._subGroups.push(subGroup);
                  }
               }
            }
         }
         var loadouts:Array = DataManager.getInstance().getDP(DataInGameID.CHARACTER_WEAPON_LOADOUTS);
         var overrideLoadoutIdx:int = DataManager.getInstance().getDP(DataInGameID.OVERRIDE_WEAPON_LOADOUT_IDX);
         len = int(loadouts.length);
         for(i = 0; i < len; i++)
         {
            if(i != overrideLoadoutIdx && CFunctionCommonContainer.isLoadoutUsable(i))
            {
               this.pushUniqueLoadoutItem(new ProductObj(loadouts[i].primary),i,IDX_LOADOUT_PRI,loadouts[i].primaryAttachments);
               this.pushUniqueLoadoutItem(new ProductObj(loadouts[i].secondary),i,IDX_LOADOUT_SEC,loadouts[i].secondaryAttachments);
               this.pushUniqueLoadoutItem(new ProductObj(loadouts[i].equipments[0]),i,IDX_LOADOUT_LET);
               this.pushUniqueLoadoutItem(new ProductObj(loadouts[i].equipments[2]),i,IDX_LOADOUT_TAC);
               for(j = 0; j < 6; j++)
               {
                  this.pushUniqueLoadoutItem(new ProductObj(loadouts[i].perks[j]),i,IDX_LOADOUT_PER + j);
               }
            }
         }
      }
      
      private function pushUniqueLoadoutItem(prod:ProductObj, loadoutIdx:int, itemIdxOffset:int, attachments:Array = null) : void
      {
         if(!prod.id)
         {
            return;
         }
         if(attachments == null)
         {
            attachments = [];
         }
         var index:int = IDX_LOADOUT_OFFSET + IDX_LOADOUT_OFFSET * loadoutIdx + itemIdxOffset;
         var item:SDPItemObj = prodToSDPItem(prod,index,attachments,true);
         var len:uint = this._items.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(itemsAreSame(this._items[i].id,prod.id,this._items[i].attachments,attachments))
            {
               if(prod.type == MarketMenuData.TYPE_WEAPON && this._items[i].cost > 0)
               {
                  this._items[i] = item;
               }
               else
               {
                  this._items[i].favorite = true;
               }
               return;
            }
         }
         this._items.push(item);
      }
      
      private function updateEquippedIndeces(loadout:Object) : void
      {
         this._equippedItemIndeces.length = 0;
         var numItems:uint = uint(loadout.allItems.length);
         for(var i:uint = 0; i < numItems; i++)
         {
            if(loadout.allItems[i] > 0)
            {
               this._equippedItemIndeces.push(this.getItemIndex(loadout.allItems[i],[]));
            }
         }
         if(loadout.primary.id > 0)
         {
            this._equippedItemIndeces.push(this.getItemIndex(loadout.primary.id,loadout.primaryAttachments));
         }
         if(loadout.secondary.id > 0)
         {
            this._equippedItemIndeces.push(this.getItemIndex(loadout.secondary.id,loadout.secondaryAttachments));
         }
         this._equippedItemIndeces.push(loadout.extra[0]);
      }
      
      private function getItemNumEquipped(itemIdx:int) : uint
      {
         var numEquipped:uint = 0;
         var numItems:uint = this._equippedItemIndeces.length;
         for(var i:uint = 0; i < numItems; i++)
         {
            if(this._equippedItemIndeces[i] == itemIdx)
            {
               numEquipped++;
            }
         }
         return numEquipped;
      }
      
      private function isItemInLoadouts(id:int, loadouts:Array) : Boolean
      {
         var loadout:Object = null;
         for(var i:uint = 0; i < loadouts.length; i++)
         {
            loadout = loadouts[i];
            if(loadout.primary.id == id || loadout.secondary.id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function sortItems(x:SDPItemObj, y:SDPItemObj) : int
      {
         if(x.isInLoadout && !y.isInLoadout)
         {
            return -1;
         }
         if(y.isInLoadout && !x.isInLoadout)
         {
            return 1;
         }
         return x.cost - y.cost;
      }
      
      public function getItems(group:String, isSubGroup:Boolean) : Vector.<Object>
      {
         var loadouts:Array = null;
         var overrideLoadoutIdx:int = 0;
         var prod:ProductObj = null;
         var pickup:SDPItemObj = null;
         var filter:int = 0;
         var items:Vector.<Object> = new Vector.<Object>();
         var cashTotal:int = CFunctionCommonContainer.GetPlayerDataInt("playingCardsCurrentBestSet",false);
         loadouts = DataManager.getInstance().getDP(DataInGameID.CHARACTER_WEAPON_LOADOUTS);
         overrideLoadoutIdx = DataManager.getInstance().getDP(DataInGameID.OVERRIDE_WEAPON_LOADOUT_IDX);
         var loadout:Object = loadouts[overrideLoadoutIdx];
         var isOT:Boolean = CFunctionCommonContainer.Dvar_GetBool("ui_overtime") as Boolean;
         var attacking:Boolean = DataManager.getInstance().getDP(DataInGameID.SD_ATTACKING);
         this.updateEquippedIndeces(loadout);
         var numItems:uint = this._items.length;
         for(var i:uint = 0; i < numItems; i++)
         {
            if(group == (isSubGroup ? this._items[i].subGroup : this._items[i].group))
            {
               this._items[i].canAfford = cashTotal >= this._items[i].cost;
               this._items[i].numEquipped = this.getItemNumEquipped(this._items[i].index);
               this._items[i].disabled = !this._canPurchase || isOT && this._items[i].disable == DISABLE_OT;
               this._items[i].isInLoadout = this.isItemInLoadouts(this._items[i].id,loadouts);
               filter = this._items[i].filter;
               if(filter == FILTER_ALL || filter == FILTER_ATTACKER && attacking || filter == FILTER_DEFENDER && !attacking || filter == FILTER_OWNED && this._items[i].favorite)
               {
                  items.push(this._items[i]);
               }
            }
         }
         if(isSubGroup)
         {
            items = items.sort(this.sortItems);
         }
         prod = new ProductObj(loadout.primary);
         if(prod.id > 0 && prod.group == group && this.getItemIndex(prod.id,loadout.primaryAttachments) == IDX_PICKUP_OFFSET)
         {
            pickup = prodToSDPItem(prod,IDX_PICKUP_OFFSET + IDX_LOADOUT_PRI,loadout.primaryAttachments,false);
            pickup.canAfford = false;
            pickup.numEquipped = 1;
            pickup.disabled = !this._canPurchase;
            items.unshift(pickup);
         }
         prod = new ProductObj(loadout.secondary);
         if(prod.id > 0 && prod.group == group && this.getItemIndex(prod.id,loadout.secondaryAttachments) == IDX_PICKUP_OFFSET)
         {
            pickup = prodToSDPItem(prod,IDX_PICKUP_OFFSET + IDX_LOADOUT_SEC,loadout.secondaryAttachments,false);
            pickup.canAfford = false;
            pickup.numEquipped = 1;
            pickup.disabled = !this._canPurchase;
            items.unshift(pickup);
         }
         return items;
      }
      
      public function getSubGroups(group:String) : Vector.<Object>
      {
         var subGroups:Vector.<Object> = new Vector.<Object>();
         var numSubGroups:uint = this._subGroups.length;
         for(var i:uint = 0; i < numSubGroups; i++)
         {
            if(group == this._subGroups[i].parentGroup)
            {
               subGroups.push(this._subGroups[i]);
            }
         }
         return subGroups;
      }
      
      public function getItemDataByIndex(index:int) : ProductObj
      {
         var data:ProductObj = new ProductObj();
         var numItems:uint = this._items.length;
         for(var i:uint = 0; i < numItems; i++)
         {
            if(this._items[i].index == index)
            {
               data.name = this._items[i].nameLoc;
               data.imageURL = this._items[i].icon;
               data.description = this._items[i].descLoc;
               break;
            }
         }
         return data;
      }
      
      public function getItemIndex(id:int, attachments:Array) : int
      {
         var numItems:uint = this._items.length;
         for(var i:uint = 0; i < numItems; i++)
         {
            if(itemsAreSame(this._items[i].id,id,this._items[i].attachments,attachments))
            {
               return this._items[i].index;
            }
         }
         return IDX_PICKUP_OFFSET;
      }
      
      private function onTransactionDebounceComplete(e:TimerEvent) : void
      {
         this._inTransactionDebounce = false;
      }
      
      public function executeTransaction(itemData:SDPItemObj, isPurchase:Boolean) : void
      {
         var message:String = null;
         if(this._inTransactionDebounce)
         {
            return;
         }
         this._inTransactionDebounce = true;
         this._transactionDebounce.reset();
         this._transactionDebounce.start();
         if(isPurchase)
         {
            message = "purchase_" + itemData.index;
            if(this._slotID != "")
            {
               message += "_" + this._slotID;
            }
         }
         else
         {
            message = "sell_" + itemData.index;
         }
         CFunctionCommonContainer.ScriptMenuResponse("sdp_purchase",message);
      }
      
      public function set canPurchase(value:Boolean) : void
      {
         this._canPurchase = value;
         DataManager.getInstance().setBindData(DataInGameID.SDP_CAN_PURCHASE,this._canPurchase);
      }
      
      public function set slotID(value:String) : void
      {
         this._slotID = value;
      }
   }
}

