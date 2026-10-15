package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   
   public class CharacterSwitchModuleArrow extends UIInteractiveComponent
   {
      
      private static const FOCUS_FRAME:int = 2;
      
      private static const UNFOCUS_FRAME:int = 1;
      
      public function CharacterSwitchModuleArrow()
      {
         super();
         isInteractiveEnabled = true;
         gotoAndStop(UNFOCUS_FRAME);
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
      
      override public function set enabled(val:Boolean) : void
      {
         super.enabled = val;
      }
   }
}

