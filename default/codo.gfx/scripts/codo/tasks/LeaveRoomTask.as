package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class LeaveRoomTask extends AsyncTaskBase
   {
      
      public function LeaveRoomTask()
      {
         super(DataID.LEAVE_ROOM,AsyncTaskGroup.IN_ROOM);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionCommonContainer.LeaveRoom(this.params.party,this.params.isUserInput);
      }
   }
}

