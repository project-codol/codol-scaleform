package codo.views
{
   import codo.base.BaseView;
   import codo.component.ContentContainer;
   import codo.component.MarketScrollGrid;
   import codo.component.MarketplaceGridControls;
   import codo.component.TextField;
   import codo.component.WeaponStatsGraph;
   import codo.component.filter.Filter;
   import codo.constants.BCEvent;
   import codo.constants.ItemType;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.event.ParaEvent;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   
   public class MarketplaceBaseView extends BaseView implements IUiCppItemListView
   {
      
      public var myFilter:Filter;
      
      public var myFrame:ContentContainer;
      
      public var myScrollGrid:MarketScrollGrid;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myStatGraph:WeaponStatsGraph;
      
      public var myMarketplaceControls:MarketplaceGridControls;
      
      protected var mShowModel:Boolean;
      
      public function MarketplaceBaseView()
      {
         super();
         this.myFilter.singleOptionMode = true;
         this.initStage();
      }
      
      protected function initStage() : void
      {
         var FRAME_WIDTH:Number = 778;
         var FRAME_HEIGHT:Number = 791;
         var CONTROLS_WIDTH:Number = 700;
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myScrollGrid.setFrame(this.myFrame,99);
         this.myMarketplaceControls.width = CONTROLS_WIDTH;
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
      }
      
      override protected function showView() : void
      {
         super.showView();
         listen(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.onUpdatePreviewList);
      }
      
      override protected function hideView() : void
      {
         unlisten(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.onUpdatePreviewList);
         super.hideView();
         broadcast(BCEvent.EVT_PREVIEW_REMOVE_ALL);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,this.myMarketplaceControls.mySortingSelector,this.myMarketplaceControls.mySortingOrderSelector,this.myFilter.getUiCpp(),this.myMarketplaceControls.mySecondaryFilterSelector);
      }
      
      override public function set routeData(data:*) : void
      {
         var itemData:ProductObj = null;
         this.myStatGraph.visible = false;
         this.mShowModel = false;
         if(null != data.modelItemData)
         {
            this.mShowModel = true;
            itemData = data.modelItemData as ProductObj;
            if(itemData.type == ItemType.WEAPON)
            {
               this.setupStats(itemData);
               this.myStatGraph.visible = true;
            }
         }
         var marketControlsSettings:Object = {
            "refreshCallback":this.refresh,
            "scrollGrid":this.myScrollGrid,
            "showingModel":this.mShowModel
         };
         this.myMarketplaceControls.showPurchasingTools = true;
         this.myMarketplaceControls.setData(marketControlsSettings);
         this.myScrollGrid.resetHeaderStates();
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this.myScrollGrid.setItemsData(list1,list2,ownedFirst);
         this.refresh();
      }
      
      protected function refresh() : void
      {
         if(!visible)
         {
            return;
         }
         var ITEM_COUNT_PADDING:Number = 5;
         this.myScrollGrid.refresh();
         this.myItemCount.text = this.myScrollGrid.listData.length.toString();
         this.myItemCountLabel.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_COUNT);
         this.myItemCountLabel.x = this.myItemCount.x + this.myItemCount.textWidth + ITEM_COUNT_PADDING;
      }
      
      private function setupStats(itemData:ProductObj) : void
      {
         var data:WeaponStatsObj = new WeaponStatsObj(itemData);
         this.myStatGraph.setData(data);
      }
      
      private function onUpdatePreviewList(e:ParaEvent) : void
      {
         this.myScrollGrid.previewItemUpdated();
      }
   }
}

