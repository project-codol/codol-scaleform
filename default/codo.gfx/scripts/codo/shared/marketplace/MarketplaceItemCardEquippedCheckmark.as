package codo.shared.marketplace
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1946")]
   public dynamic class MarketplaceItemCardEquippedCheckmark extends MovieClip
   {
      
      public function MarketplaceItemCardEquippedCheckmark()
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

