package codo.utils
{
   import codo.common.CFunctionInGameContainer;
   
   public class HostageUtil
   {
      
      public static const HOSTAGE_PHASE_FIRST_HALF:int = 0;
      
      public static const HOSTAGE_PHASE_SECOND_HALF:int = 1;
      
      public static const HOSTAGE_PHASE_OVER_TIME:int = 2;
      
      public function HostageUtil()
      {
         super();
      }
      
      public static function GetMatchPhase(round:int) : int
      {
         if(round >= CFunctionInGameContainer.AS_HostageGetRoundLimit())
         {
            return HOSTAGE_PHASE_OVER_TIME;
         }
         var roundLimit:int = Math.floor(CFunctionInGameContainer.AS_HostageGetRoundLimit() / 2) as int;
         if(round <= roundLimit)
         {
            return HOSTAGE_PHASE_FIRST_HALF;
         }
         return HOSTAGE_PHASE_SECOND_HALF;
      }
      
      public static function GetMatchAction(round:int) : int
      {
         var roundLimit:int = Math.floor(CFunctionInGameContainer.AS_HostageGetRoundLimit() / 2) as int;
         return (round - 1) % 5 + 1;
      }
   }
}

