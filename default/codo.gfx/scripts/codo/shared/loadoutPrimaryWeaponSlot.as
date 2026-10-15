package codo.shared
{
   import codo.component.loadout.LoadoutWeaponSlot;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4613")]
   public dynamic class loadoutPrimaryWeaponSlot extends LoadoutWeaponSlot
   {
      
      public function loadoutPrimaryWeaponSlot()
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

