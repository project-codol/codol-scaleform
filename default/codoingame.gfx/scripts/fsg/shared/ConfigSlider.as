package fsg.shared
{
   import codo.constants.SE_ID;
   import codo.interfaces.IDisposable;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import fsg.util.FsgAudioUtil;
   
   public class ConfigSlider extends MovieClip implements IDisposable
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      public var myCounter:MovieClip;
      
      public var mySliderHandle:MovieClip;
      
      public var myLabel:MovieClip;
      
      public var myNib:MovieClip;
      
      public var myLabelBG:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_clickableNib:BehaviourClickable;
      
      private var m_label:BehaviourLabel;
      
      private var m_counterLabel:BehaviourLabel;
      
      private var m_slider:BehaviourSlider;
      
      private var m_sliderNib:BehaviourSlider;
      
      private var m_valueCallback:Function;
      
      private var m_tooltip:BehaviourTooltip;
      
      private var m_audio:BehaviourAudio;
      
      private var m_value:Number = 0;
      
      private var m_step:Number = 1;
      
      public function ConfigSlider()
      {
         var maxValue:Number = NaN;
         super();
         var minValue:Number = 1;
         maxValue = 10;
         var initialValue:Number = maxValue;
         this.m_value = initialValue;
         this.m_label = new BehaviourLabel(this.myLabel.myLabel);
         this.m_counterLabel = new BehaviourLabel(this.myCounter.myValue);
         this.m_clickable = new BehaviourClickable(this.mySliderHandle.myHitArea);
         if(Boolean(this.myNib))
         {
            this.m_clickableNib = new BehaviourClickable(this.myNib.myHitArea,true);
         }
         this.m_audio = new BehaviourAudio(this.m_clickable,SE_ID.GENERAL_ROLLOVER,SE_ID.MUTE);
         this.m_slider = new BehaviourSlider(this.m_clickable,this.mySliderHandle.mySlider,this.mySliderHandle.myHitArea);
         if(Boolean(this.myNib) && Boolean(this.m_clickableNib))
         {
            this.m_sliderNib = new BehaviourSlider(this.m_clickableNib,this.mySliderHandle.mySlider,this.mySliderHandle.myHitArea);
         }
         this.setCounterValue(this.m_value);
         this.m_slider.initialise(this.m_value,minValue,maxValue);
         this.m_slider.registerValueCallback(this.onValueChanged);
         if(Boolean(this.myNib))
         {
            this.m_sliderNib.initialise(this.m_value,minValue,maxValue);
            this.m_sliderNib.registerValueCallback(this.onValueChanged);
         }
         if(this.myNib != null)
         {
            this.myNib.addEventListener(MouseEvent.MOUSE_DOWN,this.setSliderMouseDownNib);
            this.myNib.addEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseReleaseNib);
            this.myNib.addEventListener(MouseEvent.MOUSE_OVER,this.setSliderMouseOverNib);
            this.myNib.addEventListener(MouseEvent.MOUSE_OUT,this.setSliderMouseOutNib);
         }
         this.mySliderHandle.addEventListener(MouseEvent.MOUSE_DOWN,this.setSliderMouseDown);
         this.mySliderHandle.addEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseRelease);
         this.mySliderHandle.addEventListener(MouseEvent.MOUSE_OVER,this.setSliderMouseOver);
         this.mySliderHandle.addEventListener(MouseEvent.MOUSE_OUT,this.setSliderMouseOut);
      }
      
      private function setSliderMouseDown(e:MouseEvent) : void
      {
         parent.stage.addEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseRelease);
         gotoAndStop(OVER_STATE_FRAME);
      }
      
      private function setSliderMouseRelease(e:MouseEvent) : void
      {
         parent.stage.removeEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseRelease);
         if(e.currentTarget != this.mySliderHandle)
         {
            gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      private function setSliderMouseOver(e:MouseEvent) : void
      {
         if(!e.buttonDown)
         {
            gotoAndStop(OVER_STATE_FRAME);
         }
      }
      
      private function setSliderMouseOut(e:MouseEvent) : void
      {
         if(!e.buttonDown)
         {
            gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      private function setSliderMouseReleaseNib(e:MouseEvent) : void
      {
         parent.stage.removeEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseReleaseNib);
         if(e.currentTarget != this.myNib)
         {
            this.myNib.gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      private function setSliderMouseOverNib(e:MouseEvent) : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
         this.myNib.gotoAndStop(OVER_STATE_FRAME);
      }
      
      private function setSliderMouseOutNib(e:MouseEvent) : void
      {
         if(!e.buttonDown)
         {
            this.myNib.gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      private function setSliderMouseDownNib(e:MouseEvent) : void
      {
         parent.stage.addEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseReleaseNib);
         this.myNib.gotoAndStop(OVER_STATE_FRAME);
      }
      
      public function initialise(value:Number, minValue:Number, maxValue:Number, stepValue:Number = 1) : void
      {
         this.m_value = value;
         this.m_step = stepValue;
         this.setCounterValue(value);
         this.m_slider.initialise(this.m_value,minValue,maxValue,stepValue);
         if(Boolean(this.m_sliderNib))
         {
            this.m_sliderNib.initialise(this.m_value,minValue,maxValue,stepValue);
         }
      }
      
      public function setText(str:String, tooltip:String) : void
      {
         this.m_label.setText(str);
         if(tooltip != null)
         {
            this.m_tooltip = new BehaviourTooltip(this.m_clickable,tooltip,this.mySliderHandle.myHitArea);
         }
         if(this.myLabelBG != null)
         {
            this.myLabelBG.width = this.myLabel.myLabel.textWidth + this.myLabel.x;
         }
      }
      
      public function getValue() : Number
      {
         return this.m_value;
      }
      
      public function registerValueChangedEvent(callback:Function) : void
      {
         this.m_valueCallback = callback;
      }
      
      public function forceStopDrag() : void
      {
         this.m_slider.stopDrag();
         if(Boolean(this.m_sliderNib))
         {
            this.m_sliderNib.stopDrag();
         }
      }
      
      private function onValueChanged(value:Number) : void
      {
         if(this.m_value != value)
         {
            this.m_value = value;
            this.setCounterValue(this.m_value);
            FsgAudioUtil.getInstance().playSound(SE_ID.SCROLLBAR_SCROLL);
            if(this.m_valueCallback != null)
            {
               this.m_valueCallback();
            }
         }
         if(this.myNib != null)
         {
            this.myNib.x = this.mySliderHandle.mySlider.x + this.mySliderHandle.mySlider.width - this.myNib.width / 2;
         }
      }
      
      private function setCounterValue(value:Number) : void
      {
         if(this.m_step == 1)
         {
            this.m_counterLabel.setText(value.toFixed(0));
         }
         else
         {
            this.m_counterLabel.setText(value.toString());
         }
      }
      
      public function dispose() : void
      {
         if(this.myNib != null)
         {
            this.myNib.removeEventListener(MouseEvent.MOUSE_DOWN,this.setSliderMouseDownNib);
            this.myNib.removeEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseReleaseNib);
            this.myNib.removeEventListener(MouseEvent.MOUSE_OVER,this.setSliderMouseOverNib);
            this.myNib.removeEventListener(MouseEvent.MOUSE_OUT,this.setSliderMouseOutNib);
         }
         this.mySliderHandle.removeEventListener(MouseEvent.MOUSE_DOWN,this.setSliderMouseDown);
         this.mySliderHandle.removeEventListener(MouseEvent.MOUSE_UP,this.setSliderMouseRelease);
         this.mySliderHandle.removeEventListener(MouseEvent.MOUSE_OVER,this.setSliderMouseOver);
         this.mySliderHandle.removeEventListener(MouseEvent.MOUSE_OUT,this.setSliderMouseOut);
         this.m_clickable.dispose();
         if(Boolean(this.myNib))
         {
            this.m_clickableNib.dispose();
         }
         this.m_audio.dispose();
      }
   }
}

