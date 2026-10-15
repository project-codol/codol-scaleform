package codo.views.hud.shared
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class HUDTeamPlayerCounter extends HUDComponent
   {
      
      public function HUDTeamPlayerCounter()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TEAM_PLAYER_COUNTER;
      }
   }
}

