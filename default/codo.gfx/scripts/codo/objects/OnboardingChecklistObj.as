package codo.objects
{
   public class OnboardingChecklistObj
   {
      
      public var name:String;
      
      public var rewardIndex:int;
      
      public var challenges:Array = [];
      
      public var complete:Boolean;
      
      public var claimed:Boolean;
      
      public var timeLeft:int;
      
      public var refreshTime:String;
      
      public var rewards:Array = [];
      
      public var rewardCosts:Array = [];
      
      public var featuredIdx:int = 0;
      
      public var gpValue:int = 0;
      
      public var canReRoll:Boolean = false;
      
      public var isVeteran:Boolean;
      
      public function OnboardingChecklistObj()
      {
         super();
      }
   }
}

