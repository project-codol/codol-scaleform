package codo.objects
{
   public dynamic class RecentMatchStatsObj extends CustomObject
   {
      
      public var gameType:int;
      
      public var round:int;
      
      public var topScore:int;
      
      public var averageScore:int;
      
      public var kills:int;
      
      public var deaths:int;
      
      public var score:int;
      
      public var hits:int;
      
      public var shots:int;
      
      public var empty:Boolean;
      
      public function RecentMatchStatsObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

