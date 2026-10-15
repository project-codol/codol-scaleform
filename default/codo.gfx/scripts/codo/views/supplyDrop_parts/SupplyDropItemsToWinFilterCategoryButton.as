package codo.views.supplyDrop_parts
{
   import codo.component.filter.FilterCategoryButton;
   
   public class SupplyDropItemsToWinFilterCategoryButton extends FilterCategoryButton
   {
      
      public function SupplyDropItemsToWinFilterCategoryButton()
      {
         super();
      }
      
      override protected function get filterCategoryOptionClassPath() : String
      {
         return "codo.supplydrop.supplyDropItemsToWinFilterOption";
      }
   }
}

