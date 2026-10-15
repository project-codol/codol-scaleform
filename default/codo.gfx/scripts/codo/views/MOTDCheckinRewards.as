package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.component.LoadingSpinner;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.UIAnimScheduleFlag;
   import codo.constants.UIViewerAnimType;
   import codo.event.ParaEvent;
   import codo.localization.DictMOTD;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.utils.TLogUtil;
   import codo.views.motd_parts.MOTDCheckinRewardsContent;
   import codo.views.persistentView_parts.GameOptionBtn;
   
   public class MOTDCheckinRewards extends BaseView
   {
      
      public var myContent:MOTDCheckinRewardsContent;
      
      public var myLoadingSpinner:LoadingSpinner;
      
      public var myQuitBtn:GameOptionBtn;
      
      public var myOptionBtn:GameOptionBtn;
      
      private var mAllRewardsEarned:Boolean = false;
      
      public function MOTDCheckinRewards()
      {
         super();
         this.myContent.myBackButton.registerClickEvent(this.onBackButtonClicked);
         this.myQuitBtn.addClickCallback(this.onQuit,"ui_exitgame_button_click_01");
         this.myOptionBtn.addClickCallback(this.onDisplayOptions,"ui_settingsgear_button_click_01");
         this.myLoadingSpinner.visible = false;
      }
      
      private function onQuit() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_EXIT_GAME);
         this.broadcast(BCEvent.TRYOPEN_QUESTIONNAIRE);
      }
      
      private function onDisplayOptions() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SETTINGS);
         this.broadcast(BCEvent.EVT_GOTO_OPTION);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myContent.active();
         listen(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
         playSound("ui_dailyrewards_menu_entered_01");
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myContent.deactive();
         unlisten(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
         this.myLoadingSpinner.visible = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         var rewards:Vector.<MOTDCheckinRewardObj> = getDP(DataID.CHECKIN_REWARDS);
         this.mAllRewardsEarned = this.myContent.setData(rewards);
         this.myContent.title = this.mAllRewardsEarned ? DictMOTD.CHECKIN_REWARDS_COMPLETE_TITLE : DictMOTD.CHECKIN_REWARDS_PENDING_TITLE;
         if(!this.mAllRewardsEarned)
         {
            this.myContent.showNextItemIcon();
         }
      }
      
      protected function onBackButtonClicked() : void
      {
         broadcast(BCEvent.GOTO_PREV_MAIN_PAGE);
      }
      
      private function onUiViewerModelLoadStateUpdate(e:ParaEvent) : void
      {
         var isLoading:Boolean = false;
         isLoading = e.myPara;
         this.myLoadingSpinner.visible = isLoading;
         if(!isLoading)
         {
            if(this.myContent.mReceivedDaily)
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimDailyReceive,UIAnimScheduleFlag.NO_BLEND_IN);
            }
            else if(this.mAllRewardsEarned)
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimDailyExhausted,UIAnimScheduleFlag.NO_BLEND_IN);
            }
            else
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimDailyReturn,UIAnimScheduleFlag.NO_BLEND_IN);
            }
         }
      }
   }
}

