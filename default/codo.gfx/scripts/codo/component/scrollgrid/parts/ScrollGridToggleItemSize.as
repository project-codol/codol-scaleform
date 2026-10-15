package codo.component.scrollgrid.parts
{
   import codo.component.core.UIInteractiveComponent;
   import flash.display.MovieClip;
   
   public class ScrollGridToggleItemSize extends UIInteractiveComponent
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      public var myBackground:MovieClip;
      
      public var myArt:MovieClip;
      
      public function ScrollGridToggleItemSize()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override public function set enabled(isEnabled:Boolean) : void
      {
         super.enabled = isEnabled;
         this.myArt.alpha = isEnabled == true ? 1 : 0.18;
         if(false == isEnabled)
         {
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      override protected function onMouseOver() : void
      {
         this.myBackground.gotoAndStop(OVER_STATE_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         this.myBackground.gotoAndStop(UP_STATE_FRAME);
      }
   }
}

