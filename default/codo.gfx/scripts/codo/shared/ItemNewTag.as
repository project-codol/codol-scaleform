package codo.shared
{
   import codo.component.marketplaceitem.MarketplaceNewTag;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol251")]
   public dynamic class ItemNewTag extends MarketplaceNewTag
   {
      
      public function ItemNewTag()
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

