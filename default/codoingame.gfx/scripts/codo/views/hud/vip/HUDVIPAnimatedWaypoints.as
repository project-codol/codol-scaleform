package codo.views.hud.vip
{
   import codo.constants.HUDComponentTypes;
   import codo.hud.vip.evactionWaypoint;
   import codo.views.hud.shared.HUDAnimatedWayPoints;
   
   public class HUDVIPAnimatedWaypoints extends HUDAnimatedWayPoints
   {
      
      public const VIP_EVACTION_WAYPOINT:int = 0;
      
      public function HUDVIPAnimatedWaypoints()
      {
         super();
         addWaypointClass(this.VIP_EVACTION_WAYPOINT,evactionWaypoint);
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.VIP_ANIMATED_WAYPOINTS;
      }
   }
}

