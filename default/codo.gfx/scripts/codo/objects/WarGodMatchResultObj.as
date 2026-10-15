package codo.objects
{
   public class WarGodMatchResultObj
   {
      
      public static const PROMOTION_SCORE_DETAIL_MEDAL:int = 1;
      
      public static const PROMOTION_SCORE_DETAIL_PERFORMANCE:int = 2;
      
      public static const PROMOTION_SCORE_DETAIL_WINLOSE:int = 3;
      
      public static const PROMOTION_SCORE_DETAIL_PUNISH:int = 4;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_WINLOSE:int = 1;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_PUNISH:int = 2;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_SD_OPERATE_BOMB:int = 8;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_SD_KILL_ENEMY:int = 9;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_SD_KILL_LOTS_OF_ENEMY:int = 10;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_DEFEND_POINT:int = 8;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_CAPTURE_POINT:int = 9;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_KILL_ENEMY:int = 10;
      
      public static const SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_DOM_KILL_LOTS_OF_ENEMY:int = 11;
      
      public static const SENIOR_WARGOD_PROPTION_SCORE_DETAIL_MIN:int = 8;
      
      public static const SENIOR_WARGOD_PROPTION_SCORE_DETAIL_MAX:int = 11;
      
      public var beforePhase:int;
      
      public var afterPhase:int;
      
      public var beforeScore:int;
      
      public var afterScore:int;
      
      public var beforeRank:PlayerWarGodRank;
      
      public var afterRank:PlayerWarGodRank;
      
      public var beforeHV:int;
      
      public var afterHV:int;
      
      public var HVGainLose:int;
      
      public var beforePromotionScore:int;
      
      public var afterPromotionScore:int;
      
      public var result:int;
      
      public var numPlacementComplete:int;
      
      public var numPromotionComplete:int;
      
      public var numStarChangeDueToResult:int;
      
      public var numStarChangeDueToHV:int;
      
      public var numStarChangeDueToPromotion:int;
      
      public var numMatchHistroy:int;
      
      public var rewards:Array;
      
      public var firstTimeGetHeroicTier:Boolean;
      
      public var hasPunishment:Boolean;
      
      public var matchHistroy:Array;
      
      public var matchResultFromDvar:Array;
      
      public function WarGodMatchResultObj()
      {
         super();
      }
      
      public static function isValidSeniorWarGodDetail(type:int) : Boolean
      {
         if(type == SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_WINLOSE || type == SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_PUNISH)
         {
            return true;
         }
         if(type >= SENIOR_WARGOD_PROPTION_SCORE_DETAIL_MIN && type <= SENIOR_WARGOD_PROPTION_SCORE_DETAIL_MAX)
         {
            return true;
         }
         return false;
      }
   }
}

