package codo.objects
{
   public dynamic class RoomMemberObj extends UserObj
   {
      
      public var isHost:Boolean = false;
      
      public var isReady:Boolean = false;
      
      public var isInMyParty:Boolean = false;
      
      public var team:uint = 0;
      
      public var vote:int = 0;
      
      public var pilot:int = 0;
      
      public var avatarItemSlots:Object;
      
      public var avatarInventoryItems:Object;
      
      public var weaponloadObj:WeaponLoadoutObj;
      
      public var weaponInventoryItems:Array = [];
      
      public var careerStats:CareerStatsObj;
      
      public var menuSelections:Array = [];
      
      public var qq_membership:int = 0;
      
      public var netcafe:uint = 0;
      
      public var wargodSeason:int = 0;
      
      public var wargodScore:int = -1;
      
      public var wargodPhase:int = 0;
      
      public var fakeClientID:uint;
      
      public var dlcLevel:int;
      
      public function RoomMemberObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public function isFakeClient() : Boolean
      {
         return this.fakeClientID != 0;
      }
   }
}

