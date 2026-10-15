package components.fsg_pausemenu_part
{
   import codo.constants.ComponentCSS;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class FsgSocialInfoButton extends MovieClip
   {
      
      public static const STATE_INERT:uint = 1;
      
      public static const STATE_HIGHLIGHTED:uint = 2;
      
      public static const STATE_SELECTED:uint = 3;
      
      public var myNumber_TF:TextField;
      
      public var myText_TF:TextField;
      
      public var myHitArea:MovieClip;
      
      public var colourArray:Array = new Array(5);
      
      private var CallBackFunction:Function;
      
      public function FsgSocialInfoButton()
      {
         super();
         this.myHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.myHitArea.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.colourArray[0] = 8026233;
         this.colourArray[1] = 8026233;
         this.colourArray[2] = ComponentCSS.FSG_COLOR_BLUE;
         this.colourArray[3] = 8026233;
         this.colourArray[4] = 16777215;
      }
      
      public function setButtonText(buttonText:String) : void
      {
         this.myText_TF.text = buttonText;
      }
      
      public function steMessageNumber(number:uint) : void
      {
         this.myNumber_TF.text = String(number);
      }
      
      public function setCallbackOnClick(newFunction:Function) : void
      {
         this.CallBackFunction = newFunction;
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         if(this.state == STATE_INERT)
         {
            this.state = STATE_HIGHLIGHTED;
         }
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         if(this.state == STATE_HIGHLIGHTED)
         {
            this.state = STATE_INERT;
         }
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         this.state = STATE_SELECTED;
         this.CallBackFunction();
      }
      
      public function addMouseClickListener(listener:Function) : void
      {
         this.myHitArea.addEventListener(MouseEvent.CLICK,listener);
      }
      
      public function isMouseEventTarget(evt:MouseEvent) : Boolean
      {
         return this.myHitArea == evt.currentTarget;
      }
      
      public function get state() : uint
      {
         return this.currentFrame;
      }
      
      public function set state(uState:uint) : void
      {
         this.gotoAndStop(uState);
         this.myNumber_TF.textColor = this.colourArray[uState];
         this.myText_TF.textColor = this.colourArray[uState + 2];
      }
   }
}

