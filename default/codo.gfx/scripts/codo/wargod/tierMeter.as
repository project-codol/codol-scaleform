package codo.wargod
{
   import codo.views.wargod_parts.TierMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2749")]
   public dynamic class tierMeter extends TierMeter
   {
      
      public function tierMeter()
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

