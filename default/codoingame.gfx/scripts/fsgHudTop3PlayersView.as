package
{
   import codo.views.FsgHudTop3PlayersView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3449")]
   public dynamic class fsgHudTop3PlayersView extends FsgHudTop3PlayersView
   {
      
      public function fsgHudTop3PlayersView()
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

