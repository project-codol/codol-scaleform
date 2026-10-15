package components
{
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import shaui.component.core.InteractiveComponent;
   
   public class Label extends InteractiveComponent
   {
      
      private static const DELAY_AUTO_ROLL_CHANGE_WAY:uint = 700;
      
      public var myLabelTF:TextField;
      
      [Inspectable(name="LabelColor",defaultValue="0xFFFFFF",type="Color")]
      public var _textColor:uint = 16777215;
      
      private var _enableAutoRoll:Boolean = false;
      
      private var _autoRollSpeed:uint = 2;
      
      private var _currrentAutoRollWay:int = 1;
      
      private var _currrentAutoRollDelayRemain:int;
      
      private var _enableRollBack:Boolean = true;
      
      private var _autoRollTimer:Timer;
      
      public function Label()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.textColor = this._textColor;
      }
      
      public function set textColor(cColor:uint) : void
      {
         this._textColor = cColor;
         this.myLabelTF.textColor = this._textColor;
      }
      
      public function get textColor() : uint
      {
         return this._textColor;
      }
      
      public function set label(cStr:String) : void
      {
         this.myLabelTF.text = cStr;
      }
      
      public function set text(cStr:String) : void
      {
         this.myLabelTF.text = cStr;
      }
      
      public function get label() : String
      {
         return this.myLabelTF.text;
      }
      
      public function get tf() : TextField
      {
         return this.myLabelTF;
      }
      
      public function set enableRollBack(cSwi:Boolean) : void
      {
         this._enableRollBack = cSwi;
      }
      
      public function set autoRollSpeed(cSpd:uint) : void
      {
         this._autoRollSpeed = cSpd;
      }
      
      public function set enableAutoRoll(cSwi:Boolean) : void
      {
         this._enableAutoRoll = cSwi;
         if(this._enableAutoRoll == true)
         {
            this.myLabelTF.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOverHandle);
            this.myLabelTF.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOutHandle);
         }
         else
         {
            this.myLabelTF.removeEventListener(MouseEvent.MOUSE_OVER,this.onRollOverHandle);
            this.myLabelTF.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOutHandle);
         }
      }
      
      public function get enableAutoRoll() : Boolean
      {
         return this._enableAutoRoll;
      }
      
      public function startRoll() : void
      {
         if(this._autoRollTimer == null)
         {
            this._autoRollTimer = new Timer(50);
            this._autoRollTimer.addEventListener(TimerEvent.TIMER,this.onAutoRollTimerHandle);
         }
         else
         {
            this._autoRollTimer.reset();
         }
         this._currrentAutoRollDelayRemain = DELAY_AUTO_ROLL_CHANGE_WAY;
         if(this.myLabelTF.maxScrollH > 0)
         {
            this._autoRollTimer.start();
         }
      }
      
      public function stopRoll() : void
      {
         this._autoRollTimer.stop();
         this.myLabelTF.scrollH = 0;
         this._currrentAutoRollWay = 1;
         this._currrentAutoRollDelayRemain = DELAY_AUTO_ROLL_CHANGE_WAY;
      }
      
      private function onRollOverHandle(cEvt:MouseEvent) : void
      {
         this.startRoll();
      }
      
      private function onRollOutHandle(cEvt:MouseEvent) : void
      {
         this.stopRoll();
      }
      
      private function onAutoRollTimerHandle(cEvt:TimerEvent) : void
      {
         if(this._currrentAutoRollDelayRemain >= 0)
         {
            this._currrentAutoRollDelayRemain -= this._autoRollTimer.delay;
            if(this._enableRollBack == false && this._currrentAutoRollDelayRemain == 0 && this.myLabelTF.scrollH != 0)
            {
               this.myLabelTF.scrollH = 0;
               this._currrentAutoRollDelayRemain = DELAY_AUTO_ROLL_CHANGE_WAY;
            }
         }
         else
         {
            this.myLabelTF.scrollH += this._autoRollSpeed * this._currrentAutoRollWay;
            if(this._currrentAutoRollWay > 0 && this.myLabelTF.scrollH >= this.myLabelTF.maxScrollH)
            {
               if(this._enableRollBack == true)
               {
                  this._currrentAutoRollWay = -1;
               }
               this._currrentAutoRollDelayRemain = DELAY_AUTO_ROLL_CHANGE_WAY;
            }
            else if(this._currrentAutoRollWay < 0 && this.myLabelTF.scrollH <= 1)
            {
               this._currrentAutoRollWay = 1;
               this._currrentAutoRollDelayRemain = DELAY_AUTO_ROLL_CHANGE_WAY;
            }
         }
      }
   }
}

