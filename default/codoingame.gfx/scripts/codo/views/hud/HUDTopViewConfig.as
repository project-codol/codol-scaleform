package codo.views.hud
{
   import codo.views.hud.HUDViewConfigs.HUDTopViewZHuntConfig;
   import codo.views.hud.HUDViewConfigs.HUDViewBaseConfig;
   
   public class HUDTopViewConfig implements IHUDViewConfig
   {
      
      private const mConfigs:Object = {
         "default":new HUDViewBaseConfig(),
         "zhunt":new HUDTopViewZHuntConfig()
      };
      
      public function HUDTopViewConfig()
      {
         super();
      }
      
      public function getModeViewData(mode:String) : Array
      {
         if(this.mConfigs.hasOwnProperty(mode))
         {
            return this.mConfigs[mode].getViewConfig();
         }
         return this.mConfigs["default"].getViewConfig();
      }
   }
}

