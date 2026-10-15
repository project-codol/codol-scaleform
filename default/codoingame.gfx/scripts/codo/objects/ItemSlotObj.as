package codo.objects
{
   public dynamic class ItemSlotObj extends CustomObject
   {
      
      public var nameid:String = "";
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var imageURL:String = "";
      
      public var isEmpty:Boolean = true;
      
      public var isEnable:Boolean = true;
      
      public var isLocked:Boolean = false;
      
      public var isBought:Boolean = true;
      
      public var isOnlyTryon:Boolean = false;
      
      public var isBanned:Boolean = false;
      
      public var unlockPrestige:int = 0;
      
      public var unlockRank:int = 0;
      
      public var isUnloadable:Boolean = false;
      
      public var exclusiveList:Array = [];
      
      public var semiTransparent:Boolean = false;
      
      public var item_id:int;
      
      public var itemDat:Object;
      
      public function ItemSlotObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

