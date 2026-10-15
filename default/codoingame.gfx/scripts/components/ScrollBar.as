package components
{
   import codo.event.ParaEvent;
   import components.scrollbar_part.ScrollBarBarbtn;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import shaui.component.core.InteractiveComponent;
   
   public dynamic class ScrollBar extends InteractiveComponent
   {
      
      public var myBar:ScrollBarBarbtn;
      
      public var myBg:Sprite;
      
      private var _dragInterval:Number;
      
      private var _position:Number = 0;
      
      private var _moveSpd:uint = 33;
      
      private var _movePressOffsetY:Number;
      
      private var _targetPos:Number;
      
      private var _isDraging:Boolean = false;
      
      private var _moveBarBySelf:Boolean = true;
      
      private var _autoHideBg:Boolean = false;
      
      private var _grid:Number = 0.3;
      
      private var _itemAmount:uint = 0;
      
      public function ScrollBar()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myBar.height = this.height * this._grid;
         this.myBar.soundOff();
      }
      
      override protected function onInitListener() : void
      {
         this.myBar.addEventListener(BaseButton.EVT_MOUSE_DOWN,this.onBarClickHandle);
      }
      
      override public function set width(cSize:Number) : void
      {
         this.myBg.width = cSize;
         this.refresh();
      }
      
      override public function set height(cSize:Number) : void
      {
         this.myBg.height = cSize;
         this.myBar.height = this.myBg.height * this._grid;
         this.refresh();
      }
      
      public function set autoHideBg(value:Boolean) : void
      {
         this._autoHideBg = value;
         if(this.myBg != null)
         {
            this.myBg.visible = !this._autoHideBg;
         }
      }
      
      public function get position() : Number
      {
         return this._position;
      }
      
      public function set position(cPos:Number) : void
      {
         if(this._isDraging == false || this._moveBarBySelf == false)
         {
            if(cPos < 0)
            {
               cPos = 0;
            }
            else if(cPos > 1)
            {
               cPos = 1;
            }
            if(this._position != cPos)
            {
               this._position = cPos;
               this.refresh();
            }
         }
      }
      
      public function get targetPosition() : Number
      {
         return this._targetPos;
      }
      
      public function set itemAmount(cAmount:uint) : void
      {
         var tempOldPosition:Number = NaN;
         tempOldPosition = this._position;
         if(cAmount == 0)
         {
            this.myBar.enable = false;
            this.myBar.visible = false;
            this.myBg.visible = !this._autoHideBg;
            this._position = 0;
            this._itemAmount = 0;
            if(tempOldPosition != this._position)
            {
               this._targetPos = this._position;
               this.dispatchEvent(new Event(Event.SCROLL));
            }
         }
         else
         {
            this._position = this._itemAmount * this._position / cAmount;
            if(this._position > 1)
            {
               this._position = 1;
            }
            else if(isNaN(this._position) == true)
            {
               this._position = 0;
            }
            this.myBar.enable = true;
            this.myBar.visible = true;
            this.myBg.visible = true;
            this._itemAmount = cAmount;
            this._grid = 0.8 - 0.1 * (Math.floor(cAmount / 5) - 1);
            if(this._grid > 0.8)
            {
               this._grid = 0.8;
            }
            else if(this._grid < 0.3)
            {
               this._grid = 0.3;
            }
            this.myBar.height = this.myBg.height * this._grid;
            this.refresh();
            if(tempOldPosition != this._position)
            {
               this._targetPos = this._position;
               this.dispatchEvent(new Event(Event.SCROLL));
            }
         }
      }
      
      public function get itemAmount() : uint
      {
         return this._itemAmount;
      }
      
      private function refresh() : void
      {
         this.myBar.y = this._position * (this.myBg.height - this.myBar.height);
      }
      
      private function onBarClickHandle(cEvt:ParaEvent) : void
      {
         this._isDraging = true;
         this._movePressOffsetY = this.myBar.mouseY * this.myBar.scaleY;
         this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
         stage.addEventListener(MouseEvent.CLICK,this.onMouseUpHandle);
         clearInterval(this._dragInterval);
         this._dragInterval = setInterval(this.onMoveBarHandle,this._moveSpd);
      }
      
      private function onMouseUpHandle(cEvt:MouseEvent) : void
      {
         this._isDraging = false;
         this.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
         stage.removeEventListener(MouseEvent.CLICK,this.onMouseUpHandle);
         clearInterval(this._dragInterval);
         if(!this._moveBarBySelf)
         {
            this.refresh();
         }
      }
      
      private function onMoveBarHandle() : void
      {
         var tempTargetPos:Number = NaN;
         if(this.mouseY - this._movePressOffsetY < 0)
         {
            tempTargetPos = 0;
         }
         else if(this.mouseY - this._movePressOffsetY > this.myBg.height - this.myBar.height)
         {
            tempTargetPos = this.myBg.height - this.myBar.height;
         }
         else
         {
            tempTargetPos = this.mouseY - this._movePressOffsetY;
         }
         if(this._targetPos != tempTargetPos / (this.myBg.height - this.myBar.height))
         {
            this._targetPos = tempTargetPos / (this.myBg.height - this.myBar.height);
            if(this._moveBarBySelf == true)
            {
               this.myBar.y = tempTargetPos;
            }
            this.dispatchEvent(new Event(Event.SCROLL));
         }
      }
      
      public function get moveBarBySelf() : Boolean
      {
         return this._moveBarBySelf;
      }
      
      public function set moveBarBySelf(cSwi:Boolean) : void
      {
         this._moveBarBySelf = cSwi;
      }
   }
}

