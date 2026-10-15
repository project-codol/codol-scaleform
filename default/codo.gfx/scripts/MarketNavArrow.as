package
{
   import codo.component.scrollgrid.parts.ScrollListNavArrow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3827")]
   public dynamic class MarketNavArrow extends ScrollListNavArrow
   {
      
      public function MarketNavArrow()
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

