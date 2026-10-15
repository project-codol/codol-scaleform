package codo.matchresult.wargod
{
   import codo.views.wargod_parts.TierMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol742")]
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

