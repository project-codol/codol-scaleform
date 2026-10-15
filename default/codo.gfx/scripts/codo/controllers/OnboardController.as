package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCEvent;
   import codo.constants.UIEntry;
   import codo.event.ParaEvent;
   import codo.manager.PageManagerMain;
   import codo.objects.CodoPageObj;
   
   public class OnboardController extends BaseController
   {
      
      public function OnboardController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         listen(BCEvent.EVT_ONBOARD_INIT_UI,this.onOnboardInitUI);
         listen(BCEvent.EVT_NEXT_TUTORIAL_STEP,this.onNextTutorialStep);
         listen(BCEvent.EVT_END_TUTORIAL,this.onEndTutorial);
      }
      
      private function onOnboardInitUI() : void
      {
         unlisten(BCEvent.EVT_ONBOARD_INIT_UI,this.onOnboardInitUI);
         PageManagerMain.getInstance().startUI({
            "entry":UIEntry.UI_HOME,
            "ready":true
         });
      }
      
      protected function onNextTutorialStep(evt:ParaEvent) : void
      {
         var pageID:String = evt.myPara;
         PageManagerMain.getInstance().initNextTutorialStep(pageID);
      }
      
      private function onEndTutorial(evt:ParaEvent) : void
      {
         var pageID:String = evt.myPara;
         var pageObj:CodoPageObj = CodoPageObj.getObjByID(pageID);
         PageManagerMain.getInstance().cleanTutorial(pageObj);
      }
   }
}

