package codo.views.hud.dotmenuWrapper
{
   import codo.constants.GameInfo;
   import codo.views.hud.HUDComponent;
   
   public class HUDDotMenuComponent extends HUDComponent
   {
      
      public function HUDDotMenuComponent()
      {
         super();
      }
      
      override public function set x(value:Number) : void
      {
         super.x = (value - GameInfo.stagePosition.x) / GameInfo.stageSize.x * 640;
      }
      
      override public function set y(value:Number) : void
      {
         super.y = (value - GameInfo.stagePosition.y) / GameInfo.stageSize.y * 480;
      }
   }
}

