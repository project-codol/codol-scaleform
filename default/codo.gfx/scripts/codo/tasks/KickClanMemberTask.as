package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class KickClanMemberTask extends AsyncTaskBase
   {
      
      public function KickClanMemberTask()
      {
         super(DataID.KICK_CLAN_MEMBER,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.KickClanMember(this.params.user.id);
      }
   }
}

