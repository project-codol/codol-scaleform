package codo.component.loadout
{
   import codo.component.ScrollGrid;
   import codo.component.factory.MarketFactory;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   
   public class LoadoutViewRequisitionsPanelConsumablesBase extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      private static const INSTRUCTIONS_WIDTH:Number = 700;
      
      private static const INSTRUCTIONS_HEIGHT:Number = 200;
      
      private static const MASK_SIZE_Y:Number = 587;
      
      public var myScrollGrid:ScrollGrid;
      
      protected var _itemsData:Array;
      
      public function LoadoutViewRequisitionsPanelConsumablesBase()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         labelStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         labelStyle.fontColor = GlobalGuide.WHITE;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD;
         gridSettings.useNavArrows = false;
         this.myScrollGrid.initGrid(gridSettings,MASK_SIZE_Y,true,3);
         myHeaderTitle.width = INSTRUCTIONS_WIDTH;
         myHeaderTitle.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_CONSUMABLE).toUpperCase();
         myInstructions.width = INSTRUCTIONS_WIDTH;
         myInstructions.height = INSTRUCTIONS_HEIGHT;
         myInstructions.text = LocalizeUtil.localize(Dict.REQUISITIONS_CONSUMABLES_INSTRUCTIONS);
      }
      
      protected function set headerTitle(title:String) : void
      {
         myHeaderTitle.text = LocalizeUtil.localize(title).toUpperCase();
      }
      
      protected function set instructions(instructions:String) : void
      {
         myInstructions.text = LocalizeUtil.localize(instructions);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this);
      }
      
      override protected function onInit() : void
      {
         var categoryArr:Array = this.getCategoryArr();
         UiCppItemListView(_uiCpp).SetInitData(categoryArr,true);
      }
      
      protected function getCategoryArr() : Array
      {
         return [];
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = list1.concat(list2);
         this.refreshList();
      }
      
      protected function refreshList() : void
      {
         var items:Vector.<Object> = new Vector.<Object>();
         for(var i:int = 0; i < this._itemsData.length; i++)
         {
            items.push(this._itemsData[i]);
         }
         this.myScrollGrid.addItemsByVector(items);
      }
   }
}

