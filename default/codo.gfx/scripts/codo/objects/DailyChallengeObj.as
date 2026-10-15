package codo.objects
{
   import codo.localization.DictChallenge;
   import codo.utils.LocalizeUtil;
   
   public class DailyChallengeObj extends MatchResultsChallengeObj
   {
      
      private static var PVE_CHALLENGE_DIFFICULT_ICONS:Array = ["pve_daily_easy_challenge","pve_daily_med_challenge","pve_daily_hard_challenge"];
      
      private static var PVP_CHALLENGE_DIFFICULT_ICONS:Array = ["pvp_daily_easy_challenge","pvp_daily_med_challenge","pvp_daily_hard_challenge"];
      
      public var isPvp:Boolean;
      
      public var difficulty:uint;
      
      public var chainBonus:Boolean;
      
      public var rerollCount:int;
      
      public var score:int;
      
      public function DailyChallengeObj()
      {
         super();
      }
      
      override public function cppInitData() : void
      {
         super.cppInitData();
         icon = this.isPvp ? PVP_CHALLENGE_DIFFICULT_ICONS[this.difficulty] : PVE_CHALLENGE_DIFFICULT_ICONS[this.difficulty];
      }
      
      override public function getRewardText() : String
      {
         return LocalizeUtil.param(DictChallenge.DAILY_CHALLENGE_SCORE,[this.score]);
      }
   }
}

