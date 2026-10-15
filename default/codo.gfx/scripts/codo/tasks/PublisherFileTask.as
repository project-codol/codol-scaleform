package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.utils.Logger;
   
   public class PublisherFileTask extends AsyncTaskBase
   {
      
      public function PublisherFileTask()
      {
         super(DataID.PUBLISHER_FILES_UPDATE,AsyncTaskGroup.NONE);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         Logger.print("PublisherFileTask::onStart " + this.params.fileType);
         CFunctionContainer.AS_PublisherFileMarkAsOutOfDate(this.params.fileType);
      }
   }
}

