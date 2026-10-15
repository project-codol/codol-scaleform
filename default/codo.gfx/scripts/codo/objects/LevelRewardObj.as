package codo.objects
{
   public dynamic class LevelRewardObj extends ChallengeRewardObj
   {
      
      public static const CATEGORY_REWARD:int = 0;
      
      public static const CATEGORY_UNLOCK:int = 1;
      
      public var category:int;
      
      public function LevelRewardObj()
      {
         super();
      }
   }
}

