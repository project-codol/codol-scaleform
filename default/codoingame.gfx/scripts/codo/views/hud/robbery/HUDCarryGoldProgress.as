package codo.views.hud.robbery
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class HUDCarryGoldProgress extends HUDComponent
   {
      
      public function HUDCarryGoldProgress()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.ROBBERY_CARRY_GOLD_PROGRESS;
      }
   }
}

