package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.MarketFactory;
   import codo.component.scrollgrid.parts.ScrollGridSortOrderToggle;
   import codo.component.scrollgrid.parts.ScrollGridToggleItemSize;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class MarketplaceGridControls extends MovieClip
   {
      
      private static const SMALL_NUM_COLUMNS:int = 3;
      
      private static const SMALL_NUM_COLUMNS_WITH_MODEL:int = 3;
      
      private static const LARGE_NUM_COLUMNS:int = 2;
      
      private static const LARGE_NUM_COLUMNS_WITH_MODEL:int = 2;
      
      private static const DEFAULT_WIDTH:Number = 606;
      
      private static const MASK_SIZE_Y:Number = 657 + 30;
      
      public var myToggleItemSizeSmall:ScrollGridToggleItemSize;
      
      public var myToggleItemSizeMedium:ScrollGridToggleItemSize;
      
      public var mySortingSelector:ComboBox;
      
      public var mySecondaryFilterSelector:ComboBox;
      
      public var mySortingOrderSelector:ScrollGridSortOrderToggle;
      
      public var myPreviewSelector:MarketplaceItemPreviewSelector;
      
      private var mScrollGrid:ScrollGrid;
      
      private var mGridSettings:ScrollGridSettings;
      
      private var mShowingModel:Boolean = false;
      
      private var mOnRefreshCallback:Function;
      
      private var mShowPurchasingTools:Boolean = false;
      
      private var mWidth:Number;
      
      private var mGridHeight:int;
      
      public function MarketplaceGridControls()
      {
         super();
         this.width = DEFAULT_WIDTH;
         this.mySortingSelector.listWidth = 140;
         this.mySortingSelector.makeUiCpp();
         this.mySecondaryFilterSelector.listWidth = 140;
         this.mySecondaryFilterSelector.makeUiCpp();
         this.myToggleItemSizeMedium.visible = false;
         this.myToggleItemSizeSmall.visible = false;
      }
      
      public function setData(data:Object, gridHeight:int = -1) : void
      {
         this.mOnRefreshCallback = data.refreshCallback;
         this.mScrollGrid = data.scrollGrid;
         this.mShowingModel = data.showingModel;
         this.mGridHeight = gridHeight > 0 ? gridHeight : int(MASK_SIZE_Y);
         this.updateGridSettings();
      }
      
      public function set gridHeight(gridHeight:int) : void
      {
         this.mGridHeight = gridHeight > 0 ? gridHeight : int(MASK_SIZE_Y);
         this.updateGridSettings();
      }
      
      public function get gridHeight() : int
      {
         return this.mGridHeight;
      }
      
      public function set showPurchasingTools(showTools:Boolean) : void
      {
         this.mShowPurchasingTools = showTools;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      private function updateGridSettings() : void
      {
         var columns:uint = 0;
         this.mGridSettings = new ScrollGridSettings();
         this.mGridSettings.useNavArrows = false;
         this.mGridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         if(this.myToggleItemSizeMedium.enabled)
         {
            this.mGridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD_WITH_MARKET_TOOLS;
            columns = true == this.mShowingModel ? uint(SMALL_NUM_COLUMNS_WITH_MODEL) : uint(SMALL_NUM_COLUMNS);
         }
         else
         {
            this.mGridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_MEDIUM_CARD_WITH_MARKET_TOOLS;
            columns = true == this.mShowingModel ? uint(LARGE_NUM_COLUMNS_WITH_MODEL) : uint(LARGE_NUM_COLUMNS);
         }
         this.mScrollGrid.initGrid(this.mGridSettings,this.mGridHeight,true,columns);
      }
      
      private function onLargeGridButtonClicked(target:UIInteractiveComponent) : void
      {
         this.myToggleItemSizeSmall.enabled = true;
         this.myToggleItemSizeMedium.enabled = false;
         this.updateGridSettings();
         this.mOnRefreshCallback();
      }
      
      private function onSmallGridButtonClicked(target:UIInteractiveComponent) : void
      {
         this.myToggleItemSizeSmall.enabled = false;
         this.myToggleItemSizeMedium.enabled = true;
         this.updateGridSettings();
         this.mOnRefreshCallback();
      }
      
      private function draw() : void
      {
         this.myPreviewSelector.x = this.mWidth - this.myPreviewSelector.width;
         this.mySortingOrderSelector.x = this.myPreviewSelector.x - this.mySortingOrderSelector.width * 0.5 - GlobalGuide.COMPONENT_PADDING;
         this.mySortingSelector.x = this.mySortingOrderSelector.x - this.mySortingOrderSelector.width * 0.5 - this.mySortingSelector.width - GlobalGuide.COMPONENT_PADDING;
         this.mySecondaryFilterSelector.x = this.mySortingSelector.x - this.mySecondaryFilterSelector.width - GlobalGuide.COMPONENT_PADDING;
         this.myToggleItemSizeMedium.x = this.mySortingSelector.x - this.myToggleItemSizeMedium.width * 0.5 - GlobalGuide.COMPONENT_PADDING;
         this.myToggleItemSizeSmall.x = this.myToggleItemSizeMedium.x - this.myToggleItemSizeSmall.width - GlobalGuide.COMPONENT_PADDING;
      }
   }
}

