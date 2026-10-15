package codo.objects
{
   public class WarGodGlobalSettingObj
   {
      
      public static const LEAGUE_JUNIOR:int = 0;
      
      public static const LEAGUE_WARGOD:int = 1;
      
      public var levelRestriction:int;
      
      public var primaryWeaponRequirement:int;
      
      public var lockLeaderboard:Boolean;
      
      public var lockLocalLeaderboard:Boolean;
      
      public var partyEnabled:Boolean;
      
      public var tssEnabled:Boolean;
      
      public var lockHistroy:Boolean;
      
      public var playlistId:int;
      
      public var hvExchangeRate:Array;
      
      public var hvProtectionRate:Array;
      
      public var challengeReward:Array;
      
      public var seasonRewards:Array;
      
      public var top100Reward:Array;
      
      public var hpBonusReward:Array;
      
      public var entranceLabel:String;
      
      public var playlistOpenTimeLabel:String;
      
      public var numStarForUpgrade:Array;
      
      public var maxPlacementMatch:int;
      
      public var promotionScore:Array;
      
      public var seniorWargodPromotionScore:Array;
      
      public var tssTimeout:int;
      
      public var maxPartyMember:int;
      
      public var hpMaxStorage:int;
      
      public var ehpMaxStorage:int;
      
      public var levelPromoteWargod:int;
      
      public var dailyBonusHint:String;
      
      public var perZoneLBFromTencent:Boolean;
      
      public function WarGodGlobalSettingObj()
      {
         super();
      }
   }
}

