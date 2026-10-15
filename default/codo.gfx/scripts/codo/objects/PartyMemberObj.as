package codo.objects
{
   public dynamic class PartyMemberObj extends UserObj
   {
      
      public var isHost:Boolean = false;
      
      public var isReady:Boolean = false;
      
      public var isKicked:Boolean = false;
      
      public var showQuit:Boolean = false;
      
      public var showReassign:Boolean = false;
      
      public var showKick:Boolean = false;
      
      public var wargodSeason:int = 0;
      
      public var wargodPhase:int = 0;
      
      public var wargodScore:int = -1;
      
      public var isMiniClient:Boolean = false;
      
      public var meetWarGodWeaponRequirement:Boolean = false;
      
      public var meetWarGodCreditRatingRequirement:Boolean = false;
      
      public var wargodCreditRatingReady:Boolean = false;
      
      public var isBlocked:Boolean = false;
      
      public var isEnoughSpyKarma:Boolean = false;
      
      public var meetDMZLeagueTicketRequirement:Boolean = false;
      
      public function PartyMemberObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

