package fsg.widgets
{
   import fsg.shared.CloseButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol810")]
   public dynamic class closeButton extends CloseButton
   {
      
      public function closeButton()
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

