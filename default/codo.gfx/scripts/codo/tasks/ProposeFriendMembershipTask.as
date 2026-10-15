package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ProposeFriendMembershipTask extends AsyncTaskBase
   {
      
      public function ProposeFriendMembershipTask()
      {
         super(DataID.PROPOSE_FRIEND_MEMBERSHIP,AsyncTaskGroup.CONTACT);
      }
      
      override public function onStart() : void
      {
         if(this.params != null)
         {
            super.onStart();
            if(Boolean(this.params.isName))
            {
               CFunctionContainer.AddFriendByName(this.params.value);
            }
            else
            {
               CFunctionContainer.AddFriendByID(this.params.value);
            }
         }
      }
   }
}

