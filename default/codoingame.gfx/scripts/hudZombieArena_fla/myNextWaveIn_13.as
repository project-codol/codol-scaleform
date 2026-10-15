package hudZombieArena_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2776")]
   public dynamic class myNextWaveIn_13 extends MovieClip
   {
      
      public var myNextWave:TextField;
      
      public var myNextWaveLabel:TextField;
      
      public function myNextWaveIn_13()
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

