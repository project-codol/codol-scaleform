package codo.wargod
{
   import codo.views.wargod_parts.TierMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2085")]
   public dynamic class tierMask extends TierMeter
   {
      
      public function tierMask()
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

