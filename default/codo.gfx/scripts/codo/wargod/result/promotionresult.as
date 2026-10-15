package codo.wargod.result
{
   import codo.views.wargodMatchResult_parts.PromotionResult;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3223")]
   public dynamic class promotionresult extends PromotionResult
   {
      
      public function promotionresult()
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

