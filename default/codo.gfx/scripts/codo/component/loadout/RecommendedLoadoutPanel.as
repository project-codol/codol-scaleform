package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.CallToActionButton;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.filter.Filter;
   import codo.component.filter.FilterCategoryButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.cpp.UiCppSuggestedLoadoutView;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.BindDataHelper;
   import codo.objects.ProductObj;
   import codo.objects.SuggestedLoadoutTypeObj;
   import codo.services.WeaponLoadoutService;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class RecommendedLoadoutPanel extends MovieClip
   {
      
      private static const LOADOUT_WIDTH:Number = 1354;
      
      private static const LOADOUT_HEIGHT:Number = 849;
      
      public var myLoadout:LoadoutDisplay;
      
      public var myPlaystyleTF:TextField;
      
      public var mySelectionTitleTF:TextField;
      
      public var mySelectionDescTF:TextField;
      
      public var myOwnedSubtitleTF:TextField;
      
      public var myCallToActionButton:CallToActionButton;
      
      public var myFractionOwnedTF:TextField;
      
      public var myLegendOwnedTF:TextField;
      
      public var myLegendUnownedTF:TextField;
      
      public var myLegendPurchaseTF:TextField;
      
      public var myLegendEquippedTF:TextField;
      
      public var myLoadoutsFilter:Filter;
      
      private var mLoadoutType:SuggestedLoadoutTypeObj;
      
      private var mItems:Array = [];
      
      private var mIsSkuId:Boolean = false;
      
      private var mOwnAllItems:Boolean;
      
      private var mBindWeaponLoadoutSlotsData:BindDataHelper;
      
      public function RecommendedLoadoutPanel()
      {
         super();
         this.mOwnAllItems = false;
         this.mBindWeaponLoadoutSlotsData = new BindDataHelper(DataID.MARKET_UPDATE_INVENTORY,this.onInventoryUpdated);
         this.myLoadout.setIsSuggestedLoadout();
         this.myLoadout.width = LOADOUT_WIDTH;
         this.myLoadout.height = LOADOUT_HEIGHT;
         this.myOwnedSubtitleTF.text = "@SF_UI_SUGGESTED_LOADOUT_NUM_OWNED";
         this.myLegendOwnedTF.text = "@SF_UI_SUGGESTED_LOADOUT_OWNED_CAPS";
         this.myLegendUnownedTF.text = "@SF_UI_SUGGESTED_LOADOUT_UNOWNED_CAPS";
         this.myLegendPurchaseTF.text = "@SF_UI_SUGGESTED_LOADOUT_CLICK_TO_BUY";
         this.myLegendEquippedTF.text = "@SF_UI_SUGGESTED_LOADOUT_EQUIPPED";
         this.myLoadoutsFilter.singleOptionMode = true;
         this.myLoadout.registerSelectPrimaryEvent(this.onWpnClick,null);
         this.myLoadout.registerSelectSecondaryEvent(this.onWpnClick,null);
         this.myLoadout.registerEditPrimaryAttachmentEvent(this.onPriAttachClick,null);
         this.myLoadout.registerEditSecondaryAttachmentEvent(this.onSecAttachClick,null);
         this.myLoadout.registerEditPerkEvent(this.onPerkClick,null);
         this.myLoadout.registerEditLethalEvent(this.onLethalClick,null);
         this.myLoadout.registerEditTacticalEvent(this.onTacticalClick,null);
         this.myLoadout.registerFocusEvent(this.onLoadoutSlotFocused);
         this.myLoadout.registerUnfocusEvent(this.onLoadoutSlotUnfocused);
         this.myCallToActionButton.setClickCallback(this.onCallToActionButtonClicked);
         this.myCallToActionButton.visible = false;
         this.myCallToActionButton.width = 150;
      }
      
      public function setLoadoutType(data:SuggestedLoadoutTypeObj) : void
      {
         this.mLoadoutType = data;
         this.myPlaystyleTF.text = LocalizeUtil.localize(data.label).toUpperCase();
         this.mySelectionDescTF.text = LocalizeUtil.localize(data.desc).toUpperCase();
      }
      
      public function getLoadoutType() : SuggestedLoadoutTypeObj
      {
         return this.mLoadoutType;
      }
      
      public function updateSelectionTitle(items:Array, isSkuId:Boolean) : void
      {
         var item:int = 0;
         var productObj:ProductObj = null;
         this.mItems = items;
         this.mIsSkuId = isSkuId;
         var total:int = int(items.length);
         var owned:int = 0;
         for(var i:int = 0; i < items.length; i++)
         {
            item = int(items[i]);
            productObj = CFunctionCommonContainer.GetItemInfo(item);
            if(productObj.isOwned())
            {
               owned++;
            }
         }
         this.onInventoryUpdated(null);
         this.myFractionOwnedTF.text = owned.toString().toUpperCase() + "/" + total.toString().toUpperCase();
         var curCat:FilterCategoryButton = this.myLoadoutsFilter.currentCategory;
         var dataObj:Object = curCat.getData();
         var type:String = LocalizeUtil.localize(this.mLoadoutType.label);
         var num:String = (curCat.selectedIndex + 1).toString();
         var level:String = dataObj.label;
         if(this.mLoadoutType.id != UiCppSuggestedLoadoutView.STYLE_HOT)
         {
            this.mySelectionTitleTF.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_SUGGESTED_LOADOUT_TITLE"),[type,num,level]).toUpperCase();
         }
         else
         {
            this.mySelectionTitleTF.text = LocalizeUtil.localize("@SF_UI_SUGGESTED_LOADOUT_4");
         }
      }
      
      public function initList(data:Array) : void
      {
         this.myLoadoutsFilter.setData(data);
         this.myLoadoutsFilter.width = 283;
      }
      
      private function tryBuy(prod:ProductObj) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prod});
      }
      
      private function onWpnClick(slot:LoadoutWeaponSlot) : void
      {
         if(slot.ignoringMouse())
         {
            return;
         }
         var prod:ProductObj = slot.getData();
         this.tryBuy(prod);
      }
      
      private function tryBuyButton(btn:LoadoutButton) : void
      {
         if(btn.ignoringMouse())
         {
            return;
         }
         var slot:Object = btn.getData();
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(slot.item_id);
         this.tryBuy(prod);
      }
      
      private function onPriAttachClick(id:int) : void
      {
         this.tryBuyButton(this.myLoadout.mPriAttaches[id]);
      }
      
      private function onSecAttachClick(id:int) : void
      {
         this.tryBuyButton(this.myLoadout.mSecAttaches[id]);
      }
      
      private function onPerkClick(data:Object) : void
      {
         this.tryBuyButton(this.myLoadout.mPerks[data.slot][data.perk]);
      }
      
      private function onLethalClick(id:int) : void
      {
         this.tryBuyButton(this.myLoadout.mLethals[id]);
      }
      
      private function onTacticalClick(id:int) : void
      {
         this.tryBuyButton(this.myLoadout.mTacticals[id]);
      }
      
      protected function onLoadoutSlotFocused(item:UIInteractiveComponent) : void
      {
         var slotItemID:int = Boolean(item.getData().item_id) ? int(item.getData().item_id) : int(item.getData().id);
         var data:ProductObj = slotItemID > 0 ? CFunctionCommonContainer.GetItemInfo(slotItemID) : null;
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
            "product":data,
            "compare":true
         });
      }
      
      protected function onLoadoutSlotUnfocused() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      protected function onInventoryUpdated(cResult:Object) : void
      {
         var item:int = 0;
         var productObj:ProductObj = null;
         this.mOwnAllItems = true;
         if(this.mItems == null || this.mItems.length == 0)
         {
            this.myCallToActionButton.visible = false;
            return;
         }
         this.myCallToActionButton.visible = true;
         for(var i:int = 0; i < this.mItems.length; i++)
         {
            item = int(this.mItems[i]);
            productObj = CFunctionCommonContainer.GetItemInfo(item);
            if(!productObj.isOwned())
            {
               this.mOwnAllItems = false;
               break;
            }
         }
         if(this.mOwnAllItems)
         {
            this.myCallToActionButton.label = Dict.EQUIP_ITEM;
         }
         else
         {
            this.myCallToActionButton.label = DictMarket.BUY_REMAINDERS;
         }
      }
      
      protected function onCallToActionButtonClicked() : void
      {
         if(this.mOwnAllItems)
         {
            this.onEquipRecommendedLoadout();
         }
         else
         {
            this.onPurchaseRecommendedLoadoutRemainders();
         }
      }
      
      protected function onEquipRecommendedLoadout() : void
      {
         CFunctionContainer.WL_EquipRecommendLoadout(this.mItems);
         EventManager.getInstance().broadcast(BCEvent.EVT_CLOSE_RECOMMENTED_LOADOUT_POPUP);
         WeaponLoadoutService.getInstance().invalidateWeaponLoadOutSlotsData();
      }
      
      protected function onPurchaseRecommendedLoadoutRemainders() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_RECOMMENDED_LOADOUT_PURCHASE_REMAINDER_ITEMS_POPUP,{
            "items":this.mItems,
            "isSkuId":this.mIsSkuId
         });
      }
   }
}

