package codo.objects
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.PlayListType;
   import codo.manager.DataManager;
   
   public dynamic class PlayListObj extends CustomObject
   {
      
      private static var _selectedPlaylist:PlayListObj;
      
      private static var _streakBreakPlaylist:PlayListObj;
      
      public var id:int = 0;
      
      public var index:int = 0;
      
      public var name:String = "";
      
      public var overridename:String = "";
      
      public var overridedescription:String = "";
      
      public var description:String = "";
      
      public var imageURL:String = "";
      
      public var vsrule:String = "";
      
      public var category:int = 0;
      
      public var leagueID:int = 0;
      
      public var minPartySize:int = 0;
      
      public var maxPartySize:int = 0;
      
      public var minRoomSize:int = 0;
      
      public var maxRoomSize:int = 0;
      
      public var flags:uint = 0;
      
      public var type:uint = 0;
      
      public var combatTrainingType:int = 0;
      
      public var isNew:Boolean = false;
      
      public var isFeatured:Boolean = false;
      
      public var homepageAdSlot:int = 0;
      
      public var onboardBonus:Boolean;
      
      public var unlocked:Boolean = true;
      
      public var unlockHint:String = "";
      
      public var isActive:Boolean = true;
      
      public var cycleDayIndex:int = -1;
      
      public var partyOnly:Boolean = false;
      
      public var playerCount:int = 0;
      
      public var playerCountStatus:int = 0;
      
      public var rules:String;
      
      public var unlockedLevels:Array = [];
      
      public var unlockLevelStart:int = 0;
      
      public var unlockLevelEnd:int = 0;
      
      public var unlockFlag:String = "";
      
      public var dlcLevel:int = 0;
      
      public var dlcLocked:Boolean = false;
      
      public var minMapValidVotes:int = 3;
      
      public var maxMapVoteTimes:int = 3;
      
      public var votingDisabled:int = 0;
      
      public var entries:Array = [];
      
      public var maps:Array = [];
      
      public var modes:Array = [];
      
      public var displayOrder:int = 0;
      
      public var HasValidTime:Boolean = false;
      
      public var xpScale:Number = 1;
      
      public var gpScale:Number = 1;
      
      public var levelRestricted:Boolean = false;
      
      public var noTeamSplitting:Boolean = false;
      
      public var isUnlimitedSurvival:Boolean = false;
      
      public var isUnlimitedZombies:Boolean = false;
      
      public var isSurvivalPlus:Boolean = false;
      
      public var buddyPlaylist:int = 0;
      
      public function PlayListObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public static function getSelectedPlaylist() : PlayListObj
      {
         return _selectedPlaylist;
      }
      
      public static function setSelectedPlaylist(obj:PlayListObj) : void
      {
         _selectedPlaylist = obj;
      }
      
      public static function getStreakBreakPlaylist() : PlayListObj
      {
         return _streakBreakPlaylist;
      }
      
      public static function setStreakBreakPlaylist(pl:PlayListObj) : void
      {
         _streakBreakPlaylist = pl;
      }
      
      public function getImage() : String
      {
         var image:String = "SP_Multi_Gamemode_.tga";
         if(this.imageURL.length > 0)
         {
            image = this.imageURL;
         }
         else if(Boolean(this.modes) && this.modes.length == 1)
         {
            image = this.modes[0].image;
         }
         return image;
      }
      
      public function isBattleCityMode() : Boolean
      {
         if(this.modes.length > 0)
         {
            return this.modes[0].id == "dmz" || this.isBattleCityTeamMode();
         }
         return false;
      }
      
      public function isBattleCityTeamMode() : Boolean
      {
         if(this.modes.length > 0)
         {
            return this.modes[0].id == "tdmz";
         }
         return false;
      }
      
      public function isBattleCityLeague() : Boolean
      {
         var playlistId:int = 0;
         var bcLeagueGlobalObj:BattleCityLeagueGlobalObj = DataManager.getInstance().getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         for each(playlistId in bcLeagueGlobalObj.playlist)
         {
            if(playlistId == this.index)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBattleCityBuddyMode() : Boolean
      {
         return (this.flags & 1 << 25) != 0;
      }
      
      public function isBattleCityHardCoreMode() : Boolean
      {
         return (this.flags & 1 << 22) != 0;
      }
      
      public function isFiringRangeTraining() : Boolean
      {
         for(var i:int = 0; i < this.maps.length; i++)
         {
            if(this.maps[i].id == "coop_train_mp_firingrange")
            {
               return true;
            }
         }
         return false;
      }
      
      public function getGotoMatchMainPageEvent() : String
      {
         if(PlayListType.isPveType(this.type))
         {
            return BCEvent.EVT_GOTO_MAIN_PVE;
         }
         if(this.isBattleCityMode())
         {
            return BCEvent.EVT_GOTO_MAIN_BATTLECITY;
         }
         return BCEvent.EVT_GOTO_MAIN_PVP;
      }
   }
}

