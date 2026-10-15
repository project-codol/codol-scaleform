package codo.component.social
{
   import codo.component.core.UIInteractiveComponent;
   
   public class DeleteButton extends UIInteractiveComponent
   {
      
      private static const UNFOCUS_FRAME:int = 1;
      
      private static const FOCUS_FRAME:int = 2;
      
      public function DeleteButton()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         gotoAndStop(FOCUS_FRAME);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         gotoAndStop(UNFOCUS_FRAME);
      }
   }
}

