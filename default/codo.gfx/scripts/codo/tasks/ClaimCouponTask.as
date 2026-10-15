package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ClaimCouponTask extends AsyncTaskBase
   {
      
      public function ClaimCouponTask()
      {
         super(DataID.CLAIM_COUPON,AsyncTaskGroup.MARKET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.MKT_ClaimCouponArray(this.params);
      }
   }
}

