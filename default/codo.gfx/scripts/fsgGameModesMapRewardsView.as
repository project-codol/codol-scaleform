package
{
   import codo.views.FsgGameModesMapRewardView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4026")]
   public dynamic class fsgGameModesMapRewardsView extends FsgGameModesMapRewardView
   {
      
      public function fsgGameModesMapRewardsView()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16,23,this.frame24);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         stop();
      }
      
      internal function frame24() : *
      {
         gotoAndStop(1);
      }
   }
}

