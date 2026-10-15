package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class CreateRoomTask extends AsyncTaskBase
   {
      
      public function CreateRoomTask()
      {
         super(DataID.CREATE_ROOM,AsyncTaskGroup.IN_CHANNEL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         if(this.params != null)
         {
            CFunctionContainer.CreateRoom(this.params);
            this.params = null;
         }
      }
   }
}

