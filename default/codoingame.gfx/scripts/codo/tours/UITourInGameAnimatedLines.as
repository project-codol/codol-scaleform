package codo.tours
{
   import codo.views.uitour.ingame.UITourInGameAnimatedLines;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2654")]
   public dynamic class UITourInGameAnimatedLines extends codo.views.uitour.ingame.UITourInGameAnimatedLines
   {
      
      public function UITourInGameAnimatedLines()
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

