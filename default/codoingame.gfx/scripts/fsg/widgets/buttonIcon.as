package fsg.widgets
{
   import fsg.shared.BarIconButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol961")]
   public dynamic class buttonIcon extends BarIconButton
   {
      
      public function buttonIcon()
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

