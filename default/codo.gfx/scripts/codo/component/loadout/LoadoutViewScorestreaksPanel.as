package codo.component.loadout
{
   import codo.component.MarketScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.component.filter.Filter;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.manager.EventManager;
   import codo.objects.BindDataHelper;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.WeaponLoadoutObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class LoadoutViewScorestreaksPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      private static const STREAK_WIDTH:Number = 122;
      
      private static const STREAK_HEIGHT:Number = 122;
      
      private static const FRAME_WIDTH:Number = 778;
      
      private static const FRAME_HEIGHT:Number = 791;
      
      private static const STREAK_IMAGE_SCALE:Number = 1.6;
      
      private static const INSTRUCTIONS_WIDTH:Number = 200;
      
      private static const INSTRUCTIONS_HEIGHT:Number = 124;
      
      private static const MASK_SIZE_Y:Number = 581;
      
      public var myStreak0:LoadoutButton;
      
      public var myStreak1:LoadoutButton;
      
      public var myStreak2:LoadoutButton;
      
      public var myScrollGrid:MarketScrollGrid;
      
      public var myStreakCost0:TextField;
      
      public var myStreakCost1:TextField;
      
      public var myStreakCost2:TextField;
      
      public var myFrame:MovieClip;
      
      public var myFilter:Filter;
      
      protected var mBindWeaponLoadoutSlotsData:BindDataHelper;
      
      protected var _itemsData:Array;
      
      public function LoadoutViewScorestreaksPanel()
      {
         super();
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myScrollGrid.setFrame(this.myFrame,204);
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD_WITH_MARKET_TOOLS;
         gridSettings.useNavArrows = false;
         this.myScrollGrid.initGrid(gridSettings,MASK_SIZE_Y,true,3);
         this.mBindWeaponLoadoutSlotsData = new BindDataHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.bindLoadoutData);
         myHeaderTitle.width = 200;
         myHeaderTitle.text = LocalizeUtil.localize(Dict.LOADOUT_CATEGORY_SCORESTREAKS).toUpperCase();
         this.myStreak0.width = STREAK_WIDTH;
         this.myStreak0.height = STREAK_HEIGHT;
         this.myStreak1.width = STREAK_WIDTH;
         this.myStreak1.height = STREAK_HEIGHT;
         this.myStreak2.width = STREAK_WIDTH;
         this.myStreak2.height = STREAK_HEIGHT;
         this.myStreak0.scaleImage(STREAK_IMAGE_SCALE);
         this.myStreak1.scaleImage(STREAK_IMAGE_SCALE);
         this.myStreak2.scaleImage(STREAK_IMAGE_SCALE);
         this.myStreak0.registerFocusEvent(onLoadoutSlotFocused,this.myStreak0);
         this.myStreak1.registerFocusEvent(onLoadoutSlotFocused,this.myStreak1);
         this.myStreak2.registerFocusEvent(onLoadoutSlotFocused,this.myStreak2);
         this.myStreak0.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myStreak0);
         this.myStreak1.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myStreak1);
         this.myStreak2.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myStreak2);
         this.myStreak0.registerClearCallback(this.clearSlot);
         this.myStreak1.registerClearCallback(this.clearSlot);
         this.myStreak2.registerClearCallback(this.clearSlot);
         var streakStyle:TextStyle = new TextStyle();
         streakStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         streakStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         streakStyle.fontColor = GlobalGuide.WHITE;
         this.myStreakCost0.textStyle = streakStyle;
         this.myStreakCost1.textStyle = streakStyle;
         this.myStreakCost2.textStyle = streakStyle;
         this.myStreakCost0.mouseChildren = false;
         this.myStreakCost0.mouseEnabled = false;
         this.myStreakCost1.mouseChildren = false;
         this.myStreakCost1.mouseEnabled = false;
         this.myStreakCost2.mouseChildren = false;
         this.myStreakCost2.mouseEnabled = false;
         myInstructions.wordWrap = true;
         myInstructions.width = INSTRUCTIONS_WIDTH;
         myInstructions.height = INSTRUCTIONS_HEIGHT;
         myInstructions.text = LocalizeUtil.localize(Dict.LOADOUT_SCORESTREAK_INSTRUCTIONS);
         this.myFilter.singleOptionMode = true;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,null,null,this.myFilter.getUiCpp());
      }
      
      override protected function enableData() : void
      {
         this.mBindWeaponLoadoutSlotsData.bind();
      }
      
      override protected function disableData() : void
      {
         this.mBindWeaponLoadoutSlotsData.unbind();
      }
      
      override protected function onInit() : void
      {
         UiCppItemListView(_uiCpp).SetInitData(MarketMenuData.INVENTORY_KILLSTREAKS,true);
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = MarketScrollGrid.initSplitList(this.myScrollGrid,true,list1,list2,ownedFirst);
         this.refreshItems();
      }
      
      protected function refreshItems() : void
      {
         var items:Vector.<Object> = new Vector.<Object>();
         for(var i:int = 0; i < this._itemsData.length; i++)
         {
            items.push(this._itemsData[i]);
         }
         this.myScrollGrid.addItemsByVector(items);
      }
      
      private function bindLoadoutData(cResult:Object) : void
      {
         var loadoutButton:LoadoutButton = null;
         var label:TextField = null;
         var prodData:ProductObj = null;
         var weaponLoadout:WeaponLoadoutObj = new WeaponLoadoutObj(cResult.data);
         var sortedStreaks:Array = ItemUtil.sortStreaks([weaponLoadout.killStreakSlot_0,weaponLoadout.killStreakSlot_1,weaponLoadout.killStreakSlot_2]);
         for(var i:int = 0; i < 3; i++)
         {
            loadoutButton = this["myStreak" + i];
            loadoutButton.setData(sortedStreaks[i].slot);
            label = this["myStreakCost" + i];
            prodData = sortedStreaks[i].item;
            label.text = Boolean(prodData.killsReq) ? prodData.killsReq.toString() : "";
         }
      }
      
      private function clearSlot(slot:LoadoutButton) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":slot.getData()});
      }
   }
}

