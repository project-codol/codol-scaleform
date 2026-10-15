package fsg.widgets
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2134")]
   public dynamic class popupDialogButton extends BarDialogButton
   {
      
      public function popupDialogButton()
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

