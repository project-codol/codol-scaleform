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
   import codo.constants.DataID;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.DataManager;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   
   public class LobbyLoadoutSelectItemPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const CONTAINER_WIDTH:Number = 520;
      
      public static const CONTAINER_HEIGHT:Number = 748;
      
      public static const ITEM_COUNT_PADDING:Number = 5;
      
      public static const GRID_COLS:int = 2;
      
      public static const GRID_ROWS:int = 4;
      
      public var myCloseButton:CloseButton;
      
      public var myFilter:Filter;
      
      public var myScrollGrid:ScrollGrid;
      
      public var mySortingSelector:ComboBox;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myLabel:TextField;
      
      public var myContainer:ContentContainer;
      
      private var mBackCallback:Function;
      
      protected var mComparePrimaryWeapon:Boolean = true;
      
      protected var _itemsData:Array;
      
      public function LobbyLoadoutSelectItemPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myItemCountLabel.fontSize = this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         if(true == ScaleformUtil.isScaleform)
         {
            this.myLabel.width = CONTAINER_WIDTH;
            this.myLabel.text = LocalizeUtil.localize(Dict.LOBBY_LOADOUTS_LABEL);
         }
         this.myContainer.showAccents = false;
         this.myContainer.width = CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myCloseButton.registerClickEvent(this.onCloseClicked);
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD;
         gridSettings.useNavArrows = false;
         this.myScrollGrid.initGrid(gridSettings,GRID_ROWS,false,GRID_COLS);
         this.myFilter.singleOptionMode = true;
         this.mySortingSelector.listWidth = 140;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         this.mySortingSelector.makeUiCpp();
         return new UiCppItemListView(this,this.mySortingSelector,null,this.myFilter.getUiCpp());
      }
      
      public function registerBackCallback(f:Function) : void
      {
         this.mBackCallback = f;
      }
      
      public function setIsPrimaryWeapon(isPrimary:Boolean) : void
      {
         this.mComparePrimaryWeapon = isPrimary;
      }
      
      public function setCategories(categories:Array) : void
      {
         if(true == ScaleformUtil.isScaleform)
         {
            UiCppItemListView(_uiCpp).SetInitData(categories,true);
         }
      }
      
      public function setLoadoutLabel(label:String) : void
      {
         this.myLabel.text = label;
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = MarketScrollGrid.initSplitList(this.myScrollGrid,true,list1,list2,ownedFirst);
         this.refreshItems();
      }
      
      private function refreshItems() : void
      {
         var items:Vector.<Object> = new Vector.<Object>();
         for(var i:int = 0; i < this._itemsData.length; i++)
         {
            items.push(this._itemsData[i]);
         }
         this.myScrollGrid.addItemsByVector(items);
         this.myItemCount.text = items.length.toString();
         this.myItemCountLabel.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_COUNT);
         this.myItemCountLabel.x = this.myItemCount.x + this.myItemCount.textWidth + ITEM_COUNT_PADDING;
      }
      
      private function onCloseClicked() : void
      {
         if(null != this.mBackCallback)
         {
            this.mBackCallback(this);
         }
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DataManager.getInstance().bind(DataID.ROOM_INFO,this.onRoomInfoUpdated,null,false,true,false);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().unbind(DataID.ROOM_INFO,this.onRoomInfoUpdated);
         this.mySortingSelector.toggled = false;
      }
      
      private function onRoomInfoUpdated() : void
      {
         repopulateList(this.myScrollGrid);
      }
   }
}

