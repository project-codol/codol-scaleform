package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import fsg.util.FsgAudioUtil;
   
   public class BehaviourScrollBar implements IDisposable
   {
      
      public static const SCROLL_DIRECTION_VERTICAL:uint = 1;
      
      public static const SCROLL_DIRECTION_HORIZONTAL:uint = 2;
      
      private var m_slider:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_barLength:Number;
      
      private var m_scrollCallback:Function;
      
      private var m_scrollLimitReached:Boolean;
      
      private var m_mouseWheelListener:DisplayObject;
      
      private var m_enabled:Boolean;
      
      private var m_orientation:uint;
      
      private var m_scrollSpeed:Number = 5;
      
      private var m_tempDragRect:Rectangle;
      
      private var m_mouseDragging:Boolean = false;
      
      public function BehaviourScrollBar(clickable:BehaviourClickable, slider:MovieClip, barLength:Number, orientation:uint)
      {
         super();
         this.m_slider = slider;
         this.m_clickable = clickable;
         this.m_barLength = barLength;
         this.m_orientation = orientation;
         this.m_enabled = false;
         this.m_scrollLimitReached = true;
         this.setEnabled(true);
      }
      
      public function dispose() : void
      {
         this.m_clickable.removeMouseDownCallback(this.onStartDrag);
         this.m_clickable.removeMouseUpCallback(this.onStopDrag);
         if(this.m_mouseWheelListener != null)
         {
            this.m_mouseWheelListener.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         this.m_clickable = null;
         this.m_slider = null;
      }
      
      public function get barLength() : Number
      {
         return this.m_barLength;
      }
      
      public function set barLength(length:Number) : void
      {
         var oldScrollSpeed:Number = this.scrollSpeed;
         var oldRelativeSliderSize:Number = this.relativeSliderSize;
         var oldPosition:Number = this.getPosition();
         this.m_barLength = length;
         this.scrollSpeed = oldScrollSpeed;
         this.relativeSliderSize = oldRelativeSliderSize;
         this.setPosition(oldPosition);
      }
      
      public function set barLengthNoPositionChange(length:Number) : void
      {
         var oldScrollSpeed:Number = this.scrollSpeed;
         var oldRelativeSliderSize:Number = this.relativeSliderSize;
         this.m_barLength = length;
         this.scrollSpeed = oldScrollSpeed;
         this.relativeSliderSize = oldRelativeSliderSize;
      }
      
      public function set scrollSpeed(speed:Number) : void
      {
         var sliderLength:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
         }
         else
         {
            sliderLength = this.m_slider.height;
         }
         var scrollableLength:Number = this.m_barLength - sliderLength;
         this.m_scrollSpeed = speed * scrollableLength;
      }
      
      public function get scrollSpeed() : Number
      {
         var sliderLength:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
         }
         else
         {
            sliderLength = this.m_slider.height;
         }
         var scrollableLength:Number = this.m_barLength - sliderLength;
         return this.m_scrollSpeed / scrollableLength;
      }
      
      public function get relativeSliderSize() : Number
      {
         var sliderLength:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
         }
         else
         {
            sliderLength = this.m_slider.height;
         }
         return sliderLength / this.m_barLength;
      }
      
      public function set relativeSliderSize(size:Number) : void
      {
         var sliderLength:Number = size * this.m_barLength;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            this.m_slider.width = sliderLength;
         }
         else
         {
            this.m_slider.height = sliderLength;
         }
      }
      
      public function getPosition() : Number
      {
         var sliderLength:Number = 0;
         var sliderPos:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
            sliderPos = this.m_slider.x;
         }
         else
         {
            sliderLength = this.m_slider.height;
            sliderPos = this.m_slider.y;
         }
         var scrollableLength:Number = this.m_barLength - sliderLength;
         var position:Number = Math.min(sliderPos / scrollableLength,1);
         if(isNaN(position))
         {
            position = 0;
         }
         return position;
      }
      
      public function setPosition(position:Number) : void
      {
         var sliderLength:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
         }
         else
         {
            sliderLength = this.m_slider.height;
         }
         var scrollableLength:Number = this.m_barLength - sliderLength;
         var newSliderPos:Number = Math.min(position * scrollableLength,scrollableLength);
         newSliderPos = Math.max(newSliderPos,0);
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
            this.m_slider.x = newSliderPos;
         }
         else
         {
            sliderLength = this.m_slider.height;
            this.m_slider.y = newSliderPos;
         }
         if(this.m_scrollCallback != null)
         {
            this.m_scrollCallback();
         }
      }
      
      public function setNoCBPosition(position:Number) : void
      {
         var sliderLength:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
         }
         else
         {
            sliderLength = this.m_slider.height;
         }
         var scrollableLength:Number = this.m_barLength - sliderLength;
         var newSliderPos:Number = Math.min(position * scrollableLength,scrollableLength);
         newSliderPos = Math.max(newSliderPos,0);
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderLength = this.m_slider.width;
            this.m_slider.x = newSliderPos;
         }
         else
         {
            sliderLength = this.m_slider.height;
            this.m_slider.y = newSliderPos;
         }
      }
      
      public function setScrollCallback(callback:Function) : void
      {
         this.m_scrollCallback = callback;
      }
      
      public function setMouseWheelListener(listener:DisplayObject) : void
      {
         if(this.m_mouseWheelListener != null)
         {
            this.m_mouseWheelListener.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         }
         this.m_mouseWheelListener = listener;
         if(this.m_mouseWheelListener != null)
         {
            this.m_mouseWheelListener.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
         }
      }
      
      public function setEnabled(value:Boolean) : void
      {
         if(value != this.m_enabled)
         {
            if(value)
            {
               if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
               {
                  this.m_slider.x = 0;
               }
               else
               {
                  this.m_slider.y = 0;
               }
               this.m_clickable.addMouseDownCallback(this.onStartDrag);
               this.m_clickable.addMouseUpCallback(this.onStopDrag);
               if(this.m_mouseWheelListener != null)
               {
                  this.m_mouseWheelListener.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
               }
            }
            else
            {
               this.m_clickable.removeMouseDownCallback(this.onStartDrag);
               this.m_clickable.removeMouseUpCallback(this.onStopDrag);
               if(this.m_mouseWheelListener != null)
               {
                  this.m_mouseWheelListener.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
               }
               this.onStopDrag();
            }
            this.m_enabled = value;
         }
      }
      
      private function onMouseWheel(e:MouseEvent) : void
      {
         var sliderPos:Number = 0;
         var sliderLength:Number = 0;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            sliderPos = this.m_slider.x;
            sliderLength = this.m_slider.width;
         }
         else
         {
            sliderPos = this.m_slider.y;
            sliderLength = this.m_slider.height;
         }
         var newPos:Number = sliderPos - e.delta * this.m_scrollSpeed;
         if(newPos > this.m_barLength - sliderLength)
         {
            newPos = this.m_barLength - sliderLength;
         }
         else if(newPos < 0)
         {
            newPos = 0;
         }
         else
         {
            FsgAudioUtil.getInstance().playSound("ui_scrollbar_scroll");
         }
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            this.m_slider.x = newPos;
         }
         else
         {
            this.m_slider.y = newPos;
         }
         this.updateScroll(null);
      }
      
      private function onStartDrag() : void
      {
         var dragRect:Rectangle = this.getDragRect();
         this.m_tempDragRect = dragRect;
         this.m_mouseDragging = true;
         this.m_slider.startDrag(false,dragRect);
         this.m_slider.addEventListener(Event.ENTER_FRAME,this.updateScroll,false,0,true);
         FsgAudioUtil.getInstance().playSound("ui_scrollbar_scroll");
         this.m_scrollLimitReached = true;
      }
      
      private function onStopDrag() : void
      {
         this.m_slider.removeEventListener(Event.ENTER_FRAME,this.updateScroll);
         this.m_slider.stopDrag();
         this.m_mouseDragging = false;
      }
      
      private function updateScroll(evt:Event) : void
      {
         var dragLimit:Number = NaN;
         var dragPosition:Number = NaN;
         var dragRect:Rectangle = this.getDragRect();
         if(this.m_tempDragRect != null && this.m_mouseDragging)
         {
            if(this.m_tempDragRect.x != dragRect.x || this.m_tempDragRect.y != dragRect.y || this.m_tempDragRect.width != dragRect.width || this.m_tempDragRect.height != dragRect.height)
            {
               this.m_slider.stopDrag();
               this.m_slider.startDrag(false,dragRect);
               this.m_tempDragRect = dragRect;
            }
         }
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            dragLimit = dragRect.width;
            dragPosition = this.m_slider.x;
         }
         else
         {
            dragLimit = dragRect.height;
            dragPosition = this.m_slider.y;
         }
         if(dragPosition == 0 || dragPosition == dragLimit)
         {
            if(this.m_scrollLimitReached == false)
            {
               this.m_scrollLimitReached = true;
            }
         }
         else
         {
            this.m_scrollLimitReached = false;
         }
         if(this.m_scrollCallback != null)
         {
            this.m_scrollCallback();
         }
      }
      
      private function getDragRect() : Rectangle
      {
         var dragRect:Rectangle = null;
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            dragRect = new Rectangle(0,this.m_slider.y,this.m_barLength - this.m_slider.width,0);
         }
         else
         {
            dragRect = new Rectangle(this.m_slider.x,0,0,this.m_barLength - this.m_slider.height);
         }
         return dragRect;
      }
      
      public function setScrollRatio(ratio:Number) : void
      {
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            this.m_slider.x = (this.m_barLength - this.m_slider.width) * ratio;
         }
         else
         {
            this.m_slider.y = (this.m_barLength - this.m_slider.height) * ratio;
         }
         this.updateScroll(null);
      }
      
      public function setScrollOffset(offset:int) : void
      {
         if(this.m_orientation == SCROLL_DIRECTION_HORIZONTAL)
         {
            this.m_slider.x += offset;
            this.m_slider.x = Math.max(Math.min(this.m_slider.x,this.m_barLength - this.m_slider.width),0);
         }
         else
         {
            this.m_slider.y += offset;
            this.m_slider.y = Math.max(Math.min(this.m_slider.y,this.m_barLength - this.m_slider.height),0);
         }
         this.updateScroll(null);
      }
   }
}

