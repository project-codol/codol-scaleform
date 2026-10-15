package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.DataID;
   import codo.utils.ScaleformUtil;
   
   public class LanguageBarController extends BaseController
   {
      
      public function LanguageBarController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.IS_IME_ENABLED,this.isIMEEnabled);
      }
      
      public function isIMEEnabled() : Boolean
      {
         return ScaleformUtil.isScaleform ? this.getDvarBool("ui_scaleform_ime") : true;
      }
   }
}

