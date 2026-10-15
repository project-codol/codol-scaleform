package fsg.widgets
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2355")]
   public dynamic class SmallButtonHighlight extends BarDialogButton
   {
      
      public function SmallButtonHighlight()
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

