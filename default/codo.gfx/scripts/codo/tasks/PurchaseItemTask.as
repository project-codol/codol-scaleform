package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   
   public class PurchaseItemTask extends AsyncTaskBase
   {
      
      private var mItemPurchased:int;
      
      public function PurchaseItemTask()
      {
         super(DataID.MARKET_BUY,AsyncTaskGroup.MARKET);
         auto = true;
      }
      
      override public function onStart() : void
      {
         var item:ProductObj = null;
         super.onStart();
         this.showFeedback = true;
         if(this.params != null)
         {
            if(this.params is Array)
            {
               if(this.params.length > 0)
               {
                  CFunctionContainer.MKT_BuyRecentExpiredItems(this.params);
               }
            }
            else
            {
               if(this.params.disableFeedback == true)
               {
                  this.showFeedback = false;
               }
               item = this.params.item as ProductObj;
               if(item.SKUs.length > 0)
               {
                  CFunctionContainer.MKT_BuyItem(item.SKUs[item.currentSKUIndex].id,this.params.itemNum);
                  this.mItemPurchased = CFunctionContainer.AS_GetProductIDFromSKU(item.SKUs[item.currentSKUIndex].id);
               }
            }
         }
      }
      
      override public function onFail() : void
      {
         super.onFail();
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_TASK_FAIL,this.mItemPurchased);
      }
      
      override public function onSuccess() : void
      {
         super.onSuccess();
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_TASK_SUCCESS,this.mItemPurchased);
      }
   }
}

