package codo.shared
{
   import codo.component.marketplaceitem.MarketplaceItemPromoTag;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1079")]
   public dynamic class FeatureItemPromoTag extends MarketplaceItemPromoTag
   {
      
      public function FeatureItemPromoTag()
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

