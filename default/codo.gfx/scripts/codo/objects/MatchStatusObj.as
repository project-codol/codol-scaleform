package codo.objects
{
   public dynamic class MatchStatusObj extends CustomObject
   {
      
      public var gametype:String = "";
      
      public var gametypeID:String = "";
      
      public var timeLeft:String = "";
      
      public var timeplayed:int = 122;
      
      public var map:String = "";
      
      public var round:int = 5;
      
      public var roundLimit:int = 10;
      
      public function MatchStatusObj(cObj:Object)
      {
         super(cObj);
      }
   }
}

