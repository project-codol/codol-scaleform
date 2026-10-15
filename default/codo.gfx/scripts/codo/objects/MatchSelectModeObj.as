package codo.objects
{
   public class MatchSelectModeObj extends MatchSelectOptionObj
   {
      
      public var playlists:Array;
      
      public var heroOpsMaps:Array;
      
      public var pveDifficulties:Array;
      
      public var isNewUnlock:Boolean;
      
      public var unlockItem:int;
      
      public var cycleTodayIndex:int;
      
      public function MatchSelectModeObj(_id:String, _name:String, _tooltip:String = null, _locked:Boolean = false, _unlockLevel:int = -1, _isNew:Boolean = false, _isFeatured:Boolean = false)
      {
         super(_id,_name,_tooltip,_locked,_unlockLevel,_isNew,_isFeatured);
         this.playlists = [];
      }
      
      public function getPlaylist(index:int) : PlayListObj
      {
         return this.playlists[index] as PlayListObj;
      }
   }
}

