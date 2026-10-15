package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataCommonID;
   
   public class MatchStatusTask extends AsyncTaskBase
   {
      
      public function MatchStatusTask()
      {
         super(DataCommonID.MATCH_STATUS,AsyncTaskGroup.NONE);
      }
   }
}

