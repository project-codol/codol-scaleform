package codo.views.supplyDrop_parts
{
   import codo.component.filter.FilterOption;
   
   public class SupplyDropItemsToWinFilterOption extends FilterOption
   {
      
      public function SupplyDropItemsToWinFilterOption()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         mData = data;
      }
   }
}

