package fsg.gamemodes
{
   import components.fsggamemodes_part.FsgRewardsListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6027")]
   public dynamic class fsgRewardsListItem extends FsgRewardsListItem
   {
      
      public function fsgRewardsListItem()
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

