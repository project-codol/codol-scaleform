package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.utils.Logger;
   import com.society.comscore.DAXDispatcher;
   
   public class ProposeClanMembershipTask extends AsyncTaskBase
   {
      
      public function ProposeClanMembershipTask()
      {
         try
         {
            DAXDispatcher.queue("action_type","invite_to_clan");
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("** DAXDispatcher: " + e.message);
         }
         super(DataID.PROPOSE_CLAN_MEMBERSHIP,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ProposeClanMembership(this.params.user.id);
      }
   }
}

