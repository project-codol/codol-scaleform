package codo.component
{
   import codo.views.UITutorialBaseView;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgAudioUtil;
   
   public class ScrollBar extends MovieClip
   {
      
      private static const MOUSE_WHEEL_SCROLL_SPEED:Number = 180;
      
      private static const ANIM_SPEED:Number = 0.3;
      
      private static const FRAME_OUT:uint = 1;
      
      private static const FRAME_OVER:uint = 2;
      
      public var myScrollTrack:MovieClip;
      
      public var myScrollButton:MovieClip;
      
      private var mClickable:BehaviourClickable;
      
      private var mScrollBounds:Rectangle;
      
      private var mWheelHitArea:Sprite;
      
      private var mIsScrolling:Boolean;
      
      private var mScrollCallback:Function;
      
      protected var _scrollIncrement:Number = 0;
      
      public function ScrollBar()
      {
         super();
         this.mClickable = new BehaviourClickable(this.myScrollButton,true);
         this.mClickable.addMouseOverCallback(this.onButtonOver);
         this.mClickable.addMouseOutCallback(this.onButtonOut);
         this.mClickable.addMouseDownCallback(this.onButtonClicked);
         this.mClickable.addMouseUpCallback(this.onButtonReleased);
      }
      
      public function init(data:Object) : void
      {
         this.mScrollCallback = data.scrollCallback;
         this.mWheelHitArea = data.hitArea;
         this.myScrollButton.x = 0;
         this.updateScrollButton(this.myScrollTrack.width);
      }
      
      public function get position() : Number
      {
         return this.myScrollButton.x / (this.myScrollTrack.width - this.myScrollButton.width);
      }
      
      public function setPosition(percent:Number, animate:Boolean) : void
      {
         if(percent < 0)
         {
            percent = 0;
         }
         else if(percent > 1)
         {
            percent = 1;
         }
         var pos:Number = (this.myScrollTrack.width - this.myScrollButton.width) * percent;
         this.moveScrollButton(pos,animate);
      }
      
      public function setBarLength(barLen:Number, contentLen:Number) : void
      {
         this.myScrollTrack.width = barLen;
         this.updateScrollButton(contentLen);
      }
      
      override public function get width() : Number
      {
         return this.myScrollTrack.width;
      }
      
      override public function get height() : Number
      {
         return this.myScrollTrack.height;
      }
      
      public function getEnabled() : Boolean
      {
         return this.mClickable.isEnabled();
      }
      
      public function setEnabled(value:Boolean) : void
      {
         this.mClickable.setEnabled(value);
         if(value == true)
         {
            this.mWheelHitArea.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
         }
         else
         {
            this.mWheelHitArea.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
         }
      }
      
      private function updateScrollButton(contentLen:Number) : void
      {
         this.myScrollButton.width = this.myScrollTrack.width * (this.myScrollTrack.width / contentLen);
         this.mScrollBounds = new Rectangle(0,0,this.myScrollTrack.width - this.myScrollButton.width,0);
         var scrollableLen:Number = Math.max(1,contentLen - this.myScrollTrack.width);
         var buttonMoveLen:Number = Math.max(1,this.myScrollTrack.width - this.myScrollButton.width);
         this._scrollIncrement = buttonMoveLen * MOUSE_WHEEL_SCROLL_SPEED / scrollableLen;
      }
      
      private function handleMouseWheel(evt:MouseEvent) : void
      {
         if(UITutorialBaseView.isTutorialShowing())
         {
            return;
         }
         var newPos:Number = this.myScrollButton.x - evt.delta * this._scrollIncrement;
         var buttonMoveLen:Number = this.myScrollTrack.width - this.myScrollButton.width;
         if(newPos > buttonMoveLen)
         {
            newPos = buttonMoveLen;
         }
         else if(newPos < 0)
         {
            newPos = 0;
         }
         else
         {
            FsgAudioUtil.getInstance().playSound("ui_scrollbar_scroll");
         }
         this.moveScrollButton(newPos,true);
      }
      
      protected function moveScrollButton(newPos:Number, animate:Boolean) : void
      {
         if(animate)
         {
            TweenLite.to(this.myScrollButton,ANIM_SPEED,{
               "x":newPos,
               "onUpdate":this.onScrollAnimUpdate
            });
         }
         else
         {
            this.myScrollButton.x = newPos;
         }
      }
      
      protected function onScrollAnimUpdate() : void
      {
         var pos:Number = NaN;
         if(null != this.mScrollCallback)
         {
            pos = this.myScrollButton.x / (this.myScrollTrack.width - this.myScrollButton.width);
            this.mScrollCallback(pos);
         }
      }
      
      private function onButtonOver() : void
      {
         this.myScrollButton.gotoAndStop(FRAME_OVER);
      }
      
      private function onButtonOut() : void
      {
         if(!this.mIsScrolling)
         {
            this.myScrollButton.gotoAndStop(FRAME_OUT);
         }
      }
      
      private function onButtonClicked() : void
      {
         this.onButtonOver();
         this.myScrollButton.startDrag(false,this.mScrollBounds);
         this.mIsScrolling = true;
         this.myScrollButton.addEventListener(Event.ENTER_FRAME,this.onButtonDragging);
      }
      
      private function onButtonDragging(e:Event) : void
      {
         if(null != this.mScrollCallback)
         {
            this.mScrollCallback(this.position);
         }
      }
      
      private function onButtonReleased() : void
      {
         this.myScrollButton.stopDrag();
         this.mIsScrolling = false;
         this.onButtonOut();
         this.myScrollButton.removeEventListener(Event.ENTER_FRAME,this.onButtonDragging);
         if(null != this.mScrollCallback)
         {
            this.mScrollCallback(this.position);
         }
      }
   }
}

