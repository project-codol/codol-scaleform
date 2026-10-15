package codo.shared.onboarding
{
   import codo.component.onboarding.OnboardingChallengesChecklistListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2669")]
   public dynamic class OnboardingChallengesChecklistListItem extends codo.component.onboarding.OnboardingChallengesChecklistListItem
   {
      
      public function OnboardingChallengesChecklistListItem()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

