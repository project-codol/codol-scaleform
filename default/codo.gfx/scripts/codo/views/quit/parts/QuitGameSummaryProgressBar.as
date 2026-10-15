package codo.views.quit.parts
{
   import codo.views.quit_parts.QuitGameSummaryProgressBar;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4966")]
   public dynamic class QuitGameSummaryProgressBar extends codo.views.quit_parts.QuitGameSummaryProgressBar
   {
      
      public function QuitGameSummaryProgressBar()
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

