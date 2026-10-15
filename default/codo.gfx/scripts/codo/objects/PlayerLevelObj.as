package codo.objects
{
   public dynamic class PlayerLevelObj extends CustomObject
   {
      
      public var currentLevel:uint = 0;
      
      public var currentLevelName:String = "";
      
      public var currentLevelDisplay:uint = 0;
      
      public var nextLevel:uint = 0;
      
      public var nextLevelName:String = "";
      
      public var nextLevelDisplay:uint = 0;
      
      public var currentExp:int = 0;
      
      public var totalExp:int = 0;
      
      public var changeExp:int = 0;
      
      public function PlayerLevelObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

