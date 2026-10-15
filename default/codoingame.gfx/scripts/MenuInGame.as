package
{
   import codo.base.BaseMain;
   import codo.constants.AsyncTaskInGameName;
   import codo.constants.ControllerInGameName;
   import codo.constants.GameInfo;
   import codo.constants.MenuType;
   import codo.controllers.ScreenshotController;
   import codo.manager.AsyncTaskManager;
   import codo.manager.CommInGameManager;
   import codo.manager.ControllerManager;
   import codo.manager.DataManager;
   import codo.manager.PageInGameManager;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   
   [SWF(width="1280", height="960", backgroundColor="#000000", frameRate="30")]
   [SWF(backgroundColor="0x000000",frameRate="30",width="1280",height="960")]
   public class MenuInGame extends BaseMain
   {
      
      private var m_waterMarker:MovieClip;
      
      public function MenuInGame()
      {
         super();
      }
      
      override protected function preInit() : void
      {
         super.preInit();
         GameInfo.setStageSize(1280,960);
         this.menuType = MenuType.IN_GAME;
         this._pageManager = PageInGameManager.getInstance();
         this.commManager = CommInGameManager.getInstance();
         this.commManager.preInit();
         this.asyncTaskManager = AsyncTaskManager.getInstance();
         this.asyncTaskManager.GetTaskClass = AsyncTaskInGameName.getClass;
         this.controllerManager = ControllerManager.getInstance();
         this.controllerManager.preInit(ControllerInGameName.preControllerClasses);
         this.dataManager = DataManager.getInstance();
         this.initScreenshot();
      }
      
      override protected function resetStageScale() : void
      {
         if(this.stage != null)
         {
            this.stage.scaleMode = StageScaleMode.SHOW_ALL;
            this.stage.align = StageAlign.TOP;
         }
      }
      
      private function initScreenshot() : void
      {
         this.m_waterMarker = new mcWaterMark();
         var scController:ScreenshotController = this.controllerManager.getController(ControllerInGameName.SCREEN_SHOT) as ScreenshotController;
         scController.setMode(ScreenshotController.FROM_IN_GAME);
         scController.setScreenshotStateChangedCB(this.screenshotStateChangedHandler);
      }
      
      private function screenshotStateChangedHandler(state:Boolean) : void
      {
         if(state)
         {
            this.addChild(this.m_waterMarker);
            this.m_waterMarker.x = GameInfo.DEFAULT_WIDTH - this.m_waterMarker.width + GameInfo.widthExtra;
            this.m_waterMarker.y = GameInfo.DEFAULT_HEIGHT - this.m_waterMarker.height + GameInfo.heightExtra;
         }
         else if(this.m_waterMarker.parent != null)
         {
            this.removeChild(this.m_waterMarker);
         }
      }
   }
}

