package hudSandR_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2556")]
   public dynamic class SandR_Status_3 extends MovieClip
   {
      
      public var myStatusText:TextField;
      
      public function SandR_Status_3()
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

