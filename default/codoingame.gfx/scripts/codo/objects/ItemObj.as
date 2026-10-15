package codo.objects
{
   public dynamic class ItemObj extends CustomObject
   {
      
      public var id:int;
      
      public var nameid:String;
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var legendDesc:String = "";
      
      public var category:String = "";
      
      public var imageURL:String = "";
      
      public var type:String = "";
      
      public var baseID:int = 0;
      
      public var typeName:String = "";
      
      public var group:String = "";
      
      public var groupName:String = "";
      
      public var giftable:Boolean = true;
      
      public var properties:Object;
      
      public var clashProperties:Object;
      
      public var isBought:Boolean;
      
      public var isTryon:Boolean;
      
      public var allowPreview:Boolean = false;
      
      public var enableInTF141:Boolean = false;
      
      public var enableInSC:Boolean = false;
      
      public var enableInZombie:Boolean = false;
      
      public var isPermanentHave:Boolean = false;
      
      public var isAvailableForSale:Boolean = true;
      
      public var stackable:Boolean = false;
      
      public var stackNumber:uint = 0;
      
      public var stackDelta:uint = 0;
      
      public var remainSecond:int = 0;
      
      public var expireDateTime:uint = 4294967295;
      
      public var expiryDuration:uint = 4294967295;
      
      public var displayQuantity:int = 0;
      
      public var isUnloadable:Boolean;
      
      public var equippable:Boolean = true;
      
      public var cantEquippableReasonList:Array;
      
      public var isBanned:Boolean = false;
      
      public var equipLevel:int;
      
      public var level:uint = 0;
      
      public var currentExp:uint = 0;
      
      public var totalExp:uint = 1;
      
      public var isEvent:Boolean = false;
      
      public var isCoupon:Boolean = false;
      
      public var isBasePerk:Boolean = false;
      
      public var specialPara:Array;
      
      public var isCustomisable:Boolean = false;
      
      public var killsReq:uint = 0;
      
      public var color:uint = 16777215;
      
      public function ItemObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

