package codo.utils
{
   import codo.localization.DictHud;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   
   public class SpyUtil
   {
      
      public function SpyUtil()
      {
         super();
      }
      
      public static function getLocalizedRoleName(role:int) : String
      {
         switch(role)
         {
            case 1:
               return LocalizeUtil.localize(DictHud.SPY_INVESTIGATOR);
            case 2:
               return LocalizeUtil.localize(DictHud.SPY_SPY);
            case 3:
               return LocalizeUtil.localize(DictHud.SPY_CIVILIAN);
            case 4:
               return LocalizeUtil.localize(DictHud.SPY_ROLE_COWBOY);
            case 5:
               return LocalizeUtil.localize(DictHud.SPY_ROLE_RPGKING);
            case 6:
               return LocalizeUtil.localize(DictHud.SPY_ROLE_FRAGMAN);
            case 7:
               return LocalizeUtil.localize(DictHud.SPY_ROLE_HANZO);
            default:
               return "";
         }
      }
      
      public static function getRoleColor(role:int) : uint
      {
         switch(role)
         {
            case 1:
               return SpyHudGuide.ROLE_INVESTIGATOR_COLOR;
            case 2:
               return SpyHudGuide.ROLE_SPY_COLOR;
            case 3:
               return SpyHudGuide.ROLE_CIVILIAN_COLOR;
            default:
               return GlobalGuide.WHITE;
         }
      }
   }
}

