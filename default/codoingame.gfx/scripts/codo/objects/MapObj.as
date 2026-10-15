package codo.objects
{
   public dynamic class MapObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var minPlayer:uint = 1;
      
      public var maxPlayer:uint = 18;
      
      public var imageURL:String = "";
      
      public var chapter:int = -1;
      
      public var level:int = -1;
      
      public var narrative:String = "";
      
      public var narrative2:String = "";
      
      public var targetEasy:String = "";
      
      public var targetNormal:String = "";
      
      public var targetHard:String = "";
      
      public var targetPlaceholder:String = "";
      
      public var hint0:String = "";
      
      public var hint1:String = "";
      
      public var hint2:String = "";
      
      public var unlocked:Boolean = true;
      
      public var unlockedHints:Array = [];
      
      public var difficultyEasy:Boolean = false;
      
      public var difficultyNormal:Boolean = true;
      
      public var difficultyHard:Boolean = false;
      
      public var difficultyPlaceholder:Boolean = false;
      
      public var mapRewards:Vector.<RewardObj>;
      
      public var isComplete:Boolean = false;
      
      public var playerPreviousBestScore:int = 0;
      
      public var isOpen:Boolean = true;
      
      public var next:MapObj = null;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var sequence:int = 0;
      
      public var voted:Boolean = false;
      
      public var availableModes:Array = [];
      
      public var dlcLevel:int = 0;
      
      public var lockedByDLCLevel:Boolean = false;
      
      public var noCustomRoom:Boolean = false;
      
      public function MapObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public function get isHeroOps() : Boolean
      {
         return this.sequence >= 101 && this.sequence <= 200;
      }
   }
}

