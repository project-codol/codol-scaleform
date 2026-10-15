package codo.views
{
   import codo.base.BaseView;
   import codo.component.ViewPanelBase;
   import codo.component.navigation.SubNavTabBar;
   import codo.localization.Dict;
   import codo.localization.DictChallenge;
   import codo.services.ChallengeService;
   import codo.utils.LocalizeUtil;
   import codo.views.career_parts.CareerChallengesPanel;
   import codo.views.career_parts.CareerDailyChallengePanel;
   
   public class CareerChallengesView extends BaseView
   {
      
      public var mySubNavTabBar:SubNavTabBar;
      
      public var myDailyWeeklyPanel:CareerDailyChallengePanel;
      
      public var myCareerChallengesPanel:CareerChallengesPanel;
      
      private var mPanels:Vector.<ViewPanelBase>;
      
      private var mCurPanel:ViewPanelBase;
      
      public function CareerChallengesView()
      {
         super();
         this.mPanels = new Vector.<ViewPanelBase>();
         this.mPanels.push(this.myDailyWeeklyPanel);
         this.mPanels.push(this.myCareerChallengesPanel);
         var isOnboarding:Boolean = isDebugMode ? true : ChallengeService.getInstance().showOnboardingChecklist;
         var LOCALIZE:Function = LocalizeUtil.localize;
         var tabLabel:String = isOnboarding ? Dict.ONBOARDING_CHECKLIST : Dict.CHALLENGES_CHECKLIST;
         this.mySubNavTabBar.addTab(isDebugMode ? "TRAINING CHECKLIST" : LOCALIZE(tabLabel));
         tabLabel = isDebugMode ? "CAREER" : LOCALIZE(DictChallenge.CHALLENGES_CAREER);
         this.mySubNavTabBar.addTab(tabLabel);
         this.mySubNavTabBar.init(this.onTabClicked);
         this.mCurPanel = this.myDailyWeeklyPanel;
         this.mySubNavTabBar.setSelectedTab(0);
      }
      
      private function onTabClicked(index:int) : void
      {
         if(this.mPanels[index] == this.mCurPanel)
         {
            return;
         }
         this.mCurPanel.hidePanel();
         this.mCurPanel = this.mPanels[index];
         this.mCurPanel.showPanel();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mCurPanel.showPanel();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mCurPanel.hidePanel();
      }
   }
}

