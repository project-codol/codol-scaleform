package
{
   import codo.base.BaseMain;
   import codo.common.ThreeDAdjuster;
   import codo.constants.AsyncTaskName;
   import codo.constants.CodoPageViewDB;
   import codo.constants.ControllerName;
   import codo.constants.GameInfo;
   import codo.constants.MarketSlots;
   import codo.constants.MenuType;
   import codo.controllers.ScreenshotController;
   import codo.controllers.StageKeyController;
   import codo.manager.AsyncTaskManager;
   import codo.manager.CommManager;
   import codo.manager.ControllerManager;
   import codo.manager.PageManagerMain;
   import codo.utils.FakeXMLData;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   [SWF(width="1920", height="1080", backgroundColor="#061416", frameRate="30")]
   [SWF(width="1920",height="1080",backgroundColor="#061416",frameRate="30")]
   public class MenuMain extends BaseMain
   {
      
      private var _3DAdjuster:ThreeDAdjuster;
      
      private var _start3DAdjust:Boolean = false;
      
      private var _ui3DAdjustMouseDownX:Number;
      
      private var _ui3DAdjustMouseDownY:Number;
      
      private var _adjustType:uint = 0;
      
      private var _shiftDown:Boolean = false;
      
      private var _altDown:Boolean = false;
      
      private var _ctrlDown:Boolean = false;
      
      private var _stageKeyController:StageKeyController = null;
      
      private var _waterMarker:MovieClip;
      
      public function MenuMain()
      {
         super();
      }
      
      override protected function preInit() : void
      {
         super.preInit();
         GameInfo.setStageSize(1920,1080);
         this.menuType = MenuType.MAIN;
         this._pageManager = PageManagerMain.getInstance();
         this._pageManager.pages = CodoPageViewDB.PAGES;
         this.commManager = CommManager.getInstance();
         this.commManager.preInit();
         this.asyncTaskManager = AsyncTaskManager.getInstance();
         this.asyncTaskManager.GetTaskClass = AsyncTaskName.getClass;
         this.controllerManager = ControllerManager.getInstance();
         this.controllerManager.preInit(ControllerName.preControllerClasses);
         this.initScreenshot();
         MarketSlots.init();
         if(!ScaleformUtil.isScaleform)
         {
            FakeXMLData.init();
         }
      }
      
      override protected function onStageKeyHandle(cEvt:KeyboardEvent) : void
      {
         super.onStageKeyHandle(cEvt);
         if(cEvt.type == KeyboardEvent.KEY_DOWN)
         {
            if(this._stageKeyController == null)
            {
               this._stageKeyController = ControllerManager.getInstance().getController(ControllerName.StageKey) as StageKeyController;
            }
            if(this._stageKeyController != null)
            {
               this._stageKeyController.processKeyDown(cEvt);
            }
         }
         if(this.isDev() && ScaleformUtil.isTempContentEnabled())
         {
            if(cEvt.type == KeyboardEvent.KEY_DOWN)
            {
               if(this._3DAdjuster == null)
               {
                  this._3DAdjuster = new ThreeDAdjuster();
               }
               this._3DAdjuster.receiveKeyDownCode(cEvt.keyCode);
            }
            if(cEvt.keyCode == Keyboard.SHIFT)
            {
               this._shiftDown = cEvt.type == KeyboardEvent.KEY_DOWN;
            }
            else if(cEvt.keyCode == Keyboard.ALTERNATE)
            {
               this._altDown = cEvt.type == KeyboardEvent.KEY_DOWN;
            }
            else if(cEvt.keyCode == Keyboard.CONTROL)
            {
               this._ctrlDown = cEvt.type == KeyboardEvent.KEY_DOWN;
            }
            if(this._shiftDown == true && this._altDown == true && this._ctrlDown == true)
            {
               this.rotationX = this.rotationY = 0;
               this.x = this.y = 0;
               this.scaleX = this.scaleY = 1;
            }
            if(this._start3DAdjust == false && (this._shiftDown == true || this._altDown == true || this._ctrlDown == true))
            {
               this._start3DAdjust = true;
               if(this._ctrlDown == true)
               {
                  this._adjustType = 3;
               }
               else if(this._altDown == true)
               {
                  this._adjustType = 1;
               }
               else if(this._shiftDown == true)
               {
                  this._adjustType = 2;
               }
               this.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDownHandle);
            }
            if(this._start3DAdjust == true && this._shiftDown == false && this._altDown == false && this._ctrlDown == false)
            {
               this._start3DAdjust = false;
               this._adjustType = 0;
               this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDownHandle);
               this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
               this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
            }
         }
      }
      
      private function onStageMouseDownHandle(cEvt:MouseEvent) : void
      {
         this._ui3DAdjustMouseDownX = this.stage.mouseX;
         this._ui3DAdjustMouseDownY = this.stage.mouseY;
         this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDownHandle);
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
      }
      
      private function onStageMouseMoveHandle(cEvt:MouseEvent) : void
      {
         var tempOffsetY:Number = NaN;
         var tempOffsetX:Number = this.stage.mouseX - this._ui3DAdjustMouseDownX;
         tempOffsetY = this.stage.mouseY - this._ui3DAdjustMouseDownY;
         this._ui3DAdjustMouseDownX = this.stage.mouseX;
         this._ui3DAdjustMouseDownY = this.stage.mouseY;
         switch(this._adjustType)
         {
            case 1:
               this.rotationX += tempOffsetY / 4;
               this.rotationY -= tempOffsetX / 4;
               break;
            case 2:
               this.x += tempOffsetX;
               this.y += tempOffsetY;
               break;
            case 3:
               this.scaleX = this.scaleY = this.scaleY - tempOffsetY / 100;
         }
      }
      
      private function onStageMouseUpHandle(cEvt:MouseEvent) : void
      {
         this.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDownHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
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
         this._waterMarker = new mcWaterMark();
         var scController:ScreenshotController = this.controllerManager.getController(ControllerName.Screenshot) as ScreenshotController;
         scController.setMode(ScreenshotController.FROM_MAIN_MENU);
         scController.setScreenshotStateChangedCB(this.screenshotStateChangedHandler);
      }
      
      private function screenshotStateChangedHandler(state:Boolean) : void
      {
         if(state)
         {
            this.addChild(this._waterMarker);
            this._waterMarker.x = GameInfo.DEFAULT_WIDTH - this._waterMarker.width + GameInfo.widthExtra;
            this._waterMarker.y = GameInfo.DEFAULT_HEIGHT - this._waterMarker.height + GameInfo.heightExtra;
         }
         else if(this._waterMarker.parent != null)
         {
            this.removeChild(this._waterMarker);
         }
      }
   }
}

