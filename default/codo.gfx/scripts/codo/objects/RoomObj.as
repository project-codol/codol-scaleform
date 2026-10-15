package codo.objects
{
   import codo.constants.table.Mode;
   
   public dynamic class RoomObj
   {
      
      public static const PLAYER_MAX_NUM:int = 18;
      
      public var index:int = 0;
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var password:String = "";
      
      public var status:uint = 0;
      
      public var leagueID:uint = 0;
      
      public var isPlayList:Boolean = false;
      
      public var playListID:int = 0;
      
      public var playListName:String = "";
      
      public var playListDescription:String = "";
      
      public var isWarGod:Boolean = false;
      
      public var playListNextEntry:int = -1;
      
      public var playListLastEntry:int = -1;
      
      public var matchType:String;
      
      public var currentMatchMode:ModeObj = new ModeObj();
      
      public var currentMap:MapObj = new MapObj();
      
      public var currentMinPlayers:uint = 1;
      
      public var currentMaxPlayers:uint = 18;
      
      public var maxSpectators:uint = 6;
      
      public var currentPlayers:uint = 0;
      
      public var currentLevel:uint = 1;
      
      public var options:RoomOptionObj = null;
      
      public var numItemBans:uint = 0;
      
      public var forces:RoomInfoObj = null;
      
      public var roomDLCLevel:uint = 0;
      
      public var roomIsFullClient:Boolean = false;
      
      public var enableSpectator:Boolean = false;
      
      public function RoomObj()
      {
         super();
      }
      
      public function IsPveMode() : Boolean
      {
         return this.matchType == Mode.TYPE_PVE;
      }
   }
}

