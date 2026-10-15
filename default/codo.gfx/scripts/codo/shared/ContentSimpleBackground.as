package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2621")]
   public dynamic class ContentSimpleBackground extends MovieClip
   {
      
      public function ContentSimpleBackground()
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

