package codo.component.lobby
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TabNavigation;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutPanel;
   import codo.component.loadout.LoadoutWeaponSlot;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.objects.RoomMemberObj;
   
   public class NewLobbyLoadoutPanel extends LoadoutPanel
   {
      
      private static const CUSTOM_BACKGROUND_WIDTH:Number = 957;
      
      public var myLoadoutTabs:TabNavigation;
      
      private var mItemSelectedCallback:Function;
      
      public function NewLobbyLoadoutPanel()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         myLoadout.registerFocusEvent(onLoadoutSlotFocused);
         myLoadout.registerUnfocusEvent(onLoadoutSlotUnfocused);
         myLoadout.myContainer.width = CUSTOM_BACKGROUND_WIDTH;
         myLoadoutMelee.registerFocusEvent(onLoadoutSlotFocused);
         myLoadoutMelee.registerUnfocusEvent(onLoadoutSlotUnfocused);
      }
      
      override protected function editSlotAction(categories:Array, item:ProductObj = null, slot:String = "", isPrimary:Boolean = true) : void
      {
         this.mItemSelectedCallback({
            "categories":categories,
            "isPrimary":isPrimary
         });
      }
      
      private function inspectSlot(itemID:int) : void
      {
         var item:ProductObj = CFunctionCommonContainer.GetItemInfo(itemID);
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_SHOW_DETAILS,{"itemData":item});
      }
      
      public function registerItemSelectedCallback(f:Function) : void
      {
         this.mItemSelectedCallback = f;
      }
      
      private function reregisterClearEvents() : void
      {
         myLoadout.myPrimaryWeaponSlot.clearItemCallback = onPrimaryWeaponSlotCleared;
         myLoadout.myPrimaryWeaponSlot.myReticleSlot.registerClearCallback(onPrimaryLoadoutButtonCleared);
         myLoadout.myPrimaryWeaponSlot.myCamoSlot.registerClearCallback(onPrimaryLoadoutButtonCleared);
         myLoadout.myPrimaryWeaponSlot.myDecalSlot.registerClearCallback(onPrimaryLoadoutButtonCleared);
         myLoadout.mySecondaryWeaponSlot.clearItemCallback = onSecondaryWeaponSlotCleared;
         myLoadout.mySecondaryWeaponSlot.myReticleSlot.registerClearCallback(onSecondaryLoadoutButtonCleared);
         myLoadout.mySecondaryWeaponSlot.myCamoSlot.registerClearCallback(onSecondaryLoadoutButtonCleared);
         myLoadout.mySecondaryWeaponSlot.myDecalSlot.registerClearCallback(onSecondaryLoadoutButtonCleared);
         myLoadout.myPrimaryAttachment0.registerClearCallback(onPrimaryLoadoutButtonCleared);
         myLoadout.myPrimaryAttachment1.registerClearCallback(onPrimaryLoadoutButtonCleared);
         myLoadout.myPrimaryAttachment2.registerClearCallback(onPrimaryLoadoutButtonCleared);
         myLoadout.mySecondaryAttachment0.registerClearCallback(onSecondaryLoadoutButtonCleared);
         myLoadout.mySecondaryAttachment1.registerClearCallback(onSecondaryLoadoutButtonCleared);
         myLoadout.registerPerkClears(onPerkCleared);
         myLoadout.myLethal0.registerClearCallback(onLethalCleared);
         myLoadout.myLethal1.registerClearCallback(onLethalCleared);
         myLoadout.myTactical0.registerClearCallback(onTacticalCleared);
         myLoadout.myTactical1.registerClearCallback(onTacticalCleared);
         myLoadout.myWildCard0.registerClearCallback(onWildcardCleared);
         myLoadout.myWildCard1.registerClearCallback(onWildcardCleared);
         myLoadout.myWildCard2.registerClearCallback(onWildcardCleared);
         myLoadoutMelee.myPrimaryWeaponSlot.clearItemCallback = onPrimaryMeleeWeaponSlotCleared;
         myLoadoutMelee.mySecondaryWeaponSlot.clearItemCallback = onSecondaryMeleeWeaponSlotCleared;
      }
      
      private function unregisterClearEvents() : void
      {
         myLoadout.myPrimaryWeaponSlot.clearItemCallback = null;
         myLoadout.myPrimaryWeaponSlot.myReticleSlot.unregisterClearCallback();
         myLoadout.myPrimaryWeaponSlot.myCamoSlot.unregisterClearCallback();
         myLoadout.myPrimaryWeaponSlot.myDecalSlot.unregisterClearCallback();
         myLoadout.mySecondaryWeaponSlot.clearItemCallback = null;
         myLoadout.mySecondaryWeaponSlot.myReticleSlot.unregisterClearCallback();
         myLoadout.mySecondaryWeaponSlot.myCamoSlot.unregisterClearCallback();
         myLoadout.mySecondaryWeaponSlot.myDecalSlot.unregisterClearCallback();
         myLoadout.myPrimaryAttachment0.unregisterClearCallback();
         myLoadout.myPrimaryAttachment1.unregisterClearCallback();
         myLoadout.myPrimaryAttachment2.unregisterClearCallback();
         myLoadout.mySecondaryAttachment0.unregisterClearCallback();
         myLoadout.mySecondaryAttachment1.unregisterClearCallback();
         myLoadout.myPerk0Slot0.unregisterClearCallback();
         myLoadout.myPerk1Slot0.unregisterClearCallback();
         myLoadout.myPerk2Slot0.unregisterClearCallback();
         myLoadout.myPerk0Slot1.unregisterClearCallback();
         myLoadout.myPerk1Slot1.unregisterClearCallback();
         myLoadout.myPerk2Slot1.unregisterClearCallback();
         myLoadout.myLethal0.unregisterClearCallback();
         myLoadout.myLethal1.unregisterClearCallback();
         myLoadout.myTactical0.unregisterClearCallback();
         myLoadout.myTactical1.unregisterClearCallback();
         myLoadout.myWildCard0.unregisterClearCallback();
         myLoadout.myWildCard1.unregisterClearCallback();
         myLoadout.myWildCard2.unregisterClearCallback();
         myLoadoutMelee.myPrimaryWeaponSlot.clearItemCallback = null;
         myLoadoutMelee.mySecondaryWeaponSlot.clearItemCallback = null;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         myLoadout.enableData();
         DataManager.getInstance().bind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember,null,true,true,false);
         DataManager.getInstance().bind(DataID.WEAPONLOADOUT_SLOTSDATA,this.bind_onSetWeaponLoadoutSlotsData,null,true,true,false);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         myLoadout.disableData();
         DataManager.getInstance().unbind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember);
         DataManager.getInstance().unbind(DataID.WEAPONLOADOUT_SLOTSDATA,this.bind_onSetWeaponLoadoutSlotsData);
      }
      
      private function bind_onSetCurrentlySelectedTeamMember(cResult:Object) : void
      {
         var selectedTeamMemberID:String = cResult.data;
         var dataManager:DataManager = DataManager.getInstance();
         var roomMemberObj:RoomMemberObj = dataManager.getDP(DataID.ROOM_MEMBER_OBJ_BY_ID,[selectedTeamMemberID]);
         if(roomMemberObj == null || roomMemberObj.isMe)
         {
            this.reregisterClearEvents();
         }
         else
         {
            this.unregisterClearEvents();
         }
      }
      
      protected function bind_onSetWeaponLoadoutSlotsData(cResult:Object) : void
      {
         var loadoutIdx:int = 0;
         var dataManager:DataManager = DataManager.getInstance();
         var roomMemberObj:RoomMemberObj = dataManager.getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ);
         if(roomMemberObj == null || roomMemberObj.isMe)
         {
            this.reregisterClearEvents();
         }
         else
         {
            this.unregisterClearEvents();
         }
         var newLobbyLoadout:NewLobbyLoadoutDisplay = myLoadout as NewLobbyLoadoutDisplay;
         if(Boolean(newLobbyLoadout))
         {
            newLobbyLoadout.setLoadoutData(cResult);
         }
         var newLoobyLoadoutMelee:NewLobbyLoadoutMeleeDisplay = myLoadoutMelee as NewLobbyLoadoutMeleeDisplay;
         if(Boolean(newLoobyLoadoutMelee))
         {
            newLoobyLoadoutMelee.setLoadoutData(cResult);
         }
         if(Boolean(this.myLoadoutTabs.getTabsData()) && (roomMemberObj == null || roomMemberObj.isMe))
         {
            loadoutIdx = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
            if(this.myLoadoutTabs.currentTabId != loadoutIdx)
            {
               this.myLoadoutTabs.SetSelectedIndexById(loadoutIdx);
            }
         }
      }
      
      override protected function onPrimaryWeaponClicked(slot:LoadoutWeaponSlot) : void
      {
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onPrimaryWeaponClicked(slot);
         }
         else
         {
            this.inspectSlot(slot.getData().id);
         }
      }
      
      override protected function onSecondaryWeaponClicked(slot:LoadoutWeaponSlot) : void
      {
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onSecondaryWeaponClicked(slot);
         }
         else
         {
            this.inspectSlot(slot.getData().id);
         }
      }
      
      override protected function onEditPrimaryReticleClicked() : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onEditPrimaryReticleClicked();
         }
         else
         {
            slot = myLoadout.myPrimaryWeaponSlot.myReticleSlot;
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onEditPrimaryCamoClicked() : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onEditPrimaryCamoClicked();
         }
         else
         {
            slot = myLoadout.myPrimaryWeaponSlot.myCamoSlot;
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onEditPrimaryDecalClicked() : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onEditPrimaryDecalClicked();
         }
         else
         {
            slot = myLoadout.myPrimaryWeaponSlot.myDecalSlot;
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onEditSecondaryReticleClicked() : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onEditSecondaryReticleClicked();
         }
         else
         {
            slot = myLoadout.mySecondaryWeaponSlot.myReticleSlot;
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onEditSecondaryCamoClicked() : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onEditSecondaryCamoClicked();
         }
         else
         {
            slot = myLoadout.mySecondaryWeaponSlot.myCamoSlot;
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onEditSecondaryDecalClicked() : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onEditSecondaryDecalClicked();
         }
         else
         {
            slot = myLoadout.mySecondaryWeaponSlot.myDecalSlot;
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onPrimaryAttachmentClicked(id:int) : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onPrimaryAttachmentClicked(id);
         }
         else
         {
            slot = myLoadout["myPrimaryAttachment" + id];
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onSecondaryAttachmentClicked(id:int) : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onSecondaryAttachmentClicked(id);
         }
         else
         {
            slot = myLoadout["mySecondaryAttachment" + id];
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onPerkClicked(data:Object) : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onPerkClicked(data);
         }
         else
         {
            slot = myLoadout["myPerk" + data.perk + "Slot" + data.slot];
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onLethalClicked(id:int) : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onLethalClicked(id);
         }
         else
         {
            slot = myLoadout["myLethal" + id];
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onTacticalClicked(id:int) : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onTacticalClicked(id);
         }
         else
         {
            slot = myLoadout["myTactical" + id];
            this.inspectSlot(slot.getData().item_id);
         }
      }
      
      override protected function onWildCardClicked(id:int) : void
      {
         var slot:LoadoutButton = null;
         if((myLoadout as NewLobbyLoadoutDisplay).viewingLocalPlayerLoadout)
         {
            super.onWildCardClicked(id);
         }
         else
         {
            slot = myLoadout["myWildCard" + id];
            this.inspectSlot(slot.getData().item_id);
         }
      }
   }
}

