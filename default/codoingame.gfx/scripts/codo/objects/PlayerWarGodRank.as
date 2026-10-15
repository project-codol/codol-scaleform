package codo.objects
{
   public class PlayerWarGodRank
   {
      
      public static const TIER_JWG1:int = 0;
      
      public static const TIER_JWG2:int = 1;
      
      public static const TIER_JWG3:int = 2;
      
      public static const TIER_JWG4:int = 3;
      
      public static const TIER_JWG5:int = 4;
      
      public static const TIER_JWG6:int = 5;
      
      public static const TIER_BRONZE:int = 6;
      
      public static const TIER_SILVER:int = 7;
      
      public static const TIER_GOLD:int = 8;
      
      public static const TIER_PLATINUM:int = 9;
      
      public static const TIER_DIAMOND:int = 10;
      
      public static const TIER_HEROIC:int = 11;
      
      public static const MAX_TIER_NUM:int = 12;
      
      public static const DIVISION_THREE:int = 0;
      
      public static const DIVISION_TWO:int = 1;
      
      public static const DIVISION_ONE:int = 2;
      
      public static const MAX_DIVISION_NUM:int = 3;
      
      public static const MAX_STAR_NUM:int = 5;
      
      public static const HEROIC_TIER_SCORE:int = 198000;
      
      public static const MINIMUM_BRONZE_SCORE:int = 108000;
      
      public var tier:int;
      
      public var division:int;
      
      public var star:int;
      
      public var score:int;
      
      public var promotionScore:int;
      
      public function PlayerWarGodRank()
      {
         super();
      }
   }
}

