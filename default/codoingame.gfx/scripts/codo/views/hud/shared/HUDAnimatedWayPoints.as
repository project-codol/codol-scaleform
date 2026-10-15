package codo.views.hud.shared
{
   import codo.constants.GameInfo;
   import codo.views.hud.HUDComponent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class HUDAnimatedWayPoints extends HUDComponent
   {
      
      protected var mWaypoints:Array;
      
      protected var mWaypointClasses:Dictionary;
      
      protected var mArrowClasses:Dictionary;
      
      public function HUDAnimatedWayPoints()
      {
         super();
         this.mWaypoints = new Array();
         this.mWaypointClasses = new Dictionary();
         this.mArrowClasses = new Dictionary();
      }
      
      public function set waypointData(waypointsData:Array) : void
      {
         var wp:AnimatedWaypointBase = null;
         var stageSize:Point = null;
         var data:Object = null;
         var waypoint:AnimatedWaypointBase = null;
         for each(wp in this.mWaypoints)
         {
            if(wp.visible)
            {
               wp.visible = false;
               if(wp.myArrow != null)
               {
                  wp.myArrow.visible = false;
               }
               removeChild(wp);
            }
         }
         waypointsData.sort(this.sortByDistance);
         stageSize = GameInfo.stageSize;
         for each(data in waypointsData)
         {
            waypoint = this.getOrCreateWaypoint(data);
            addChildAt(waypoint,0);
            if(waypoint.myArrow != null)
            {
               waypoint.myArrow.visible = true;
               if(waypoint.myArrow.parent == this)
               {
                  waypoint.myArrow.x = data.drawInfo.clampedX * stageSize.x;
                  waypoint.myArrow.y = data.drawInfo.clampedY * stageSize.y;
               }
            }
            waypoint.visible = true;
            waypoint.x = data.drawInfo.x * stageSize.x;
            waypoint.y = data.drawInfo.y * stageSize.y;
            waypoint.setupAlpha(data.drawInfo.alpha);
            waypoint.setupScale(data.drawInfo.w * stageSize.x,data.drawInfo.h * stageSize.y);
            waypoint.setupArrow(data.drawInfo.arrowAlpha,data.drawInfo.arrowAngle);
            waypoint.setData(data);
         }
      }
      
      private function getOrCreateWaypoint(data:Object) : AnimatedWaypointBase
      {
         var waypoint:AnimatedWaypointBase = null;
         waypoint = this.findWaypointByID(data.type,data.id);
         if(waypoint != null)
         {
            return waypoint;
         }
         var cls:Class = this.mWaypointClasses[data.type] as Class;
         waypoint = new cls();
         waypoint.type = data.type;
         waypoint.id = data.id;
         waypoint.visible = false;
         this.mWaypoints.push(waypoint);
         var arrowCls:Class = this.mArrowClasses[data.type] as Class;
         if(arrowCls != null)
         {
            waypoint.myArrow = new arrowCls();
            addChild(waypoint.myArrow);
         }
         return waypoint;
      }
      
      private function sortByDistance(data0:Object, data1:Object) : Number
      {
         return data0.drawInfo.worldDistance > data1.drawInfo.worldDistance ? 1 : -1;
      }
      
      public function addWaypointClass(id:int, cls:Class) : void
      {
         this.mWaypointClasses[id] = cls;
      }
      
      public function addArrowClass(id:int, cls:Class) : void
      {
         this.mArrowClasses[id] = cls;
      }
      
      public function findWaypointByID(type:int, id:int) : AnimatedWaypointBase
      {
         var wp:AnimatedWaypointBase = null;
         for each(wp in this.mWaypoints)
         {
            if(wp.type == type && wp.id == id)
            {
               return wp;
            }
         }
         return null;
      }
   }
}

