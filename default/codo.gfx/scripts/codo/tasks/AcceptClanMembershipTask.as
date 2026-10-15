package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.utils.ScaleformUtil;
   
   public class AcceptClanMembershipTask extends AsyncTaskBase
   {
      
      public function AcceptClanMembershipTask()
      {
         super(DataID.ACCEPT_CLAN_MEMBERSHIP,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            CFunctionContainer.AS_MessageAccept(this.params.invitation.messageid);
         }
         else
         {
            CFunctionContainer.AcceptClanMembership(this.params.invitation.targetID);
         }
      }
   }
}

