package codo.component.lobby
{
   import codo.component.Button;
   import codo.component.ComboBox;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.CreateRoomOptionsList;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.MatchSelectTableRowObj;
   import codo.objects.RoomObj;
   import codo.objects.RoomOptionObj;
   import codo.utils.ClashPvpUtil;
   import codo.views.GameLobbyView;
   
   public class LobbyAdvancedOptions extends UIInteractiveComponent
   {
      
      public static const ADVANCED_OPTION_WIDTH:int = 325;
      
      public static const ADVANCED_OPTION_X:int = 2;
      
      public static const TEXT_FIELD_WIDTH:int = 177;
      
      public static const COMBO_BOX_WIDTH:int = 210;
      
      public static const COMBO_BOX_X:int = 120;
      
      public var myTextField0:TextField;
      
      public var myTextField1:TextField;
      
      public var myTextField2:TextField;
      
      public var myTextField3:TextField;
      
      public var myComboBox0:ComboBox;
      
      public var myComboBox1:ComboBox;
      
      public var myComboBox2:ComboBox;
      
      public var myAdvancedBtn:Button;
      
      private var _primaryOptions:Array = [];
      
      private var mSkipComboBoxChangeCallback:Boolean = false;
      
      private var mFixClashFOVForHardcore:Boolean = false;
      
      private var mClashFOVComboBox:ComboBox;
      
      private var mLastClashFOV:int = -1;
      
      public function LobbyAdvancedOptions()
      {
         super();
         this.myAdvancedBtn.registerClickEvent(this.onAdvancedOptionsClicked);
         this.myAdvancedBtn.label = "@SF_UI_ADVANCED_OPTIONS";
         this.myAdvancedBtn.x = ADVANCED_OPTION_X;
         this.myAdvancedBtn.width = ADVANCED_OPTION_WIDTH;
         this.myComboBox0.addEventListener(ComboBox.EVT_CHANGE,this.onComboBoxChanged);
         this.myComboBox1.addEventListener(ComboBox.EVT_CHANGE,this.onComboBoxChanged);
         this.myComboBox2.addEventListener(ComboBox.EVT_CHANGE,this.onComboBoxChanged);
         this.myComboBox0.singleOptionMode = true;
         this.myComboBox1.singleOptionMode = true;
         this.myComboBox2.singleOptionMode = true;
         this.myComboBox0.showSelectionInHeader = true;
         this.myComboBox1.showSelectionInHeader = true;
         this.myComboBox2.showSelectionInHeader = true;
         this.myComboBox0.allowScrolling = true;
         this.myComboBox1.allowScrolling = true;
         this.myComboBox2.allowScrolling = true;
         this.myComboBox0.scrollListHeight = GameLobbyView.LOBBY_SCROLL_LIST_HEIGHT;
         this.myComboBox1.scrollListHeight = GameLobbyView.LOBBY_SCROLL_LIST_HEIGHT;
         this.myComboBox2.scrollListHeight = GameLobbyView.LOBBY_SCROLL_LIST_HEIGHT;
         this.myComboBox0.width = COMBO_BOX_WIDTH;
         this.myComboBox1.width = COMBO_BOX_WIDTH;
         this.myComboBox2.width = COMBO_BOX_WIDTH;
         this.myComboBox0.x = COMBO_BOX_X;
         this.myComboBox1.x = COMBO_BOX_X;
         this.myComboBox2.x = COMBO_BOX_X;
         this.myTextField0.width = TEXT_FIELD_WIDTH;
         this.myTextField1.width = TEXT_FIELD_WIDTH;
         this.myTextField2.width = TEXT_FIELD_WIDTH;
         this.myTextField3.width = TEXT_FIELD_WIDTH;
      }
      
      public function SetUpOptions() : void
      {
         var roomObj:RoomObj = null;
         var numRows:uint = 0;
         var numModes:uint = 0;
         var j:uint = 0;
         var dataProvider:Array = null;
         var d:uint = 0;
         var newPrimaryOption:Object = null;
         roomObj = DataManager.getInstance().getDP(DataID.ROOM_INFO);
         var optionsTableInfo:Vector.<MatchSelectTableRowObj> = DataManager.getInstance().getDP(DataID.GET_ROOM_OPTIONS_ROW_INFO);
         var isHost:Boolean = DataManager.getInstance().getDP(DataID.IS_ROOM_HOST);
         var primaryOptions:Array = DataManager.getInstance().getDP(DataID.LIST_PRIMARY_OPTIONS,[roomObj.currentMatchMode.id]);
         var options:Array = DataManager.getInstance().getDP(DataID.LIST_SUPPORTED_OPTIONS,[roomObj.currentMatchMode.id]);
         this.myAdvancedBtn.visible = options.length > 3;
         this._primaryOptions = [];
         this.myTextField0.text = roomObj.currentMatchMode.name;
         var numOptions:uint = primaryOptions.length;
         var i:uint = 0;
         while(i < 3 && i < numOptions)
         {
            numRows = optionsTableInfo.length;
            for(j = 0; j < numRows; j++)
            {
               if(primaryOptions[i] == optionsTableInfo[j].index)
               {
                  this["myTextField" + (i + 1)].visible = true;
                  this["myComboBox" + i].visible = true;
                  this["myTextField" + (i + 1)].text = optionsTableInfo[j].label;
                  this["myComboBox" + i].enabled = isHost;
                  dataProvider = optionsTableInfo[j].data[0].dataComboBox;
                  numModes = optionsTableInfo[j].data.length;
                  for(d = 1; d < numModes; d++)
                  {
                     if(optionsTableInfo[j].data[d].modeID == roomObj.currentMatchMode.id)
                     {
                        dataProvider = optionsTableInfo[j].data[d].dataComboBox;
                        break;
                     }
                  }
                  this["myComboBox" + i].dataProvider = dataProvider;
                  newPrimaryOption = {};
                  newPrimaryOption.comboBox = this["myComboBox" + i];
                  newPrimaryOption.index = optionsTableInfo[j].index;
                  newPrimaryOption.dataComboBox = dataProvider;
                  this._primaryOptions.push(newPrimaryOption);
               }
            }
            i++;
         }
         for(var m:int = 2; m >= numOptions; m--)
         {
            this["myTextField" + (m + 1)].visible = false;
            this["myComboBox" + m].visible = false;
         }
         this.onUpdateWithBroadcastedRoomInfoHandle();
         EventManager.getInstance().listen(BCEvent.ROOM_INFO_ONLY,this.onUpdateWithBroadcastedRoomInfoHandle);
      }
      
      public function disableData() : void
      {
         EventManager.getInstance().unlisten(BCEvent.ROOM_INFO_ONLY,this.onUpdateWithBroadcastedRoomInfoHandle);
      }
      
      public function onUpdateWithBroadcastedRoomInfoHandle() : void
      {
         var numComboBoxOptions:uint = 0;
         var value:Object = null;
         var k:uint = 0;
         var room:RoomObj = DataManager.getInstance().getDP(DataID.ROOM_INFO);
         var options:RoomOptionObj = room.options;
         this.mSkipComboBoxChangeCallback = true;
         this.mFixClashFOVForHardcore = false;
         var len:uint = this._primaryOptions.length;
         for(var i:uint = 0; i < len; i++)
         {
            switch(this._primaryOptions[i].index)
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
               case CreateRoomOptionsList.GAME_ENABLE_BUDDY_MODE:
                  value = options.gameEnableBuddyMode ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_FORCE_UAV:
                  value = options.gameForceUAV ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_ONLY_HEADSHOTS:
                  value = options.gameOnlyHeadshots ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.RESTRICT_WPNS_AT_START:
                  value = options.restrictWpnsAtStart ? "TRUE" : "FALSE";
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
                  if(options.clashMode == int(ClashPvpUtil.CLASH_MODE_HARDCORE))
                  {
                     this.mFixClashFOVForHardcore = true;
                     this.mClashFOVComboBox = this["myComboBox" + i];
                     this.mLastClashFOV = options.clashFOV;
                     options.clashFOV = int(ClashPvpUtil.CLASH_FOV_FIRSTPERSION);
                  }
                  else if(this.mLastClashFOV != -1)
                  {
                     options.clashFOV = this.mLastClashFOV;
                     this.mLastClashFOV = -1;
                  }
                  value = options.clashFOV;
                  break;
               case CreateRoomOptionsList.DIFFICULTY:
                  value = options.difficulty.toString() + (options.isEndless ? "|" + RoomOptionObj.DIFFICULTY_ENDLESS : "");
                  break;
               case CreateRoomOptionsList.GAME_FORBID_SPAWN_BULLET_WEAPON:
                  value = options.gameForbidSpawnBulletWeapon ? "TRUE" : "FALSE";
                  break;
               case CreateRoomOptionsList.GAME_FORBID_SPAWN_GRENADE:
                  value = options.gameForbidSpawnGrenade ? "TRUE" : "FALSE";
            }
            numComboBoxOptions = uint(this._primaryOptions[i].dataComboBox.length);
            for(k = 0; k < numComboBoxOptions; k++)
            {
               if(this._primaryOptions[i].dataComboBox[k].id == String(value))
               {
                  this._primaryOptions[i].comboBox.selectedIndex = k;
                  this._primaryOptions[i].comboBox.label = this._primaryOptions[i].dataComboBox[k].name;
                  break;
               }
            }
         }
         this.mSkipComboBoxChangeCallback = false;
      }
      
      public function onAdvancedOptionsClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_CREATEROOMOPTION);
      }
      
      public function setOptionsEnabled(isEnabled:Boolean) : void
      {
         this.myComboBox0.enabled = isEnabled;
         this.myComboBox1.enabled = isEnabled;
         this.myComboBox2.enabled = isEnabled;
      }
      
      private function onComboBoxChanged(cEvt:ParaEvent) : void
      {
         var room:RoomObj = null;
         if(this.mSkipComboBoxChangeCallback)
         {
            return;
         }
         cEvt.myPara.label = cEvt.myPara.selectedData.name;
         var len:uint = this._primaryOptions.length;
         for(var i:uint = 0; i < len; i++)
         {
            if(this._primaryOptions[i].dataComboBox == cEvt.myPara.dataProvider)
            {
               room = DataManager.getInstance().getDP(DataID.ROOM_INFO);
               room.options = DataManager.getInstance().getDP(DataID.SET_ROOM_OPTION_VALUE,[room.options,this._primaryOptions[i].index,cEvt.myPara.selectedData.id]);
               EventManager.getInstance().broadcast(BCEvent.CHANGE_ROOM_OPTIONS,room);
               break;
            }
         }
         if(this.mFixClashFOVForHardcore)
         {
            this.mClashFOVComboBox.enabled = false;
         }
      }
   }
}

