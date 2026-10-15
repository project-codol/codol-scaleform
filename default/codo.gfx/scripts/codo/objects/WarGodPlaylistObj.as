package codo.objects
{
   public class WarGodPlaylistObj
   {
      
      public static const NO_SPECIFIY_SCORE_WHEN_GET_PLAYLIST:int = -1;
      
      public static const WARN_TYPE_NO_WARN:int = -1;
      
      public static const WARN_TYPE_PARTY_MEMBER_PLACEMENT:int = 0;
      
      public static const WARN_TYPE_PLAYER_PLACEMENT:int = 1;
      
      public var warnType:int;
      
      public var playlist:Array;
      
      public var othersPlaylist:Boolean;
      
      public function WarGodPlaylistObj()
      {
         super();
         this.warnType = WARN_TYPE_NO_WARN;
         this.playlist = new Array();
         this.othersPlaylist = false;
      }
   }
}

