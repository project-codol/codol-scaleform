package codo.objects
{
   public class ClanObj
   {
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var ownerID:String = "";
      
      public var ownerName:String = "";
      
      public var clanAnnouncement:String = "";
      
      public var clanDescription:String = "";
      
      public var status:uint = 0;
      
      public var autoJoinLevel:int;
      
      public var recruitState:int;
      
      public var ctp:int;
      
      public var ctpEarnedToday:int;
      
      public var level:int;
      
      public var tags:Array = [];
      
      public var members:Array = [];
      
      public function ClanObj()
      {
         super();
      }
   }
}

