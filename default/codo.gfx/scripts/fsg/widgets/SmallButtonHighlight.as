package fsg.widgets
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2693")]
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

