package fsg.shared
{
   public class ScrollBarHorizontal extends ScrollBar
   {
      
      public function ScrollBarHorizontal()
      {
         super();
      }
      
      override public function getOrientation() : uint
      {
         return BehaviourScrollBar.SCROLL_DIRECTION_HORIZONTAL;
      }
   }
}

