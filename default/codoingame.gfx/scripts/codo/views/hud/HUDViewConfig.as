package codo.views.hud
{
   import codo.views.hud.HUDViewConfigs.HUDViewBaseConfig;
   import codo.views.hud.HUDViewConfigs.HUDViewNftblConfig;
   import codo.views.hud.HUDViewConfigs.HUDViewRobberyConfig;
   import codo.views.hud.HUDViewConfigs.HUDViewTDConfig;
   import codo.views.hud.HUDViewConfigs.HUDViewVipConfig;
   import codo.views.hud.HUDViewConfigs.HUDViewZHuntConfig;
   
   public class HUDViewConfig implements IHUDViewConfig
   {
      
      private const mConfigs:Object = {
         "default":new HUDViewBaseConfig(),
         "zhunt":new HUDViewZHuntConfig(),
         "nftbl":new HUDViewNftblConfig(),
         "vip":new HUDViewVipConfig(),
         "robbery":new HUDViewRobberyConfig(),
         "td":new HUDViewTDConfig()
      };
      
      public function HUDViewConfig()
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

