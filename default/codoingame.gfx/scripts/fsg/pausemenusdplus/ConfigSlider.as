package fsg.pausemenusdplus
{
   import fsg.shared.ConfigSlider;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3507")]
   public dynamic class ConfigSlider extends fsg.shared.ConfigSlider
   {
      
      public function ConfigSlider()
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

