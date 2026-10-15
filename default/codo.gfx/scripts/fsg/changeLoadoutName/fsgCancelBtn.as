package fsg.changeLoadoutName
{
   import fsg.shared.BarDialogButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3725")]
   public dynamic class fsgCancelBtn extends BarDialogButton
   {
      
      public function fsgCancelBtn()
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

