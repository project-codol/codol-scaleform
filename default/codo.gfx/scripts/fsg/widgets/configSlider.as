package fsg.widgets
{
   import fsg.shared.ConfigSlider;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1747")]
   public dynamic class configSlider extends ConfigSlider
   {
      
      public function configSlider()
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

