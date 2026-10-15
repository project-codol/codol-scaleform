package codo.component.loadout
{
   import codo.component.MarketScrollGrid;
   import codo.component.MarketplaceGridControls;
   import codo.component.TextField;
   import codo.component.filter.LoadoutFilter;
   import codo.constants.BCCommonEvent;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class LoadoutViewGearPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const CONTAINER_WIDTH:Number = 778;
      
      public static const CONTAINER_HEIGHT:Number = 791;
      
      private static const ITEM_COUNT_PADDING:Number = 5;
      
      private static const INSTRUCTIONS_WIDTH:Number = 660;
      
      private static const CONTROLS_WIDTH:Number = 700;
      
      private static const EMOTE_SETTING_PANNEL_PADDING:Number = 10;
      
      private static const GRID_OFFSET_TO_MARKETPLACE_CONTROL:Number = 28;
      
      private static const MARKETPLACE_CONTROL_OFFSET_TO_FRAME:Number = 60;
      
      private static const EMOTE_PANEL_EXTRA_FRAME_HEIGHT:Number = 94;
      
      private static const MASK_SIZE_Y:Number = 657;
      
      private static const MASK_SIZE_Y_EMOTE:Number = 545;
      
      public var myLoadoutFilter:LoadoutFilter;
      
      public var myScrollGrid:MarketScrollGrid;
      
      public var myItemCount:TextField;
      
      public var myItemCountLabel:TextField;
      
      public var myEmoteSettingsPanel:LoadoutViewGearPanelEmoteSettingsPanel;
      
      public var myMarketplaceControls:MarketplaceGridControls;
      
      public var myFrame:MovieClip;
      
      private var mGridHeightDelta:Number;
      
      public function LoadoutViewGearPanel()
      {
         super();
         this.myEmoteSettingsPanel.visible = false;
         this.myMarketplaceControls.width = CONTROLS_WIDTH;
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myScrollGrid.setFrame(this.myFrame,134);
         this.myItemCountLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myItemCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myItemCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myItemCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         myInstructions.width = INSTRUCTIONS_WIDTH;
         myInstructions.text = LocalizeUtil.localize(Dict.LOADOUT_GEAR_INSTRUCTIONS);
         this.mGridHeightDelta = 0;
         EventManager.getInstance().listen(BCCommonEvent.EVT_REFRESH_EMOTE_SETTING_PANEL,this.onRefreshEmoteSettings);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,this.myMarketplaceControls.mySortingSelector,this.myMarketplaceControls.mySortingOrderSelector,this.myLoadoutFilter.getUiCpp(),this.myMarketplaceControls.mySecondaryFilterSelector);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         if(true == ScaleformUtil.isScaleform)
         {
            this.myLoadoutFilter.refreshCharacters(this);
            UiCppItemListView(_uiCpp).SetInitData([null],true);
         }
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         var gridHeight:Number = NaN;
         var marketControlsSettings:Object = null;
         if(this.myLoadoutFilter.currentCategoryIndex == 1)
         {
            this.myItemCount.visible = this.myItemCountLabel.visible = false;
            this.myEmoteSettingsPanel.visible = true;
            this.myEmoteSettingsPanel.y = this.myFrame.y + MARKETPLACE_CONTROL_OFFSET_TO_FRAME;
            this.myMarketplaceControls.y = this.myEmoteSettingsPanel.y + this.myEmoteSettingsPanel.height - GRID_OFFSET_TO_MARKETPLACE_CONTROL;
            this.myScrollGrid.y = this.myEmoteSettingsPanel.y + this.myEmoteSettingsPanel.height + EMOTE_SETTING_PANNEL_PADDING;
            gridHeight = MASK_SIZE_Y_EMOTE + this.mGridHeightDelta;
         }
         else
         {
            this.myItemCount.visible = this.myItemCountLabel.visible = true;
            this.myEmoteSettingsPanel.visible = false;
            this.myMarketplaceControls.y = this.myFrame.y + MARKETPLACE_CONTROL_OFFSET_TO_FRAME;
            this.myScrollGrid.y = this.myMarketplaceControls.y + GRID_OFFSET_TO_MARKETPLACE_CONTROL + EMOTE_SETTING_PANNEL_PADDING;
            gridHeight = MASK_SIZE_Y + this.mGridHeightDelta;
         }
         if(this.myMarketplaceControls.gridHeight != gridHeight)
         {
            marketControlsSettings = {
               "refreshCallback":this.refresh,
               "scrollGrid":this.myScrollGrid,
               "showingModel":false
            };
            this.myMarketplaceControls.setData(marketControlsSettings,gridHeight);
         }
         this.myScrollGrid.setItemsData(list1,list2,ownedFirst);
         this.refresh();
      }
      
      public function set gridHeightDelta(gridHeightDelta:Number) : void
      {
         this.mGridHeightDelta = gridHeightDelta;
      }
      
      private function refresh() : void
      {
         this.myScrollGrid.refresh();
         if(this.myLoadoutFilter.currentCategoryIndex == 1)
         {
            this.myFrame.height += EMOTE_PANEL_EXTRA_FRAME_HEIGHT;
         }
         this.myItemCount.text = this.myScrollGrid.listData.length.toString();
         this.myItemCountLabel.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_COUNT);
         this.myItemCountLabel.x = this.myItemCount.x + this.myItemCount.textWidth + ITEM_COUNT_PADDING;
      }
      
      public function updatePreviewList() : void
      {
         this.myScrollGrid.previewItemUpdated();
      }
      
      public function onRefreshEmoteSettings() : void
      {
         this.myEmoteSettingsPanel.updateEmoteSetting();
      }
   }
}

