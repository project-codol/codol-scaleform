package codo.views
{
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.services.OnboardService;
   import components.fsgTrainingComplete_part.FsgTrainingCompleteViewContent;
   import fsg.shared.popups.PopupBaseView;
   
   public class FsgTrainingCompleteView extends PopupBaseView
   {
      
      private var mContent:FsgTrainingCompleteViewContent;
      
      public function FsgTrainingCompleteView()
      {
         super();
         this.mContent = FsgTrainingCompleteViewContent(myContent);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mContent.rewardLaunchCallback = this.showReward;
         this.mContent.setDataProvider(OnboardService.getInstance().getTrainEOGSummary());
         if(this.mContent.numUnlocks > 0)
         {
            listen(BCInGameEvent.EVT_CLOSE_TRAINING_REWARD_VIDEO_POPUP_PAGE,this.onRewardPopupClosed);
         }
         this.broadcast(BCInGameEvent.EVT_SET_PAUSEMENU_TO_CLOSE);
      }
      
      private function showReward() : void
      {
         this.mContent.disableBtns();
         this.broadcast(BCInGameEvent.EVT_SHOW_REWARDS_VIEW_POPUP,this.mContent.numUnlocks);
      }
      
      private function onRewardPopupClosed(cEvt:ParaEvent) : void
      {
         FsgTrainingCompleteViewContent(myContent).reEnableBtns();
         unlisten(BCInGameEvent.EVT_CLOSE_TRAINING_REWARD_VIDEO_POPUP_PAGE,this.onRewardPopupClosed);
      }
   }
}

