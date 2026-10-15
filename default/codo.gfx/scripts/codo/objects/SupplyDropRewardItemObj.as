package codo.objects
{
   public class SupplyDropRewardItemObj
   {
      
      public var supplyDropID:int;
      
      public var product:ProductObj;
      
      public var isReplacedItem:Boolean;
      
      public var crushedCurrencyID:int;
      
      public var alternativeAmount:int;
      
      public var itemDependencies:Array;
      
      public var isFeatured:Boolean;
      
      public var isPartialCrushed:Boolean;
      
      public var shouldShowOff:Boolean;
      
      public function SupplyDropRewardItemObj(supplyDropID:int, product:ProductObj, itemDependencies:Array = null, isReplacedItem:Boolean = false, crushCurrencyId:int = 0, alternativeAmount:int = 0, isFeatured:Boolean = false, isPartialCrushed:Boolean = false, shouldShowOff:Boolean = false)
      {
         super();
         this.supplyDropID = supplyDropID;
         this.product = product;
         this.itemDependencies = itemDependencies;
         this.isReplacedItem = isReplacedItem;
         this.crushedCurrencyID = crushCurrencyId;
         this.alternativeAmount = alternativeAmount;
         this.isFeatured = isFeatured;
         this.isPartialCrushed = isPartialCrushed;
         this.shouldShowOff = shouldShowOff;
      }
   }
}

