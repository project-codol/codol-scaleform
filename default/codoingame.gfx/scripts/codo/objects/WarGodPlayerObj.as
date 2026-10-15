package codo.objects
{
   public class WarGodPlayerObj
   {
      
      public static const PHASE_PENDING:int = 0;
      
      public static const PHASE_PLACEMENT:int = 1;
      
      public static const PHASE_STAR:int = 2;
      
      public static const PHASE_PROMOTION:int = 3;
      
      public static const PLAYER_BLOCKED_PERMANENTLY:int = -1;
      
      public var seasonID:int;
      
      public var league:int;
      
      public var score:int;
      
      public var seasonMaxScore:int;
      
      public var warGodRank:PlayerWarGodRank;
      
      public var heroicValue:int;
      
      public var promotionScore:int;
      
      public var phase:int;
      
      public var matchHistroy:Array;
      
      public var numMatchHistroy:int;
      
      public var maxMatchHistroy:int = 10;
      
      public var numPlacementMatchCompleted:int;
      
      public var numPromotionMatchCompleted:int;
      
      public var kills:int;
      
      public var deaths:int;
      
      public var wins:int;
      
      public var maxWinStreak:int;
      
      public var numMatches:int;
      
      public var numDuoMatches:int;
      
      public var tssSatisfied:Boolean;
      
      public var tssReady:Boolean;
      
      public var blockDuration:int;
      
      public var tierRewardFlags:Array;
      
      public function WarGodPlayerObj()
      {
         super();
      }
      
      public function isBlocked(currentTimestamp:int) : Boolean
      {
         if(this.blockDuration == -1)
         {
            return true;
         }
         return this.blockDuration > currentTimestamp;
      }
      
      public function getBlockDuration() : int
      {
         return this.blockDuration;
      }
   }
}

