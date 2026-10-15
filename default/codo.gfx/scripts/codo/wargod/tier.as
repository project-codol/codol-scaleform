package codo.wargod
{
   import codo.views.wargod_parts.TierMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol938")]
   public dynamic class tier extends TierMeter
   {
      
      public function tier()
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

