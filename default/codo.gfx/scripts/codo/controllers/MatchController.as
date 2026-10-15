package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.CombatType;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.MusicID;
   import codo.constants.PageID;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.RankedMatchStatus;
   import codo.constants.RoomMatchType;
   import codo.constants.RoomStatus;
   import codo.constants.SE_ID;
   import codo.constants.SanitizedType;
   import codo.constants.ServerChannel;
   import codo.constants.SystemMsgPriority;
   import codo.constants.table.Mode;
   import codo.event.ParaEvent;
   import codo.localization.DictInvitation;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.objects.*;
   import codo.services.MatchService;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import codo.utils.StringUtil;
   import com.society.comscore.DAXDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MatchController extends BaseController
   {
      
      private static const MINICLIENT_UNAVAILABLE_GAME_MODE:Array = ["clash","zhunt","nftbl"];
      
      private var _mpStartLockScreenCount:Number = 5;
      
      private var _isListingRoom:Boolean = false;
      
      private var _inRoomChannel:Boolean;
      
      private var _roomListDP:Array = [];
      
      private var _timedplayListDp:Array = [];
      
      private var _currentMatchType:QuickMatchType = new QuickMatchType();
      
      private var _currentQuickMatchFilter:QuickMatchFilterObj = null;
      
      private var _currentChannel:uint = ServerChannel.NONE;
      
      private var _currentRankedMatchStatus:String = "idle";
      
      private var _previousRankedMatchStatus:String = "idle";
      
      private var _currentSelectedLeague:uint = 1;
      
      private var _rankedMatchGoRoomTime:int = 0;
      
      private var _rankedMatchGoGameTime:int = 0;
      
      private var _rankedMatchGoRoomTimer:Timer = null;
      
      private var _rankedMatchGoGameTimer:Timer = null;
      
      private var _rankedMatchLobbyUpdateTimer:Timer = null;
      
      private var _unrankedMatchGoGameTime:int = 0;
      
      private var _unrankedMatchGoGameTimer:Timer = null;
      
      private var _fetchGroupCountTimer:Timer = null;
      
      private var _isRankedMatchInRoomDone:Boolean = false;
      
      private var _isMatchBeingLocked:Boolean = false;
      
      private var _isPlayerStatsReady:Boolean = false;
      
      private var _newUnlockedCoopStoryMap:String = "";
      
      private var _tryJoinRoomPara:Object;
      
      private var _roomToCreate:Object;
      
      private var _groupCounts:Object = new Object();
      
      private var _fakeElapsedTime:Number = 0;
      
      private var _roomHistory:Object;
      
      private var mStartMatchMsg:SystemMsgObj;
      
      public function MatchController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this._mpStartLockScreenCount = CFunctionCommonContainer.Dvar_GetFloat("dw_lockLobbyCountingDown");
      }
      
      override protected function onInitialized() : void
      {
         bind(DataID.QUICK_MATCH_DEBUG,this.onQuickMatchDebug);
         bind(DataID.CANCEL_LIST_ROOM,this.bind_cancelListRoom);
         bind(DataID.JOIN_ROOM,this.onRoomJoined);
         bind(DataID.QUICK_MATCH_INTERMISSION,this.bind_rankedMatchIntermission);
         bind(DataID.QUICK_MATCH_IN_PROGRESS_IN_ROOM,this.bind_rankedMatchInProgressInRoom);
         bind(DataID.START_MATCH_COUNTDOWN,this.bind_startMatchCountingDown);
         bind(DataID.START_MATCH,this.bind_startMatchComplete);
         bind(DataID.QUICK_MATCH,this.bind_quickMatchReady);
         bind(DataID.JUMP_GAME,this.bind_jumpGameComplete);
         bind(DataID.GROUP_COUNTS,this.bind_groupCounts);
         addDP(DataID.DEFAULT_ROOM_NAME,this.getDefaultRoomName);
         addDP(DataID.CURRENT_MATCH_TYPE,this.getCurrentMatchType);
         addDP(DataID.CURRENT_RANKED_MATCH_STATUS,this.getCurrentRankedMatchStatus);
         addDP(DataID.CURRENT_LEAGUE,this.getCurrentLeague);
         addDP(DataID.CURRENT_LEAGUE_NAME,this.getCurrentLeagueName);
         addDP(DataID.IS_CYBORG,this.isCyborgMode);
         addDP(DataID.IS_IN_RANKED_MATCH,this.isInRankedMatch);
         addDP(DataID.IS_RANKED_MATCH_IN_PROGRESS,this.isRankedMatchInProgress);
         addDP(DataID.IS_RANKED_MATCH_READY,this.isRankedMatchReady);
         addDP(DataID.IS_BOOT_CAMP,this.isBootCamp);
         addDP(DataID.IS_IN_ROOM,this.isInRoom);
         addDP(DataID.IS_ROOM_FULL,this.isRoomFull);
         addDP(DataID.IS_IN_AAR,this.isInAAR);
         addDP(DataID.NEW_UNLOCKED_COOP_STORY_MAP,this.getNewUnlockedCoopStoryMap);
         addDP(DataID.LIST_MAP,this.listMap);
         addDP(DataID.LIST_MODE,this.listMode);
         addDP(DataID.LIST_LEAGUE,this.listLeague);
         addDP(DataID.LIST_DIFFICULTY,this.listDifficulty);
         addDP(DataID.LIST_DIFFICULTY_CT_CREATOR,this.listCTDifficulty);
         addDP(DataID.LIST_PLAY_LIST_MP,this.listPlayListMP);
         addDP(DataID.LIST_PLAY_LIST_PVE,this.listPlayListPve);
         addDP(DataID.LIST_PLAY_LIST_BATTLECITY,this.listPlayListBattleCity);
         addDP(DataID.LIST_PLAY_LIST_BY_TYPE,this.listPlayListByType);
         addDP(DataID.LIST_PLAY_LIST,this.listPlayList);
         addDP(DataID.LIST_PLAY_LIST_HOMEPAGE_AD,this.listPlayListHomepageAd);
         addDP(DataID.LIST_MATCH_QUICK_MP_PLAY_LIST,this.listQuickMPPlayList);
         addDP(DataID.LIST_MAX_PLAYER,this.listMaxPlayer);
         addDP(DataID.LIST_MAX_PLAYER_CT,this.listCTMaxPlayer);
         addDP(DataID.LIST_ROOM_LIST_FILTER_STATUS,this.listRoomListFilterStatus);
         addDP(DataID.LIST_CLEAR_TIMED_PLAYLIST,this.clearTimedPlayList);
         addDP(DataID.LIST_COLLECT_TIMED_PLAYLIST,this.collectTimedPlayList);
         addDP(DataID.GET_GAME_RULES_BY_MODE_ID,this.getGameRulesByModeID);
         addDP(DataID.GET_SPECTATING_BY_MODE_ID,this.getSpectatingByModeID);
         addDP(DataID.GET_GAME_PLAY_OPTIONS,this.getGamePlayOptions);
         addDP(DataID.MAP_OBJ,this.getMapObj);
         addDP(DataID.IS_UNAVAILABLE_MINICLIENT_MODE,this.getIsUnavailableMiniClientMode);
         addDP(DataID.MATCH_MODE_OBJ,this.getMatchModeObj);
         addDP(DataID.PLAY_LIST_OBJ,this.getPlayListObj);
         addDP(DataID.BONUS_CT_PER_MIN,this.getCTBonus);
         addDP(DataID.BONUS_MP_PER_MIN,this.getMPBonus);
         addDP(DataID.DELAY_TO_SHOW_BUTTON,this.getDelayToShowButton);
         addDP(DataID.ROOM_DLC_LEVEL,this.getRoomDLCLevel);
         addDP(DataID.CURRENT_PLAYER_DLC_LEVEL,this.getCurruntDLCLevel);
         addDP(DataID.MAX_ROOM_NAME_LENGTH,this.GetMaxRoomNameLength);
         listen(BCEvent.EVT_SET_MATCH_TYPE,this.onSetQuickMatchTypeHandle);
         listen(BCEvent.EVT_CREATE_ROOM,this.onCreateRoomHandle);
         listen(BCEvent.TRY_JOIN_ROOM,this.tryJoinRoomHandle);
         listen(BCEvent.TRY_JOIN_FRIEND_PRIVATE_ROOM,this.tryJoinFriendPrivateRoom);
         listen(BCEvent.JOIN_ROOM,this.joinRoomHandle);
         listen(BCEvent.GOTO_FIRST_PAGE,this.onGoToFirstPageHandle);
         listen(BCEvent.EVT_BACK_TO_ROOM,this.onBackToRoomHandle);
         listen(BCEvent.ROOM_INFO_ONLY,this.onOnlyRoomInfoHandle);
         listen(BCEvent.EVT_CONFIRM_ENTER_JOIN_ROOM_PASSWORD,this.onConfirmEnterJoinRoomPasswordHandle);
         listen(BCEvent.EVT_CANCEL_ENTER_JOIN_ROOM_PASSWORD,this.onCancelEnterJoinRoomPasswordHandle);
         listen(BCEvent.PROPOSE_ROOM_MEMBERSHIP,this.onProposeRoomMembershipHandle);
         listen(BCEvent.REJECT_ROOM_MEMBERSHIP,this.onRejectRoomMembershipHandle);
         listen(BCEvent.EVT_QUICK_MATCH_COOP,this.onQuickMatchCoopHandle);
         listen(BCEvent.EVT_QUICK_MATCH_TRAINING,this.onQuickMatchTrainingHandle);
         listen(BCEvent.EVT_QUICK_MATCH,this.onQuickMatchHandle);
         listen(BCEvent.EVT_START_QUICK_MATCH_MP,this.onQuickMatchMpHandle);
         listen(BCEvent.ON_ROOM_LEFT,this.onRoomLeftHandle);
         listen(BCEvent.LEAVE_ROOM,this.onLeaveRoomHandle);
         listen(BCEvent.MATCH_QUICK_MP_CHANGE_LEAGUE,this.onMatchQuickMpLeagueChangedHandle);
         listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onRoomNameSanitizedHandle);
         listen(BCEvent.EVT_SHOW_TOKEN_BUY_POPUP,this.onShowTokenBuyPopupHandle);
         listen(BCEvent.EVT_QUIT_TOKEN_BUY_POPUP,this.onQuitTokenBuyPopupHandle);
         listen(BCEvent.EVT_TOKEN_BUY_POPUP_START_GAME,this.onTokenBuyPopupStartGameHandle);
         listen(BCEvent.EVT_PLAY_MAINMENU_SOUND,this.onPlayMainMenuSound);
         listen(BCEvent.EVT_OPEN_GAME_MODE_TUTORIAL,this.onOpenGamemodeTutorialClick);
         listen(BCEvent.EVT_OPEN_GAME_MODE_IMAGE,this.onOpenGameModeImage);
      }
      
      override public function update(deltaTime:Number) : void
      {
         var changed:Boolean = false;
         var ret:Boolean = false;
         if(!this._isPlayerStatsReady)
         {
            if(ScaleformUtil.isScaleform)
            {
               this._isPlayerStatsReady = CFunctionContainer.IsPlayerStatsReady() as Boolean;
            }
            else
            {
               this._fakeElapsedTime += deltaTime;
               if(this._fakeElapsedTime >= 0.3)
               {
                  this._isPlayerStatsReady = true;
               }
            }
            if(this._isPlayerStatsReady)
            {
               broadcast(BCEvent.EVT_PLAYER_STATS_READY);
               broadcast(BCEvent.EVT_HIDE_SYSTEM_CONNECT);
               this.enableRoomListEvent(true);
            }
         }
         changed = false;
         for(var i:int = 0; i < this._timedplayListDp.length; i++)
         {
            ret = CFunctionContainer.AS_PlayListValid(this._timedplayListDp[i].index) as Boolean;
            if(this._timedplayListDp[i].unlockedTimedMatch != ret)
            {
               this._timedplayListDp[i].unlockedTimedMatch = ret;
               changed = true;
            }
         }
         if(changed)
         {
            setBindData(DataID.GROUP_COUNTS,this._groupCounts);
         }
      }
      
      private function cancelListRoom() : void
      {
         MatchService.getInstance().cancelListRoom();
      }
      
      private function cancelRankedMatch() : void
      {
         MatchService.getInstance().cancelRankedMatch();
         if(!this.isInRoom())
         {
            this.onRankedMatchCanceled();
         }
      }
      
      private function onSetQuickMatchTypeHandle(cEvt:ParaEvent) : void
      {
         var matchType:QuickMatchType = cEvt.myPara as QuickMatchType;
         this.setCurrentMatchType(matchType,false,true);
      }
      
      private function onRoomNameSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type == SanitizedType.ROOM_NAME && !cEvt.myPara.sanitized && Boolean(this._roomToCreate))
         {
            request(DataID.CREATE_ROOM,this._roomToCreate,this.onRoomCreated);
         }
      }
      
      private function getDefaultRoomName() : String
      {
         return ScaleformUtil.isScaleform ? getDP(DataID.PLAYER_USER_NAME) : DictRoom.ROOM_DEFAULT_NAME;
      }
      
      private function setMatchTypeByRoom() : void
      {
         var pl:PlayListObj = null;
         var newType:QuickMatchType = QuickMatchType.makePvp();
         var roomInfo:Object = CFunctionContainer.GetRoomInfo();
         if(roomInfo != null && roomInfo.playListID >= 0)
         {
            pl = this.getPlayListObj(roomInfo.playListID);
            newType = QuickMatchType.fromPlaylistType(pl.type);
         }
         if(!newType.modeEquals(this._currentMatchType))
         {
            this.setCurrentMatchType(newType,false,false);
         }
      }
      
      private function setCurrentMatchType(newType:QuickMatchType, cPlay:Boolean, updateChannel:Boolean) : void
      {
         Logger.print("MatchController:::setCurrentMatchType cType: " + newType);
         if(!this._currentMatchType.equals(newType))
         {
            this._currentMatchType = newType;
            QuickMatchType.saveToPersistent(this._currentMatchType);
            cPlay = true;
         }
         if(updateChannel)
         {
            this.joinChannel(this._currentMatchType.serverChannel());
         }
         if(cPlay)
         {
            this.onPlayMainMenuSound();
         }
      }
      
      private function getCurrentMatchType() : QuickMatchType
      {
         return this._currentMatchType;
      }
      
      private function isCyborgMode() : Boolean
      {
         return this._currentMatchType.isCyborgs();
      }
      
      private function getCurrentRankedMatchStatus() : String
      {
         return this._currentRankedMatchStatus;
      }
      
      private function isInRankedMatch() : Boolean
      {
         return this._currentRankedMatchStatus != RankedMatchStatus.IDLE;
      }
      
      private function isRankedMatchInProgress() : Boolean
      {
         return this._currentRankedMatchStatus == RankedMatchStatus.IN_PROGRESS || this._currentRankedMatchStatus == RankedMatchStatus.IN_PROGRESS_IN_ROOM;
      }
      
      private function isRankedMatchReady() : Boolean
      {
         return this._currentRankedMatchStatus == RankedMatchStatus.READY || this._currentRankedMatchStatus == RankedMatchStatus.READY_IN_ROOM;
      }
      
      private function getCurrentLeague() : int
      {
         return MatchService.getInstance().getCurrentLeague();
      }
      
      private function getCurrentLeagueName() : String
      {
         return DictRoom.LEAGUES[this.getCurrentLeague()];
      }
      
      private function isBootCamp() : Boolean
      {
         return this.getCurrentLeague() == 0;
      }
      
      private function onCB3CoopStoryFinished() : void
      {
         this.leaveRoom(true,false,true);
      }
      
      private function resetNewUnlockedCoopStoryMap() : void
      {
         this._newUnlockedCoopStoryMap = "";
      }
      
      private function getNewUnlockedCoopStoryMap() : String
      {
         return this._newUnlockedCoopStoryMap;
      }
      
      private function isRankedMatch() : Boolean
      {
         return ScaleformUtil.isScaleform ? Boolean(CFunctionContainer.IsRankedMatch()) : this.isInRankedMatch();
      }
      
      private function isRoomFull() : Boolean
      {
         return Boolean(CFunctionContainer.IsRoomFull());
      }
      
      private function isInAAR() : Boolean
      {
         return CodoPageViewDB.PAGE_ADV_FSG_MATCH_RESULT.owner.currentPageObj == CodoPageViewDB.PAGE_ADV_FSG_MATCH_RESULT;
      }
      
      private function isPlayerReady() : Boolean
      {
         return MatchService.getInstance().isPlayerReady;
      }
      
      private function isInRoom() : Boolean
      {
         return MatchService.getInstance().isInRoom;
      }
      
      private function listMap(mode:String, dlcLevel:uint, isHeroOps:Boolean = false) : Array
      {
         var mapLevel:int = 0;
         var i:int = 0;
         var curMap:MapObj = null;
         var maps:Array = [];
         if(mode == Mode.TYPE_PVP || mode == "")
         {
            maps = maps.concat(MatchService.getInstance().listMap(true));
         }
         if(mode == Mode.TYPE_PVE || mode == "")
         {
            maps = maps.concat(MatchService.getInstance().listMap(false));
         }
         var isFullClient:Boolean = dlcLevel == CFunctionContainer.GetMaxDLCLevel();
         if(!isFullClient)
         {
            Logger.print("MatchController::listMap: list map without fullclient");
            for(i = maps.length - 1; i >= 0; i--)
            {
               mapLevel = CFunctionContainer.GetMapDLCLevel(maps[i].id);
               maps[i].dlcLevel = mapLevel;
               Logger.print("MatchController::listMap: maps[i].id:" + maps[i].id);
               Logger.print("MatchController::listMap: mapLevel:" + mapLevel);
               if(mapLevel > 0 || mapLevel == -1)
               {
                  if(isHeroOps)
                  {
                     maps[i].lockedByDLCLevel = true;
                  }
                  else
                  {
                     maps.splice(i,1);
                  }
               }
            }
         }
         else
         {
            for(i = maps.length - 1; i >= 0; i--)
            {
               if(isHeroOps)
               {
                  maps[i].lockedByDLCLevel = false;
               }
            }
         }
         if(isHeroOps)
         {
            for(i = maps.length - 1; i >= 0; i--)
            {
               curMap = maps[i];
               if(!curMap.isHeroOps)
               {
                  maps.splice(i,1);
               }
            }
         }
         return maps.concat();
      }
      
      private function listMode(requestMode:String) : Array
      {
         var modes:Array = [];
         if(requestMode == Mode.TYPE_PVP || requestMode == "")
         {
            modes = modes.concat(MatchService.getInstance().listMatchMode(true));
         }
         if(requestMode == Mode.TYPE_PVE || requestMode == "")
         {
            modes = modes.concat(MatchService.getInstance().listMatchMode(false));
         }
         return modes;
      }
      
      private function listLeague(isRoom:Boolean = false, insertAny:Boolean = false) : Array
      {
         var i:int = 0;
         var leagues:Array = MatchService.getInstance().listLeague();
         if(isRoom)
         {
            for(i = leagues.length - 1; i >= 0; i--)
            {
               if(leagues[i].id == 4)
               {
                  leagues.splice(i,1);
               }
            }
         }
         if(insertAny)
         {
            leagues.unshift({
               "name":DictRoom.ANY,
               "id":-1
            });
         }
         return leagues;
      }
      
      private function listCTDifficulty() : Array
      {
         var difficulties:Array = MatchService.getInstance().listDifficulty();
         var newDiffs:Array = [];
         for(var i:int = 0; i < difficulties.length; i++)
         {
            newDiffs.push({
               "name":difficulties[i].name,
               "id":difficulties[i].id + 1
            });
         }
         return newDiffs;
      }
      
      private function listDifficulty(cMap:Object = null, insertAny:Boolean = false, coopFilter:Boolean = false) : Array
      {
         var difficulties:Array = MatchService.getInstance().listDifficulty(cMap);
         Logger.print("MatchController:::listDifficulty difficulties.length: " + difficulties.length);
         if(coopFilter)
         {
            difficulties.splice(0,1);
         }
         if(insertAny)
         {
            difficulties.unshift({
               "name":DictRoom.ANY,
               "id":-1
            });
         }
         return difficulties;
      }
      
      private function listPlayListMP() : Array
      {
         var mpPlayList:Array = this.listPlayList(0,PlayListType.RANKED,true);
         var ctPlayList:Array = this.listPlayList(0,PlayListType.COMBAT,true);
         return ctPlayList.concat(mpPlayList);
      }
      
      private function listPlayListPve() : Array
      {
         var list:Array = [];
         for(var i:int = 0; i < PlayListType.PVE_TYPES.length; i++)
         {
            list = list.concat(this.listPlayList(0,PlayListType.PVE_TYPES[i],true));
         }
         return list;
      }
      
      private function listPlayListBattleCity(isFlod:Boolean) : Array
      {
         var playlistObj:PlayListObj = null;
         var copiedPlayListObj:PlayListObj = null;
         var candidatePlayList:PlayListObj = null;
         var playLists:Array = this.listPlayListMP();
         var battleCityPlayList:Array = [];
         var buddyPlayList:Array = [];
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < playLists.length; i++)
         {
            playlistObj = playLists[i] as PlayListObj;
            if(Boolean(playlistObj) && playlistObj.isBattleCityMode())
            {
               copiedPlayListObj = new PlayListObj(playlistObj);
               battleCityPlayList.push(copiedPlayListObj);
               if(isFlod)
               {
                  if(playlistObj.buddyPlaylist != 0)
                  {
                     buddyPlayList.push(playlistObj.buddyPlaylist);
                  }
                  if(copiedPlayListObj.overridename != "")
                  {
                     copiedPlayListObj.name = copiedPlayListObj.overridename;
                  }
                  if(copiedPlayListObj.overridedescription != "")
                  {
                     copiedPlayListObj.description = copiedPlayListObj.overridedescription;
                  }
               }
            }
         }
         if(isFlod)
         {
            for(i = battleCityPlayList.length - 1; i >= 0; i--)
            {
               candidatePlayList = battleCityPlayList[i];
               for(j = 0; j < buddyPlayList.length; j++)
               {
                  if(candidatePlayList.index == buddyPlayList[j])
                  {
                     battleCityPlayList.splice(i,1);
                     break;
                  }
               }
            }
         }
         return this.sortBattleCityPlaylist(battleCityPlayList);
      }
      
      private function sortBattleCityPlaylist(playlist:Array) : Array
      {
         var onePL:PlayListObj = null;
         var leagueGlobal:BattleCityLeagueGlobalObj = getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         var leaguePlaylistIsLocked:Boolean = !leagueGlobal.enabled;
         var leaguePlaylist:Array = new Array();
         var otherPlaylist:Array = new Array();
         var finalSort:Array = new Array();
         for(var i:int = 0; i < playlist.length; i++)
         {
            onePL = playlist[i] as PlayListObj;
            if(onePL.isBattleCityLeague())
            {
               leaguePlaylist.push(onePL);
            }
            else
            {
               otherPlaylist.push(onePL);
            }
         }
         if(leaguePlaylistIsLocked)
         {
            finalSort = finalSort.concat(otherPlaylist);
            finalSort = finalSort.concat(leaguePlaylist);
         }
         else
         {
            finalSort = finalSort.concat(leaguePlaylist);
            finalSort = finalSort.concat(otherPlaylist);
         }
         return finalSort;
      }
      
      private function listPlayListByType(type:uint) : Array
      {
         return this.listPlayList(0,type,true);
      }
      
      private function listPlayList(leagueId:int, playlistType:uint = 1, ignoreLeague:Boolean = false) : Array
      {
         return MatchService.getInstance().listPlayList(leagueId,playlistType,ignoreLeague);
      }
      
      private function listPlayListHomepageAd() : Array
      {
         return MatchService.getInstance().listPlayList(0,PlayListType.NONE,true,true);
      }
      
      private function listQuickMPPlayList() : Array
      {
         return this.listPlayList(this._currentSelectedLeague);
      }
      
      private function listMaxPlayer(insertAny:Boolean = false, maxMapPlayer:int = 18, minPlayers:int = 0) : Array
      {
         var maxPlayers:Array = [{
            "name":6,
            "id":6
         },{
            "name":8,
            "id":8
         },{
            "name":10,
            "id":10
         },{
            "name":12,
            "id":12
         },{
            "name":14,
            "id":14
         },{
            "name":16,
            "id":16
         },{
            "name":18,
            "id":18
         }];
         if(maxMapPlayer == 4)
         {
            maxPlayers.unshift({
               "name":4,
               "id":4
            });
         }
         for(var i:int = maxPlayers.length - 1; i >= 0; i--)
         {
            if(maxPlayers[i].id > maxMapPlayer || maxPlayers[i].id < minPlayers)
            {
               maxPlayers.splice(i,1);
            }
         }
         if(insertAny)
         {
            maxPlayers.unshift({
               "name":DictRoom.ANY,
               "id":0
            });
         }
         return maxPlayers;
      }
      
      private function listCTMaxPlayer() : Array
      {
         return [{
            "name":4,
            "id":4
         },{
            "name":6,
            "id":6
         },{
            "name":8,
            "id":8
         }];
      }
      
      private function listLoadout(insertAny:Boolean = false) : Array
      {
         var loadouts:Array = [{
            "name":"No Custom",
            "id":1
         },{
            "name":"Class Restricted",
            "id":2
         }];
         if(insertAny)
         {
            loadouts.unshift({
               "name":DictRoom.ANY,
               "id":0
            });
         }
         return loadouts;
      }
      
      private function listRoomListFilterStatus() : Array
      {
         return MatchService.getInstance().listRoomListFilterStatus();
      }
      
      private function clearTimedPlayList() : void
      {
         this._timedplayListDp.splice(0);
      }
      
      private function collectTimedPlayList(plObj:PlayListObj) : void
      {
         if(plObj.HasValidTime)
         {
            this._timedplayListDp.push(plObj);
         }
      }
      
      private function getGameRulesByModeID(modeID:String) : Array
      {
         return MatchService.getInstance().getGameRulesByModeID(modeID);
      }
      
      private function getSpectatingByModeID(modeID:String) : Object
      {
         return MatchService.getInstance().getSpectatingByModeID(modeID);
      }
      
      private function getGamePlayOptions() : Object
      {
         return MatchService.getInstance().getGamePlayOptions();
      }
      
      private function getMapObj(mapID:String) : MapObj
      {
         return MatchService.getInstance().getMapObj(mapID);
      }
      
      private function getIsUnavailableMiniClientMode(modeID:String) : Boolean
      {
         return MINICLIENT_UNAVAILABLE_GAME_MODE.indexOf(modeID) != -1;
      }
      
      private function getMatchModeObj(modeID:String) : ModeObj
      {
         return MatchService.getInstance().getModeObj(modeID);
      }
      
      private function getPlayListObj(playListID:int) : PlayListObj
      {
         return MatchService.getInstance().getPlayListObj(playListID);
      }
      
      private function getCTBonus(leagueID:uint) : int
      {
         return MatchService.getInstance().getCTBonus(leagueID);
      }
      
      private function getMPBonus(leagueID:uint) : int
      {
         return MatchService.getInstance().getMPBonus(leagueID);
      }
      
      private function getLeagueName(leagueID:uint) : String
      {
         var leagues:Array = this.listLeague();
         for(var i:int = 0; i < leagues.length; i++)
         {
            if(leagueID == leagues[i].id)
            {
               return leagues[i].name;
            }
         }
         return "";
      }
      
      private function getDelayToShowButton() : Number
      {
         return MatchService.getInstance().delayToShowButton;
      }
      
      private function getRoomDLCLevel() : uint
      {
         return CFunctionContainer.GetRoomDLCLevel() as uint;
      }
      
      private function getCurruntDLCLevel() : uint
      {
         return CFunctionContainer.GetCurrentDLCLevel() as uint;
      }
      
      private function GetMaxRoomNameLength() : int
      {
         return CFunctionContainer.GetMaxRoomNameLength() as int;
      }
      
      private function canLeaveRoomNow() : Boolean
      {
         if(null != this._rankedMatchGoRoomTimer && this._rankedMatchGoRoomTimer.running)
         {
            return this._rankedMatchGoRoomTime > 10;
         }
         if(null != this._rankedMatchGoGameTimer && this._rankedMatchGoGameTimer.running)
         {
            return this._rankedMatchGoGameTime > 10;
         }
         return true;
      }
      
      private function onQuickMatchDebug(cRes:Object) : void
      {
         this.changeRankedMatchStatus(RankedMatchStatus.IN_PROGRESS);
      }
      
      public function onRoomJoined(cRes:Object) : void
      {
         this.goRoom(cRes.result,cRes.resultMsg);
      }
      
      public function onRoomCreated(cRes:Object) : void
      {
         if(cRes.result != ResultObj.RESULT_SUCCESS)
         {
            showMsg(cRes.resultMsg);
            return;
         }
         this.goRoom(cRes.result,cRes.resultMsg,true,true);
      }
      
      private function bind_rankedMatchIntermission(cRes:Object) : void
      {
         if(this._currentRankedMatchStatus == RankedMatchStatus.IN_PROGRESS_IN_ROOM)
         {
            broadcast(BCEvent.RANKED_MATCH_INTERMISSION);
         }
      }
      
      private function bind_rankedMatchInProgressInRoom(cRes:Object) : void
      {
         if(this.isRankedMatch())
         {
            if(!this._currentMatchType.isPvp())
            {
               this.setCurrentMatchType(QuickMatchType.makePvp(),false,false);
            }
            Logger.print("MatchController:::bind_rankedMatchInProgressInRoom - Entering room... " + cRes);
            this.goRoom(true);
            this.changeRankedMatchStatus(RankedMatchStatus.IN_PROGRESS_IN_ROOM);
         }
      }
      
      private function bind_startMatchCountingDown(cRes:Object) : void
      {
         if(this.isRankedMatch())
         {
            this.startRankedMatchGoGameTimer(ScaleformUtil.isScaleform ? int(cRes.data) : 5);
         }
         else if(cRes.data >= 0)
         {
            this.startUnrankedMatchGoGameTimer(ScaleformUtil.isScaleform ? int(Math.ceil(cRes.data)) : 5);
         }
         else
         {
            this.stopUnrankedMatchGoGameTimer();
         }
      }
      
      private function showStartGameFailureMsg(message:String) : void
      {
         this.showMsg(message,MsgBtnCount.ONE,SystemMsgPriority.WARNING);
      }
      
      private function bind_startMatchComplete(cRes:Object) : void
      {
         Logger.print("MatchController:::bind_startMatchComplete cRes.result: " + cRes.result);
         if(this.mStartMatchMsg != null)
         {
            hideSpecificMsg(this.mStartMatchMsg);
            this.mStartMatchMsg = null;
         }
         if(Boolean(CFunctionContainer.AS_IsHiddenRoomMatch()))
         {
            closePopupPage(PageID.HIDDEN_ROOM_MATCH_START_MSG);
         }
         DAXDispatcher.OnMatchStart();
         ScaleformUtil.blockAltEnter(false);
         if(cRes.result == ResultObj.RESULT_FAIL)
         {
            this.showStartGameFailureMsg(cRes.resultMsg);
            if(Boolean(this._currentQuickMatchFilter) && this._currentQuickMatchFilter.mode == QuickMatchFilterObj.MODE_HERO_OPS)
            {
               this.leaveRoom(true);
            }
            else
            {
               if(this._currentMatchType.isPvp())
               {
                  if(this.isInRankedMatch())
                  {
                     this.onRankedMatchCanceled();
                  }
               }
               this._isMatchBeingLocked = false;
               this.stopUnrankedMatchGoGameTimer();
            }
         }
      }
      
      private function bind_jumpGameComplete(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_FAIL)
         {
            this.showStartGameFailureMsg(cRes.resultMsg);
         }
      }
      
      private function bind_roomListDP(cRes:ResultObj) : void
      {
         var room:Object = null;
         var isFull:Boolean = false;
         var isInLobby:Boolean = false;
         var rooms:Array = cRes.data.rooms;
         this._roomListDP = [];
         var wrapper:Object = this.getHistoryRoomObject();
         wrapper.finished = !MatchService.getInstance().stillHasOtherRooms;
         var targetArr:Array = wrapper.rooms;
         for(var i:int = 0; i < rooms.length; i++)
         {
            room = rooms[i];
            isFull = room.currentPlayers >= room.currentMaxPlayers;
            isInLobby = room.status == 0;
            room.status = isInLobby ? (isFull ? RoomStatus.BUSY_LOBBY : RoomStatus.FREE_LOBBY) : (isFull ? RoomStatus.BUSY_GAMING : RoomStatus.FREE_GAMING);
            room.enableShoutcast = !room.isPlayList;
            targetArr.push(rooms[i]);
         }
         if(this._inRoomChannel)
         {
            this._roomListDP = rooms;
            this.dispatchRooms(!MatchService.getInstance().stillHasOtherRooms);
         }
      }
      
      private function getHistoryRoomObject() : Object
      {
         var targetObj:Object = null;
         var roomArr:Array = null;
         if(this._roomHistory == null)
         {
            targetObj = new Object();
            targetObj.finished = false;
            roomArr = new Array();
            targetObj.rooms = roomArr;
            this._roomHistory = targetObj;
         }
         else
         {
            targetObj = this._roomHistory;
         }
         return targetObj;
      }
      
      private function bind_cancelListRoom(cRes:ResultObj) : void
      {
         this._isListingRoom = false;
      }
      
      private function bind_quickMatchReady(cRes:Object) : void
      {
         ScaleformUtil.blockAltEnter(false);
         if(cRes != null)
         {
            if(cRes.params != null)
            {
               this._currentQuickMatchFilter = cRes.params as QuickMatchFilterObj;
            }
         }
         if(Boolean(this._currentQuickMatchFilter))
         {
            if(this._currentQuickMatchFilter.skipLobby || this._currentQuickMatchFilter.mode == QuickMatchFilterObj.MODE_HERO_OPS)
            {
               Logger.print("MatchController:::bind_quickMatchReady _currentQuickMatchFilter.map: " + this._currentQuickMatchFilter.map);
               if(Boolean(CFunctionContainer.IsRoomHost()))
               {
                  Logger.print("IS ROOM HOST?: " + this._currentQuickMatchFilter.map);
                  request(DataID.START_MATCH,{
                     "useDS":true,
                     "index":-1,
                     "feedback":false
                  });
                  return;
               }
            }
         }
         if(this._currentMatchType.isPvp() && this.isInRankedMatch())
         {
            Logger.print("isInRankedMatch?: " + this._currentQuickMatchFilter.map);
            if(this.isRankedMatchInProgress())
            {
               Logger.print("isRankedMatchInProgress?: " + this._currentQuickMatchFilter.map);
               this.startRankedMatchGoRoomTimer(ScaleformUtil.isScaleform ? int(this.goRoomCountingDown) : 10);
               this.changeRankedMatchStatus(RankedMatchStatus.READY);
               SoundUtil.getInstance().playSound(SE_ID.MATCH_SUCCESS);
            }
            else if(this._currentRankedMatchStatus == RankedMatchStatus.BACK_FROM_GAME)
            {
               Logger.print("BACK FROM GAME?: " + this._currentQuickMatchFilter.map);
               this.startRankedMatchGoGameTimer(ScaleformUtil.isScaleform ? int(this.goRoomCountingDown) : 15,false);
               this.changeRankedMatchStatus(RankedMatchStatus.READY_IN_ROOM);
            }
            this.enableLeaveRoom(false);
         }
         else
         {
            Logger.print("MatchController:::bind_quickMatchReady - DEFAULTING HERE....\n\n\n");
            this.goRoom(cRes.result,cRes.resultMsg);
         }
      }
      
      private function bind_groupCounts(cRes:Object) : void
      {
         if(cRes.data == null)
         {
            return;
         }
         this._groupCounts = cRes.data;
         MatchService.getInstance().setPlayListPlayerNum(this._groupCounts.playlist);
         setBindData(DataID.GROUP_COUNTS,this._groupCounts);
      }
      
      private function restartStartMatchCountDown() : void
      {
         hideMsg();
         if(Boolean(getDP(DataID.IS_ROOM_HOST)))
         {
            this.startMatchCountDown();
         }
      }
      
      private function startRankedMatchLobbyUpdateTimer() : void
      {
         if(this._rankedMatchLobbyUpdateTimer == null)
         {
            this._rankedMatchLobbyUpdateTimer = new Timer(1000,0);
            this._rankedMatchLobbyUpdateTimer.addEventListener(TimerEvent.TIMER,this.onRankedMatchLobbyUpdateTimerHandle);
         }
         if(!this._rankedMatchLobbyUpdateTimer.running)
         {
            this._rankedMatchLobbyUpdateTimer.reset();
            this._rankedMatchLobbyUpdateTimer.start();
         }
      }
      
      private function stopRankedMatchLobbyUpdateTimer(cancel:Boolean = false) : void
      {
         var elapsedTime:int = 0;
         if(this._rankedMatchLobbyUpdateTimer != null && this._rankedMatchLobbyUpdateTimer.running)
         {
            Logger.print("MatchController:::stopRankedMatchPassedTimeTimer _currentRankedMatchStatus: " + this._currentRankedMatchStatus);
            Logger.print("MatchController:::stopRankedMatchPassedTimeTimer _previousRankedMatchStatus: " + this._previousRankedMatchStatus);
            elapsedTime = this._rankedMatchLobbyUpdateTimer.currentCount;
            if(cancel && this._currentRankedMatchStatus == RankedMatchStatus.BACK_FROM_GAME || !cancel && this._previousRankedMatchStatus == RankedMatchStatus.BACK_FROM_GAME)
            {
               elapsedTime -= CFunctionCommonContainer.Dvar_GetFloat("dw_enterGameNextMapCountingDown");
            }
            Logger.print("MatchController:::stopRankedMatchPassedTimeTimer elapsedTime: " + elapsedTime);
            this.rankedMatchLobbyUpdate(this._rankedMatchLobbyUpdateTimer.currentCount,true);
            this._rankedMatchLobbyUpdateTimer.stop();
         }
      }
      
      private function startRankedMatchGoRoomTimer(repeatCount:int) : void
      {
         if(this._rankedMatchGoGameTimer != null && this._rankedMatchGoGameTimer.running)
         {
            return;
         }
         this._rankedMatchGoRoomTime = repeatCount;
         if(this._rankedMatchGoRoomTimer == null)
         {
            this._rankedMatchGoRoomTimer = new Timer(1000,this._rankedMatchGoRoomTime + 1);
            this._rankedMatchGoRoomTimer.addEventListener(TimerEvent.TIMER,this.onRankedMatchGoRoomTimerHandle);
            this._rankedMatchGoRoomTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRankedMatchGoRoomTimerCompleteHandle);
         }
         this._rankedMatchGoRoomTimer.reset();
         this._rankedMatchGoRoomTimer.start();
      }
      
      private function stopRankedMatchGoRoomTimer() : void
      {
         if(this._rankedMatchGoRoomTimer != null && this._rankedMatchGoRoomTimer.running)
         {
            this._rankedMatchGoRoomTime = 0;
            this._rankedMatchGoRoomTimer.stop();
         }
      }
      
      private function startRankedMatchGoGameTimer(repeatCount:int, lockNow:Boolean = true) : void
      {
         if(Boolean(this._rankedMatchGoGameTimer) && this._rankedMatchGoGameTimer.running)
         {
            return;
         }
         this._rankedMatchGoGameTime = repeatCount;
         if(this._rankedMatchGoGameTime > 0)
         {
            if(this._rankedMatchGoGameTimer == null)
            {
               this._rankedMatchGoGameTimer = new Timer(1000,this._rankedMatchGoGameTime + 1);
               this._rankedMatchGoGameTimer.addEventListener(TimerEvent.TIMER,this.onRankedMatchGoGameTimerHandle);
               this._rankedMatchGoGameTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRankedMatchGoGameTimerCompleteHandle);
            }
            this._rankedMatchGoGameTimer.reset();
            this._rankedMatchGoGameTimer.start();
         }
         else
         {
            this.onRankedMatchGoGameTimerCompleteHandle();
         }
         if(lockNow)
         {
            this.lockMatch();
         }
      }
      
      private function stopRankedMatchGoGameTimer() : void
      {
         if(this._rankedMatchGoGameTimer != null && this._rankedMatchGoGameTimer.running)
         {
            this._rankedMatchGoGameTime = 0;
            this._rankedMatchGoGameTimer.stop();
            broadcast(BCEvent.RANKED_MATCH_GO_GAME_TIMER,0);
         }
      }
      
      private function startUnrankedMatchGoGameTimer(repeatCount:int) : void
      {
         this._unrankedMatchGoGameTime = repeatCount;
         if(this._unrankedMatchGoGameTime > 0)
         {
            if(this._unrankedMatchGoGameTimer == null)
            {
               this._unrankedMatchGoGameTimer = new Timer(1000,this._unrankedMatchGoGameTime + 1);
               this._unrankedMatchGoGameTimer.addEventListener(TimerEvent.TIMER,this.onUnrankedMatchGoGameTimerHandle);
               this._unrankedMatchGoGameTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onUnrankedMatchGoGameTimerCompleteHandle);
            }
            this._unrankedMatchGoGameTimer.reset();
            this._unrankedMatchGoGameTimer.start();
         }
         else
         {
            this.onUnrankedMatchGoGameTimerCompleteHandle();
         }
      }
      
      private function stopUnrankedMatchGoGameTimer() : void
      {
         if(this._unrankedMatchGoGameTimer != null && this._unrankedMatchGoGameTimer.running)
         {
            this._unrankedMatchGoGameTime = 0;
            this._unrankedMatchGoGameTimer.stop();
            this._unrankedMatchGoGameTimer = null;
            broadcast(BCEvent.UNRANKED_MATCH_GO_GAME_TIMER,0);
         }
      }
      
      private function lockMatch() : void
      {
         if(!this.getDvarBool("dw_autoStartGame"))
         {
            return;
         }
         if(this._isMatchBeingLocked)
         {
            return;
         }
         this._isMatchBeingLocked = true;
         if(Boolean(CFunctionContainer.AS_IsHiddenRoomMatch()))
         {
            gotoPage(CodoPageViewDB.PAGE_HIDDEN_ROOM_MATCH_START_MSG);
         }
         else
         {
            this.mStartMatchMsg = showMsg(DictRoom.NOTE_START_GAME,MsgBtnCount.ONE,SystemMsgPriority.NORMAL,this.leaveRoom,DictRoom.LEAVE_ROOM,null,"",null,"",this.getDelayToShowButton());
         }
      }
      
      private function leaveRoom(auto:Boolean = false, cancelRanked:Boolean = false, withParty:Boolean = false, isUserInput:Boolean = false) : void
      {
         request(DataID.LEAVE_ROOM,{
            "auto":auto,
            "cancelRanked":cancelRanked,
            "party":withParty,
            "isUserInput":isUserInput
         });
      }
      
      private function leaveRoomWithParty(isUserInput:Boolean) : void
      {
         this.leaveRoom(false,false,true,isUserInput);
      }
      
      private function leaveRoomAlone(isUserInput:Boolean) : void
      {
         this.leaveRoom(false,false,false,isUserInput);
      }
      
      private function leaveRoomAsPartyHost(isUserInput:Boolean) : void
      {
         var onLeaveRoomWithPartyFromInput:Function = function():void
         {
            if(canLeaveRoomNow())
            {
               leaveRoomWithParty(isUserInput);
            }
            else
            {
               showMsg(DictRoom.GAME_STARTING_CANNOT_LEAVE,MsgBtnCount.ONE);
            }
         };
         var onLeaveRoomAloneFromInput:Function = function():void
         {
            if(canLeaveRoomNow())
            {
               leaveRoomAlone(isUserInput);
            }
            else
            {
               showMsg(DictRoom.GAME_STARTING_CANNOT_LEAVE,MsgBtnCount.ONE);
            }
         };
         showMsg(DictRoom.NOTE_LEAVE_ROOM_LONE_OR_WITH_PARTY,MsgBtnCount.THREE,0,onLeaveRoomWithPartyFromInput,DictRoom.LEAVE_ROOM_WITH_PARTY,onLeaveRoomAloneFromInput,DictRoom.LEAVE_ROOM_ALONE,null,DictSystem.CANCEL);
      }
      
      private function leaveRoomAsNotPartyHost(isUserInput:Boolean) : void
      {
         var onLeaveRoomAloneFromInput:Function = function():void
         {
            leaveRoomAlone(isUserInput);
         };
         showMsg(DictRoom.LEAVE_ROOM_AND_PARTY_CONFIRM,MsgBtnCount.TWO,0,onLeaveRoomAloneFromInput,DictRoom.LEAVE_ROOM);
      }
      
      private function startMatchCountDown(cEvt:TimerEvent = null) : void
      {
         if(Boolean(getDP(DataID.IS_ROOM_HOST)) && this.goGameCountingDown >= 0)
         {
            CFunctionContainer.StartMatchCountDown();
            if(!ScaleformUtil.isScaleform)
            {
               this.bind_startMatchCountingDown(new ResultObj());
            }
         }
         this.enableLeaveRoom(false);
      }
      
      private function get goRoomCountingDown() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("dw_enterRoomCountingDown");
      }
      
      private function get goGameCountingDown() : Number
      {
         return CFunctionCommonContainer.Dvar_GetFloat("dw_startGameCountingDown");
      }
      
      private function rankedMatchLobbyUpdate(elapsedTime:int, lastTick:Boolean) : void
      {
         var intermissionElapsedTime:int = CFunctionCommonContainer.Dvar_GetInt("dw_matchmaking_intermission");
         var intermissionTotalTime:int = Math.round(CFunctionCommonContainer.Dvar_GetFloat("dw_enterGameNextMapCountingDown"));
         var updateObj:RankedMatchLobbyUpdateObj = new RankedMatchLobbyUpdateObj(elapsedTime,intermissionElapsedTime,intermissionTotalTime,lastTick);
         broadcast(BCEvent.RANKED_MATCH_LOBBY_UPDATE,updateObj);
      }
      
      private function onRankedMatchLobbyUpdateTimerHandle(cEvt:TimerEvent) : void
      {
         this.rankedMatchLobbyUpdate(cEvt.target.currentCount,false);
      }
      
      private function onRankedMatchGoRoomTimerHandle(cEvt:TimerEvent) : void
      {
         broadcast(BCEvent.RANKED_MATCH_GO_ROOM_TIMER,this._rankedMatchGoRoomTime--);
         if(this._rankedMatchGoRoomTime == this._mpStartLockScreenCount - 1)
         {
            this.lockMatch();
         }
      }
      
      private function onRankedMatchGoRoomTimerCompleteHandle(cEvt:TimerEvent) : void
      {
         if(!this._isRankedMatchInRoomDone)
         {
            this._isRankedMatchInRoomDone = true;
            this.goRoom(true);
         }
         this.changeRankedMatchStatus(RankedMatchStatus.READY_IN_ROOM);
         this.startMatchCountDown();
         if(!getDP(DataID.IS_ROOM_HOST) && this._currentRankedMatchStatus == RankedMatchStatus.READY_IN_ROOM)
         {
            this.startRankedMatchGoGameTimer(ScaleformUtil.isScaleform ? int(this.goGameCountingDown) : 5);
         }
      }
      
      private function onRankedMatchGoGameTimerHandle(cEvt:TimerEvent) : void
      {
         broadcast(BCEvent.RANKED_MATCH_GO_GAME_TIMER,this._rankedMatchGoGameTime--);
         if(this._rankedMatchGoGameTime == this._mpStartLockScreenCount - 1)
         {
            this.lockMatch();
         }
      }
      
      private function onRankedMatchGoGameTimerCompleteHandle(cEvt:TimerEvent = null) : void
      {
         var canStart:Boolean = false;
         if(Boolean(getDP(DataID.IS_ROOM_HOST)))
         {
            canStart = getDP(DataID.IS_SHIP_BUILD);
            if(!canStart)
            {
               canStart = this.goGameCountingDown >= 0;
            }
            this.changeRankedMatchStatus(RankedMatchStatus.STARTING_GAME);
         }
      }
      
      private function onUnrankedMatchGoGameTimerHandle(cEvt:TimerEvent) : void
      {
         broadcast(BCEvent.UNRANKED_MATCH_GO_GAME_TIMER,this._unrankedMatchGoGameTime--);
         if(this._unrankedMatchGoGameTime == this._mpStartLockScreenCount - 1)
         {
            this.lockMatch();
            broadcast(BCEvent.SET_FINAL_VOTE);
         }
      }
      
      private function onUnrankedMatchGoGameTimerCompleteHandle(cEvt:TimerEvent = null) : void
      {
      }
      
      private function onLeaveRoomHandle(cEvt:ParaEvent) : void
      {
         var isUserInput:Boolean = false;
         var onCancelRankedMatchAlone:Function = null;
         var onCancelRankedMatchWithParty:Function = null;
         var isRanked:Boolean = this.isRankedMatchInProgress();
         var isInParty:Boolean = getDP(DataID.IS_IN_PARTY);
         var isPartyHost:Boolean = getDP(DataID.IS_PARTY_HOST);
         isUserInput = cEvt.myPara != null && Boolean(cEvt.myPara.isUserInput);
         if(isRanked)
         {
            if(isInParty)
            {
               onCancelRankedMatchAlone = function():void
               {
                  if(canLeaveRoomNow())
                  {
                     cancelRankedMatchAlone(isUserInput);
                  }
                  else
                  {
                     showMsg(DictRoom.GAME_STARTING_CANNOT_LEAVE,MsgBtnCount.ONE);
                  }
               };
               onCancelRankedMatchWithParty = function():void
               {
                  if(canLeaveRoomNow())
                  {
                     cancelRankedMatchWithParty(isUserInput);
                  }
                  else
                  {
                     showMsg(DictRoom.GAME_STARTING_CANNOT_LEAVE,MsgBtnCount.ONE);
                  }
               };
               if(!isPartyHost)
               {
                  showMsg(DictRoom.LEAVE_ROOM_AND_PARTY_CONFIRM,MsgBtnCount.TWO,0,onCancelRankedMatchAlone,DictRoom.LEAVE_ROOM,null,DictSystem.STAY);
                  return;
               }
               showMsg(DictRoom.NOTE_LEAVE_ROOM_LONE_OR_WITH_PARTY,MsgBtnCount.THREE,0,onCancelRankedMatchWithParty,DictRoom.LEAVE_ROOM_WITH_PARTY,onCancelRankedMatchAlone,DictRoom.LEAVE_ROOM_ALONE,null,DictSystem.CANCEL);
               return;
            }
            this.cancelRankedMatch();
         }
         else if(isInParty)
         {
            if(isPartyHost)
            {
               this.leaveRoomAsPartyHost(isUserInput);
            }
            else
            {
               this.leaveRoomAsNotPartyHost(isUserInput);
            }
            return;
         }
         this.leaveRoom(false,isRanked,isPartyHost && isRanked,isUserInput);
      }
      
      private function cancelRankedMatchAlone(isUserInput:Boolean) : void
      {
         this.cancelRankedMatch();
         this.leaveRoom(false,true,false,isUserInput);
      }
      
      private function cancelRankedMatchWithParty(isUserInput:Boolean) : void
      {
         this.cancelRankedMatch();
         this.leaveRoom(false,true,true,isUserInput);
      }
      
      private function onRankedMatchCanceled() : void
      {
         this._isRankedMatchInRoomDone = false;
         this._isMatchBeingLocked = false;
         this.enableLeaveRoom(true);
         this.stopRankedMatchGoRoomTimer();
         this.stopRankedMatchGoGameTimer();
         this.stopRankedMatchLobbyUpdateTimer(true);
         this.changeRankedMatchStatus(RankedMatchStatus.IDLE);
      }
      
      private function onRoomLeftHandle(cEvt:ParaEvent) : void
      {
         MatchService.getInstance().cancelRoomTasks();
         this._currentQuickMatchFilter = null;
         this._isMatchBeingLocked = false;
         var play:Boolean = true;
         if(this.isInRankedMatch())
         {
            if(this._currentRankedMatchStatus == RankedMatchStatus.IN_PROGRESS_IN_ROOM)
            {
               play = false;
            }
            else if(this.isRankedMatchReady())
            {
               Logger.print("MatchController:::onRoomLeftHandle GO HOME\n\n");
               broadcast(BCEvent.EVT_GOTO_PLAY_MODE_SELECTION);
            }
            this.onRankedMatchCanceled();
         }
         else
         {
            this.stopUnrankedMatchGoGameTimer();
         }
         if(play)
         {
            this.onPlayMainMenuSound(null);
         }
      }
      
      private function onOpenGamemodeTutorialClick(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_GAMEMODES_TUTORIAL,cEvt.myPara);
      }
      
      private function onOpenGameModeImage(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_GAMEMODES_IMAGES,cEvt.myPara);
      }
      
      private function onPlayMainMenuSound(cEvt:ParaEvent = null) : void
      {
         SoundUtil.getInstance().playSound(SE_ID.MENU_BGM_TRANSITION);
      }
      
      private function onCreateRoomHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            if(this.checkInPartyAsNotHost())
            {
               return;
            }
            if(this.checkInPartySize(cEvt.myPara.maxPlayer))
            {
               return;
            }
            if(this._currentMatchType.isPvp() && this.checkInParty())
            {
               return;
            }
            if(this.checkInPartyMemberState())
            {
               return;
            }
         }
         this._roomToCreate = cEvt.myPara;
         broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
            "type":SanitizedType.ROOM_NAME,
            "content":StringUtil.trim(this._roomToCreate.name)
         });
      }
      
      private function onQuickMatchCoopHandle(cEvt:ParaEvent) : void
      {
         var filter:QuickMatchFilterObj = new QuickMatchFilterObj();
         filter.type = RoomMatchType.COOP;
         filter.map = cEvt.myPara.map.id;
         filter.mode = QuickMatchFilterObj.MODE_HERO_OPS;
         filter.league = this.listDifficulty(cEvt.myPara.map)[cEvt.myPara.leagueIndex];
         filter.minPlayer = cEvt.myPara.map.minPlayer;
         filter.maxPlayer = cEvt.myPara.map.maxPlayer;
         this.startQuickMatch(filter);
      }
      
      private function onQuickMatchTrainingHandle(cEvt:ParaEvent) : void
      {
         if(this.checkInParty())
         {
            return;
         }
         var filter:QuickMatchFilterObj = new QuickMatchFilterObj();
         filter.type = RoomMatchType.MP;
         filter.map = cEvt.myPara.map.id;
         filter.mode = cEvt.myPara.mode.id;
         filter.league = cEvt.myPara.league.id;
         filter.minPlayer = cEvt.myPara.map.minPlayer;
         filter.maxPlayer = cEvt.myPara.map.maxPlayer;
         this.startQuickMatch(filter);
      }
      
      private function onQuickMatchMpHandle(cEvt:ParaEvent) : void
      {
         var filter:QuickMatchFilterObj = new QuickMatchFilterObj();
         filter.type = RoomMatchType.RANKED;
         filter.league = cEvt.myPara.data.leagueID;
         filter.leagueName = this.getLeagueName(filter.league);
         filter.mode = QuickMatchFilterObj.MODE_PLAYLIST;
         filter.playListID = cEvt.myPara.data.id;
         Logger.print("MatchController::onQuickMatchMpHandle:" + filter.playListID + " " + filter.playListName);
         filter.playListName = cEvt.myPara.data.name;
         filter.minPlayer = cEvt.myPara.data.minPartySize;
         filter.maxPlayer = cEvt.myPara.data.maxPartySize;
         this.startQuickMatch(filter);
      }
      
      private function onQuickMatchHandle(cEvt:ParaEvent) : void
      {
         this.startQuickMatch(cEvt.myPara.filter);
      }
      
      private function onMatchQuickMpLeagueChangedHandle(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.MATCH_QUICK_MP_CHANGE_PLAYLIST,this.listPlayList(cEvt.myPara.id));
      }
      
      private function initFetchGroupCountTimer() : void
      {
         var interval:int = 0;
         if(this._fetchGroupCountTimer == null)
         {
            if(Boolean(MatchService.getInstance()))
            {
               this.onFetchGroupCountTimerHandle(null);
               interval = this.getDvarInt("dw_refreshGroupCountTime");
               interval = interval > 0 ? int(interval * 1000) : int(120 * 1000);
               this._fetchGroupCountTimer = new Timer(interval);
               this._fetchGroupCountTimer.addEventListener(TimerEvent.TIMER,this.onFetchGroupCountTimerHandle);
               this._fetchGroupCountTimer.start();
            }
         }
      }
      
      private function onGoToFirstPageHandle(cEvt:ParaEvent) : void
      {
         var _mapID:String = null;
         var roomInfo:Object = null;
         var playListObj:PlayListObj = null;
         var isValid:Boolean = false;
         var isHiddenRoomMatch:Boolean = false;
         var partyMemberHasLeftRoom:Boolean = false;
         var mapUFname:String = null;
         var unlockedMaps:Array = null;
         var mapObj:MapObj = null;
         var status:String = null;
         var canLeaveRoom:Boolean = false;
         var state:int = 0;
         SoundUtil.getInstance().playMusic(MusicID.FSG_BGM_HOME,"");
         var mapID:String = CFunctionCommonContainer.Dvar_GetString("ui_played_mapname");
         Logger.print("MatchController:::onGoToFirstPageHandle mapID: " + mapID);
         var showMatchResults:Boolean = getDP(DataID.EOG_SHOW_SCOREMATCH_RESULT);
         var savedMatchType:QuickMatchType = QuickMatchType.loadFromPersistent();
         if(!ScaleformUtil.isCurrentModeUnlocked(savedMatchType))
         {
            savedMatchType = this._currentMatchType;
         }
         this.setCurrentMatchType(savedMatchType,true,false);
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            CFunctionContainer.RefreshParty();
         }
         this.initFetchGroupCountTimer();
         if(this.isInRoom())
         {
            _mapID = mapID;
            roomInfo = CFunctionContainer.GetRoomInfo();
            if(_mapID == "")
            {
               if(roomInfo != null && roomInfo.mapID != null)
               {
                  _mapID = roomInfo.mapID;
               }
            }
            if(roomInfo.playListID != -1)
            {
               playListObj = this.getPlayListObj(roomInfo.playListID);
               isValid = CFunctionContainer.AS_PlayListValid(playListObj.index) as Boolean;
               isHiddenRoomMatch = CFunctionContainer.AS_IsHiddenRoomMatch() as Boolean;
               partyMemberHasLeftRoom = Boolean(getDP(DataID.IS_IN_PARTY)) && !getDP(DataID.IS_PARTY_MEMBER_ALL_IN_ROOM);
               if(!isValid || isHiddenRoomMatch || partyMemberHasLeftRoom)
               {
                  this.cancelRankedMatch();
                  if(!isValid)
                  {
                     showMsg(DictRoom.LIST_TIMED_CLOSE,MsgBtnCount.ONE);
                  }
                  this.continueToLeaveRoomWithParty();
               }
               else if(Boolean(CFunctionContainer.AS_CanJoinStreakBreakLobby(playListObj.index)))
               {
                  PlayListObj.setStreakBreakPlaylist(playListObj);
                  this.cancelRankedMatch();
                  this.continueToLeaveRoomWithParty();
               }
            }
            if(!this.isRankedMatch() && this._currentMatchType.isHeroOps())
            {
               mapUFname = "cf_ch_" + _mapID;
               if(Boolean(CFunctionContainer.IsMapUnlockFlagNew(mapUFname)))
               {
                  unlockedMaps = CFunctionContainer.GetNewUnlockedCoopStoryMaps(mapUFname);
                  if(Boolean(unlockedMaps) && unlockedMaps.length > 0)
                  {
                     this._newUnlockedCoopStoryMap = unlockedMaps[0];
                     Logger.print("MatchController:::onGoToFirstPageHandle _newUnlockedCoopStoryMap: " + this._newUnlockedCoopStoryMap);
                     if(MatchService.getInstance().isMapValid(this._newUnlockedCoopStoryMap))
                     {
                        mapObj = this.getMapObj(unlockedMaps[0]);
                        if(Boolean(mapObj))
                        {
                           showMsg(LocalizeUtil.param(DictRoom.NOTE_NEW_STORY_MAP_UNLOCKED,[LocalizeUtil.localize(mapObj.name)]),MsgBtnCount.ONE,0,this.resetNewUnlockedCoopStoryMap);
                        }
                     }
                     else
                     {
                        showMsg(DictRoom.NOTE_ALL_STORY_MAPS_FINISHED,MsgBtnCount.ONE,0,this.onCB3CoopStoryFinished);
                     }
                  }
               }
               this.setupLeaveRoomWithParty();
            }
            else
            {
               CFunctionContainer.RefreshInRoom();
               if(this.isRankedMatch())
               {
                  status = RankedMatchStatus.IDLE;
                  canLeaveRoom = true;
                  state = CFunctionContainer.GetRankedMatchState();
                  switch(state)
                  {
                     case 0:
                     case 1:
                        status = RankedMatchStatus.IN_PROGRESS_IN_ROOM;
                        canLeaveRoom = false;
                        break;
                     case 2:
                     case 3:
                        status = RankedMatchStatus.BACK_FROM_GAME;
                  }
                  if(status == RankedMatchStatus.IN_PROGRESS_IN_ROOM)
                  {
                     Logger.print("MatchController:::TutorialMap.RankedMatchStatus.IN_PROGRESS_IN_ROOM GO HOME \n\n)");
                     this.setupNoRoomNavigation(showMatchResults);
                  }
                  else
                  {
                     trace("\n\n\n\n***************** goroom isranked == true");
                     this.goRoom(true,"",true);
                  }
                  this.changeRankedMatchStatus(status);
                  this.enableLeaveRoom(canLeaveRoom);
               }
               else
               {
                  trace("\n\n\n\n***************** goroom isranked == false");
                  this.goRoom(true,"",true);
               }
            }
         }
         else
         {
            this.setupNoRoomNavigation(showMatchResults);
         }
         if(showMatchResults == true)
         {
            broadcast(BCEvent.EVT_CLEAR_SHOW_MATCH_RESULT_DVAR);
            broadcast(BCEvent.EVT_ENABLE_PREV_MATCH_SUMMARY,{"isCyborg":this._currentMatchType.isCyborgs()});
            gotoPage(CodoPageViewDB.PAGE_ADV_FSG_MATCH_RESULT);
         }
      }
      
      private function setupNoRoomNavigation(showMatchResults:Boolean) : void
      {
         if(showMatchResults)
         {
            listen(BCEvent.EVT_CONTINUE_FROM_MATCH_RESULTS,this.continueNoRoomNavigation);
            listen(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.continueNoRoomNavigation);
         }
         else
         {
            this.continueNoRoomNavigation();
         }
      }
      
      private function continueNoRoomNavigation() : void
      {
         unlisten(BCEvent.EVT_CONTINUE_FROM_MATCH_RESULTS,this.continueNoRoomNavigation);
         unlisten(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.continueNoRoomNavigation);
         if(!MatchService.getInstance().isInRoom)
         {
            broadcast(BCEvent.EVT_GOTO_MATCH_SELECT);
         }
      }
      
      private function setupLeaveRoomWithParty() : void
      {
         if(Boolean(getDP(DataID.EOG_SHOW_SCOREMATCH_RESULT)))
         {
            listen(BCEvent.EVT_CONTINUE_FROM_MATCH_RESULTS,this.continueToLeaveRoomWithParty);
            listen(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.continueToLeaveRoomWithParty);
         }
         else
         {
            this.continueToLeaveRoomWithParty();
         }
      }
      
      private function continueToLeaveRoomWithParty() : void
      {
         unlisten(BCEvent.EVT_CONTINUE_FROM_MATCH_RESULTS,this.continueToLeaveRoomWithParty);
         unlisten(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.continueToLeaveRoomWithParty);
         this.leaveRoomWithParty(false);
      }
      
      private function onBackToRoomHandle(cEvt:ParaEvent) : void
      {
         Logger.print("MatchController:::onBackToRoomHandle");
         if(this.isInRankedMatch())
         {
            this.goRoom(true,"",true);
            if(this._currentMatchType.isPvp())
            {
               if(Boolean(this._rankedMatchGoRoomTimer) && this._rankedMatchGoRoomTimer.running)
               {
                  this._isRankedMatchInRoomDone = true;
                  this.enableLeaveRoom(false);
                  this.changeRankedMatchStatus(RankedMatchStatus.READY_IN_ROOM);
               }
            }
         }
         else
         {
            this.goRoom(true,"",false);
         }
      }
      
      private function onOnlyRoomInfoHandle(cEvt:ParaEvent) : void
      {
         var roomObj:RoomObj = cEvt.myPara;
         if(roomObj == null)
         {
            return;
         }
         if(this.isRankedMatch() && this._currentQuickMatchFilter == null)
         {
            this._currentQuickMatchFilter = new QuickMatchFilterObj();
            this._currentQuickMatchFilter.league = roomObj.leagueID;
            this._currentQuickMatchFilter.leagueName = DictRoom.LEAGUES[roomObj.leagueID];
            this._currentQuickMatchFilter.playListID = roomObj.playListID;
            Logger.print("MatchController::onQuickMatchMpHandle:" + roomObj.playListID + " " + roomObj.playListName);
            this._currentQuickMatchFilter.playListName = roomObj.playListName;
            this.dispatchRankedMatchStatus();
         }
      }
      
      private function onProposeRoomMembershipHandle(cEvt:ParaEvent) : void
      {
         if(!this.isInRoom())
         {
            showMsg(DictRoom.NOTE_NOT_IN_ROOM,MsgBtnCount.ONE);
            return;
         }
         if(cEvt.myPara.id != null)
         {
            CFunctionContainer.ProposePartyMembership(cEvt.myPara.id);
         }
         showMsg(DictInvitation.GAME_INVITATION_SENT,MsgBtnCount.ONE);
      }
      
      private function onRejectRoomMembershipHandle(cEvt:ParaEvent) : void
      {
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            CFunctionContainer.AS_MessageDelete(cEvt.myPara.messageid);
         }
         else
         {
            CFunctionContainer.RejectRoomMembership(cEvt.myPara.senderID);
         }
      }
      
      private function tryJoinRoomHandle(cEvt:ParaEvent) : void
      {
         this._tryJoinRoomPara = cEvt.myPara;
         if(this._tryJoinRoomPara.room.password != "")
         {
            gotoPage(CodoPageViewDB.PAGE_POPUP_JOIN_ROOM_PASSWORD);
         }
         else
         {
            broadcast(BCEvent.JOIN_ROOM,this._tryJoinRoomPara);
         }
      }
      
      private function tryJoinFriendPrivateRoom(cEvt:ParaEvent) : void
      {
         var friendObj:Object = cEvt.myPara;
         this._tryJoinRoomPara = new Object();
         this._tryJoinRoomPara.ticket = false;
         this._tryJoinRoomPara.room = new Object();
         this._tryJoinRoomPara.room.id = friendObj.sessionID;
         gotoPage(CodoPageViewDB.PAGE_POPUP_JOIN_ROOM_PASSWORD);
      }
      
      private function onConfirmEnterJoinRoomPasswordHandle(cEvt:ParaEvent) : void
      {
         prevPage();
         this._tryJoinRoomPara.room.password = cEvt.myPara;
         broadcast(BCEvent.JOIN_ROOM,this._tryJoinRoomPara);
      }
      
      private function onCancelEnterJoinRoomPasswordHandle(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function joinRoomHandle(cEvt:ParaEvent) : void
      {
         if(MatchService.getInstance().isJoiningRoom())
         {
            return;
         }
         if(this.isInRoom())
         {
            showMsg(this.isRankedMatch() ? DictRoom.NOTE_ALREADY_IN_RANKED_MATCH : DictRoom.NOTE_ALREADY_IN_ROOM,MsgBtnCount.ONE);
            return;
         }
         var para:Object = cEvt.myPara;
         if(Boolean(para.room) && Boolean(para.room.id))
         {
            if(Boolean(CFunctionContainer.IsEverBeKickedByRoom(para.room.id)))
            {
               showMsg(DictRoom.NOTE_EVER_BE_KICKED,MsgBtnCount.ONE);
               return;
            }
         }
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            if(this.checkInPartyAsNotHost())
            {
               return;
            }
            if(this._currentMatchType.isPvp() && this.checkInParty())
            {
               return;
            }
            if(this.checkInPartyMemberState())
            {
               return;
            }
         }
         broadcast(BCEvent.EVT_RESET_WARGOD_HIDDEN_ROOM);
         broadcast(BCEvent.EVT_RESET_BCL_HIDDEN_ROOM);
         request(DataID.JOIN_ROOM,cEvt.myPara);
      }
      
      private function joinChannel(channel:uint) : void
      {
         Logger.print("MatchController:::joinChannel channel: " + channel);
         Logger.print("MatchController:::joinChannel _currentChannel: " + this._currentChannel);
         this._currentChannel = channel;
         if(channel != ServerChannel.NONE)
         {
            CFunctionContainer.JoinChannel(channel);
         }
         this._inRoomChannel = channel == ServerChannel.MP_ROOM;
      }
      
      private function startQuickMatch(filter:QuickMatchFilterObj) : void
      {
         var maxPlayer:int;
         var playlistObj:PlayListObj = null;
         var mapObj:MapObj = null;
         if(filter == null)
         {
            return;
         }
         if(this.isInRoom() || this.isInRankedMatch())
         {
            return;
         }
         this._currentQuickMatchFilter = filter;
         if(this._currentQuickMatchFilter.playListID >= 0)
         {
            playlistObj = this.getPlayListObj(this._currentQuickMatchFilter.playListID);
         }
         else if(this._currentQuickMatchFilter.map.length > 0)
         {
            mapObj = getDP(DataID.MAP_OBJ,[this._currentQuickMatchFilter.map]);
         }
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            if(this.checkInPartyAsNotHost() || this.checkInPartyMemberState())
            {
               this._currentQuickMatchFilter = null;
               return;
            }
         }
         maxPlayer = Math.max(1,filter.maxPlayer);
         if(!this.checkPartyCanPlayPlaylist(playlistObj) || this.checkInPartySize(maxPlayer))
         {
            return;
         }
         Logger.print("MatchController:::startQuickMatch _currentQuickMatchFilter.type: " + this._currentQuickMatchFilter.type);
         Logger.print("MatchController:::startQuickMatch _currentQuickMatchFilter.playListID: " + this._currentQuickMatchFilter.playListID);
         try
         {
            DAXDispatcher.setGameModeByType(playlistObj.type);
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
         if(this._currentQuickMatchFilter.playListID >= 0)
         {
            if(!this.checkPartyCanPlayPlaylist(playlistObj) || !this.checkPlaylistPartyOnly(playlistObj))
            {
               return;
            }
            if(playlistObj.type == PlayListType.COMBAT && playlistObj.combatTrainingType == CombatType.CT)
            {
               this.joinChannel(ServerChannel.TRAINING_ROOM);
            }
            else if(playlistObj.type == PlayListType.RANKED)
            {
               this.joinChannel(ServerChannel.MP_PLAYLIST);
            }
         }
         else if(this._currentQuickMatchFilter.map.length > 0)
         {
            if(!mapObj.unlocked)
            {
               showMsg(DictRoom.NOTE_MAP_LOCKED,MsgBtnCount.ONE);
               return;
            }
            if(mapObj.lockedByDLCLevel)
            {
               showMsg(DictRoom.TUTORIAL_NODLC,MsgBtnCount.ONE);
               return;
            }
         }
         request(DataID.QUICK_MATCH,this._currentQuickMatchFilter);
         if(this._currentQuickMatchFilter.type == RoomMatchType.RANKED)
         {
            this.changeRankedMatchStatus(RankedMatchStatus.IN_PROGRESS);
         }
      }
      
      private function enableLeaveRoom(enable:Boolean) : void
      {
         broadcast(BCEvent.RANKED_MATCH_ENABLE_LEAVE_ROOM,enable);
      }
      
      private function dispatchRooms(finished:Boolean = false) : void
      {
         var rooms:Array = this._roomListDP;
         broadcast(BCEvent.EVT_ON_ROOM_LISTED,{
            "finished":finished,
            "rooms":rooms
         });
      }
      
      public function cppSetRoomData(rooms:Array) : void
      {
         broadcast(BCEvent.EVT_ON_ROOM_LISTED,{
            "finished":true,
            "rooms":rooms
         });
      }
      
      public function onRoomListed(cRes:Object) : void
      {
         var result:Object = cRes.data;
         MatchService.getInstance().stillHasOtherRooms = !result.finished;
         this.bind_roomListDP(cRes as ResultObj);
      }
      
      private function enableRoomListEvent(cEnable:Boolean) : void
      {
         request(DataID.ENABLE_ROOM_LIST_EVENT,cEnable);
      }
      
      private function goRoom(cRes:Boolean, cMsg:String = "", cShouldDispatch:Boolean = true, cRoomJustCreated:Boolean = false) : void
      {
         var tempHasPopup:Boolean = false;
         this.joinRoom(cRes,cMsg,cShouldDispatch,cRoomJustCreated);
         if(cRes)
         {
            tempHasPopup = this.getDP(DataID.HAS_POPUP);
            if(tempHasPopup == true)
            {
               this.prevPage();
               broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.FSG_MATCHRESULT});
               broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.PLAYER_DETAIL_INFO});
               broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.CLAN});
            }
            if(Boolean(CFunctionContainer.AS_IsHiddenRoomMatch()) && !getDvarBool("ui_debugHiddenRoom"))
            {
               broadcast(BCEvent.EVT_ENTER_HIDDEN_ROOM_COMPLETE);
            }
            else
            {
               gotoPage(CodoPageViewDB.PAGE_MAIN_IN_ROOM);
            }
         }
      }
      
      private function joinRoom(cRes:Boolean, cMsg:String = "", cShouldDispatch:Boolean = true, cRoomJustCreated:Boolean = false) : void
      {
         if(cShouldDispatch)
         {
            MatchService.getInstance().isInRoom = cRes;
         }
         if(cRes)
         {
            this.setMatchTypeByRoom();
         }
         if(cShouldDispatch)
         {
            broadcast(BCEvent.ON_ROOM_JOINED,{
               "success":cRes,
               "message":cMsg,
               "roomJustCreated":cRoomJustCreated
            });
         }
      }
      
      private function changeRankedMatchStatus(cStatus:String) : void
      {
         Logger.print("MatchController:::changeRankedMatchStatus cStatus: " + cStatus);
         if(this._currentRankedMatchStatus == cStatus)
         {
            return;
         }
         this._previousRankedMatchStatus = this._currentRankedMatchStatus;
         this._currentRankedMatchStatus = cStatus;
         switch(this._currentRankedMatchStatus)
         {
            case RankedMatchStatus.IDLE:
               this._previousRankedMatchStatus = RankedMatchStatus.IDLE;
               break;
            case RankedMatchStatus.IN_PROGRESS:
            case RankedMatchStatus.IN_PROGRESS_IN_ROOM:
               this.startRankedMatchLobbyUpdateTimer();
               break;
            case RankedMatchStatus.READY:
            case RankedMatchStatus.READY_IN_ROOM:
               this.stopRankedMatchLobbyUpdateTimer();
               break;
            case RankedMatchStatus.BACK_FROM_GAME:
               this.startRankedMatchLobbyUpdateTimer();
         }
         this.dispatchRankedMatchStatus();
      }
      
      private function dispatchRankedMatchStatus() : void
      {
         var league:String = null;
         var playList:String = null;
         if(this._currentRankedMatchStatus == RankedMatchStatus.IDLE || this._currentQuickMatchFilter != null)
         {
            if(this._currentQuickMatchFilter != null && this._currentQuickMatchFilter.leagueName.length <= 0)
            {
               this._currentQuickMatchFilter.leagueName = DictRoom.LEAGUES[this._currentQuickMatchFilter.league];
            }
            league = this._currentQuickMatchFilter != null ? this._currentQuickMatchFilter.leagueName : "";
            playList = this._currentQuickMatchFilter != null ? this._currentQuickMatchFilter.playListName : "";
            broadcast(BCEvent.RANKED_MATCH_STATUS_CHANGED,{
               "status":this._currentRankedMatchStatus,
               "leagueName":league,
               "playListName":playList
            });
         }
      }
      
      private function isMapUnlocked(id:String) : Boolean
      {
         return MatchService.getInstance().isMapUnlocked(id);
      }
      
      private function checkPartyCanPlayPlaylist(playlistObj:PlayListObj) : Boolean
      {
         var partyObj:PartyObj = null;
         if(Boolean(getDP(DataID.IS_PARTY_HOST)) && playlistObj != null)
         {
            if(playlistObj.minPartySize == 0 && playlistObj.maxPartySize == 0)
            {
               showMsg(LocalizeUtil.localize(DictRoom.LIST_LOCKPARTY),MsgBtnCount.TWO,0,null,DictSystem.CONFIRM,this.leaveParty,DictParty.LEAVE_PARTY);
               return false;
            }
            partyObj = getDP(DataID.PARTY_INFO);
            if(Boolean(partyObj) && partyObj.members.length < playlistObj.minPartySize)
            {
               showMsg(LocalizeUtil.param(DictParty.PARTY_MEM_LESS_THAN_PLAYLIST,[partyObj.members.length,playlistObj.minPartySize]),MsgBtnCount.ONE);
               return false;
            }
            if(Boolean(partyObj) && partyObj.members.length > playlistObj.maxPartySize)
            {
               showMsg(LocalizeUtil.param(DictParty.PARTY_MEM_MORE_THAN_PLAYLIST,[partyObj.members.length,playlistObj.maxPartySize]),MsgBtnCount.ONE);
               return false;
            }
         }
         return true;
      }
      
      private function checkPlaylistPartyOnly(playlistObj:PlayListObj) : Boolean
      {
         if(!getDP(DataID.IS_IN_PARTY) && playlistObj.partyOnly)
         {
            showMsg(DictParty.PARTY_ONLY_PLAYLIST,MsgBtnCount.ONE);
            return false;
         }
         return true;
      }
      
      private function checkInParty(isCyborg:Boolean = false) : Boolean
      {
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            showMsg(isCyborg ? DictParty.NOTE_NO_CYBORG_TUTORIAL_WITH_PARTY : DictParty.NOTE_IN_A_PARTY,MsgBtnCount.TWO,0,null,DictSystem.ACCEPT,this.leaveParty,DictParty.LEAVE_PARTY);
            return true;
         }
         return false;
      }
      
      private function leaveParty() : void
      {
         this.broadcast(BCEvent.PARTY_LEAVE);
      }
      
      private function checkInPartyAsNotHost() : Boolean
      {
         if(Boolean(getDP(DataID.IS_IN_PARTY)) && !getDP(DataID.IS_PARTY_HOST))
         {
            showMsg(DictParty.NOTE_IN_A_PARTY_AS_NOT_HOST,MsgBtnCount.ONE);
            return true;
         }
         return false;
      }
      
      private function checkInPartyMemberState() : Boolean
      {
         var partyInfo:PartyObj = null;
         var i:int = 0;
         var partyMemberObj:PartyMemberObj = null;
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            partyInfo = getDP(DataID.PARTY_INFO);
            for(i = 0; i < partyInfo.members.length; i++)
            {
               partyMemberObj = partyInfo.members[i] as PartyMemberObj;
               if(Boolean(CFunctionContainer.IsPartyMemberInRoom(partyMemberObj.id)))
               {
                  showMsg(LocalizeUtil.param(DictParty.NOTE_SOMEONE_ALREADY_IN_ROOM,[partyMemberObj.name]),MsgBtnCount.ONE);
                  return true;
               }
            }
         }
         return false;
      }
      
      private function checkInPartySize(maxPlayer:int) : Boolean
      {
         var partyObj:PartyObj = null;
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            partyObj = getDP(DataID.PARTY_INFO);
            if(Boolean(partyObj) && partyObj.members.length > maxPlayer)
            {
               showMsg(LocalizeUtil.param(DictParty.NOTE_PARTY_NUM_TOO_MUCH,[partyObj.members.length,maxPlayer]),MsgBtnCount.ONE);
               return true;
            }
         }
         return false;
      }
      
      private function onShowTokenBuyPopupHandle(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_POPUP_TOKEN_BUY);
      }
      
      private function onQuitTokenBuyPopupHandle(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function onTokenBuyPopupStartGameHandle(cEvt:ParaEvent) : void
      {
         prevPage();
         broadcast(BCEvent.EVT_BOTTOM_START_GAME);
      }
      
      private function onFetchGroupCountTimerHandle(event:TimerEvent) : void
      {
         this.cppRefreshGroupCount();
         if(!ScaleformUtil.isScaleform)
         {
            this.cppRefreshPlaylistPlayerCount("0@600");
         }
      }
      
      public function cppRefreshGroupCount(refresh:Boolean = true) : void
      {
         if(refresh)
         {
            request(DataID.GROUP_COUNTS);
         }
      }
      
      public function cppSetRefreshGroupCountInterval(interval:int) : void
      {
         interval = interval > 0 ? int(interval * 1000) : int(120 * 1000);
         this._fetchGroupCountTimer.stop();
         this._fetchGroupCountTimer.delay = interval;
         this._fetchGroupCountTimer.start();
      }
      
      public function cppRefreshPlaylistPlayerCount(params:String) : void
      {
         if(params == null || params.length <= 0 || params.indexOf("@") == -1)
         {
            return;
         }
         var paramsArr:Array = params.split("@");
         MatchService.getInstance().setPlayListPlayerNum([{
            "groupID":int(paramsArr[0]),
            "groupCount":int(paramsArr[1])
         }]);
         setBindData(DataID.GROUP_COUNTS,this._groupCounts);
      }
      
      public function cppIsInRankedMatch() : Boolean
      {
         return this.isRankedMatchInProgress();
      }
      
      public function cppShutdownFlash() : void
      {
         Logger.print("MatchController:::cppShutdownFlash");
         broadcast(BCEvent.SHUTDOWN_FLASH);
      }
   }
}

