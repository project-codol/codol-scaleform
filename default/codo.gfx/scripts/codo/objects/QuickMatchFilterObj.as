package codo.objects
{
   import codo.constants.RoomMatchType;
   
   public class QuickMatchFilterObj
   {
      
      public static const MODE_HERO_OPS:String = "coop";
      
      public static const MODE_COMBAT_TRAINING:String = "combat";
      
      public static const MODE_PLAYLIST:String = "playlist";
      
      public var type:uint = RoomMatchType.NONE;
      
      public var league:uint = 0;
      
      public var leagueName:String = "";
      
      public var playListID:int = -1;
      
      public var playListName:String = "";
      
      public var mode:String = "";
      
      public var map:String = "";
      
      public var minPlayer:int = 0;
      
      public var maxPlayer:int = 0;
      
      public var skipLobby:Boolean;
      
      public function QuickMatchFilterObj()
      {
         super();
      }
   }
}

