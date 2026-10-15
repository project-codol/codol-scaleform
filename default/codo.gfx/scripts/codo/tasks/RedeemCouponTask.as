package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class RedeemCouponTask extends AsyncTaskBase
   {
      
      public function RedeemCouponTask()
      {
         super(DataID.REDEEM_COUPON,AsyncTaskGroup.MARKET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.MKT_RedeemCouponArray(this.params);
      }
   }
}

