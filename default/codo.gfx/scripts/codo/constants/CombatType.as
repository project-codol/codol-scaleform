package codo.constants
{
   public class CombatType
   {
      
      public static const CT:int = 0;
      
      public static const CT_1V1:int = 1;
      
      public static const CT_2V2:int = 2;
      
      public static const CT_3V3:int = 3;
      
      public static const CT_EASY:int = 0;
      
      public static const CT_NORMAL:int = 1;
      
      public static const CT_HARD:int = 2;
      
      public function CombatType()
      {
         super();
      }
      
      public static function toStr(ctType:int = 0) : String
      {
         switch(ctType)
         {
            case CT:
               return "combat";
            case CT_1V1:
               return "combat_1v1";
            case CT_2V2:
               return "combat_2v2";
            case CT_3V3:
               return "combat_3v3";
            default:
               return "";
         }
      }
      
      public static function getMaxPlayerFromLeague(leagueType:int) : int
      {
         switch(leagueType)
         {
            case CT_EASY:
               return 4;
            case CT_NORMAL:
               return 6;
            case CT_HARD:
               return 10;
            default:
               return 10;
         }
      }
   }
}

