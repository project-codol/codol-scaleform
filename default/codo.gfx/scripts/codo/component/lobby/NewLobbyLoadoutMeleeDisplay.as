package codo.component.lobby
{
   import codo.component.loadout.LoadoutMeleeDisplay;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.objects.RoomMemberObj;
   import codo.objects.WeaponLoadoutObj;
   
   public class NewLobbyLoadoutMeleeDisplay extends LoadoutMeleeDisplay
   {
      
      private var m_viewingLocalPlayerLoadout:Boolean = false;
      
      public function NewLobbyLoadoutMeleeDisplay()
      {
         super();
         myContainer.width = 460;
         myContainer.height = 730;
      }
      
      public function setLoadoutData(cResult:Object) : void
      {
         var dataManager:DataManager = DataManager.getInstance();
         var roomMemberObj:RoomMemberObj = dataManager.getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ);
         if(roomMemberObj == null || roomMemberObj.isMe)
         {
            this.m_viewingLocalPlayerLoadout = true;
            this.updateLoadout(new WeaponLoadoutObj(cResult.data));
         }
         else
         {
            this.m_viewingLocalPlayerLoadout = false;
            this.updateLoadout(roomMemberObj.weaponloadObj);
         }
      }
      
      override public function updateLoadout(weaponLoadoutObj:WeaponLoadoutObj) : void
      {
         super.updateLoadout(weaponLoadoutObj);
         myPrimaryWeaponSlot.enabled = this.m_viewingLocalPlayerLoadout || myPrimaryWeaponSlot.getData().id != 0;
         mySecondaryWeaponSlot.enabled = this.m_viewingLocalPlayerLoadout || mySecondaryWeaponSlot.getData().id != 0;
         myPrimaryWeaponSlot.myCamoSlot.visible = false;
         myPrimaryWeaponSlot.myReticleSlot.visible = false;
         myPrimaryWeaponSlot.myDecalSlot.visible = false;
         mySecondaryWeaponSlot.myCamoSlot.visible = false;
         mySecondaryWeaponSlot.myReticleSlot.visible = false;
         mySecondaryWeaponSlot.myDecalSlot.visible = false;
         myContainer.width = 460;
         myContainer.height = 730;
      }
   }
}

