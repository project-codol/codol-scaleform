package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class DemoteClanMemberTask extends AsyncTaskBase
   {
      
      public function DemoteClanMemberTask()
      {
         super(DataID.DEMOTE_CLAN_MEMBER,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.DemoteClanMember(this.params.user.id);
      }
   }
}

