package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.DictBattleCity;
   import codo.manager.DataManager;
   import codo.objects.AccountObj;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.BattleCityLeagueInfoObj;
   import codo.objects.BattleCityLeagueMatchResultObj;
   import codo.objects.BattleCityLeaguePlayerObj;
   import codo.objects.RewardObjComplete;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   
   public class BattleCityLeagueController extends BaseController
   {
      
      private static const BATTLE_CITY_LEADER_BOARD_SOURCE_TYPE:int = 4;
      
      private static const FRIENDS_LEADERBOARD_OPEN_TYPE:int = 0;
      
      private static const TOP_PLAYER_LEADERBOARD_OPEN_TYPE:int = 2;
      
      private var globalObj:BattleCityLeagueGlobalObj;
      
      private var playerObj:BattleCityLeaguePlayerObj;
      
      private var leagueObj:BattleCityLeagueInfoObj;
      
      private var matchResultObj:BattleCityLeagueMatchResultObj;
      
      private var leaderboardFetched:Boolean = false;
      
      private var awardAnimationIsShown:Boolean = false;
      
      public function BattleCityLeagueController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         addDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ,this.getBattleCityLeagueGlobalObj);
         addDP(DataID.BATTLE_CITY_LEAGUE_PLAYER_OBJ,this.getBattleCityPlayerObj);
         addDP(DataID.BATTLE_CITY_LEAGUE_INFO_OBJ,this.getBattleCityLeagueInfoObj);
         addDP(DataID.BATTLE_CITY_LEAGUE_MATCH_RESULT_OBJ,this.getBattleCityLeagueMatchResultObj);
         addDP(DataID.IS_BATTLE_CITY_LEAGUE_MATCH,this.isBattleCityLeagueMatch);
         addDP(DataID.BATTLE_CITY_LEAGUE_HAS_SUFFICIENT_TICKET,this.hasSufficientTicket);
         listen(BCEvent.EVT_SHOW_BATTLECITY_LEAGUE_AWARD,this.onShowBattleCityLeagueAward);
         listen(BCEvent.EVT_HIDE_BATTLECITY_LEAGUE_AWARD,this.onHideBattleCityLeagueAward);
         listen(BCEvent.EVT_SHOW_BATTLECITY_TICKET_REWARD,this.onShowBattleCityTicketReward);
         listen(BCEvent.EVT_SHOW_BATTLECITY_LEAGUE_REWARD,this.onShowBattleCityLeagueReward);
         listen(BCEvent.EVT_FETCH_BATTLECITY_LEAGUE_LEADERBOARD,this.onFetchBattleCityLeagueLeaderboard);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onRefreshUIAfterInventoryChange);
      }
      
      private function onRefreshUIAfterInventoryChange(evt:ParaEvent) : void
      {
         this.playerObj = null;
      }
      
      private function getBattleCityLeagueGlobalObj() : BattleCityLeagueGlobalObj
      {
         if(this.globalObj == null)
         {
            this.globalObj = CFunctionContainer.AS_GetDMZLeagueGlobalInfo();
         }
         return this.globalObj;
      }
      
      private function getBattleCityPlayerObj() : BattleCityLeaguePlayerObj
      {
         if(this.playerObj == null)
         {
            this.playerObj = CFunctionContainer.AS_GetDMZLeaguePlayerInfo();
         }
         return this.playerObj;
      }
      
      private function getBattleCityLeagueInfoObj() : BattleCityLeagueInfoObj
      {
         if(this.leagueObj == null)
         {
            this.leagueObj = CFunctionContainer.AS_GetDMZCurrentLeagueInfo();
         }
         return this.leagueObj;
      }
      
      private function assembleBattleCityLeagueMatchResultObj() : BattleCityLeagueMatchResultObj
      {
         if(!this.isBattleCityLeagueMatch())
         {
            return null;
         }
         var matchResultObj:BattleCityLeagueMatchResultObj = CFunctionContainer.AS_GetDMZLeagueMatchResult() as BattleCityLeagueMatchResultObj;
         if(matchResultObj.championPointsBeforeMatch != matchResultObj.championPointsAfterMatch)
         {
            return matchResultObj;
         }
         return null;
      }
      
      private function getBattleCityLeagueMatchResultObj() : BattleCityLeagueMatchResultObj
      {
         if(this.matchResultObj == null)
         {
            this.matchResultObj = this.assembleBattleCityLeagueMatchResultObj();
         }
         return this.matchResultObj;
      }
      
      private function hasSufficientTicket() : Boolean
      {
         return CFunctionContainer.AS_HasSuffcientDMZLeagueTicket() as Boolean;
      }
      
      private function isBattleCityLeagueMatch() : Boolean
      {
         return CFunctionContainer.AS_IsDMZLeagueMatch() as Boolean;
      }
      
      public function cppOnLeagueOpenStateChanged() : void
      {
         this.globalObj = null;
         this.playerObj = null;
         this.leagueObj = null;
         this.leaderboardFetched = false;
         broadcast(BCEvent.EVT_BATTLECITY_OPEN_STATE_CHANGE);
      }
      
      public function cppOnValidatingTicket() : void
      {
         showMsg(DictBattleCity.BATTLECITY_LEAGUE_TICKET_VALIDATING);
      }
      
      public function cppOnValidateTicketComplete(success:Boolean) : void
      {
         hideMsg();
         if(!success)
         {
            showMsg(DictBattleCity.BATTLECITY_LEAGUE_TICKET_VALIDATE_FAIL,MsgBtnCount.ONE);
         }
      }
      
      public function cppOnFetchBattleCityLeagueLeaderBoardTop100(success:Boolean, leaderboardData:Object) : void
      {
         if(success)
         {
            setBindData(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_TOP100,leaderboardData);
         }
         this.fetchLeaderboardFriend();
      }
      
      public function cppOnFetchBattleCityLeagueLeaderBoardFriend(success:Boolean, leaderboardData:Object) : void
      {
         if(success)
         {
            setBindData(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_FRIEND,leaderboardData);
         }
      }
      
      private function onShowBattleCityLeagueAward(evt:ParaEvent) : void
      {
         var matchResult:BattleCityLeagueMatchResultObj = getDP(DataID.BATTLE_CITY_LEAGUE_MATCH_RESULT_OBJ);
         if(Boolean(matchResult))
         {
            this.awardAnimationIsShown = true;
            broadcast(BCEvent.EVT_PLAY_BATTLECITY_LEAGUE_AWARD_ANIMATION,matchResult);
         }
      }
      
      private function onHideBattleCityLeagueAward(evt:ParaEvent) : void
      {
         this.awardAnimationIsShown = false;
         broadcast(BCEvent.EVT_SHOW_BATTLECITY_TICKET_REWARD);
      }
      
      private function showBattleCityTicketRewardPopup(freeTicketAmount:int, battleTicketAmount:int) : void
      {
         var freeTicketRewardObj:RewardObjComplete = null;
         var remainTicket:int = 0;
         var description:String = null;
         var battleTicketRewardObj:RewardObjComplete = null;
         if(freeTicketAmount > 0)
         {
            freeTicketRewardObj = new RewardObjComplete(RewardObjComplete.REWARD_TYPE_CURRENCY,MarketMenuData.CURRENCY_BCL_FREE,freeTicketAmount,DictBattleCity.BATTLECITY_EXTRA_REWARD,DictBattleCity.BATTLECITY_FREE_TICKET_REWARD_DESCRIPTION);
            broadcast(BCEvent.EVT_GOTO_SHOW_REWARD_POPUP,freeTicketRewardObj);
         }
         if(battleTicketAmount > 0)
         {
            remainTicket = this.getBattleCityLeagueGlobalObj().battleTicketWeeklyWinLimit - this.getBattleCityPlayerObj().battleTicketGottenThisWeek;
            description = LocalizeUtil.param(DictBattleCity.BATTLECITY_BATTLE_TICKET_REWARD_DESCRIPTION,[String(remainTicket)]);
            battleTicketRewardObj = new RewardObjComplete(RewardObjComplete.REWARD_TYPE_CURRENCY,MarketMenuData.CURRENCY_BCL_BATTLE,battleTicketAmount,DictBattleCity.BATTLECITY_EXTRA_REWARD,description);
            broadcast(BCEvent.EVT_GOTO_SHOW_REWARD_POPUP,battleTicketRewardObj);
         }
         Logger.print("BattleCityLeagueController::showBattleCityTicketRewardPopup freeticketAmount:" + freeTicketAmount + " battleticketAmount:" + battleTicketAmount);
      }
      
      private function bindAccountInfo(cResult:Object) : void
      {
         DataManager.getInstance().unbind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         var accountInfoAfterMatch:AccountObj = new AccountObj(cResult.data);
         var ticketsBeforeMatch:Object = CFunctionContainer.AS_GetDMZLeagueTicketsBeforeMatch();
         var freeTicketAmount:int = accountInfoAfterMatch.dmzlFreeTicket - ticketsBeforeMatch.freeTicket;
         var battleTicketAmount:int = accountInfoAfterMatch.dmzlBattleTicket - ticketsBeforeMatch.battleTicket;
         this.showBattleCityTicketRewardPopup(freeTicketAmount,battleTicketAmount);
      }
      
      private function onShowBattleCityTicketReward(evt:ParaEvent) : void
      {
         var tickets:Array = null;
         var freeTicketAmount:int = 0;
         var battleTicketAmount:int = 0;
         if(this.awardAnimationIsShown)
         {
            return;
         }
         var ticketStatus:String = CFunctionCommonContainer.Dvar_GetString("ui_dmzl_t");
         if(ticketStatus.length > 0)
         {
            tickets = ticketStatus.split("|");
            freeTicketAmount = int(tickets[0]);
            battleTicketAmount = int(tickets[1]);
            this.showBattleCityTicketRewardPopup(freeTicketAmount,battleTicketAmount);
            CFunctionContainer.AS_ResetBattleCityMatchTicketStatus();
         }
         else
         {
            Logger.print("BattleCityLeagueController::onShowBattleCityTicketReward No ui_dmzl_t dvar set, check ticket count before match.");
            DataManager.getInstance().bind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         }
      }
      
      private function onShowBattleCityLeagueReward(evt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_BATTLECITY_LEAGUE);
      }
      
      private function onFetchBattleCityLeagueLeaderboard(evt:ParaEvent) : void
      {
         if(this.leaderboardFetched)
         {
            return;
         }
         this.leaderboardFetched = true;
         this.fetchLeaderBoardTop100();
      }
      
      private function fetchLeaderBoardTop100() : void
      {
         var leagueInfo:BattleCityLeagueInfoObj = this.getBattleCityLeagueInfoObj();
         if(leagueInfo == null)
         {
            return;
         }
         var param:Object = {
            "name":leagueInfo.lbName,
            "page":0,
            "size":100,
            "sourceType":BATTLE_CITY_LEADER_BOARD_SOURCE_TYPE,
            "openMode":TOP_PLAYER_LEADERBOARD_OPEN_TYPE,
            "mustHave":true
         };
         broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,param);
      }
      
      private function fetchLeaderboardFriend() : void
      {
         var leagueInfo:BattleCityLeagueInfoObj = this.getBattleCityLeagueInfoObj();
         if(leagueInfo == null)
         {
            return;
         }
         var param:Object = {
            "name":leagueInfo.lbName,
            "page":0,
            "size":100,
            "sourceType":BATTLE_CITY_LEADER_BOARD_SOURCE_TYPE,
            "openMode":FRIENDS_LEADERBOARD_OPEN_TYPE,
            "mustHave":true
         };
         broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,param);
      }
   }
}

