package codo.wargod
{
   import codo.views.wargod_parts.HeroicValueMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2685")]
   public dynamic class heroicValueMeter extends HeroicValueMeter
   {
      
      public function heroicValueMeter()
      {
         super();
         addFrameScript(14,this.frame15);
      }
      
      internal function frame15() : *
      {
         stop();
      }
   }
}

