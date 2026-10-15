package components
{
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shaui.component.core.InteractiveComponent;
   
   public class ScrollBar2 extends InteractiveComponent
   {
      
      public static const STOP_SCROLL:String = "stopscroll";
      
      private static const TOP_MARGIN:Number = 0;
      
      private static const BOTTOM_MARGIN:Number = 0;
      
      private static const MIN_THUMBNAIL_SIZE:Number = 10;
      
      public var myBar:MovieClip;
      
      public var myBg:Sprite;
      
      private var _barFullSize:Number;
      
      private var _barStartPos:Number;
      
      private var _barEndPos:Number;
      
      private var _thumbSize:Number;
      
      private var _scrollRangeMin:Number;
      
      private var _scrollRangeMax:Number;
      
      private var _pos:Number = 0;
      
      private var _mouseYKeeper:Number;
      
      private var _tempPoint:Point = new Point();
      
      public function ScrollBar2()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         if(this.myBar is BaseButton)
         {
            (this.myBar as BaseButton).soundOff();
         }
         this._pos = 0;
      }
      
      override protected function updateMouseInteractivity(value:Boolean) : void
      {
         if(value)
         {
            this.myBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarClickHandle);
         }
         else
         {
            this.myBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarClickHandle);
         }
      }
      
      public function setScrollRange(minValue:Number, maxValue:Number) : void
      {
         this._scrollRangeMin = minValue;
         this._scrollRangeMax = maxValue;
      }
      
      private function refreshLayout() : void
      {
         this._barFullSize = this.myBg.height - TOP_MARGIN - BOTTOM_MARGIN;
         this._barStartPos = TOP_MARGIN;
         this._barEndPos = this._barFullSize + TOP_MARGIN - this._thumbSize;
      }
      
      override public function set height(value:Number) : void
      {
         this.myBg.height = value;
      }
      
      private function onBarClickHandle(cEvt:MouseEvent) : void
      {
         this._tempPoint.x = cEvt.stageX;
         this._tempPoint.y = cEvt.stageY;
         this._tempPoint = globalToLocal(this._tempPoint);
         this._mouseYKeeper = this._tempPoint.y;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
      }
      
      private function onStageMouseUpHandle(cEvt:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         dispatchEvent(new ParaEvent(STOP_SCROLL));
      }
      
      private function onStageMouseMoveHandle(cEvt:MouseEvent) : void
      {
         var scrollValue:Number = NaN;
         var nextPos:Number = NaN;
         this._tempPoint.x = cEvt.stageX;
         this._tempPoint.y = cEvt.stageY;
         this._tempPoint = globalToLocal(this._tempPoint);
         var offset:Number = this._tempPoint.y - this._mouseYKeeper;
         this._mouseYKeeper = this._tempPoint.y;
         if(this.myBar.y + offset > this._barEndPos)
         {
            offset = this._barEndPos - this.myBar.y;
            scrollValue = this._scrollRangeMax;
            nextPos = this._barEndPos;
         }
         else if(this.myBar.y + offset < this._barStartPos)
         {
            offset = this._barStartPos - this.myBar.y;
            scrollValue = this._scrollRangeMin;
            nextPos = this._barStartPos;
         }
         else
         {
            nextPos = this.myBar.y + offset;
            scrollValue = (nextPos - this._barStartPos) / (this._barEndPos - this._barStartPos) * (this._scrollRangeMax - this._scrollRangeMin) + this._scrollRangeMin;
         }
         dispatchEvent(new ParaEvent(Event.SCROLL,{
            "scrollValue":scrollValue,
            "pixelValue":nextPos
         }));
      }
      
      public function set offset(offset:Number) : void
      {
         this.myBar.y += offset;
      }
      
      public function set posInPixel(value:Number) : void
      {
         this.myBar.y = value;
      }
      
      public function set pos(value:Number) : void
      {
         var roughPercent:Number = (value - this._scrollRangeMin) / (this._scrollRangeMax - this._scrollRangeMin);
         this._pos = this._barStartPos + (this._barEndPos - this._barStartPos) * roughPercent;
         this.myBar.y = this._pos;
      }
      
      public function get pos() : Number
      {
         return this._pos;
      }
      
      public function get scrollRangeMin() : Number
      {
         return this._scrollRangeMin;
      }
      
      public function set scrollRangeMin(value:Number) : void
      {
         this._scrollRangeMin = value;
      }
      
      public function get scrollRangeMax() : Number
      {
         return this._scrollRangeMax;
      }
      
      public function set scrollRangeMax(value:Number) : void
      {
         this._scrollRangeMax = value;
      }
      
      public function get barStartPos() : Number
      {
         return this._barStartPos;
      }
      
      public function get barEndPos() : Number
      {
         return this._barEndPos;
      }
      
      private function get thumbSize() : Number
      {
         return this._thumbSize;
      }
      
      private function set thumbSize(value:Number) : void
      {
         this._thumbSize = value;
         this.myBar.height = value;
         this.refreshLayout();
      }
      
      public function set thumbSizeByPercent(value:Number) : void
      {
         var sizeCandidate:Number = this._barFullSize * value;
         if(sizeCandidate < MIN_THUMBNAIL_SIZE)
         {
            sizeCandidate = MIN_THUMBNAIL_SIZE;
         }
         this.thumbSize = sizeCandidate;
      }
   }
}

