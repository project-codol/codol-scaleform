package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataCommonID;
   
   public class TencentSanitizeStringTask extends AsyncTaskBase
   {
      
      public function TencentSanitizeStringTask()
      {
         super(DataCommonID.TENCENT_SANITIZE_STRING,AsyncTaskGroup.HARMONY);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionCommonContainer.TencentSanitizeString(this.params.sanitizeObj);
      }
   }
}

