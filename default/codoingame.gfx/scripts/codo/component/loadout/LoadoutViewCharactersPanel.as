package codo.component.loadout
{
   import codo.component.ContentContainer;
   import codo.component.MarketScrollGrid;
   import codo.component.MarketplaceGridControls;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.factory.ButtonFactory;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.DictMarket;
   import codo.objects.CustomObject;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   
   public class LoadoutViewCharactersPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const LIST_WIDTH:Number = 200;
      
      public static const LIST_HEIGHT:Number = 600;
      
      public static const CONTAINER_WIDTH:Number = 678;
      
      public static const CONTAINER_HEIGHT:Number = 632;
      
      private static const ITEM_COUNT_PADDING:Number = 5;
      
      public var myScrollList:ScrollList;
      
      public var myScrollGrid:MarketScrollGrid;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myMarketplaceControls:MarketplaceGridControls;
      
      public var myFrame:ContentContainer;
      
      public function LoadoutViewCharactersPanel()
      {
         var listSettings:ScrollListSettings = null;
         var itemData:CustomObject = null;
         super();
         var marketControlsSettings:Object = {
            "refreshCallback":this.refresh,
            "scrollGrid":this.myScrollGrid,
            "showingModel":false
         };
         this.myMarketplaceControls.setData(marketControlsSettings);
         listSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.autoSize = false;
         this.myScrollList.settings = listSettings;
         this.myScrollList.resetList();
         for(var i:int = 0; i < 8; i++)
         {
            itemData = new CustomObject();
            itemData.label = "Character " + i;
            itemData.clickEvent = onListItemClicked;
            itemData.clickEventData = i;
            itemData.id = i;
            this.myScrollList.addItem(itemData,ButtonFactory.GENERIC_BUTTON_LINKAGE);
         }
         this.myScrollList.width = LIST_WIDTH;
         this.myScrollList.height = LIST_HEIGHT;
         this.myScrollList.refreshVisuals();
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
      }
      
      private static function onListItemClicked(item:int) : void
      {
         trace("LIST ITEM CLICKED: " + item);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,this.myMarketplaceControls.mySortingSelector,this.myMarketplaceControls.mySortingOrderSelector,null,this.myMarketplaceControls.mySecondaryFilterSelector);
      }
      
      override protected function onInit() : void
      {
         var categoryData:Array = [{"id":MarketMenuData.TYPE_CHARACTER}];
         if(true == ScaleformUtil.isScaleform)
         {
            UiCppItemListView(_uiCpp).SetInitData(categoryData,true);
         }
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this.myScrollGrid.setItemsData(list1,list2,ownedFirst);
         this.refresh();
      }
      
      private function refresh() : void
      {
         this.myScrollGrid.refresh();
         this.myItemCount.text = this.myScrollGrid.listData.length.toString();
         this.myItemCountLabel.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_COUNT);
         this.myItemCountLabel.x = this.myItemCount.x + this.myItemCount.textWidth + ITEM_COUNT_PADDING;
      }
   }
}

