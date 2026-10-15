package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class DeleteClanMailsTask extends AsyncTaskBase
   {
      
      public function DeleteClanMailsTask()
      {
         super(DataID.DELETE_CLAN_MAILS,AsyncTaskGroup.MAIL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.DeleteClanMails(this.params.mails);
      }
   }
}

