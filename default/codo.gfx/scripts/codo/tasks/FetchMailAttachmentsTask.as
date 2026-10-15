package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class FetchMailAttachmentsTask extends AsyncTaskBase
   {
      
      public function FetchMailAttachmentsTask()
      {
         super(DataID.FETCH_MAIL_ATTACHMENTS,AsyncTaskGroup.MARKET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.MKT_RefreshPendingCoupon();
      }
   }
}

