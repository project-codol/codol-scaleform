package codo.views
{
   import codo.base.BaseView;
   import codo.constants.PageID;
   import codo.constants.UITourVOSoundAliases;
   import codo.cpp.UiCppOnboarding;
   import codo.views.uitour.UIPlayerOnboardTrainingIntro;
   
   public class PlayerOnboardTrainingIntroView extends BaseView
   {
      
      public var myOnboardTrainingIntro:UIPlayerOnboardTrainingIntro;
      
      public var _tempIsExperienceSelect:Boolean;
      
      public function PlayerOnboardTrainingIntroView()
      {
         super();
         this.myOnboardTrainingIntro.hide();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this._tempIsExperienceSelect = pageID == PageID.ONBOARDING_EXPERIENCE_SELECT || isDebugMode;
         this.myOnboardTrainingIntro.tempInitExperienceSelect(this._tempIsExperienceSelect);
         if(!this._tempIsExperienceSelect)
         {
            playSound(UITourVOSoundAliases.START_TRAINING_TF141_NUKETOWN);
         }
         this.myOnboardTrainingIntro.registerCallToActionEvent(this.onLaunchTrainingMission);
         this.myOnboardTrainingIntro.show();
      }
      
      private function onLaunchTrainingMission() : void
      {
         if(this._tempIsExperienceSelect)
         {
            UiCppOnboarding.instance.FinishExperienceStep(false);
            return;
         }
         UiCppOnboarding.instance.FinishTutorialIntroStep(false);
      }
   }
}

