package codo.views.option_sub
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.CODOVirtualKey;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import flash.events.MouseEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class FsgOptionControlChatPanel extends FsgOptionControlBase
   {
      
      private static var CONTROL_BTN_NUM:uint;
      
      private static const KB_CHAT:uint = 0;
      
      private static const KB_MARKING:uint = 1;
      
      private static const KB_SCREEN_CAPTURE:uint = 2;
      
      private static const KB_INSPECT_WEAPON:uint = 3;
      
      private static const KB_USE_CONSUMABLE:uint = 4;
      
      private static const KB_MAP_OVERLAY:uint = 5;
      
      private static const SRC_NAME_CONTROL_BTN:String = "myKB_";
      
      private static var CONTROL_CMD:Array = ["chatmodeteam","+markerslot 1","screenshotJpeg","+inspectWeapon","+actionslot 5","+targetMap"];
      
      private var mCachedScreenshot:Array;
      
      public function FsgOptionControlChatPanel()
      {
         super();
         CONTROL_BTN_NUM = CONTROL_CMD.length;
         myKB = new Array(CONTROL_BTN_NUM);
         for(var i:uint = 0; i < CONTROL_BTN_NUM; i++)
         {
            myKB[i] = this[SRC_NAME_CONTROL_BTN + i];
         }
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myKB[KB_CHAT].label = DictSetting.CONTROL_CHAT;
         myKB[KB_MARKING].label = DictSetting.CONTROL_MARKING;
         myKB[KB_SCREEN_CAPTURE].label = DictSetting.CONTROL_SCREENSHOT;
         myKB[KB_INSPECT_WEAPON].label = DictSetting.CONTROL_INSPECT;
         myKB[KB_USE_CONSUMABLE].label = DictSetting.CONTROL_CONSUMABLE;
         myKB[KB_MAP_OVERLAY].label = DictSetting.CONTROL_MAP_OVERLAY;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         for(var i:int = 0; i < CONTROL_BTN_NUM; i++)
         {
            addBtnListener(myKB[i]);
         }
      }
      
      override protected function onBtnClickHandle(userData:Object) : void
      {
         var cmd:String = null;
         var isChangingBind:Boolean = _isChangingBind;
         var isMouseDownDuringBind:Boolean = _isMouseDownDuringBind;
         super.onBtnClickHandle(userData);
         if(isChangingBind || isMouseDownDuringBind)
         {
            return;
         }
         if(_currentBtnIndex == KB_SCREEN_CAPTURE)
         {
            cmd = CONTROL_CMD[KB_SCREEN_CAPTURE];
            this.mCachedScreenshot = CFunctionCommonContainer.GetKeyBindingValuesFromCommand(cmd);
            CFunctionCommonContainer.ClearKeyBindingForCommand(cmd);
         }
      }
      
      override protected function bindKeyToCmd(keyNum:uint, cmd:String, bMouse:Boolean = false) : void
      {
         var cachedKey:uint = 0;
         if(_currentBtnIndex == KB_SCREEN_CAPTURE)
         {
            for each(cachedKey in this.mCachedScreenshot)
            {
               CFunctionCommonContainer.SetKeyBindingForCommand(cachedKey,CONTROL_CMD[KB_SCREEN_CAPTURE]);
            }
            this.mCachedScreenshot = null;
            if(keyNum == CODOVirtualKey.K_MOUSE1)
            {
               this.showMsg(DictSetting.OPTIONS_SCREENSHOTBIND_WARNING,MsgBtnCount.ONE);
               this.refreshAllCommands();
               this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle,true);
               this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandle,true);
               this.myTFChangeBindHint.text = DictSetting.CONTROL_BINDING_HINT_1;
               this._isChangingBind = false;
               this.broadcast(BCEvent.EVT_TOGGLE_GLOBAL_KEY_CATCH,true);
               return;
            }
         }
         super.bindKeyToCmd(keyNum,cmd,bMouse);
      }
      
      override protected function onUnbondHandle(cEvt:ParaEvent) : void
      {
         var j:int = 0;
         super.onUnbondHandle(cEvt);
         var keyArray:Array = cEvt.myPara;
         for(var i:int = 0; i < CONTROL_CMD.length; i++)
         {
            myKB[i].warn = false;
            for(j = 0; j < keyArray.length; j++)
            {
               if(CONTROL_CMD[i] == keyArray[j])
               {
                  myKB[i].warn = true;
               }
            }
         }
      }
      
      override protected function mapBtnToCmd(cBtn:uint) : String
      {
         return CONTROL_CMD[cBtn];
      }
      
      override protected function onMouseDownHandler(cEvt:MouseEvent) : void
      {
         var evt:MouseEventEx = null;
         if(_currentBtnIndex == KB_SCREEN_CAPTURE)
         {
            evt = cEvt as MouseEventEx;
            if(evt.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               return;
            }
         }
         super.onMouseDownHandle(cEvt);
      }
   }
}

