package components.fsgTrainingComplete_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictCoopSummary;
   import codo.localization.DictOnBoard;
   import codo.objects.FsgTrainingSummaryObj;
   import flash.text.TextField;
   import fsg.shared.popups.PopupContentBase;
   
   public class FsgTrainingCompleteViewContent extends PopupContentBase
   {
      
      public var myLabelStatNamesTF:TextField;
      
      public var myLabelThisRoundTF:TextField;
      
      public var myLabelPointsTF:TextField;
      
      public var myTrainingStarBar:FsgTrainingStarBar;
      
      public var myTrainingStatList:FsgCombinedStatBarPanel;
      
      public var numUnlocks:uint = 0;
      
      private var mLaunchRewardCallback:Function;
      
      private var mFinalStarCount:int = 0;
      
      public function FsgTrainingCompleteViewContent()
      {
         super();
      }
      
      override protected function configPopUpBase() : void
      {
         super.configPopUpBase();
         this.myLabelStatNamesTF.text = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_RESULTS_TRAINING_STATISTICS).toUpperCase();
         this.myLabelThisRoundTF.text = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_RESULTS_THIS_ROUND).toUpperCase();
         this.myLabelPointsTF.text = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_RESULTS_POINTS).toUpperCase();
         myPopupBase.headerText = LOCALIZE(DictCoopSummary.TRAINING_COMPLETE).toUpperCase();
         myPopupBase.subheaderText = LOCALIZE(DictOnBoard.ONBOARD_TRAINING_COMPLETE_DESC).toUpperCase();
         myPopupBase.animateFrame = true;
         this.myTrainingStatList.onCompleteCallback = this.onStatComplete;
      }
      
      public function set rewardLaunchCallback(callback:Function) : void
      {
         this.mLaunchRewardCallback = callback;
      }
      
      private function onNextBtnClickCallback() : void
      {
         this.broadcast(BCInGameEvent.EVT_SHOW_REWARDS_VIEW,this.mFinalStarCount);
      }
      
      private function onFinishClicked() : void
      {
         this.broadcast(BCInGameEvent.TRAINING_SKIP);
      }
      
      private function onTryAgainBtnClick() : void
      {
         this.broadcast(BCInGameEvent.TRAINING_TRY_AGAIN);
      }
      
      public function setDataProvider(data:Vector.<FsgTrainingSummaryObj>) : void
      {
         var SUMMARY_STAT_ACCURACY:uint = 0;
         var SUMMARY_STAT_TIME:uint = 1;
         var SUMMARY_STAT_TARGETS:uint = 2;
         var SUMMARY_STAT_FINAL_SCORE:uint = 3;
         var prevStars:uint = uint(data[SUMMARY_STAT_FINAL_SCORE].prevBestStar);
         var currStars:uint = uint(data[SUMMARY_STAT_FINAL_SCORE].star);
         this.mFinalStarCount = Math.max(prevStars,currStars);
         this.numUnlocks = this.getUnlockNum(currStars);
         this.myTrainingStarBar.setData(data[SUMMARY_STAT_FINAL_SCORE]);
         this.myTrainingStatList.setup(data[SUMMARY_STAT_ACCURACY],data[SUMMARY_STAT_TIME],data[SUMMARY_STAT_TARGETS]);
         this.myTrainingStatList.start();
         myPopupBase.configAuxiliaryButton(DictCoopSummary.UI_PLAY_AGAIN,this.onTryAgainBtnClick);
         myPopupBase.configCancelButton(DictCoopSummary.TRAINING_REWARD,this.onNextBtnClickCallback);
         myPopupBase.configConfirmButton(LOCALIZE(DictOnBoard.ONBOARD_TRAINING_FINISH).toUpperCase(),this.onFinishClicked);
         if(CFunctionCommonContainer.Dvar_GetString("last_played_map") == "coop_training_mp_killhouse_full")
         {
            this.numUnlocks = 0;
            return;
         }
         if(this.numUnlocks > 0)
         {
            this.disableBtns();
         }
      }
      
      public function reEnableBtns() : void
      {
         myPopupBase.confirmButtonRef.setEnabled(true);
         myPopupBase.cancelButtonRef.setEnabled(true);
         myPopupBase.auxiliaryButtonRef.setEnabled(true);
         myPopupBase.auxiliaryButtonRef.visible = myPopupBase.cancelButtonRef.visible = myPopupBase.confirmButtonRef.visible = true;
      }
      
      public function disableBtns() : void
      {
         myPopupBase.confirmButtonRef.setEnabled(false);
         myPopupBase.cancelButtonRef.setEnabled(false);
         myPopupBase.auxiliaryButtonRef.setEnabled(false);
         myPopupBase.auxiliaryButtonRef.visible = myPopupBase.cancelButtonRef.visible = myPopupBase.confirmButtonRef.visible = false;
      }
      
      private function onStatComplete(total:Number) : void
      {
         if(this.numUnlocks == 0)
         {
            return;
         }
         this.myTrainingStarBar.start();
         this.myTrainingStarBar.addEventListener(FsgTrainingStarBar.EVT_STAR_AWARDED,this.onStarAwardComplete);
      }
      
      private function onStarAwardComplete(cEvt:ParaEvent) : void
      {
         this.removeEventListener(FsgTrainingStarBar.EVT_STAR_AWARDED,this.onStarAwardComplete);
         this.mLaunchRewardCallback();
      }
      
      private function getUnlockNum(stars:uint) : uint
      {
         if(stars > 0 && stars < 3)
         {
            return 1;
         }
         if(stars > 2 && stars < 5)
         {
            return 2;
         }
         if(stars == 5)
         {
            return 3;
         }
         return 0;
      }
   }
}

