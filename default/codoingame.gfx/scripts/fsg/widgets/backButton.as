package fsg.widgets
{
   import fsg.shared.DialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1989")]
   public dynamic class backButton extends DialogButton
   {
      
      public function backButton()
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

