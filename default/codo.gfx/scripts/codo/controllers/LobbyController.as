package codo.controllers
{
   import codo.base.BaseController;
   import codo.base.BaseSubElement;
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.*;
   import codo.constants.table.*;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.manager.EventManager;
   import codo.manager.PageManagerMain;
   import codo.objects.*;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.services.*;
   import codo.utils.*;
   import components.fsggamelobby_part.FsgGameLobbyConsts;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   import fsg.util.FsgAudioUtil;
   import shaui.component.core.UIComponent;
   
   public class LobbyController extends BaseController
   {
      
      private var _roomObj:RoomObj = new RoomObj();
      
      private var _roomMembers:Array = [];
      
      private var _dedicatedServers:Array = [];
      
      private var _ac130Types:Array;
      
      private var _currentSelectedWeaponSlot:Object = null;
      
      private var _dlcWarningEverSent:Boolean = false;
      
      private var _currentSelectedCharacter:RoomMemberObj = null;
      
      private var _currentSelectedMember:RoomMemberObj = null;
      
      private var _isCareerStatsSet:Boolean = false;
      
      private var _isRenewingAvatar:uint = 0;
      
      private var _parentGlowFilter:GlowFilter = new GlowFilter(16711680);
      
      private var _childGlowFilter:GlowFilter = new GlowFilter(16711680);
      
      private var _glowFilterTimers:Array = [];
      
      private var _characterList:Vector.<CharacterObj>;
      
      private var _currentCharacterIdx:int = -1;
      
      private var _backToLobbyButtonTimer:Timer;
      
      private var _pageChangeDelayed:Boolean = false;
      
      private var _delayNextPage:Boolean = false;
      
      private var _roomOptionsRowInfo:Vector.<MatchSelectTableRowObj>;
      
      private var _disabledOptionsRowInfo:Vector.<MatchSelectTableRowObj>;
      
      private var _numMiniClientMember:int = -1;
      
      private var _onceAutoSelected:Boolean = false;
      
      private var _requestChangeReadyState:Boolean = false;
      
      private var _confirmedReadyState:Boolean = false;
      
      public function LobbyController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.IS_IN_ROOM_READY,this.isReady);
         addDP(DataID.IS_ROOM_HOST,this.isRoomHost);
         addDP(DataID.IS_IN_MY_ROOM,this.isInMyRoom);
         addDP(DataID.IS_LEAVING_ROOM,this.isLeavingRoom);
         addDP(DataID.IS_GAME_COUNTING_DOWN,this.isGameStartCountingDown);
         addDP(DataID.ROOM_MEMBER_OBJ,this.getRoomMemberObj);
         addDP(DataID.ROOM_MEMBER_OBJ_BY_ID,this.getRoomMemberObjByID);
         addDP(DataID.CURRENT_SELECTED_CHARACTER_MEMBER_OBJ,this.getCurrentSelectedCharacterMemeberObj);
         addDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ,this.getCurrentSelectedMemberMemberObj);
         addDP(DataID.MY_AVATAR_MEMBER_OBJ,this.getMyAvatarMemberObj);
         addDP(DataID.ROOM_INFO,this.getRoomInfo);
         addDP(DataID.GET_ROOM_OPTIONS_ROW_INFO,this.getRoomOptionsRowInfo);
         addDP(DataID.SET_ROOM_OPTION_VALUE,this.setRoomOptionValue);
         addDP(DataID.LIST_SUPPORTED_OPTIONS,this.listSupportedOptions);
         addDP(DataID.LIST_PRIMARY_OPTIONS,this.listPrimaryOptions);
         addDP(DataID.ROOM_ITEM_BANS_ENABLED,this.getItemBansEnabled);
         bind(DataID.LEAVE_ROOM,this.bind_onRoomLeft);
         bind(DataID.LIST_DEDICATED_SERVER,this.bind_dedicatedServerDP);
         bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         listen(BCEvent.ON_ROOM_JOINED,this.onRoomJoinedHandle);
         listen(BCEvent.CHANGE_READY_STATE,this.onChangeReadyStateHandle);
         listen(BCEvent.LIST_DEDICATED_SERVER,this.onListDedicatedServerHandle);
         listen(BCEvent.RANKED_MATCH_STATUS_CHANGED,this.onRankedMatchStatusChangedHandle);
         listen(BCEvent.TEAM_AVATAR,this.onCheckTeamAvatar);
         listen(BCEvent.CHANGE_TEAM,this.onChangeTeamHandle);
         listen(BCEvent.CHANGE_ROOM_INFO,this.onChangeRoomInfoHandle);
         listen(BCEvent.CHANGE_ROOM_OPTIONS,this.onChangeRoomOptionsHandle);
         listen(BCEvent.VOTE_MAP,this.onVoteMapHandle);
         listen(BCEvent.SET_FINAL_VOTE,this.setFinalVoting);
         listen(BCEvent.SET_PILOT,this.onSetPilotHandle);
         listen(BCEvent.START_MATCH,this.onStartMatchHandle);
         listen(BCEvent.CACHE_ROOM_INFO,this.onCacheRoomInfoHandle);
         listen(BCEvent.REINSTANCE_ROOM_OPTIONS,this.onReinstanceRoomOptionsHandle);
         listen(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS_WARNING,this.onShowMatchItemRestrictionsWarning);
         listen(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS,this.onShowMatchItemRestrictions);
         listen(BCEvent.EVT_GOTO_CREATEROOMOPTION,this.onGotoCreateRoomOptionHandle);
         listen(BCEvent.EVT_CLOSE_CREATEROOMOPTION,this.onCloseCreateRoomOptionHandle);
         listen(BCEvent.LOBBY_REFRESH_AVATAR,this.onRefreshAvatarHandle);
         listen(BCEvent.LOBBY_REFRESH_WEAPON,this.onRefreshWeaponHandle);
         listen(BCEvent.LOBBY_RENEW_AVATAR,this.onRenewAvatarHandle);
         listen(BCEvent.LOBBY_RENEW_WEAPON,this.onRenewWeaponHandle);
         listen(BCEvent.LOBBY_WEAPON_SLOT_CLICK,this.onWeaponSlotClickedHandle);
         listen(BCEvent.LOBBY_CHANGE_WEAPON_LOADOUT,this.onWeaponLoadoutChangedHandle);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangeHandle);
         listen(BCEvent.EVT_ON_BACKTOLOBBY_BUTTON_DISABLED,this.startBackToLobbyButtonTimer);
         listen(BCEvent.EVT_MATCH_RESULTS_OPEN,this.onNextPageDelayStart);
         listen(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.onNextPageDelayEnd);
         listen(BCEvent.EVT_LOBBY_TRY_SELECT_MEMBER,this.onTrySelectMember);
         this.initDisabledOptionsRowInfo();
         this.initRoomOptionsRowInfo();
         var dvarBackToLobbyButtonTime:int = CFunctionCommonContainer.Dvar_GetInt("ui_return_lobby_timeout");
         var backToLobbyButtonTime:Number = 1000 * dvarBackToLobbyButtonTime;
         this._backToLobbyButtonTimer = new Timer(backToLobbyButtonTime,1);
         this._backToLobbyButtonTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.backToLobbyButtonTimer);
      }
      
      private function initDisabledOptionsRowInfo() : void
      {
         var rows:Array = null;
         var i:int = 0;
         var options:Array = null;
         var newRow:MatchSelectTableRowObj = null;
         var j:int = 0;
         var values:Array = null;
         var newData:MatchSelectTableRowModeObj = null;
         this._disabledOptionsRowInfo = new Vector.<MatchSelectTableRowObj>();
         var disabled:String = CFunctionCommonContainer.AS_GetDisabledMatchSelectOptions();
         if(disabled != "")
         {
            rows = disabled.split("|");
            for(i = 0; i < rows.length; i++)
            {
               options = rows[i].split(";");
               newRow = new MatchSelectTableRowObj();
               newRow.index = parseInt(options[0]);
               newRow.data = new Vector.<MatchSelectTableRowModeObj>();
               for(j = 1; j < options.length; j++)
               {
                  values = options[j].split(":");
                  if(values.length == 2)
                  {
                     newData = new MatchSelectTableRowModeObj();
                     newData.modeID = values[0];
                     newData.dataComboBox = values[1].split(",");
                     newRow.data.push(newData);
                  }
               }
               this._disabledOptionsRowInfo.push(newRow);
            }
         }
      }
      
      private function IsOptionDisabled(index:int, mode:String, select:String) : Boolean
      {
         var j:int = 0;
         for(var i:int = 0; i < this._disabledOptionsRowInfo.length; i++)
         {
            if(this._disabledOptionsRowInfo[i].index == index)
            {
               j = 0;
               while(j < this._disabledOptionsRowInfo[i].data.length)
               {
                  if(this._disabledOptionsRowInfo[i].data[j].modeID == mode && this._disabledOptionsRowInfo[i].data[j].dataComboBox.indexOf(select) != -1)
                  {
                     return true;
                     break;
                  }
                  j++;
               }
            }
         }
         return false;
      }
      
      private function initRoomOptionsRowInfo() : void
      {
         var newRow:MatchSelectTableRowObj = null;
         var gotoNextRow:Boolean = false;
         var modeID:String = null;
         var newData:MatchSelectTableRowModeObj = null;
         var resetDefaultValue:Boolean = false;
         var column:int = 0;
         var name:String = null;
         var id:String = null;
         var newElement:Object = null;
         this._roomOptionsRowInfo = new Vector.<MatchSelectTableRowObj>();
         var numRows:int = TableUtil.getRowCount(MatchSelectOptions.PATH);
         for(var i:int = 0; i < numRows; i++)
         {
            newRow = new MatchSelectTableRowObj();
            newRow.index = parseInt(TableUtil.getValue(MatchSelectOptions.PATH,i,MatchSelectOptions.INDEX));
            newRow.label = "@" + TableUtil.getValue(MatchSelectOptions.PATH,i,MatchSelectOptions.LABEL);
            newRow.data = new Vector.<MatchSelectTableRowModeObj>();
            gotoNextRow = true;
            modeID = "";
            while(gotoNextRow)
            {
               i += 1;
               modeID = TableUtil.getValue(MatchSelectOptions.PATH,i,MatchSelectOptions.MODE_ID);
               if(i >= numRows || modeID == "")
               {
                  gotoNextRow = false;
                  i--;
               }
               else
               {
                  newData = new MatchSelectTableRowModeObj();
                  newData.modeID = modeID;
                  newData.defaultValue = TableUtil.getValue(MatchSelectOptions.PATH,i,MatchSelectOptions.DEFAULT_VALUE);
                  newData.dataComboBox = [];
                  resetDefaultValue = false;
                  column = MatchSelectOptions.COMBO_BOX_DETAILS;
                  while(true)
                  {
                     name = TableUtil.getValue(MatchSelectOptions.PATH,i,column);
                     if(name == "")
                     {
                        break;
                     }
                     id = TableUtil.getValue(MatchSelectOptions.PATH,i,column + 1);
                     newElement = {};
                     newElement.name = !isNaN(parseFloat(name)) ? name : "@" + name;
                     newElement.id = id;
                     if(this.IsOptionDisabled(newRow.index,newData.modeID,id))
                     {
                        if(id == newData.defaultValue)
                        {
                           resetDefaultValue = true;
                        }
                     }
                     else
                     {
                        newData.dataComboBox.push(newElement);
                     }
                     column += 2;
                     if(column >= TableUtil.getColumnCount(MatchSelectOptions.PATH))
                     {
                        break;
                     }
                  }
                  if(resetDefaultValue && newData.dataComboBox.length > 0)
                  {
                     newData.defaultValue = newData.dataComboBox[0].id;
                  }
                  newRow.data.push(newData);
               }
            }
            this._roomOptionsRowInfo.push(newRow);
         }
      }
      
      public function getRoomInfo() : RoomObj
      {
         return this._roomObj;
      }
      
      public function getRoomOptionsRowInfo() : Vector.<MatchSelectTableRowObj>
      {
         return this._roomOptionsRowInfo;
      }
      
      private function setRoomOptionValue(options:RoomOptionObj, index:int, value:Object) : RoomOptionObj
      {
         var subValues:Array = null;
         switch(index)
         {
            case CreateRoomOptionsList.MODE_TIME_LIMIT:
               options.modeTimeLimit = Number(value);
               break;
            case CreateRoomOptionsList.MODE_SCORE_LIMIT:
               options.modeScoreLimit = int(value);
               break;
            case CreateRoomOptionsList.MODE_ROUND_LIMIT:
               options.modeRoundLimit = int(value);
               break;
            case CreateRoomOptionsList.MODE_WIN_LIMIT:
               options.modeWinLimit = int(value);
               break;
            case CreateRoomOptionsList.MODE_ROUND_SWITCH:
               options.modeRoundSwitch = int(value);
               break;
            case CreateRoomOptionsList.MODE_NUM_LIVES:
               options.modeNumLives = int(value);
               break;
            case CreateRoomOptionsList.MODE_PLAYER_RESPAWN_DELAY:
               options.modePlayerRespawnDelay = Number(value);
               break;
            case CreateRoomOptionsList.MODE_WAVE_RESPAWN_DELAY:
               options.modeWaveRespawnDelay = Number(value);
               break;
            case CreateRoomOptionsList.MODE_BOMB_TIMER:
               options.modeBombTimer = Number(value);
               break;
            case CreateRoomOptionsList.MODE_PLANT_TIME:
               options.modePlantTime = Number(value);
               break;
            case CreateRoomOptionsList.MODE_DEFUSE_TIME:
               options.modeDefuseTime = Number(value);
               break;
            case CreateRoomOptionsList.PLAYER_MAX_HEALTH:
               options.playerMaxHealth = int(value);
               break;
            case CreateRoomOptionsList.PLAYER_HEALTH_REGEN_TIME:
               options.playerHealthRegenTime = int(value);
               break;
            case CreateRoomOptionsList.PLAYER_HEALTH_REGEN_RATE:
               options.playerHealthRegenRate = Number(value);
               break;
            case CreateRoomOptionsList.TEAM_FF_TYPE:
               options.teamFFType = int(value);
               break;
            case CreateRoomOptionsList.GAME_SPECTATE_TYPE:
               options.gameSpectateType = int(value);
               break;
            case CreateRoomOptionsList.GAME_ALLOW_KILLCAM:
               options.gameAllowKillCam = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.GAME_ENABLE_HARDCORE:
               options.gameEnableHardcore = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.GAME_FORCE_UAV:
               options.gameForceUAV = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.GAME_ONLY_HEADSHOTS:
               options.gameOnlyHeadshots = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.GAME_ENABLE_BUDDY_MODE:
               options.gameEnableBuddyMode = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.RESTRICT_WPNS_AT_START:
               options.restrictWpnsAtStart = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.COMBAT_HIGH_HOSTILE_ACTION_END:
               options.combatHighHostileActionEnd = int(value);
               break;
            case CreateRoomOptionsList.BOTS_ADD_ALL:
               options.botsAddAll = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.CLASH_MODE:
               options.clashMode = int(value);
               break;
            case CreateRoomOptionsList.CLASH_FOV:
               options.clashFOV = int(value);
               break;
            case CreateRoomOptionsList.DIFFICULTY:
               subValues = value.split("|");
               options.difficulty = int(subValues[0]);
               options.isEndless = subValues.length > 1 && RoomOptionObj.DIFFICULTY_ENDLESS == subValues[1];
               break;
            case CreateRoomOptionsList.GAME_FORBID_SPAWN_BULLET_WEAPON:
               options.gameForbidSpawnBulletWeapon = String(value).toLowerCase() == "true";
               break;
            case CreateRoomOptionsList.GAME_FORBID_SPAWN_GRENADE:
               options.gameForbidSpawnGrenade = String(value).toLowerCase() == "true";
         }
         return options;
      }
      
      private function listSupportedOptions(mode:String) : Array
      {
         return MatchService.getInstance().listSupportedOptions(mode);
      }
      
      private function listPrimaryOptions(mode:String) : Array
      {
         return MatchService.getInstance().listPrimaryOptions(mode);
      }
      
      private function getItemBansEnabled() : Boolean
      {
         return MatchService.getInstance().getItemBansEnabled(this._roomObj.currentMatchMode.id);
      }
      
      private function onNextPageDelayStart() : void
      {
         this._delayNextPage = true;
      }
      
      private function onNextPageDelayEnd() : void
      {
         this._delayNextPage = false;
         if(this._pageChangeDelayed == true)
         {
            this.continueNextPage();
         }
      }
      
      private function startBackToLobbyButtonTimer(cEvt:ParaEvent) : void
      {
         this._backToLobbyButtonTimer.reset();
         this._backToLobbyButtonTimer.start();
      }
      
      private function backToLobbyButtonTimer(cEvt:TimerEvent) : void
      {
         broadcast(BCEvent.EVT_REENABLE_BACKTOLOBBY_BUTTON);
      }
      
      public function cppOnRoomIsMerged() : void
      {
         this._requestChangeReadyState = false;
      }
      
      public function cppSetRoomTeamNames(teamNames:Array) : void
      {
         broadcast(BCEvent.LOBBY_SET_PLAYER_NAMES,teamNames);
      }
      
      public function cppSetRoomInfo(info:Object) : void
      {
         Logger.print("LobbyController:::cppSetRoomInfo info.name: " + info.name);
         this.setRoomInfo(info);
      }
      
      public function cppSetRoomMembers(members:Array) : void
      {
         Logger.print("LobbyController:::cppSetRoomMembers members: " + members);
         this.setRoomMembers(members);
      }
      
      public function cppOnMemberClanNameUpdated(userID:String, clanName:String) : void
      {
         var member:RoomMemberObj = this.getRoomMemberObjByID(userID);
         if(Boolean(member))
         {
            member.clanName = clanName;
         }
      }
      
      public function cppSelectCharacter(loadout:Object, characterID:String, forceHide:Boolean, selected:Boolean) : Boolean
      {
         if(selected && this._currentSelectedCharacter != null && this._currentSelectedCharacter.id == characterID)
         {
            return true;
         }
         if(selected == false && (this._currentSelectedCharacter == null || this._currentSelectedCharacter.id == "0"))
         {
            this.validateCurrentSelectedMember();
            return true;
         }
         if(this._roomObj.currentMatchMode.id == ClashPvpUtil.MODE_ID)
         {
            return true;
         }
         var weaponLoadout:WeaponLoadoutObj = loadout == null ? null : new WeaponLoadoutObj(loadout);
         if(selected && !forceHide)
         {
            setBindData(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,characterID);
            this._currentSelectedCharacter = this.getRoomMemberObjByID(characterID);
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ZOOM_IN);
            if(this._currentSelectedCharacter != null && this._currentSelectedCharacter.team != FsgGameLobbyConsts.TEAM_SPECTATOR)
            {
               this._currentSelectedMember = this._currentSelectedCharacter;
            }
            else
            {
               this._currentSelectedMember = null;
            }
            if(this._currentSelectedMember != null)
            {
               this._currentSelectedMember.weaponloadObj = weaponLoadout;
            }
            if(CFunctionCommonContainer.GetPlayerID() == characterID)
            {
               weaponLoadout.isMe = true;
            }
            this.validateCurrentSelectedMember();
            broadcast(BCEvent.EVT_SELECTED_CHARACTER,this._currentSelectedCharacter);
         }
         else
         {
            this._currentSelectedCharacter = null;
            broadcast(BCEvent.EVT_SELECTED_CHARACTER_CLEARED);
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ZOOM_OUT);
         }
         return true;
      }
      
      private function validateCurrentSelectedMember() : void
      {
         ScaleformUtil.isMe = true;
         var myId:String = CFunctionCommonContainer.GetPlayerID();
         var myMemberObj:RoomMemberObj = this.getRoomMemberObjByID(myId);
         if(this._currentSelectedMember == null || myMemberObj != null && myMemberObj.team != this._currentSelectedMember.team)
         {
            this._currentSelectedMember = myMemberObj;
         }
         if(Boolean(this._currentSelectedMember))
         {
            ScaleformUtil.isMe = this._currentSelectedMember.isMe;
            broadcast(BCEvent.TEAM_AVATAR,this._currentSelectedMember.team);
         }
         broadcast(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this._currentSelectedMember);
      }
      
      private function getCurrentSelectedCharacterMemeberObj() : RoomMemberObj
      {
         return this._currentSelectedCharacter;
      }
      
      private function getCurrentSelectedMemberMemberObj() : RoomMemberObj
      {
         return this._currentSelectedMember;
      }
      
      private function getMyAvatarMemberObj() : RoomMemberObj
      {
         var myId:String = CFunctionCommonContainer.GetPlayerID();
         return this.getRoomMemberObjByID(myId);
      }
      
      public function cppSetCharacterAvatarSlots(playerID:String, avatarSlots:Object, weaponSlots:Object) : void
      {
         var prop:String = null;
         var slotObj:Object = null;
         var itemID:int = 0;
         var roomMemberObj:RoomMemberObj = this.getRoomMemberObjByID(playerID);
         if(roomMemberObj != null)
         {
            if(roomMemberObj.isMe)
            {
               this.refreshMyAvatar(roomMemberObj);
               this.refreshMyWeaponLoadout();
            }
            else
            {
               roomMemberObj.avatarItemSlots = avatarSlots;
               for(prop in roomMemberObj.avatarItemSlots)
               {
                  slotObj = roomMemberObj.avatarItemSlots[prop];
                  itemID = slotObj.hasOwnProperty("item_id") ? int(slotObj.item_id) : 0;
                  if(itemID > 0)
                  {
                     slotObj.itemDat = MarketService.getInstance().getItemInfoObj(itemID);
                  }
                  if(slotObj.itemDat == null)
                  {
                     slotObj.itemDat = new ItemObj();
                  }
               }
               roomMemberObj.weaponloadObj = new WeaponLoadoutObj(weaponSlots);
               WeaponLoadoutService.getInstance().fillWeaponLoadout(roomMemberObj.weaponloadObj);
            }
            if(this._currentSelectedCharacter != null && this._currentSelectedCharacter.id == roomMemberObj.id)
            {
               this.refreshLobbyCharacter(roomMemberObj);
            }
         }
      }
      
      public function cppSetRoomRTTParams(params:Object) : void
      {
         if(params == null)
         {
            return;
         }
         broadcast(BCEvent.LOBBY_RTT_PARAMS,params);
      }
      
      public function cppSetMemberVote(member:String, vote:int) : void
      {
         var roomMemberObj:RoomMemberObj = this.getRoomMemberObjByID(member);
         if(Boolean(roomMemberObj))
         {
            roomMemberObj.vote = vote;
            this.refreshRoomVoting();
         }
      }
      
      public function cppSetMemberReadyState(member:String, ready:Boolean) : void
      {
         var nonSpectatorPlayers:int = 0;
         var roomMemberObj:RoomMemberObj = this.getRoomMemberObjByID(member);
         if(Boolean(roomMemberObj))
         {
            roomMemberObj.isReady = ready;
            if(Boolean(getDP(DataID.IS_ME,[roomMemberObj])))
            {
               this._confirmedReadyState = ready;
               this._roomObj.forces.isReady = ready;
               if(this._roomObj.forces.showChangeForceBtn)
               {
                  this._roomObj.forces.enableChangeForce0 = !ready && !this._roomObj.forces.isInForce0;
                  this._roomObj.forces.enableChangeForce1 = !ready && !this._roomObj.forces.isInForce1;
                  this._roomObj.forces.enableChangeForce2 = !ready && !this._roomObj.forces.isInForce2;
               }
               if(this._roomObj.forces.showChangeMapBtn)
               {
                  this._roomObj.forces.enableChangeMapBtn = !ready;
               }
               this._requestChangeReadyState = false;
               broadcast(BCEvent.READY_STATE_CHANGE_COMPLETE,ready);
            }
            broadcast(BCEvent.ROOM_STATE_CHANGED,{
               "team":roomMemberObj.team,
               "forces":this._roomObj.forces
            });
         }
         var allReady:Boolean = true;
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(!this._roomMembers[i].isReady)
            {
               this._roomObj.forces.votes.enable = true;
               broadcast(BCEvent.REFRESH_MAP_VOTING,this._roomObj);
               allReady = false;
               break;
            }
         }
         if(allReady)
         {
            this.setFinalVoting();
            nonSpectatorPlayers = 0;
            for(i = 0; i < this._roomMembers.length; i++)
            {
               if(this._roomMembers[i].team != FsgGameLobbyConsts.TEAM_SPECTATOR)
               {
                  nonSpectatorPlayers++;
               }
            }
            if(nonSpectatorPlayers >= this._roomObj.currentMinPlayers)
            {
               broadcast(BCEvent.ALL_READY);
            }
         }
      }
      
      private function initCharacterList() : void
      {
         var i:int = 0;
         if(!CFunctionCommonContainer.IsMarketplaceReady())
         {
            return;
         }
         if(this._currentCharacterIdx >= 0)
         {
            return;
         }
         this._characterList = CharacterLoadoutService.getInstance().getAssignedCharacterArray();
         if(Boolean(this._characterList))
         {
            for(i = 0; i < this._characterList.length; i++)
            {
               if(this._characterList[i].isDefault)
               {
                  this._currentCharacterIdx = i;
                  break;
               }
            }
         }
      }
      
      private function onListDedicatedServerHandle(cEvt:ParaEvent) : void
      {
         request(DataID.LIST_DEDICATED_SERVER,cEvt.myPara);
      }
      
      private function isInMyRoom(cUser:Object) : Boolean
      {
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(this._roomMembers[i].id == cUser.id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isLeavingRoom() : Boolean
      {
         return MatchService.getInstance().isLeavingRoom();
      }
      
      private function isRoomHost() : Boolean
      {
         return Boolean(CFunctionContainer.IsRoomHost());
      }
      
      private function isGameStartCountingDown() : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetFloat("dw_gameStartCountingDown") > 0;
      }
      
      private function onRoomJoinedHandle(cEvt:ParaEvent) : void
      {
         if(this.isRoomHost() && Boolean(cEvt.myPara.roomJustCreated))
         {
            broadcast(BCEvent.REINSTANCE_ROOM_OPTIONS);
         }
         this._pageChangeDelayed = false;
      }
      
      private function onChangeReadyStateHandle(cEvt:ParaEvent) : void
      {
         if(!this.isRoomInfoReady())
         {
            return;
         }
         if(this._requestChangeReadyState)
         {
            return;
         }
         this._requestChangeReadyState = true;
         var readyToSet:Boolean = !this.isReady();
         if(readyToSet)
         {
            if(this.isRoomHost())
            {
               this._roomObj.forces.enableChangeMapBtn = !this._roomObj.isPlayList && !readyToSet;
            }
            this._roomObj.forces.enableChangeForce0 = false;
            this._roomObj.forces.enableChangeForce1 = false;
            this._roomObj.forces.enableChangeForce2 = false;
            broadcast(BCEvent.ROOM_STATE_CHANGED,{
               "team":this.me.team,
               "forces":this._roomObj.forces
            });
         }
         CFunctionContainer.SetReadyState(readyToSet);
      }
      
      private function isReady() : Boolean
      {
         return Boolean(CFunctionContainer.GetReadyState());
      }
      
      private function listAC130Type() : Array
      {
         if(this._ac130Types == null)
         {
            this._ac130Types = [{
               "id":0,
               "name":DictRoom.AC130_TYPE_GROUND
            },{
               "id":1,
               "name":DictRoom.AC130_TYPE_PILOT
            }];
         }
         return this._ac130Types;
      }
      
      private function isAC130(map:Object) : Boolean
      {
         if(map == null || map.id.length <= 0)
         {
            return false;
         }
         return map.id == "coop_spec_mp_hunted_spring" || map.id == "coop_spec1_mp_suburbs";
      }
      
      private function getRoomMemberObj(name:String) : RoomMemberObj
      {
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(this._roomMembers[i].name == name)
            {
               return this._roomMembers[i];
            }
         }
         return null;
      }
      
      private function getRoomMemberObjByID(id:String) : RoomMemberObj
      {
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(this._roomMembers[i].id == id)
            {
               return this._roomMembers[i];
            }
         }
         return null;
      }
      
      private function isBootCampPlayList() : Boolean
      {
         var playListObj:PlayListObj = null;
         if(this._roomObj.isPlayList)
         {
            playListObj = this.getCurrentPlayList();
            return playListObj != null && playListObj.combatTrainingType == CombatType.CT && playListObj.leagueID == 0;
         }
         return false;
      }
      
      private function bind_onRoomLeft(cRes:Object) : void
      {
         this.resetRoom();
         this._isRenewingAvatar = 0;
         this._roomMembers.splice(0);
         this._currentSelectedWeaponSlot = null;
         this._currentSelectedCharacter = null;
         this._currentSelectedMember = null;
         MatchService.getInstance().isInRoom = false;
         this._characterList = null;
         this._currentCharacterIdx = -1;
         this._onceAutoSelected = false;
         this._requestChangeReadyState = false;
         this._confirmedReadyState = false;
         this._dlcWarningEverSent = false;
         broadcast(BCEvent.ON_ROOM_LEFT);
         if(this._delayNextPage == true)
         {
            Logger.print("_delayNextPage == true");
            this._pageChangeDelayed = true;
         }
         else
         {
            Logger.print("_delayNextPage == false");
            this._pageChangeDelayed = false;
            this.continueNextPage();
         }
         setBindData(DataID.ROOM_INFO,null);
         this._backToLobbyButtonTimer.stop();
      }
      
      private function continueNextPage() : void
      {
         var currentPageID:String = null;
         this._delayNextPage = false;
         var faction:uint = CharacterLoadoutService.getInstance().currentLoadoutType;
         CFunctionContainer.UIViewer_SetFaction(faction);
         var invTutorial:UITourToolTipObj = TutorialService.getInstance().getPendingInventoryTutorial();
         if(invTutorial != null)
         {
            PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_PERSISTENT);
            this.goToInventoryTutorial(invTutorial);
         }
         else
         {
            currentPageID = getDP(DataID.CURRENT_MAIN_PAGE_ID);
            if(currentPageID == "" || currentPageID == PageID.INROOM)
            {
               PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_PERSISTENT);
               broadcast(BCEvent.EVT_GOTO_MATCH_SELECT);
            }
         }
         this._pageChangeDelayed = false;
         var streakBreak:PlayListObj = PlayListObj.getStreakBreakPlaylist();
         if(streakBreak != null)
         {
            PlayListObj.setStreakBreakPlaylist(null);
            broadcast(BCEvent.EVT_START_QUICK_MATCH_MP,{"data":streakBreak});
         }
      }
      
      private function goToInventoryTutorial(invTutorial:UITourToolTipObj) : void
      {
         TutorialService.getInstance().setPendingInventoryTutorial(null);
         broadcast(BCEvent.EVT_GOTO_LOADOUT_TAB,invTutorial.destinationTab);
      }
      
      private function bind_dedicatedServerDP(cRes:Object) : void
      {
         this._dedicatedServers = cRes.data;
         broadcast(BCEvent.ON_DEDICATED_SERVER_LISTED,this._dedicatedServers);
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         Logger.print("LobbyController:::bind_dataReceived data: " + cRes.data);
         if(cRes.result == 1 && (cRes.data == Common.MARKET_RECEIVED || cRes.data == Common.PLAYERDATA_RECEIVED))
         {
            this.initCharacterList();
            this.refreshMyAvatar(this.me);
            if(MatchService.getInstance().isInRoom)
            {
               CFunctionContainer.MarketDataReceivedInRoom();
            }
         }
      }
      
      private function onSetPilotHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara == null)
         {
            return;
         }
         var isPilot:Boolean = cEvt.myPara.id == 1;
         if(isPilot != CFunctionContainer.IsPilot())
         {
            CFunctionContainer.SetPilot(isPilot);
         }
      }
      
      private function onStartMatchHandle(cEvt:ParaEvent) : void
      {
         var msg:String = null;
         if(!this.isRoomInfoReady())
         {
            return;
         }
         var max:uint = this._roomObj.currentMaxPlayers;
         var min:uint = this._roomObj.currentMinPlayers;
         var current:uint = this._roomMembers.length;
         if(Boolean(getDP(DataID.IS_SHIP_BUILD)) && !getDP(DataID.IS_WHITELIST_TESTER))
         {
            msg = current < min ? DictRoom.ERROR_ROOM_NOT_ENOUGH : (current > max ? DictRoom.ERROR_ROOM_TOO_MANY : "");
            if(msg.length > 0)
            {
               showMsg(msg,MsgBtnCount.ONE);
               return;
            }
         }
         this.setFinalVoting();
         request(DataID.START_MATCH,cEvt.myPara);
      }
      
      private function onCacheRoomInfoHandle(cEvt:ParaEvent) : void
      {
         this._roomObj.options = cEvt.myPara.options;
      }
      
      private function onReinstanceRoomOptionsHandle(cEvt:ParaEvent) : void
      {
         var numModes:uint = 0;
         var value:Object = null;
         var j:uint = 0;
         trace("LobbyController::onReinstanceRoomOptionsHandle");
         this._roomObj.options = new RoomOptionObj();
         var numRows:uint = this._roomOptionsRowInfo.length;
         for(var i:uint = 0; i < numRows; i++)
         {
            value = this._roomOptionsRowInfo[i].data[0].defaultValue;
            numModes = this._roomOptionsRowInfo[i].data.length;
            for(j = 1; j < numModes; j++)
            {
               if(this._roomOptionsRowInfo[i].data[j].modeID == this._roomObj.currentMatchMode.id)
               {
                  value = this._roomOptionsRowInfo[i].data[j].defaultValue;
                  break;
               }
            }
            this._roomObj.options = this.setRoomOptionValue(this._roomObj.options,this._roomOptionsRowInfo[i].index,value);
         }
         this.broadcast(BCEvent.CHANGE_ROOM_OPTIONS,this._roomObj);
      }
      
      private function onGotoCreateRoomOptionHandle() : void
      {
         this.gotoPage(CodoPageViewDB.PAGE_FSG_CREATEROOMOPTIONS);
      }
      
      private function onShowMatchItemRestrictionsWarning(cEvt:ParaEvent) : void
      {
         this.gotoPage(CodoPageViewDB.PAGE_POPUP_ITEM_RESTRICTION_WARNING,cEvt.myPara);
      }
      
      private function onShowMatchItemRestrictions(cEvt:ParaEvent) : void
      {
         this.gotoPage(CodoPageViewDB.PAGE_POPUP_ITEM_RESTRICTION_PREVIEW,cEvt.myPara);
      }
      
      private function onCloseCreateRoomOptionHandle(cEvt:ParaEvent) : void
      {
         this.prevPage();
      }
      
      private function onCheckTeamAvatar(cEvt:ParaEvent) : void
      {
         var team:int = cEvt.myPara;
         CFunctionContainer.CheckTeamAvatar(team);
      }
      
      private function onChangeTeamHandle(cEvt:ParaEvent) : void
      {
         var team:uint = CFunctionContainer.GetTeamType();
         if(team == cEvt.myPara)
         {
            return;
         }
         CFunctionContainer.ChangeTeam(cEvt.myPara);
      }
      
      private function onVoteMapHandle(cEvt:ParaEvent) : void
      {
         CFunctionContainer.VoteMap(int(cEvt.myPara));
      }
      
      private function onChangeRoomInfoHandle(cEvt:ParaEvent) : void
      {
         var mode:String = null;
         if(cEvt.myPara.data == null || !this.isRoomHost())
         {
            Logger.print("LobbyController:::onChangeRoomInfoHandle: warning null data or not room Host");
            return;
         }
         var changedInfo:Object = {};
         if(cEvt.myPara.type == "map")
         {
            if(this._roomObj.currentMap.id == cEvt.myPara.data.id)
            {
               return;
            }
            mode = this._roomObj.currentMatchMode.id;
            changedInfo.map = cEvt.myPara.data.id;
            changedInfo.minPlayer = cEvt.myPara.data.minPlayer;
            if(mode != "combat")
            {
               changedInfo.maxPlayer = cEvt.myPara.data.maxPlayer;
            }
         }
         else if(cEvt.myPara.type == "mode")
         {
            if(this._roomObj.forces.showMode)
            {
               if(this._roomObj.currentMatchMode.id == cEvt.myPara.data)
               {
                  return;
               }
               changedInfo.mode = cEvt.myPara.data;
            }
         }
         CFunctionContainer.ChangeRoomInfo(changedInfo,cEvt.myPara.type);
      }
      
      private function onChangeRoomOptionsHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara == null || !this.isRoomHost())
         {
            Logger.print("LobbyController:::onChangeRoomOptions: warning null data or not room Host");
            return;
         }
         CFunctionContainer.ChangeRoomOptions(cEvt.myPara);
      }
      
      private function onRankedMatchStatusChangedHandle(cEvt:ParaEvent) : void
      {
         switch(cEvt.myPara.status)
         {
            case RankedMatchStatus.READY:
            case RankedMatchStatus.READY_IN_ROOM:
               this.setFinalVoting();
         }
      }
      
      private function onRefreshAvatarHandle(cEvt:ParaEvent) : void
      {
         Logger.print("LobbyController:::onRefreshAvatarHandle");
         this.refreshMyAvatar(this.me);
         this.broadcastAvatarRefreshInTeam();
      }
      
      private function onRefreshWeaponHandle(cEvt:ParaEvent) : void
      {
         Logger.print("LobbyController:::onRefreshWeaponHandle");
         this.refreshMyWeaponLoadout(true);
      }
      
      private function onRenewAvatarHandle(cEvt:ParaEvent) : void
      {
         this._isRenewingAvatar = 1;
      }
      
      private function onRenewWeaponHandle(cEvt:ParaEvent) : void
      {
         this._isRenewingAvatar = 2;
      }
      
      private function onInventoryChangeHandle(cEvt:ParaEvent) : void
      {
         Logger.print("LobbyController:::onInventoryChangeHandle _isRenewingAvatar: " + this._isRenewingAvatar);
         if(this._isRenewingAvatar == 1)
         {
            this._isRenewingAvatar = 0;
            this.refreshMyAvatar(this.me);
            broadcast(BCEvent.LOBBY_REFRESH_CHARACTER_SLOT);
         }
         else if(this._isRenewingAvatar == 2)
         {
            this._isRenewingAvatar = 0;
            this.refreshMyWeaponLoadout(true);
            broadcast(BCEvent.LOBBY_REFRESH_WEAPON);
         }
      }
      
      private function broadcastAvatarRefreshInTeam() : void
      {
         var faction:uint = 0;
         if(Boolean(getDP(DataID.IS_IN_ROOM)))
         {
            faction = Boolean(this.me) ? this.me.team : Common.LOADOUT_TYPE_TF;
            CFunctionContainer.AS_CheckAvatarRefreshInTeam(faction);
         }
      }
      
      private function onWeaponSlotClickedHandle(cEvt:ParaEvent) : void
      {
         this._currentSelectedWeaponSlot = cEvt.myPara.slot;
         this.refreshMyWeaponItems(this._currentSelectedWeaponSlot);
      }
      
      private function onWeaponLoadoutChangedHandle(cEvt:ParaEvent) : void
      {
         Logger.print("LobbyController:::onWeaponLoadoutChangedHandle");
         this.refreshMyWeaponLoadout(true);
      }
      
      private function setFinalVoting() : void
      {
         if(this._roomObj.forces == null)
         {
            return;
         }
         var playListObj:PlayListObj = this.getCurrentPlayList();
         if(playListObj != null && playListObj.combatTrainingType > 0)
         {
            return;
         }
         this._roomObj.forces.votes.enable = false;
         broadcast(BCEvent.REFRESH_MAP_VOTING,this._roomObj);
         if(this.isRoomHost())
         {
            CFunctionContainer.SetFinalVoting(this._roomObj.forces.votes.entry);
         }
      }
      
      private function isRoomInfoReady() : Boolean
      {
         return this._roomObj.name.length > 0 && this._roomMembers.length > 0;
      }
      
      private function setRoomInfo(obj:Object) : void
      {
         if(obj == null)
         {
            return;
         }
         if(this._roomObj.forces == null)
         {
            this._roomObj.forces = new RoomInfoObj();
            this._roomObj.forces.votes = new RoomVoteObj();
         }
         this.initCharacterList();
         this.initRoomInfo(obj);
         if(this._roomObj.name.length > 0)
         {
            this.refreshRoomMaps();
            this.refreshRoomStatus();
            setBindData(DataID.ROOM_INFO,this._roomObj);
            this.tryAutoSelectReady();
         }
      }
      
      private function setRoomMembers(members:Array) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         if(members == null)
         {
            return;
         }
         this.initRoomMembers(members);
         this.checkDLCMembers(members);
         if(Boolean(this._currentSelectedMember))
         {
            roomMemberObj = this.getRoomMemberObjByID(this._currentSelectedMember.id);
            this._currentSelectedMember = roomMemberObj;
         }
         this.validateCurrentSelectedMember();
         if(this.isRoomInfoReady())
         {
            this.refreshRoomStatus();
            setBindData(DataID.ROOM_INFO,this._roomObj);
            this.tryAutoSelectReady();
         }
      }
      
      private function tryAutoSelectReady() : void
      {
         if(!this._onceAutoSelected && this.isRoomInfoReady() && this._roomObj.isPlayList && this._roomObj.currentMatchMode.isDMZ)
         {
            broadcast(BCEvent.CHANGE_READY_STATE);
            this._onceAutoSelected = true;
         }
      }
      
      private function initRoomInfo(obj:Object) : void
      {
         this._roomObj.name = obj.name.length > 0 ? obj.name : " ";
         this._roomObj.index = obj.index;
         this._roomObj.password = obj.password;
         this._roomObj.isPlayList = obj.isPlayList;
         this._roomObj.matchType = obj.matchType;
         this._roomObj.currentLevel = obj.currentLevel;
         this._roomObj.options = RoomOptionObj(obj.options);
         this._roomObj.numItemBans = obj.numItemBans;
         this._roomObj.isWarGod = obj.isWarGod;
         this._roomObj.enableSpectator = obj.enableSpectator;
         this._roomObj.currentMatchMode.id = obj.currentMatchMode == null ? "" : obj.currentMatchMode.id || "";
         this._roomObj.currentMaxPlayers = obj.currentMaxPlayers;
         this._roomObj.maxSpectators = obj.maxSpectators;
         Logger.print("LobbyController::initRoomInfo dlcLevel" + obj.dlcLevel);
         this._roomObj.roomDLCLevel = obj.dlcLevel;
         this._roomObj.roomIsFullClient = obj.dlcLevel == CFunctionContainer.GetMaxDLCLevel();
         if(Boolean(obj.isPlayList))
         {
            this._roomObj.leagueID = obj.leagueID == null ? 0 : uint(obj.leagueID);
            this._roomObj.playListID = obj.playListID == null ? 0 : int(obj.playListID);
            this._roomObj.playListName = obj.playListName || "";
            this._roomObj.playListDescription = obj.playListDescription || "";
            this._roomObj.playListNextEntry = obj.playListNextEntry == null ? -1 : int(obj.playListNextEntry);
            this._roomObj.playListLastEntry = obj.playListLastEntry == null ? -1 : int(obj.playListLastEntry);
            this._roomObj.currentMatchMode.name = obj.currentMatchMode.name || "";
            this._roomObj.currentMatchMode.description = "";
            this._roomObj.currentMinPlayers = this._roomObj.currentMatchMode.id == "combat" ? 1 : uint(obj.currentMinPlayers);
         }
         else
         {
            this._roomObj.currentMap.name = obj.currentMap.name || "";
            this._roomObj.currentMap.id = obj.currentMap.id || "";
            this._roomObj.currentMap.description = obj.currentMap.description || "";
            this._roomObj.currentMap.imageURL = obj.currentMap.imageURL || "";
            this._roomObj.currentMap.sequence = obj.currentMap.sequence;
            this._roomObj.currentMatchMode.name = obj.currentMatchMode.name || "";
            this._roomObj.currentMatchMode.description = obj.currentMatchMode.description || "";
            this._roomObj.currentMinPlayers = 1;
         }
         broadcast(BCEvent.ROOM_INFO_ONLY,this._roomObj);
      }
      
      private function checkDLCMembers(members:Array) : void
      {
         var member:RoomMemberObj = null;
         var numMiniClientMember:int = 0;
         for each(member in members)
         {
            if(member.dlcLevel < CFunctionContainer.GetMaxDLCLevel())
            {
               numMiniClientMember++;
            }
         }
         if(!this._dlcWarningEverSent && this._numMiniClientMember != -1 && (this._numMiniClientMember == 0 && numMiniClientMember > 0))
         {
            showMsg(DictRoom.MINICLIENT_JOIN_ROOM,MsgBtnCount.ONE);
            this._dlcWarningEverSent = true;
         }
         this._numMiniClientMember = numMiniClientMember;
      }
      
      private function initRoomMembers(members:Array) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         var isNewRoomMember:Boolean = false;
         var member:RoomMemberObj = null;
         var oldRoomMember:* = undefined;
         var isRankedMatch:Boolean = CFunctionContainer.IsRankedMatch() as Boolean;
         var oldRoomMembers:Array = this._roomMembers.concat();
         this._roomMembers.splice(0);
         for each(member in members)
         {
            roomMemberObj = null;
            isNewRoomMember = false;
            for each(oldRoomMember in oldRoomMembers)
            {
               if(oldRoomMember.id == member.id)
               {
                  roomMemberObj = oldRoomMember;
                  this.refreshRoomMember(roomMemberObj,member);
                  break;
               }
            }
            if(roomMemberObj == null)
            {
               roomMemberObj = member;
               isNewRoomMember = true;
            }
            if(isRankedMatch)
            {
               roomMemberObj.isHost = false;
            }
            roomMemberObj.isOnline = true;
            roomMemberObj.isInMyParty = getDP(DataID.IS_IN_MY_PARTY,[roomMemberObj]);
            roomMemberObj.isMe = getDP(DataID.IS_ME,[roomMemberObj]);
            if(roomMemberObj.isMe && isNewRoomMember)
            {
               this.refreshMyAvatar(roomMemberObj);
               this.refreshCareerStats(roomMemberObj);
            }
            this.setMenuSelections(roomMemberObj);
            if(roomMemberObj.isMe && roomMemberObj.isHost)
            {
               EventManager.getInstance().broadcast(BCEvent.CHANGE_ROOM_OPTIONS,this._roomObj);
            }
            this._roomMembers.push(roomMemberObj);
         }
         this._roomObj.currentPlayers = this._roomMembers.length;
      }
      
      private function refreshRoomMaps() : void
      {
         var map:MapObj = null;
         var newUnlockedMap:String = null;
         var mode:String = null;
         var mapChanged:Boolean = false;
         var i:int = 0;
         var mapObj:MapObj = null;
         if(this._roomObj.isPlayList)
         {
            this._roomObj.forces.maps.splice(0);
            this._roomObj.forces.selectedMapIndex = 0;
            if(this._roomObj.forces.votes.votedMap != null)
            {
               this._roomObj.forces.maps.push(this._roomObj.forces.votes.votedMap);
            }
            else
            {
               map = this.getPlayListEntryMap(this._roomObj.playListID,this._roomObj.playListNextEntry);
               if(map != null)
               {
                  this._roomObj.forces.maps.push(map);
               }
            }
         }
         else
         {
            if(this.isRoomHost())
            {
               this._roomObj.forces.maps.splice(0);
               this._roomObj.forces.maps = getDP(DataID.LIST_MAP,["",this._roomObj.roomDLCLevel]);
               mode = this._roomObj.currentMatchMode.id;
               if(this._roomObj.currentMatchMode.id == ClashPvpUtil.MODE_ID)
               {
                  mode = ClashPvpUtil.getClashDetailedMode(this._roomObj.options.clashMode);
               }
               this._roomObj.forces.maps = this._roomObj.forces.maps.filter(function(item:*, index:int, array:Array):Boolean
               {
                  var mapObj:* = item as MapObj;
                  if(!item is MapObj || !item.hasOwnProperty("availableModes"))
                  {
                     return false;
                  }
                  var isMapMaxValid:* = mapObj.maxPlayer >= _roomObj.currentMaxPlayers;
                  if(!isMapMaxValid)
                  {
                     return false;
                  }
                  return (mode == "" || mapObj.availableModes.indexOf(mode) != -1) && mapObj.noCustomRoom == false;
               });
               if(!this._roomObj.currentMap.isHeroOps)
               {
                  mapChanged = true;
                  for(i = 0; i < this._roomObj.forces.maps.length; i++)
                  {
                     if(this._roomObj.currentMap.id == this._roomObj.forces.maps[i].id)
                     {
                        this._roomObj.forces.selectedMapIndex = i;
                        mapChanged = false;
                        break;
                     }
                  }
                  if(mapChanged)
                  {
                     this._roomObj.forces.selectedMapIndex = 0;
                     broadcast(BCEvent.CHANGE_ROOM_INFO,{
                        "type":"map",
                        "data":this._roomObj.forces.maps[this._roomObj.forces.selectedMapIndex]
                     });
                  }
               }
            }
            else
            {
               this._roomObj.forces.maps.splice(0);
               this._roomObj.forces.maps.push(getDP(DataID.MAP_OBJ,[this._roomObj.currentMap.id]));
               this._roomObj.forces.selectedMapIndex = 0;
            }
            newUnlockedMap = getDP(DataID.NEW_UNLOCKED_COOP_STORY_MAP);
            if(newUnlockedMap.length > 0 && newUnlockedMap != "coop_evasion_mp_con_spring" && this.isRoomHost())
            {
               mapObj = getDP(DataID.MAP_OBJ,[newUnlockedMap]);
               if(Boolean(mapObj))
               {
                  broadcast(BCEvent.CHANGE_ROOM_INFO,{
                     "type":"map",
                     "data":mapObj
                  });
               }
            }
         }
      }
      
      private function refreshRoomStatus() : void
      {
         var showBoth:Boolean = false;
         var j:int = 0;
         var mapCount:int = 0;
         var forceInfo:RoomInfoObj = this._roomObj.forces;
         if(!ScaleformUtil.isScaleform)
         {
            forceInfo.isHost = true;
         }
         var playListObj:PlayListObj = this.getCurrentPlayList();
         if(this._roomObj.isPlayList)
         {
            showBoth = playListObj != null && !PlayListType.isPveType(playListObj.type);
            if(playListObj.noTeamSplitting)
            {
               showBoth = false;
            }
            else if(playListObj.type == PlayListType.RANKED && playListObj.entries[0].gametype == "ffa")
            {
               showBoth = false;
            }
         }
         else
         {
            showBoth = !CFunctionCommonContainer.AS_IsFFALobbyGameType(this._roomObj.currentMatchMode.id) && !this._roomObj.IsPveMode();
         }
         Logger.print("LobbyController:::refreshRoomStatus showBoth: " + showBoth);
         var party:Boolean = !getDP(DataID.IS_IN_PARTY) || Boolean(getDP(DataID.IS_PARTY_HOST));
         forceInfo.force0.splice(0);
         forceInfo.force1.splice(0);
         forceInfo.force2.splice(0);
         if(showBoth && this._roomObj.isPlayList)
         {
            forceInfo.forceMaxPlayer = this._roomObj.currentMaxPlayers / 2;
         }
         else
         {
            forceInfo.forceMaxPlayer = Math.min(this._roomObj.currentMaxPlayers,FsgGameLobbyConsts.MAX_TEAMSIZE);
         }
         forceInfo.forceMaxSpectator = this._roomObj.maxSpectators;
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(Boolean(getDP(DataID.IS_ME,[this._roomMembers[i]])))
            {
               forceInfo.isInForce0 = this._roomMembers[i].team == FsgGameLobbyConsts.TEAM_141;
               forceInfo.isInForce1 = this._roomMembers[i].team == FsgGameLobbyConsts.TEAM_SCAR;
               forceInfo.isInForce2 = this._roomMembers[i].team == FsgGameLobbyConsts.TEAM_SPECTATOR;
               forceInfo.isHost = this.isRoomHost();
               forceInfo.isReady = this._roomMembers[i].isReady;
               if(forceInfo.isReady != this._confirmedReadyState)
               {
                  broadcast(BCEvent.CHANGE_READY_STATE);
               }
               forceInfo.showPilot = false;
               if(forceInfo.showPilot)
               {
                  if(forceInfo.pilots.length <= 0)
                  {
                     forceInfo.pilots = this.listAC130Type();
                     forceInfo.selectedPilotIndex = 0;
                  }
                  for(j = 0; j < forceInfo.pilots.length; j++)
                  {
                     if(forceInfo.pilots[j].id == this._roomMembers[i].pilot)
                     {
                        forceInfo.selectedPilotIndex = j;
                        break;
                     }
                  }
               }
               forceInfo.showMode = false;
               if(forceInfo.showMode)
               {
                  forceInfo.modes = getDP(DataID.LIST_MODE,[""]);
                  forceInfo.selectedModeIndex = 0;
                  for(j = 0; j < forceInfo.modes.length; j++)
                  {
                     if(forceInfo.modes[j].id == this._roomObj.currentMatchMode.id)
                     {
                        forceInfo.selectedModeIndex = j;
                        break;
                     }
                  }
               }
            }
            if(this._roomMembers[i].team == FsgGameLobbyConsts.TEAM_141)
            {
               forceInfo.force0.push(this._roomMembers[i]);
            }
            else if(this._roomMembers[i].team == FsgGameLobbyConsts.TEAM_SCAR)
            {
               forceInfo.force1.push(this._roomMembers[i]);
            }
            else if(this._roomMembers[i].team == FsgGameLobbyConsts.TEAM_SPECTATOR)
            {
               forceInfo.force2.push(this._roomMembers[i]);
            }
         }
         this.refreshRoomVoting();
         if(forceInfo.force0.length > 1)
         {
            forceInfo.force0.sortOn(["isHost","name"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         }
         if(forceInfo.force1.length > 1)
         {
            forceInfo.force1.sortOn(["isHost","name"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         }
         if(forceInfo.force2.length > 1)
         {
            forceInfo.force2.sortOn(["isHost","name"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         }
         forceInfo.showMapAlbum = !forceInfo.votes.show;
         Logger.print("LobbyController:::refreshRoomStatus forceInfo.showMapAlbum: " + forceInfo.showMapAlbum);
         var shouldShowChangeMapBtn:Boolean = !this._roomObj.isPlayList && forceInfo.isHost;
         if(forceInfo.showChangeMapBtn == false && shouldShowChangeMapBtn == true)
         {
            this.refreshRoomMaps();
            mapCount = int(this._roomObj.forces.maps.length);
            shouldShowChangeMapBtn &&= mapCount > 1;
         }
         forceInfo.showChangeMapBtn = shouldShowChangeMapBtn;
         forceInfo.enableChangeMapBtn = forceInfo.showChangeMapBtn && !forceInfo.isReady;
         if(!this._roomObj.isPlayList && Boolean(CFunctionCommonContainer.AS_IsFFALobbyGameType(this._roomObj.currentMatchMode.id)))
         {
            forceInfo.showForce0 = true;
            forceInfo.showForce1 = false;
         }
         else
         {
            forceInfo.showForce0 = forceInfo.force0.length > 0 || showBoth;
            forceInfo.showForce1 = forceInfo.force1.length > 0 || showBoth;
         }
         forceInfo.showAdvancedOptions = !this._roomObj.isPlayList;
         forceInfo.showChangeForceBtn = !this._roomObj.isPlayList;
         if(forceInfo.showChangeForceBtn && !forceInfo.isReady && party)
         {
            forceInfo.enableChangeForce0 = forceInfo.force0.length < forceInfo.forceMaxPlayer && !forceInfo.isInForce0;
            forceInfo.enableChangeForce1 = forceInfo.force1.length < forceInfo.forceMaxPlayer && !forceInfo.isInForce1;
            forceInfo.enableChangeForce2 = forceInfo.force2.length < forceInfo.forceMaxSpectator && !forceInfo.isInForce2;
         }
      }
      
      private function refreshRoomVoting(fromVote:Boolean = true) : void
      {
         if(this._roomObj.forces == null)
         {
            return;
         }
         if(!this._roomObj.isPlayList)
         {
            return;
         }
         var playListObj:PlayListObj = this.getCurrentPlayList();
         if(playListObj == null)
         {
            return;
         }
         var voteObj:RoomVoteObj = this._roomObj.forces.votes;
         if(voteObj == null || !fromVote && voteObj.show)
         {
            return;
         }
         this.resetRoomVoting();
         voteObj.show = playListObj.votingDisabled == 0 && playListObj.entries.length >= 2;
         Logger.print("LobbyController:::refreshRoomVoting voteObj.show: " + voteObj.show);
         if(!voteObj.show)
         {
            return;
         }
         var gameModeString:String = "";
         if(playListObj.modes.length > 1)
         {
            gameModeString = "@SF_UI_PLAYLIST_GAMEMODE_MIXED";
         }
         else
         {
            switch(playListObj.type)
            {
               case PlayListType.SURVIVAL:
                  gameModeString = Dict.MAIN_MENU_LABEL_QUICKMATCH_SURVIVAL;
                  break;
               default:
                  gameModeString = this._roomObj.currentMatchMode.name;
            }
         }
         voteObj.gameMode = gameModeString;
         voteObj.enable = !getDP(DataID.IS_RANKED_MATCH_READY);
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(this._roomMembers[i].vote == VoteMapType.NEXT)
            {
               ++voteObj.next;
            }
            else if(this._roomMembers[i].vote == VoteMapType.PREVIOUS)
            {
               ++voteObj.previous;
            }
            else if(this._roomMembers[i].vote == VoteMapType.RANDOM)
            {
               ++voteObj.random;
            }
         }
         if(voteObj.next >= voteObj.random && voteObj.next >= voteObj.previous)
         {
            voteObj.entry = this._roomObj.playListNextEntry;
         }
         else
         {
            voteObj.entry = voteObj.random > voteObj.previous ? -1 : this._roomObj.playListLastEntry;
         }
         Logger.print("LobbyController:::refreshRoomVoting entry: " + voteObj.entry);
         voteObj.nextMap = this.getPlayListEntryMap(this._roomObj.playListID,this._roomObj.playListNextEntry);
         if(voteObj.nextMap != null)
         {
            voteObj.nextMap.voted = false;
            Logger.print("LobbyController:::refreshRoomVoting next map: " + voteObj.nextMap.id);
         }
         voteObj.previousMap = this.getPlayListEntryMap(this._roomObj.playListID,this._roomObj.playListLastEntry);
         if(voteObj.previousMap != null)
         {
            voteObj.previousMap.voted = false;
            Logger.print("LobbyController:::refreshRoomVoting previous map: " + voteObj.previousMap.id);
            if(playListObj.entries.length == 2)
            {
               voteObj.showRandom = false;
            }
         }
         if(voteObj.randomMap == null)
         {
            voteObj.randomMap = new MapObj({"name":DictRoom.MAP_VOTING_RANDOM});
         }
         voteObj.randomMap.voted = false;
         if(voteObj.entry == this._roomObj.playListNextEntry && voteObj.nextMap != null)
         {
            voteObj.votedMap = voteObj.nextMap;
         }
         else if(voteObj.entry == this._roomObj.playListLastEntry && voteObj.previousMap != null)
         {
            voteObj.votedMap = voteObj.previousMap;
         }
         else
         {
            voteObj.votedMap = voteObj.randomMap;
         }
         Logger.print("LobbyController:::refreshRoomVoting vote map: " + voteObj.votedMap);
         if(voteObj.votedMap != null)
         {
            voteObj.votedMap.voted = true;
            this._roomObj.forces.maps.splice(0);
            this._roomObj.forces.maps.push(voteObj.votedMap);
            if(fromVote)
            {
               broadcast(BCEvent.REFRESH_MAP_VOTING,this._roomObj);
            }
         }
      }
      
      private function getPlayListEntryMap(playListID:int, idxEntry:int) : MapObj
      {
         var playListObj:PlayListObj = this.getCurrentPlayList();
         if(playListObj == null)
         {
            return null;
         }
         if(idxEntry >= 0 && idxEntry < playListObj.entries.length)
         {
            return getDP(DataID.MAP_OBJ,[playListObj.entries[idxEntry].map]);
         }
         return null;
      }
      
      private function getCurrentPlayList() : PlayListObj
      {
         return getDP(DataID.PLAY_LIST_OBJ,[this._roomObj.playListID]);
      }
      
      private function resetRoom() : void
      {
         this._numMiniClientMember = -1;
         this._roomObj.name = "";
         this._roomObj.index = 0;
         this._roomObj.currentMap.id = "";
         this._roomObj.currentMatchMode.id = "";
         if(this._roomObj.forces != null)
         {
            this._roomObj.forces.maps.splice(0);
            this._roomObj.forces.pilots.splice(0);
            this.resetRoomVoting();
         }
      }
      
      private function resetRoomVoting() : void
      {
         if(this._roomObj.forces != null)
         {
            this._roomObj.forces.votes.show = false;
            this._roomObj.forces.votes.enable = false;
            this._roomObj.forces.votes.showRandom = true;
            this._roomObj.forces.votes.next = 0;
            this._roomObj.forces.votes.previous = 0;
            this._roomObj.forces.votes.random = 0;
            this._roomObj.forces.votes.entry = 0;
            this._roomObj.forces.votes.previousMap = null;
            this._roomObj.forces.votes.nextMap = null;
            this._roomObj.forces.votes.votedMap = null;
            this._roomObj.forces.votes.gameMode = "";
         }
      }
      
      private function get me() : RoomMemberObj
      {
         for(var i:int = 0; i < this._roomMembers.length; i++)
         {
            if(Boolean(this._roomMembers[i].isMe))
            {
               return this._roomMembers[i];
            }
         }
         return null;
      }
      
      private function refreshRoomMember(dest:RoomMemberObj, src:Object) : void
      {
         dest.name = src.name;
         dest.team = src.team;
         dest.vote = src.vote;
         dest.pilot = src.pilot;
         dest.isReady = src.isReady;
         dest.isHost = src.isHost;
      }
      
      private function filterOnTeam(dp:Array, faction:int) : void
      {
         if(null == dp)
         {
            return;
         }
         for(var i:int = dp.length - 1; i >= 0; i--)
         {
            switch(faction)
            {
               case 0:
                  if(dp[i].enableInTF141 == false)
                  {
                     dp.splice(i,1);
                  }
                  break;
               case 1:
                  if(dp[i].enableInSC == false)
                  {
                     dp.splice(i,1);
                  }
            }
         }
      }
      
      private function refreshMyAvatar(roomMemberObj:RoomMemberObj) : void
      {
         var i:int = 0;
         var characterID:int = 0;
         var prop:String = null;
         var slotObj:Object = null;
         var slotName:String = null;
         if(roomMemberObj == null || !roomMemberObj.isMe)
         {
            return;
         }
         var iCharacterID:int = CFunctionContainer.CL_GetCurrentCharacterID();
         if(Boolean(this._characterList))
         {
            for(i = 0; i < this._characterList.length; i++)
            {
               if(this._characterList[i].id == iCharacterID)
               {
                  this._currentCharacterIdx = i;
                  break;
               }
            }
         }
         roomMemberObj.avatarItemSlots = CharacterLoadoutService.getInstance().getActiveCharacterLoadout();
         roomMemberObj.avatarInventoryItems = {};
         if(Boolean(roomMemberObj.avatarItemSlots) && Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
         {
            characterID = roomMemberObj.avatarItemSlots.chaSlot == null ? 0 : int(roomMemberObj.avatarItemSlots.chaSlot.item_id);
            roomMemberObj.isCustomizable = false;
            for(prop in roomMemberObj.avatarItemSlots)
            {
               slotObj = roomMemberObj.avatarItemSlots[prop];
               slotName = slotObj.hasOwnProperty("nameid") ? slotObj.nameid : "";
               if(slotName.length > 0)
               {
                  roomMemberObj.avatarInventoryItems[slotName] = MarketService.getInstance().GetProductList(slotName,Common.LIST_TYPE_INVENTORY);
                  this.filterOnTeam(roomMemberObj.avatarInventoryItems[slotName],roomMemberObj.team);
               }
            }
         }
      }
      
      private function refreshMyWeaponLoadout(checkChanged:Boolean = false) : void
      {
         Logger.print("LobbyController:::refreshMyWeaponLoadout");
         var roomMemberObj:RoomMemberObj = this.me;
         if(roomMemberObj == null)
         {
            return;
         }
         roomMemberObj.weaponloadObj = WeaponLoadoutService.getInstance().getCurrentWeaponLoadout();
         this.refreshMyWeaponItems(this._currentSelectedWeaponSlot);
         if(checkChanged)
         {
            this.broadcastAvatarRefreshInTeam();
         }
      }
      
      private function refreshMyWeaponItems(weaponSlot:Object) : void
      {
         var category:String = null;
         var values:Array = null;
         if(weaponSlot == null)
         {
            return;
         }
         var roomMemberObj:RoomMemberObj = this.me;
         if(roomMemberObj != null)
         {
            category = weaponSlot.nameid;
            if(category.length <= 0)
            {
               return;
            }
            values = category.split("_");
            if(values[1] == "primary")
            {
               WeaponLoadoutService.getInstance().currentWeaponID = roomMemberObj.weaponloadObj.primaryWeapSlot.item_id;
            }
            else if(values[1] == "secondary")
            {
               WeaponLoadoutService.getInstance().currentWeaponID = roomMemberObj.weaponloadObj.secondaryWeapSlot.item_id;
            }
            roomMemberObj.weaponInventoryItems = MarketService.getInstance().getItemListByCategory(values[0],Common.LIST_TYPE_INVENTORY);
            if(roomMemberObj.weaponInventoryItems == null)
            {
               roomMemberObj.weaponInventoryItems = [];
            }
            roomMemberObj.weaponInventoryItems.sortOn(["equippable","equipLevel","requirementLevel","name"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC,Array.CASEINSENSITIVE]);
         }
      }
      
      private function refreshCareerStats(roomMemberObj:RoomMemberObj, select:Boolean = false) : void
      {
         if(roomMemberObj == null)
         {
            return;
         }
         if(roomMemberObj.isMe)
         {
            if(roomMemberObj.careerStats == null)
            {
               roomMemberObj.careerStats = getDP(DataID.CAREER_STATS);
               if(!this._isCareerStatsSet)
               {
                  this._isCareerStatsSet = true;
                  CFunctionContainer.SetStatsForRoom(roomMemberObj.careerStats);
               }
            }
         }
         else if(select && roomMemberObj.careerStats == null)
         {
            CFunctionContainer.QueryRoomTeammateStats(roomMemberObj.id);
         }
      }
      
      private function refreshLobbyCharacter(roomMemberObj:RoomMemberObj) : void
      {
         if(roomMemberObj != null)
         {
            setBindData(DataID.LOBBY_CHARACTER_DATA,roomMemberObj);
         }
      }
      
      private function dispatchCareerStats(roomMemberObj:RoomMemberObj) : void
      {
         if(roomMemberObj != null)
         {
            broadcast(BCEvent.LOBBY_SET_CHARACTER_STATS,roomMemberObj);
         }
      }
      
      private function setMenuSelections(roomMemberObj:RoomMemberObj) : void
      {
         if(roomMemberObj == null)
         {
            return;
         }
         var isFriend:Boolean = getDP(DataID.IS_FRIEND,[roomMemberObj]);
         roomMemberObj.menuSelections.splice(0);
         if(!this.isBootCampPlayList())
         {
            if(roomMemberObj.isMe ? Boolean(getDP(DataID.IS_NOTIFIED,[UINotifications.WEAPON_CUSTOMIZATION])) : true)
            {
               roomMemberObj.menuSelections.push({
                  "label":DictRoom.LOBBY_CHARACTER_MENU_WEAPON_LOADOUT,
                  "enable":true,
                  "needStandBy":false,
                  "action":LobbyAction.ACTION_WEAPON_LOADOUT,
                  "reserve":{}
               });
            }
            if(roomMemberObj.isMe ? Boolean(getDP(DataID.IS_NOTIFIED,[UINotifications.AVATAR_CUSTOMIZATION])) : true)
            {
               roomMemberObj.menuSelections.push({
                  "label":DictRoom.LOBBY_CHARACTER_OUTFIT,
                  "enable":true,
                  "needStandBy":false,
                  "action":LobbyAction.ACTION_CHARACTER_OUTFIT,
                  "reserve":{}
               });
            }
         }
         roomMemberObj.menuSelections.push({
            "label":DictRoom.LOBBY_CHARACTER_PLAYER_STATS,
            "enable":true,
            "needStandBy":false,
            "action":LobbyAction.ACTION_PLAYER_STATS,
            "reserve":{}
         });
         roomMemberObj.menuSelections.push({
            "label":DictRoom.LOBBY_CHARACTER_ADD_FRIEND,
            "enable":!roomMemberObj.isMe && !isFriend,
            "needStandBy":true,
            "action":LobbyAction.ACTION_ADD_FRIEND,
            "reserve":roomMemberObj
         });
         roomMemberObj.menuSelections.push({
            "label":DictRoom.LOBBY_CHARACTER_SEND_MESSAGE,
            "enable":!roomMemberObj.isMe,
            "needStandBy":false,
            "action":LobbyAction.ACTION_SEND_MESSAGE,
            "reserve":roomMemberObj
         });
      }
      
      private function isBaseView(container:DisplayObjectContainer) : Boolean
      {
         return container is BaseView || container is BaseSubElement;
      }
      
      private function hasBaseView(container:DisplayObjectContainer) : Boolean
      {
         return this.isBaseView(container) || this.hasClass(container,BaseView,BaseSubElement);
      }
      
      private function hasUIComponent(container:DisplayObjectContainer) : Boolean
      {
         return this.hasClass(container,UIComponent);
      }
      
      private function hasClass(container:DisplayObjectContainer, class1:Class, class2:Class = null) : Boolean
      {
         var i:int = 0;
         var child:DisplayObject = null;
         var found:Boolean = false;
         if(container != null)
         {
            i = 0;
            while(i < container.numChildren)
            {
               child = container.getChildAt(i++);
               if(class1 != null && child is class1 || class2 != null && child is class2)
               {
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               i = 0;
               while(i < container.numChildren)
               {
                  child = container.getChildAt(i++);
                  if(child is DisplayObjectContainer)
                  {
                     found = this.hasClass(child as DisplayObjectContainer,class1,class2);
                     if(found)
                     {
                        break;
                     }
                  }
               }
            }
         }
         return found;
      }
      
      private function hasDisplayObjectContainer(container:DisplayObjectContainer) : Boolean
      {
         var child:DisplayObject = null;
         var i:int = 0;
         var found:Boolean = false;
         if(container != null)
         {
            i = 0;
            while(i < container.numChildren)
            {
               child = container.getChildAt(i++);
               if(child is DisplayObjectContainer)
               {
                  found = true;
                  break;
               }
            }
         }
         return found;
      }
      
      private function addGlowFilterTimer(container:*, child:* = null) : void
      {
         if(container == null && child == null)
         {
            return;
         }
         for(var i:int = 0; i < this._glowFilterTimers.length; i++)
         {
            if(this._glowFilterTimers[i].container == container && this._glowFilterTimers[i].child == child)
            {
               this._glowFilterTimers[i].timer.reset();
               this._glowFilterTimers[i].timer.start();
               return;
            }
         }
         var containerFilters:Array = Boolean(container) && Boolean(container.filters) ? container.filters : [];
         var containerHasFilter:Boolean = containerFilters.length > 0;
         containerFilters.push(this._parentGlowFilter);
         if(Boolean(container))
         {
            container.filters = containerFilters;
         }
         var childFilters:Array = Boolean(child) && Boolean(child.filters) ? child.filters : [];
         var childHasFilter:Boolean = childFilters.length > 0;
         childFilters.push(this._childGlowFilter);
         if(Boolean(child))
         {
            child.filters = childFilters;
         }
         var timer:Timer = new Timer(500,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onGlowFilterTimerComplete);
         timer.start();
         this._glowFilterTimers.push({
            "container":container,
            "containerHasFilter":containerHasFilter,
            "child":child,
            "childHasFilter":childHasFilter,
            "timer":timer
         });
      }
      
      private function onGlowFilterTimerComplete(event:TimerEvent) : void
      {
         var j:int = 0;
         var filters:Array = null;
         var glowFilterTimer:Object = null;
         for(var i:int = this._glowFilterTimers.length - 1; i >= 0; i--)
         {
            if(this._glowFilterTimers[i].timer == event.target)
            {
               glowFilterTimer = this._glowFilterTimers[i];
               if(Boolean(glowFilterTimer.container))
               {
                  if(Boolean(glowFilterTimer.containerHasFilter))
                  {
                     filters = glowFilterTimer.container.filters;
                     for(j = filters.length - 1; j >= 0; j--)
                     {
                        if(filters[j] == this._parentGlowFilter)
                        {
                           filters.splice(j,1);
                           glowFilterTimer.container.filters = filters;
                           break;
                        }
                     }
                  }
                  else
                  {
                     glowFilterTimer.container.filters = null;
                  }
               }
               if(Boolean(glowFilterTimer.child))
               {
                  if(Boolean(glowFilterTimer.childHasFilter))
                  {
                     filters = glowFilterTimer.child.filters;
                     for(j = filters.length - 1; j >= 0; j--)
                     {
                        if(filters[j] == this._childGlowFilter)
                        {
                           filters.splice(j,1);
                           glowFilterTimer.child.filters = filters;
                           break;
                        }
                     }
                  }
                  else
                  {
                     glowFilterTimer.child.filters = null;
                  }
               }
               this._glowFilterTimers.splice(i,1);
               break;
            }
         }
      }
      
      private function onTrySelectMember(evt:ParaEvent) : void
      {
         var id:String = evt.myPara as String;
         CFunctionContainer.SelectTeamMemberItemInPanel(id);
      }
   }
}

