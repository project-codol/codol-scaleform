package codo.shared.tutorial
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1419")]
   public dynamic class AnimatedArrowGlow extends MovieClip
   {
      
      public function AnimatedArrowGlow()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         gotoAndPlay(2);
      }
   }
}

