package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class GetGroupCountsTask extends AsyncTaskBase
   {
      
      public function GetGroupCountsTask()
      {
         super(DataID.GROUP_COUNTS,AsyncTaskGroup.GROUP_COUNT);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.GetGroupCounts();
      }
   }
}

