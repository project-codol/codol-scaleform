package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.DataID;
   
   public class TournamentLeaderboardController extends BaseController
   {
      
      private var curFriendsLeaderboardData:Object;
      
      private var curTop100LeaderboardData:Object;
      
      private var curLocalZoneTop100LeaderboardData:Object;
      
      public function TournamentLeaderboardController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.GET_WARGOD_100TH_SCORE,this.getWarGod100ThScore);
      }
      
      public function cppOnGetFriendsLeaderboard(leaderboardData:Object) : void
      {
         if(Boolean(leaderboardData.success))
         {
            this.curFriendsLeaderboardData = leaderboardData;
            setBindData(DataID.WARGOD_LEADERBOARD_FRIENDS,leaderboardData);
         }
      }
      
      public function cppOnGetSeasonTop100Player(leaderboardName:String, leaderboardData:Object) : void
      {
         if(Boolean(leaderboardData))
         {
            if(this.isLocalZoneLeaderboard(leaderboardName))
            {
               this.curLocalZoneTop100LeaderboardData = leaderboardData;
               setBindData(DataID.WARGOD_LEADERBOARD_LOCAL_ZONE_TOP100,leaderboardData);
            }
            else
            {
               this.curTop100LeaderboardData = leaderboardData;
               setBindData(DataID.WARGOD_LEADERBOARD_TOP100,leaderboardData);
            }
         }
      }
      
      public function cppOnGetHistorySeasonData(leaderBoardData:Array) : void
      {
         setBindData(DataID.WARGOD_HISTROY_SEASON_RESULT,leaderBoardData);
      }
      
      private function getWarGod100ThScore() : int
      {
         return CFunctionContainer.AS_GetWarGod100thPlayerScore();
      }
      
      private function isLocalZoneLeaderboard(lbName:String) : Boolean
      {
         return getDP(DataID.CURRENT_WARGOD_INFO).lbLocalName == lbName;
      }
   }
}

