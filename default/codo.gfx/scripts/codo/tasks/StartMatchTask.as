package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class StartMatchTask extends AsyncTaskBase
   {
      
      public function StartMatchTask()
      {
         super(DataID.START_MATCH,AsyncTaskGroup.IN_ROOM);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.StartMatch(this.params);
      }
   }
}

