package fsg.matchresults
{
   import components.fsgmatchresult_part.FsgMatchResultTeamPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol609")]
   public dynamic class fsgMatchResultTeamPanel extends FsgMatchResultTeamPanel
   {
      
      public function fsgMatchResultTeamPanel()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame10() : *
      {
         stop();
      }
   }
}

