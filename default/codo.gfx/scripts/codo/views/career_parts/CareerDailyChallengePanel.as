package codo.views.career_parts
{
   import codo.component.ViewPanelBase;
   import codo.component.career.ChallengeChecklist;
   import codo.component.onboarding.OnboardingChallengeChecklist;
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.services.ChallengeService;
   
   public class CareerDailyChallengePanel extends ViewPanelBase
   {
      
      public var myChecklistPanel:OnboardingChallengeChecklist;
      
      public var myChallengeChecklist:ChallengeChecklist;
      
      public function CareerDailyChallengePanel()
      {
         super();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         EventManager.getInstance().listen(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
         this.refreshChallenges();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().unlisten(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
      }
      
      private function refreshChallenges() : void
      {
         var isOnboarding:Boolean = ChallengeService.getInstance().showOnboardingChecklist;
         if(isOnboarding)
         {
            gotoAndStop(2);
            this.myChecklistPanel.setData(ChallengeService.getInstance().GetOnboardingChecklist());
         }
         else
         {
            gotoAndStop(1);
            this.myChallengeChecklist.setData(ChallengeService.getInstance().GetChallengeChecklist(),false);
         }
      }
   }
}

