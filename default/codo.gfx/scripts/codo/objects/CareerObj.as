package codo.objects
{
   public dynamic class CareerObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var imageURL:String = "";
      
      public var currentLevel:String = "";
      
      public var prestige:uint = 0;
      
      public var xpEarned:uint = 0;
      
      public var xpRequired:uint = 0;
      
      public var scoreEarned:uint = 0;
      
      public var totalEarnedXP:uint = 0;
      
      public var wargodPlayerInfo:WarGodPlayerObj = null;
      
      public var wins:uint = 0;
      
      public var losses:uint = 0;
      
      public var ties:uint = 0;
      
      public var escapes:uint = 0;
      
      public var winStreak:uint = 0;
      
      public var currentWinStreak:uint = 0;
      
      public var kills:uint = 0;
      
      public var headshots:uint = 0;
      
      public var assists:uint = 0;
      
      public var killStreak:uint = 0;
      
      public var deaths:uint = 0;
      
      public var timePlayed:uint = 0;
      
      public var objectives:uint = 0;
      
      public var winRatio:Number = 0;
      
      public var kdRatio:Number = 0;
      
      public var rank:uint = 0;
      
      public var accuracy:Number = 0;
      
      public var score:int = 0;
      
      public var recentStatistics:Object;
      
      public var weaponCategoryStatistics:Object;
      
      public function CareerObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

