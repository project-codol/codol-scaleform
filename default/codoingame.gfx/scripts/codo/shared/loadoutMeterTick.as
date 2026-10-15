package codo.shared
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol367")]
   public dynamic class loadoutMeterTick extends MovieClip
   {
      
      public var myActive:MovieClip;
      
      public function loadoutMeterTick()
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

