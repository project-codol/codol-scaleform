package codo.shared.hud
{
   import codo.views.hudDMZ.DMZTop3PlayerView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4503")]
   public dynamic class hudDMZTop3PlayersView extends DMZTop3PlayerView
   {
      
      public function hudDMZTop3PlayersView()
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

