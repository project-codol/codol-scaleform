package codo.component.scrollgrid.parts
{
   import codo.component.core.UIInteractiveComponent;
   
   public class ScrollListNavArrow extends UIInteractiveComponent
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      public function ScrollListNavArrow()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      public function setOrientRight() : void
      {
         scaleX = -1;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         gotoAndStop(OVER_STATE_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         gotoAndStop(UP_STATE_FRAME);
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         gotoAndStop(DOWN_STATE_FRAME);
      }
      
      override protected function onMouseClickUp() : void
      {
         gotoAndStop(OVER_STATE_FRAME);
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         if(!enabled)
         {
            this.onMouseOut();
         }
         alpha = enabled ? 1 : 0.5;
      }
   }
}

