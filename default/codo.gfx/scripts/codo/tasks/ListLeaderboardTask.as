package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ListLeaderboardTask extends AsyncTaskBase
   {
      
      public function ListLeaderboardTask()
      {
         super(DataID.LIST_LEADERBOARD,AsyncTaskGroup.LEADERBOARD);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ListLeaderboard(this.params);
      }
   }
}

