package codo.views.battlecity_parts
{
   import codo.constants.DataID;
   import codo.localization.DictBattleCity;
   import codo.manager.DataManager;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.BattleCityLeaguePlayerObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.BehaviourTooltip;
   
   public class BattleCityModeInfoLeagueAddon extends MovieClip
   {
      
      private static const DES_HAS_WARNING_Y:int = 125;
      
      private static const DES_NO_WARNING_Y:int = 103;
      
      private static const GAP:int = 10;
      
      public var myTitleTF:TextField;
      
      public var myFreeTicketCountTF:TextField;
      
      public var myBattleTicketCountTF:TextField;
      
      public var myNoMoreBattleTicketTF:TextField;
      
      public var myDescriptionTF:TextField;
      
      public var myFreeTicketIcon:MovieClip;
      
      public var myBattleTicketIcon:MovieClip;
      
      public var myChampionPointLabel:TextField;
      
      public var myChampionPointValue:TextField;
      
      public var myLeaderboardLabel:TextField;
      
      public var myLeaderboardValue:TextField;
      
      public var myStartMatchHintTF:TextField;
      
      public var myRewardProgress:BattleCityRewardProgress;
      
      private var mFreeTicketToolTipBehaviour:BehaviourTooltip;
      
      private var mBattleTicketToolTipBehaviour:BehaviourTooltip;
      
      public function BattleCityModeInfoLeagueAddon()
      {
         super();
         this.mFreeTicketToolTipBehaviour = this.addToolTip(this.myFreeTicketIcon,DictBattleCity.BATTLECITY_FREE_TICKET_NAME);
         this.mBattleTicketToolTipBehaviour = this.addToolTip(this.myBattleTicketIcon,DictBattleCity.BATTLECITY_BATTLE_TICKET_NAME);
         this.myStartMatchHintTF.text = DictBattleCity.BATTLECITY_TICKET_RULE;
         this.myChampionPointLabel.text = DictBattleCity.BATTLECITY_CHAMPION_POINTS_LABEL;
         this.myLeaderboardLabel.text = DictBattleCity.BATTLECITY_LEADERBOARD_LABEL;
         this.myNoMoreBattleTicketTF.text = DictBattleCity.BATTLECITY_NO_MORE_BATTLE_TICKET_LABEL;
         this.myLeaderboardLabel.visible = false;
         this.myLeaderboardValue.visible = false;
      }
      
      public function set title(value:String) : void
      {
         this.myTitleTF.text = value;
      }
      
      public function set description(value:String) : void
      {
         this.myDescriptionTF.text = value;
      }
      
      public function set rule(value:String) : void
      {
         this.myStartMatchHintTF.text = value;
      }
      
      public function setTicketCount(freeTicket:int, freeTicketHoldLimit:int, battleTicket:int, battleTicketHoldLimit:int) : void
      {
         this.myFreeTicketCountTF.text = String(freeTicket) + "/" + String(freeTicketHoldLimit);
         this.myBattleTicketCountTF.text = String(battleTicket) + "/" + String(battleTicketHoldLimit);
         this.myFreeTicketIcon.x = 0;
         this.myFreeTicketCountTF.x = this.myFreeTicketIcon.x + this.myFreeTicketIcon.width + GAP;
         this.myBattleTicketIcon.x = this.myFreeTicketCountTF.x + this.myFreeTicketCountTF.textWidth + GAP;
         this.myBattleTicketCountTF.x = this.myBattleTicketIcon.x + this.myBattleTicketIcon.width + GAP;
      }
      
      public function loadPlayerInfo() : void
      {
         var playerObj:BattleCityLeaguePlayerObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_PLAYER_OBJ);
         var globalObj:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         this.setChampionPoint(playerObj.championPoints);
         this.myRewardProgress.setProgress(playerObj.rewardCurrentProgress,playerObj.rewardFullProgress);
         this.myRewardProgress.setBoxNumber(playerObj.numRewardGotten + 1);
         this.switchWarningInfo(playerObj.battleTicketGottenThisWeek >= globalObj.battleTicketHoldLimit);
      }
      
      public function setChampionPoint(points:int) : void
      {
         this.myChampionPointValue.text = String(points);
         this.adjustLabelPositions();
      }
      
      public function setRank(rank:int) : void
      {
         this.myLeaderboardLabel.visible = true;
         if(rank > 0)
         {
            this.myLeaderboardLabel.text = LocalizeUtil.localize(DictBattleCity.BATTLECITY_LEADERBOARD_LABEL);
            this.myLeaderboardValue.text = String(rank);
            this.myLeaderboardValue.visible = true;
         }
         else
         {
            this.myLeaderboardLabel.text = LocalizeUtil.localize(DictBattleCity.BATTLECITY_LEADERBOARD_LABEL) + " " + LocalizeUtil.localize(DictBattleCity.BATTLECITY_NO_LEADERBOARD_RANK);
            this.myLeaderboardValue.visible = false;
         }
         this.adjustLabelPositions();
      }
      
      private function adjustLabelPositions() : void
      {
         this.myChampionPointLabel.x = 0;
         this.myChampionPointValue.x = this.myChampionPointLabel.x + this.myChampionPointLabel.textWidth + GAP;
         this.myLeaderboardLabel.x = this.myChampionPointValue.x + this.myChampionPointValue.textWidth + GAP;
         this.myLeaderboardValue.x = this.myLeaderboardLabel.x + this.myLeaderboardLabel.textWidth + GAP;
      }
      
      private function addToolTip(target:MovieClip, tooltip:String) : BehaviourTooltip
      {
         var clickableBehaviour:BehaviourClickable = new BehaviourClickable(target);
         return new BehaviourTooltip(clickableBehaviour,tooltip,target);
      }
      
      private function switchWarningInfo(show:Boolean) : void
      {
         this.myNoMoreBattleTicketTF.visible = show;
         this.myDescriptionTF.y = show ? DES_HAS_WARNING_Y : DES_NO_WARNING_Y;
      }
   }
}

