package codo.views.hud.td
{
   import codo.constants.GameInfo;
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   
   public class TDBaseInfo extends HUDComponent
   {
      
      public var myNightInfo:MovieClip;
      
      public var myDayInfo:MovieClip;
      
      public function TDBaseInfo()
      {
         super();
         this.myDayInfo.x = 9;
         this.myDayInfo.y = 332;
         this.myNightInfo.x = (GameInfo.stageSize.x - this.myNightInfo.width) * 0.5;
         this.myNightInfo.y = 56;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.TD_BASE_INFO;
      }
   }
}

