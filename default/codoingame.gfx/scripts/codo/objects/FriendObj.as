package codo.objects
{
   public dynamic class FriendObj extends UserObj
   {
      
      public var isInRoom:Boolean = false;
      
      public var isRoomFull:Boolean = false;
      
      public var isRoomPrivate:Boolean = false;
      
      public var isRankedMatch:Boolean = false;
      
      public var isInParty:Boolean = false;
      
      public var isPartyPrivate:Boolean = false;
      
      public var isInClan:Boolean = false;
      
      public var gameStatus:int = 0;
      
      public var dlcLevel:uint = 0;
      
      public var roomDLCLevel:uint = 0;
      
      public var partyDLCLevel:uint = 0;
      
      public var sessionID:String = "";
      
      public var leagueID:int = 0;
      
      public var rankedMatchState:uint = 0;
      
      public var mapObj:MapObj = null;
      
      public var modeObj:ModeObj = null;
      
      public var playListObj:PlayListObj = null;
      
      public var partySelected:Boolean = false;
      
      public var clanSelected:Boolean = false;
      
      public var qqMembershipBits:int = 0;
      
      public var netCafePrivileges:int = 0;
      
      public function FriendObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

