package fsg.shared
{
   import flash.display.MovieClip;
   
   public class ScrollPane extends MovieClip
   {
      
      public var myScrollBar:ScrollBar;
      
      public var myMask:MovieClip;
      
      public var myScrollItem:MovieClip;
      
      protected var m_scrollPaneBehaviour:BehaviourScrollPane;
      
      public function ScrollPane()
      {
         super();
         this.m_scrollPaneBehaviour = new BehaviourScrollPane(this.myScrollBar,this.myMask,this.myScrollItem,this);
      }
      
      public function refreshScrollBar() : void
      {
         this.m_scrollPaneBehaviour.refreshScrollBar();
      }
      
      public function setScrollRatio(ratio:Number) : void
      {
         this.m_scrollPaneBehaviour.setScrollRatio(ratio);
      }
   }
}

