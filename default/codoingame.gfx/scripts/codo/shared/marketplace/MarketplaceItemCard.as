package codo.shared.marketplace
{
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1607")]
   public dynamic class MarketplaceItemCard extends codo.component.marketplaceitem.parts.MarketplaceItemCard
   {
      
      public function MarketplaceItemCard()
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

