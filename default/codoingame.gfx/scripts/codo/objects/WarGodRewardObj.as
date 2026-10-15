package codo.objects
{
   public class WarGodRewardObj
   {
      
      public static const TYPE_RENTAL:int = 0;
      
      public static const TYPE_STACKABLE:int = 1;
      
      public static const TYPE_CURRENCY:int = 2;
      
      public static const MAX_REWARD_DELIVERY_PER_TIER:int = 5;
      
      public var prodID:int;
      
      public var type:int;
      
      public var currencyID:int;
      
      public var parameter:int;
      
      public var valid:Boolean;
      
      public var threshold:int = -1;
      
      public function WarGodRewardObj()
      {
         super();
      }
      
      public static function getRewardListByTierIndex(rewards:Array, tierIndex:int) : Array
      {
         var result:Array = [];
         var startIndex:int = tierIndex * WarGodRewardObj.MAX_REWARD_DELIVERY_PER_TIER;
         var endIndex:int = startIndex + WarGodRewardObj.MAX_REWARD_DELIVERY_PER_TIER;
         for(var i:int = startIndex; i < endIndex; i++)
         {
            if(Boolean(rewards[i].valid))
            {
               result.push(rewards[i]);
            }
         }
         return result;
      }
      
      public static function getTop100Reward(rewards:Array) : Array
      {
         var result:Array = [];
         for(var i:int = 0; i < rewards.length; i++)
         {
            if(Boolean(rewards[i].valid))
            {
               result.push(rewards[i]);
            }
         }
         return result;
      }
   }
}

