package codo.views.hud.HUDViewConfigs
{
   import codo.constants.GameInfo;
   import codo.hud.hudTopPopupMessage;
   import codo.hud.shared.hudTeamPlayerCounter;
   import codo.hud.vip.animatedWaypoints;
   import codo.hud.vip.hudEvactionHint;
   import flash.geom.Point;
   
   public class HUDViewVipConfig extends HUDViewBaseConfig
   {
      
      public function HUDViewVipConfig()
      {
         super();
      }
      
      override protected function buildConfigArray() : void
      {
         super.buildConfigArray();
         addComponent({
            "cls":animatedWaypoints,
            "anchor":GameInfo.TOP_LEFT,
            "width":100,
            "height":100
         });
         addComponent({"cls":hudTopPopupMessage});
         addComponent({
            "cls":hudEvactionHint,
            "anchor":GameInfo.CENTER,
            "offset":new Point(0,-150)
         });
         addComponent({
            "cls":hudTeamPlayerCounter,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(12,274)
         });
      }
   }
}

