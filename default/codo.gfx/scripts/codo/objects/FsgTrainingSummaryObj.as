package codo.objects
{
   public class FsgTrainingSummaryObj
   {
      
      public var statIndex:uint;
      
      public var iconFrame:uint;
      
      public var label:String;
      
      public var val:*;
      
      public var score:*;
      
      public var preBestScore:int;
      
      public var prevBestStar:int;
      
      public var star:int;
      
      public function FsgTrainingSummaryObj(statIndex:uint, iconFrame:uint = 1, label:String = null, val:* = null, score:* = null, preBestScore:int = -1, star:int = -1, prevBestStar:int = -1)
      {
         super();
         this.statIndex = statIndex;
         this.score = score;
         this.preBestScore = preBestScore;
         this.star = star;
         this.iconFrame = iconFrame;
         this.label = label;
         this.val = val;
         this.prevBestStar = prevBestStar;
      }
   }
}

