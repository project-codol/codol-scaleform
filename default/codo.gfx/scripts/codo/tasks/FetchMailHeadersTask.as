package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class FetchMailHeadersTask extends AsyncTaskBase
   {
      
      public function FetchMailHeadersTask()
      {
         super(DataID.FETCH_MAIL_HEADERS,AsyncTaskGroup.MAIL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.FetchMailHeaders(this.params.startIndex);
      }
   }
}

