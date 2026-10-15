package codo.controllers
{
   import codo.constants.CodoInGamePageDB;
   import codo.event.ParaEvent;
   import codo.manager.PageInGameManager;
   import codo.utils.PauseUtil;
   
   public class GVoiceInGameController extends GVoiceBaseController
   {
      
      public function GVoiceInGameController()
      {
         super();
      }
      
      override protected function onToggleVoiceSettings(cEvt:ParaEvent) : void
      {
         trace("GVoiceInGameController.onToggleVoiceSettings");
         if(Boolean(CodoInGamePageDB.PAGE_GVOICE_SETTINGS.owner.currentPageObj))
         {
            PauseUtil.hidePauseMap(false);
            PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_GVOICE_SETTINGS.owner);
         }
         else
         {
            PauseUtil.hidePauseMap(true);
            PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_GVOICE_SETTINGS);
         }
      }
      
      override protected function onForceCloseGVoiceSettings(cEvt:ParaEvent) : void
      {
         if(Boolean(CodoInGamePageDB.PAGE_GVOICE_SETTINGS.owner.currentPageObj))
         {
            PauseUtil.hidePauseMap(false);
            PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_GVOICE_SETTINGS.owner);
         }
      }
   }
}

