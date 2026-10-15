package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.ComboBox;
   import codo.component.ExperienceBar;
   import codo.component.FilteredList;
   import codo.component.ItemLevelDisplay;
   import codo.component.MarketItemModule;
   import codo.component.MarketSupplyDropModule;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceDiscountItemPromoTag;
   import codo.component.marketplaceitem.parts.MarketplaceItemRentalStatus;
   import codo.component.object.NavigationObj;
   import codo.component.scrollgrid.parts.ScrollListNavArrow;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.constants.SE_ID;
   import codo.constants.table.UINotifications;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppView;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ItemBuffListObj;
   import codo.objects.ItemBuffObj;
   import codo.objects.ProductObj;
   import codo.objects.SKUObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.WeaponStatsObj;
   import codo.services.TutorialService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import fsg.util.FsgImageHolder;
   
   public class MarketplaceItemDetailsView extends ItemDetailsBaseView implements IUiCppItemListView
   {
      
      private static const BOTTOM_Y:Number = 971;
      
      private static const BUFF_ICON_SIZE:int = 64;
      
      private static const BUTTON_WIDTH:Number = 200;
      
      private static const EQUIP_BUTTON_WIDTH:Number = 108;
      
      private static const OFFSET_X:Number = 490;
      
      private static const BUFF_ICON_ITEM_Y:int = 579;
      
      private static const BUFF_ICON_CHARACTER_Y:int = 719;
      
      public var myBundleButton:Button;
      
      public var myTrainingButton:Button;
      
      public var myEquipButton:Button;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myOptions:ComboBox;
      
      public var myBuyButton:CallToActionButton;
      
      public var myBundleText:TextField;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myLevelDisplay:ItemLevelDisplay;
      
      public var myItemDebugText:TextField;
      
      public var myXPBar:ExperienceBar;
      
      public var myItemModule:MarketItemModule;
      
      public var mySupplyDropModule:MarketSupplyDropModule;
      
      public var myBuffs:MovieClip;
      
      public var myItemListBackground:MovieClip;
      
      public var myLeftNavArrow:ScrollListNavArrow;
      
      public var myRightNavArrow:ScrollListNavArrow;
      
      public var myDefaultPriceDisplay:MarketplaceItemRentalStatus;
      
      public var myDiscountTag:MarketplaceDiscountItemPromoTag;
      
      public var myWeaponBrandIcon:FsgImageHolder;
      
      private var mItemData:ProductObj;
      
      private var mItemSiblings:Vector.<ProductObj>;
      
      private var mWeaponStats:WeaponStatsObj;
      
      private var mTurntableTimeout:uint;
      
      private var mItemBuffs:Vector.<ItemBuffObj>;
      
      private var mFilteredList:FilteredList;
      
      private var mOffsetApplied:Boolean = false;
      
      private var mFocusTimeout:uint;
      
      private var _loadoutSlot:String;
      
      private var _slotIsPrimary:Boolean;
      
      private var _focusModel:TweenLite;
      
      private var _modelFocused:Boolean;
      
      private var _modelOffset:int = 0;
      
      public function MarketplaceItemDetailsView()
      {
         super();
         this.initStage();
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         this.myRightNavArrow.alpha = this.myLeftNavArrow.alpha = 0.75;
         this.myBundleText.textStyle = GlobalGuide.styleTextSmall;
         this.myBundleText.text = DictMarket.MARKETPLACE_ITEM_PART_OF_A_BUNDLE;
         this.myBundleButton.label = Dict.FRIEND_VIEW_DETAIL;
         this.myBundleButton.registerClickEvent(onBackButtonClicked);
         this.myBuyButton.registerClickEvent(this.onBuyClicked);
         this.myBuyButton.audioRef.overrideClickAudio(SE_ID.UI_MARKET_PURCHASE_CLICK);
         this.myBuyButton.width = BUTTON_WIDTH;
         this.myTrainingButton.label = LocalizeUtil.localize("@MPUI_TRAIN");
         this.myTrainingButton.registerClickEvent(this.onTrainingClicked);
         this.myTrainingButton.width = BUTTON_WIDTH;
         this.myEquipButton.label = LocalizeUtil.localize(Dict.EQUIP_ITEM);
         this.myEquipButton.registerClickEvent(this.onEquipButtonClicked);
         this.myEquipButton.width = EQUIP_BUTTON_WIDTH;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.alignment = TextStyle.HALIGN_LEFT;
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myItemCountLabel.alignment = TextStyle.HALIGN_LEFT;
         this.myItemCountLabel.width = 250;
         this.myItemCountLabel.text = DictMarket.MARKETPLACE_AVAILABLE_ATTACHMENTS;
         this.myScrollGrid.listItemFocusCallback = this.onListItemFocus;
         this.myScrollGrid.listItemUnfocusCallback = this.onListItemUnfocus;
         this.myLeftNavArrow.registerClickEvent(this.onNavArrowClick,-1);
         this.myRightNavArrow.registerClickEvent(this.onNavArrowClick,1);
         this.myOptions.showSelectionInHeader = true;
         this.myOptions.singleOptionMode = true;
         this.myOptions.clearOnSelect = false;
         this.myOptions.width = 177;
         this.myOptions.listWidth = 140;
         this.myOptions.preserveIndex = true;
         this.myWeaponBrandIcon.keepWHRatio = true;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         this.mFilteredList = new FilteredList(this.myScrollGrid,this.myOptions);
         return new UiCppItemListView(this,null,null,this.mFilteredList);
      }
      
      override public function set routeData(data:*) : void
      {
         var itemIsInBundle:Boolean = false;
         var categories:Array = null;
         var imgHolder:FsgImageHolder = null;
         var sibIdx:int = 0;
         var sib:ProductObj = null;
         var weaponObject:Object = null;
         var maxLevel:int = 0;
         var levelProgress:Number = NaN;
         var func:int = 0;
         var buff:ItemBuffObj = null;
         var weaponBrandObj:Object = null;
         super.routeData = data;
         if(!data.useExistingData)
         {
            this.mItemData = data.itemData;
            this._loadoutSlot = data.slot;
            this._slotIsPrimary = data.slotIsPrimary;
         }
         this.mItemSiblings = new Vector.<ProductObj>(0);
         if(this.mItemData.listSiblings != null)
         {
            for(sibIdx = 0; sibIdx < this.mItemData.listSiblings.length; sibIdx++)
            {
               sib = this.mItemData.listSiblings[sibIdx];
               if(sib.fullscreenDetailsEnabled())
               {
                  this.mItemSiblings.push(sib);
               }
            }
         }
         this.myLeftNavArrow.visible = this.myRightNavArrow.visible = this.myLeftNavArrow.mouseEnabled = this.myRightNavArrow.mouseEnabled = this.myLeftNavArrow.mouseChildren = this.myRightNavArrow.mouseChildren = this.mItemSiblings.length > 1;
         CFunctionCommonContainer.AS_UIViewerSetItemDetailsID(this.mItemData.id);
         ProductObj.setMarketDetailsItem(this.mItemData,this._loadoutSlot != null);
         this.mFilteredList.setFilterIdx(0);
         TutorialService.getInstance().enableToolTip(UINotifications.ONBOARD_HELP_SELECT_ATTACHMENT,this._loadoutSlot == MarketMenuData.SLOT_ATTACH[0]);
         TutorialService.getInstance().enableToolTip(UINotifications.ONBOARD_HELP_SELECT_ATTACHMENT_2,this._loadoutSlot == MarketMenuData.SLOT_ATTACH[1]);
         this.myItemModule.visible = false;
         myCharacterModule.visible = false;
         this.mySupplyDropModule.visible = false;
         this.myItemListBackground.visible = false;
         if(this.mItemData.type == MarketMenuData.TYPE_CHARACTER)
         {
            myCharacterModule.setData(this.mItemData);
            myCharacterModule.visible = true;
            this.myBuffs.y = BUFF_ICON_CHARACTER_Y;
         }
         else
         {
            this.myItemModule.setData(this.mItemData);
            this.myItemModule.visible = true;
            this.myBuffs.y = BUFF_ICON_ITEM_Y;
         }
         if(this.mItemData.type == ItemType.WEAPON && (this.mItemData.level > 0 || this.mItemData.isBought))
         {
            this.myLevelDisplay.visible = true;
            this.myLevelDisplay.level = this.mItemData.level;
            this.myLevelDisplay.tier = this.mItemData.tier;
            if(this.mItemData.isOwned())
            {
               weaponObject = CFunctionCommonContainer.GetItemInfo(this.mItemData.id);
               maxLevel = int(weaponObject.maxLevel);
               levelProgress = weaponObject.level == maxLevel ? 1 : weaponObject.currentExp / weaponObject.totalExp;
               this.myXPBar.visible = true;
               this.myXPBar.setProgress(levelProgress);
               this.myXPBar.setExperiencePoints(weaponObject.currentExp,weaponObject.totalExp);
               this.myXPBar.setTier(this.mItemData.tier);
            }
            else
            {
               this.myXPBar.visible = false;
            }
         }
         else
         {
            this.myLevelDisplay.visible = false;
            this.myXPBar.visible = false;
         }
         itemIsInBundle = this.isInBundle();
         this.myBundleButton.visible = itemIsInBundle;
         this.myBundleText.visible = itemIsInBundle;
         this.myBuyButton.visible = this.mItemData.purchaseUiEnabled();
         this.testForShowDefaultPrice(this.mItemData);
         this.myBuyButton.label = this.mItemData.isOwnedRental() ? DictMarket.EXTEND : DictMarket.PURCHASE;
         var discountTxt:String = ItemUtil.getItemSaleValueBySku(this.mItemData.SKUs);
         if(!this.mItemData.ignoreDiscount && discountTxt != null && this.myBuyButton.visible)
         {
            this.myDiscountTag.visible = true;
            this.myDiscountTag.discount = discountTxt;
         }
         else
         {
            this.myDiscountTag.visible = false;
         }
         this.myEquipButton.visible = !this.isInCustomizeMode() && this.mItemData.equipUiEnabled();
         this.myTrainingButton.visible = false;
         var buttons:Vector.<Button> = new <Button>[this.myBuyButton,this.myEquipButton,this.myTrainingButton];
         var curX:Number = 1803;
         for(var btnIdx:int = 0; btnIdx < buttons.length; btnIdx++)
         {
            if(buttons[btnIdx].visible)
            {
               curX -= buttons[btnIdx].width;
               buttons[btnIdx].x = curX;
               curX -= 10;
            }
         }
         if(this.mItemData.type == MarketMenuData.TYPE_WEAPON)
         {
            this.mWeaponStats = new WeaponStatsObj(this.mItemData);
            if(this._loadoutSlot != null)
            {
               func = this._slotIsPrimary ? UiCppItemListView.FUNC_USE_WPN_PRI : UiCppItemListView.FUNC_USE_WPN_SEC;
               if(this._loadoutSlot == MarketMenuData.SLOT_CAMO)
               {
                  categories = [{
                     "aggregate":true,
                     "categoryFunc":func,
                     "child":[{
                        "id":this._loadoutSlot,
                        "label":Dict.WEAPONLOADOUT_CAMO
                     }]
                  }];
               }
               else if(this._loadoutSlot == MarketMenuData.SLOT_COSMETIC)
               {
                  categories = [{
                     "aggregate":true,
                     "categoryFunc":func,
                     "child":[{
                        "id":this._loadoutSlot,
                        "label":Dict.WEAPONLOADOUT_RETICULE
                     }]
                  }];
               }
               else if(this._loadoutSlot == MarketMenuData.SLOT_COSMETIC2)
               {
                  categories = [{
                     "aggregate":true,
                     "categoryFunc":func,
                     "child":[{
                        "id":this._loadoutSlot,
                        "label":Dict.WEAPONLOADOUT_DECAL
                     }]
                  }];
               }
               else
               {
                  categories = [{
                     "id":this._loadoutSlot,
                     "categoryFunc":func,
                     "child":MarketMenuData.ATTACHMENT_FILTERS
                  }];
               }
               UiCppItemListView(_uiCpp).SetInitData(categories,true);
            }
            else
            {
               categories = [{
                  "aggregate":true,
                  "child":[{
                     "allItems":true,
                     "label":DictMarket.CATEGORY_ALL
                  },{
                     "id":MarketMenuData.SLOT_ATTACH[0],
                     "label":DictMarket.MARKETPLACE_DETAILS_ATTACHMENTS
                  },{
                     "id":MarketMenuData.SLOT_CAMO,
                     "label":Dict.WEAPONLOADOUT_CAMO
                  },{
                     "id":MarketMenuData.SLOT_COSMETIC,
                     "label":Dict.WEAPONLOADOUT_RETICULE
                  }]
               }];
               UiCppItemListView(_uiCpp).SetInitData(categories,false,true);
            }
         }
         else
         {
            UiCppItemListView(_uiCpp).SetInitData([],false,true);
            this.mFilteredList.setFilters(new Vector.<NavigationObj>(0));
            this.setupItemList(null);
         }
         if(true == ScaleformUtil.IsLogItemIDEnabled())
         {
            this.myItemDebugText.visible = true;
            this.myItemDebugText.width = 960;
            this.onRadioClicked(0);
         }
         else
         {
            this.myItemDebugText.visible = false;
         }
         this.myBuyButton.y = BOTTOM_Y - this.myBuyButton.height;
         this.clearBuffs();
         var imgClass:Class = getDefinitionByName("fsg.widget.comboboxImageHolder") as Class;
         var i:int = 0;
         curX = 0;
         this.mItemBuffs = ItemBuffListObj.getBuffs(this.mItemData);
         for(var len:int = int(this.mItemBuffs.length); i < len; )
         {
            imgHolder = new imgClass() as FsgImageHolder;
            imgHolder.width = imgHolder.height = BUFF_ICON_SIZE;
            buff = this.mItemBuffs[i];
            imgHolder.setImage(buff.icon);
            imgHolder.addEventListener(MouseEvent.MOUSE_OVER,this.onBuffMouseOver);
            imgHolder.addEventListener(MouseEvent.MOUSE_OUT,this.onBuffMouseOut);
            imgHolder.x = curX;
            this.myBuffs.addChild(imgHolder);
            curX += imgHolder.width;
            i++;
         }
         var mode:uint = Common.UIVIEWER_MODE_ITEM_DETAILS;
         switch(this.mItemData.type)
         {
            case ItemType.CHA:
               mode = Common.UIVIEWER_MODE_CHAR_DETAILS;
               break;
            case ItemType.WEAPON:
               mode = this.isInCustomizeMode() ? Common.UIVIEWER_MODE_WEAPON_LOADOUT : Common.UIVIEWER_MODE_WEAPON_DETAILS;
         }
         this.myWeaponBrandIcon.visible = false;
         if(this.mItemData.type == ItemType.WEAPON)
         {
            weaponBrandObj = CFunctionContainer.AS_GetWeaponBrandDataByWeaponID(this.mItemData.id);
            if(weaponBrandObj != null)
            {
               this.myWeaponBrandIcon.visible = true;
               this.myWeaponBrandIcon.setImage(weaponBrandObj.icon);
            }
         }
         broadcast(BCEvent.EVT_SET_UIVIEWER_MODE,{
            "mode":mode,
            "status":Common.UIVIEWER_POS_NONE,
            "gametype":-1
         });
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         if(ScaleformUtil.isScaleform)
         {
            this.mTurntableTimeout = setTimeout(this.timeoutEnableTurntable,1000);
            listen(BCEvent.EVT_EQUIPPED,this.onEquip);
            listen(BCEvent.EVT_ITEM_REMOVED_FROM_INVENTORY,this.onItemRemovedFromInventory);
            listen(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.updatePreviewStats);
            listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.refreshView);
         }
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         if(ScaleformUtil.isScaleform)
         {
            clearTimeout(this.mTurntableTimeout);
            clearTimeout(this.mFocusTimeout);
            unlisten(BCEvent.EVT_EQUIPPED,this.onEquip);
            unlisten(BCEvent.EVT_ITEM_REMOVED_FROM_INVENTORY,this.onItemRemovedFromInventory);
            this.mWeaponStats = null;
            unlisten(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.updatePreviewStats);
            unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.refreshView);
            if(this.mItemData.type == ItemType.WEAPON)
            {
               broadcast(BCEvent.EVT_PREVIEW_REMOVE,{"item":this.mItemData});
            }
         }
         if(this.myItemModule != null)
         {
            this.myItemModule.clearDualStatsTimer();
         }
         ProductObj.setMarketDetailsItem(null);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.focusModel(false,0);
         CFunctionContainer.UIViewer_SetModelOffset(0);
      }
      
      protected function onEquip(evt:ParaEvent) : void
      {
         onBackButtonClicked();
      }
      
      protected function onItemRemovedFromInventory(evt:ParaEvent) : void
      {
         var removedItemID:int = int(evt.myPara.id);
         var bWasEquipped:Boolean = Boolean(evt.myPara.bWasEquipped);
         var removedItemData:ProductObj = CFunctionCommonContainer.GetItemInfo(removedItemID);
         if(removedItemID == this.mItemData.id)
         {
            onBackButtonClicked();
         }
         else if(bWasEquipped && (this.isInCustomizeMode() || this.mItemData.equipUiEnabled()) && (removedItemData.type == MarketMenuData.TYPE_CHARACTER || removedItemData.group == MarketMenuData.GRP_LOADOUT_SLOT))
         {
            onBackButtonClicked();
         }
      }
      
      protected function updatePreviewStats(evt:ParaEvent) : void
      {
         var items:Array = null;
         var attachmentID:int = 0;
         var i:int = 0;
         var modifiedStats:WeaponStatsObj = null;
         if(this.mItemData.type == ItemType.WEAPON)
         {
            items = evt.myPara as Array;
            attachmentID = 0;
            for(i = 0; i < items.length; i++)
            {
               if(items[i].type == ItemType.WAT)
               {
                  attachmentID = int(items[i].id);
                  break;
               }
            }
            if(this.mWeaponStats != null)
            {
               modifiedStats = new WeaponStatsObj(this.mItemData,true,false,attachmentID);
               this.myItemModule.refreshStats(this.mWeaponStats,modifiedStats);
            }
         }
      }
      
      protected function refreshView() : void
      {
         _flagResetRotation = true;
         var itemData:ProductObj = CFunctionCommonContainer.GetItemInfo(this.mItemData.id);
         itemData.listSiblings = this.mItemData.listSiblings;
         var data:Object = {
            "itemData":itemData,
            "slot":this._loadoutSlot,
            "slotIsPrimary":this._slotIsPrimary
         };
         this.routeData = data;
         CFunctionCommonContainer.AS_UIViewerEnableTurntable(false);
         clearTimeout(this.mTurntableTimeout);
         this.mTurntableTimeout = setTimeout(this.timeoutEnableTurntable,1000);
      }
      
      private function onListItemUnfocus(item:*) : void
      {
         clearTimeout(this.mFocusTimeout);
      }
      
      private function onListItemFocus(item:*) : void
      {
         if(this.mItemData.type == MarketMenuData.TYPE_WEAPON && !this._modelFocused)
         {
            clearTimeout(this.mFocusTimeout);
            this.mFocusTimeout = setTimeout(this.listItemFocusedHandler,100,item);
         }
      }
      
      private function listItemFocusedHandler(item:*) : void
      {
         EventManager.broadcast(BCEvent.EVT_EQUIP,{
            "item":item,
            "isPreviewing":true,
            "isLoadoutView":this.isInCustomizeMode()
         });
      }
      
      private function setupItemList(items:Array) : void
      {
         var listSettings:ScrollGridSettings = null;
         var itemRenderer:Function = null;
         this.myScrollGrid.visible = false;
         this.myItemCount.visible = false;
         this.myItemCountLabel.visible = false;
         this.myOptions.visible = false;
         this.myItemModule.myItemListBackground.visible = false;
         if(items != null && items.length > 0)
         {
            listSettings = new ScrollGridSettings();
            listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
            itemRenderer = this._loadoutSlot != null ? MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD_WITH_MARKET_TOOLS : MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD;
            listSettings.buildGridItemRenderMethod = itemRenderer;
            listSettings.useNavArrows = false;
            this.myScrollGrid.initGrid(listSettings,681,true,2);
            this.mFilteredList.itemData = items;
            this.myScrollGrid.visible = true;
            this.myOptions.visible = true;
            this.myItemCount.visible = true;
            this.myItemCountLabel.visible = true;
            this.myItemModule.myItemListBackground.visible = true;
            this.setDescriptionAndStatsPosition();
            this.myItemCount.text = items.length.toString();
         }
         else
         {
            this.setDescriptionAndStatsPosition(-OFFSET_X);
         }
         this._modelOffset = !this.myScrollGrid.visible && this.mItemData.type == MarketMenuData.TYPE_WEAPON ? 20 : 0;
         CFunctionContainer.UIViewer_SetModelOffset(this._modelOffset);
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         var items:Array = list1.concat(list2);
         for(var i:int = 0; i < items.length; i++)
         {
            items[i] = items[i];
         }
         this.setupItemList(items);
      }
      
      private function onRadioClicked(id:int) : void
      {
         var sku:SKUObj = null;
         var text:String = "ITEMID: " + this.mItemData.id.toString();
         if(this.mItemData.currentSKUIndex < this.mItemData.SKUs.length)
         {
            sku = this.mItemData.SKUs[this.mItemData.currentSKUIndex];
            if(sku != null)
            {
               text += "  ->  SKUID: " + sku.id.toString() + "  ->  PRODID: " + sku.productId;
            }
         }
         this.myItemDebugText.text = text;
      }
      
      private function onEquipButtonClicked() : void
      {
         onBackButtonClicked();
         EventManager.broadcast(BCEvent.EVT_EQUIP,{"item":this.mItemData});
      }
      
      private function onBuyClicked() : void
      {
         var prodObj:ProductObj = CFunctionCommonContainer.GetItemInfo(this.mItemData.id);
         CFunctionCommonContainer.AS_SetupAndReturnMinSkus(prodObj);
         EventManager.broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prodObj});
      }
      
      private function onTrainingClicked() : void
      {
         UiCppMatchSelectView.ON_TRAINING();
      }
      
      private function onCartClicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_ADD_TO_CART,{"item":this.mItemData});
      }
      
      private function onNavArrowClick(directionVal:int) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mItemSiblings.length; i++)
         {
            if(this.mItemSiblings[i].id == this.mItemData.id)
            {
               this.mItemData = this.resolveItem(i,directionVal);
               break;
            }
         }
         this.refreshView();
      }
      
      private function resolveItem(index:int, directionVal:int) : ProductObj
      {
         var last:int = this.mItemSiblings.length - 1;
         if(index == 0 && directionVal == -1)
         {
            return this.mItemSiblings[last];
         }
         if(index == last && directionVal == 1)
         {
            return this.mItemSiblings[0];
         }
         return this.mItemSiblings[index + directionVal];
      }
      
      private function testForShowDefaultPrice(itemData:ProductObj) : void
      {
         if(itemData.purchaseUiEnabled(false))
         {
            this.myDefaultPriceDisplay.visible = true;
            this.myDefaultPriceDisplay.setItemPurchaseable(CFunctionCommonContainer.AS_SetupAndReturnMinSkus(itemData));
         }
         else
         {
            this.myDefaultPriceDisplay.visible = false;
         }
      }
      
      private function isInBundle() : Boolean
      {
         var productId:int = 0;
         var bundle:Object = null;
         var len:int = int(this.mItemData.SKUs.length);
         var skus:Array = this.mItemData.SKUs;
         for(var i:int = 0; i < len; i++)
         {
            productId = CFunctionContainer.AS_GetProductIDFromSKU(skus[i].id);
            bundle = CFunctionCommonContainer.GetBundleInfo(productId);
            if(bundle != null && bundle.id != null && bundle.type == "giftbox")
            {
               return true;
            }
         }
         return false;
      }
      
      private function clearBuffs() : void
      {
         while(this.myBuffs.numChildren > 0)
         {
            this.myBuffs.removeChildAt(0);
         }
      }
      
      public function isInCustomizeMode() : Boolean
      {
         return this._loadoutSlot != null;
      }
      
      override protected function onStartDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         clearTimeout(this.mTurntableTimeout);
         super.onStartDetect3DModelRotationHandle(cEvt);
         this.focusModel(true,0.25);
      }
      
      override protected function onStopDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         this.mTurntableTimeout = setTimeout(this.timeoutEnableTurntable,1000);
         super.onStopDetect3DModelRotationHandle(cEvt);
         this.focusModel(false,0.25);
      }
      
      private function timeoutEnableTurntable() : void
      {
         if(this.mItemData.type != ItemType.CHA)
         {
            CFunctionCommonContainer.AS_UIViewerEnableTurntable(true);
         }
      }
      
      private function onBuffMouseOver(e:MouseEvent) : void
      {
         var clip:DisplayObject = e.currentTarget as DisplayObject;
         var idx:int = this.myBuffs.getChildIndex(clip);
         var obj:ProductObj = new ProductObj();
         obj.name = this.mItemBuffs[idx].name;
         obj.description = LocalizeUtil.replaceConversionString(LocalizeUtil.localize(this.mItemBuffs[idx].desc),[this.mItemBuffs[idx].percent]);
         broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
            "product":obj,
            "compare":false
         });
      }
      
      private function onBuffMouseOut(e:MouseEvent) : void
      {
         broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      private function setDescriptionAndStatsPosition(xPos:Number = 0) : void
      {
         if(this.mOffsetApplied == true && xPos == 0)
         {
            xPos = OFFSET_X;
            this.mOffsetApplied = false;
         }
         else if(this.mOffsetApplied == true && xPos != 0)
         {
            xPos = 0;
         }
         else if(this.mOffsetApplied == false && xPos != 0)
         {
            this.mOffsetApplied = true;
         }
         this.myItemModule.x = xPos + this.myItemModule.x;
         this.myBuffs.x = this.myItemModule.x + this.myItemModule.myItemName.x;
         this.myLeftNavArrow.x = this.mItemData.type != MarketMenuData.TYPE_CHARACTER ? this.myItemModule.x + this.myItemModule.myItemName.x + this.myLeftNavArrow.width : 660;
         myLoadingSpinner.x = (this.myLeftNavArrow.x + this.myRightNavArrow.x) / 2;
      }
      
      private function focusModel(doFocus:Boolean, duration:Number) : void
      {
         if(Boolean(this._focusModel))
         {
            this._focusModel.pause();
         }
         if(doFocus)
         {
            this._focusModel = new TweenLite(this.stage,duration,{
               "alpha":0,
               "blurFilter":{
                  "blurX":25,
                  "blurY":25
               }
            });
            this._modelFocused = true;
            this._modelOffset = this.mItemData.type == MarketMenuData.TYPE_WEAPON ? 20 : 0;
         }
         else
         {
            this._focusModel = new TweenLite(this.stage,duration,{
               "alpha":1,
               "blurFilter":{
                  "blurX":0,
                  "blurY":0
               }
            });
            this._modelFocused = false;
            this._modelOffset = !this.myScrollGrid.visible && this.mItemData.type == MarketMenuData.TYPE_WEAPON ? 20 : 0;
         }
         CFunctionContainer.UIViewer_SetModelOffset(this._modelOffset);
      }
   }
}

