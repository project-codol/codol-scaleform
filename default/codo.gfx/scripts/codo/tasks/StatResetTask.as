package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class StatResetTask extends AsyncTaskBase
   {
      
      public function StatResetTask()
      {
         super(DataID.REDEEM_STAT_RESET,AsyncTaskGroup.REDEEM_STAT_RESET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.AS_RedeemStatReset();
      }
   }
}

