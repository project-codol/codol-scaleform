package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   
   public class CloseButton extends UIInteractiveComponent
   {
      
      private static const UNFOCUS_FRAME:int = 1;
      
      private static const FOCUS_FRAME:int = 2;
      
      public function CloseButton()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override protected function onMouseOver() : void
      {
         gotoAndStop(FOCUS_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         gotoAndStop(UNFOCUS_FRAME);
      }
   }
}

