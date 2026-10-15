package codo.objects
{
   public dynamic class LeaderboardElementObj extends CustomObject
   {
      
      public var index:int;
      
      public var name:String;
      
      public var user:String;
      
      public var type:String;
      
      public var gameType:String;
      
      public var parameter:String;
      
      public var time:String;
      
      public function LeaderboardElementObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

