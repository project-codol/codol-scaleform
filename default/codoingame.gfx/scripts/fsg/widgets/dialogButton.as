package fsg.widgets
{
   import fsg.shared.DialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1845")]
   public dynamic class dialogButton extends DialogButton
   {
      
      public function dialogButton()
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

