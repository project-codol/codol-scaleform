package codo.objects
{
   public dynamic class EXPLevelObj extends CustomObject
   {
      
      public var current:uint = 0;
      
      public var total:uint = 0;
      
      public var displayRank:int;
      
      public var prestige:int;
      
      public function EXPLevelObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

