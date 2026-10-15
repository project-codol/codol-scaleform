package codo.cpp
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.MarketScrollGrid;
   import codo.component.ScrollList;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.constants.SystemMsgPriority;
   import codo.constants.table.Mode;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.MapObj;
   import codo.objects.MatchSelectDifficultyObj;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.MatchSelectOptionObj;
   import codo.objects.MatchSelectTheatreOptionObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.objects.PlaylistCategoryObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.services.MatchService;
   import codo.utils.LocalizeUtil;
   import codo.views.MatchSelectView;
   import codo.views.uitour.UITutorialMatchSelectView;
   
   public dynamic class UiCppMatchSelectView extends UiCppView
   {
      
      public static var hackTutorialTabFix:Boolean;
      
      public static var CPP_TYPE:uint;
      
      public static const ROOT_IDX_PVP:uint = 0;
      
      public static const ROOT_IDX_PVE:uint = 1;
      
      public static const ROOT_IDX_BATTLECITY:uint = 2;
      
      public static const ROOT_IDX_WARGOD:uint = 3;
      
      public static const ROOT_IDX_ROOMS:uint = 4;
      
      public static const ROOT_IDX_TRAINING:uint = 5;
      
      public static const ROOT_IDX_THEATRE:uint = 6;
      
      public static const PVE_IDX_HERO_OPS:uint = 0;
      
      public static const ROOM_TYPE_FIND:uint = 0;
      
      public static const ROOM_TYPE_CREATE:uint = 1;
      
      private static const DIFFICULTY_HARD_INDEX:uint = 1;
      
      private static const DIFFICULTY_HERO_INDEX:uint = 2;
      
      private static const DIFFICULTY_UNLIMTED_SURVIVAL_INDEX:uint = 3;
      
      private static const DIFFICULTY_UNKNOWN:String = "?";
      
      public static const ENTRANCE_FROM_PLAYLIST:int = 0;
      
      public static const ENTRANCE_FROM_ROOTMENU:int = 1;
      
      public var CPP_rootModeList:UiCppList;
      
      public var CPP_pvpPanel:UiCppViewPanel;
      
      public var CPP_pvePanel:UiCppViewPanel;
      
      public var CPP_battleCityPanel:UiCppViewPanel;
      
      public var CPP_warGodPanel:UiCppViewPanel;
      
      public var CPP_roomPanel:UiCppViewPanel;
      
      public var CPP_theatrePanel:UiCppViewPanel;
      
      public var CPP_theatreList:UiCppList;
      
      public var CPP_favouriteList:UiCppList;
      
      public var CPP_pveModeList:UiCppList;
      
      public var CPP_pveMapList:UiCppList;
      
      public var CPP_pveDifficultyList:UiCppList;
      
      public var CPP_roomTypeList:UiCppList;
      
      public var CPP_roomCreateModeList:UiCppList;
      
      public var CPP_roomFindModeList:UiCppList;
      
      public var CPP_roomMatchList:UiCppList;
      
      public var CPP_pvpModeList:UiCppList;
      
      public var CPP_pvpMatchList:UiCppList;
      
      public var CPP_battleCityPlayList:UiCppList;
      
      private var _view:MatchSelectView;
      
      public function UiCppMatchSelectView(view:MatchSelectView)
      {
         this._view = view;
         this.CPP_rootModeList = new UiCppList(view.mySecondaryNavMenu);
         this.CPP_pvpPanel = view.myPVPPanel.getUiCpp() as UiCppViewPanel;
         this.CPP_pvePanel = view.myPVEPanel.getUiCpp() as UiCppViewPanel;
         this.CPP_battleCityPanel = view.myBattleCityPanel.getUiCpp() as UiCppViewPanel;
         this.CPP_warGodPanel = view.myWarGodPanel.getUiCpp() as UiCppViewPanel;
         this.CPP_roomPanel = view.myRoomPanel.getUiCpp() as UiCppViewPanel;
         this.CPP_theatrePanel = view.myTheatrePanel.getUiCpp() as UiCppViewPanel;
         this.CPP_theatreList = new UiCppList(view.myTheatrePanel.myScrollList);
         this.CPP_favouriteList = new UiCppList(view.myTheatrePanel.myMiddleList);
         this.CPP_pveModeList = new UiCppList(view.myPVEPanel.myLeftList);
         this.CPP_pveMapList = new UiCppList(view.myPVEPanel.myMiddleList);
         this.CPP_pveDifficultyList = new UiCppList(view.myPVEPanel.difficultyList);
         this.CPP_battleCityPlayList = new UiCppList(view.myBattleCityPanel.myLeftList);
         this.CPP_roomTypeList = new UiCppList(view.myRoomPanel.pvpTypeList);
         this.CPP_roomCreateModeList = new UiCppList(view.myRoomPanel.myCreateModeList);
         this.CPP_roomFindModeList = new UiCppList(view.myRoomPanel.myFindModeList);
         this.CPP_roomMatchList = new UiCppList(view.myRoomPanel.myMiddleList);
         this.CPP_pvpModeList = new UiCppList(view.myPVPPanel.myLeftList);
         this.CPP_pvpMatchList = new UiCppList(view.myPVPPanel.myMiddleList);
         super();
      }
      
      public static function ON_TRAINING(from:int = 1, playlist:PlayListObj = null) : void
      {
         var paramsForPlaylist:Object = null;
         var paramsForRootMenu:Object = null;
         if(from == ENTRANCE_FROM_PLAYLIST)
         {
            paramsForPlaylist = {
               "mode":"playlist",
               "playlist":playlist.index
            };
            DataManager.getInstance().request(DataID.JUMP_GAME,paramsForPlaylist);
         }
         else
         {
            if(Boolean(DataManager.getInstance().getDP(DataID.IS_TRAIN_BTN_LOCKED)))
            {
               BaseView.staticShowMsg("@SF_UI_NOTE_MAP_LOCKED",1,SystemMsgPriority.WARNING);
               return;
            }
            paramsForRootMenu = {
               "map":"coop_train_mp_firingrange",
               "mode":"coop",
               "difficulty":1
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{
               "page":PageID.LAUNCH_TRAINING,
               "routeData":paramsForRootMenu
            });
         }
      }
      
      public function decideJuniorWarGodPlaylist(playlist:Array) : void
      {
         this["AS_DecideJuniorWarGodPlaylist"](playlist);
      }
      
      public function RefreshRooms() : void
      {
         this["AS_RefreshRooms"]();
      }
      
      public function StartDemo() : void
      {
         this["AS_StartDemo"](this._view.myTheatrePanel.myScrollList.selectedData.name);
      }
      
      public function FavouriteDemo() : void
      {
         this["AS_FavouriteDemo"](this._view.myTheatrePanel.myScrollList.selectedData.name);
      }
      
      public function DeleteDemo() : void
      {
         this["AS_DeleteDemo"](this._view.myTheatrePanel.myScrollList.selectedData.name);
      }
      
      public function SetInitialPlaylist(playlist:PlayListObj) : void
      {
         this["AS_SetInitialPlaylist"](playlist);
      }
      
      public function GetWarGodPlaylist() : PlayListObj
      {
         return this["AS_GetWarGodPlaylist"]();
      }
      
      public function CPP_GetHeroOpsModeObj() : MatchSelectModeObj
      {
         var locked:Boolean = DataManager.getInstance().getDP(DataID.IS_COOP_BTN_LOCKED);
         return new MatchSelectModeObj(null,Dict.MATCH_SELECT_HERO_OPS_TITLE,null,locked);
      }
      
      public function CPP_GetPveModeObjs() : Array
      {
         var playlistsData:Array = this.getPlaylistModeObjs(DataID.LIST_PLAY_LIST_PVE,CFunctionContainer.PLAYLIST_GROUP_PVE);
         this.initPvePlaylists(playlistsData);
         return playlistsData;
      }
      
      public function CPP_SetTheatreObjs(data:Vector.<MatchSelectTheatreOptionObj>) : void
      {
         var modeData:MatchSelectTheatreOptionObj = null;
         var recentData:Array = [];
         var savedData:Array = [];
         var len:uint = data.length;
         for(var i:int = 0; i < len; i++)
         {
            modeData = data[i];
            if(modeData.saved)
            {
               savedData.push(modeData);
            }
            else
            {
               recentData.push(modeData);
            }
         }
         var _itemsData:Array = MarketScrollGrid.initSplitList(this._view.myTheatrePanel.myScrollList,true,savedData,recentData,true,"@SF_UI_THEATER_SAVED_FILES","@SF_UI_THEATER_RECENT_FILES");
         len = _itemsData.length;
         var items:Vector.<Object> = new Vector.<Object>();
         for(var j:int = 0; j < len; j++)
         {
            items.push(_itemsData[j]);
         }
         this._view.myTheatrePanel.myScrollList.addItemsByVector(items);
         this._view.myTheatrePanel.refreshSavedCounter(savedData.length);
         this._view.myTheatrePanel.myEmptyText.visible = len == 0;
      }
      
      public function CPP_GetSelectedTheatreObj() : Object
      {
         return this._view.myTheatrePanel.myScrollList.selectedData;
      }
      
      public function CPP_SelectTheatreOption() : void
      {
         this._view.myTheatrePanel.selectTheatreOption();
      }
      
      public function CPP_GetRoomTypes() : Array
      {
         var types:Array = [new MatchSelectOptionObj(null,LocalizeUtil.localize(Dict.FIND_ROOM_TITLE))];
         var hideCreate:Boolean = DataManager.getInstance().getDP(DataID.IS_CREATE_ROOM_LOCKED);
         if(!hideCreate)
         {
            types.push(new MatchSelectOptionObj(null,LocalizeUtil.localize(Dict.CREATE_ROOM_TITLE)));
         }
         return types;
      }
      
      public function CPP_GetPvpQuickMatchModes() : Array
      {
         return this.getPlaylistModeObjs(DataID.LIST_PLAY_LIST_MP,CFunctionContainer.PLAYLIST_GROUP_PVP);
      }
      
      public function CPP_OnRoomsListed(finished:Boolean) : void
      {
         this._view.myRoomPanel.onRoomsListed(finished);
      }
      
      public function CPP_GetPvpCreateModes() : Array
      {
         var modeList:Array = DataManager.getInstance().getDP(DataID.LIST_MODE,[""]);
         if(modeList == null)
         {
            modeList = [];
         }
         return this.filterAndSortModeList(modeList);
      }
      
      public function CPP_OnPvp() : void
      {
         this._view.tryPlayTutorial(UITutorialMatchSelectView.TUTORIAL_PVP);
         this._view.myPVPPanel.onTypeSelect();
      }
      
      public function CPP_OnBattleCityMode() : void
      {
      }
      
      public function CPP_OnWarGodMode() : void
      {
         this._view.tryPlayTutorial(UITutorialMatchSelectView.TUTORIAL_WARGOD);
      }
      
      public function CPP_OnPveMode() : void
      {
         this._view.tryPlayTutorial(UITutorialMatchSelectView.TUTORIAL_PVE);
         this._view.myPVEPanel.onModeSelect();
      }
      
      public function CPP_OnRoomType(showRoomLoadInfo:Boolean) : void
      {
         this._view.myRoomPanel.onTypeSelect(showRoomLoadInfo);
      }
      
      public function CPP_OnPvpMode() : void
      {
         this._view.myPVPPanel.onModeSelect();
      }
      
      public function CPP_OnRoomMode() : void
      {
         this._view.myRoomPanel.onModeSelect();
      }
      
      public function CPP_OnTheatreOption(data:MatchSelectTheatreOptionObj) : void
      {
         this._view.myTheatrePanel.selectTheatreOption(data);
      }
      
      public function CPP_OnTheatreOptionClear() : void
      {
         this._view.myTheatrePanel.clearTheatreOption();
      }
      
      public function CPP_GetTheatreInfo() : String
      {
         return this._view.myTheatrePanel.myTheatreInfo.name;
      }
      
      public function CPP_OnPvpMatchDisplay(mode:uint, match:uint, isSelection:Boolean) : void
      {
         this._view.myPVPPanel.onMatchDisplay(mode,match,isSelection);
      }
      
      public function CPP_OnRoomMatchDisplay(mode:uint, match:uint, isSelection:Boolean) : void
      {
         this._view.myRoomPanel.onMatchDisplay(mode,match,isSelection);
      }
      
      public function CPP_OnPveDifficulty() : void
      {
         this._view.myPVEPanel.onDifficultySelect();
      }
      
      public function CPP_OnPveMapDisplay(mode:uint, difficulty:uint, map:uint, isSelection:Boolean) : void
      {
         this._view.myPVEPanel.onMapDisplay(mode,difficulty,map,isSelection);
      }
      
      public function CPP_OnBattleCityMatchDisplay(playlistSelection:int) : void
      {
         this._view.myBattleCityPanel.onPlaylistSelect(playlistSelection);
      }
      
      public function CPP_GetHeroOpsMaps() : Array
      {
         var itemData:MapObj = null;
         var maps:Array = DataManager.getInstance().getDP(DataID.LIST_MAP,[Mode.TYPE_PVE,DataManager.getInstance().getDP(DataID.CURRENT_PLAYER_DLC_LEVEL),true]) as Array;
         if(maps == null)
         {
            maps = [];
         }
         var len:int = int(maps.length);
         for(var i:int = 0; i < len; i++)
         {
            itemData = maps[i];
            itemData.locked = !itemData.unlocked || itemData.lockedByDLCLevel;
            if(itemData.isComplete)
            {
               itemData.locked = false;
            }
         }
         return maps;
      }
      
      public function CPP_GetWarGodPlaylist() : PlayListObj
      {
         var pl:PlayListObj = null;
         var playLists:Array = DataManager.getInstance().getDP(DataID.LIST_PLAY_LIST_MP);
         var warGodSettings:WarGodGlobalSettingObj = DataManager.getInstance().getDP(DataID.WARGOD_GLOBAL_SETTING);
         for(var i:int = 0; i < playLists.length; i++)
         {
            pl = playLists[i];
            if(pl.index == warGodSettings.playlistId)
            {
               return pl;
            }
         }
         return null;
      }
      
      public function CPP_GetBattleCityPlaylist() : Array
      {
         return DataManager.getInstance().getDP(DataID.LIST_PLAY_LIST_BATTLECITY,[true]);
      }
      
      public function CPP_OnRootModeClick() : void
      {
         if(hackTutorialTabFix)
         {
            return;
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_END_TUTORIAL,PageID.MATCH_SELECT);
      }
      
      public function CPP_OnTraining() : void
      {
         ON_TRAINING();
      }
      
      public function CPP_OnNewModeClear(cppList:UiCppList) : void
      {
         var list:ScrollList = cppList.GetList() as ScrollList;
         var item:UIInteractiveComponent = list.getSelectedItem();
         var data:* = item.getData();
         item.setData(data);
      }
      
      private function getPlaylistModeObjs(dataID:String, categoryGroup:uint) : Array
      {
         var i:int = 0;
         var pl:PlayListObj = null;
         var category:PlaylistCategoryObj = null;
         var modeObj:MatchSelectModeObj = null;
         var j:int = 0;
         var id:uint = 0;
         var playlist:PlayListObj = null;
         var playLists:Array = DataManager.getInstance().getDP(dataID);
         if(playLists == null)
         {
            return [];
         }
         var playlistsById:Array = [];
         for(i = 0; i < playLists.length; i++)
         {
            pl = playLists[i];
            playlistsById[pl.index] = pl;
         }
         var categories:Array = CFunctionContainer.GetPlayListCategories(categoryGroup);
         var playlistsData:Array = [];
         for(i = 0; i < categories.length; i++)
         {
            category = categories[i];
            modeObj = new MatchSelectModeObj(null,category.name,null,category.locked,category.unlockLevelStart,category.isNew,category.isFeatured);
            modeObj.isNewUnlock = category.isNewUnlock;
            modeObj.unlockItem = category.unlockItem;
            modeObj.cycleTodayIndex = category.cycleTodayIndex;
            for(j = 0; j < category.entries.length; j++)
            {
               id = uint(category.entries[j]);
               playlist = playlistsById[id];
               if(playlist != null)
               {
                  if(category.cycleTodayIndex >= 0)
                  {
                     playlist.cycleDayIndex = j;
                     playlist.isActive = j == category.cycleTodayIndex;
                  }
                  modeObj.playlists.push(playlist);
               }
            }
            playlistsData.push(modeObj);
         }
         return playlistsData;
      }
      
      private function initPvePlaylists(playlistsData:Array) : void
      {
         var mode:MatchSelectModeObj = null;
         var j:int = 0;
         var playlist:PlayListObj = null;
         var unlocked:Boolean = false;
         var unlockFlag:String = null;
         for(var i:int = 0; i < playlistsData.length; i++)
         {
            mode = playlistsData[i] as MatchSelectModeObj;
            for(j = 0; j < mode.playlists.length; j++)
            {
               playlist = mode.playlists[j];
               unlocked = playlist.unlocked;
               unlockFlag = playlist.unlockFlag;
               if(unlockFlag.length > 0)
               {
                  unlocked &&= Boolean(CFunctionContainer.IsFlagUnlocked(unlockFlag,1));
               }
               playlist.unlocked = unlocked;
               playlist.isUnlimitedSurvival = MatchService.getInstance().getPlayListHasRule(playlist,"scr_survival_unlimited_waves 1");
               playlist.isUnlimitedZombies = MatchService.getInstance().getPlayListHasRule(playlist,"zarena_round_table unlimited");
               playlist.isSurvivalPlus = MatchService.getInstance().getPlayListHasRule(playlist,"scr_survival_plus_mode 1");
            }
            this.initPveDifficulties(mode);
         }
      }
      
      private function initPveDifficulties(mode:MatchSelectModeObj) : void
      {
         var i:int = 0;
         var playlist:PlayListObj = null;
         var diffic:int = 0;
         var dataObj:MatchSelectDifficultyObj = null;
         mode.pveDifficulties = [];
         var rawDifficulties:Array = [];
         for(i = 0; i < mode.playlists.length; i++)
         {
            playlist = mode.playlists[i];
            diffic = playlist.leagueID;
            if(playlist.isUnlimitedSurvival || playlist.isUnlimitedZombies)
            {
               diffic = int(DIFFICULTY_UNLIMTED_SURVIVAL_INDEX);
            }
            if(rawDifficulties.length <= diffic)
            {
               rawDifficulties.length = diffic + 1;
            }
            if(rawDifficulties[diffic] == null)
            {
               rawDifficulties[diffic] = [];
            }
            rawDifficulties[diffic].push(playlist);
         }
         for(i = 0; i < rawDifficulties.length; i++)
         {
            if(rawDifficulties[i] != null)
            {
               dataObj = new MatchSelectDifficultyObj();
               dataObj.playlists = rawDifficulties[i];
               if(i >= 0 && i < DictRoom.ROOM_LEVELS.length)
               {
                  dataObj.name = DictRoom.ROOM_LEVELS[i];
               }
               else
               {
                  dataObj.name = DIFFICULTY_UNKNOWN;
               }
               mode.pveDifficulties.push(dataObj);
            }
         }
      }
      
      private function filterAndSortModeList(modeList:Array) : Array
      {
         var index:int = 0;
         var order:String = CFunctionCommonContainer.Dvar_GetString("ui_mode_order");
         var modeOrder:Array = order.split(",");
         var copiedModeList:Array = modeList.concat();
         var orderedModeList:Array = new Array();
         for(var i:int = 0; i < modeOrder.length; i++)
         {
            index = this.findModeObj(modeOrder[i],copiedModeList);
            if(-1 != index && Boolean(copiedModeList[index].customizable))
            {
               orderedModeList.push(copiedModeList[index]);
               copiedModeList.splice(index,1);
            }
         }
         for(i = 0; i < copiedModeList.length; i++)
         {
            if(Boolean(copiedModeList[i].customizable))
            {
               orderedModeList.push(copiedModeList[i]);
            }
         }
         return orderedModeList;
      }
      
      private function findModeObj(id:String, modeList:Array) : int
      {
         for(var i:int = 0; i < modeList.length; i++)
         {
            if((modeList[i] as ModeObj).id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

