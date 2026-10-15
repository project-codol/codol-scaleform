package codo.objects
{
   public dynamic class RequirementObj extends CustomObject
   {
      
      public var statement:String = "";
      
      public var valueArray:Array;
      
      public var isChallenge:Boolean = false;
      
      public var challengeNames:Array;
      
      public var challengeLevels:Array;
      
      public var challengeNum:int;
      
      public function RequirementObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

