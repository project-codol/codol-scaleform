package codo.constants
{
   public class UITutorialFlags
   {
      
      public static const NULL:uint = uint.MAX_VALUE;
      
      public static const UI_TOUR_AAR_NEW_USER_GP_VIEWED:uint = 1;
      
      public static const UI_TOUR_LANDING_PICK10_INTRO_VIEWED:uint = 101;
      
      public static const UI_TOUR_INVENTORY_PICK10_INTRO_VIEWED:uint = 102;
      
      public static const UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_VIEWED:uint = 103;
      
      public static const UI_TOUR_LOADOUT_SELECT_PICK10_EQUIP_PERK1_VIEWED:uint = 104;
      
      public static const UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_SHOW_BAR_VIEWED:uint = 105;
      
      public static const UI_TOUR_INVENTORY_PICK10_WILDCARD_INTRO_VIEWED:uint = 106;
      
      public static const UI_TOUR_LOADOUT_SELECT_PICK10_EQUIP_WILDCARD_VIEWED:uint = 107;
      
      public static const UI_TOUR_INVENTORY_PICK10_WILDCARD_EQUIPPED_VIEWED:uint = 108;
      
      public static const UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_SLOT2_VIEWED:uint = 109;
      
      public static const UI_TOUR_LOADOUT_SELECT_PICK10_EQUIP_PERK1_SLOT2_VIEWED:uint = 110;
      
      public static const UI_TOUR_INVENTORY_PICK10_COMPLETE_VIEWED:uint = 111;
      
      public static const UI_TUTORIAL_IN_GAME_SPRINT:uint = 0;
      
      public static const UI_TUTORIAL_IN_GAME_SHOOT:uint = 1;
      
      public static const UI_TUTORIAL_IN_GAME_FIRST_KILL:uint = 2;
      
      public static const UI_TUTORIAL_IN_GAME_FIRST_KILLSTREAK:uint = 3;
      
      public static const UI_TUTORIAL_IN_GAME_CALL_IN_PREDATOR:uint = 4;
      
      public static const UI_TUTORIAL_IN_GAME_KILL_ENEMIES_WITH_PREDATOR:uint = 5;
      
      public static const UI_TUTORIAL_IN_GAME_DAMAGE:uint = 6;
      
      public static const UI_TUTORIAL_IN_GAME_KILL:uint = 7;
      
      public static const UI_TUTORIAL_IN_GAME_ADS:uint = 8;
      
      public static const UI_TUTORIAL_IN_GAME_CALL_IN_HELICOPTER:uint = 9;
      
      public static const UI_TUTORIAL_IN_GAME_ELIMINATE_FORCES:uint = 10;
      
      public static const UI_TUTORIAL_IN_GAME_COURSE:uint = 11;
      
      public static const UI_TUTORIAL_IN_GAME_CQB:uint = 12;
      
      public static const UI_TUTORIAL_IN_GAME_CHOOSE:uint = 13;
      
      public static const TOUR_AAR_STEP_SHOW_GP:uint = 1;
      
      public static const TOUR_AAR_STEP_SHOW_XP:uint = 2;
      
      public static const TOUR_AAR_STEP_SHOW_LEVEL_REWARD:uint = 3;
      
      public static const TOUR_AAR_STEP_END:uint = 4;
      
      public static const UI_TOUR_LOGIN_REWARDS:uint = 301;
      
      public static const UI_TOUR_CAREER:uint = 302;
      
      public static const UI_TOUR_MATCH_SELECT:uint = 303;
      
      public static const UI_TOUR_INVENTORY:uint = 304;
      
      public static const UI_TOUR_INVENTORY_SELECT_WEAPON:uint = 305;
      
      public static const UI_TOUR_INVENTORY_SELECT_ATTACHMENT:uint = 306;
      
      public static const UI_TOUR_MARKETPLACE:uint = 307;
      
      public static const UI_TOUR_CLANS:uint = 308;
      
      public static const UI_TOUR_LEADERBOARD:uint = 309;
      
      public static const UI_TOUR_WARGOD:uint = 310;
      
      public static const UI_TOUR_FRIENDS:uint = 311;
      
      public static const UI_TOUR_PARTY:uint = 312;
      
      private static var _curOnboardingStep:uint = NULL;
      
      private static var _nextOnboardingStep:uint = NULL;
      
      private static var _curPick10Step:uint = NULL;
      
      private static var _nextPick10Step:uint = NULL;
      
      public function UITutorialFlags()
      {
         super();
      }
      
      public static function setNextOnboardingStep(step:uint) : void
      {
         _nextOnboardingStep = step;
      }
      
      public static function advanceOnboardingStep() : void
      {
         _curOnboardingStep = _nextOnboardingStep;
         if(_nextOnboardingStep != NULL)
         {
            ++_nextOnboardingStep;
         }
      }
      
      public static function getOnboardingStep() : uint
      {
         return _curOnboardingStep;
      }
      
      public static function setNextPick10Step(step:uint) : void
      {
         _nextPick10Step = step;
      }
      
      public static function advancePick10Step() : void
      {
         _curPick10Step = _nextPick10Step;
         if(_nextPick10Step != NULL)
         {
            ++_nextPick10Step;
         }
      }
      
      public static function getPick10Step() : uint
      {
         return _curPick10Step;
      }
      
      public static function clearMarketTutorials() : void
      {
         _nextOnboardingStep = NULL;
         _nextPick10Step = NULL;
      }
   }
}

