package codo.component.matchselect
{
   import codo.base.BaseView;
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.ComboBox;
   import codo.component.IconButton;
   import codo.component.ScrollGrid;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.ViewPanelBase;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.CombatType;
   import codo.constants.DataID;
   import codo.constants.GlobalBottomBtnStatus;
   import codo.constants.MsgBtnCount;
   import codo.constants.QuickMatchType;
   import codo.constants.RoomMatchType;
   import codo.constants.SanitizedType;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppView;
   import codo.cpp.UiCppViewPanel;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.MapObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.objects.QuickMatchFilterObj;
   import codo.objects.ScrollListSettings;
   import codo.services.TutorialService;
   import codo.style.MatchSelectGuide;
   import codo.utils.Logger;
   import codo.utils.MathUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import codo.utils.TLogUtil;
   import com.society.comscore.DAXDispatcher;
   import components.fsggamelobby_part.FsgGameLobbyConsts;
   import components.matchselect_part.MatchSelectRoomScrollGrid;
   import flash.display.MovieClip;
   
   public class MatchSelectCustomizeRoom extends ViewPanelBase
   {
      
      private static const MAX_CLICK_TIME_THRESOLD:int = 2000;
      
      private static const MAX_CLICK_THRESOLD:int = 3;
      
      public var myGameTypeBG:MovieClip;
      
      public var myGameTypeHeader:TextField;
      
      public var myHeader:MovieClip;
      
      public var myCustomHeader:MovieClip;
      
      public var myCreateModeList:ScrollGrid;
      
      public var myFindModeList:ScrollList;
      
      public var myMiddleList:MatchSelectRoomScrollGrid;
      
      public var myModeInfo:MatchSelectModeInfo2;
      
      public var myNoRoomModeInfo:MovieClip;
      
      public var myConfirmButton:CallToActionButton;
      
      public var mySpectatorButton:Button;
      
      public var myGameTypeScrollList:ScrollList;
      
      public var myCreateOptions:MatchSelectCreateMatchOptions;
      
      public var myRefreshBtn:IconButton;
      
      public var myFindRoomBottomBG:MovieClip;
      
      protected var _timeStamp:int;
      
      public var pvpTypeList:ScrollList;
      
      protected var _clickCounter:int = 0;
      
      public function MatchSelectCustomizeRoom()
      {
         super();
         this.initStage();
         if(!ScaleformUtil.isScaleform)
         {
            visible = true;
            alpha = 1;
         }
      }
      
      protected function initStage() : void
      {
         var noInfoTF:TextField = null;
         this.myRefreshBtn.setIconPadding(11);
         this.myRefreshBtn.swapIconAlignment(true);
         this.myRefreshBtn.label = Dict.REFRESH;
         this.myRefreshBtn.setImage("refresh_icon");
         this.myRefreshBtn.registerClickEvent(this.onForceRefreshBtnClicked);
         this.myRefreshBtn.setMarketReadyMode(true);
         this.myRefreshBtn.x = this.myFindRoomBottomBG.x + this.myFindRoomBottomBG.width - this.myRefreshBtn.width - 11;
         this.myRefreshBtn.y = 916;
         this.myConfirmButton.registerClickEvent(this.onStartMatch);
         this.myConfirmButton.width = 280;
         this.myConfirmButton.height = 60;
         this.myConfirmButton.x = 1792 - this.myConfirmButton.width;
         this.myConfirmButton.y = 885;
         this.myConfirmButton.label = DictRoom.JOIN;
         this.myConfirmButton.myLabel.fontSize = 28;
         this.mySpectatorButton.width = 280;
         this.mySpectatorButton.height = 60;
         this.mySpectatorButton.x = this.myConfirmButton.x - this.mySpectatorButton.width - 6;
         this.mySpectatorButton.y = 885;
         this.mySpectatorButton.label = DictRoom.SPECTATOR_TEAM_START;
         this.mySpectatorButton.registerClickEvent(this.onClickJoinRoomAsSpectator);
         this.mySpectatorButton.myLabel.fontSize = 28;
         this.myGameTypeHeader.textStyle = MatchSelectGuide.styleHeader;
         this.myGameTypeHeader.width = 250;
         this.myGameTypeHeader.height = 32;
         this.myGameTypeHeader.x = 131;
         this.myGameTypeHeader.y = 213;
         this.myGameTypeHeader.text = Dict.MATCH_SELECT_MENU_OPTION_ROOMS;
         this.myGameTypeBG.myBackground.width = 787;
         this.myCustomHeader.myModeName.textStyle = MatchSelectGuide.styleCustomHeader;
         this.myCustomHeader.myModeName.text = DictRoom.LIST_LABEL_MODE;
         this.myCustomHeader.myModeName.alpha = 0.5;
         this.myCustomHeader.myRoomName.textStyle = MatchSelectGuide.styleCustomHeader;
         this.myCustomHeader.myRoomName.text = DictRoom.ROOM_NAME;
         this.myCustomHeader.myRoomName.alpha = 0.5;
         this.myCustomHeader.myNumPlayer.textStyle = MatchSelectGuide.styleCustomHeader;
         this.myCustomHeader.myNumPlayer.text = DictRoom.ROOM_PLAYERS;
         this.myCustomHeader.myNumPlayer.alpha = 0.5;
         this.myNoRoomModeInfo.myFrame.width = 906;
         this.myNoRoomModeInfo.myFrame.height = 696;
         noInfoTF = this.myNoRoomModeInfo.myNoRoomText;
         noInfoTF.textStyle = MatchSelectGuide.styleNoRoomModeInfo;
         noInfoTF.width = 906;
         noInfoTF.height = 30;
         noInfoTF.x = 0;
         noInfoTF.y = 233;
         noInfoTF.text = DictRoom.NOTE_NO_ROOM_FOUND;
         var typeScrollListSetting:ScrollListSettings = new ScrollListSettings();
         typeScrollListSetting.useNavArrows = false;
         typeScrollListSetting.itemLinkage = "codo.matchselect.roomFilterButton";
         this.myGameTypeScrollList.settings = typeScrollListSetting;
         this.pvpTypeList = this.myGameTypeScrollList;
         var createListSetting:ScrollListSettings = new ScrollListSettings();
         createListSetting.useNavArrows = false;
         createListSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         createListSetting.itemLinkage = "codo.shared.matchselect.matchSelectModeOption";
         createListSetting.barOffsetX = 8;
         this.myCreateModeList.initGrid(createListSetting,600,true,2);
         var roomModeListSetting:ScrollListSettings = new ScrollListSettings();
         roomModeListSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         roomModeListSetting.useNavArrows = false;
         roomModeListSetting.autoSize = false;
         roomModeListSetting.buildGridItemRenderMethod = ButtonFactory.BUILD_MATCH_SELECT_MODE_OPTION;
         roomModeListSetting.itemPadding = 6;
         this.myFindModeList.settings = roomModeListSetting;
         this.myFindModeList.width = 382;
         this.myFindModeList.height = 531;
         var roomListSetting:ScrollListSettings = new ScrollListSettings();
         roomListSetting.useNavArrows = false;
         roomListSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         roomListSetting.itemLinkage = "codo.matchselect.roomItem";
         roomListSetting.barOffsetX = 5;
         roomListSetting.itemPadding = 6;
         this.myMiddleList.initGrid(roomListSetting,531,true,1);
         this.myMiddleList.listItemDoubleClickCallback = this.onStartMatch;
         this.myCreateOptions.myRoomName.width = MatchSelectCreateMatchOptions.TEXT_WIDTH;
         this.myCreateOptions.myRoomName.maxLength = StringUtil.getMaxEnglishNameCharacterCount();
         this.myCreateOptions.myRoomPassword.width = MatchSelectCreateMatchOptions.TEXT_WIDTH;
         this.myCreateOptions.myRoomPassword.maxLength = MatchSelectCreateMatchOptions.LIMIT_PASSWORD;
         this.myCreateOptions.myPlayerLimit.label = DictRoom.GAME_OPTION_MAX_PLAYER;
         this.myCreateOptions.myPlayerLimit.showSelectionInHeader = true;
         this.myCreateOptions.myPlayerLimit.addEventListener(ComboBox.EVT_CHANGE,this.onCBMaxPlayersChanged);
         this.myModeInfo.myPlayListLimit.visible = false;
         EventManager.getInstance().listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onRoomNameSanitizedHandle);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DataManager.getInstance().addDP(DataID.MATCH_MPCT_ROOMCREATOR_PARAMS,this.getRoomCreatorParams);
         this.myCreateOptions.myRoomName.text = String(DataManager.getInstance().getDP(DataID.DEFAULT_ROOM_NAME));
         this.myCreateOptions.myRoomPassword.text = "";
         this.myCreateOptions.myRoomName.myTextClip.setSelection(0,0);
         DAXDispatcher.setGameVariant("mp");
         var matchType:QuickMatchType = QuickMatchType.makeRoom();
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,matchType);
         DataManager.getInstance().addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         DataManager.getInstance().addDP(DataID.MATCH_ROOMLIST_SELECTED_ROOM,this.getSelectedRoom);
         this.switchRoomMode(UiCppMatchSelectView.ROOM_TYPE_FIND);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().removeDP(DataID.MATCH_MPCT_ROOMCREATOR_PARAMS,this.getRoomCreatorParams);
         DataManager.getInstance().removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
      }
      
      private function getRoomCreatorParams() : Object
      {
         var filter:QuickMatchFilterObj = null;
         var room:Object = null;
         var mode:String = this.getCreateModeId();
         var params:Array = ["",DataManager.getInstance().getDP(DataID.CURRENT_PLAYER_DLC_LEVEL)];
         var maplist:Array = DataManager.getInstance().getDP(DataID.LIST_MAP,params);
         maplist = this.filterMapsByMode(maplist,mode);
         var selectedMap:Object = maplist.length > 0 ? maplist[Math.random() * maplist.length] : null;
         var map:String = Boolean(selectedMap) ? selectedMap.id : "";
         var minPlayer:int = Boolean(selectedMap) ? int(selectedMap.minPlayer) : 0;
         var maxPlayer:int = this.myCreateOptions.getPlayerLimit();
         if(mode == "combat")
         {
            filter = new QuickMatchFilterObj();
            filter.type = RoomMatchType.MP;
            filter.mode = mode;
            filter.league = 0;
            filter.map = map;
            filter.minPlayer = minPlayer;
            filter.maxPlayer = CombatType.getMaxPlayerFromLeague(filter.league);
            return {
               "type":QuickMatchType.makeRoom(),
               "room":filter
            };
         }
         room = {};
         room.name = this.myCreateOptions.getRoomName();
         room.password = this.myCreateOptions.getRoomPassword();
         room.map = map;
         room.mode = mode;
         room.minPlayer = minPlayer;
         room.maxPlayer = maxPlayer;
         return {
            "type":QuickMatchType.makeRoom(),
            "room":room
         };
      }
      
      private function getCreateModeId() : String
      {
         var mode:ModeObj = this.getSelectedCreateMode();
         return mode != null ? mode.id : "";
      }
      
      private function getFindModeId() : String
      {
         var mode:ModeObj = this.getSelectedFindMode();
         return mode != null ? mode.id : "";
      }
      
      public function getSelectedCreateMode() : ModeObj
      {
         return this.myCreateModeList.selectedData as ModeObj;
      }
      
      public function getSelectedFindMode() : ModeObj
      {
         return this.myFindModeList.selectedData as ModeObj;
      }
      
      private function filterMapsByMode(maps:Array, mode:String) : Array
      {
         return maps.filter(function(item:MapObj, index:int, array:Array):Boolean
         {
            return (mode == "" || item.availableModes.indexOf(mode) != -1) && item.noCustomRoom == false;
         });
      }
      
      public function enableRefreshBtn(value:Boolean) : void
      {
         this.myRefreshBtn.enabled = value;
      }
      
      public function onRoomsListed(finished:Boolean) : void
      {
         this.enableRefreshBtn(true);
      }
      
      public function onModeSelect() : void
      {
         this.switchRoomMode(this.myGameTypeScrollList.selectedIndex);
      }
      
      public function onMatchDisplay(mode:uint, match:uint, isSelection:Boolean) : void
      {
         this.myConfirmButton.visible = false;
         this.mySpectatorButton.visible = false;
         this.myNoRoomModeInfo.visible = true;
         this.myModeInfo.visible = false;
         this.myModeInfo.resetInfo();
         var curType:uint = this.pvpTypeList.selectedIndex;
         if(curType == UiCppMatchSelectView.ROOM_TYPE_FIND)
         {
            this.showRoomInfo(mode,match,isSelection);
            this.myConfirmButton.label = DictRoom.FORCE_TEAM_START;
         }
         else if(curType == UiCppMatchSelectView.ROOM_TYPE_CREATE)
         {
            this.refreshCreateOptions(mode,isSelection);
            this.myConfirmButton.label = DictRoom.CREATE;
         }
      }
      
      public function getSelectedPlaylist() : PlayListObj
      {
         return this.myMiddleList.selectedData as PlayListObj;
      }
      
      public function getSelectedRoom() : Object
      {
         return this.myMiddleList.selectedData;
      }
      
      private function switchRoomMode(modeIndex:int) : void
      {
         var bottomStartStatus:uint = 0;
         var tlogBtn:int = 0;
         if(modeIndex == UiCppMatchSelectView.ROOM_TYPE_FIND)
         {
            this.myCustomHeader.myNumPlayer.visible = true;
            this.myCustomHeader.myRoomName.visible = true;
            this.myFindRoomBottomBG.visible = true;
            this.myRefreshBtn.visible = true;
            this.myFindModeList.visible = true;
            this.myMiddleList.visible = true;
            this.myCreateModeList.visible = false;
            this.myCreateOptions.visible = false;
            bottomStartStatus = GlobalBottomBtnStatus.STATUS_IDLE_MP_ROOM_JOIN;
            tlogBtn = int(ButtonTLog.BUTTON_GAMEMODE_FIND_ROOM_MENU);
         }
         else
         {
            this.myCustomHeader.myNumPlayer.visible = false;
            this.myCustomHeader.myRoomName.visible = false;
            this.myFindRoomBottomBG.visible = false;
            this.myRefreshBtn.visible = false;
            this.myFindModeList.visible = false;
            this.myMiddleList.visible = false;
            this.myCreateModeList.visible = true;
            this.myCreateOptions.visible = true;
            bottomStartStatus = GlobalBottomBtnStatus.STATUS_IDLE_MP_ROOM_CREATOR;
            tlogBtn = int(ButtonTLog.BUTTON_GAMEMODE_CREATE_ROOM_MENU);
         }
         TLogUtil.TLog_UserInput(tlogBtn);
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_BOTTOM_START_STATUS,bottomStartStatus);
      }
      
      private function onCBMaxPlayersChanged(e:ParaEvent) : void
      {
         var modeObj:Object = this.getSelectedCreateMode();
         if(modeObj == null)
         {
            return;
         }
         var numPlayers:int = this.myCreateOptions.getPlayerLimit();
         this.myModeInfo.setPlayerLimit(this.playerRangeString(modeObj.minPlayers,numPlayers));
         this.myCreateOptions.showHideMaxPlayerWarning(numPlayers > MatchSelectCreateMatchOptions.DEFAULT_MAP_PLAYER_LIMIT);
      }
      
      private function refreshCreateOptions(mode:uint, isSelection:Boolean) : void
      {
         var modeID:String;
         var numXPRate:Number;
         var numGPRate:Number;
         var maxPlayers:uint;
         var modeStr:String;
         var params:Array;
         var maplist:Array;
         var modeObj:ModeObj = null;
         if(mode < this.myCreateModeList.listData.length)
         {
            modeObj = this.myCreateModeList.listData[mode] as ModeObj;
         }
         if(modeObj == null)
         {
            return;
         }
         this.myNoRoomModeInfo.visible = false;
         this.myModeInfo.visible = true;
         this.myModeInfo.showNoLevelProgressWarning(true);
         this.myConfirmButton.visible = true;
         modeID = this.getCreateModeId();
         if(modeID == "combat")
         {
            this.myCreateOptions.myRoomName.visible = false;
            this.myCreateOptions.myRoomPassword.text = "";
            this.myCreateOptions.myPlayerLimit.visible = false;
         }
         else
         {
            this.myCreateOptions.myRoomName.visible = true;
            this.myCreateOptions.myRoomPassword.visible = true;
            this.myCreateOptions.myPlayerLimit.visible = true;
         }
         this.myModeInfo.setModeName(Dict.MATCH_SELECT_MENU_OPTION_ROOMS);
         this.myModeInfo.setGameName(modeObj.name);
         this.myModeInfo.setModeDescription(modeObj.description);
         numXPRate = 10;
         numGPRate = 10;
         this.myModeInfo.setXPandGPRate(numXPRate,numGPRate);
         if(isSelection)
         {
            this.refreshMaxPlayers();
            try
            {
               Logger.print("*** DAXDispatcher: game_mode=" + modeID);
               if(DAXDispatcher.CURRENT_GAME_MODE != null)
               {
                  DAXDispatcher.queue("game_mode",DAXDispatcher.CURRENT_GAME_MODE);
               }
            }
            catch(e:Error)
            {
               Logger.print("*** DAXDispatcher: " + e.message);
            }
         }
         maxPlayers = modeObj.maxPlayers;
         if(mode == this.myCreateModeList.selectedIndex)
         {
            maxPlayers = uint(this.myCreateOptions.getPlayerLimit());
         }
         this.myModeInfo.setPlayerLimit(this.playerRangeString(modeObj.minPlayers,maxPlayers));
         modeStr = this.getCreateModeId();
         params = ["",DataManager.getInstance().getDP(DataID.CURRENT_PLAYER_DLC_LEVEL)];
         maplist = DataManager.getInstance().getDP(DataID.LIST_MAP,params);
         maplist = this.filterMapsByMode(maplist,modeStr);
         this.myModeInfo.setMaps(maplist,TutorialService.getInstance().getContentByGameType(modeStr));
      }
      
      private function onRoomNameSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type == SanitizedType.ROOM_NAME && Boolean(cEvt.myPara.sanitized))
         {
            this.myCreateOptions.myRoomName.text = cEvt.myPara.content;
            if(this.myGameTypeScrollList.selectedIndex == UiCppMatchSelectView.ROOM_TYPE_CREATE)
            {
               BaseView.staticShowMsg(DictRoom.NOTE_SANITIZED_ROOM_NAME,MsgBtnCount.ONE);
            }
         }
      }
      
      private function refreshMaxPlayers() : void
      {
         var index:int = 0;
         var modeObj:ModeObj = this.getSelectedCreateMode();
         var currMaxPlayersForMode:int = int(modeObj.maxPlayers);
         var isEsportSpectator:Boolean = DataManager.getInstance().getDP(DataID.IS_ESPORT_SPECTATOR);
         if(isEsportSpectator)
         {
            currMaxPlayersForMode = 18;
         }
         var maxPlayers:Array = DataManager.getInstance().getDP(DataID.LIST_MAX_PLAYER,[false,currMaxPlayersForMode,modeObj.minPlayers]);
         var defaultPlayers:int = int(modeObj.defaultPlayers);
         if(maxPlayers != null && maxPlayers.length > 0)
         {
            this.myCreateOptions.myPlayerLimit.dataProvider = maxPlayers;
            this.myCreateOptions.myPlayerLimit.selectedIndex = 0;
            for(index = 0; index < maxPlayers.length; index++)
            {
               if(maxPlayers[index].id >= defaultPlayers)
               {
                  if(maxPlayers[index].id == defaultPlayers)
                  {
                     this.myCreateOptions.myPlayerLimit.selectedIndex = index;
                  }
                  break;
               }
               this.myCreateOptions.myPlayerLimit.selectedIndex = index;
            }
         }
      }
      
      private function showRoomInfo(mode:uint, match:uint, isSelection:Boolean) : void
      {
         var modeObj:ModeObj = null;
         var roomObj:Object = null;
         if(mode < this.myFindModeList.listData.length)
         {
            if(Boolean(this.myFindModeList.getSelectedItem()))
            {
               modeObj = this.myFindModeList.getSelectedItem().getData();
            }
            if(Boolean(this.myMiddleList.getSelectedItem()))
            {
               roomObj = this.myMiddleList.getSelectedItem().getData();
            }
         }
         if(roomObj == null)
         {
            return;
         }
         this.myNoRoomModeInfo.visible = false;
         this.myModeInfo.visible = true;
         this.myModeInfo.showNoLevelProgressWarning(true);
         this.myConfirmButton.visible = true;
         this.mySpectatorButton.visible = roomObj.enableShoutcast;
         var modeName:String = DictRoom.NOT_APPLICABLE;
         var playlist:PlayListObj = DataManager.getInstance().getDP(DataID.PLAY_LIST_OBJ,[roomObj.playListID]);
         var xpRate:Number = playlist.xpScale;
         var gpRate:Number = playlist.gpScale;
         if(roomObj.playListID == undefined)
         {
            xpRate = gpRate = 0.1;
         }
         this.myModeInfo.setModeName(Dict.MATCH_SELECT_MENU_OPTION_ROOMS);
         this.myModeInfo.setGameName(modeObj.name);
         this.myModeInfo.setPlayerLimit(this.playerNumString(roomObj.currentPlayers,roomObj.currentMaxPlayers));
         this.myModeInfo.setModeDescription(modeObj.description);
         this.myModeInfo.setXPandGPRate(MathUtil.roundDecimal(xpRate * 100,2),MathUtil.roundDecimal(gpRate * 100,2));
         var modeStr:String = this.getFindModeId();
         var params:Array = ["",DataManager.getInstance().getDP(DataID.CURRENT_PLAYER_DLC_LEVEL)];
         var maplist:Array = DataManager.getInstance().getDP(DataID.LIST_MAP,params);
         maplist = this.filterMapsByMode(maplist,modeStr);
         this.myModeInfo.setMaps(maplist,TutorialService.getInstance().getContentByGameType(modeStr));
      }
      
      protected function onStartMatch() : void
      {
         switch(this.myGameTypeScrollList.selectedIndex)
         {
            case UiCppMatchSelectView.ROOM_TYPE_FIND:
               this.startJoinRoom();
               break;
            case UiCppMatchSelectView.ROOM_TYPE_CREATE:
               this.startCreateRoom();
         }
      }
      
      private function startCreateRoom() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_CREATE_ROOM);
         EventManager.getInstance().broadcast(BCEvent.EVT_BOTTOM_START_GAME);
      }
      
      private function startJoinRoom(teamIndex:int = -1) : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_START_AUTOMATCH);
         EventManager.getInstance().broadcast(BCEvent.EVT_BOTTOM_START_GAME,teamIndex);
      }
      
      protected function playerRangeString(minPlayers:int, maxPlayers:int) : String
      {
         return minPlayers + " ~ " + maxPlayers;
      }
      
      protected function playerNumString(curPlayers:int, maxPlayers:int) : String
      {
         return curPlayers + " / " + maxPlayers;
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppViewPanel(this);
      }
      
      private function onForceRefreshBtnClicked() : void
      {
         var date:Date = null;
         var currentTimeStamp:int = 0;
         if(this._clickCounter == 0)
         {
            date = new Date();
            this._timeStamp = date.time;
            ++this._clickCounter;
         }
         else
         {
            ++this._clickCounter;
            date = new Date();
            currentTimeStamp = date.time;
            if(currentTimeStamp - this._timeStamp > MAX_CLICK_TIME_THRESOLD)
            {
               this._clickCounter = 1;
               this._timeStamp = currentTimeStamp;
            }
            else if(this._clickCounter >= MAX_CLICK_THRESOLD)
            {
               BaseView.staticShowMsg(DictRoom.ROOM_REFRESH_TOO_FREQUENCY,1);
               this._clickCounter = 0;
               return;
            }
         }
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_REFRESH);
         (_view.getUiCpp() as UiCppMatchSelectView).RefreshRooms();
      }
      
      private function onClickJoinRoomAsSpectator() : void
      {
         this.startJoinRoom(FsgGameLobbyConsts.TEAM_SPECTATOR);
      }
      
      public function onTypeSelect(showRoomLoadInfo:Boolean = false) : void
      {
      }
   }
}

