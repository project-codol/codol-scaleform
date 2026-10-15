package codo.views.hud.td
{
   import codo.constants.GameInfo;
   import codo.constants.HUDComponentTypes;
   import codo.hud.td.turretWaypoint;
   import codo.hud.td.turretWaypoint.offscreenArrow;
   import codo.views.hud.shared.HUDAnimatedWayPoints;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class HUDTDTurretWaypoints extends HUDAnimatedWayPoints
   {
      
      private const MAP_X:Number = 8;
      
      private const MAP_Y:Number = 12;
      
      private const MAP_WIDTH:Number = 234;
      
      private const MAP_HEIGHT:Number = 255;
      
      private const CENTER_MAP_MARGIN:Number = 4;
      
      private var mPopupConfig:Dictionary;
      
      private var myMask:MovieClip;
      
      public function HUDTDTurretWaypoints()
      {
         super();
         this.mPopupConfig = new Dictionary();
         addWaypointClass(0,turretWaypoint);
         addArrowClass(0,offscreenArrow);
         this.myMask = new MovieClip();
         addChild(this.myMask);
         mask = this.myMask;
         this.fillMask(false);
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_TURRET_WAYPOINTS;
      }
      
      public function initPopupTypeConfig(configs:Array) : void
      {
         var type:int = 0;
         for(var i:int = 0; i < configs.length; i++)
         {
            type = int(configs[i].type);
            this.mPopupConfig[type] = configs[i];
         }
      }
      
      public function doMoneyPopup(index:int, type:int, amount:int) : void
      {
         var waypoint:TurretWaypoint = findWaypointByID(0,index) as TurretWaypoint;
         if(waypoint != null)
         {
            waypoint.doMoneyPopup(amount,this.mPopupConfig[type]);
         }
      }
      
      public function fillMask(isCenterMapOn:Boolean) : void
      {
         var centerMapSize:Number = NaN;
         var centerMapX:Number = NaN;
         var miniMapWidth:Number = NaN;
         this.myMask.graphics.clear();
         this.myMask.graphics.beginFill(16777215,1);
         this.myMask.graphics.drawRect(0,0,GameInfo.stageSize.x,GameInfo.stageSize.y);
         if(!isCenterMapOn)
         {
            this.myMask.graphics.drawRect(this.MAP_X,this.MAP_Y,this.MAP_WIDTH,this.MAP_HEIGHT);
         }
         else
         {
            centerMapSize = GameInfo.stageSize.y - this.CENTER_MAP_MARGIN * 2;
            centerMapX = (GameInfo.stageSize.x - centerMapSize) * 0.5;
            this.myMask.graphics.drawRect(centerMapX,this.CENTER_MAP_MARGIN,centerMapSize,centerMapSize);
            miniMapWidth = this.MAP_WIDTH;
            if(this.MAP_X + miniMapWidth > centerMapX)
            {
               miniMapWidth = centerMapX - this.MAP_X;
            }
            this.myMask.graphics.drawRect(this.MAP_X,this.MAP_Y,miniMapWidth,this.MAP_HEIGHT);
         }
         this.myMask.graphics.endFill();
      }
   }
}

