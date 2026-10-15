package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class QuickMatchTask extends AsyncTaskBase
   {
      
      public function QuickMatchTask()
      {
         super(DataID.QUICK_MATCH,AsyncTaskGroup.IN_CHANNEL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.QuickMatch(this.params);
      }
   }
}

