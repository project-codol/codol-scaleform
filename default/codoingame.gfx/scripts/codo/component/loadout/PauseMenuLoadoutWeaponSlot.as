package codo.component.loadout
{
   import codo.style.GlobalGuide;
   
   public class PauseMenuLoadoutWeaponSlot extends LoadoutWeaponSlot
   {
      
      private static const SLOT_WIDTH:Number = 38;
      
      private static const SLOT_HEIGHT:Number = 40;
      
      private static const NAME_WIDTH:Number = 142;
      
      public function PauseMenuLoadoutWeaponSlot()
      {
         super();
         myName.fontSize = GlobalGuide.FONT_SIZE_TINY;
         myCategory.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         myName.width = NAME_WIDTH;
         myCategory.width = NAME_WIDTH;
         myReticleSlot.width = SLOT_WIDTH;
         myReticleSlot.height = SLOT_HEIGHT;
         myCamoSlot.width = SLOT_WIDTH;
         myCamoSlot.height = SLOT_HEIGHT;
         myDecalSlot.width = SLOT_WIDTH;
         myDecalSlot.height = SLOT_HEIGHT;
      }
   }
}

