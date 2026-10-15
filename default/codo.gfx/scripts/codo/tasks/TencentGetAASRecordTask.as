package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class TencentGetAASRecordTask extends AsyncTaskBase
   {
      
      public function TencentGetAASRecordTask()
      {
         super(DataID.TENCENT_GET_AAS_RECORD,AsyncTaskGroup.AAS);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.TencentGetAASRecord();
      }
   }
}

