package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.UITutorialFlags;
   import codo.utils.ScaleformUtil;
   import codo.views.uitour.UITourAARCrateRewards;
   import codo.views.uitour.UITourAARLevelXPRewards;
   
   public class UITutorialAARView extends UITutorialBaseView
   {
      
      public var myAARLevelXPRewards:UITourAARLevelXPRewards;
      
      public var myAARCrateRewards:UITourAARCrateRewards;
      
      public function UITutorialAARView()
      {
         super();
         mDrawGutter = false;
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(!ScaleformUtil.isScaleform)
         {
            this.myAARCrateRewards.showCrateRewardMission1();
         }
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_AAR_NEW_USER_GP_VIEWED:
               this.myAARLevelXPRewards.showGPReward(this.onNextClick,UITutorialFlags.TOUR_AAR_STEP_SHOW_GP);
         }
      }
      
      private function onNextClick(step:uint) : void
      {
         this.myAARLevelXPRewards.myTopicArrow.reset();
         switch(step)
         {
            case UITutorialFlags.TOUR_AAR_STEP_SHOW_GP:
               this.myAARLevelXPRewards.showXPReward(this.onNextClick,UITutorialFlags.TOUR_AAR_STEP_SHOW_XP);
               this.forwardRewardPresentation(UITutorialFlags.TOUR_AAR_STEP_SHOW_XP);
               break;
            case UITutorialFlags.TOUR_AAR_STEP_SHOW_XP:
               this.myAARLevelXPRewards.assetsAreVisible = false;
               this.forwardRewardPresentation(UITutorialFlags.TOUR_AAR_STEP_SHOW_LEVEL_REWARD,this.onBarLevelAnimationComplete);
               break;
            case UITutorialFlags.TOUR_AAR_STEP_SHOW_LEVEL_REWARD:
               this.myAARLevelXPRewards.hide();
               this.forwardRewardPresentation(UITutorialFlags.TOUR_AAR_STEP_END);
         }
      }
      
      private function onBarLevelAnimationComplete() : void
      {
         this.myAARLevelXPRewards.showLevelUpReward(this.onNextClick,UITutorialFlags.TOUR_AAR_STEP_SHOW_LEVEL_REWARD);
      }
      
      private function forwardRewardPresentation(step:uint, animationInitMethod:Function = null) : void
      {
         broadcast(BCEvent.EVT_MATCH_RESULTS_SHOW_ONBOARDING_REWARDS,{
            "step":step,
            "callback":animationInitMethod
         });
      }
   }
}

