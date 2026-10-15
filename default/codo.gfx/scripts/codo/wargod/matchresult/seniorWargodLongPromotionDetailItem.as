package codo.wargod.matchresult
{
   import codo.views.wargodMatchResult_parts.PromotionDetailItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3401")]
   public dynamic class seniorWargodLongPromotionDetailItem extends PromotionDetailItem
   {
      
      public function seniorWargodLongPromotionDetailItem()
      {
         super();
         addFrameScript(29,this.frame30);
      }
      
      internal function frame30() : *
      {
         stop();
      }
   }
}

