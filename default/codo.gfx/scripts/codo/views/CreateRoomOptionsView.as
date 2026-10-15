package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionContainer;
   import codo.component.ComboBox;
   import codo.component.ComboBoxSettingRow;
   import codo.component.ScrollGrid;
   import codo.component.ScrollList;
   import codo.component.TabNavigation;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.CreateRoomOptionsList;
   import codo.constants.DataID;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSetting;
   import codo.localization.DictSystem;
   import codo.objects.ComboBoxSettingRowObj;
   import codo.objects.ItemBanCategoryObj;
   import codo.objects.ItemBanObj;
   import codo.objects.MatchSelectTableRowObj;
   import codo.objects.RoomObj;
   import codo.objects.RoomOptionObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListHeaderRestrictionObj;
   import codo.objects.ScrollListSettings;
   import codo.objects.SystemMsgObj;
   import codo.utils.MarketItemUtil;
   import flash.display.MovieClip;
   
   public class CreateRoomOptionsView extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 885;
      
      private static const MIN_CONTENT_HEIGHT:Number = 380;
      
      private static const TAB_CUSTOM_OPTIONS:uint = 0;
      
      private static const TAB_WEAPON_BANS:uint = 1;
      
      private static const TAB_ITEM_BANS:uint = 2;
      
      private static const COMBO_BOX_LINK:String = "codo.shared.comboBoxSettingRow";
      
      private static const ADVANCED_OPTION_TAB_LINKAGE:String = "codo.shared.FilterToggleButton";
      
      public var myTabBar:TabNavigation;
      
      public var myCustomOptionsList:ScrollList;
      
      public var myWeaponBanGrid:ScrollGrid;
      
      public var myItemBanGrid:ScrollGrid;
      
      public var myOptionsTabNavigation:MovieClip;
      
      private var tableInfo:Vector.<MatchSelectTableRowObj>;
      
      private var createOptions:Array = [];
      
      private var _mode:String = "";
      
      private var _isHost:Boolean = true;
      
      private var _currentTabIdx:int;
      
      private var _bansChanged:Boolean;
      
      private var _saveBanChanges:Boolean;
      
      public function CreateRoomOptionsView()
      {
         super();
         myPopup.myCloseButton.setClickCallback(this.onCancelBtnClick,null,true);
      }
      
      override protected function onInit() : void
      {
         this.myOptionsTabNavigation.visible = false;
         myPopup.width = POPUP_WIDTH;
         myPopup.keepBogusHeightCode = false;
         myPopup.header.title = "@SF_UI_ADVANCED_OPTIONS";
         var tabs:Array = [];
         tabs[TAB_CUSTOM_OPTIONS] = {
            "label":"@SF_UI_GAME_OPTION_TAB_MATCH",
            "lockedForPurchase":false
         };
         tabs[TAB_WEAPON_BANS] = {
            "label":"@SF_UI_WEAPON_BANS",
            "lockedForPurchase":false
         };
         tabs[TAB_ITEM_BANS] = {
            "label":"@SF_UI_ITEM_BANS",
            "lockedForPurchase":false
         };
         var tabData:Object = {};
         tabData.tabClickedCallback = this.gotoTabPage;
         tabData.tabs = tabs;
         tabData.tabWidth = 170;
         tabData.tabPadding = 3;
         tabData.tabLinkage = ADVANCED_OPTION_TAB_LINKAGE;
         this.myTabBar.setData(tabData);
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.autoSize = false;
         listSettings.autoSizeItems = true;
         listSettings.useNavArrows = false;
         listSettings.useMask = false;
         this.myCustomOptionsList.settings = listSettings;
         this.myCustomOptionsList.width = POPUP_WIDTH - 65;
         this.myCustomOptionsList.height = MIN_CONTENT_HEIGHT;
         this.myWeaponBanGrid.visible = this.myItemBanGrid.visible = false;
         this.listen(BCEvent.ROOM_INFO_ONLY,this.onUpdateWithBroadcastedRoomInfoHandle);
         this.listen(BCEvent.REINSTANCE_ROOM_OPTIONS,this.onReinstanceRoomOptionsHandle);
         this.listen(BCEvent.ON_ROOM_JOINED,this.onResetHeaderStates);
         this.tableInfo = new Vector.<MatchSelectTableRowObj>();
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(this.createOptions.length <= 0)
         {
            this.createCustomOptions((this.getDP(DataID.ROOM_INFO) as RoomObj).currentMatchMode.id);
         }
         else
         {
            this.myTabBar.SetSelectedIndex(TAB_CUSTOM_OPTIONS);
         }
         bind(DataID.ROOM_INFO,this.bind_onRoomInfoUpdated);
         this._bansChanged = false;
         this._saveBanChanges = false;
         var isHost:Boolean = getDP(DataID.IS_ROOM_HOST);
         if(isHost)
         {
            CFunctionContainer.SetItemBansTemp();
         }
      }
      
      private function createCustomOptions(mode:String) : void
      {
         this.myCustomOptionsList.resetList();
         this.createOptions.length = 0;
         this.tableInfo = this.getDP(DataID.GET_ROOM_OPTIONS_ROW_INFO);
         if(mode == "")
         {
            mode = (this.getDP(DataID.GET_CACHED_ROOM_INFO) as RoomObj).currentMatchMode.id;
         }
         this._mode = mode;
         var supportedOptions:Array = this.getDP(DataID.LIST_SUPPORTED_OPTIONS,[this._mode]);
         var len:uint = supportedOptions.length;
         for(var i:uint = 0; i < len; i++)
         {
            this.createComponentRow(supportedOptions[i]);
         }
         var listHeight:Number = Math.max(this.myCustomOptionsList.getContentLength(),MIN_CONTENT_HEIGHT);
         this.myCustomOptionsList.height = listHeight;
         myPopup.height = listHeight + 192;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         gridSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_RESTRICTION_ITEM;
         this.myWeaponBanGrid.initGrid(gridSettings,listHeight,true,4);
         this.myItemBanGrid.initGrid(gridSettings,listHeight,true,4);
         this.myCustomOptionsList.refreshVisuals();
         this.myTabBar.SetSelectedIndex(TAB_CUSTOM_OPTIONS);
         this.updateStageToCurrentSettings();
      }
      
      private function refreshCurrentBanList() : void
      {
         var filter:uint = 0;
         var header:ScrollListHeaderRestrictionObj = null;
         var restrictionCategory:ItemBanCategoryObj = null;
         var restrictedItems:Vector.<ItemBanObj> = null;
         var numBanned:int = 0;
         var listLen:int = 0;
         var j:int = 0;
         switch(this._currentTabIdx)
         {
            case TAB_WEAPON_BANS:
               filter = Common.ITEM_BAN_FILTER_WEAPONS;
               break;
            case TAB_ITEM_BANS:
               filter = Common.ITEM_BAN_FILTER_ITEMS;
               break;
            default:
               return;
         }
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         var restrictedCategories:Vector.<ItemBanCategoryObj> = CFunctionContainer.GetItemBanList(filter,false);
         var restrictionList:Vector.<Object> = new Vector.<Object>();
         var startIndex:int = 0;
         var catLen:int = int(restrictedCategories.length);
         for(var i:int = 0; i < catLen; i++)
         {
            restrictionCategory = restrictedCategories[i];
            restrictedItems = restrictionCategory.items;
            numBanned = 0;
            listLen = int(restrictedItems.length);
            for(j = 0; j < listLen; j++)
            {
               restrictedItems[j].toggleBannedCallback = this.onBanToggled;
               restrictionList.push(restrictedItems[j]);
               if(restrictedItems[j].banned)
               {
                  numBanned++;
               }
            }
            header = new ScrollListHeaderRestrictionObj();
            header.beforeIndex = startIndex;
            header.count = listLen;
            header.label = MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(restrictionCategory.name);
            header.numBanned = numBanned;
            header.toggleBannedCallback = this.onBanCategoryToggled;
            headers.push(header);
            startIndex += header.count;
         }
         var curList:ScrollGrid = this.getListForTabIdx(this._currentTabIdx) as ScrollGrid;
         curList.setHeaders(headers);
         curList.addItemsByVector(restrictionList);
      }
      
      private function onBanToggled(data:Object) : void
      {
         this._bansChanged = true;
         CFunctionContainer.SetItemIsBanned(data.id,data.banned);
         this.refreshCurrentBanList();
      }
      
      private function onBanCategoryToggled(data:ScrollListHeaderRestrictionObj) : void
      {
         var itemBanData:ItemBanObj = null;
         this._bansChanged = true;
         var i:uint = data.beforeIndex;
         var iLimit:uint = i + data.count;
         for(var setBanned:Boolean = data.numBanned < data.count; i < iLimit; )
         {
            itemBanData = this.getListForTabIdx(this._currentTabIdx).listData[i] as ItemBanObj;
            if(itemBanData.banned != setBanned)
            {
               CFunctionContainer.SetItemIsBanned(itemBanData.id,setBanned);
            }
            i++;
         }
         this.refreshCurrentBanList();
      }
      
      private function createComponentRow(option:int) : void
      {
         var rowToCreate:MatchSelectTableRowObj = null;
         var len:uint = this.tableInfo.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(this.tableInfo[i].index == option)
            {
               rowToCreate = this.tableInfo[i];
               break;
            }
         }
         if(rowToCreate == null)
         {
            return;
         }
         var indexToUse:int = 0;
         len = rowToCreate.data.length;
         for(i = 1; i < len; i++)
         {
            if(rowToCreate.data[i].modeID == this._mode)
            {
               indexToUse = int(i);
               break;
            }
         }
         var comboBoxData:ComboBoxSettingRowObj = new ComboBoxSettingRowObj();
         comboBoxData.label = rowToCreate.label;
         comboBoxData.dataProvider = rowToCreate.data[indexToUse].dataComboBox;
         var insert:Object = {};
         insert.component = this.myCustomOptionsList.addItem(comboBoxData,COMBO_BOX_LINK);
         insert.index = rowToCreate.index;
         insert.defaultValue = rowToCreate.data[indexToUse].defaultValue;
         this.createOptions.push(insert);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         if(this._isHost && !this._saveBanChanges)
         {
            CFunctionContainer.ResetItemBansToTemp();
         }
         unbind(DataID.ROOM_INFO,this.bind_onRoomInfoUpdated);
      }
      
      private function setOptionsToDefault() : void
      {
         var len:uint = this.createOptions.length;
         for(var i:uint = 0; i < len; i++)
         {
            this.setValueForComboBox(this.createOptions[i].component,this.createOptions[i].defaultValue);
         }
      }
      
      private function setValueForComboBox(component:Object, value:Object) : void
      {
         var comboBox:ComboBox = component.myComboBox as ComboBox;
         var data:Array = comboBox.dataProvider as Array;
         var dataLen:uint = data.length;
         for(var i:uint = 0; i < dataLen; i++)
         {
            if(data[i].id == String(value))
            {
               comboBox.selectedIndex = i;
               break;
            }
         }
         comboBox.label = comboBox.selectedData.name;
      }
      
      private function updateStageToCurrentSettings() : void
      {
         var value:Object = null;
         var room:RoomObj = this.getDP(DataID.ROOM_INFO);
         var options:RoomOptionObj = room.options;
         var len:uint = this.createOptions.length;
         for(var i:uint = 0; i < len; i++)
         {
            switch(this.createOptions[i].index)
            {
               case CreateRoomOptionsList.MODE_TIME_LIMIT:
                  value = options.modeTimeLimit;
                  break;
               case CreateRoomOptionsList.MODE_SCORE_LIMIT:
                  value = options.modeScoreLimit;
                  break;
               case CreateRoomOptionsList.MODE_ROUND_LIMIT:
                  value = options.modeRoundLimit;
                  break;
               case CreateRoomOptionsList.MODE_WIN_LIMIT:
                  value = options.modeWinLimit;
                  break;
               case CreateRoomOptionsList.MODE_ROUND_SWITCH:
                  value = options.modeRoundSwitch;
                  break;
               case CreateRoomOptionsList.MODE_NUM_LIVES:
                  value = options.modeNumLives;
                  break;
               case CreateRoomOptionsList.MODE_PLAYER_RESPAWN_DELAY:
                  value = options.modePlayerRespawnDelay;
                  break;
               case CreateRoomOptionsList.MODE_WAVE_RESPAWN_DELAY:
                  value = options.modeWaveRespawnDelay;
                  break;
               case CreateRoomOptionsList.MODE_BOMB_TIMER:
                  value = options.modeBombTimer;
                  break;
               case CreateRoomOptionsList.MODE_PLANT_TIME:
                  value = options.modePlantTime;
                  break;
               case CreateRoomOptionsList.MODE_DEFUSE_TIME:
                  value = options.modeDefuseTime;
                  break;
               case CreateRoomOptionsList.PLAYER_MAX_HEALTH:
                  value = options.playerMaxHealth;
                  break;
               case CreateRoomOptionsList.PLAYER_HEALTH_REGEN_TIME:
                  value = options.playerHealthRegenTime;
                  break;
               case CreateRoomOptionsList.PLAYER_HEALTH_REGEN_RATE:
                  value = options.playerHealthRegenRate;
                  break;
               case CreateRoomOptionsList.TEAM_FF_TYPE:
                  value = options.teamFFType;
                  break;
               case CreateRoomOptionsList.GAME_SPECTATE_TYPE:
                  value = options.gameSpectateType;
                  break;
               case CreateRoomOptionsList.GAME_ALLOW_KILLCAM:
                  value = options.gameAllowKillCam ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_ENABLE_HARDCORE:
                  value = options.gameEnableHardcore ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_FORCE_UAV:
                  value = options.gameForceUAV ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_ONLY_HEADSHOTS:
                  value = options.gameOnlyHeadshots ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_ENABLE_BUDDY_MODE:
                  value = options.gameEnableBuddyMode ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.COMBAT_HIGH_HOSTILE_ACTION_END:
                  value = options.combatHighHostileActionEnd;
                  break;
               case CreateRoomOptionsList.BOTS_ADD_ALL:
                  value = options.botsAddAll ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.CLASH_MODE:
                  value = options.clashMode;
                  break;
               case CreateRoomOptionsList.CLASH_FOV:
                  value = options.clashFOV;
                  break;
               case CreateRoomOptionsList.RESTRICT_WPNS_AT_START:
                  value = options.restrictWpnsAtStart ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.DIFFICULTY:
                  value = options.difficulty.toString() + (options.isEndless ? "|" + RoomOptionObj.DIFFICULTY_ENDLESS : "");
            }
            this.setValueForComboBox(this.createOptions[i].component,value);
         }
      }
      
      private function getDataFromComboBox(component:Object) : Object
      {
         var row:ComboBoxSettingRow = component as ComboBoxSettingRow;
         var box:ComboBox = row.myComboBox as ComboBox;
         return box.selectedData.id;
      }
      
      private function onUpdateWithBroadcastedRoomInfoHandle(cEvt:ParaEvent) : void
      {
         this.updateStageToCurrentSettings();
      }
      
      private function onReinstanceRoomOptionsHandle(cEvt:ParaEvent) : void
      {
         this.createCustomOptions((this.getDP(DataID.ROOM_INFO) as RoomObj).currentMatchMode.id);
      }
      
      private function onResetHeaderStates() : void
      {
         this.myWeaponBanGrid.resetHeaderStates();
         this.myItemBanGrid.resetHeaderStates();
      }
      
      private function updatedRoomObject() : RoomObj
      {
         var value:Object = null;
         var room:RoomObj = this.getDP(DataID.ROOM_INFO);
         var len:uint = this.createOptions.length;
         for(var i:uint = 0; i < len; i++)
         {
            value = this.getDataFromComboBox(this.createOptions[i].component);
            room.options = this.getDP(DataID.SET_ROOM_OPTION_VALUE,[room.options,this.createOptions[i].index,value]);
         }
         return room;
      }
      
      private function gotoTabPage(index:int) : void
      {
         if(index == this._currentTabIdx)
         {
            return;
         }
         this.getListForTabIdx(this._currentTabIdx).visible = false;
         this._currentTabIdx = index;
         this.refreshCurrentBanList();
         this.getListForTabIdx(index).visible = true;
         this.updatePopupButtons();
      }
      
      private function getListForTabIdx(index:int) : ScrollList
      {
         switch(index)
         {
            case TAB_CUSTOM_OPTIONS:
               return this.myCustomOptionsList;
            case TAB_WEAPON_BANS:
               return this.myWeaponBanGrid;
            case TAB_ITEM_BANS:
               return this.myItemBanGrid;
            default:
               return this.myCustomOptionsList;
         }
      }
      
      private function onAcceptBtnClick() : void
      {
         this._saveBanChanges = true;
         this.broadcast(BCEvent.CHANGE_ROOM_OPTIONS,this.updatedRoomObject());
         this.broadcast(BCEvent.EVT_CLOSE_CREATEROOMOPTION);
      }
      
      private function onCancelBtnClick() : void
      {
         var systemMsg:SystemMsgObj = null;
         if(this._isHost && this._bansChanged)
         {
            systemMsg = SystemMsgObj.getObj("@SF_UI_ROOM_OPTIONS_WARNING",2,SystemMsgPriority.NORMAL,this.onCloseConfirm,Dict.CONFIRM,null,Dict.CANCEL,null,"",0,0,DictSystem.WARNING);
            this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
         }
         else
         {
            this.onCloseConfirm();
         }
      }
      
      private function onCloseConfirm() : void
      {
         this.broadcast(BCEvent.EVT_CLOSE_CREATEROOMOPTION);
         this.updateStageToCurrentSettings();
      }
      
      private function onDefaultBtnClick() : void
      {
         this.setOptionsToDefault();
      }
      
      private function updatePopupButtons() : void
      {
         myPopup.resetButtons();
         if(this._isHost)
         {
            myPopup.configConfirmButton(DictSetting.APPLY_SETTING,this.onAcceptBtnClick);
            if(this._currentTabIdx == TAB_CUSTOM_OPTIONS)
            {
               myPopup.configAuxiliaryButton(DictSetting.DEFAULT_SETTING,this.onDefaultBtnClick);
            }
         }
         myPopup.configCancelButton(DictSetting.CANCEL_SETTING,this.onCancelBtnClick);
      }
      
      private function bind_onRoomInfoUpdated(cRes:Object) : void
      {
         var len:int = 0;
         var i:int = 0;
         var row:ComboBoxSettingRow = null;
         var box:ComboBox = null;
         if(cRes.data == null)
         {
            return;
         }
         var roomObj:RoomObj = cRes.data;
         var isHost:Boolean = !roomObj.isPlayList && roomObj.forces.isHost;
         if(this._isHost != isHost)
         {
            this._isHost = isHost;
            len = this.myCustomOptionsList.numberOfItems;
            for(i = 0; i < len; i++)
            {
               row = this.myCustomOptionsList.getItem(i) as ComboBoxSettingRow;
               box = row.myComboBox as ComboBox;
               box.enabled = isHost;
            }
            if(isHost)
            {
               CFunctionContainer.SetItemBansTemp();
            }
         }
         this.myTabBar.tabs[TAB_WEAPON_BANS].visible = this.myTabBar.tabs[TAB_ITEM_BANS].visible = isHost && Boolean(getDP(DataID.ROOM_ITEM_BANS_ENABLED));
         this.myTabBar.SetSelectedIndex(TAB_CUSTOM_OPTIONS);
         this.updatePopupButtons();
      }
   }
}

