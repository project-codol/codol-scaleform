package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class LeavePartyTask extends AsyncTaskBase
   {
      
      public function LeavePartyTask()
      {
         super(DataID.LEAVE_PARTY,AsyncTaskGroup.PARTY);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.LeaveParty();
      }
   }
}

