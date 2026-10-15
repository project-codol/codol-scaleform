package codo.views.option_sub
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import fsg.shared.CheckBox;
   import fsg.shared.ConfigSlider;
   
   public class FsgOptionControlLookPanel extends FsgOptionControlBase
   {
      
      private static const KB_LOOK_UP:uint = 0;
      
      private static const KB_LOOK_DOWN:uint = 1;
      
      private static const KB_HOLD_MOUSE_LOOK:uint = 2;
      
      private static const KB_CENTER_VIEW:uint = 3;
      
      private static const SRC_NAME_CONTROL_BTN:String = "myKB_";
      
      private static var CONTROL_BTN_NUM:int = 4;
      
      private static var CONTROL_CMD:Array = ["+lookup","+lookdown","+mlook","centerview"];
      
      private static var MOUSE_SENSITIVITY_STEP:Number = 0.01;
      
      public var myMouseSensitivityX:ConfigSlider;
      
      public var myMouseSensitivityY:ConfigSlider;
      
      public var myCBMouseInvert:CheckBox;
      
      public var myCBMouseSmooth:CheckBox;
      
      public var myCBFreeLook:CheckBox;
      
      public function FsgOptionControlLookPanel()
      {
         super();
         myKB = new Array(CONTROL_BTN_NUM);
         for(var i:uint = 0; i < CONTROL_BTN_NUM; i++)
         {
            myKB[i] = this[SRC_NAME_CONTROL_BTN + i];
         }
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myMouseSensitivityX.setText(DictSetting.CONTROL_MOUSE_SENSITIVITY,null);
         this.myMouseSensitivityY.setText(DictSetting.CONTROL_MOUSE_SENSITIVITY_Y,null);
         this.myMouseSensitivityY.visible = false;
         this.myCBMouseInvert.setText(DictSetting.CONTROL_INVERT_MOUSE,null);
         this.myCBMouseSmooth.setText(DictSetting.CONTROL_SMOOTH_MOUSE,DictSetting.CONTROL_SMOOTH_MOUSE_DESC);
         this.myCBFreeLook.setText(DictSetting.CONTROL_FREE_LOOK,null);
         this.myKB[KB_LOOK_UP].label = DictSetting.CONTROL_LOOK_UP;
         this.myKB[KB_LOOK_DOWN].label = DictSetting.CONTROL_LOOK_DOWN;
         this.myKB[KB_HOLD_MOUSE_LOOK].label = DictSetting.CONTROL_HOLD_MOUSE_LOOK;
         this.myKB[KB_CENTER_VIEW].label = DictSetting.CONTROL_CENTER_VIEW;
         this.myTFChangeBindHint.text = DictSetting.CONTROL_BINDING_HINT_1;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         for(var i:int = 0; i < CONTROL_BTN_NUM; i++)
         {
            this.addBtnListener(myKB[i]);
         }
         listen(BCEvent.EVT_VSYNC_OPTION_CHANGE,this.onVSyncOptionChange);
      }
      
      override protected function mapBtnToCmd(cBtn:uint) : String
      {
         return CONTROL_CMD[cBtn];
      }
      
      override protected function onResetControlsHandle(cEvt:ParaEvent) : void
      {
         super.onResetControlsHandle(cEvt);
      }
      
      override protected function onUnbondHandle(cEvt:ParaEvent) : void
      {
         var j:int = 0;
         super.onUnbondHandle(cEvt);
         var keyArray:Array = cEvt.myPara;
         for(var i:int = 0; i < CONTROL_CMD.length; i++)
         {
            this[SRC_NAME_CONTROL_BTN + i].warn = false;
            for(j = 0; j < keyArray.length; j++)
            {
               if(CONTROL_CMD[i] == keyArray[j])
               {
                  this[SRC_NAME_CONTROL_BTN + i].warn = true;
               }
            }
         }
      }
      
      private function refreshSmoothLookCheckBox(isVsyncEnabled:Boolean) : void
      {
         if(isVsyncEnabled)
         {
            this.myCBMouseSmooth.enable = false;
            this.myCBMouseSmooth.checked = true;
         }
         else
         {
            this.myCBMouseSmooth.enable = true;
         }
      }
      
      override protected function refreshAllCommands() : void
      {
         var isVsyncEnabled:Boolean = false;
         super.refreshAllCommands();
         this.myCBMouseInvert.checked = this.getDP(DataID.GET_MOUSE_INVERT) < 0;
         this.myCBMouseSmooth.checked = this.getDP(DataID.GET_MOUSE_SMOOTH);
         this.myCBFreeLook.checked = this.getDP(DataID.GET_FREE_LOOK);
         var range:Object = this.getDP(DataID.SENSITIVITY_RANGE);
         if(range != null)
         {
            this.myMouseSensitivityX.initialise(this.getDP(DataID.GET_MOUSE_SENSITIVITY_X),range.min,range.max,MOUSE_SENSITIVITY_STEP);
            this.myMouseSensitivityY.initialise(this.getDP(DataID.GET_MOUSE_SENSITIVITY_Y),range.min,range.max,MOUSE_SENSITIVITY_STEP);
         }
         var videoSettings:Object = this.getDP(DataID.VIDEO_SETTING);
         if(videoSettings != null && videoSettings.ui_r_vsync != null)
         {
            isVsyncEnabled = videoSettings.ui_r_vsync as Boolean;
            this.refreshSmoothLookCheckBox(isVsyncEnabled);
         }
      }
      
      override public function onAcceptSettings() : void
      {
         super.onAcceptSettings();
         this.broadcast(BCEvent.EVT_SET_MOUSE_INVERT,this.myCBMouseInvert.checked ? "-0.022" : "0.022");
         this.broadcast(BCEvent.EVT_SET_MOUSE_SMOOTH,this.myCBMouseSmooth.checked ? "1" : "0");
         this.broadcast(BCEvent.EVT_SET_FREE_LOOK,this.myCBFreeLook.checked ? "1" : "0");
         this.broadcast(BCEvent.EVT_SET_MOUSE_SENSITIVITY_X,this.myMouseSensitivityX.getValue());
         this.broadcast(BCEvent.EVT_SET_MOUSE_SENSITIVITY_Y,this.myMouseSensitivityY.getValue());
      }
      
      private function onVSyncOptionChange(evt:ParaEvent) : void
      {
         var isVsyncEnabled:Boolean = Boolean(evt.myPara.v_sync_enabled);
         this.refreshSmoothLookCheckBox(isVsyncEnabled);
      }
   }
}

