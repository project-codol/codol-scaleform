package components.fsgmatchresult_part
{
   import codo.base.BaseSubElement;
   import codo.utils.ScaleformUtil;
   
   public class FsgMatchResultPopupPanelBase extends BaseSubElement
   {
      
      public function FsgMatchResultPopupPanelBase()
      {
         super();
         visible = false;
      }
      
      public function setData(data:*) : void
      {
      }
      
      public function canAdvance() : Boolean
      {
         return true;
      }
      
      protected function get inDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
   }
}

