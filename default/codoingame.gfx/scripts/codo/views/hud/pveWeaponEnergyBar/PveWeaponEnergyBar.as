package codo.views.hud.pveWeaponEnergyBar
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class PveWeaponEnergyBar extends HUDComponent
   {
      
      public function PveWeaponEnergyBar()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.PVE_WEAPON_ENERGY_BAR;
      }
   }
}

