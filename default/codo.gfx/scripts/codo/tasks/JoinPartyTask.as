package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class JoinPartyTask extends AsyncTaskBase
   {
      
      public function JoinPartyTask()
      {
         super(DataID.JOIN_PARTY,AsyncTaskGroup.PARTY);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.AcceptPartyMembership(params.senderID,params.ticketID);
      }
   }
}

