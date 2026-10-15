package
{
   import codo.views.FsgHelpMenuView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3486")]
   public dynamic class fsgHelpMenuView extends FsgHelpMenuView
   {
      
      public function fsgHelpMenuView()
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

