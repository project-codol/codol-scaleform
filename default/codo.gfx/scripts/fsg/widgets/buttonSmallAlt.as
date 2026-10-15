package fsg.widgets
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1065")]
   public dynamic class buttonSmallAlt extends BarDialogButton
   {
      
      public function buttonSmallAlt()
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

