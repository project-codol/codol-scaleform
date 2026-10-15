package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class UpdateCouponTask extends AsyncTaskBase
   {
      
      public function UpdateCouponTask()
      {
         super(DataID.UPDATE_COUPON,AsyncTaskGroup.MARKET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.MKT_RefreshCoupon();
      }
   }
}

