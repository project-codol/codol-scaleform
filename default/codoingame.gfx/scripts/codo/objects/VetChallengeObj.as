package codo.objects
{
   public class VetChallengeObj extends ChallengeBaseObj
   {
      
      public var unlocked:Boolean;
      
      public var finished:Boolean;
      
      public var deactivated:Boolean;
      
      public var currentLevel:uint;
      
      public var maxLevel:uint;
      
      public var unlock_rank:uint;
      
      public var unlock_prestige:uint;
      
      public var awardSkuID:uint;
      
      public function VetChallengeObj()
      {
         super();
      }
      
      override public function getFinished() : Boolean
      {
         return this.finished;
      }
   }
}

