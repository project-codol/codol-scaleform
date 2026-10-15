package codo.objects
{
   public class MatchSelectDifficultyObj
   {
      
      public var name:String;
      
      public var playlists:Array;
      
      public function MatchSelectDifficultyObj()
      {
         super();
         this.playlists = [];
      }
      
      public function getPlaylist(index:int) : PlayListObj
      {
         return this.playlists[index] as PlayListObj;
      }
   }
}

