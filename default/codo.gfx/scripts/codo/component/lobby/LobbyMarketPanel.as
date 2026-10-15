package codo.component.lobby
{
   import codo.component.CloseButton;
   import codo.component.ComboBox;
   import codo.component.ContentContainer;
   import codo.component.MarketScrollGrid;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.component.filter.Filter;
   import codo.component.loadout.LoadoutViewPanelBase;
   import codo.component.scrollgrid.parts.ScrollGridSortOrderToggle;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   
   public class LobbyMarketPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const TAB_GAMEMODE:Object = {
         "label":MarketMenuData.CATEGORY_GAMEMODE.label,
         "listData":[MarketMenuData.CATEGORY_GAMEMODE]
      };
      
      public static const DEFAULT_CONTAINER_WIDTH:Number = 515;
      
      public static const RECOMMENDED_CONTAINER_WIDTH:Number = 682;
      
      public static const CONTAINER_HEIGHT:Number = 755;
      
      public var myCloseButton:CloseButton;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myLabel:TextField;
      
      public var myContainer:ContentContainer;
      
      public var myFilter:Filter;
      
      public var mySortingSelector:ComboBox;
      
      public var mySortingOrderSelector:ScrollGridSortOrderToggle;
      
      public var myDisabledCategory0:Sprite;
      
      public var myDisabledCategory1:Sprite;
      
      public var myDisabledCategory2:Sprite;
      
      public var myDisabledCategory3:Sprite;
      
      public var myDisabledCategory4:Sprite;
      
      public var myDisabledCategory5:Sprite;
      
      private var mCloseCallback:Function;
      
      private var mCurrentTab:Object = TAB_GAMEMODE;
      
      protected var _itemsData:Array;
      
      public function LobbyMarketPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myContainer.showAccents = false;
         this.myContainer.width = DEFAULT_CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myCloseButton.registerClickEvent(this.onCloseClicked);
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myLabel.width = RECOMMENDED_CONTAINER_WIDTH;
         this.myLabel.text = Dict.MAIN_MENU_LABEL_MARKET;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD;
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         this.myScrollGrid.initGrid(gridSettings,4,false,2);
         this.myFilter.singleOptionMode = true;
         this.mySortingSelector.listWidth = 140;
         this.myDisabledCategory0.visible = false;
         this.myDisabledCategory1.visible = false;
         this.myDisabledCategory2.visible = false;
         this.myDisabledCategory3.visible = false;
         this.myDisabledCategory4.visible = false;
         this.myDisabledCategory5.visible = false;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         this.mySortingSelector.makeUiCpp();
         return new UiCppItemListView(this,this.mySortingSelector,this.mySortingOrderSelector,this.myFilter.getUiCpp());
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         if(true == ScaleformUtil.isScaleform)
         {
            UiCppItemListView(_uiCpp).SetInitData(this.mCurrentTab.listData,false);
         }
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         ScaleformUtil.setInLobbyLoadout(false);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         ScaleformUtil.setInLobbyLoadout(true);
      }
      
      public function setMode(m:Object) : void
      {
         this.mCurrentTab = m;
         if(true == ScaleformUtil.isScaleform)
         {
            UiCppItemListView(_uiCpp).SetInitData(this.mCurrentTab.listData,false);
         }
      }
      
      public function registerCloseCallback(f:Function) : void
      {
         this.mCloseCallback = f;
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = MarketScrollGrid.initSplitList(this.myScrollGrid,true,list1,list2,ownedFirst);
         this.refreshItems();
      }
      
      private function refreshItems() : void
      {
         var marketItemsData:Vector.<Object> = new Vector.<Object>();
         var len:int = int(this._itemsData.length);
         for(var itemIdx:int = 0; itemIdx < len; itemIdx++)
         {
            marketItemsData.push(this._itemsData[itemIdx]);
         }
         this.myScrollGrid.addItemsByVector(marketItemsData);
      }
      
      private function onCloseClicked() : void
      {
         if(null != this.mCloseCallback)
         {
            this.mCloseCallback(this);
         }
      }
   }
}

