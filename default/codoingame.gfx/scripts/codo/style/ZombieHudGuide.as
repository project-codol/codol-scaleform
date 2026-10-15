package codo.style
{
   import codo.objects.ZombieArenaSpecializationObj;
   
   public class ZombieHudGuide
   {
      
      public static const ROLE_COLOR_ATTACKER:uint = 13115167;
      
      public static const ROLE_COLOR_DEFENDER:uint = 1010604;
      
      public static const SPECIALIZATION_COLOR_TANK:uint = 2730979;
      
      public static const SPECIALIZATION_COLOR_SUPPORT:uint = 8895040;
      
      public static const SPECIALIZATION_COLOR_SNIPER:uint = 13115167;
      
      public static const SPECIALIZATION_COLOR_RAMPAGER:uint = 15869837;
      
      public static const SPECIALIZATION_COLOR_GAMBLER:uint = 16755232;
      
      public static const SPECIALIZATION_COLOR_NONE:uint = 16777215;
      
      public function ZombieHudGuide()
      {
         super();
      }
      
      public static function getSpecializationColor(specializationType:int) : uint
      {
         var color:uint = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         switch(specializationType)
         {
            case ZombieArenaSpecializationObj.SPECIALIZATION_TANK:
               color = ZombieHudGuide.SPECIALIZATION_COLOR_TANK;
               break;
            case ZombieArenaSpecializationObj.SPECIALIZATION_SUPPORT:
               color = ZombieHudGuide.SPECIALIZATION_COLOR_SUPPORT;
               break;
            case ZombieArenaSpecializationObj.SPECIALIZATION_SNIPER:
               color = ZombieHudGuide.SPECIALIZATION_COLOR_SNIPER;
               break;
            case ZombieArenaSpecializationObj.SPECIALIZATION_RAMPAGER:
               color = ZombieHudGuide.SPECIALIZATION_COLOR_RAMPAGER;
               break;
            case ZombieArenaSpecializationObj.SPECIALIZATION_GAMBLER:
               color = ZombieHudGuide.SPECIALIZATION_COLOR_GAMBLER;
         }
         return color;
      }
   }
}

