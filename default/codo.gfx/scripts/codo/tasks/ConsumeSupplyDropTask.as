package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ConsumeSupplyDropTask extends AsyncTaskBase
   {
      
      public function ConsumeSupplyDropTask()
      {
         super(DataID.REWARD_CONSUME_SUPPLY_DROP,AsyncTaskGroup.REWARD);
      }
      
      override public function onStart() : void
      {
         var supplyDropID:int = 0;
         var quantity:int = 0;
         super.onStart();
         if(this.params != null)
         {
            supplyDropID = this.params.id as int;
            quantity = this.params.quantity as int;
            CFunctionContainer.AS_ConsumeSupplyDrop(supplyDropID,quantity);
         }
      }
   }
}

