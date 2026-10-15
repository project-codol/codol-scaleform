package codo.objects
{
   public class RoomVoteObj
   {
      
      public var show:Boolean = false;
      
      public var enable:Boolean = false;
      
      public var showRandom:Boolean = true;
      
      public var next:int = 0;
      
      public var previous:int = 0;
      
      public var random:int = 0;
      
      public var entry:int = 0;
      
      public var previousMap:MapObj = null;
      
      public var nextMap:MapObj = null;
      
      public var randomMap:MapObj = null;
      
      public var votedMap:MapObj = null;
      
      public var gameMode:String = "";
      
      public function RoomVoteObj()
      {
         super();
      }
   }
}

