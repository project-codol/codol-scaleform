package codo.views.hud.HUDViewConfigs
{
   import codo.constants.GameInfo;
   import codo.hud.robbery.hudCarriedGoldBar;
   import codo.hud.robbery.hudObtainGoldHint;
   import codo.hud.shared.numericReviveTimer;
   import flash.geom.Point;
   
   public class HUDViewRobberyConfig extends HUDViewBaseConfig
   {
      
      public function HUDViewRobberyConfig()
      {
         super();
      }
      
      override protected function buildConfigArray() : void
      {
         super.buildConfigArray();
         addComponent({
            "cls":numericReviveTimer,
            "anchor":GameInfo.BOTTOM_CENTER,
            "offset":new Point(-172.5,-340),
            "width":345,
            "height":88
         });
         addComponent({
            "cls":hudObtainGoldHint,
            "anchor":GameInfo.TOP_CENTER,
            "offset":new Point(0,80)
         });
         addComponent({
            "cls":hudCarriedGoldBar,
            "anchor":GameInfo.BOTTOM_CENTER,
            "offset":new Point(-244,-48)
         });
      }
   }
}

