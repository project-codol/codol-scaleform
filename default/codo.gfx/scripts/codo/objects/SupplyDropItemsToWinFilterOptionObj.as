package codo.objects
{
   public class SupplyDropItemsToWinFilterOptionObj
   {
      
      public var index:int;
      
      public var label:String;
      
      public var category:int;
      
      public var subCategory:int;
      
      public function SupplyDropItemsToWinFilterOptionObj(index:int, label:String, category:int, subCategory:int)
      {
         super();
         this.index = index;
         this.label = label;
         this.category = category;
         this.subCategory = subCategory;
      }
   }
}

