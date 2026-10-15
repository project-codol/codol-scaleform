package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.utils.ScaleformUtil;
   
   public class RejectClanMembershipTask extends AsyncTaskBase
   {
      
      public function RejectClanMembershipTask()
      {
         super(DataID.REJECT_CLAN_MEMBERSHIP,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            CFunctionContainer.AS_MessageReject(this.params.invitation.messageid);
         }
         else
         {
            CFunctionContainer.RejectClanMembership(this.params.invitation.targetID);
         }
      }
   }
}

