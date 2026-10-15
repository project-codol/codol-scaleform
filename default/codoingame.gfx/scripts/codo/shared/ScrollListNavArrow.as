package codo.shared
{
   import codo.component.scrollgrid.parts.ScrollListNavArrow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol908")]
   public dynamic class ScrollListNavArrow extends codo.component.scrollgrid.parts.ScrollListNavArrow
   {
      
      public function ScrollListNavArrow()
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

