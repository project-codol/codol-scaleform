package codo.views.hud.td
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.weaponBar.WeaponBar;
   
   public class TDWeaponBar extends WeaponBar
   {
      
      public function TDWeaponBar()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_WEAPONBAR;
      }
   }
}

