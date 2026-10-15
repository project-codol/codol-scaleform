package codo.component.loadout
{
   import codo.component.MarketplaceGridControls;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.component.filter.Filter;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class LoadoutViewLockerPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const CONTAINER_WIDTH:Number = 778;
      
      public static const CONTAINER_HEIGHT:Number = 791;
      
      private static const ITEM_COUNT_PADDING:Number = 5;
      
      public var myFilter:Filter;
      
      public var myFrame:MovieClip;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myMarketplaceControls:MarketplaceGridControls;
      
      public var myNoItemsText:TextField;
      
      protected var _itemsData:Array;
      
      public function LoadoutViewLockerPanel()
      {
         super();
         this.initStage();
      }
      
      public function initStage() : void
      {
         this.myMarketplaceControls.visible = false;
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myFrame.gotoAndStop(3);
         this.myScrollGrid.setFrame(this.myFrame,95);
         this.myFilter.singleOptionMode = true;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.GET_BUILD_MARKET_ITEM_CARD_FUNC(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false,true,false);
         gridSettings.useNavArrows = false;
         this.myScrollGrid.initGrid(gridSettings,4,false,3);
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myItemCount.fontColor = GlobalGuide.GRAY_80;
         this.myNoItemsText.text = LocalizeUtil.localize(Dict.STORAGE_LOCKER_NO_ITEMS);
         this.myNoItemsText.x = this.myFrame.x + (this.myFrame.width - this.myNoItemsText.textWidth) / 2;
         this.myNoItemsText.visible = false;
         myInstructions.width = 800;
         myInstructions.height = 40;
         myInstructions.text = LocalizeUtil.localize(Dict.STORAGE_LOCKER_DESCRIPTION);
         myInstructions.alignment = TextStyle.HALIGN_RIGHT;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,null,null,this.myFilter.getUiCpp());
      }
      
      override protected function onInit() : void
      {
         var categoryArr:Array = [MarketMenuData.CATEGORY_STORAGE_GEAR];
         UiCppItemListView(_uiCpp).SetInitData(categoryArr,true,false,true);
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = ownedFirst ? list1 : list2;
         this.refreshList();
      }
      
      protected function refreshList() : void
      {
         var item:ProductObj = null;
         var items:Vector.<Object> = new Vector.<Object>();
         var len:uint = this._itemsData.length;
         for(var i:int = 0; i < len; i++)
         {
            item = this._itemsData[i];
            items.push(item);
         }
         this.myScrollGrid.addItemsByVector(items);
         this.myNoItemsText.visible = len == 0;
         if(this.myNoItemsText.visible)
         {
            this.myNoItemsText.y = this.myFrame.y + 10 + (this.myFrame.height - this.myNoItemsText.textHeight) / 2;
         }
         this.myItemCount.text = this.myScrollGrid.listData.length.toString();
         this.myItemCountLabel.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_COUNT);
         this.myItemCountLabel.x = this.myItemCount.x + this.myItemCount.textWidth + ITEM_COUNT_PADDING;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         ScaleformUtil.setInInventoryStorage(true);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         ScaleformUtil.setInInventoryStorage(false);
      }
   }
}

