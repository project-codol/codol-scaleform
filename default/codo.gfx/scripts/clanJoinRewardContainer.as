package
{
   import codo.views.clan_sub.ClanRewardPresentation;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5575")]
   public dynamic class clanJoinRewardContainer extends ClanRewardPresentation
   {
      
      public function clanJoinRewardContainer()
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

