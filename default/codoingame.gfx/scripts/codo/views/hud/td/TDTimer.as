package codo.views.hud.td
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class TDTimer extends HUDComponent
   {
      
      public function TDTimer()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_TIMER;
      }
   }
}

