package fsg.shared
{
   public class ScrollBarVertical extends ScrollBar
   {
      
      public function ScrollBarVertical()
      {
         super();
      }
      
      override public function getOrientation() : uint
      {
         return BehaviourScrollBar.SCROLL_DIRECTION_VERTICAL;
      }
   }
}

