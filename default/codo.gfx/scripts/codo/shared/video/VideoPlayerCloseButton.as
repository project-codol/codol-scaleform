package codo.shared.video
{
   import codo.component.CloseButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2594")]
   public dynamic class VideoPlayerCloseButton extends CloseButton
   {
      
      public function VideoPlayerCloseButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

