package codo.wargod.matchresult
{
   import codo.views.wargodMatchResult_parts.PromotionDetailItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3239")]
   public dynamic class promotionDetailItem extends PromotionDetailItem
   {
      
      public function promotionDetailItem()
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

