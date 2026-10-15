package fsg.matchresults
{
   import components.fsgmatchresult_part.FsgRandomRewardPresentation;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol810")]
   public dynamic class fsgRandomRewardPresentation extends FsgRandomRewardPresentation
   {
      
      public function fsgRandomRewardPresentation()
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

