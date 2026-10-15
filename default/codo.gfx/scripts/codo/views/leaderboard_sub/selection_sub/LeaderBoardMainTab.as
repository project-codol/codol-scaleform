package codo.views.leaderboard_sub.selection_sub
{
   import codo.component.social.SocialMainTab;
   
   public class LeaderBoardMainTab extends SocialMainTab
   {
      
      private static const BG_WIDTH:int = 300;
      
      private static const BG_HEIGHT:int = 45;
      
      public function LeaderBoardMainTab()
      {
         super();
         myBg.width = BG_WIDTH;
         myBg.height = BG_HEIGHT;
      }
   }
}

