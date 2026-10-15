package codo.component.lobby
{
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutDisplay;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.objects.RoomMemberObj;
   import codo.objects.WeaponLoadoutObj;
   import flash.display.DisplayObject;
   
   public class NewLobbyLoadoutDisplay extends LoadoutDisplay
   {
      
      private var m_viewingLocalPlayerLoadout:Boolean = true;
      
      public function NewLobbyLoadoutDisplay()
      {
         super();
         mTickWidth = 4;
         mTickPadding = 3;
         myLoadoutMeter.x = 666;
         myContainer.width = 931;
         myContainer.height = 730;
      }
      
      public function get viewingLocalPlayerLoadout() : Boolean
      {
         return this.m_viewingLocalPlayerLoadout;
      }
      
      override public function enableData() : void
      {
         super.enableData();
         DataManager.getInstance().bind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember,null,true,true,false);
      }
      
      override public function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().unbind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember);
      }
      
      override protected function bindLoadoutData(cResult:Object) : void
      {
      }
      
      public function setLoadoutData(cResult:Object) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         var dataManager:DataManager = DataManager.getInstance();
         roomMemberObj = dataManager.getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ);
         if(roomMemberObj == null || roomMemberObj.isMe)
         {
            myOptions.visible = true;
            myLoadoutMeter.visible = true;
            this.m_viewingLocalPlayerLoadout = true;
            this.updateLoadout(new WeaponLoadoutObj(cResult.data));
         }
         else
         {
            myOptions.visible = false;
            myLoadoutMeter.visible = false;
            this.m_viewingLocalPlayerLoadout = false;
            this.updateLoadout(roomMemberObj.weaponloadObj);
         }
      }
      
      override public function updateLoadout(weaponLoadoutObj:WeaponLoadoutObj) : void
      {
         var loadoutButton:LoadoutButton = null;
         var child:DisplayObject = null;
         super.updateLoadout(weaponLoadoutObj);
         myPrimaryWeaponSlot.enabled = this.m_viewingLocalPlayerLoadout || myPrimaryWeaponSlot.getData().id != 0;
         mySecondaryWeaponSlot.enabled = this.m_viewingLocalPlayerLoadout || mySecondaryWeaponSlot.getData().id != 0;
         myPrimaryWeaponSlot.myCamoSlot.enabled = this.m_viewingLocalPlayerLoadout || myPrimaryWeaponSlot.myCamoSlot.getData().item_id != 0;
         myPrimaryWeaponSlot.myReticleSlot.enabled = this.m_viewingLocalPlayerLoadout || myPrimaryWeaponSlot.myReticleSlot.getData().item_id != 0;
         myPrimaryWeaponSlot.myDecalSlot.enabled = this.m_viewingLocalPlayerLoadout || myPrimaryWeaponSlot.myDecalSlot.getData().item_id != 0;
         mySecondaryWeaponSlot.myCamoSlot.enabled = this.m_viewingLocalPlayerLoadout || mySecondaryWeaponSlot.myCamoSlot.getData().item_id != 0;
         mySecondaryWeaponSlot.myReticleSlot.enabled = this.m_viewingLocalPlayerLoadout || mySecondaryWeaponSlot.myReticleSlot.getData().item_id != 0;
         mySecondaryWeaponSlot.myDecalSlot.enabled = this.m_viewingLocalPlayerLoadout || mySecondaryWeaponSlot.myDecalSlot.getData().item_id != 0;
         for(var i:uint = 0; i < this.numChildren; i++)
         {
            child = this.getChildAt(i);
            if(child is LoadoutButton)
            {
               loadoutButton = child as LoadoutButton;
               loadoutButton.enabled = this.m_viewingLocalPlayerLoadout || loadoutButton.getData().item_id != 0;
            }
         }
         myContainer.width = 931;
         myContainer.height = 730;
      }
      
      private function bind_onSetCurrentlySelectedTeamMember(cRes:Object) : void
      {
         var selectedTeamMemberID:String = cRes.data;
         var dataManager:DataManager = DataManager.getInstance();
         if(dataManager == null)
         {
            return;
         }
         var roomMemberObj:RoomMemberObj = dataManager.getDP(DataID.ROOM_MEMBER_OBJ_BY_ID,[selectedTeamMemberID]);
         if(roomMemberObj == null)
         {
            return;
         }
         if(roomMemberObj.isMe)
         {
            this.m_viewingLocalPlayerLoadout = true;
            myOptions.visible = true;
            myLoadoutMeter.visible = true;
         }
         else
         {
            this.m_viewingLocalPlayerLoadout = false;
            myOptions.visible = false;
            myLoadoutMeter.visible = false;
         }
         this.updateLoadout(roomMemberObj.weaponloadObj);
      }
   }
}

