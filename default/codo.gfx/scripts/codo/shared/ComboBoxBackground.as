package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol74")]
   public dynamic class ComboBoxBackground extends MovieClip
   {
      
      public function ComboBoxBackground()
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

