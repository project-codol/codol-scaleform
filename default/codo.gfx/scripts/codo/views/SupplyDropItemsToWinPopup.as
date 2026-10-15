package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.ButtonFactory;
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.localization.DictSetting;
   import codo.objects.FilterObj;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.SupplyDropFilterObj;
   import codo.objects.SupplyDropItemsToWinFilterOptionObj;
   import codo.style.SupplyDropGuide;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.views.supplyDrop_parts.SupplyDropItemToWin;
   import codo.views.supplyDrop_parts.SupplyDropItemsToWinFilter;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class SupplyDropItemsToWinPopup extends PopupView
   {
      
      private static const POPUP_WIDTH:uint = 853;
      
      private static const POPUP_HEIGHT:uint = 640;
      
      private static const PADDING:uint = 30;
      
      private static const TAB_LIMITED:int = 0;
      
      private static const TAB_ADVANCED:uint = 1;
      
      private static const TAB_BASIC:uint = 2;
      
      private static const CATEGORY_LATEST_UPDATES:int = 0;
      
      private static const CATEGORY_PRIMARY_WEAPON:int = 1;
      
      private static const CATEGORY_SECONDARY_WEAPON:int = 2;
      
      private static const CATEGORY_MELEE_WEAPON:int = 3;
      
      private static const CATEGORY_EQUIPMENT:int = 4;
      
      private static const CATEGORY_CHARACTER:int = 5;
      
      private static const CATEGORY_MTX:int = 6;
      
      private static const CATEGORY_PERSONALIZED:int = 7;
      
      private static const CATEGORY_GAMEPLAY:int = 8;
      
      private static const CATEGORY_OTHERS:int = 9;
      
      private static const SUB_CATEGORY_ALL:int = 0;
      
      private static const SUB_CATEGORY_PRIMARY_WEAPON_AR:int = 1;
      
      private static const SUB_CATEGORY_PRIMARY_WEAPON_SMG:int = 2;
      
      private static const SUB_CATEGORY_PRIMARY_WEAPON_LMG:int = 3;
      
      private static const SUB_CATEGORY_PRIMARY_WEAPON_SHOT_GUN:int = 4;
      
      private static const SUB_CATEGORY_PRIMARY_WEAPON_SNIPER:int = 5;
      
      private static const SUB_CATEGORY_PRIMARY_WEAPON_OTHER:int = 6;
      
      private static const SUB_CATEGORY_SECONDARY_WEAPON_PISTOL:int = 1;
      
      private static const SUB_CATEGORY_SECONDARY_WEAPON_MACHINE_PISTOL:int = 2;
      
      private static const SUB_CATEGORY_SECONDARY_WEAPON_LAUNCHER:int = 3;
      
      private static const SUB_CATEGORY_MELEE_WEAPON_SWORD:int = 1;
      
      private static const SUB_CATEGORY_MELEE_WEAPON_KNIFE:int = 2;
      
      private static const SUB_CATEGORY_EQUIP_LETHAL:int = 1;
      
      private static const SUB_CATEGORY_EQUIP_TACTICAL:int = 2;
      
      private static const SUB_CATEGORY_MTX_EMOTES:int = 1;
      
      private static const SUB_CATEGORY_MTX_MTX:int = 2;
      
      private static const SUB_CATEGORY_MTX_KNIFE_VARIANT:int = 3;
      
      private static const SUB_CATEGORY_PERSONALIZE_BACKGROUNDS:int = 1;
      
      private static const SUB_CATEGORY_PERSONALIZE_EMBLEMS:int = 2;
      
      private static const SUB_CATEGORY_PERSONALIZE_TITLE:int = 3;
      
      private static const SUB_CATEGORY_PERSONALIZE_OTHERS:int = 4;
      
      private static const SUB_CATEGORY_GAME_PLAY_PERK:int = 1;
      
      private static const SUB_CATEGORY_GAME_PLAY_KIS:int = 2;
      
      private static const SUB_CATEGORY_GAME_PLAY_WILDCARD:int = 3;
      
      public var myNavMenu:NavigationMenu;
      
      public var myGrid:ScrollGrid;
      
      public var myDescriptionTF:TextField;
      
      public var myPopupHeaderTF:TextField;
      
      public var myFilter:SupplyDropItemsToWinFilter;
      
      private var mShowFeaturedItems:Boolean = false;
      
      private var mNavButtons:Vector.<NavigationObj>;
      
      private var mCurrentTabIndex:uint;
      
      private var mCurrentCategory:uint;
      
      private var mCurrentSubCategory:uint;
      
      private var mBasicItems:Dictionary;
      
      private var mAdvancedItems:Dictionary;
      
      private var mLimitedItems:Dictionary;
      
      private var categoryAndSubCategoryRelationship:Array;
      
      public function SupplyDropItemsToWinPopup()
      {
         super();
         this.categoryAndSubCategoryRelationship = [{
            "id":CATEGORY_LATEST_UPDATES,
            "name":DictMarket.LATEST_SUPPLY_DROP_REWARD,
            "subCategories":[]
         },{
            "id":CATEGORY_PRIMARY_WEAPON,
            "name":DictMarket.ITEM_MENU_PRIMARY,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_PRIMARY_WEAPON_AR,
               "name":DictMarket.CATEGORY_ASSAULT_RIFLE
            },{
               "id":SUB_CATEGORY_PRIMARY_WEAPON_SMG,
               "name":DictMarket.CATEGORY_SMG
            },{
               "id":SUB_CATEGORY_PRIMARY_WEAPON_LMG,
               "name":DictMarket.CATEGORY_LMG
            },{
               "id":SUB_CATEGORY_PRIMARY_WEAPON_SHOT_GUN,
               "name":DictMarket.CATEGORY_SHOTGUN
            },{
               "id":SUB_CATEGORY_PRIMARY_WEAPON_SNIPER,
               "name":DictMarket.CATEGORY_SNIPER
            },{
               "id":SUB_CATEGORY_PRIMARY_WEAPON_OTHER,
               "name":DictMarket.OTHER
            }]
         },{
            "id":CATEGORY_SECONDARY_WEAPON,
            "name":DictMarket.ITEM_MENU_SECONDARYWEAP,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_SECONDARY_WEAPON_PISTOL,
               "name":DictMarket.CATEGORY_PISTOL
            },{
               "id":SUB_CATEGORY_SECONDARY_WEAPON_MACHINE_PISTOL,
               "name":DictMarket.CATEGORY_MACHINE_PISTOL
            },{
               "id":SUB_CATEGORY_SECONDARY_WEAPON_LAUNCHER,
               "name":DictMarket.CATEGORY_LAUNCHER
            }]
         },{
            "id":CATEGORY_MELEE_WEAPON,
            "name":DictMarket.ITEM_MENU_MELEE,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_MELEE_WEAPON_SWORD,
               "name":DictMarket.CATEGORY_OTHER
            },{
               "id":SUB_CATEGORY_MELEE_WEAPON_KNIFE,
               "name":DictMarket.CATEGORY_COMBAT_KNIFE
            }]
         },{
            "id":CATEGORY_EQUIPMENT,
            "name":DictMarket.ITEM_MENU_EQUIPMENT,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_EQUIP_LETHAL,
               "name":DictMarket.CATEGORY_LETHAL
            },{
               "id":SUB_CATEGORY_EQUIP_TACTICAL,
               "name":DictMarket.CATEGORY_TACTICAL
            }]
         },{
            "id":CATEGORY_CHARACTER,
            "name":DictMarket.ITEM_MENU_CHA,
            "subCategories":[]
         },{
            "id":CATEGORY_MTX,
            "name":Dict.LOADOUT_CATEGORY_GEAR,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_MTX_EMOTES,
               "name":DictMarket.ITEM_MENU_EMO
            },{
               "id":SUB_CATEGORY_MTX_MTX,
               "name":Dict.LOADOUT_CATEGORY_GEAR
            },{
               "id":SUB_CATEGORY_MTX_KNIFE_VARIANT,
               "name":Dict.CHARACTERLOADOUT_COMBATKNIFE
            }]
         },{
            "id":CATEGORY_PERSONALIZED,
            "name":DictMarket.CATEGORY_PLAYER,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_PERSONALIZE_BACKGROUNDS,
               "name":DictMarket.CATEGORY_CALLSIGN_PCB
            },{
               "id":SUB_CATEGORY_PERSONALIZE_EMBLEMS,
               "name":DictMarket.CATEGORY_CALLSIGN_EMBLEM
            },{
               "id":SUB_CATEGORY_PERSONALIZE_TITLE,
               "name":DictMarket.CATEGORY_CALLSIGN_TITLE
            },{
               "id":SUB_CATEGORY_PERSONALIZE_OTHERS,
               "name":DictMarket.OTHER
            }]
         },{
            "id":CATEGORY_GAMEPLAY,
            "name":DictMarket.CATEGORY_GAMEPLAY,
            "subCategories":[{
               "id":SUB_CATEGORY_ALL,
               "name":DictMarket.CATEGORY_ALL
            },{
               "id":SUB_CATEGORY_GAME_PLAY_PERK,
               "name":DictMarket.ITEM_MENU_PERK
            },{
               "id":SUB_CATEGORY_GAME_PLAY_KIS,
               "name":DictMarket.ITEM_MENU_KILLSTREAK
            },{
               "id":SUB_CATEGORY_GAME_PLAY_WILDCARD,
               "name":DictMarket.ITEM_MENU_WILDCARD
            }]
         },{
            "id":CATEGORY_OTHERS,
            "name":DictMarket.OTHER,
            "subCategories":[]
         }];
         this.mCurrentTabIndex = 0;
         this.mCurrentCategory = 0;
         this.mCurrentSubCategory = 0;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.useNavArrows = false;
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = this.buildDisplayCards;
         this.myPopupHeaderTF.textStyle = SupplyDropGuide.styleSupplyDropItemsToWinHeader;
         this.myDescriptionTF.textStyle = SupplyDropGuide.styleSupplyDropItemsToWinDescription;
         this.myDescriptionTF.alpha = 0.7;
         this.myGrid.initGrid(gridSettings,3,false,4);
         this.myGrid.listItemFocusCallback = this.onListItemFocused;
         this.myGrid.listItemUnfocusCallback = this.onListItemUnfocused;
         myPopup.width = this.myPopupHeaderTF.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         this.myDescriptionTF.width = POPUP_WIDTH - 65;
         myPopup.configConfirmButton(DictSetting.CLOSE_SETTING,this.onConfirm,true);
         myPopup.configCancelButton(DictMarket.SUPPLY_DROP_VIEW_MORE_ITEMS,this.onOpenWebImage);
         myPopup.header.visible = false;
         myPopup.y += this.myPopupHeaderTF.textHeight + 10;
         this.myFilter.y = myPopup.y + 15;
         this.myFilter.addOnCategoryClickCallback(this.onCategoryCheckedCallback);
         this.myFilter.addOnSubCategoryCheckedCallback(this.onSubCategoryCheckedCallback);
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mShowFeaturedItems = data.isFeatured as Boolean;
         this.mCurrentTabIndex = 0;
         this.mCurrentCategory = 0;
         this.mCurrentSubCategory = 0;
      }
      
      private function categorizeItems(categorizedItems:Dictionary, sourceItems:Vector.<Object>) : void
      {
         var categoryObj:Object = null;
         var j:uint = 0;
         var subCategoryObj:Object = null;
         for(var i:uint = 0; i < this.categoryAndSubCategoryRelationship.length; i++)
         {
            categoryObj = this.categoryAndSubCategoryRelationship[i];
            if(categoryObj.subCategories.length > 0)
            {
               for(j = 0; j < categoryObj.subCategories.length; j++)
               {
                  subCategoryObj = categoryObj.subCategories[j];
                  this.setAvailableCategoryAndSubCategoryItems(categorizedItems,sourceItems,categoryObj.id,subCategoryObj.id);
               }
            }
            else
            {
               this.setAvailableCategoryAndSubCategoryItems(categorizedItems,sourceItems,categoryObj.id,SUB_CATEGORY_ALL);
            }
         }
      }
      
      private function setAvailableCategoryAndSubCategoryItems(categorizedItems:Dictionary, sourceItems:Vector.<Object>, category:uint, subCategory:uint) : void
      {
         var items:Vector.<Object> = null;
         items = this.getItemsByCategoryAndSubCategory(sourceItems,category,subCategory);
         if(items.length > 0)
         {
            if(categorizedItems[category] == null)
            {
               categorizedItems[category] = new Dictionary();
            }
            categorizedItems[category][subCategory] = items;
         }
      }
      
      private function getCategorizedItems(tabIndex:uint, category:uint, subCategory:uint) : Vector.<Object>
      {
         var categorisedItems:Dictionary = null;
         switch(tabIndex)
         {
            case TAB_BASIC:
               categorisedItems = this.mBasicItems;
               break;
            case TAB_ADVANCED:
               categorisedItems = this.mAdvancedItems;
               break;
            case TAB_LIMITED:
               categorisedItems = this.mLimitedItems;
         }
         if(categorisedItems == null)
         {
            return new Vector.<Object>(0);
         }
         if(categorisedItems[category] == null)
         {
            return new Vector.<Object>(0);
         }
         if(categorisedItems[category][subCategory] == null)
         {
            return new Vector.<Object>(0);
         }
         return categorisedItems[category][subCategory];
      }
      
      protected function refreshFilter() : void
      {
         var filterObj:SupplyDropFilterObj = null;
         var items:Vector.<Object> = null;
         var options:Array = null;
         var subCategoryIndex:uint = 0;
         var categoryObj:Object = null;
         var j:int = 0;
         var subCategoryObj:Object = null;
         var filters:Vector.<FilterObj> = new Vector.<FilterObj>(0);
         var categoryIndex:uint = 0;
         for(var i:int = 0; i < this.categoryAndSubCategoryRelationship.length; i++)
         {
            subCategoryIndex = 0;
            categoryObj = this.categoryAndSubCategoryRelationship[i];
            if(categoryObj.subCategories.length > 0)
            {
               options = new Array();
               for(j = 0; j < categoryObj.subCategories.length; j++)
               {
                  subCategoryObj = categoryObj.subCategories[j];
                  items = this.getCategorizedItems(this.mCurrentTabIndex,categoryObj.id,subCategoryObj.id);
                  if(items.length > 0)
                  {
                     options.push(new SupplyDropItemsToWinFilterOptionObj(subCategoryIndex,subCategoryObj.name,categoryObj.id,subCategoryObj.id));
                     subCategoryIndex++;
                  }
               }
               if(options.length > 0)
               {
                  filterObj = new SupplyDropFilterObj(categoryIndex,categoryObj.name,options,categoryObj.id);
                  filters.push(filterObj);
                  categoryIndex++;
               }
            }
            else
            {
               items = this.getCategorizedItems(this.mCurrentTabIndex,categoryObj.id,SUB_CATEGORY_ALL);
               if(items.length > 0)
               {
                  options = new Array();
                  filterObj = new SupplyDropFilterObj(categoryIndex,categoryObj.name,options,categoryObj.id);
                  filters.push(filterObj);
                  categoryIndex++;
               }
            }
         }
         this.myFilter.singleOptionMode = true;
         this.myFilter.setData(DataUtil.VectorToArray(filters));
         this.myFilter.selectCategory(0);
         this.onCategoryCheckedCallback();
      }
      
      override protected function showView() : void
      {
         var index:int = 0;
         super.showView();
         listen(BCEvent.EVT_LOAD_ANIMATED_PRODUCT_COMPLETE,this.onLoadAnimatedProductComplete);
         var httpLinkBtn:Button = myPopup.getButtonByIndex(1);
         httpLinkBtn.enabled = httpLinkBtn.visible = false;
         var headerTxt:String = this.mShowFeaturedItems ? DictMarket.SUPPLY_DROPS_FEATURED_ITEMS_TO_WIN_HEADER : DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_HEADER;
         this.myPopupHeaderTF.text = headerTxt;
         if(this.mShowFeaturedItems)
         {
            this.myNavMenu.visible = false;
            this.myFilter.visible = false;
            this.myGrid.addItemsByVector(this.getFeatureItems());
            this.myDescriptionTF.htmlText = LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_FEATURE_ITEMS_TO_WIN_DESCRIPTION);
            this.myGrid.y = this.myDescriptionTF.y + this.myDescriptionTF.textHeight + 20;
         }
         else
         {
            this.myNavMenu.visible = true;
            this.myFilter.visible = true;
            this.mNavButtons = new Vector.<NavigationObj>();
            index = 0;
            if(Boolean(CFunctionContainer.AS_IsSupplyDropForSale(MarketMenuData.SUPPLY_DROP_EVENT)))
            {
               this.mNavButtons.push(new NavigationObj(index,DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_EVENT_TITLE,true,this.onSwitchTab,TAB_LIMITED));
               index++;
            }
            if(Boolean(CFunctionContainer.AS_IsSupplyDropForSale(MarketMenuData.SUPPLY_DROP_ADVANCED)))
            {
               this.mNavButtons.push(new NavigationObj(index,DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_ADVANCED_TITLE,true,this.onSwitchTab,TAB_ADVANCED));
               index++;
            }
            if(Boolean(CFunctionContainer.AS_IsSupplyDropForSale(MarketMenuData.SUPPLY_DROP_BASIC)))
            {
               this.mNavButtons.push(new NavigationObj(index,DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_BASIC_TITLE,true,this.onSwitchTab,TAB_BASIC));
               index++;
            }
            this.myNavMenu.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
            this.myNavMenu.setData(this.mNavButtons);
            this.myNavMenu.selectedIndex = 0;
            this.myNavMenu.showMenu();
            this.onTabClicked(this.mNavButtons[0]);
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mShowFeaturedItems = false;
         unlisten(BCEvent.EVT_LOAD_ANIMATED_PRODUCT_COMPLETE,this.onLoadAnimatedProductComplete);
         if(this.myNavMenu.visible)
         {
            this.myNavMenu.hideMenu();
         }
      }
      
      private function buildDisplayCards() : UIInteractiveComponent
      {
         return new supplyDropItemToWin() as SupplyDropItemToWin;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.myGrid.myScrollBar.x = 786;
         if(!this.mShowFeaturedItems)
         {
            this.mBasicItems = new Dictionary();
            this.mAdvancedItems = new Dictionary();
            this.mLimitedItems = new Dictionary();
            this.categorizeItems(this.mBasicItems,this.getSampleItemsByCrateItemID(MarketMenuData.SUPPLY_DROP_BASIC));
            this.categorizeItems(this.mAdvancedItems,this.getSampleItemsByCrateItemID(MarketMenuData.SUPPLY_DROP_ADVANCED));
            this.categorizeItems(this.mLimitedItems,this.getSampleItemsByCrateItemID(MarketMenuData.SUPPLY_DROP_EVENT));
            this.refreshGrid();
         }
         else
         {
            this.mBasicItems = null;
            this.mAdvancedItems = null;
            this.mLimitedItems = null;
         }
      }
      
      override protected function positionView() : void
      {
         var filterOffsetWidth:int = this.mShowFeaturedItems ? 0 : 250;
         var totalWidth:uint = filterOffsetWidth + POPUP_WIDTH + 10;
         myPopup.x = filterOffsetWidth;
         this.myDescriptionTF.x = myPopup.x + PADDING;
         this.myDescriptionTF.y = myPopup.y + PADDING;
         this.myGrid.x = this.myDescriptionTF.x;
         if(this.mShowFeaturedItems)
         {
            this.myPopupHeaderTF.x = myPopup.x + 10;
            this.myPopupHeaderTF.y = myPopup.y - this.myPopupHeaderTF.height - 40;
         }
         else
         {
            this.myPopupHeaderTF.y = -40;
            this.myPopupHeaderTF.x = this.myFilter.x;
            this.myNavMenu.x = this.myPopupHeaderTF.x;
         }
         x = (GameInfo.DEFAULT_WIDTH - totalWidth) * 0.5;
         y = (GameInfo.DEFAULT_HEIGHT - (myPopup.popupHeight + this.myPopupHeaderTF.textHeight)) * 0.5;
      }
      
      override protected function get transitionTargetPoint() : Point
      {
         var totalWidth:uint = this.mShowFeaturedItems ? uint(POPUP_WIDTH + 10) : uint(this.myFilter.width + POPUP_WIDTH + 10);
         var pointX:int = (GameInfo.DEFAULT_WIDTH - totalWidth) * 0.5;
         var pointY:int = (GameInfo.DEFAULT_HEIGHT - (myPopup.popupHeight + (this.myPopupHeaderTF.textHeight + 30))) * 0.5;
         return new Point(pointX,pointY);
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
      
      private function onOpenWebImage() : void
      {
         broadcast(BCEvent.EVT_CLICK_SUPPLY_DROP_ITEMS_WEBPAGE);
      }
      
      private function getFeatureItems() : Vector.<Object>
      {
         var sampleItem:Object = null;
         var item:Object = null;
         var GET_ITEM_INFO:Function = CFunctionCommonContainer.GetItemInfo;
         var featureItems:Array = CFunctionContainer.AS_GetSupplyDropFeaturedItems(MarketMenuData.SUPPLY_DROP_ADVANCED);
         var items:Vector.<Object> = new Vector.<Object>(0);
         for each(sampleItem in featureItems)
         {
            item = new Object();
            if(sampleItem.item != 0)
            {
               item.item = GET_ITEM_INFO(sampleItem.item);
            }
            else
            {
               item.product = GET_ITEM_INFO(sampleItem.product);
            }
            item.isFeatured = true;
            items.push(item);
         }
         return items;
      }
      
      private function getSampleItemsByCrateItemID(itemID:int) : Vector.<Object>
      {
         var sampleItem:Object = null;
         var item:Object = null;
         var GET_ITEM_INFO:Function = CFunctionCommonContainer.GetItemInfo;
         var GET_PRODUCT_INFO:Function = CFunctionCommonContainer.GetBundleInfo;
         var sampleItems:Array = CFunctionContainer.AS_GetSupplyDropSampleItems(itemID);
         var items:Vector.<Object> = new Vector.<Object>(0);
         for each(sampleItem in sampleItems)
         {
            item = new Object();
            if(sampleItem.item != 0)
            {
               item.item = GET_ITEM_INFO(sampleItem.item);
            }
            else
            {
               item.item = GET_PRODUCT_INFO(sampleItem.product);
            }
            item.isNew = sampleItem.isNew;
            item.isFeatured = sampleItem.isFeatured;
            items.push(item);
         }
         return items;
      }
      
      protected function onListItemFocused(item:Object) : void
      {
         broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
            "product":item.item,
            "compare":false
         });
      }
      
      protected function onListItemUnfocused(item:Object) : void
      {
         broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      protected function onTabClicked(tab:NavigationObj) : void
      {
         tab.clickEvent(tab.clickEventData as int);
      }
      
      protected function onSwitchTab(tabIndex:int) : void
      {
         this.mCurrentTabIndex = tabIndex;
         switch(this.mCurrentTabIndex)
         {
            case TAB_LIMITED:
               this.myDescriptionTF.htmlText = LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_EVENT_DESCRIPTION);
               break;
            case TAB_ADVANCED:
               this.myDescriptionTF.htmlText = LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_ADVANCED_DESCRIPTION);
               break;
            case TAB_BASIC:
               this.myDescriptionTF.htmlText = LocalizeUtil.localize(DictMarket.SUPPLY_DROPS_ITEMS_TO_WIN_BASIC_DESCRIPTION);
         }
         this.refreshFilter();
      }
      
      protected function onCategoryCheckedCallback() : void
      {
         var filterObj:SupplyDropFilterObj = this.myFilter.currentCategory.getData() as SupplyDropFilterObj;
         this.mCurrentCategory = filterObj.category;
         this.onSubCategoryCheckedCallback();
      }
      
      protected function onSubCategoryCheckedCallback() : void
      {
         var optionObj:SupplyDropItemsToWinFilterOptionObj = null;
         var filterObj:SupplyDropFilterObj = this.myFilter.currentCategory.getData() as SupplyDropFilterObj;
         if(filterObj.child.length > 0)
         {
            optionObj = filterObj.child[this.myFilter.currentCategory.selectedIndex] as SupplyDropItemsToWinFilterOptionObj;
            this.mCurrentCategory = optionObj.category;
            this.mCurrentSubCategory = optionObj.subCategory;
         }
         else
         {
            this.mCurrentCategory = filterObj.category;
            this.mCurrentSubCategory = SUB_CATEGORY_ALL;
         }
         this.refreshGrid();
      }
      
      private function getItemCategory(item:Object) : Vector.<int>
      {
         var prod:ProductObj = item.item;
         if(prod.type == MarketMenuData.TYPE_WEAPON)
         {
            if(prod.group == MarketMenuData.GRP_WPN_ASSAULT)
            {
               return new <int>[CATEGORY_PRIMARY_WEAPON,SUB_CATEGORY_PRIMARY_WEAPON_AR];
            }
            if(prod.group == MarketMenuData.GRP_WPN_SMG)
            {
               return new <int>[CATEGORY_PRIMARY_WEAPON,SUB_CATEGORY_PRIMARY_WEAPON_SMG];
            }
            if(prod.group == MarketMenuData.GRP_WPN_LMG)
            {
               return new <int>[CATEGORY_PRIMARY_WEAPON,SUB_CATEGORY_PRIMARY_WEAPON_LMG];
            }
            if(prod.group == MarketMenuData.GRP_WPN_SHOTGUN)
            {
               return new <int>[CATEGORY_PRIMARY_WEAPON,SUB_CATEGORY_PRIMARY_WEAPON_SHOT_GUN];
            }
            if(prod.group == MarketMenuData.GRP_WPN_SNIPER)
            {
               return new <int>[CATEGORY_PRIMARY_WEAPON,SUB_CATEGORY_PRIMARY_WEAPON_SNIPER];
            }
            if(prod.group == MarketMenuData.GRP_WPN_OTHER)
            {
               return new <int>[CATEGORY_PRIMARY_WEAPON,SUB_CATEGORY_PRIMARY_WEAPON_OTHER];
            }
            if(prod.group == MarketMenuData.GRP_WPN_PISTOL)
            {
               return new <int>[CATEGORY_SECONDARY_WEAPON,SUB_CATEGORY_SECONDARY_WEAPON_PISTOL];
            }
            if(prod.group == MarketMenuData.GRP_WPN_MPISTOL)
            {
               return new <int>[CATEGORY_SECONDARY_WEAPON,SUB_CATEGORY_SECONDARY_WEAPON_MACHINE_PISTOL];
            }
            if(prod.group == MarketMenuData.GRP_WPN_LAUNCHER)
            {
               return new <int>[CATEGORY_SECONDARY_WEAPON,SUB_CATEGORY_SECONDARY_WEAPON_LAUNCHER];
            }
            if(prod.group == MarketMenuData.GRP_WPN_MELEE_SWORD)
            {
               return new <int>[CATEGORY_MELEE_WEAPON,SUB_CATEGORY_MELEE_WEAPON_SWORD];
            }
         }
         if(prod.type == MarketMenuData.TYPE_EQUIPMENT)
         {
            if(prod.group == MarketMenuData.GRP_LETHAL)
            {
               return new <int>[CATEGORY_EQUIPMENT,SUB_CATEGORY_EQUIP_LETHAL];
            }
            if(prod.group == MarketMenuData.GRP_TACTICAL)
            {
               return new <int>[CATEGORY_EQUIPMENT,SUB_CATEGORY_EQUIP_TACTICAL];
            }
            if(prod.group == MarketMenuData.GRP_WPN_MELEE_KNIFE)
            {
               return new <int>[CATEGORY_MELEE_WEAPON,SUB_CATEGORY_MELEE_WEAPON_KNIFE];
            }
         }
         if(prod.type == MarketMenuData.TYPE_CHARACTER)
         {
            return new <int>[CATEGORY_CHARACTER];
         }
         if(prod.type == ItemType.CAT)
         {
            return new <int>[CATEGORY_MTX,SUB_CATEGORY_MTX_MTX];
         }
         if(prod.type == MarketMenuData.TYPE_GAMEMODE)
         {
            if(prod.group == MarketMenuData.GRP_EMOTE)
            {
               return new <int>[CATEGORY_MTX,SUB_CATEGORY_MTX_EMOTES];
            }
            if(prod.group == MarketMenuData.GRP_WILDCARD)
            {
               return new <int>[CATEGORY_GAMEPLAY,SUB_CATEGORY_GAME_PLAY_WILDCARD];
            }
         }
         if(prod.type == MarketMenuData.TYPE_CALLSIGN_BKG)
         {
            return new <int>[CATEGORY_PERSONALIZED,SUB_CATEGORY_PERSONALIZE_BACKGROUNDS];
         }
         if(prod.type == MarketMenuData.TYPE_CALLSIGN_EMBLEM)
         {
            return new <int>[CATEGORY_PERSONALIZED,SUB_CATEGORY_PERSONALIZE_EMBLEMS];
         }
         if(prod.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            return new <int>[CATEGORY_PERSONALIZED,SUB_CATEGORY_PERSONALIZE_TITLE];
         }
         if(prod.group == MarketMenuData.TYPE_CALLSIGN_CHANGE_NAME)
         {
            return new <int>[CATEGORY_PERSONALIZED,SUB_CATEGORY_PERSONALIZE_OTHERS];
         }
         if(prod.type == MarketMenuData.TYPE_PERK)
         {
            return new <int>[CATEGORY_GAMEPLAY,SUB_CATEGORY_GAME_PLAY_PERK];
         }
         if(prod.type == MarketMenuData.TYPE_KILLSTREAK)
         {
            return new <int>[CATEGORY_GAMEPLAY,SUB_CATEGORY_GAME_PLAY_KIS];
         }
         return new <int>[CATEGORY_OTHERS];
      }
      
      protected function getItemsByCategoryAndSubCategory(sourceItems:Vector.<Object>, category:int, subCategory:int) : Vector.<Object>
      {
         var item:Object = null;
         var itemCat:Vector.<int> = null;
         var availableItems:Vector.<Object> = new Vector.<Object>();
         for(var i:uint = 0; i < sourceItems.length; i++)
         {
            item = sourceItems[i];
            if(category == CATEGORY_LATEST_UPDATES)
            {
               if(Boolean(item.isNew))
               {
                  availableItems.push(item);
               }
            }
            else
            {
               itemCat = this.getItemCategory(item);
               if(itemCat[0] == category && (subCategory == SUB_CATEGORY_ALL || subCategory == itemCat[1]))
               {
                  availableItems.push(item);
               }
            }
         }
         return availableItems;
      }
      
      protected function refreshGrid() : void
      {
         var items:Vector.<Object> = this.getCategorizedItems(this.mCurrentTabIndex,this.mCurrentCategory,this.mCurrentSubCategory);
         this.myGrid.addItemsByVector(items);
      }
      
      private function onLoadAnimatedProductComplete(evt:ParaEvent) : void
      {
         this.refreshGrid();
      }
   }
}

