package codo.shared
{
   import codo.component.loadout.PauseMenuLoadoutWeaponSlot;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol129")]
   public dynamic class pauseMenuLoadoutPrimaryWeaponSlot extends PauseMenuLoadoutWeaponSlot
   {
      
      public function pauseMenuLoadoutPrimaryWeaponSlot()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

