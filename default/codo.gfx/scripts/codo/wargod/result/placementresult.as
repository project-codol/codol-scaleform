package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.PlacementResult;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3224")]
   public dynamic class placementresult extends PlacementResult
   {
      
      public function placementresult()
      {
         super();
         addFrameScript(25,this.frame26);
      }
      
      internal function frame26() : *
      {
         stop();
      }
   }
}

