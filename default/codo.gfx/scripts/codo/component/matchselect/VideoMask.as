package codo.component.matchselect
{
   import codo.component.core.UIInteractiveComponent;
   import flash.display.MovieClip;
   
   public class VideoMask extends UIInteractiveComponent
   {
      
      public var myPlayButton:MovieClip;
      
      public function VideoMask()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myPlayButton.gotoAndStop(2);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myPlayButton.gotoAndStop(1);
      }
   }
}

