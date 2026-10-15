package codo.objects
{
   public class ChallengeRewardObj extends CustomObject
   {
      
      public static const REWARD_TYPE_NONE:int = 0;
      
      public static const REWARD_TYPE_GP:int = 1;
      
      public static const REWARD_TYPE_ITEM:int = 2;
      
      public static const REWARD_TYPE_PRODUCT:int = 3;
      
      public static const REWARD_TYPE_SKU:int = 4;
      
      public static const REWARD_TYPE_XP:int = 4;
      
      public var type:int;
      
      public var entityId:int;
      
      public var entityInfo:int = 0;
      
      public var entityDuration:int = 0;
      
      public var xp:int = 0;
      
      public var gp:int = 0;
      
      public var claimed:Boolean;
      
      public function ChallengeRewardObj()
      {
         super();
      }
   }
}

