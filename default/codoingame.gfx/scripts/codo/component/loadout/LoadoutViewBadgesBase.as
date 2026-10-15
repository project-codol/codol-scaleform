package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.event.ParaEvent;
   import codo.localization.DictCareer;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.BadgeObj;
   import codo.objects.ProductObj;
   
   public class LoadoutViewBadgesBase extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      protected var SLOT_WIDTH:Number = 122;
      
      protected var SLOT_HEIGHT:Number = 122;
      
      public var myBadgeSlot0:LoadoutButton;
      
      public var myBadgeSlot1:LoadoutButton;
      
      public var myBadgeSlot2:LoadoutButton;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myConsumableSlot:LoadoutButton;
      
      public var myConsumableCount:TextField;
      
      private var mBadgeSlots:Vector.<LoadoutButton>;
      
      private var mSelectedSlot:LoadoutButton;
      
      private var _itemsData:Array;
      
      public function LoadoutViewBadgesBase()
      {
         super();
         this.mBadgeSlots = new <LoadoutButton>[this.myBadgeSlot0,this.myBadgeSlot1,this.myBadgeSlot2];
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myInstructions.height = 100;
         this.myBadgeSlot0.width = this.SLOT_WIDTH;
         this.myBadgeSlot0.height = this.SLOT_HEIGHT;
         this.myBadgeSlot1.width = this.SLOT_WIDTH;
         this.myBadgeSlot1.height = this.SLOT_HEIGHT;
         this.myBadgeSlot2.width = this.SLOT_WIDTH;
         this.myBadgeSlot2.height = this.SLOT_HEIGHT;
         this.myConsumableSlot.width = this.SLOT_WIDTH;
         this.myConsumableSlot.height = this.SLOT_HEIGHT;
         this.myBadgeSlot0.registerClickEvent(this.onBadgeSlotClicked,0);
         this.myBadgeSlot1.registerClickEvent(this.onBadgeSlotClicked,1);
         this.myBadgeSlot2.registerClickEvent(this.onBadgeSlotClicked,2);
         this.myConsumableSlot.registerClickEvent(this.onSlotClicked,this.myConsumableSlot);
         this.updateGrid();
         this.mSelectedSlot = this.myBadgeSlot0;
         this.mSelectedSlot.toggled = true;
      }
      
      override protected function enableData() : void
      {
         EventManager.getInstance().listen(BCEvent.EVT_BADGE_REFRESH,this.refreshBadge);
         EventManager.getInstance().broadcast(BCEvent.EVT_CALLSIGN_VIEW_ONSHOW);
      }
      
      override protected function disableData() : void
      {
         EventManager.getInstance().unlisten(BCEvent.EVT_BADGE_REFRESH,this.refreshBadge);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this);
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = list1.concat(list2);
         this.refreshList();
         this.mSelectedSlot.toggled = true;
      }
      
      private function refreshList() : void
      {
         var item:ProductObj = null;
         var items:Vector.<Object> = new Vector.<Object>();
         for(var i:int = 0; i < this._itemsData.length; i++)
         {
            item = this._itemsData[i];
            items.push(item);
         }
         this.myScrollGrid.addItemsByVector(items);
         this.refreshConsumableSlot();
      }
      
      private function refreshConsumableSlot() : void
      {
         var id:int = CFunctionContainer.Callsign_GetActiveAdvancedConsumable();
         var productData:ProductObj = CFunctionCommonContainer.GetItemInfo(id);
         if(productData.stackable)
         {
            this.myConsumableSlot.setData(productData);
            this.myConsumableCount.text = "x" + productData.stackNumber;
            if(this.myConsumableSlot.visible)
            {
               this.myConsumableCount.visible = true;
            }
         }
         else
         {
            productData = new ProductObj();
            productData.isEmpty = true;
            productData.isEnable = true;
            this.myConsumableSlot.setData(productData);
            this.myConsumableCount.visible = false;
         }
      }
      
      protected function refreshBadge(cEvt:ParaEvent) : void
      {
         var badgeObj:BadgeObj = null;
         var productData:ProductObj = null;
         var badgeData:Array = cEvt.myPara as Array;
         for(var i:int = 0; i < this.mBadgeSlots.length; i++)
         {
            badgeObj = new BadgeObj(badgeData[i]);
            if(badgeObj.id > 0)
            {
               productData = CFunctionCommonContainer.GetItemInfo(int(badgeObj.id));
               this.mBadgeSlots[i].setData(productData);
            }
            else
            {
               productData = new ProductObj();
               productData.isEmpty = true;
               productData.isEnable = true;
               productData.isLocked = !(CFunctionCommonContainer.WL_GetIsBadgeSlotUnlocked(i) as Boolean);
               productData.type = MarketMenuData.TYPE_CALLSIGN_BADGE;
               this.mBadgeSlots[i].setData(productData);
            }
         }
         if(this.mSelectedSlot != this.myConsumableSlot && Boolean(this.mSelectedSlot.getData().isLocked))
         {
            this.onBadgeSlotClicked(0);
         }
      }
      
      private function onSlotClicked(slot:LoadoutButton) : void
      {
         if(this.mSelectedSlot != slot && this.mSelectedSlot != null)
         {
            this.mSelectedSlot.toggled = false;
            this.mSelectedSlot = slot;
            this.mSelectedSlot.toggled = true;
            this.updateGrid();
            return;
         }
      }
      
      private function onBadgeSlotClicked(index:int) : void
      {
         var unlockData:ProductObj = null;
         if(!this.mBadgeSlots[index].getData().isLocked)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_BADGE_SLOT_SELECTED,index);
            this.onSlotClicked(this.mBadgeSlots[index]);
         }
         else
         {
            unlockData = CFunctionCommonContainer.GetItemInfo(CFunctionCommonContainer.WL_GetMarketItemIdForBadgeIndex(index));
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":unlockData});
         }
      }
      
      private function updateGrid() : void
      {
         if(this.mSelectedSlot == this.myConsumableSlot)
         {
            this.showConsumables();
         }
         else
         {
            this.showBadges();
         }
      }
      
      protected function showConsumables() : void
      {
         var categoryArr:Array = [{
            "id":MarketMenuData.GRP_EQUIPPABLE_TOKEN,
            "label":DictMarket.MARKET_ITEM_ADVANCED_CONSUMABLE
         }];
         UiCppItemListView(_uiCpp).SetInitData(categoryArr,true);
      }
      
      protected function showBadges() : void
      {
         var categoryArr:Array = [{
            "id":MarketMenuData.TYPE_CALLSIGN_BADGE,
            "label":DictCareer.CAREER_BADGES
         }];
         UiCppItemListView(_uiCpp).SetInitData(categoryArr,true);
      }
   }
}

