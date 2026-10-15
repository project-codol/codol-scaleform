package codo.shared.hud
{
   import codo.views.hudDMZ.CircleTimer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3058")]
   public dynamic class dmzCircleTimer extends CircleTimer
   {
      
      public function dmzCircleTimer()
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

