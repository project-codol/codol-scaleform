package fsg.popups
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2723")]
   public dynamic class fsgPopupUnlockStar extends MovieClip
   {
      
      public var myFill:MovieClip;
      
      public function fsgPopupUnlockStar()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

