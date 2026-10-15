package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.ServiceID;
   import codo.localization.DictChallenge;
   import codo.objects.DailyChallengeObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.objects.VetChallengeObj;
   import codo.objects.WeeklyChallengeObj;
   import codo.utils.DataUtil;
   
   public class ChallengeService extends ServiceBase
   {
      
      private static var _instance:ChallengeService;
      
      public function ChallengeService()
      {
         super(ServiceID.CHALLENGE);
      }
      
      public static function getInstance() : ChallengeService
      {
         if(ChallengeService._instance == null)
         {
            ChallengeService._instance = new ChallengeService();
         }
         return ChallengeService._instance;
      }
      
      override public function init() : void
      {
      }
      
      public function GetDailyChallenges() : Vector.<DailyChallengeObj>
      {
         return CFunctionCommonContainer.FetchDailyChallenge()["challengeProgresses"];
      }
      
      public function GetWeeklyChallenges() : Vector.<WeeklyChallengeObj>
      {
         return CFunctionCommonContainer.FetchWeeklyChallenge()["challengeProgresses"];
      }
      
      public function GetVeteranChallenges(numChallenges:uint = 3) : Vector.<VetChallengeObj>
      {
         var src:Array = CFunctionContainer.AS_GetVetAwardChallenges(numChallenges);
         return DataUtil.copyElems(new Vector.<VetChallengeObj>(0),src);
      }
      
      public function GetWeeklyChallengeChecklist() : OnboardingChecklistObj
      {
         return CFunctionCommonContainer.GetWeeklyChallengeChecklist();
      }
      
      public function GetOnboardingChecklist() : Vector.<OnboardingChecklistObj>
      {
         return CFunctionCommonContainer.GetOnboardingChecklist();
      }
      
      public function GetDailyChallengeChecklist() : OnboardingChecklistObj
      {
         return CFunctionCommonContainer.GetDailyChallengeChecklist();
      }
      
      public function get showOnboardingChecklist() : Boolean
      {
         return CFunctionCommonContainer.GetShowOnboardingChecklist() as Boolean;
      }
      
      public function GetChallengeChecklist() : Vector.<OnboardingChecklistObj>
      {
         var checklists:Vector.<OnboardingChecklistObj> = new Vector.<OnboardingChecklistObj>();
         if(CFunctionCommonContainer.Dvar_GetBool("dailyChanllengeDisabled") == false)
         {
            checklists.push(ChallengeService.getInstance().GetDailyChallengeChecklist());
         }
         checklists.push(ChallengeService.getInstance().GetWeeklyChallengeChecklist());
         var checklistData:OnboardingChecklistObj = new OnboardingChecklistObj();
         checklistData.isVeteran = true;
         var veteranChallenges:Vector.<VetChallengeObj> = ChallengeService.getInstance().GetVeteranChallenges(5);
         checklistData.name = DictChallenge.CHALLENGES_CAREER;
         checklistData.challenges = DataUtil.copyElems([],veteranChallenges);
         checklistData.canReRoll = false;
         checklists.push(checklistData);
         return checklists;
      }
   }
}

