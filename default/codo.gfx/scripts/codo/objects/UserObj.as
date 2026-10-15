package codo.objects
{
   import codo.constants.ClanMemberPosition;
   
   public dynamic class UserObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var level:int = 0;
      
      public var prestige:int = 0;
      
      public var clanID:String = "0";
      
      public var clanPos:uint = ClanMemberPosition.ORDINARY;
      
      public var clanName:String = "";
      
      public var clanTag:String = "";
      
      public var isOnline:Boolean = false;
      
      public var friendStatus:int = 0;
      
      public var isMe:Boolean = false;
      
      public var callSignObj:CallSignObj = new CallSignObj();
      
      public var badgeObj:BadgeObj = new BadgeObj();
      
      public function UserObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

