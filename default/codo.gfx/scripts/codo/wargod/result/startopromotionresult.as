package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.StarToPromotionResult;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3209")]
   public dynamic class startopromotionresult extends StarToPromotionResult
   {
      
      public function startopromotionresult()
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

