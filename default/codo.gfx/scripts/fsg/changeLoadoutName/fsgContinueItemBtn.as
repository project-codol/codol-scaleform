package fsg.changeLoadoutName
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3728")]
   public dynamic class fsgContinueItemBtn extends BarDialogButton
   {
      
      public function fsgContinueItemBtn()
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

