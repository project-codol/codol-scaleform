package codo.objects
{
   public dynamic class WeaponLoadoutObj extends CustomObject
   {
      
      public var name:String = "";
      
      public var primaryValKeyArray:Array = [];
      
      public var secondaryValKeyArray:Array = [];
      
      public var swordValKeyArray:Array = [];
      
      public var meleeValKeyArray:Array = [];
      
      public var primaryWeapSlot:ItemSlotObj;
      
      public var secondaryWeapSlot:ItemSlotObj;
      
      public var swordWeapSlot:ItemSlotObj;
      
      public var meleeWeapSlot:ItemSlotObj;
      
      public var primaryWeapAttachment_0:Object;
      
      public var primaryWeapAttachment_1:Object;
      
      public var primaryWeapAttachment_2:Object;
      
      public var primaryWeapAttachment_3:Object;
      
      public var primaryWeapAttachment_4:Object;
      
      public var primaryWeapAttachment_5:Object;
      
      public var secondWeapAttachment_0:Object;
      
      public var secondWeapAttachment_1:Object;
      
      public var secondWeapAttachment_2:Object;
      
      public var secondWeapAttachment_3:Object;
      
      public var secondWeapAttachment_4:Object;
      
      public var secondWeapAttachment_5:Object;
      
      public var primarySlotArray:Array = [];
      
      public var secondarySlotArray:Array = [];
      
      public var swordSlotArray:Array = [];
      
      public var meleeSlotArray:Array = [];
      
      public var combatSlot:Object;
      
      public var grenadeSlot_0:Object;
      
      public var grenadeSlot_1:Object;
      
      public var grenadeSlot_2:Object;
      
      public var grenadeSlot_3:Object;
      
      public var perkSlot_0:Object;
      
      public var perkSlot_1:Object;
      
      public var perkSlot_2:Object;
      
      public var perkSlot_3:Object;
      
      public var perkSlot_4:Object;
      
      public var perkSlot_5:Object;
      
      public var wildcardSlot_0:Object;
      
      public var wildcardSlot_1:Object;
      
      public var wildcardSlot_2:Object;
      
      public var deathStreakSlot:Object;
      
      public var killStreakSlot_0:Object;
      
      public var killStreakSlot_1:Object;
      
      public var killStreakSlot_2:Object;
      
      public var primaryWeapSlotItem:Object;
      
      public var secondaryWeapSlotItem:Object;
      
      public var swordWeapSlotItem:Object;
      
      public var knifeWeapSlotItem:Object;
      
      public var characterParts:Array = [];
      
      public var emotes:Array = [0,0,0,0];
      
      public var combatKnife:int;
      
      public var isMe:Boolean = true;
      
      public var badges:Array = [];
      
      public var consumable:int = 0;
      
      public var consumableCount:int = 0;
      
      public function WeaponLoadoutObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

