package fsgmatchresults_part
{
   import components.fsgmatchresults_part.MissionAwardsPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2483")]
   public dynamic class missionAwardsPanel extends MissionAwardsPanel
   {
      
      public function missionAwardsPanel()
      {
         super();
         addFrameScript(0,this.frame1,22,this.frame23);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame23() : *
      {
         stop();
      }
   }
}

