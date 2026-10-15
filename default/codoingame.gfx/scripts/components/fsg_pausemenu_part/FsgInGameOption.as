package components.fsg_pausemenu_part
{
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.localization.DictSetting;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.CheckBox;
   import fsg.shared.ConfigSlider;
   
   public class FsgInGameOption extends MovieClip
   {
      
      private static var MOUSE_SENSITIVITY_STEP:Number = 0.01;
      
      public var myTitleTF:TextField;
      
      public var myBrightness:ConfigSlider;
      
      public var myMouseSensitivityX:ConfigSlider;
      
      public var myMouseSensitivityY:ConfigSlider;
      
      public var myLookInvert:CheckBox;
      
      public function FsgInGameOption()
      {
         super();
         this.myBrightness.setText(DictSetting.BRIGHTNESS,DictSetting.BRIGHTNESS);
         this.myMouseSensitivityX.setText(DictSetting.CONTROL_MOUSE_SENSITIVITY,DictSetting.CONTROL_MOUSE_SENSITIVITY);
         this.myMouseSensitivityY.setText(DictSetting.CONTROL_MOUSE_SENSITIVITY_Y,DictSetting.CONTROL_MOUSE_SENSITIVITY_Y);
         this.myLookInvert.setText(DictSetting.CONTROL_INVERT_MOUSE,null);
         this.myMouseSensitivityY.visible = false;
         gotoAndStop(1);
      }
      
      public function setTitle(HeaderText:String) : void
      {
         this.myTitleTF.text = HeaderText;
      }
      
      public function showBrightness(show:Boolean) : void
      {
         this.myBrightness.visible = show;
      }
      
      public function initOptionWithParms(options:Object) : void
      {
         this.initSlider(this.myBrightness,options.brightness,0.1);
         this.initSlider(this.myMouseSensitivityX,options.sensitivityX,MOUSE_SENSITIVITY_STEP);
         this.initSlider(this.myMouseSensitivityY,options.sensitivityY,MOUSE_SENSITIVITY_STEP);
      }
      
      public function initOption() : void
      {
         var range:Object = null;
         var options:Object = {};
         range = DataManager.getInstance().getDP(DataInGameID.GAMMA_RANGE);
         if(Boolean(range))
         {
            options.brightness = {
               "min":range.min,
               "max":range.max,
               "value":DataManager.getInstance().getDP(DataInGameID.GAMMA),
               "listener":this.onChangeBrightness
            };
         }
         range = DataManager.getInstance().getDP(DataInGameID.SENSITIVITY_RANGE);
         if(Boolean(range))
         {
            options.sensitivityX = {
               "min":range.min,
               "max":range.max,
               "value":DataManager.getInstance().getDP(DataInGameID.MOUSE_SENSITIVITY_X),
               "listener":this.onChangeSensitivityX
            };
            options.sensitivityY = {
               "min":range.min,
               "max":range.max,
               "value":DataManager.getInstance().getDP(DataInGameID.MOUSE_SENSITIVITY_Y),
               "listener":this.onChangeSensitivityY
            };
         }
         this.myLookInvert.checked = DataManager.getInstance().getDP(DataInGameID.MOUSE_INVERT) < 0;
         this.myLookInvert.addCheckedCallback(this.onChangeLookInvert);
         this.myLookInvert.addUncheckedCallback(this.onChangeLookInvert);
         this.initOptionWithParms(options);
      }
      
      private function initSlider(slider:ConfigSlider, params:Object, step:Number) : void
      {
         if(slider == null || params == null)
         {
            return;
         }
         slider.initialise(params.value,params.min,params.max,step);
         slider.registerValueChangedEvent(params.listener);
      }
      
      public function stopSliderDragState() : void
      {
         this.myBrightness.forceStopDrag();
         this.myMouseSensitivityX.forceStopDrag();
         this.myMouseSensitivityY.forceStopDrag();
      }
      
      private function onChangeBrightness() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_SET_BRIGHTNESS,this.myBrightness.getValue());
      }
      
      private function onChangeSensitivityX() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_SET_MOUSE_SENSITIVITY_X,this.myMouseSensitivityX.getValue());
      }
      
      private function onChangeSensitivityY() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_SET_MOUSE_SENSITIVITY_Y,this.myMouseSensitivityY.getValue());
      }
      
      private function onChangeLookInvert() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_SET_MOUSE_INVERT,this.myLookInvert.checked ? "-0.022" : "0.022");
      }
   }
}

