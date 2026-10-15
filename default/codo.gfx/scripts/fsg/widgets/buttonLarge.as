package fsg.widgets
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2462")]
   public dynamic class buttonLarge extends BarDialogButton
   {
      
      public function buttonLarge()
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

