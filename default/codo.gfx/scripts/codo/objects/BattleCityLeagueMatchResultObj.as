package codo.objects
{
   public class BattleCityLeagueMatchResultObj
   {
      
      public static const REWARD_TYPE_UNKNOWN:int = 0;
      
      public static const REWARD_TYPE_MAIN:int = 1;
      
      public static const REWARD_TYPE_SUB:int = 2;
      
      public var championPointsBeforeMatch:int;
      
      public var championPointsAfterMatch:int;
      
      public var beforeProgress:int;
      
      public var afterProgress:int;
      
      public var fullProgress:int;
      
      public var rewardPoolType:int;
      
      public var rewardIndex:int;
      
      public var beforeMatchRewardStatus:Array;
      
      public function BattleCityLeagueMatchResultObj()
      {
         super();
      }
   }
}

