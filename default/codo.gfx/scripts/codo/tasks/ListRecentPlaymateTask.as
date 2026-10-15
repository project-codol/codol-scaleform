package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ListRecentPlaymateTask extends AsyncTaskBase
   {
      
      public function ListRecentPlaymateTask()
      {
         super(DataID.LIST_RECENTPLAYMATE,AsyncTaskGroup.RECENT);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ListContact(this.params.type);
      }
   }
}

