package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.errors.IllegalOperationError;
   
   public class ScrollBar extends MovieClip implements IDisposable
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 1;
      
      public var myScrollBar:MovieClip;
      
      public var myScrollButton:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_scrollBehaviour:BehaviourScrollBar;
      
      private var m_enabled:Boolean;
      
      public function ScrollBar()
      {
         super();
         this.m_clickable = new BehaviourClickable(this.myScrollButton,true);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,OVER_STATE_FRAME);
         var barLength:Number = 0;
         var orientation:uint = this.getOrientation();
         if(orientation == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            barLength = this.myScrollBar.width;
         }
         else
         {
            barLength = this.myScrollBar.height;
         }
         this.m_scrollBehaviour = new BehaviourScrollBar(this.m_clickable,this.myScrollButton,barLength,orientation);
         this.setVisible(visible);
      }
      
      public function dispose() : void
      {
         this.m_clickable.dispose();
         this.m_animated.dispose();
         this.m_scrollBehaviour.dispose();
      }
      
      public function get barLength() : Number
      {
         return this.m_scrollBehaviour.barLength;
      }
      
      public function set barLength(length:Number) : void
      {
         if(this.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            this.myScrollBar.width = length;
         }
         else
         {
            this.myScrollBar.height = length;
         }
         this.m_scrollBehaviour.barLength = length;
      }
      
      public function set barLengthNoPositionChange(length:Number) : void
      {
         if(this.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            this.myScrollBar.width = length;
         }
         else
         {
            this.myScrollBar.height = length;
         }
         this.m_scrollBehaviour.barLengthNoPositionChange = length;
      }
      
      public function get relativeSliderSize() : Number
      {
         return this.m_scrollBehaviour.relativeSliderSize;
      }
      
      public function set relativeSliderSize(size:Number) : void
      {
         this.m_scrollBehaviour.relativeSliderSize = size;
      }
      
      public function set scrollSpeed(speed:Number) : void
      {
         this.m_scrollBehaviour.scrollSpeed = speed;
      }
      
      public function get scrollSpeed() : Number
      {
         return this.m_scrollBehaviour.scrollSpeed;
      }
      
      public function getPosition() : Number
      {
         return this.m_scrollBehaviour.getPosition();
      }
      
      public function setPosition(position:Number) : void
      {
         this.m_scrollBehaviour.setPosition(position);
      }
      
      public function setNoCBPosition(position:Number) : void
      {
         this.m_scrollBehaviour.setNoCBPosition(position);
      }
      
      public function setMouseWheelListener(listener:DisplayObject) : void
      {
         this.m_scrollBehaviour.setMouseWheelListener(listener);
      }
      
      public function setScrollCallback(callback:Function) : void
      {
         this.m_scrollBehaviour.setScrollCallback(callback);
      }
      
      public function setVisible(value:Boolean) : void
      {
         visible = value;
         this.m_enabled = value;
         this.m_scrollBehaviour.setEnabled(this.m_enabled);
      }
      
      public function getOrientation() : uint
      {
         throw IllegalOperationError("ScrollBar is intended to be used as an abstract class. Use one of the concrete implementations.");
      }
      
      public function setScrollRatio(ratio:Number) : void
      {
         this.m_scrollBehaviour.setScrollRatio(ratio);
      }
      
      public function setScrollOffset(offset:int) : void
      {
         this.m_scrollBehaviour.setScrollOffset(offset);
      }
      
      public function set position(cPos:Number) : void
      {
         this.m_scrollBehaviour.setPosition(cPos);
      }
      
      public function get position() : Number
      {
         return this.m_scrollBehaviour.getPosition();
      }
      
      public function setEnabled(value:Boolean) : void
      {
         this.m_scrollBehaviour.setEnabled(value);
      }
   }
}

