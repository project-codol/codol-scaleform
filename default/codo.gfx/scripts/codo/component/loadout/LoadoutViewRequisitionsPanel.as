package codo.component.loadout
{
   import codo.component.filter.Filter;
   import codo.component.filter.FilterCategoryButton;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.manager.EventManager;
   import flash.display.MovieClip;
   
   public class LoadoutViewRequisitionsPanel extends LoadoutViewPanelBase
   {
      
      public static const CONTAINER_WIDTH:Number = 778;
      
      public static const CONTAINER_HEIGHT:Number = 791;
      
      public var myFilter:Filter;
      
      public var myFrame:MovieClip;
      
      public var myEquippablesPanel:LoadoutViewRequisitionsPanelEquippables;
      
      public var myConsumablesPanel:LoadoutViewRequisitionsPanelConsumables;
      
      public var myShardsPanel:LoadoutViewRequisitionsPanelConsumablesShards;
      
      private var mCurrentPanel:LoadoutViewPanelBase;
      
      public function LoadoutViewRequisitionsPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myEquippablesPanel.myBadgeSlot0.registerClearCallback(this.clearSlot);
         this.myEquippablesPanel.myBadgeSlot1.registerClearCallback(this.clearSlot);
         this.myEquippablesPanel.myBadgeSlot2.registerClearCallback(this.clearSlot);
         this.myEquippablesPanel.myConsumableSlot.registerClearCallback(this.clearSlot);
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myEquippablesPanel.myScrollGrid.setFrame(this.myFrame,204);
         this.myConsumablesPanel.myScrollGrid.setFrame(this.myFrame,166);
         this.myShardsPanel.myScrollGrid.setFrame(this.myFrame,166);
         this.myFilter.singleOptionMode = true;
         this.myFilter.setData(MarketMenuData.INVENTORY_REQUISITIONS);
         this.myFilter.addOnSubCategoryCheckedCallback(this.onSubCategoryclicked);
         this.mCurrentPanel = this.myEquippablesPanel;
      }
      
      override protected function enableData() : void
      {
         this.mCurrentPanel.showPanel();
      }
      
      override protected function disableData() : void
      {
         this.mCurrentPanel.hidePanel();
      }
      
      private function onSubCategoryclicked() : void
      {
         var newPanel:LoadoutViewPanelBase = null;
         var category:FilterCategoryButton = this.myFilter.currentCategory;
         var states:Array = category.subcategoryStates;
         if(true == states[MarketMenuData.EQUIPPABLES_TAB])
         {
            this.myEquippablesPanel.changeGridToType(LoadoutViewRequisitionsPanelEquippables.SHOW_BADGES);
            newPanel = this.myEquippablesPanel;
         }
         else if(true == states[MarketMenuData.CONSUMABLES_TAB])
         {
            newPanel = this.myConsumablesPanel;
         }
         else if(true == states[MarketMenuData.CONSUMABLES_TAB_ADVANCED])
         {
            this.myEquippablesPanel.changeGridToType(LoadoutViewRequisitionsPanelEquippables.SHOW_ADVANCED_CONSUMABLES);
            newPanel = this.myEquippablesPanel;
         }
         else if(true == states[MarketMenuData.CONSUMABLES_TAB_SHARDS])
         {
            newPanel = this.myShardsPanel;
         }
         if(this.mCurrentPanel != newPanel)
         {
            this.mCurrentPanel.hidePanel();
            this.mCurrentPanel = newPanel;
            this.mCurrentPanel.showPanel();
         }
      }
      
      private function clearSlot(slot:LoadoutButton) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_BY_ITEM,{"data":slot.getData()});
      }
   }
}

