package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2860")]
   public dynamic class ContentSimpleBackgroundNoShapes extends MovieClip
   {
      
      public function ContentSimpleBackgroundNoShapes()
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

