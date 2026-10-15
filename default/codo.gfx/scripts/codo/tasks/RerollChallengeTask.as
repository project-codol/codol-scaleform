package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.objects.DailyChallengeObj;
   
   public class RerollChallengeTask extends AsyncTaskBase
   {
      
      public function RerollChallengeTask()
      {
         super(DataID.REWARD_REROLL_CHALLENGE,AsyncTaskGroup.REWARD);
      }
      
      override public function onStart() : void
      {
         var dailyChallenge:DailyChallengeObj = null;
         var sequence:int = 0;
         var isPVP:Boolean = false;
         var challengeID:int = 0;
         var rerollCount:int = 0;
         super.onStart();
         if(this.params != null)
         {
            dailyChallenge = this.params as DailyChallengeObj;
            sequence = int(dailyChallenge.difficulty);
            isPVP = dailyChallenge.isPvp;
            challengeID = int(dailyChallenge.id);
            rerollCount = dailyChallenge.rerollCount;
            CFunctionContainer.AS_RerollDailyChallenge(sequence,isPVP,challengeID,rerollCount);
         }
      }
   }
}

