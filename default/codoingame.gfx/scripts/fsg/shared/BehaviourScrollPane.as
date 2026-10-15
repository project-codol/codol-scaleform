package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class BehaviourScrollPane implements IDisposable
   {
      
      private var m_scrollBar:ScrollBar;
      
      private var m_mask:MovieClip;
      
      private var m_scrollItem:MovieClip;
      
      private var m_bAutoVisibility:Boolean;
      
      private var m_uPadding:uint;
      
      private var m_callback:Function;
      
      private var m_paneScrollSpeed:Number = 50;
      
      public function BehaviourScrollPane(scrollBar:ScrollBar, mask:MovieClip, scrollItem:MovieClip, wheelHitArea:DisplayObject, autoVisibility:Boolean = true, padding:uint = 0)
      {
         super();
         this.m_scrollBar = scrollBar;
         this.m_mask = mask;
         this.m_scrollItem = scrollItem;
         this.m_bAutoVisibility = autoVisibility;
         this.m_uPadding = padding;
         if(this.m_scrollBar.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            this.m_scrollBar.scaleX = 1;
         }
         else
         {
            this.m_scrollBar.scaleY = 1;
         }
         this.m_scrollBar.setMouseWheelListener(wheelHitArea);
         this.m_scrollBar.setScrollCallback(this.onScroll);
         this.refreshScrollBar();
      }
      
      public function dispose() : void
      {
         this.m_scrollBar.setMouseWheelListener(null);
         this.m_scrollBar.setScrollCallback(null);
         this.m_scrollBar = null;
         this.m_mask = null;
         this.m_scrollItem = null;
         this.m_callback = null;
      }
      
      public function setScrollCallback(callback:Function) : void
      {
         this.m_callback = callback;
      }
      
      public function refreshScrollBar() : void
      {
         var scrollItemLength:Number = 0;
         var maskLength:Number = 0;
         var maxScroll:Number = 0;
         if(this.m_scrollBar.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            scrollItemLength = this.m_scrollItem.width + this.m_uPadding;
            maskLength = this.m_mask.width;
            this.m_scrollBar.barLength = maskLength;
            maxScroll = Math.max(scrollItemLength - this.m_mask.width,0);
            this.m_scrollBar.relativeSliderSize = Math.min(maskLength / scrollItemLength,1);
            this.m_scrollBar.scrollSpeed = this.m_paneScrollSpeed / maxScroll;
         }
         else
         {
            scrollItemLength = this.m_scrollItem.height + this.m_uPadding;
            maskLength = this.m_mask.height;
            this.m_scrollBar.barLength = maskLength;
            maxScroll = Math.max(scrollItemLength - this.m_mask.height,0);
            this.m_scrollBar.relativeSliderSize = Math.min(maskLength / scrollItemLength,1);
            this.m_scrollBar.scrollSpeed = this.m_paneScrollSpeed / maxScroll;
         }
         var setVisible:Boolean = false;
         if(scrollItemLength > maskLength)
         {
            setVisible = true;
         }
         if(this.m_bAutoVisibility)
         {
            this.m_scrollBar.setVisible(setVisible);
         }
         this.onScroll();
      }
      
      public function updateScrollBar() : void
      {
         var scrollItemLength:Number = 0;
         var maskLength:Number = 0;
         var maxScroll:Number = 0;
         if(this.m_scrollBar.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            scrollItemLength = this.m_scrollItem.width + this.m_uPadding;
            maskLength = this.m_mask.width;
            this.m_scrollBar.barLengthNoPositionChange = maskLength;
            maxScroll = Math.max(scrollItemLength - this.m_mask.width,0);
            this.m_scrollBar.relativeSliderSize = Math.min(maskLength / scrollItemLength,1);
            this.m_scrollBar.scrollSpeed = this.m_paneScrollSpeed / maxScroll;
         }
         else
         {
            scrollItemLength = this.m_scrollItem.height + this.m_uPadding;
            maskLength = this.m_mask.height;
            this.m_scrollBar.barLengthNoPositionChange = maskLength;
            maxScroll = Math.max(scrollItemLength - this.m_mask.height,0);
            this.m_scrollBar.relativeSliderSize = Math.min(maskLength / scrollItemLength,1);
            this.m_scrollBar.scrollSpeed = this.m_paneScrollSpeed / maxScroll;
         }
         var setVisible:Boolean = false;
         if(scrollItemLength > maskLength)
         {
            setVisible = true;
         }
         if(this.m_bAutoVisibility)
         {
            this.m_scrollBar.setVisible(setVisible);
         }
         var pos:Number = 0;
         var scrollPos:Number = 0;
         if(this.m_scrollBar.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            maxScroll = Math.max(this.m_scrollItem.width + this.m_uPadding - this.m_mask.width,0);
            pos = this.m_scrollBar.x - this.m_mask.x;
            scrollPos = pos / -maxScroll;
         }
         else
         {
            maxScroll = Math.max(this.m_scrollItem.height + this.m_uPadding - this.m_mask.height,0);
            pos = this.m_scrollItem.y - this.m_mask.y;
            scrollPos = pos / -maxScroll;
         }
         this.m_scrollBar.setNoCBPosition(scrollPos);
      }
      
      private function onScroll() : void
      {
         var maxScroll:Number = 0;
         var pos:Number = 0;
         var previousLoc:Point = new Point(this.m_scrollItem.x,this.m_scrollItem.y);
         if(this.m_scrollBar.getOrientation() == BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL)
         {
            maxScroll = Math.max(this.m_scrollItem.width + this.m_uPadding - this.m_mask.width,0);
            pos = -this.m_scrollBar.getPosition() * maxScroll;
            this.m_scrollItem.x = pos + this.m_mask.x;
         }
         else
         {
            maxScroll = Math.max(this.m_scrollItem.height + this.m_uPadding - this.m_mask.height,0);
            pos = -this.m_scrollBar.getPosition() * maxScroll;
            this.m_scrollItem.y = pos + this.m_mask.y;
         }
         if(this.m_callback != null && (previousLoc.x != this.m_scrollItem.x || previousLoc.y != this.m_scrollItem.y))
         {
            this.m_callback();
         }
      }
      
      public function setScrollRatio(ratio:Number) : void
      {
         this.m_scrollBar.setScrollRatio(ratio);
      }
      
      public function setScrollOffset(offset:int) : void
      {
         this.m_scrollBar.setScrollOffset(offset);
      }
      
      public function set position(cPos:Number) : void
      {
         this.m_scrollBar.position = cPos;
      }
      
      public function get position() : Number
      {
         return this.m_scrollBar.position;
      }
   }
}

