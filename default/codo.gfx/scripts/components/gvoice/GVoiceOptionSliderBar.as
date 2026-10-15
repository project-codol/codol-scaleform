package components.gvoice
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class GVoiceOptionSliderBar extends MovieClip
   {
      
      public var myHitArea:MovieClip;
      
      public var myDragButton:GVoiceOptionSliderBarDragButton;
      
      public var myFill:MovieClip;
      
      public var myBg:MovieClip;
      
      private var mProgress:Number = 0;
      
      private var mDrag:Boolean = false;
      
      private var mParent:MovieClip;
      
      private var mProgressChangedCallback:Function;
      
      public function GVoiceOptionSliderBar()
      {
         super();
         this.progress = 0;
      }
      
      public function setProgressChangedCallback(callback:Function) : void
      {
         this.mProgressChangedCallback = callback;
      }
      
      public function registerMouseEvents() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandler);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         stage.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         stage.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
      }
      
      public function unregisterMouseEvents() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandler);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         stage.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandler);
         stage.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandler);
      }
      
      protected function onMouseDownHandler(e:MouseEvent) : void
      {
         var location:Point = this.myHitArea.globalToLocal(new Point(e.stageX,e.stageY));
         if(location.x < 0)
         {
            return;
         }
         if(location.y < 0)
         {
            return;
         }
         if(location.x > this.myHitArea.width)
         {
            return;
         }
         if(location.y > this.myHitArea.height)
         {
            return;
         }
         this.progress = location.x / this.myHitArea.width;
         this.mDrag = true;
         this.updateDragButtonAnimation(e);
      }
      
      protected function onMouseUpHandler(e:MouseEvent) : void
      {
         if(this.mDrag)
         {
            this.mDrag = false;
            if(this.mProgressChangedCallback != null)
            {
               this.mProgressChangedCallback(this.progress);
            }
         }
         this.updateDragButtonAnimation(e);
      }
      
      protected function onMouseMoveHandler(e:MouseEvent) : void
      {
         var location:Point = null;
         var x:Number = NaN;
         this.updateDragButtonAnimation(e);
         var pointToStage:Point = new Point(e.stageX,e.stageY);
         if(this.mDrag)
         {
            location = this.myHitArea.globalToLocal(pointToStage);
            x = location.x;
            if(x < 0)
            {
               x = 0;
            }
            if(x > this.myHitArea.width)
            {
               x = this.myHitArea.width;
            }
            this.progress = x / this.myHitArea.width;
         }
      }
      
      protected function onMouseOverHandler(e:MouseEvent) : void
      {
         this.updateDragButtonAnimation(e);
      }
      
      protected function onMouseOutHandler(e:MouseEvent) : void
      {
         this.updateDragButtonAnimation(e);
      }
      
      private function updateDragButtonAnimation(e:MouseEvent) : void
      {
         var pointToStage:Point = null;
         var pointToDragButton:Point = null;
         if(this.mDrag)
         {
            this.myDragButton.gotoAndStop(2);
         }
         else
         {
            pointToStage = new Point(e.stageX,e.stageY);
            pointToDragButton = this.myDragButton.globalToLocal(pointToStage);
            if(pointToDragButton.x > 0 && pointToDragButton.x < this.myDragButton.width && pointToDragButton.y > 0 && pointToDragButton.y < this.myDragButton.height)
            {
               this.myDragButton.gotoAndStop(2);
            }
            else
            {
               this.myDragButton.gotoAndStop(1);
            }
         }
      }
      
      public function set progress(progress:Number) : void
      {
         this.mProgress = progress;
         this.myDragButton.x = this.mProgress * this.myHitArea.width;
         this.myFill.width = this.mProgress * this.myHitArea.width;
      }
      
      public function get progress() : Number
      {
         return this.mProgress;
      }
   }
}

