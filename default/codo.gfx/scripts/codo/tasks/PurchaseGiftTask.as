package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class PurchaseGiftTask extends AsyncTaskBase
   {
      
      public function PurchaseGiftTask()
      {
         super(DataID.PURCHASE_GIFT,AsyncTaskGroup.MARKET);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.MKT_PurchaseGift(this.params.sku,this.params.targetUser,this.params.needCheckID);
      }
   }
}

