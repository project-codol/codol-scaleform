package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class FetchMailBodiesTask extends AsyncTaskBase
   {
      
      public function FetchMailBodiesTask()
      {
         super(DataID.FETCH_MAIL_BODIES,AsyncTaskGroup.MAIL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.FetchMailBodies(this.params.headers);
      }
   }
}

