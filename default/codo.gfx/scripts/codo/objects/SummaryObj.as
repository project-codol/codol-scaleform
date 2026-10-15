package codo.objects
{
   public dynamic class SummaryObj extends CustomObject
   {
      
      public var timePlayed:Number = 0;
      
      public var xpOriginal:int = 0;
      
      public var xpGained:int = 0;
      
      public var gpOriginal:uint = 0;
      
      public var gpGained:uint = 0;
      
      public var levelIncrease:Vector.<EXPLevelObj>;
      
      public function SummaryObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

