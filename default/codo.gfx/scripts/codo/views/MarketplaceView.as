package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.MarketplaceFeaturedTab;
   import codo.component.PlayerAccountInfo;
   import codo.component.factory.ButtonFactory;
   import codo.component.filter.FilterCategoryButton;
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListViewCustom;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.DictMarket;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodPlayerObj;
   import codo.services.MarketService;
   import codo.utils.WarGodUtility;
   
   public class MarketplaceView extends MarketplaceBaseView implements IUiCppItemListViewCustom
   {
      
      private static const ITEM_LABEL_POS_Y:Number = 220;
      
      private static const SCROLL_GRID_POS_Y:Number = 264;
      
      private static const SCROLL_GRID_HEIGHT:Number = 687;
      
      private static const SCROLL_FRAME_OFFSET:Number = 99;
      
      private static const BRAND_PLANE_HEIGHT_OFFSET:Number = 20;
      
      private static const TAB_FEATURED:Array = [{
         "id":"FEATURED",
         "label":"FEATURED"
      }];
      
      private static const TAB_WEAPONS:Array = [MarketMenuData.MARKET_CATEGORY_LABELS_PRIMARY,MarketMenuData.MARKET_CATEGORY_LABELS_SECONDARY,MarketMenuData.MARKET_CATEGORY_LABLES_MELEE,{
         "id":"equipment",
         "label":DictMarket.ITEM_MENU_EQUIPMENT,
         "breadcrumb":UiCppNewItems.CRUMB_EQUIPMENT,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.GRP_LETHAL,
            "label":DictMarket.CATEGORY_LETHAL,
            "breadcrumb":UiCppNewItems.CRUMB_LETHALS
         },{
            "id":MarketMenuData.GRP_TACTICAL,
            "label":DictMarket.CATEGORY_TACTICAL,
            "breadcrumb":UiCppNewItems.CRUMB_TACTICALS
         }]
      }];
      
      private static const TAB_GAMEPLAY:Array = [{
         "id":"perk",
         "label":DictMarket.ITEM_MENU_PERK,
         "breadcrumb":UiCppNewItems.CRUMB_PERKS,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.GRP_PERK1,
            "label":DictMarket.CATEGORY_PERK1,
            "breadcrumb":UiCppNewItems.CRUMB_PERKS_1
         },{
            "id":MarketMenuData.GRP_PERK2,
            "label":DictMarket.CATEGORY_PERK2,
            "breadcrumb":UiCppNewItems.CRUMB_PERKS_2
         },{
            "id":MarketMenuData.GRP_PERK3,
            "label":DictMarket.CATEGORY_PERK3,
            "breadcrumb":UiCppNewItems.CRUMB_PERKS_3
         }]
      },{
         "id":MarketMenuData.GRP_WILDCARD,
         "label":DictMarket.ITEM_MENU_WILDCARD,
         "breadcrumb":UiCppNewItems.CRUMB_WILDCARDS
      },MarketMenuData.CATEGORY_KILLSTREAKS,MarketMenuData.CATEGORY_GAMEMODE,MarketMenuData.CATEGORY_REQUISITIONS];
      
      private static const TAB_CLAN:Array = [{
         "id":MarketMenuData.GRP_CLAN,
         "label":DictMarket.CATEGORY_CLAN,
         "aggregate":true,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.CLAN_EXCLUSIVE_BRONZE,
            "label":DictMarket.CLAN_MKT_BRONZE
         },{
            "id":MarketMenuData.CLAN_EXCLUSIVE_SILVER,
            "label":DictMarket.CLAN_MKT_SILVER
         },{
            "id":MarketMenuData.CLAN_EXCLUSIVE_GOLD,
            "label":DictMarket.CLAN_MKT_GOLD
         },{
            "id":MarketMenuData.CLAN_EXCLUSIVE_PLATINUM,
            "label":DictMarket.CLAN_MKT_PLATINUM
         },{
            "id":MarketMenuData.CLAN_EXCLUSIVE_DIAMOND,
            "label":DictMarket.CLAN_MKT_DIAMOND
         }]
      }];
      
      private static const TAB_WARGOD:Array = [{
         "id":MarketMenuData.GRP_WARGOD,
         "label":DictMarket.CATEGORY_JUNIOR_WARGOD,
         "aggregate":true,
         "sortOption":MarketMenuData.SORT_OPTION_WARGOD,
         "sortDirection":UiCppItemListView.DIR_DESCENDING,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.WARGOD_MKT_J1,
            "label":DictMarket.WARGOD_MKT_J1
         },{
            "id":MarketMenuData.WARGOD_MKT_J2,
            "label":DictMarket.WARGOD_MKT_J2
         },{
            "id":MarketMenuData.WARGOD_MKT_J3,
            "label":DictMarket.WARGOD_MKT_J3
         },{
            "id":MarketMenuData.WARGOD_MKT_J4,
            "label":DictMarket.WARGOD_MKT_J4
         },{
            "id":MarketMenuData.WARGOD_MKT_J5,
            "label":DictMarket.WARGOD_MKT_J5
         },{
            "id":MarketMenuData.WARGOD_MKT_J6,
            "label":DictMarket.WARGOD_MKT_J6
         }]
      },{
         "id":MarketMenuData.GRP_SENIOR_WARGOD,
         "label":DictMarket.CATEGORY_SENIOR_WARGOD,
         "aggregate":true,
         "sortOption":MarketMenuData.SORT_OPTION_WARGOD,
         "sortDirection":UiCppItemListView.DIR_DESCENDING,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.WARGOD_MKT_BRONZE,
            "label":DictMarket.WARGOD_MKT_BRONZE
         },{
            "id":MarketMenuData.WARGOD_MKT_SILVER,
            "label":DictMarket.WARGOD_MKT_SILVER
         },{
            "id":MarketMenuData.WARGOD_MKT_GOLD,
            "label":DictMarket.WARGOD_MKT_GOLD
         },{
            "id":MarketMenuData.WARGOD_MKT_PLATINUM,
            "label":DictMarket.WARGOD_MKT_PLATINUM
         },{
            "id":MarketMenuData.WARGOD_MKT_DIAMOND,
            "label":DictMarket.WARGOD_MKT_DIAMOND
         },{
            "id":MarketMenuData.WARGOD_MKT_HEROIC,
            "label":DictMarket.WARGOD_MKT_HEROIC
         }]
      }];
      
      private static const TAB_BUNDLES:Array = [{
         "id":MarketMenuData.GRP_LOADOUT_BUNDLE,
         "label":DictMarket.CATEGORY_BUNDLE,
         "aggregate":true
      }];
      
      private var TAB_FILTERS:Array = [TAB_FEATURED,TAB_BUNDLES,TAB_WEAPONS,MarketMenuData.CATEGORIES_CHARACTER,TAB_GAMEPLAY,[MarketMenuData.CATEGORY_PLAYER],TAB_CLAN,TAB_WARGOD,null];
      
      public var myFeaturedTab:MarketplaceFeaturedTab;
      
      public var mySecondaryNavMenu:NavigationMenu;
      
      public var myBrandPlane:MarketplaceBrandPlane;
      
      protected var _currentTabIdx:int;
      
      public function MarketplaceView()
      {
         var secondaryButtons:Vector.<NavigationObj> = null;
         super();
         this._currentTabIdx = MarketMenuData.TAB_FEATURED;
         secondaryButtons = new <NavigationObj>[new NavigationObj(MarketMenuData.TAB_FEATURED,DictMarket.FEATURED),new NavigationObj(MarketMenuData.TAB_BUNDLE,DictMarket.CATEGORY_BUNDLE),new NavigationObj(MarketMenuData.TAB_WEAPONS,DictMarket.ITEM_MENU_WEAPON),new NavigationObj(MarketMenuData.TAB_CHARS,DictMarket.ITEM_MENU_CHA),new NavigationObj(MarketMenuData.TAB_GAMEPLAY,DictMarket.CATEGORY_GAMEPLAY),new NavigationObj(MarketMenuData.TAB_PLAYER,DictMarket.CATEGORY_PLAYER),new NavigationObj(MarketMenuData.TAB_CLAN,DictMarket.CATEGORY_CLAN),new NavigationObj(MarketMenuData.TAB_WARGOD,DictMarket.CATEGORY_WARGOD),new NavigationObj(MarketMenuData.TAB_WEAPON_ILLUSTRATION,DictMarket.CATEGORY_WEAPON_ILLUSTRATION)];
         secondaryButtons[MarketMenuData.TAB_CHARS].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_GEAR);
         secondaryButtons[MarketMenuData.TAB_GAMEPLAY].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_PERKS);
         secondaryButtons[MarketMenuData.TAB_PLAYER].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_PLAYERCARD);
         secondaryButtons[MarketMenuData.TAB_CLAN].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_CLANS);
         secondaryButtons[MarketMenuData.TAB_WARGOD].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_WARGOD);
         this.fillPlayerCurrentWarGodTierTag();
         this.mySecondaryNavMenu.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
         this.mySecondaryNavMenu.setData(secondaryButtons);
         this.mySecondaryNavMenu.listItemClickCallback = this.onSecondaryMenuItemClicked;
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         this.myBrandPlane.setOnHeightChangedCallback(this.refreshScrollLayout);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myFeaturedTab.active();
         if(this._currentTabIdx == MarketMenuData.TAB_FEATURED)
         {
            this.myFeaturedTab.showTab();
         }
         this.mySecondaryNavMenu.showMenu();
         listen(BCEvent.EVT_NFS_DATA_READY,this.onNFSDataReady);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myFeaturedTab.deactive();
         this.mySecondaryNavMenu.hideMenu();
         broadcast(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,PlayerAccountInfo.CPGPMode);
         unlisten(BCEvent.EVT_NFS_DATA_READY,this.onNFSDataReady);
      }
      
      private function onNFSDataReady(evt:ParaEvent) : void
      {
         if(this._currentTabIdx == MarketMenuData.TAB_WEAPON_ILLUSTRATION)
         {
            this.setMarketTab(this._currentTabIdx);
         }
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mySecondaryNavMenu.visible = true;
         if(data.tabIndex != null)
         {
            this.mySecondaryNavMenu.selectedIndex = data.tabIndex;
            this.setMarketTab(data.tabIndex,data.subtabIndex != null ? int(data.subtabIndex) : -1);
         }
         else
         {
            this.setMarketTab(this._currentTabIdx);
         }
      }
      
      private function onSecondaryMenuItemClicked(btnData:NavigationObj) : void
      {
         this.setMarketTab(btnData.index);
      }
      
      protected function setMarketTab(tab:int, subtab:int = -1) : void
      {
         var isJuniorWarGod:Boolean = false;
         var targetFilter:Object = null;
         this._currentTabIdx = tab;
         var filterData:Array = this.GetTabFilterData(this._currentTabIdx);
         myFrame.visible = myMarketplaceControls.visible = myItemCount.visible = myItemCountLabel.visible = myFilter.visible = myScrollGrid.visible = false;
         myStatGraph.visible = false;
         if(this._currentTabIdx == MarketMenuData.TAB_FEATURED)
         {
            if(subtab >= 0)
            {
               this.myFeaturedTab.setDefaultTab(subtab);
            }
            if(this.myFeaturedTab.isActive())
            {
               this.myFeaturedTab.showTab();
            }
            this.myBrandPlane.visible = false;
         }
         else
         {
            this.myFeaturedTab.hideTab();
            myFrame.visible = myMarketplaceControls.visible = myItemCount.visible = myItemCountLabel.visible = myScrollGrid.visible = true;
            myFilter.visible = true;
            myStatGraph.visible = mShowModel;
            EventManager.broadcast(BCEvent.EVT_MARKET_SET_COMPARE_ITEM,null);
            if(this._currentTabIdx == MarketMenuData.TAB_WARGOD)
            {
               broadcast(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,PlayerAccountInfo.HPEHPMode);
               isJuniorWarGod = WarGodUtility.isJuniorWarGod(getDP(DataID.PLAYER_WARGOD_DATA));
               targetFilter = TAB_WARGOD[isJuniorWarGod ? 0 : 1];
               targetFilter.defaultSelect = true;
            }
            else
            {
               broadcast(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,PlayerAccountInfo.CPGPMode);
            }
            UiCppItemListView(_uiCpp).SetInitData(filterData,false);
         }
      }
      
      private function fillPlayerCurrentWarGodTierTag() : void
      {
         var tabArray:Array = null;
         var tabIndex:int = 0;
         var tabObj:Object = null;
         var tier:int = 0;
         var tag:String = "";
         var playerWarGodData:WarGodPlayerObj = getDP(DataID.PLAYER_WARGOD_DATA);
         if(playerWarGodData.phase == WarGodPlayerObj.PHASE_STAR || playerWarGodData.phase == WarGodPlayerObj.PHASE_PROMOTION)
         {
            tier = playerWarGodData.warGodRank.tier;
            tag = DictMarket.CURRENT_TIER;
            tabArray = WarGodUtility.isJuniorWarGod(playerWarGodData) ? TAB_WARGOD[0].child : TAB_WARGOD[1].child;
            tabIndex = WarGodUtility.isJuniorWarGod(playerWarGodData) ? tier : int(tier - PlayerWarGodRank.TIER_BRONZE);
            tabObj = tabArray[tabIndex + 1];
            tabObj.label += tag;
         }
      }
      
      private function GetTabFilterData(tabIdx:int) : Array
      {
         var obj:Object = null;
         var filterData:Array = this.TAB_FILTERS[tabIdx];
         if(filterData == null && tabIdx == MarketMenuData.TAB_WEAPON_ILLUSTRATION)
         {
            filterData = CFunctionContainer.AS_BuildWeaponBrandsFilterData();
            for each(obj in filterData)
            {
               obj.sortOption = MarketMenuData.SORT_OPTION_BRAND;
            }
            filterData.push({
               "id":MarketMenuData.GRP_NOTSALE,
               "label":DictMarket.CATEGORY_NOTSALE,
               "aggregate":true,
               "sortOption":MarketMenuData.SORT_OPTION_NOTSALE,
               "secondaryFilterOption":MarketMenuData.SECONDARY_FILTER_OPTION_NOTSALE,
               "child":[{
                  "allItems":true,
                  "label":DictMarket.CATEGORY_ALL
               },{
                  "id":MarketMenuData.NOTSALE_MKT_EVENT,
                  "label":DictMarket.NOTSALE_MKT_EVENT
               },{
                  "id":MarketMenuData.NOTSALE_MKT_PVE,
                  "label":DictMarket.NOTSALE_MKT_PVE
               },{
                  "id":MarketMenuData.NOTSALE_MKT_PVP,
                  "label":DictMarket.NOTSALE_MKT_PVP
               },{
                  "id":MarketMenuData.NOTSALE_MKT_OTHER,
                  "label":DictMarket.NOTSALE_MKT_OTHER
               },{
                  "id":MarketMenuData.NOTSALE_MKT_EXTINCTION,
                  "label":DictMarket.NOTSALE_MKT_EXTINCTION
               }]
            });
            this.TAB_FILTERS[tabIdx] = filterData;
         }
         return filterData;
      }
      
      override protected function refresh() : void
      {
         var i:int = 0;
         if(!myFilter.visible)
         {
            return;
         }
         var brandObj:Object = null;
         var category:FilterCategoryButton = myFilter.currentCategory;
         var filterObj:Object = category.getData();
         var states:Array = category.subcategoryStates;
         if(MarketService.getInstance().isWeaponBrandCategory(filterObj.id))
         {
            for(i = 0; i < states.length; i++)
            {
               if(Boolean(states[i]))
               {
                  brandObj = CFunctionContainer.AS_GetWeaponBrandData(filterObj.child[i].id);
                  break;
               }
            }
         }
         this.myBrandPlane.visible = brandObj != null;
         this.myBrandPlane.setData(brandObj);
         super.refresh();
      }
      
      override public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         var listHeader1:String = DictMarket.MARKET_OWNED_ITEMS;
         var listHeader2:String = DictMarket.MARKET_UNOWNED_ITEMS;
         if(this._currentTabIdx == MarketMenuData.TAB_WARGOD)
         {
            listHeader1 = DictMarket.MARKET_UNPURCHASABLE_ITEMS;
            listHeader2 = DictMarket.MARKET_PURCHASABLE_ITEMS;
         }
         myScrollGrid.setItemsData(list1,list2,ownedFirst,true,listHeader1,listHeader2);
         this.refresh();
      }
      
      public function uiCppSetItemsCustom(itemListArray:Array) : void
      {
         myScrollGrid.setItemsDataCustom(itemListArray);
         this.refresh();
      }
      
      private function refreshScrollLayout() : void
      {
         var brandHeight:Number = this.myBrandPlane.visible ? this.myBrandPlane.height + BRAND_PLANE_HEIGHT_OFFSET : 0;
         myMarketplaceControls.y = myItemCount.y = myItemCountLabel.y = ITEM_LABEL_POS_Y + brandHeight;
         myMarketplaceControls.gridHeight = SCROLL_GRID_HEIGHT - brandHeight;
         myScrollGrid.y = SCROLL_GRID_POS_Y + brandHeight;
         myScrollGrid.setFrame(myFrame,SCROLL_FRAME_OFFSET + brandHeight);
         myScrollGrid.refreshVisuals();
      }
   }
}

