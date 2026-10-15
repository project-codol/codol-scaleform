package fsg.matchresults
{
   import components.fsgmatchresult_part.FsgMatchResultRankBar;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2892")]
   public dynamic class fsgMatchResultRankProgressBar extends FsgMatchResultRankBar
   {
      
      public function fsgMatchResultRankProgressBar()
      {
         super();
         addFrameScript(0,this.frame1,18,this.frame19);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame19() : *
      {
         stop();
      }
   }
}

