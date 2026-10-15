package codo.services
{
   import codo.base.ServiceBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.localization.DictSystem;
   
   public class RewardService extends ServiceBase
   {
      
      private static var _instance:RewardService;
      
      public function RewardService()
      {
         super(ServiceID.REWARD);
      }
      
      public static function getInstance() : RewardService
      {
         if(RewardService._instance == null)
         {
            RewardService._instance = new RewardService();
         }
         return RewardService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.REWARD_CONSUME_SUPPLY_DROP,this.RewardConsumeSupplyDrop);
         this.register(DataID.REWARD_REROLL_CHALLENGE,this.RewardRerollChallenge);
      }
      
      public function RewardConsumeSupplyDrop(params:Object) : void
      {
         if(this.createTask(DataID.REWARD_CONSUME_SUPPLY_DROP,AsyncTaskGroup.REWARD,params))
         {
            this.showMsg(DictSystem.REWARD_CONSUMING_SUPPLY_DROP);
         }
      }
      
      public function RewardRerollChallenge(cParams:Object) : void
      {
         if(this.createTask(DataID.REWARD_REROLL_CHALLENGE,AsyncTaskGroup.REWARD,cParams))
         {
            this.showMsg(DictSystem.REWARD_REROLL_CHALLENGE);
         }
      }
   }
}

