package shaui.component.core
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import scaleform.gfx.MouseEventEx;
   import shaui.component.config.UIConfig;
   
   public class InteractiveComponent extends UIComponent
   {
      
      protected static const OUT:uint = 0;
      
      protected static const IN:uint = 1;
      
      public var myHitArea:Sprite;
      
      private var _isSoundOn:Boolean = false;
      
      private var _enable:Boolean = true;
      
      private var _mouseState:int;
      
      public function InteractiveComponent()
      {
         super();
         if(this.myHitArea != null)
         {
            hitArea = this.myHitArea;
            this.myHitArea.visible = false;
         }
         this.enable = true;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(value:Boolean) : void
      {
         this._enable = value;
         this.mouseInteractivity = this._enable;
      }
      
      protected function get mouseState() : uint
      {
         return this._mouseState;
      }
      
      final protected function set mouseInteractivity(value:Boolean) : void
      {
         enabled = value;
         mouseEnabled = value;
         buttonMode = value;
         mouseChildren = value && this.myHitArea == null;
         doubleClickEnabled = value;
         if(isInit)
         {
            if(this._enable)
            {
               addEventListener(MouseEvent.CLICK,this.mouseClickHandler,false,0,true);
               addEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClickHandler,false,0,true);
               addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler,false,0,true);
               addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler,false,0,true);
               addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler,false,0,true);
               addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler,false,0,true);
               addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
            }
            else
            {
               removeEventListener(MouseEvent.CLICK,this.mouseClickHandler);
               removeEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDoubleClickHandler);
               removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
               removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
               removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
               removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
               removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
            }
            this.updateMouseInteractivity(value);
         }
      }
      
      override protected function onInitListener() : void
      {
         this.mouseInteractivity = this._enable;
      }
      
      public function soundOff() : void
      {
         this._isSoundOn = false;
      }
      
      public function soundOn() : void
      {
         this._isSoundOn = true;
      }
      
      protected function updateMouseInteractivity(value:Boolean) : void
      {
      }
      
      protected function onClickHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMiddleClickHandler(e:MouseEvent) : void
      {
      }
      
      protected function onRightClickHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMouseDoubleClickHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMouseDownHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMouseMoveHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMouseOverHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMouseOutHandler(e:MouseEvent) : void
      {
      }
      
      protected function onMouseUpHandler(e:MouseEvent) : void
      {
      }
      
      private function mouseClickHandler(e:MouseEvent) : void
      {
         var tempEvtEx:MouseEventEx = null;
         if(UIConfig.isScaleform)
         {
            tempEvtEx = e as MouseEventEx;
            if(tempEvtEx.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               this.onClickHandler(e);
            }
            else if(tempEvtEx.buttonIdx == MouseEventEx.MIDDLE_BUTTON)
            {
               this.onMiddleClickHandler(e);
            }
            else if(tempEvtEx.buttonIdx == MouseEventEx.RIGHT_BUTTON)
            {
               this.onRightClickHandler(e);
            }
         }
         else if(e.ctrlKey)
         {
            this.onRightClickHandler(e);
         }
         else if(e.altKey)
         {
            this.onMiddleClickHandler(e);
         }
         else
         {
            this.onClickHandler(e);
         }
      }
      
      private function mouseOverHandler(e:MouseEvent) : void
      {
         this._mouseState = IN;
         this.onMouseOverHandler(e);
      }
      
      private function mouseOutHandler(e:MouseEvent) : void
      {
         this._mouseState = OUT;
         this.onMouseOutHandler(e);
      }
      
      private function mouseUpHandler(e:MouseEvent) : void
      {
         this.onMouseUpHandler(e);
      }
   }
}

