package codo.pausemenu
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol90")]
   public dynamic class contentSimpleBackground extends MovieClip
   {
      
      public function contentSimpleBackground()
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

