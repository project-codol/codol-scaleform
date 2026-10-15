package codo.views.hud
{
   public class HUDView extends HUDBaseView
   {
      
      private var mViewConfig:HUDViewConfig;
      
      public function HUDView()
      {
         super();
         this.mViewConfig = new HUDViewConfig();
      }
      
      override protected function get viewConfig() : IHUDViewConfig
      {
         return this.mViewConfig;
      }
   }
}

