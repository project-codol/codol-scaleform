package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ListDedicatedServerTask extends AsyncTaskBase
   {
      
      public function ListDedicatedServerTask()
      {
         super(DataID.LIST_DEDICATED_SERVER,AsyncTaskGroup.IN_ROOM);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ListDedicatedServer();
      }
   }
}

