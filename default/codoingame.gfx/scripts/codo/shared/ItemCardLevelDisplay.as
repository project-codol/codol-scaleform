package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1907")]
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

