package fsg.pausemenu
{
   import codo.views.FsgPauseMenuView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol174")]
   public dynamic class fsgPauseMenuView extends FsgPauseMenuView
   {
      
      public function fsgPauseMenuView()
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

