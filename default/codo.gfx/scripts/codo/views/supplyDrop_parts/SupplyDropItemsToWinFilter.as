package codo.views.supplyDrop_parts
{
   import codo.component.filter.Filter;
   
   public class SupplyDropItemsToWinFilter extends Filter
   {
      
      public function SupplyDropItemsToWinFilter()
      {
         super();
      }
      
      override protected function get filterCategoryButtonClassPath() : String
      {
         return "codo.supplydrop.supplyDropItemsToWinFilterCategoryButton";
      }
   }
}

