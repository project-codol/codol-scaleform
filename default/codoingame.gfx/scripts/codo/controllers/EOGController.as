package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataCommonID;
   import codo.constants.DataInGameID;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.manager.PageInGameManager;
   import codo.services.OnboardService;
   import codo.utils.ScaleformUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class EOGController extends BaseController
   {
      
      private var _isShowingCoopSpecEOG:Boolean = false;
      
      private var _isTryAgainAllowed:Boolean = false;
      
      public function EOGController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         var timer:Timer = null;
         if(!ScaleformUtil.isScaleform)
         {
            timer = new Timer(2000,1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompleteHandle);
            timer.start();
         }
         this.addDP(DataCommonID.IS_CQB_PLAYING,this.isCQBPlaying);
         this.addDP(DataInGameID.COOP_SPEC_EOG_SUMMARY,this.getCoopEOGSummary);
         this.addDP(DataInGameID.TRAIN_EOG_SUMMARY,OnboardService.getInstance().getTrainEOGSummary);
         this.listen(BCInGameEvent.BACK_TO_ROOM,this.onBackToLobbyMenuHandle);
         this.listen(BCInGameEvent.BACK_TO_SPEC_OPS_MENU,this.onBackToSpecOpsMenuHandle);
         this.listen(BCInGameEvent.TRY_CURRENT_LEVEL_AGAIN,this.onTryAgainHandle);
         this.listen(BCInGameEvent.TRAINING_SKIP,this.onTrainSkipHandle);
         this.listen(BCInGameEvent.TRAINING_TRY_AGAIN,this.onTrainTryAgainHandle);
         this.listen(BCInGameEvent.EVT_SHOW_REWARDS_VIEW,this.onShowRewardsView);
         this.listen(BCInGameEvent.EVT_SHOW_REWARDS_VIEW_POPUP,this.onShowRewardsViewPopup);
         this.listen(BCInGameEvent.EVT_CLOSE_TRAINING_REWARD_VIDEO_POPUP_PAGE,this.closeTrainingRewardsVideoPopup);
      }
      
      public function openCoopSpecEOG(show:Boolean = true) : void
      {
      }
      
      public function openTrainEOG(show:Boolean = true) : void
      {
         this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,show);
         if(show)
         {
            PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_RETRY_TRAINING);
         }
         else
         {
            PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_RETRY_TRAINING.owner);
         }
      }
      
      override public function update(deltaTime:Number) : void
      {
         var allow:Boolean = false;
         if(this._isShowingCoopSpecEOG)
         {
            allow = this.allowRestart();
            if(this._isTryAgainAllowed != allow)
            {
               this._isTryAgainAllowed = allow;
               this.broadcast(BCInGameEvent.SET_TRY_AGAIN_STATE,allow);
            }
         }
      }
      
      private function getCoopEOGSummary() : Object
      {
         var time:String = CFunctionCommonContainer.Dvar_GetString("elapsed_mission_time");
         var kills:int = this.getDvarInt("player_1_kills");
         var difficulty:String = CFunctionCommonContainer.Dvar_GetString("player_1_difficulty");
         var success:Boolean = this.getDvarBool("ui_mission_success");
         var solo:Boolean = this.getDvarBool("solo_play");
         var partnerKills:int = solo ? 0 : this.getDvarInt("player_2_kills");
         this._isTryAgainAllowed = this.allowRestart();
         var canPlay:Boolean = !this.belowExpected() && this._isTryAgainAllowed;
         var quote:String = "";
         if(!success)
         {
            quote = CFunctionCommonContainer.Dvar_GetString("ui_deadquote");
         }
         return {
            "success":success,
            "time":time,
            "kills":kills,
            "difficulty":difficulty,
            "quote":quote,
            "solo":solo,
            "partnerKills":partnerKills,
            "canPlay":canPlay
         };
      }
      
      private function closeTrainingRewardsVideoPopup(cEvt:ParaEvent) : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_TRAINING_REWARDS_POPUP.owner);
      }
      
      private function onShowRewardsViewPopup(cEvt:ParaEvent) : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TRAINING_REWARDS_POPUP,false,ViewState.ACTIVATED,cEvt.myPara as int);
      }
      
      private function onShowRewardsView(cEvt:ParaEvent) : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_TRAINING_REWARDS,false,ViewState.ACTIVATED,cEvt.myPara as int);
      }
      
      private function onBackToLobbyMenuHandle(cEvt:ParaEvent) : void
      {
         this.pauseGame(false);
         this.openCoopSpecEOG(false);
         CFunctionCommonContainer.execnow("disconnectwithkeepsession");
      }
      
      private function onBackToSpecOpsMenuHandle(cEvt:ParaEvent) : void
      {
         this.pauseGame(false);
         this.backToMainMenu();
         this.openCoopSpecEOG(false);
      }
      
      private function onTryAgainHandle(cEvt:ParaEvent) : void
      {
         var belowExpected:Boolean = this.belowExpected();
         if(belowExpected || !this._isTryAgainAllowed)
         {
            return;
         }
         this.pauseGame(false);
         this.tryAgain();
         this.openCoopSpecEOG(false);
      }
      
      private function onTrainSkipHandle(cEvt:ParaEvent) : void
      {
         this.pauseGame(false);
         this.backToMainMenu();
         this.openTrainEOG(false);
      }
      
      private function onTrainTryAgainHandle(cEvt:ParaEvent) : void
      {
         this.broadcast(BCInGameEvent.RELOAD_CHARACTER_LOADOUT);
         this.pauseGame(false);
         this.openTrainEOG(false);
         CFunctionCommonContainer.ScriptMenuResponse("class","back");
         this.broadcast(BCInGameEvent.BACK_TO_GAME);
      }
      
      private function onTimerCompleteHandle(cEvt:TimerEvent) : void
      {
      }
      
      private function isCQBPlaying() : Boolean
      {
         return this.getDvarBool("ui_cqb_playing");
      }
      
      private function backToMainMenu() : void
      {
         CFunctionCommonContainer.execnow("disconnect");
      }
      
      private function tryAgain() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("coop_eog_summary","map_restart");
      }
      
      private function trainTryAgain() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("popup_retry","retry");
      }
      
      private function pauseGame(pause:Boolean) : void
      {
         CFunctionCommonContainer.setdvar("cl_paused",pause ? "1" : "0");
      }
      
      private function belowExpected() : Boolean
      {
         return this.getDvarBool("below_expected_clients");
      }
      
      private function allowRestart() : Boolean
      {
         return this.getDvarBool("ui_allow_coop_restart");
      }
   }
}

