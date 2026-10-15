package codo.constants
{
   public class UnlockItemCategory
   {
      
      public static const INV_ITEM:uint = 0;
      
      public static const MAP:uint = 1;
      
      public static const FUNCTIONAL:uint = 2;
      
      public static const REWARD:uint = 3;
      
      public function UnlockItemCategory()
      {
         super();
      }
      
      public static function isUnlocked(category:uint) : Boolean
      {
         return category == INV_ITEM || category == MAP || category == FUNCTIONAL;
      }
      
      public static function isReward(category:uint) : Boolean
      {
         return category == REWARD;
      }
   }
}

