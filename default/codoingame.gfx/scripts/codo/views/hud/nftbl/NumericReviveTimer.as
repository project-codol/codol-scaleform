package codo.views.hud.nftbl
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class NumericReviveTimer extends HUDComponent
   {
      
      public function NumericReviveTimer()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.NUMERIC_REVIVE_TIMER;
      }
   }
}

