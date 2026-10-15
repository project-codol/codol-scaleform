package codo.objects
{
   public dynamic class ChallengeObj extends CustomObject
   {
      
      public var id:uint = 0;
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var imageURL:String = "";
      
      public var category:String = "";
      
      public var complete:Boolean = false;
      
      public var finished:Boolean = false;
      
      public var xpGained:int = 0;
      
      public var gpGained:uint = 0;
      
      public var rewardGP:uint = 0;
      
      public var xp:uint = 0;
      
      public var endValue:Number = 0;
      
      public var currentProgress:Number = 0;
      
      public var targetProgress:Number = 0;
      
      public var progress:Number = 0;
      
      public var playList:String;
      
      public var weaponItemID:int;
      
      public var enablePageJump:Boolean = true;
      
      public var actionIDs:Array = [];
      
      public var items:Array = [];
      
      public var target:uint = 0;
      
      public var awardSkuID:uint = 0;
      
      public function ChallengeObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

