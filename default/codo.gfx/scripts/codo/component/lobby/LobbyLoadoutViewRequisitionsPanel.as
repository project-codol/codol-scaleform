package codo.component.lobby
{
   import codo.component.filter.Filter;
   import codo.component.filter.FilterCategoryButton;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutViewPanelBase;
   import codo.component.loadout.LoadoutViewRequisitionsPanelConsumables;
   import codo.component.loadout.LoadoutViewRequisitionsPanelConsumablesShards;
   import codo.component.loadout.LoadoutViewRequisitionsPanelEquippables;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.RoomMemberObj;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class LobbyLoadoutViewRequisitionsPanel extends LoadoutViewPanelBase
   {
      
      public static const CONTAINER_WIDTH:Number = 766;
      
      public static const CONTAINER_HEIGHT:Number = 790;
      
      public var myFilter:Filter;
      
      public var myFrame:MovieClip;
      
      public var myEquippablesPanel:LobbyLoadoutViewRequisitionsPanelEquippables;
      
      public var myConsumablesPanel:LoadoutViewRequisitionsPanelConsumables;
      
      public var myShardsPanel:LoadoutViewRequisitionsPanelConsumablesShards;
      
      private var mCurrentPanel:LoadoutViewPanelBase;
      
      public function LobbyLoadoutViewRequisitionsPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myEquippablesPanel.myBadgeSlot0.registerFocusEvent(onLoadoutSlotFocused,this.myEquippablesPanel.myBadgeSlot0);
         this.myEquippablesPanel.myBadgeSlot1.registerFocusEvent(onLoadoutSlotFocused,this.myEquippablesPanel.myBadgeSlot1);
         this.myEquippablesPanel.myBadgeSlot2.registerFocusEvent(onLoadoutSlotFocused,this.myEquippablesPanel.myBadgeSlot2);
         this.myEquippablesPanel.myConsumableSlot.registerFocusEvent(onLoadoutSlotFocused,this.myEquippablesPanel.myConsumableSlot);
         this.myEquippablesPanel.myBadgeSlot0.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myEquippablesPanel.myBadgeSlot0);
         this.myEquippablesPanel.myBadgeSlot1.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myEquippablesPanel.myBadgeSlot1);
         this.myEquippablesPanel.myBadgeSlot2.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myEquippablesPanel.myBadgeSlot2);
         this.myEquippablesPanel.myConsumableSlot.registerUnfocusEvent(onLoadoutSlotUnfocused,this.myEquippablesPanel.myConsumableSlot);
         this.myEquippablesPanel.myBadgeSlot0.registerClearCallback(this.clearSlot);
         this.myEquippablesPanel.myBadgeSlot1.registerClearCallback(this.clearSlot);
         this.myEquippablesPanel.myBadgeSlot2.registerClearCallback(this.clearSlot);
         this.myEquippablesPanel.myConsumableSlot.registerClearCallback(this.clearSlot);
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myFilter.singleOptionMode = true;
         this.myFilter.addOnSubCategoryCheckedCallback(this.onSubCategoryclicked);
         this.mCurrentPanel = this.myEquippablesPanel;
      }
      
      override protected function enableData() : void
      {
         this.mCurrentPanel.showPanel();
         EventManager.getInstance().listen(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberChanged);
         var paraEvent:ParaEvent = new ParaEvent(Event.COMPLETE,DataManager.getInstance().getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ));
         this.onSelectedMemberChanged(paraEvent);
      }
      
      override protected function disableData() : void
      {
         this.mCurrentPanel.hidePanel();
         EventManager.getInstance().unlisten(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberChanged);
      }
      
      private function onSelectedMemberChanged(cEvt:ParaEvent) : void
      {
         var tab:Array = null;
         var currentMember:RoomMemberObj = cEvt.myPara;
         if(currentMember == null || currentMember.isMe)
         {
            this.myFilter.setData(MarketMenuData.INVENTORY_REQUISITIONS);
            this.myFilter.selectCategory(0);
         }
         else
         {
            this.myFilter.setData(MarketMenuData.INVENTORY_REQUISITIONS_OTHER);
            this.myFilter.selectCategory(0);
         }
         this.myEquippablesPanel.setData(currentMember);
      }
      
      private function onSubCategoryclicked() : void
      {
         var newPanel:LoadoutViewPanelBase = null;
         var category:FilterCategoryButton = this.myFilter.currentCategory;
         var states:Array = category.subcategoryStates;
         if(ScaleformUtil.isMe)
         {
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
         }
         else if(true == states[MarketMenuData.EQUIPPABLES_TAB])
         {
            this.myEquippablesPanel.changeGridToType(LoadoutViewRequisitionsPanelEquippables.SHOW_BADGES);
            newPanel = this.myEquippablesPanel;
         }
         else if(true == states[MarketMenuData.CONSUMABLES_TAB])
         {
            this.myEquippablesPanel.changeGridToType(LoadoutViewRequisitionsPanelEquippables.SHOW_ADVANCED_CONSUMABLES);
            newPanel = this.myEquippablesPanel;
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

