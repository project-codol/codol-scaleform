package codo.cpp
{
   import codo.component.ComboBox;
   import codo.component.scrollgrid.parts.ScrollGridSortOrderToggle;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.DataManager;
   import codo.objects.RoomMemberObj;
   import codo.services.CharacterLoadoutService;
   import codo.services.MarketService;
   import codo.services.MatchService;
   import codo.utils.Logger;
   
   public dynamic class UiCppItemListView extends UiCppView
   {
      
      public static var CPP_TYPE:uint;
      
      public static const SORT_DEFAULT:int = 0;
      
      public static const SORT_CP:int = 1;
      
      public static const SORT_GP:int = 2;
      
      public static const SORT_LEVEL:int = 3;
      
      public static const SORT_HP:int = 4;
      
      public static const SORT_EHP:int = 5;
      
      public static const SORT_WARGOD_LEVEL:int = 6;
      
      public static const SORT_TYPE:int = 7;
      
      public static const SORT_BRAND:int = 8;
      
      public static const DIR_ASCENDING:int = 0;
      
      public static const DIR_DESCENDING:int = 1;
      
      public static const SECONDARY_FILTER_OPTION_ALL:int = 0;
      
      public static const SECONDARY_FILTER_OPTION_WEAPON:int = 1;
      
      public static const SECONDARY_FILTER_OPTION_CHARACTER:int = 2;
      
      public static const SECONDARY_FILTER_OPTION_GAMEPLAY:int = 3;
      
      public static const SECONDARY_FILTER_OPTION_PLAYERCARD:int = 4;
      
      public static const FUNC_NONE:int = 0;
      
      public static const FUNC_USE_WPN_PRI:int = 1;
      
      public static const FUNC_USE_WPN_SEC:int = 2;
      
      public static const FUNC_SWITCH_CHAR:int = 3;
      
      public static const FUNC_USE_WPN_SWD:int = 4;
      
      public static const FUNC_USE_WPN_KNF:int = 5;
      
      public static const NORMAL_SORT_OPTIONS:Array = [{
         "id":UiCppItemListView.SORT_DEFAULT,
         "enabled":true,
         "label":DictMarket.SORT_DEFAULT
      },{
         "id":UiCppItemListView.SORT_CP,
         "enabled":true,
         "label":Dict.CP
      },{
         "id":UiCppItemListView.SORT_GP,
         "enabled":true,
         "label":Dict.GP
      },{
         "id":UiCppItemListView.SORT_LEVEL,
         "enabled":true,
         "label":DictMarket.SORT_BY_LEVEL
      }];
      
      public static const CATEG_RECOMMENDED:String = "RECOMMENDED";
      
      private var WARGOD_SORT_OPTION:Array = [{
         "id":UiCppItemListView.SORT_TYPE,
         "enabled":true,
         "label":DictMarket.SORT_BY_TYPE
      },{
         "id":UiCppItemListView.SORT_EHP,
         "enabled":true,
         "label":DictMarket.EHP
      },{
         "id":UiCppItemListView.SORT_WARGOD_LEVEL,
         "enabled":true,
         "label":DictMarket.SORT_BY_TIER
      }];
      
      private var NOTSALE_SORT_OPTION:Array = [{
         "id":UiCppItemListView.SORT_DEFAULT,
         "enabled":true,
         "label":DictMarket.SORT_DEFAULT
      }];
      
      private var BRAND_SORT_OPTION:Array = [{
         "id":UiCppItemListView.SORT_BRAND,
         "enabled":true,
         "label":DictMarket.SORT_DEFAULT
      }];
      
      private var SECONDARY_FILTER_OPTIONS_NOTSALE:Array = [{
         "id":UiCppItemListView.SECONDARY_FILTER_OPTION_ALL,
         "enable":true,
         "label":DictMarket.SECONDARY_FILTER_OPTION_ALL
      },{
         "id":UiCppItemListView.SECONDARY_FILTER_OPTION_WEAPON,
         "enable":true,
         "label":DictMarket.SECONDARY_FILTER_OPTION_WEAPON
      },{
         "id":UiCppItemListView.SECONDARY_FILTER_OPTION_CHARACTER,
         "enable":true,
         "label":DictMarket.SECONDARY_FILTER_OPTION_CHARACTER
      },{
         "id":UiCppItemListView.SECONDARY_FILTER_OPTION_GAMEPLAY,
         "enable":true,
         "label":DictMarket.SECONDARY_FILTER_OPTION_GAMEPLAY
      },{
         "id":UiCppItemListView.SECONDARY_FILTER_OPTION_PLAYERCARD,
         "enable":true,
         "label":DictMarket.SECONDARY_FILTER_OPTION_PLAYERCARD
      }];
      
      private var SECONDARY_FILTER_OPTIONS_DEFAULT:Array = [{
         "id":UiCppItemListView.SECONDARY_FILTER_OPTION_ALL,
         "enable":true,
         "label":DictMarket.SECONDARY_FILTER_OPTION_ALL
      }];
      
      public var CPP_filter:UiCppListFilter;
      
      public var CPP_sortOptions:UiCppList;
      
      public var CPP_sortDirs:UiCppList;
      
      public var CPP_secondaryFilter:UiCppList;
      
      protected var _view:IUiCppItemListView;
      
      protected var _sortComboBox:ComboBox;
      
      protected var _sortDirection:ScrollGridSortOrderToggle;
      
      protected var _secondaryFilterOptions:ComboBox;
      
      public function UiCppItemListView(view:IUiCppItemListView, sortOptions:ComboBox = null, sortDirs:ScrollGridSortOrderToggle = null, filter:UiCppListFilter = null, secondaryFilterOptions:ComboBox = null)
      {
         this._view = view;
         this.CPP_filter = filter;
         this._sortComboBox = sortOptions;
         this._sortDirection = sortDirs;
         this._secondaryFilterOptions = secondaryFilterOptions;
         if(Boolean(sortOptions))
         {
            this.CPP_sortOptions = sortOptions.getUiCpp();
            sortOptions.label = DictMarket.SORT;
            sortOptions.dataProvider = NORMAL_SORT_OPTIONS;
         }
         if(Boolean(sortDirs))
         {
            this.CPP_sortDirs = sortDirs.getUiCpp();
         }
         if(Boolean(secondaryFilterOptions))
         {
            secondaryFilterOptions.label = DictMarket.FILTER;
            this.CPP_secondaryFilter = secondaryFilterOptions.getUiCpp();
         }
         super();
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
      
      public function SetInitData(filterData:Array, isLoadoutView:Boolean, inMarketDetails:Boolean = false, inMarketStorage:Boolean = false) : void
      {
         this["AS_SetInitData"](filterData,isLoadoutView,inMarketDetails,inMarketStorage);
      }
      
      public function CPP_GetCategoryItems(category:String, isLoadoutView:Boolean, inMarketDetails:Boolean, inMarketStorage:Boolean) : Array
      {
         var items:Array = null;
         var filterType:uint = 0;
         var i:int = 0;
         var item:Object = null;
         if(category == CATEG_RECOMMENDED)
         {
            items = DataManager.getInstance().getDP(DataID.HOMEPAGE_MARKET_RECOMMEND_ITEM);
         }
         else if(MarketService.getInstance().isExclusiveCategory(category))
         {
            items = MarketService.getInstance().getMarketDP(category,filterType,inMarketDetails,inMarketStorage);
         }
         else if(MarketService.getInstance().isNotSaleCategory(category))
         {
            items = MarketService.getInstance().getMarketDP(category,filterType,inMarketDetails,inMarketStorage);
         }
         else if(MarketService.getInstance().isWeaponBrandCategory(category))
         {
            items = MarketService.getInstance().getMarketDP(category,filterType,inMarketDetails,inMarketStorage);
         }
         else
         {
            filterType = isLoadoutView ? Common.LIST_TYPE_MARKET_OR_EQUIPPABLE : Common.LIST_TYPE_MARKET;
            if(inMarketStorage)
            {
               filterType = Common.LIST_TYPE_INVENTORY;
            }
            items = MarketService.getInstance().getItemListByCategory(category,filterType,inMarketDetails,inMarketStorage);
         }
         var focusedLobbyPlayer:RoomMemberObj = MatchService.getInstance().isInRoom ? DataManager.getInstance().getDP(DataID.MY_AVATAR_MEMBER_OBJ) : null;
         var faction:uint = focusedLobbyPlayer == null ? CharacterLoadoutService.getInstance().currentLoadoutType : focusedLobbyPlayer.team;
         if(faction == Common.LOADOUT_TYPE_SC)
         {
            for(i = 0; i < items.length; i++)
            {
               item = items[i];
               if(item.type == ItemType.CAT || item.group == MarketMenuData.GRP_OUTFIT || item.type == ItemType.CHA)
               {
                  item.imageURL += "_sc";
                  if(item.type != ItemType.CHA)
                  {
                     item.name = item.name.substr(0,item.name.length - 4) + "SC_NAME";
                     item.description = item.description.substr(0,item.description.length - 4) + "SC_DESC";
                  }
               }
            }
         }
         return items;
      }
      
      public function CPP_SetItemsData(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         try
         {
            this._view.uiCppSetItems(list1,list2,ownedFirst);
         }
         catch(err:Error)
         {
            Logger.print("RED ALERT:  MENUS BROKEN");
            Logger.fatalErrorPrint(err.getStackTrace());
         }
      }
      
      public function CPP_SetItemsDataCustom(list:Array) : void
      {
         try
         {
            (this._view as IUiCppItemListViewCustom).uiCppSetItemsCustom(list);
         }
         catch(err:Error)
         {
            Logger.print("RED ALERT:  MENUS BROKEN");
            Logger.fatalErrorPrint(err.getStackTrace());
         }
      }
      
      public function CPP_SetSortOption(option:int) : void
      {
         if(null == this._sortComboBox)
         {
            return;
         }
         this._sortComboBox.visible = option != MarketMenuData.SORT_OPTION_BRAND;
         if(this._sortDirection != null)
         {
            this._sortDirection.visible = this._sortComboBox.visible;
         }
         if(option == MarketMenuData.SORT_OPTION_WARGOD)
         {
            this._sortComboBox.dataProvider = this.WARGOD_SORT_OPTION;
         }
         else if(option == MarketMenuData.SORT_OPTION_NOTSALE)
         {
            this._sortComboBox.dataProvider = this.NOTSALE_SORT_OPTION;
         }
         else if(option == MarketMenuData.SORT_OPTION_BRAND)
         {
            this._sortComboBox.dataProvider = this.BRAND_SORT_OPTION;
         }
         else
         {
            this._sortComboBox.dataProvider = NORMAL_SORT_OPTIONS;
         }
         this._sortComboBox.selectedIndex = 0;
      }
      
      public function CPP_SetSortDirection(direction:int) : void
      {
         if(null == this._sortDirection)
         {
            return;
         }
         this._sortDirection.sortOrder = direction;
      }
      
      public function CPP_SetSecondaryFilterOption(option:int) : void
      {
         if(null == this._secondaryFilterOptions)
         {
            return;
         }
         if(option == MarketMenuData.SECONDARY_FILTER_OPTION_NOTSALE)
         {
            this._secondaryFilterOptions.dataProvider = this.SECONDARY_FILTER_OPTIONS_NOTSALE;
            this._secondaryFilterOptions.selectedIndex = 0;
            this._secondaryFilterOptions.visible = true;
         }
         else
         {
            this._secondaryFilterOptions.dataProvider = this.SECONDARY_FILTER_OPTIONS_DEFAULT;
            this._secondaryFilterOptions.selectedIndex = 0;
            this._secondaryFilterOptions.visible = false;
         }
      }
   }
}

