package codo.objects
{
   public class ZHuntKillZombieRewardObj extends ChallengeRewardObj
   {
      
      public var monsterID:int;
      
      public var partID:int;
      
      public var typeString:String;
      
      public var nameString:String;
      
      public var icon:String;
      
      public var isBossReward:Boolean;
      
      public function ZHuntKillZombieRewardObj(rewardObjComplete:RewardObjComplete, monsterID:int, partID:int, typeString:String, nameString:String, isBossReward:Boolean)
      {
         super();
         type = ChallengeRewardObj.REWARD_TYPE_NONE;
         entityId = 0;
         xp = 0;
         gp = 0;
         claimed = true;
         this.monsterID = monsterID;
         this.partID = partID;
         this.typeString = typeString;
         this.nameString = nameString;
         this.isBossReward = isBossReward;
         if(rewardObjComplete.getType() == RewardObjComplete.REWARD_TYPE_CURRENCY && rewardObjComplete.getId() == CurrencyObj.CURRENCY_GAMEPOINT)
         {
            type = ChallengeRewardObj.REWARD_TYPE_GP;
            entityInfo = rewardObjComplete.getPara();
         }
         else if(rewardObjComplete.getType() == RewardObjComplete.REWARD_TYPE_RENTAL)
         {
            type = ChallengeRewardObj.REWARD_TYPE_PRODUCT;
            entityId = rewardObjComplete.getId();
            entityDuration = rewardObjComplete.getPara();
         }
         else if(rewardObjComplete.getType() == RewardObjComplete.REWARD_TYPE_STACKABLE)
         {
            type = ChallengeRewardObj.REWARD_TYPE_PRODUCT;
            entityId = rewardObjComplete.getId();
            entityInfo = rewardObjComplete.getPara();
         }
      }
   }
}

