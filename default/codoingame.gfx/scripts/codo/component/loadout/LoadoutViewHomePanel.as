package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.ComboBox;
   import codo.component.filter.LoadoutFilter;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.cpp.UiCppOnboarding;
   import codo.cpp.UiCppSuggestedLoadoutView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.manager.EventManager;
   import codo.objects.BindDataHelper;
   import codo.objects.FilterObj;
   import codo.objects.ProductObj;
   import codo.objects.SuggestedLoadoutTypeObj;
   import codo.services.WeaponLoadoutService;
   import codo.style.GlobalGuide;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TimeUtil;
   import flash.text.TextField;
   
   public class LoadoutViewHomePanel extends LoadoutPanel
   {
      
      private static const INSTRUCTIONS_WIDTH:Number = 430;
      
      public var myLoadoutFilter:LoadoutFilter;
      
      public var myRecommendedSelector:RecommendedLoadoutSelector;
      
      public var myRecommendedTitleTF:TextField;
      
      public var myRecommendedDescTF:TextField;
      
      private var m_bindLoadoutSlots:BindDataHelper;
      
      public function LoadoutViewHomePanel()
      {
         super();
         this.m_bindLoadoutSlots = new BindDataHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.bindLoadoutSlots);
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         myLoadout.registerLoadoutCopiedCb(this.onLoadoutCopied);
         myLoadout.registerFocusEvent(onLoadoutSlotFocused);
         myLoadout.registerUnfocusEvent(onLoadoutSlotUnfocused);
         myLoadoutMelee.registerFocusEvent(onLoadoutSlotFocused);
         myLoadoutMelee.registerUnfocusEvent(onLoadoutSlotUnfocused);
         this.myLoadoutFilter.addOnSubCategoryCheckedCallback(this.onLoadoutSelected);
         this.myLoadoutFilter.addOnCharacterSelectCallback(this.onCharacterSelected);
         this.myLoadoutFilter.setCancelCategoryChange(this.checkCancelLoadout);
         this.myRecommendedSelector.label = LocalizeUtil.localize("@SF_UI_LOADOUT_SELECT_PLAYSTYLE").toUpperCase();
         this.myRecommendedSelector.preserveIndex = false;
         this.myRecommendedSelector.clearOnSelect = true;
         this.myRecommendedSelector.singleOptionMode = true;
         this.myRecommendedSelector.addEventListener(ComboBox.EVT_CHANGE,this.onRecommendedLoadoutSelected);
         this.myRecommendedTitleTF.text = LocalizeUtil.localize("@SF_UI_SUGGESTED_LOADOUT_TYPES_TITLE").toUpperCase();
         this.myRecommendedDescTF.text = LocalizeUtil.localize("@SF_UI_LOADOUT_RECOMMENDED_DESC").toUpperCase();
         var suggestedStyles:Vector.<SuggestedLoadoutTypeObj> = UiCppSuggestedLoadoutView.getStyles();
         this.myRecommendedSelector.dataProvider = DataUtil.copyElems([],suggestedStyles);
         myLoadoutName.width = INSTRUCTIONS_WIDTH;
         myInstructions.width = INSTRUCTIONS_WIDTH;
         myInstructions.height = 50;
         myInstructions.text = LocalizeUtil.localize(Dict.LOADOUT_INSTRUCTIONS);
         myLoadoutName.text = "";
      }
      
      override protected function editSlotAction(categories:Array, item:ProductObj = null, slot:String = "", isPrimary:Boolean = true) : void
      {
         var data:Object = null;
         if(item != null && slot != MarketMenuData.SLOT_PRIMARY && slot != MarketMenuData.SLOT_SECONDARY && slot != MarketMenuData.SLOT_MELEE)
         {
            this.gotoCustomizeView(item,slot,isPrimary);
         }
         else
         {
            data = {};
            data.categories = categories;
            data.slot = slot;
            myLoadout.clearCopyCache();
            EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_LOADOUT_WEAPON,data);
         }
      }
      
      protected function checkCancelLoadout(loadoutIndex:int) : Boolean
      {
         var data:ProductObj = null;
         var isUnlocked:Boolean = CFunctionCommonContainer.WL_GetIsLoadoutSlotUnlocked(loadoutIndex) as Boolean;
         if(!isUnlocked)
         {
            data = CFunctionCommonContainer.GetItemInfo(CFunctionCommonContainer.WL_GetMarketItemIdForLoadoutIndex(loadoutIndex));
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":data});
            return true;
         }
         return false;
      }
      
      private function onLoadoutSelected(loadoutIndex:int) : void
      {
         WeaponLoadoutService.getInstance().changeLoadout(loadoutIndex);
      }
      
      private function onRecommendedLoadoutSelected(cEvt:ParaEvent) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_RECOMMENDED_LOADOUT_POPUP,this.myRecommendedSelector.selectedData);
      }
      
      protected function bindLoadoutSlots(result:Object) : void
      {
         var data:Object = result.data;
         myLoadoutName.text = data.name;
         var currentLoadoutIndex:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         if(this.myLoadoutFilter.currentCategoryIndex != currentLoadoutIndex)
         {
            this.refreshLoadouts();
         }
         this.showLoadoutInstruction();
      }
      
      override protected function setSelectedTab(index:int) : void
      {
         super.setSelectedTab(index);
         this.showLoadoutInstruction();
      }
      
      private function showLoadoutInstruction() : void
      {
         var meleeKey:String = null;
         var rentalSlotData:ProductObj = null;
         var currentLoadoutIndex:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         if(myLoadout.visible)
         {
            myInstructions.text = LocalizeUtil.localize(Dict.LOADOUT_INSTRUCTIONS);
         }
         else
         {
            meleeKey = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee").toUpperCase();
            LocalizeUtil.paramColorized(myInstructions.myTextClip,Dict.STORAGE_MELEE_USAGE_DESCRIPTION,[meleeKey,meleeKey],[GlobalGuide.WHITE,GlobalGuide.WHITE]);
         }
         var rentalSlotID:int = CFunctionCommonContainer.WL_GetMarketItemIdForLoadoutIndex(currentLoadoutIndex);
         if(rentalSlotID > 0)
         {
            rentalSlotData = CFunctionCommonContainer.GetItemInfo(rentalSlotID);
            if(rentalSlotData.isOwnedRental())
            {
               myInstructions.myTextClip.appendText("\n" + TimeUtil.convertTimeRemainingToHHMMSS(rentalSlotData.remainSecond,false));
            }
         }
      }
      
      private function onCharacterSelected() : void
      {
         this.refreshLoadouts();
      }
      
      private function initOnboardLock(loadouts:Array, idx:int, feature:String) : void
      {
         var obj:FilterObj = loadouts[idx];
         obj.onboardLock = feature;
         obj.locked = CFunctionCommonContainer.GetOnboardUnlockLevel(feature) != null;
      }
      
      private function refreshLoadouts() : void
      {
         var optionData:FilterObj = null;
         var loadoutIndex:int = 0;
         var loadoutName:String = null;
         var currentCharacterIndex:int = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
         var filters:Array = new Array();
         var maxNumSlots:int = CFunctionCommonContainer.WL_GetMaxNumLoadouts();
         var currentLoadoutIndex:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         for(var i:int = 0; i < maxNumSlots; i++)
         {
            loadoutIndex = currentCharacterIndex * maxNumSlots + i;
            loadoutName = CFunctionContainer.WL_GetLoadoutName(loadoutIndex,i);
            optionData = new FilterObj(i,loadoutName);
            optionData.lockedForPurchase = !(CFunctionCommonContainer.WL_GetIsLoadoutSlotUnlocked(i) as Boolean);
            filters.push(optionData);
            if(currentLoadoutIndex == i)
            {
               myLoadoutName.text = loadoutName;
            }
         }
         this.initOnboardLock(filters,1,UiCppOnboarding.FEATURE_LOADOUT_2);
         this.initOnboardLock(filters,2,UiCppOnboarding.FEATURE_LOADOUT_3);
         this.myLoadoutFilter.SetCategories(filters,currentLoadoutIndex);
         onLoadoutSlotUnfocused();
      }
      
      override protected function enableData() : void
      {
         if(true == ScaleformUtil.isScaleform)
         {
            this.myLoadoutFilter.refreshCharacters(this);
            this.refreshLoadouts();
            this.onLoadoutSelected(this.myLoadoutFilter.currentCategoryIndex);
            myLoadout.enableData();
            myLoadout.clearCopyCache();
            myLoadoutMelee.enableData();
            EventManager.getInstance().listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangeHandle);
            this.m_bindLoadoutSlots.bind();
         }
      }
      
      override protected function disableData() : void
      {
         this.m_bindLoadoutSlots.unbind();
         myLoadout.disableData();
         myLoadoutMelee.disableData();
         EventManager.getInstance().unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangeHandle);
      }
      
      private function onInventoryChangeHandle(cEvt:ParaEvent) : void
      {
         this.refreshLoadouts();
      }
      
      private function gotoCustomizeView(item:ProductObj, slot:String, isPrimary:Boolean) : void
      {
         var routeData:Object = {
            "itemData":item,
            "slot":slot,
            "slotIsPrimary":isPrimary
         };
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_SHOW_DETAILS,routeData);
         myLoadout.clearCopyCache();
      }
      
      private function onLoadoutCopied() : void
      {
         this.onLoadoutSelected(this.myLoadoutFilter.currentCategoryIndex);
         this.refreshLoadouts();
      }
   }
}

