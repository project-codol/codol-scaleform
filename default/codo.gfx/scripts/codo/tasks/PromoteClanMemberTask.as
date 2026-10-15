package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class PromoteClanMemberTask extends AsyncTaskBase
   {
      
      public function PromoteClanMemberTask()
      {
         super(DataID.PROMOTE_CLAN_MEMBER,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.PromoteClanMember(this.params.user.id,uint(this.params.type));
      }
   }
}

