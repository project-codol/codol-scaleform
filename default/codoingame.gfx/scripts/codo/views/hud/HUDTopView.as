package codo.views.hud
{
   import codo.event.ParaEvent;
   
   public class HUDTopView extends HUDBaseView
   {
      
      private var mViewConfig:HUDTopViewConfig;
      
      public function HUDTopView()
      {
         super();
         this.mViewConfig = new HUDTopViewConfig();
      }
      
      override protected function get viewConfig() : IHUDViewConfig
      {
         return this.mViewConfig;
      }
      
      override protected function onBlurAllUI(cEvt:ParaEvent) : void
      {
      }
   }
}

