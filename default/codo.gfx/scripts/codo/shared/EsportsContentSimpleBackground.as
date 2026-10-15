package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1502")]
   public dynamic class EsportsContentSimpleBackground extends MovieClip
   {
      
      public function EsportsContentSimpleBackground()
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

