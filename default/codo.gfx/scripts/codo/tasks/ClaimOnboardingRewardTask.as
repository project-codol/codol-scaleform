package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ClaimOnboardingRewardTask extends AsyncTaskBase
   {
      
      public function ClaimOnboardingRewardTask()
      {
         super(DataID.CLAIM_ONBOARDING_REWARD,AsyncTaskGroup.CLAIM_ONBOARDING_REWARD);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionCommonContainer.ClaimOnboardingChecklistReward(this.params.index);
      }
   }
}

