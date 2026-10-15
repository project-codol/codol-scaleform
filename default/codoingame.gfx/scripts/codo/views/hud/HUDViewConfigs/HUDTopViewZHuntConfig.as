package codo.views.hud.HUDViewConfigs
{
   import codo.hud.hudTopPopupMessage;
   
   public class HUDTopViewZHuntConfig extends HUDViewBaseConfig
   {
      
      public function HUDTopViewZHuntConfig()
      {
         super();
      }
      
      override protected function buildConfigArray() : void
      {
         super.buildConfigArray();
         addComponent({"cls":hudTopPopupMessage});
      }
   }
}

