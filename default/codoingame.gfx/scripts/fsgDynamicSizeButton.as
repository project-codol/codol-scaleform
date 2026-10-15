package
{
   import fsg.shared.DynamicSizeButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol275")]
   public dynamic class fsgDynamicSizeButton extends DynamicSizeButton
   {
      
      public function fsgDynamicSizeButton()
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

