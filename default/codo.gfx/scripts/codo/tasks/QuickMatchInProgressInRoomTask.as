package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class QuickMatchInProgressInRoomTask extends AsyncTaskBase
   {
      
      public function QuickMatchInProgressInRoomTask()
      {
         super(DataID.QUICK_MATCH_IN_PROGRESS_IN_ROOM,AsyncTaskGroup.NONE);
      }
   }
}

