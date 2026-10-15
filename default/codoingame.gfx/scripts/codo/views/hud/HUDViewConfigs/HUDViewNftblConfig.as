package codo.views.hud.HUDViewConfigs
{
   import codo.constants.GameInfo;
   import codo.hud.nftbl.ballMatchPlayerInfoBar;
   import codo.hud.nftbl.ballMatchScoreBar;
   import codo.hud.shared.numericReviveTimer;
   import codo.hud.shared.speakerContainer;
   import flash.geom.Point;
   
   public class HUDViewNftblConfig extends HUDViewBaseConfig
   {
      
      public function HUDViewNftblConfig()
      {
         super();
      }
      
      override protected function buildConfigArray() : void
      {
         super.buildConfigArray();
         addComponent({
            "cls":ballMatchScoreBar,
            "anchor":GameInfo.TOP_CENTER,
            "offset":new Point(-178.5,0),
            "width":347,
            "height":71.7
         });
         addComponent({
            "cls":ballMatchPlayerInfoBar,
            "anchor":GameInfo.BOTTOM_LEFT,
            "offset":new Point(0,-150),
            "width":265.3,
            "height":119.1
         });
         addComponent({
            "cls":speakerContainer,
            "anchor":GameInfo.TOP_LEFT,
            "offset":new Point(20,300),
            "zoom":0.8
         });
         addComponent({
            "cls":numericReviveTimer,
            "anchor":GameInfo.BOTTOM_CENTER,
            "offset":new Point(-172.5,-340),
            "width":345,
            "height":88
         });
      }
   }
}

