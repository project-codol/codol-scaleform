package codo.objects
{
   public class WarGodSeasonObj
   {
      
      public static const STATE_OPEN:uint = 0;
      
      public static const STATE_CLOSE_LOCK:uint = 1;
      
      public static const STATE_CLOSE_LEVEL:uint = 2;
      
      public static const STATE_CLOSE_PRIMARY_WEAPON:uint = 3;
      
      public static const STATE_CLOSE_SEASON_NOT_START:uint = 4;
      
      public static const STATE_CLOSE_SEASON_END:uint = 5;
      
      public static const STATE_PAUSE:uint = 6;
      
      public static const STATE_CLOSE_CREDIT_RATING:uint = 7;
      
      public static const STATE_BLOCKED:uint = 8;
      
      public var id:int;
      
      public var name:String;
      
      public var description:String;
      
      public var timeForShow:String;
      
      public var startTimeStamp:uint;
      
      public var endTimeStamp:uint;
      
      public var lbName:String;
      
      public var lbBestName:String;
      
      public var lbLocalName:String;
      
      public function WarGodSeasonObj()
      {
         super();
      }
   }
}

