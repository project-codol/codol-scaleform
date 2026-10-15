package codo.objects
{
   import codo.localization.DictClan;
   
   public class ClanGlobalConfig
   {
      
      public static const CLAN_LEVEL_NAMES:Array = [DictClan.CLAN_LEVEL_BRONZE,DictClan.CLAN_LEVEL_SILVER,DictClan.CLAN_LEVEL_GOLD,DictClan.CLAN_LEVEL_PLATINUM,DictClan.CLAN_LEVEL_DIAMOND];
      
      public static const CLAN_LEVEL_BRONZE:int = 1;
      
      public static const CLAN_LEVEL_SILVER:int = 2;
      
      public static const CLAN_LEVEL_GOLD:int = 3;
      
      public static const CLAN_LEVEL_PLATINUM:int = 4;
      
      public static const CLAN_LEVEL_DIAMOND:int = 5;
      
      public var levelUpgrade:Array;
      
      public var maintenance:Array;
      
      public var dailyCap:Array;
      
      public var dailyGPReward:Array;
      
      public var xpBuffPerLevel:Array;
      
      public var xpMatePlayBuffPerLevel:Array;
      
      public var ccpPlayWithMember:uint;
      
      public var ccpPlayWithMemberCap:uint;
      
      public var ccpWargod:uint;
      
      public var ccpWargodCap:uint;
      
      public var ccpChallenge:uint;
      
      public var ccpChallengeCap:uint;
      
      public var cpToCCPRate:String;
      
      public var ccpToCTPRate:String;
      
      public var createClanCoolDown:uint;
      
      public var joinRewardItemDuration:uint;
      
      public var joinRewardItemId:uint;
      
      public var readBestClanFromTencent:Boolean;
      
      public function ClanGlobalConfig()
      {
         super();
      }
   }
}

