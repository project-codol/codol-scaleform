package codo.objects
{
   public class SupplyDropGrantedItemObj
   {
      
      public var itemID:int;
      
      public var productID:int;
      
      public var itemDependencies:Array = [];
      
      public var rentalDurationSeconds:uint;
      
      public var wasCrushed:Boolean;
      
      public var crushCurrencyID:int;
      
      public var crushAmount:int;
      
      public var isFeatured:Boolean;
      
      public var quantity:int;
      
      public var quantityDelta:int;
      
      public var isPartialCrushed:Boolean;
      
      public var showOff:Boolean;
      
      public function SupplyDropGrantedItemObj()
      {
         super();
      }
   }
}

