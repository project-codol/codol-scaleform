package codo.objects
{
   public class WeeklyChallengeObj extends MatchResultsChallengeObj
   {
      
      public var active:Boolean;
      
      public var finished:Boolean;
      
      public var revealed:Boolean;
      
      public var step:uint;
      
      public function WeeklyChallengeObj()
      {
         super();
      }
      
      override public function getFinished() : Boolean
      {
         return this.finished;
      }
      
      override public function cppInitData() : void
      {
         super.cppInitData();
         icon = "scaleform_ash/miscicons/" + icon;
      }
   }
}

