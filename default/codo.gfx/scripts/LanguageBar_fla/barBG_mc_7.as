package LanguageBar_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol858")]
   public dynamic class barBG_mc_7 extends MovieClip
   {
      
      public var currState:int;
      
      public function barBG_mc_7()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
         this.currState = 1;
      }
   }
}

