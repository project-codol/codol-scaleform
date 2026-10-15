package fsg.pausemenu
{
   import codo.views.PauseMenuAsymView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4071")]
   public dynamic class pauseMenuAsymView extends PauseMenuAsymView
   {
      
      public function pauseMenuAsymView()
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
         trace("WE AERE HERERERE");
         stop();
      }
   }
}

