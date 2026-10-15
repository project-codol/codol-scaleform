package codo.views.supplyDrop_parts
{
   import codo.utils.ScaleformUtil;
   
   public class BaseSupplyDropRewardPanelDecorator
   {
      
      protected var mPanel:SupplyDropRewardItemPanel;
      
      public function BaseSupplyDropRewardPanelDecorator(panel:SupplyDropRewardItemPanel)
      {
         super();
         this.mPanel = panel;
      }
      
      public function decorate() : void
      {
      }
      
      final protected function get isDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
   }
}

