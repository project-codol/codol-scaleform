package codo.component.matchselect
{
   import codo.component.core.UIInteractiveComponent;
   
   public class MatchSelectModeScrollNavButton extends UIInteractiveComponent
   {
      
      public function MatchSelectModeScrollNavButton()
      {
         super();
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         gotoAndStop(1);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         play();
      }
   }
}

