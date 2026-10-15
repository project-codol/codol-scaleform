package codo.shared
{
   import codo.component.marketplaceitem.MarketplaceItemPromoTag;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2392")]
   public dynamic class ItemPromoTag extends MarketplaceItemPromoTag
   {
      
      public function ItemPromoTag()
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

