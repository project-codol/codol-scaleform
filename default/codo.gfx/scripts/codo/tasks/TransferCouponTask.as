package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class TransferCouponTask extends AsyncTaskBase
   {
      
      public function TransferCouponTask()
      {
         super(DataID.TRANSFER_COUPON,AsyncTaskGroup.MARKET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.MKT_TransferCoupon(this.params.coupon,this.params.targetUser,this.params.needCheckID);
      }
   }
}

