package codo.objects
{
   public class TDRewardObj extends ChallengeRewardObj
   {
      
      private const REWARD_NAMES:Array = ["","@SF_UI_TD_REWARD_NAME_COPPER","@SF_UI_TD_REWARD_NAME_SILVER","@SF_UI_TD_REWARD_NAME_GOLD","@SF_UI_TD_REWARD_NAME_RARE"];
      
      public var rewardName:String;
      
      public function TDRewardObj()
      {
         super();
      }
      
      public function setupReward(rewardType:int, rewardParam:int) : void
      {
         if(rewardType == RewardObjComplete.REWARD_TYPE_CURRENCY)
         {
            type = ChallengeRewardObj.REWARD_TYPE_GP;
            entityInfo = rewardParam;
         }
         else if(rewardType == RewardObjComplete.REWARD_TYPE_RENTAL)
         {
            type = ChallengeRewardObj.REWARD_TYPE_PRODUCT;
            entityDuration = rewardParam;
         }
         else if(rewardType == RewardObjComplete.REWARD_TYPE_STACKABLE)
         {
            type = ChallengeRewardObj.REWARD_TYPE_PRODUCT;
            entityInfo = rewardParam;
         }
      }
      
      public function set chestID(id:int) : void
      {
         this.rewardName = this.REWARD_NAMES[id];
      }
   }
}

