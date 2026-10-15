package codo.component.social
{
   import codo.component.core.UIInteractiveComponent;
   
   public class ArrowButton extends UIInteractiveComponent
   {
      
      private static const NORMAL_FRAME:int = 1;
      
      private static const DISABLE_FRAME:int = 2;
      
      public function ArrowButton()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         gotoAndStop(enabled ? NORMAL_FRAME : DISABLE_FRAME);
      }
   }
}

