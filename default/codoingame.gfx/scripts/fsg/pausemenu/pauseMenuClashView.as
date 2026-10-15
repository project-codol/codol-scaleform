package fsg.pausemenu
{
   import codo.views.PauseMenuClashView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3793")]
   public dynamic class pauseMenuClashView extends PauseMenuClashView
   {
      
      public function pauseMenuClashView()
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

