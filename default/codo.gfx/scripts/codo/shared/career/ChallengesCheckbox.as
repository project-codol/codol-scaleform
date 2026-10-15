package codo.shared.career
{
   import codo.component.onboarding.OnboardingChallengesCheckbox;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2767")]
   public dynamic class ChallengesCheckbox extends OnboardingChallengesCheckbox
   {
      
      public function ChallengesCheckbox()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,14,this.frame15);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         play();
      }
      
      internal function frame15() : *
      {
         stop();
      }
   }
}

