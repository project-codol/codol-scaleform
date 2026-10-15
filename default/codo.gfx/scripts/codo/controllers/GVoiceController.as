package codo.controllers
{
   import codo.constants.CodoPageViewDB;
   import codo.event.ParaEvent;
   
   public class GVoiceController extends GVoiceBaseController
   {
      
      public function GVoiceController()
      {
         super();
      }
      
      override protected function onToggleVoiceSettings(cEvt:ParaEvent) : void
      {
         if(Boolean(CodoPageViewDB.PAGE_GVOICE_SETTINGS.owner.currentPageObj))
         {
            prevPage();
         }
         else
         {
            gotoPage(CodoPageViewDB.PAGE_GVOICE_SETTINGS);
         }
      }
      
      override protected function onForceCloseGVoiceSettings(cEvt:ParaEvent) : void
      {
         if(Boolean(CodoPageViewDB.PAGE_GVOICE_SETTINGS.owner.currentPageObj))
         {
            prevPage();
         }
      }
   }
}

