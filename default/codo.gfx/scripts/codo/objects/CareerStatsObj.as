package codo.objects
{
   public class CareerStatsObj
   {
      
      public var recentScores:Array = [];
      
      public var averageScore:uint = 0;
      
      public var matchResult:Object;
      
      public var currentLevelInfo:PlayerLevelObj;
      
      public var customStats:Array;
      
      public var customStatsValues:Array;
      
      public var isBootCamp:Boolean = false;
      
      public var bootCampEXP:int = 0;
      
      public var bootCampScore:int = 0;
      
      public function CareerStatsObj()
      {
         super();
      }
   }
}

