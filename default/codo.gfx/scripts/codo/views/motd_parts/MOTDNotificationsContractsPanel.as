package codo.views.motd_parts
{
   import codo.base.BaseSubElement;
   import codo.component.TextField;
   import codo.component.career.ChallengeChecklist;
   import codo.component.onboarding.OnboardingChallengeChecklist;
   import codo.constants.BCEvent;
   import codo.localization.Dict;
   import codo.services.ChallengeService;
   import codo.style.MOTDGuide;
   import codo.utils.LocalizeUtil;
   
   public class MOTDNotificationsContractsPanel extends BaseSubElement
   {
      
      public var myHeader:TextField;
      
      public var myChallengeChecklist:ChallengeChecklist;
      
      public var myChecklistPanel:OnboardingChallengeChecklist;
      
      private var mIsOnboarding:Boolean;
      
      public function MOTDNotificationsContractsPanel()
      {
         super();
         this.myHeader.textStyle = MOTDGuide.styleMOTDTitle;
         this.myHeader.width = 871;
         this.myChecklistPanel.myLabel.visible = false;
      }
      
      override public function active() : void
      {
         super.active();
         this.refreshChallenges();
         listen(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unlisten(BCEvent.EVT_REFRESH_CHALLENGES,this.refreshChallenges);
      }
      
      public function set isOnboarding(value:Boolean) : void
      {
         this.mIsOnboarding = value;
      }
      
      private function updateChallengesGrid() : void
      {
         this.myChallengeChecklist.setData(ChallengeService.getInstance().GetChallengeChecklist(),false);
      }
      
      private function refreshChallenges() : void
      {
         if(this.mIsOnboarding)
         {
            this.myChecklistPanel.useSmallRenderer = true;
            this.myChecklistPanel.setData(ChallengeService.getInstance().GetOnboardingChecklist());
            this.myChecklistPanel.visible = true;
            this.myHeader.text = LocalizeUtil.localize(Dict.ONBOARDING_CHECKLIST);
         }
         else
         {
            this.myChecklistPanel.visible = false;
            this.myHeader.text = LocalizeUtil.localize(Dict.CHALLENGES_CHECKLIST);
            this.updateChallengesGrid();
         }
      }
   }
}

