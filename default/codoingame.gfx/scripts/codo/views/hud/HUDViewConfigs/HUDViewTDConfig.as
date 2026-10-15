package codo.views.hud.HUDViewConfigs
{
   import codo.constants.GameInfo;
   import codo.hud.td.hudTDTurretWaypoints;
   import codo.hud.td.hudTdBaseInfo;
   import codo.hud.td.hudTdGainLootHint;
   import codo.hud.td.hudTdKeyHint;
   import codo.hud.td.hudTdNightComingHint;
   import codo.hud.td.playerInfoBar;
   import codo.hud.td.rankPanel;
   import codo.hud.td.timer;
   import codo.hud.td.weaponBar;
   import codo.views.hud.dotmenuWrapper.GameMessageWindow;
   import flash.geom.Point;
   
   public class HUDViewTDConfig extends HUDViewBaseConfig
   {
      
      public function HUDViewTDConfig()
      {
         super();
      }
      
      override protected function buildConfigArray() : void
      {
         super.buildConfigArray();
         addComponent({
            "cls":hudTDTurretWaypoints,
            "anchor":GameInfo.TOP_LEFT
         });
         addComponent({
            "cls":GameMessageWindow,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(X_MARGIN,424)
         });
         addComponent({
            "cls":weaponBar,
            "anchor":GameInfo.BOTTOM_RIGHT,
            "offset":new Point(0,-22)
         });
         addComponent({
            "cls":playerInfoBar,
            "anchor":GameInfo.BOTTOM_LEFT,
            "offset":new Point(0,-22)
         });
         addComponent({
            "cls":rankPanel,
            "anchor":GameInfo.TOP_RIGHT,
            "offset":new Point(0,20)
         });
         addComponent({
            "cls":hudTdGainLootHint,
            "anchor":GameInfo.CENTER,
            "offset":new Point(16,64)
         });
         addComponent({
            "cls":timer,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(9,270),
            "width":232,
            "height":56
         });
         addComponent({
            "cls":hudTdKeyHint,
            "anchor":GameInfo.TOP_LEFT
         });
         addComponent({
            "cls":hudTdBaseInfo,
            "anchor":GameInfo.TOP_LEFT
         });
         addComponent({
            "cls":hudTdNightComingHint,
            "anchor":GameInfo.TOP_CENTER,
            "offset":new Point(0,140)
         });
      }
   }
}

