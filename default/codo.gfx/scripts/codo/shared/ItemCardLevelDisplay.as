package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2255")]
   public dynamic class ItemCardLevelDisplay extends MovieClip
   {
      
      public function ItemCardLevelDisplay()
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

