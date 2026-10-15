package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2100")]
   public dynamic class ListSimpleBackground extends MovieClip
   {
      
      public function ListSimpleBackground()
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

