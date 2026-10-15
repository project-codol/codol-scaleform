package codo.constants
{
   public class TutorialMap
   {
      
      public static var ONBOARD_CARGOSHIP:String = "coop_training_mp_cargoship";
      
      public static var ONBOARD_SHOOTING_RANGE:String = "mp_shootingrange";
      
      public static var ONBOARD_CQB_COURSE:String = "mp_cqbtraining";
      
      public static var ONBOARD_TRAINING_GROUNDS:String = "mp_trainingground";
      
      public static var MP:String = "mp_killhouse_sh";
      
      public static var ZM:String = "zm_zombie_training";
      
      public static var ZM_FIRST_PLAY:String = "zm_prototype_sh";
      
      public static var SURVIVAL:String = "coop_survival_mp_afghan";
      
      public static var EVACUATION:String = "coop_evac_mp_bog_sh";
      
      public static var CB3_ON_BOARD:String = "coop_training_mp_cargoship";
      
      public static var CB3_TRAINING_0:String = "mp_shootingrange";
      
      public static var CB3_TRAINING_1:String = "mp_cqbtraining";
      
      public static var CB3_TRAINING_2:String = "mp_trainingground";
      
      public function TutorialMap()
      {
         super();
      }
      
      public static function isCyborgTraining(param1:String) : Boolean
      {
         return param1 == ZM;
      }
      
      public static function isCB3Training(param1:String) : Boolean
      {
         return param1 == CB3_TRAINING_0 || param1 == CB3_TRAINING_1 || param1 == CB3_TRAINING_2;
      }
      
      public static function getTutorialMode(param1:String) : String
      {
         switch(param1)
         {
            default:
               return "bad";
            case ZM:
               return "cyborg";
            case MP:
               return "mp";
            case SURVIVAL:
               return "survival";
            case EVACUATION:
               return "evac";
            case ONBOARD_CARGOSHIP:
               return "cargoship";
            case ONBOARD_SHOOTING_RANGE:
               return "shootingrange";
            case ONBOARD_CQB_COURSE:
               return "cqbtraining";
            case ONBOARD_TRAINING_GROUNDS:
               return "trainingground";
         }
      }
   }
}

