package codo.scoreboard.wargod
{
   import codo.views.wargod_parts.TierMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2038")]
   public dynamic class smallTierMeter extends TierMeter
   {
      
      public function smallTierMeter()
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

