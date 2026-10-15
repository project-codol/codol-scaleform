package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.BCEvent;
   import codo.constants.CodoVersion;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.RoomMatchType;
   import codo.constants.ServiceID;
   import codo.constants.table.League;
   import codo.constants.table.Map;
   import codo.constants.table.MatchBonus;
   import codo.constants.table.MatchOption;
   import codo.constants.table.Mode;
   import codo.event.ParaEvent;
   import codo.localization.DictCareer;
   import codo.localization.DictRoom;
   import codo.objects.*;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.MiscUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import codo.utils.TableUtil;
   import flash.utils.Dictionary;
   
   public class MatchService extends ServiceBase
   {
      
      private static var _instance:MatchService;
      
      private var _leagues:Array = [];
      
      private var _levels:Array = [];
      
      private var _playListWithFilter:Dictionary = new Dictionary();
      
      private var _mapsWithFilter:Dictionary = new Dictionary();
      
      private var _modesWithFilter:Dictionary = new Dictionary();
      
      private var _modeRules:Dictionary = new Dictionary();
      
      private var _roomListFilterStatus:Array;
      
      private var _isPlayListInit:Boolean = false;
      
      private var _isInRoom:Boolean = false;
      
      private var _fakeRoomList:Array = [];
      
      private var _fakeDedicatedServers:Array = [];
      
      private var _fakeGroupCounts:GroupCountsObj = null;
      
      private var _stillHasOtherRooms:Boolean = false;
      
      private var _overrideMapAvailableModes:Dictionary = new Dictionary();
      
      public function MatchService()
      {
         super(ServiceID.MATCH);
      }
      
      public static function getInstance() : MatchService
      {
         if(MatchService._instance == null)
         {
            MatchService._instance = new MatchService();
         }
         return MatchService._instance;
      }
      
      public static function getPlaylistRewardID(playlist:PlayListObj) : String
      {
         var map:MapObj = null;
         var quickMatchType:QuickMatchType = null;
         if(playlist.isSurvivalPlus)
         {
            return "survival_plus";
         }
         if(playlist.isUnlimitedSurvival)
         {
            return "unlimited_survival";
         }
         if(playlist.isUnlimitedZombies)
         {
            map = playlist.maps.length > 0 ? playlist.maps[0] as MapObj : null;
            if(Boolean(map) && map.id == "za_island")
            {
               return "unlimited_island";
            }
            if(Boolean(map) && map.id == "za_coliseum")
            {
               return "unlimited_coliseum";
            }
            return QuickMatchType.ID_ZARENA;
         }
         if(playlist.isBattleCityMode())
         {
            return "bc";
         }
         quickMatchType = QuickMatchType.fromPlaylistType(playlist.type);
         return quickMatchType.getCoopModeID();
      }
      
      public static function getBattleCityExclusiveRewardID() : String
      {
         return "bc";
      }
      
      public static function getBattleCityUltimateRewardID() : String
      {
         return "bcu";
      }
      
      override public function init() : void
      {
         this.register(DataID.JOIN_ROOM,this.joinRoom);
         this.register(DataID.CREATE_ROOM,this.createRoom);
         this.register(DataID.QUICK_MATCH,this.quickMatch);
         this.register(DataID.GROUP_COUNTS,this.getGroupCounts);
         this.register(DataID.LIST_DEDICATED_SERVER,this.listDedicatedServer);
         this.register(DataID.LEAVE_ROOM,this.leaveRoom);
         this.register(DataID.START_MATCH,this.startMatch);
         this.register(DataID.ENABLE_ROOM_LIST_EVENT,this.enableRoomListEvent);
         this.register(DataID.ENABLE_IN_ROOM_EVENT,this.enableInRoomEvent);
         this.register(DataID.TENCENT_GET_AAS_RECORD,this.tencentGetAASRecord);
         listen(BCEvent.EVT_FULLCLIENT_DOWNLOADED,this.fullClientDownloaded);
         this.initCustomMapAvailableModes();
         this.initMapModePlayList();
      }
      
      private function get fakeRoomList() : Object
      {
         return null;
      }
      
      private function get fakeGroupCounts() : GroupCountsObj
      {
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeGroupCounts == null)
         {
            this._fakeGroupCounts = new GroupCountsObj();
            this._fakeGroupCounts.coop = 10000;
            this._fakeGroupCounts.mp = 100000;
            this._fakeGroupCounts.cyborg = 1000;
            this._fakeGroupCounts.mp_room = 100;
            this._fakeGroupCounts.mp_playlist = 99000;
            this._fakeGroupCounts.playlist = [];
         }
         return this._fakeGroupCounts;
      }
      
      private function get fakeDedicatedServers() : Array
      {
         var i:uint = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeDedicatedServers.length <= 0)
         {
            for(i = 1; i <= 15; i++)
            {
               this._fakeDedicatedServers.push({
                  "name":"server" + i,
                  "hostName":"AAA",
                  "status":i % 2,
                  "currentPlayers":Math.min(18,Math.round(i + Math.random())),
                  "currentMaxPlayers":Math.min(18,Math.round(12 + Math.random()))
               });
            }
         }
         return this._fakeDedicatedServers;
      }
      
      public function get delayToShowButton() : Number
      {
         return this.getDvarInt("ui_return_lobby_timeout") * 1000;
      }
      
      public function joinRoom(cObj:Object) : void
      {
         if(this.createTask(DataID.JOIN_ROOM,AsyncTaskGroup.IN_CHANNEL,cObj))
         {
            this.showMsg(DictRoom.NOTE_JOIN_ROOM);
         }
      }
      
      public function createRoom(cRoomObj:Object) : void
      {
         this.cancelListRoom();
         if(this.createTask(DataID.CREATE_ROOM,AsyncTaskGroup.IN_CHANNEL,cRoomObj))
         {
            this.showMsg(DictRoom.NOTE_CREATE_ROOM);
         }
      }
      
      public function tencentGetAASRecord() : void
      {
         this.createTask(DataID.TENCENT_GET_AAS_RECORD,AsyncTaskGroup.AAS);
      }
      
      public function cancelListRoom() : void
      {
         CFunctionContainer.CancelList();
      }
      
      public function set stillHasOtherRooms(value:Boolean) : void
      {
         this._stillHasOtherRooms = value;
      }
      
      public function get stillHasOtherRooms() : Boolean
      {
         return this._stillHasOtherRooms;
      }
      
      public function cancelRoomTasks() : void
      {
         this.cancelRankedMatch();
         if(this.isTaskInProgress(DataID.START_MATCH))
         {
            this.cancelTask(DataID.START_MATCH);
         }
         if(this.isTaskInProgress(DataID.CREATE_ROOM))
         {
            this.cancelTask(DataID.CREATE_ROOM);
         }
      }
      
      public function cancelRankedMatch() : void
      {
         if(this.isTaskInProgress(DataID.QUICK_MATCH))
         {
            this.hideMsg();
            this.cancelTask(DataID.QUICK_MATCH);
         }
         if(this.isTaskInProgress(DataID.QUICK_MATCH_IN_PROGRESS_IN_ROOM))
         {
            this.cancelTask(DataID.QUICK_MATCH_IN_PROGRESS_IN_ROOM);
         }
      }
      
      public function quickMatch(matchFilter:Object) : void
      {
         this.cancelListRoom();
         ScaleformUtil.blockAltEnter(true);
         if(this.createTask(DataID.QUICK_MATCH,AsyncTaskGroup.IN_CHANNEL,matchFilter))
         {
            if(matchFilter.type == RoomMatchType.RANKED)
            {
               this.createTask(DataID.QUICK_MATCH_IN_PROGRESS_IN_ROOM,AsyncTaskGroup.NONE);
            }
            this.showMsg(DictRoom.NOTE_QUICK_MATCH);
         }
      }
      
      public function getGroupCounts() : void
      {
         this.createTask(DataID.GROUP_COUNTS,AsyncTaskGroup.GROUP_COUNT,{
            "feedback":false,
            "auto":true
         },this.fakeGroupCounts);
      }
      
      public function cancelListDedicatedServer() : void
      {
         if(this.isTaskInProgress(DataID.LIST_DEDICATED_SERVER))
         {
            this.hideMsg();
            this.cancelListRoom();
            this.cancelTask(DataID.LIST_DEDICATED_SERVER);
         }
      }
      
      public function listDedicatedServer(bAuto:Boolean) : void
      {
         this.cancelListDedicatedServer();
         if(this.createTask(DataID.LIST_DEDICATED_SERVER,AsyncTaskGroup.IN_ROOM,{"auto":bAuto},this.fakeDedicatedServers))
         {
            if(!bAuto)
            {
               this.showMsg(DictRoom.NOTE_LIST_DEDICATED_SERVER);
            }
         }
      }
      
      public function leaveRoom(cPara:Object) : void
      {
         this.cancelListDedicatedServer();
         if(this.createTask(DataID.LEAVE_ROOM,AsyncTaskGroup.IN_ROOM,{
            "auto":cPara.auto,
            "party":cPara.party,
            "isUserInput":cPara.isUserInput
         }))
         {
            if(!cPara.auto)
            {
               this.showMsg(Boolean(cPara.cancelRanked) ? DictRoom.NOTE_CANCEL_RANKED_MATCH : DictRoom.NOTE_LEAVE_ROOM);
            }
         }
      }
      
      public function startMatch(dsObj:Object) : void
      {
         this.cancelListDedicatedServer();
         ScaleformUtil.blockAltEnter(true);
         if(this.createTask(DataID.START_MATCH,AsyncTaskGroup.IN_ROOM,dsObj))
         {
            this.showMsg(DictRoom.NOTE_START_GAME);
         }
      }
      
      private function isRowValid(csvFile:String, row:int) : Boolean
      {
         var version:String = TableUtil.getValue(csvFile,row,CodoVersion.currentVersionColumn);
         return version == "1";
      }
      
      public function isMapValid(mapID:String) : Boolean
      {
         var mapRow:int = TableUtil.lookupRow(Map.PATH,Map.ID,mapID);
         if(mapRow == -1)
         {
            return false;
         }
         return this.isRowValid(Map.PATH,mapRow);
      }
      
      public function getPlayListName(playListID:uint) : String
      {
         var prop:* = undefined;
         var i:int = 0;
         for each(prop in this._playListWithFilter)
         {
            i = 0;
            while(i < prop.length)
            {
               if(prop[i].id == playListID)
               {
                  return prop[i].name;
                  break;
               }
               i++;
            }
         }
         return "";
      }
      
      public function getMapName(mapID:String) : String
      {
         var numRow:int = TableUtil.getRowCount(Map.PATH);
         for(var i:int = 0; i < numRow; i++)
         {
            if(TableUtil.getValue(Map.PATH,i,Map.ID) == mapID)
            {
               return "@" + TableUtil.getValue(Map.PATH,i,Map.NAME);
            }
         }
         return "";
      }
      
      public function isMapUnlocked(mapID:String) : Boolean
      {
         var unlockFlag:String = TableUtil.lookup(Map.PATH,Map.ID,mapID,Map.UNLOCK_FLAG);
         Logger.print("MatchService:::isMapUnlocked unlockFlag: " + unlockFlag);
         return this.isMapUnlockedByFlag(unlockFlag);
      }
      
      private function getKeyForMapType(isPvp:Boolean) : String
      {
         return isPvp ? "mp" : "coop";
      }
      
      private function initCustomMapAvailableModes() : void
      {
         var rows:Array = null;
         var i:int = 0;
         var elem:Array = null;
         var mapmodes:String = CFunctionCommonContainer.AS_GetCustomMapAvailableModes();
         if(mapmodes != "")
         {
            rows = mapmodes.split("|");
            for(i = 0; i < rows.length; i++)
            {
               elem = rows[i].split(";");
               if(elem.length == 2)
               {
                  this._overrideMapAvailableModes[elem[0]] = elem[1].split(":");
               }
            }
         }
      }
      
      private function initMapModePlayList() : void
      {
         Logger.print("MatchService:::initMapModePlayList");
         if(this._mapsWithFilter[this.getKeyForMapType(true)] == null)
         {
            this.listMap(true);
         }
         if(this._mapsWithFilter[this.getKeyForMapType(false)] == null)
         {
            this.listMap(false);
         }
         if(this._modesWithFilter[this.getKeyForMapType(true)] == null)
         {
            this.listMatchMode(true);
         }
         if(this._modesWithFilter[this.getKeyForMapType(false)] == null)
         {
            this.listMatchMode(false);
         }
         if(!this._isPlayListInit)
         {
            this.listPlayList(0);
         }
      }
      
      public function getMapObj(mapID:String) : MapObj
      {
         return this.getObjByID(this._mapsWithFilter,mapID) as MapObj;
      }
      
      public function getModeObj(modeID:String) : ModeObj
      {
         return this.getObjByID(this._modesWithFilter,modeID) as ModeObj;
      }
      
      public function getPlayListObj(playListID:int) : PlayListObj
      {
         return this.getObjByID(this._playListWithFilter,playListID.toString()) as PlayListObj;
      }
      
      public function listMap(isPvp:Boolean) : Array
      {
         var publisherLockedMaps:Array = null;
         var numRow:int = 0;
         var i:int = 0;
         var isRowValid:Boolean = false;
         var matchesType:Boolean = false;
         var tableType:String = null;
         var mapID:String = null;
         var chapter:int = 0;
         var map:MapObj = null;
         var pos:Array = null;
         var unlockHint:String = null;
         var iLockedMap:int = 0;
         var iMap2:int = 0;
         var typeKey:String = this.getKeyForMapType(isPvp);
         if(!this._mapsWithFilter.hasOwnProperty(typeKey))
         {
            if(ScaleformUtil.isScaleform)
            {
               publisherLockedMaps = CFunctionContainer.GetLockedMapsFromPublisher();
               numRow = TableUtil.getRowCount(Map.PATH);
               if(numRow > 0)
               {
                  this._mapsWithFilter[typeKey] = [];
               }
               for(i = 0; i < numRow; i++)
               {
                  isRowValid = this.isRowValid(Map.PATH,i);
                  matchesType = false;
                  if(isRowValid)
                  {
                     tableType = TableUtil.getValue(Map.PATH,i,Map.TYPE);
                     if(isPvp)
                     {
                        matchesType = tableType == Map.TYPE_PVP;
                     }
                     else
                     {
                        matchesType = tableType == Map.TYPE_COOP || tableType == Map.TYPE_ZM || tableType == Map.TYPE_ZHUNT;
                     }
                  }
                  if(isRowValid && matchesType)
                  {
                     mapID = TableUtil.getValue(Map.PATH,i,Map.ID);
                     chapter = parseInt(TableUtil.getValue(Map.PATH,i,Map.CHAPTER));
                     map = new MapObj();
                     map.id = mapID;
                     map.name = "@" + TableUtil.getValue(Map.PATH,i,Map.NAME);
                     map.description = "@" + TableUtil.getValue(Map.PATH,i,Map.DESCRIPTION);
                     map.imageURL = TableUtil.getValue(Map.PATH,i,Map.IMAGE);
                     map.minPlayer = 1;
                     map.maxPlayer = uint(TableUtil.getValue(Map.PATH,i,Map.MAX_PLAYER));
                     map.sequence = int(TableUtil.getValue(Map.PATH,i,Map.SEQUENCE));
                     map.unlocked = this.isMapUnlockedByFlag(TableUtil.getValue(Map.PATH,i,Map.UNLOCK_FLAG));
                     if(mapID in this._overrideMapAvailableModes)
                     {
                        map.availableModes = this._overrideMapAvailableModes[mapID];
                        Logger.print("MatchService:::listMap override map [" + mapID + "] modes to : [" + map.availableModes.join(";") + "] from configs");
                     }
                     else
                     {
                        map.availableModes = TableUtil.getValue(Map.PATH,i,Map.MODES).split(";");
                     }
                     if(int(TableUtil.getValue(Map.PATH,i,Map.NO_CUSTOM_ROOM)) >= 1)
                     {
                        map.noCustomRoom = true;
                     }
                     pos = TableUtil.getValue(Map.PATH,i,Map.POS).split(":");
                     if(pos != null && pos.length > 0)
                     {
                        map.x = parseInt(pos[0]);
                        map.y = parseInt(pos[1]);
                     }
                     if(!isPvp)
                     {
                        if(map.isHeroOps)
                        {
                           map.isComplete = this.isMapUnlockedByFlag("cf_ch_" + mapID);
                        }
                        map.chapter = chapter;
                        map.level = parseInt(TableUtil.getValue(Map.PATH,i,Map.LEVEL));
                        map.narrative = "@" + TableUtil.getValue(Map.PATH,i,Map.NARRATIVE);
                        if(map.isHeroOps)
                        {
                           map.narrative2 = "@" + TableUtil.getValue(Map.PATH,i,Map.NARRATIVE2);
                        }
                        map.targetEasy = "@" + TableUtil.getValue(Map.PATH,i,Map.TARGET_EASY);
                        map.targetNormal = "@" + TableUtil.getValue(Map.PATH,i,Map.TARGET_NORMAL);
                        map.targetHard = "@" + TableUtil.getValue(Map.PATH,i,Map.TARGET_HARD);
                        map.targetPlaceholder = "@" + TableUtil.getValue(Map.PATH,i,Map.TARGET_PLACEHOLDER);
                        map.hint0 = "@" + TableUtil.getValue(Map.PATH,i,Map.HINT_0);
                        map.hint1 = "@" + TableUtil.getValue(Map.PATH,i,Map.HINT_1);
                        map.hint2 = "@" + TableUtil.getValue(Map.PATH,i,Map.HINT_2);
                     }
                     map.difficultyEasy = TableUtil.getValue(Map.PATH,i,Map.DIFFICULTY_EASY) == "1";
                     map.difficultyNormal = TableUtil.getValue(Map.PATH,i,Map.DIFFICULTY_NORMAL) == "1";
                     map.difficultyHard = TableUtil.getValue(Map.PATH,i,Map.DIFFICULTY_HARD) == "1";
                     map.difficultyPlaceholder = TableUtil.getValue(Map.PATH,i,Map.DIFFICULTY_PLACEHOLDER) == "1";
                     map.unlockedHints = [];
                     unlockHint = TableUtil.getValue(Map.PATH,i,Map.UNLOCK_HINT_0);
                     if(unlockHint != null && unlockHint.length > 0)
                     {
                        map.unlockedHints.push("@" + unlockHint);
                     }
                     unlockHint = TableUtil.getValue(Map.PATH,i,Map.UNLOCK_HINT_1);
                     if(unlockHint != null && unlockHint.length > 0)
                     {
                        map.unlockedHints.push("@" + unlockHint);
                     }
                     unlockHint = TableUtil.getValue(Map.PATH,i,Map.UNLOCK_HINT_2);
                     if(unlockHint != null && unlockHint.length > 0)
                     {
                        map.unlockedHints.push("@" + unlockHint);
                     }
                     for(iLockedMap = 0; iLockedMap < publisherLockedMaps.length; iLockedMap++)
                     {
                        if(map.id == publisherLockedMaps[iLockedMap])
                        {
                           map.unlocked = false;
                           break;
                        }
                     }
                     this._mapsWithFilter[typeKey].push(map);
                  }
               }
            }
            this._mapsWithFilter[typeKey].sortOn("sequence");
         }
         var maps:Array = this._mapsWithFilter[typeKey] != null ? this._mapsWithFilter[typeKey].concat() : [];
         if(isPvp)
         {
            for(iMap2 = maps.length - 1; iMap2 >= 0; iMap2--)
            {
               if(!maps[iMap2].unlocked)
               {
                  maps.splice(iMap2,1);
               }
            }
         }
         return maps;
      }
      
      public function listMatchMode(isPvp:Boolean) : Array
      {
         var numRow:int = 0;
         var i:int = 0;
         var neededType:String = null;
         var id:String = null;
         var alias:String = null;
         var name:String = null;
         var description:String = null;
         var image:String = null;
         var maxPlayers:uint = 0;
         var defaultPlayers:uint = 0;
         var customizable:Boolean = false;
         var typeKey:String = this.getKeyForMapType(isPvp);
         if(!this._modesWithFilter.hasOwnProperty(typeKey))
         {
            if(ScaleformUtil.isScaleform)
            {
               numRow = TableUtil.getRowCount(Mode.PATH);
               if(numRow > 0)
               {
                  this._modesWithFilter[typeKey] = [];
               }
               for(i = 0; i < numRow; i++)
               {
                  if(this.isRowValid(Mode.PATH,i))
                  {
                     neededType = isPvp ? Mode.TYPE_PVP : Mode.TYPE_PVE;
                     if(TableUtil.getValue(Mode.PATH,i,Mode.TYPE) == neededType)
                     {
                        id = TableUtil.getValue(Mode.PATH,i,Mode.ID);
                        if(!CFunctionCommonContainer.AS_IsGameTypeDisabled(id))
                        {
                           alias = TableUtil.getValue(Mode.PATH,i,Mode.ALIAS);
                           name = "@" + TableUtil.getValue(Mode.PATH,i,Mode.NAME);
                           description = "@" + TableUtil.getValue(Mode.PATH,i,Mode.DESCRIPTION);
                           image = TableUtil.getValue(Mode.PATH,i,Mode.IMAGE);
                           maxPlayers = uint(TableUtil.getValue(Mode.PATH,i,Mode.MAXPLAYERS));
                           defaultPlayers = uint(TableUtil.getValue(Mode.PATH,i,Mode.DEFAULTPLAYERS));
                           customizable = TableUtil.getValue(Mode.PATH,i,Mode.CUSTOMIZABLE) == "1";
                           this._modesWithFilter[typeKey].push(new ModeObj({
                              "id":id,
                              "alias":alias,
                              "name":name,
                              "description":description,
                              "image":image,
                              "minPlayers":1,
                              "maxPlayers":maxPlayers,
                              "defaultPlayers":defaultPlayers,
                              "customizable":customizable
                           }));
                        }
                     }
                  }
               }
            }
         }
         return this._modesWithFilter[typeKey] != null ? this._modesWithFilter[typeKey].concat() : [];
      }
      
      public function listSupportedOptions(mode:String) : Array
      {
         var options:String = null;
         var splitOptions:Array = null;
         var j:int = 0;
         var supportedOptions:Array = [];
         var numRow:int = TableUtil.getRowCount(Mode.PATH);
         for(var i:int = 0; i < numRow; i++)
         {
            if(this.isRowValid(Mode.PATH,i))
            {
               if(TableUtil.getValue(Mode.PATH,i,Mode.ID) == mode)
               {
                  options = TableUtil.getValue(Mode.PATH,i,Mode.SUPPORTED_OPTIONS);
                  if(StringUtil.trim(options) != "")
                  {
                     splitOptions = options.split("|");
                     for(j = 0; j < splitOptions.length; j++)
                     {
                        supportedOptions.push(int(splitOptions[j]));
                     }
                  }
               }
            }
         }
         return supportedOptions;
      }
      
      public function listPrimaryOptions(mode:String) : Array
      {
         var options:String = null;
         var splitOptions:Array = null;
         var j:int = 0;
         var primaryOptions:Array = [];
         var numRow:int = TableUtil.getRowCount(Mode.PATH);
         for(var i:int = 0; i < numRow; i++)
         {
            if(this.isRowValid(Mode.PATH,i))
            {
               if(TableUtil.getValue(Mode.PATH,i,Mode.ID) == mode)
               {
                  options = TableUtil.getValue(Mode.PATH,i,Mode.PRIMARY_OPTIONS);
                  if(StringUtil.trim(options) != "")
                  {
                     splitOptions = options.split("|");
                     for(j = 0; j < splitOptions.length; j++)
                     {
                        primaryOptions.push(int(splitOptions[j]));
                     }
                  }
               }
            }
         }
         return primaryOptions;
      }
      
      public function getItemBansEnabled(mode:String) : Boolean
      {
         var value:int = parseInt(TableUtil.lookup(Mode.PATH,Mode.ID,mode,Mode.BANS_ENABLED));
         return value == 1;
      }
      
      public function listLeague() : Array
      {
         var numRow:int = 0;
         var i:int = 0;
         if(this._leagues.length <= 0)
         {
            if(ScaleformUtil.isScaleform)
            {
               numRow = TableUtil.getRowCount(League.PATH);
               for(i = 0; i < numRow; i++)
               {
                  if(this.isRowValid(League.PATH,i))
                  {
                     this._leagues.push({
                        "id":int(TableUtil.getValue(League.PATH,i,League.ID)),
                        "name":"@" + TableUtil.getValue(League.PATH,i,League.NAME),
                        "description":"@" + TableUtil.getValue(League.PATH,i,League.DESCRIPTION)
                     });
                  }
               }
            }
            else
            {
               this._leagues.push({
                  "id":0,
                  "name":DictRoom.LEAGUE_0,
                  "description":DictRoom.LEAGUE_0
               });
               this._leagues.push({
                  "id":1,
                  "name":DictRoom.LEAGUE_1,
                  "description":DictRoom.LEAGUE_1
               });
               this._leagues.push({
                  "id":2,
                  "name":DictRoom.LEAGUE_2,
                  "description":DictRoom.LEAGUE_2
               });
               this._leagues.push({
                  "id":3,
                  "name":DictRoom.LEAGUE_3,
                  "description":DictRoom.LEAGUE_3
               });
               this._leagues.push({
                  "id":4,
                  "name":DictRoom.LEAGUE_4,
                  "description":DictRoom.LEAGUE_4
               });
            }
         }
         return this._leagues.concat();
      }
      
      public function listDifficulty(cMap:Object = null) : Array
      {
         var map:Object = null;
         if(cMap != null)
         {
            this._levels.splice(0);
            map = this.getMapObj(cMap.id);
            if(map == null)
            {
               map = cMap;
            }
            if(Boolean(map.difficultyEasy))
            {
               this._levels.push({
                  "id":0,
                  "name":DictRoom.ROOM_LEVELS[0]
               });
            }
            if(Boolean(map.difficultyNormal))
            {
               this._levels.push({
                  "id":1,
                  "name":DictRoom.ROOM_LEVELS[1]
               });
            }
            if(Boolean(map.difficultyHard))
            {
               this._levels.push({
                  "id":2,
                  "name":DictRoom.ROOM_LEVELS[2]
               });
            }
            if(Boolean(map.difficultyPlaceholder))
            {
               this._levels.push({
                  "id":3,
                  "name":DictRoom.ROOM_LEVELS[3]
               });
            }
         }
         else
         {
            this._levels.splice(0);
            this._levels.push({
               "id":0,
               "name":DictRoom.ROOM_LEVELS[0]
            });
            this._levels.push({
               "id":1,
               "name":DictRoom.ROOM_LEVELS[1]
            });
            this._levels.push({
               "id":2,
               "name":DictRoom.ROOM_LEVELS[2]
            });
         }
         return this._levels.concat();
      }
      
      private function fullClientDownloaded(evt:ParaEvent) : void
      {
         this._isPlayListInit = false;
      }
      
      public function listPlayList(leagueID:uint, playlistType:uint = 1, ignoreLeague:Boolean = false, homepageAdOnly:Boolean = false) : Array
      {
         var fullPlayList:Array = null;
         var prop:* = undefined;
         var playerMaxLevel:uint = 0;
         var usingFullClient:Boolean = false;
         var unlockAll:Boolean = false;
         var i:int = 0;
         var playListObj:PlayListObj = null;
         var unlockFlagStartInt:int = 0;
         var unlockFlagEndInt:int = 0;
         var bFound:Boolean = false;
         var idxE:int = 0;
         var idxM:int = 0;
         var entryObj:Object = null;
         var endRank:int = 0;
         var mapObj:Object = null;
         var modeObj:Object = null;
         var j:uint = 0;
         var obj:PlayListObj = null;
         var prop2:* = undefined;
         var p:int = 0;
         var k:int = 0;
         if(!this._isPlayListInit || Boolean(CFunctionContainer.AS_PlayListUpdated()))
         {
            if(ScaleformUtil.isScaleform)
            {
               fullPlayList = CFunctionContainer.GetPlayList();
               if(fullPlayList.length == 0)
               {
                  return fullPlayList;
               }
               this.getDP(DataID.LIST_CLEAR_TIMED_PLAYLIST);
               for each(prop in this._playListWithFilter)
               {
                  if(prop is Array)
                  {
                     prop.splice(0);
                  }
               }
               playerMaxLevel = CFunctionCommonContainer.GetPlayerMaxLevel() - 1;
               usingFullClient = CFunctionContainer.IsFullClient() as Boolean;
               unlockAll = this.getDvarBool("ui_unlock_allplaylists");
               for(i = 0; i < fullPlayList.length; i++)
               {
                  playListObj = new PlayListObj(fullPlayList[i]);
                  this.getDP(DataID.LIST_COLLECT_TIMED_PLAYLIST,[playListObj]);
                  if(!this._playListWithFilter.hasOwnProperty(playListObj.leagueID.toString()))
                  {
                     this._playListWithFilter[playListObj.leagueID] = [];
                  }
                  if(playListObj.minMapValidVotes > playListObj.minRoomSize)
                  {
                     playListObj.minMapValidVotes = playListObj.minRoomSize;
                  }
                  if(playListObj.type == PlayListType.COMBAT)
                  {
                     if(playListObj.combatTrainingType <= 0)
                     {
                        playListObj.minRoomSize = 1;
                     }
                     else
                     {
                        playListObj.maxRoomSize = playListObj.combatTrainingType * 2;
                     }
                  }
                  unlockFlagStartInt = playListObj.unlockLevelStart - 1;
                  unlockFlagEndInt = playListObj.unlockLevelEnd - 1;
                  playListObj.unlocked = unlockAll;
                  if(!playListObj.unlocked)
                  {
                     if(unlockFlagStartInt <= 0 || Boolean(CFunctionContainer.IsFlagUnlocked("uf_prestige_rank",unlockFlagStartInt)))
                     {
                        if(unlockFlagEndInt <= 0 || unlockFlagEndInt == playerMaxLevel)
                        {
                           playListObj.unlocked = true;
                        }
                        else
                        {
                           endRank = unlockFlagEndInt + 1;
                           if(!CFunctionContainer.IsFlagUnlocked("uf_prestige_rank",endRank))
                           {
                              playListObj.unlocked = true;
                           }
                        }
                     }
                     if(!playListObj.unlocked)
                     {
                        playListObj.unlockHint = DictCareer.NOTE_CANT_JOIN_BOOTCAMP;
                     }
                     else
                     {
                        if(playListObj.unlockFlag != "")
                        {
                           playListObj.unlocked = CFunctionContainer.IsFlagUnlocked(playListObj.unlockFlag,1) as Boolean;
                        }
                        if(!playListObj.unlocked)
                        {
                           playListObj.unlockHint = MiscUtil.getLocalizedPlaylistUnlockHintByFlag(playListObj.unlockFlag);
                        }
                     }
                  }
                  playListObj.dlcLocked = false;
                  if(!usingFullClient)
                  {
                     playListObj.dlcLocked = !CFunctionContainer.isDLCLevelAvailable(playListObj.dlcLevel);
                  }
                  playListObj.unlockedLevels.splice(0);
                  playListObj.unlockedLevels.push({
                     "start":(playListObj.unlockLevelStart > 0 ? playListObj.unlockLevelStart : 1),
                     "end":(playListObj.unlockLevelEnd > 0 ? playListObj.unlockLevelEnd : CFunctionCommonContainer.GetPlayerMaxLevel())
                  });
                  bFound = false;
                  idxE = 0;
                  idxM = 0;
                  for(idxE = 0; idxE < playListObj.entries.length; idxE++)
                  {
                     entryObj = playListObj.entries[idxE];
                     bFound = false;
                     for(idxM = 0; idxM < playListObj.maps.length; idxM++)
                     {
                        if(playListObj.maps[idxM].id == entryObj.map)
                        {
                           bFound = true;
                           break;
                        }
                     }
                     if(!bFound)
                     {
                        mapObj = this.getMapObj(String(entryObj.map).toLowerCase());
                        if(mapObj != null)
                        {
                           playListObj.maps.push(mapObj);
                        }
                     }
                     bFound = false;
                     for(idxM = 0; idxM < playListObj.modes.length; idxM++)
                     {
                        if(playListObj.modes[idxM].id == entryObj.gametype || playListObj.modes[idxM].alias == entryObj.gametype)
                        {
                           bFound = true;
                           break;
                        }
                     }
                     if(!bFound)
                     {
                        modeObj = this.getModeObj(String(entryObj.gametype).toLowerCase());
                        if(modeObj != null)
                        {
                           playListObj.modes.push(modeObj);
                        }
                     }
                  }
                  this._playListWithFilter[playListObj.leagueID].push(playListObj);
               }
            }
            else
            {
               for(j = 0; j < 32; j++)
               {
                  obj = new PlayListObj({
                     "name":"name" + j,
                     "description":"description" + j,
                     "id":j,
                     "leagueID":j % 5,
                     "minPartySize":j,
                     "maxPartySize":j,
                     "type":Math.max(1,j % 4)
                  });
                  if(!this._playListWithFilter.hasOwnProperty(obj.leagueID.toString()))
                  {
                     this._playListWithFilter[obj.leagueID] = [];
                  }
                  this._playListWithFilter[obj.leagueID].push(obj);
               }
            }
            this._isPlayListInit = true;
         }
         var pl:Array = [];
         if(ignoreLeague)
         {
            for each(prop2 in this._playListWithFilter)
            {
               if(prop2 is Array)
               {
                  for(p = 0; p < prop2.length; p++)
                  {
                     if(homepageAdOnly)
                     {
                        if(prop2[p].homepageAdSlot > 0)
                        {
                           pl.push(prop2[p]);
                        }
                     }
                     else if(prop2[p].type == playlistType)
                     {
                        pl.push(prop2[p]);
                     }
                  }
               }
            }
         }
         else if(Boolean(this._playListWithFilter[leagueID]))
         {
            for(k = 0; k < this._playListWithFilter[leagueID].length; k++)
            {
               if(homepageAdOnly)
               {
                  if(this._playListWithFilter[leagueID][k].homepageAdSlot > 0)
                  {
                     pl.push(this._playListWithFilter[leagueID][k]);
                  }
               }
               else if(this._playListWithFilter[leagueID][k].type == playlistType)
               {
                  pl.push(this._playListWithFilter[leagueID][k]);
               }
            }
         }
         pl.sortOn("displayOrder",Array.NUMERIC);
         return pl;
      }
      
      public function listRoomListFilterStatus() : Array
      {
         if(this._roomListFilterStatus == null)
         {
            this._roomListFilterStatus = [{
               "name":DictRoom.ROOM_LIST_FILTER_STATUS_ALL,
               "id":0
            },{
               "name":DictRoom.ROOM_LIST_FILTER_STATUS_FREE,
               "id":1
            }];
         }
         return this._roomListFilterStatus;
      }
      
      public function setPlayListPlayerNum(playListGroup:Array) : void
      {
         var pl:PlayListObj = null;
         if(playListGroup == null || playListGroup.length <= 0)
         {
            return;
         }
         var ui_pl_min_player_cool:int = this.getDvarInt("ui_pl_min_player_cool");
         var ui_pl_min_player_warm:int = this.getDvarInt("ui_pl_min_player_warm");
         for(var i:int = 0; i < playListGroup.length; i++)
         {
            pl = this.getPlayListObj(playListGroup[i].groupID);
            if(pl != null)
            {
               pl.playerCount = playListGroup[i].groupCount;
               if(pl.playerCount >= ui_pl_min_player_warm)
               {
                  pl.playerCountStatus = Common.PLAYLIST_WARM;
               }
               else if(pl.playerCount >= ui_pl_min_player_cool)
               {
                  pl.playerCountStatus = Common.PLAYLIST_COOL;
               }
               else
               {
                  pl.playerCountStatus = Common.PLAYLIST_COLD;
               }
            }
         }
      }
      
      private function getModeRule(column:uint, label:String = "", localizedUnit:String = "", localizedNone:String = "") : Object
      {
         var value:String = null;
         var id:Number = NaN;
         var j:int = 0;
         var modeRule:Object = {
            "label":label,
            "defaultIndex":0,
            "data":[]
         };
         var defaultID:Number = -1;
         var numRow:int = TableUtil.getRowCount(MatchOption.PATH);
         for(var i:int = 0; i < numRow; i++)
         {
            value = TableUtil.getValue(MatchOption.PATH,i,column);
            if(value != null && value.length > 0)
            {
               if(value.indexOf("*") == 0)
               {
                  value = value.substring(1,value.length);
                  defaultID = Number(value);
               }
               id = Number(value);
               if(id != -1)
               {
                  modeRule.data.push({
                     "name":(id > 0 ? LocalizeUtil.param(localizedUnit,[id]) : localizedNone),
                     "id":id
                  });
               }
            }
         }
         if(defaultID != -1)
         {
            for(j = 0; j < modeRule.data.length; j++)
            {
               if(modeRule.data[j].id == defaultID)
               {
                  modeRule.defaultIndex = j;
                  break;
               }
            }
         }
         return modeRule;
      }
      
      private function getTimeLimit(column:uint, unit0:String = "@SF_UI_LIMIT_TIME_M", unit1:String = "@SF_UI_UNLIMITED") : Object
      {
         var ruleObj:Object = this.getModeRule(column,DictRoom.GAME_RULES_TIME_LIMIT,unit0,unit1);
         if(!ScaleformUtil.isScaleform)
         {
            ruleObj.data.push({
               "name":"5分钟",
               "id":5
            });
            ruleObj.data.push({
               "name":"10分钟",
               "id":10
            });
            ruleObj.data.push({
               "name":"15分钟",
               "id":15
            });
            ruleObj.data.push({
               "name":"20分钟",
               "id":20
            });
         }
         return ruleObj;
      }
      
      private function getScoreLimit(column:uint) : Object
      {
         var ruleObj:Object = this.getModeRule(column,DictRoom.GAME_RULES_SCORE_LIMIT,DictRoom.LIMIT_SCORE,DictRoom.UNLIMITED);
         if(!ScaleformUtil.isScaleform)
         {
            ruleObj.data.push({
               "name":"无限制",
               "id":0
            });
            ruleObj.data.push({
               "name":"25分",
               "id":25
            });
            ruleObj.data.push({
               "name":"50分",
               "id":50
            });
            ruleObj.data.push({
               "name":"75分",
               "id":75
            });
            ruleObj.data.push({
               "name":"100分",
               "id":100
            });
            ruleObj.data.push({
               "name":"150分",
               "id":150
            });
         }
         return ruleObj;
      }
      
      private function getRoundSwitch(column:uint) : Object
      {
         var unit:String = DictRoom.LIMIT_ROUND;
         if(column == MatchOption.ROUND_SWITCH_DD)
         {
            unit = DictRoom.GAME_RULES_ROUND_EVERY;
         }
         return this.getModeRule(column,DictRoom.GAME_RULES_ROUND_SWITCH,unit,DictRoom.GAME_RULES_ROUND_NEVER);
      }
      
      private function getBombTimer(column:uint) : Object
      {
         return this.getModeRule(column,DictRoom.GAME_RULES_BOMB_TIMER,DictRoom.LIMIT_TIME_S);
      }
      
      private function getPlantDiffuseTime(column:uint) : Object
      {
         return this.getModeRule(column,DictRoom.GAME_RULES_PLANT_DIFFUSE_TIME,DictRoom.LIMIT_TIME_S);
      }
      
      private function getExtraTime(column:uint) : Object
      {
         return this.getModeRule(column,DictRoom.GAME_RULES_EXTRA_TIME,DictRoom.LIMIT_TIME_M,DictRoom.EXTRA_TIME_NONE);
      }
      
      private function getRoundLength(column:uint) : Object
      {
         return this.getModeRule(column,DictRoom.GAME_RULES_ROUND_LENGTH,DictRoom.LIMIT_TIME_M,DictRoom.UNLIMITED);
      }
      
      public function getGameRulesByModeID(modeID:String) : Array
      {
         if(this._modeRules[modeID] == null)
         {
            this._modeRules[modeID] = [];
            switch(modeID)
            {
               case "war":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_WAR));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_WAR));
                  break;
               case "dom":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_DOM));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_DOM));
                  break;
               case "dd":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_DD));
                  this._modeRules[modeID].push(this.getRoundSwitch(MatchOption.ROUND_SWITCH_DD));
                  this._modeRules[modeID].push(this.getBombTimer(MatchOption.BOMB_TIMER_DD));
                  this._modeRules[modeID].push(this.getPlantDiffuseTime(MatchOption.PLANT_DIFFUSE_TIME_DD));
                  this._modeRules[modeID].push(this.getExtraTime(MatchOption.EXTRA_TIME_DD));
                  break;
               case "dm":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_DM));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_DM));
                  break;
               case "sd":
               case "sdp":
               case "sdc":
                  this._modeRules[modeID].push(this.getRoundLength(MatchOption.ROUND_LENGTH_SD));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_SD));
                  this._modeRules[modeID].push(this.getRoundSwitch(MatchOption.ROUND_SWITCH_SD));
                  this._modeRules[modeID].push(this.getBombTimer(MatchOption.BOMB_TIMER_SD));
                  this._modeRules[modeID].push(this.getPlantDiffuseTime(MatchOption.PLANT_DIFFUSE_TIME_SD));
                  break;
               case "sab":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_SAB));
                  this._modeRules[modeID].push(this.getBombTimer(MatchOption.BOMB_TIMER_SAB));
                  this._modeRules[modeID].push(this.getPlantDiffuseTime(MatchOption.PLANT_DIFFUSE_TIME_SAB));
                  break;
               case "koth":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_KOTH));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_KOTH));
                  this._modeRules[modeID].push(this.getModeRule(MatchOption.LIFETIME_KOTH,DictRoom.GAME_RULES_HQ_LIFETIME,DictRoom.LIMIT_TIME_S,DictRoom.UNLIMITED));
                  this._modeRules[modeID].push(this.getModeRule(MatchOption.ACTIVATE_DELAY_KOTH,DictRoom.GAME_RULES_HQ_ACTIVATE_DELAY,DictRoom.LIMIT_TIME_S,DictRoom.EXTRA_TIME_NONE));
                  break;
               case "ctf":
                  this._modeRules[modeID].push(this.getRoundLength(MatchOption.ROUND_LENGTH_CTF));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_CTF));
                  break;
               case "conf":
                  this._modeRules[modeID].push(this.getTimeLimit(MatchOption.TIME_LIMIT_CONF));
                  this._modeRules[modeID].push(this.getScoreLimit(MatchOption.SCORE_LIMIT_CONF));
            }
         }
         return this._modeRules[modeID];
      }
      
      public function getPlayListHasRule(playlist:PlayListObj, rule:String) : Boolean
      {
         var rules:Array = playlist.rules.split(";");
         var len:uint = rules.length;
         for(var i:uint = 0; i < len; )
         {
            if(rules[i] == rule)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function getSpectatingByModeID(modeID:String) : Object
      {
         return this.getSpectating(modeID);
      }
      
      public function getGamePlayOptions() : Object
      {
         var options:Object = {};
         options.autoBalance = this.switches;
         options.spectating = this.getSpectating();
         options.killCam = this.switches;
         options.friendlyFire = this.friendlyFire;
         options.respawnDelay = this.respawnDelay;
         options.waveRespawnDelay = this.waveRespawnDelay;
         options.healthRegen = this.healthRegen;
         options.classRestriction = null;
         options.killStreaks = this.switches;
         options.perks = this.switches;
         return options;
      }
      
      public function get respawnDelay() : Object
      {
         return this.getTimeLimit(MatchOption.RESPAWN_DELAY,DictRoom.LIMIT_TIME_S,DictRoom.EXTRA_TIME_NONE);
      }
      
      public function get waveRespawnDelay() : Object
      {
         return this.getTimeLimit(MatchOption.WAVE_RESPAWN_DELAY,DictRoom.LIMIT_TIME_S,DictRoom.EXTRA_TIME_NONE);
      }
      
      private function get healthRegen() : Object
      {
         var i:int = 0;
         var optionObj:Object = this.getModeRule(MatchOption.HEALTH_REGEN);
         if(ScaleformUtil.isScaleform)
         {
            for(i = 0; i < optionObj.data.length; i++)
            {
               optionObj.data[i].name = DictRoom.HEALTH_REGENERATIONS[i];
            }
         }
         else
         {
            optionObj.data.push({
               "name":"关闭",
               "id":0
            });
            optionObj.data.push({
               "name":"慢速",
               "id":50
            });
            optionObj.data.push({
               "name":"正常",
               "id":100
            });
            optionObj.data.push({
               "name":"快速",
               "id":200
            });
         }
         return optionObj;
      }
      
      private function getSpectating(modeID:String = "") : Object
      {
         var isFreeForAll:Boolean = modeID == "dm";
         var optionObj:Object = {
            "label":"",
            "defaultIndex":(isFreeForAll ? 1 : 2),
            "data":[]
         };
         optionObj.data.push({
            "name":DictRoom.GAME_OPTION_DISABLE,
            "id":0
         });
         if(!isFreeForAll)
         {
            optionObj.data.push({
               "name":DictRoom.GAME_OPTION_SPECTATING_TEAM_ONLY,
               "id":1
            });
         }
         return optionObj;
      }
      
      private function get friendlyFire() : Object
      {
         var optionObj:Object = {
            "label":"",
            "defaultIndex":0,
            "data":[]
         };
         optionObj.data.push({
            "name":DictRoom.GAME_OPTION_DISABLE,
            "id":0
         });
         optionObj.data.push({
            "name":DictRoom.GAME_OPTION_ENABLE,
            "id":1
         });
         optionObj.data.push({
            "name":DictRoom.FRIENDLY_FIRE_RICOCHET,
            "id":2
         });
         optionObj.data.push({
            "name":DictRoom.FRIENDLY_FIRE_SHARED,
            "id":3
         });
         optionObj.data.push({
            "name":DictRoom.FRIENDLY_FIRE_FULL,
            "id":4
         });
         return optionObj;
      }
      
      private function get switches() : Object
      {
         var optionObj:Object = {
            "label":"",
            "defaultIndex":0,
            "data":[]
         };
         optionObj.data.push({
            "name":DictRoom.GAME_OPTION_ENABLE,
            "id":true
         });
         optionObj.data.push({
            "name":DictRoom.GAME_OPTION_DISABLE,
            "id":false
         });
         return optionObj;
      }
      
      public function getCurrentLeague() : uint
      {
         return CFunctionCommonContainer.GetPlayerCurrentLeague();
      }
      
      public function getCTBonus(leagueID:uint) : int
      {
         return int(TableUtil.lookup(MatchBonus.PATH,0,"ct",leagueID + 1));
      }
      
      public function getMPBonus(leagueID:uint) : int
      {
         return int(TableUtil.lookup(MatchBonus.PATH,0,"mp",leagueID + 1));
      }
      
      private function isMapUnlockedByFlag(unlockFlag:String) : Boolean
      {
         return Boolean(CFunctionContainer.IsMapUnlocked(unlockFlag));
      }
      
      private function getObjByID(dic:Dictionary, id:String) : Object
      {
         var prop:* = undefined;
         var p:int = 0;
         for each(prop in dic)
         {
            if(prop is Array)
            {
               p = 0;
               while(p < prop.length)
               {
                  if(prop[p].id == id || Boolean(prop[p].alias) && Boolean(prop[p].alias == id))
                  {
                     return prop[p];
                     break;
                  }
                  p++;
               }
            }
         }
         return null;
      }
      
      private function enableRoomListEvent(bEnable:Boolean) : void
      {
         CFunctionContainer.EnableRoomListEvent(bEnable);
      }
      
      private function enableInRoomEvent(bEnable:Boolean) : void
      {
         CFunctionContainer.EnableInRoomEvent(bEnable);
      }
      
      public function get isInRoom() : Boolean
      {
         return ScaleformUtil.isScaleform ? Boolean(CFunctionCommonContainer.IsInRoom()) : this._isInRoom;
      }
      
      public function set isInRoom(cIn:Boolean) : void
      {
         this._isInRoom = cIn;
      }
      
      public function isJoiningRoom() : Boolean
      {
         return this.isTaskInProgress(DataID.JOIN_ROOM);
      }
      
      public function isLeavingRoom() : Boolean
      {
         return this.isTaskInProgress(DataID.LEAVE_ROOM);
      }
      
      public function get isPlayerReady() : Boolean
      {
         return ScaleformUtil.isScaleform ? Boolean(CFunctionContainer.IsPlayerStatsReady()) : true;
      }
   }
}

