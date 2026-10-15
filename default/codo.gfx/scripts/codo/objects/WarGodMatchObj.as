package codo.objects
{
   public class WarGodMatchObj
   {
      
      public static const RESULT_LOSE:int = 0;
      
      public static const RESULT_WIN:int = 1;
      
      public static const RESULT_DRAW:int = 2;
      
      public static const RESULT_LEAVE:int = 3;
      
      public var timeStamp:int;
      
      public var isWinner:int;
      
      public var isDraw:int;
      
      public var isDisconnected:int;
      
      public var gameMode:int;
      
      public var map:int;
      
      public var kills:int;
      
      public var deaths:int;
      
      public var score:int;
      
      public var ladderScoreBeforeMatch:int;
      
      public var ladderScoreAfterMatch:int;
      
      public var heroicValueGain:int;
      
      public var isSolo:int;
      
      public var place:int;
      
      public var isPromotion:int;
      
      public var isPlacement:int;
      
      public var isPunishment:int;
      
      public var version:int;
      
      public var modeName:String;
      
      public var mapName:String;
      
      public function WarGodMatchObj()
      {
         super();
      }
   }
}

