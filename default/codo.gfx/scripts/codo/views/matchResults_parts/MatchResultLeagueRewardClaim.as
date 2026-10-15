package codo.views.matchResults_parts
{
   import codo.base.BaseSubElement;
   import codo.constants.DataID;
   import codo.localization.DictBattleCity;
   import codo.objects.BattleCityLeaguePlayerObj;
   import codo.objects.RewardObjComplete;
   import codo.views.battlecity_parts.BattleCityRewardProgress;
   import flash.text.TextField;
   
   public class MatchResultLeagueRewardClaim extends BaseSubElement
   {
      
      public var myTitle:TextField;
      
      public var myLeagueRewardProgress:BattleCityRewardProgress;
      
      public var myCarte:MatchResultLeagueRewardClaimButton;
      
      private var mCarteClickHandler:Function;
      
      public function MatchResultLeagueRewardClaim()
      {
         super();
      }
      
      override public function active() : void
      {
         super.active();
         this.myTitle.text = DictBattleCity.BATTLECITY_LEAGUE_REWARD_INFO;
         var playerObj:BattleCityLeaguePlayerObj = getDP(DataID.BATTLE_CITY_LEAGUE_PLAYER_OBJ);
         this.myLeagueRewardProgress.setProgress(playerObj.rewardCurrentProgress,playerObj.rewardFullProgress);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.myCarte.unRegisterClickEvent(this.onCarteClicked);
      }
      
      public function setReward(reward:RewardObjComplete) : void
      {
         if(null != reward)
         {
            this.myTitle.visible = true;
            this.myCarte.toggleReward(true);
            this.myCarte.registerClickEvent(this.onCarteClicked);
         }
         else
         {
            this.myTitle.visible = false;
            this.myCarte.toggleReward(false);
            this.myCarte.unRegisterClickEvent(this.onCarteClicked);
         }
      }
      
      public function registerCarteClickHandler(handler:Function) : void
      {
         this.mCarteClickHandler = handler;
      }
      
      private function onCarteClicked() : void
      {
         if(this.mCarteClickHandler != null)
         {
            this.mCarteClickHandler();
            this.myCarte.toggleReward(false);
            this.myCarte.unRegisterClickEvent(this.onCarteClicked);
         }
      }
   }
}

