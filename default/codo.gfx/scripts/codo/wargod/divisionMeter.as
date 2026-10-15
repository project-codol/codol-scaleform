package codo.wargod
{
   import codo.views.wargod_parts.DivisionMeter;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol81")]
   public dynamic class divisionMeter extends DivisionMeter
   {
      
      public function divisionMeter()
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

