package fsg.widgets
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol358")]
   public dynamic class fsgButtonLargeAlt extends BarDialogButton
   {
      
      public function fsgButtonLargeAlt()
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

