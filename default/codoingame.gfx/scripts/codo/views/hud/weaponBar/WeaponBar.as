package codo.views.hud.weaponBar
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class WeaponBar extends HUDComponent
   {
      
      public function WeaponBar()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.WEAPON_BAR;
      }
   }
}

