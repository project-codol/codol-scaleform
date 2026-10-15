package
{
   import codo.component.loadout.LoadoutWeaponSlot;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4424")]
   public dynamic class lobbyLoadoutPrimaryWeaponSlot extends LoadoutWeaponSlot
   {
      
      public function lobbyLoadoutPrimaryWeaponSlot()
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

