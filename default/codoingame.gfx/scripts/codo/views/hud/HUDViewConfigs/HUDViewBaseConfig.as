package codo.views.hud.HUDViewConfigs
{
   public class HUDViewBaseConfig
   {
      
      protected static const X_MARGIN:int = 10;
      
      protected static const Y_MARGIN:int = 35;
      
      protected static var mConfigurableProperties:Array = ["cls","anchor","width","height","zoom","rotateX","rotateY","rotateZ","offset"];
      
      protected var mConfig:Array;
      
      public function HUDViewBaseConfig()
      {
         super();
         this.mConfig = new Array();
         this.buildConfigArray();
      }
      
      public static function IsConfigurableProperty(name:String) : Boolean
      {
         return mConfigurableProperties.indexOf(name) >= 0;
      }
      
      protected function buildConfigArray() : void
      {
      }
      
      protected function addComponent(component:Object) : void
      {
         this.mConfig.push(component);
      }
      
      public function getViewConfig() : Array
      {
         return this.mConfig;
      }
   }
}

