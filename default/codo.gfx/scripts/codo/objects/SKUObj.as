package codo.objects
{
   public dynamic class SKUObj extends CustomObject
   {
      
      public var name:String;
      
      public var id:int;
      
      public var promoSkuId:int;
      
      public var cp:int;
      
      public var cc:int;
      
      public var duration:int;
      
      public var stackable:Boolean;
      
      public var productId:int;
      
      public var requirementLevel:int;
      
      public var requirementPrestige:int;
      
      public var requirementUnlockFlag:String;
      
      public var purchasable:Boolean = true;
      
      public var originalPrice:int;
      
      public var price:int;
      
      public var currency:String;
      
      public var couponEnable:Boolean;
      
      public var ignoreEntitlement:Boolean;
      
      public var indexInProduct:uint;
      
      public var ignoreDiscount:Boolean = false;
      
      public function SKUObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

