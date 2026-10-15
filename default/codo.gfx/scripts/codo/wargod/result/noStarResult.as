package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.NoStarResult;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3287")]
   public dynamic class noStarResult extends NoStarResult
   {
      
      public function noStarResult()
      {
         super();
         addFrameScript(0,this.frame1,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame26() : *
      {
         stop();
         complete();
      }
   }
}

