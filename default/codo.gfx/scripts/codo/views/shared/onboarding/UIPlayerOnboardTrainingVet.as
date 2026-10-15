package codo.views.shared.onboarding
{
   import codo.views.uitour.OnboardingExperienceSelectBtn;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5592")]
   public dynamic class UIPlayerOnboardTrainingVet extends OnboardingExperienceSelectBtn
   {
      
      public function UIPlayerOnboardTrainingVet()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,7,this.frame8,13,this.frame14);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         play();
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         gotoAndStop(1);
      }
   }
}

