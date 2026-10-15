package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class FetchClanMailHeadersTask extends AsyncTaskBase
   {
      
      public function FetchClanMailHeadersTask()
      {
         super(DataID.FETCH_CLAN_MAIL_HEADERS,AsyncTaskGroup.MAIL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.FetchClanMailHeaders(this.params.startIndex);
      }
   }
}

