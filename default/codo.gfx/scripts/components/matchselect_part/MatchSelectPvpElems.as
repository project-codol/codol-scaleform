package components.matchselect_part
{
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.UIStencils;
   import codo.constants.table.UINotifications;
   import codo.event.ListEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.MatchSelectOptionObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.services.MarketService;
   import codo.utils.AsymPvpUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.MathUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import codo.views.MatchSelectBaseView;
   import com.society.comscore.DAXDispatcher;
   import components.CodoList;
   import components.fsggamemodes_part.MatchSelectSharedInfoItem;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.BarDialogButton;
   import fsg.shared.BarIconButton;
   import fsg.shared.PvpPurchaseRobotButton;
   
   public class MatchSelectPvpElems extends MatchSelectPvElemsBase
   {
      
      protected static var _playlistModesById:Object;
      
      private static const FLOOR:Function = Math.floor;
      
      private static const RANDOM:Function = Math.random;
      
      public static const IDX_NULL:int = -1;
      
      public static const MODE_MIXED_ID:String = "MIXED";
      
      public static const MODE_TRAINING:String = "TRAINING";
      
      public static const MODE_GROUND_WAR:String = "GROUNDWAR";
      
      public static const MODE_DEATH_RAY:String = "DEATHRAY";
      
      public static const MODE_WAR_GOD:String = "WARGOD";
      
      public static const HOT_MODES:Vector.<String> = new <String>[MODE_TRAINING,QuickMatchType.ID_MODE_SEARCH_AND_RESCUE,QuickMatchType.ID_MODE_DEMOLITION,QuickMatchType.ID_BORG,MODE_MIXED_ID];
      
      public static const MODE_GROUND_WAR_PLAYERS:int = 9;
      
      public static const MODE_DEATH_RAY_RULE:String = "mu_deathray 1";
      
      public static const MODE_WAR_GOD_DATA:Object = {
         "id":MODE_WAR_GOD,
         "name":"@SF_UI_MODE_WAR_GOD"
      };
      
      public static const MODE_DATA_BY_PLAYLIST_ID:Object = {
         "_68":MODE_WAR_GOD_DATA,
         "_105":MODE_WAR_GOD_DATA
      };
      
      public var myNumPlaylistMaps:MatchSelectSharedInfoItem;
      
      public var myOpenLevel:MatchSelectSharedInfoItem;
      
      public var myPlayerNumber:MatchSelectSharedInfoItem;
      
      public var myNoProgressSupportTF:TextField;
      
      public var myGameListPanel:CodoList;
      
      public var myCreatePartyBtn:BarIconButton;
      
      public var myStartMatchBtn:BarDialogButton;
      
      public var myDisabledTF:TextField;
      
      public var myAsymPurchase:PvpPurchaseRobotButton;
      
      protected var _view:MatchSelectBaseView;
      
      protected var _onPlaylistInvalidate:Function;
      
      protected var _curPlaylistIdx:int;
      
      public function MatchSelectPvpElems()
      {
         super();
         this.myStartMatchBtn.setText(DictRoom.JOIN);
         this.myStartMatchBtn.registerClickEvent(this.onClickStartPlaylist);
         this.myAsymPurchase.addClickCallback(this.onAsymPurchaseClick);
         this.hideAsymButton();
         if(ScaleformUtil.isScaleform)
         {
            if(DataManager.getDP(DataID.IS_DATA_AVAILABLE) == false)
            {
               this.myAsymPurchase.setMarketReadyMode(false);
               DataManager.bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
            }
         }
         MatchSelectBaseView.SetHeader(this.myGameListPanel,"@SF_UI_MAP_SELECTION");
         this.myNoProgressSupportTF.autoSize = TextFieldAutoSize.LEFT;
         this.myNoProgressSupportTF.text = "@SF_UI_NO_CHALLENGE_PROGRESS_INFO";
         this.myNumPlaylistMaps.itemName = LocalizeUtil.localize("@SF_UI_GAMEMODES_NUM_MAPS");
         this.myOpenLevel.itemName = LocalizeUtil.localize(DictRoom.PLAYLIST_OPEN_AT);
         this.myPlayerNumber.itemName = LocalizeUtil.localize(DictRoom.LIST_LABEL_PLAYER_MIN_MAX);
         var _loc1_:uint = Math.max(this.myNumPlaylistMaps.nameWidth,Math.max(this.myOpenLevel.nameWidth,this.myPlayerNumber.nameWidth));
         myDifficultyList.disableListRightClick = this.myGameListPanel.disableListRightClick = true;
         this.myNumPlaylistMaps.valueXPosition = this.myOpenLevel.valueXPosition = this.myPlayerNumber.valueXPosition = _loc1_ + 30;
         this.myCreatePartyBtn.setText(Dict.CREATE_PARTY);
         this.myCreatePartyBtn.registerClickEvent(this.onShowPartyPanel);
         this.myCreatePartyBtn.visible = ScaleformUtil.isTempContentEnabled_3();
         this.myDisabledTF.text = LocalizeUtil.localize(DictRoom.MATCH_SELECT_DIFFICULTY_NOT_AVAILABILITY_MSG);
         this.myDisabledTF.visible = myDifficultyList.visible = false;
         this.resetSelection();
      }
      
      public static function GetModeDataForPlaylistId(param1:int) : Object
      {
         return MODE_DATA_BY_PLAYLIST_ID["_" + param1];
      }
      
      public function setView(param1:MatchSelectBaseView, param2:Function) : void
      {
         this._view = param1;
         this._onPlaylistInvalidate = param2;
      }
      
      public function resetSelection() : void
      {
         this._curPlaylistIdx = IDX_NULL;
         this.hideAsymButton();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myGameListPanel.setRows(MatchSelectBaseView.LIST_ROWS);
      }
      
      public function set difficultyDisabled(param1:Boolean) : void
      {
         if(param1)
         {
            MatchSelectBaseView.SetHeader(myDifficultyList,DictRoom.ROOM_LEVEL);
            myDifficultyList.setRows(MatchSelectBaseView.LIST_ROWS);
            this.myDisabledTF.visible = myDifficultyList.visible = true;
            myDifficultyList.setListDisabled(true);
         }
         else
         {
            this.myDisabledTF.visible = myDifficultyList.visible = false;
            myDifficultyList.setListDisabled(false);
         }
      }
      
      override public function showView() : void
      {
         super.showView();
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_CLICK,this.onPlaylistSelect);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_ROLLOVER,this.onPlaylistRollOverHandle);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_ROLLOUT,this.onPlaylistRollOutHandle);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_DOUBLE_CLICK,this.onPlaylistDblClick);
         listen(BCEvent.EVT_GAME_DATA_STATE_CHANGE,this.refreshCreatePartyBtn);
         addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         listen(BCEvent.EVT_FULLCLIENT_DOWNLOADED,this.onFullClientDownloaded);
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            this.bind(DataID.IS_IN_PARTY_CHANGED,this.bind_IsInPartyChanged);
         }
      }
      
      override public function hideView() : void
      {
         super.hideView();
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_CLICK,this.onPlaylistSelect);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_ROLLOVER,this.onPlaylistRollOverHandle);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_ROLLOUT,this.onPlaylistRollOutHandle);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_DOUBLE_CLICK,this.onPlaylistDblClick);
         unlisten(BCEvent.EVT_GAME_DATA_STATE_CHANGE,this.refreshCreatePartyBtn);
         removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            this.unbind(DataID.IS_IN_PARTY_CHANGED,this.bind_IsInPartyChanged);
         }
      }
      
      private function bind_IsInPartyChanged(param1:Object) : void
      {
         this.refreshCreatePartyBtn();
      }
      
      private function onFullClientDownloaded(param1:ParaEvent) : void
      {
         this.invalidatePlaylists();
      }
      
      public function getPlaylistModesById() : Object
      {
         var _loc2_:int = 0;
         var _loc3_:PlayListObj = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:ModeObj = null;
         var _loc9_:MatchSelectModeObj = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         if(_playlistModesById != null)
         {
            return _playlistModesById;
         }
         var _loc1_:Array = getDP(DataID.LIST_PLAY_LIST_MP);
         if(_loc1_ == null)
         {
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc4_ = _loc3_.modes;
            _loc7_ = GetModeDataForPlaylistId(_loc3_.index);
            if(_loc7_ != null)
            {
               _loc5_ = _loc7_.id;
               _loc6_ = _loc7_.name;
            }
            else if(_loc3_.type == PlayListType.COMBAT)
            {
               _loc5_ = MODE_TRAINING;
               _loc6_ = "@SF_UI_GAME_TYPE_TRAINING";
            }
            else if(_loc3_.rules.indexOf(MODE_DEATH_RAY_RULE) >= 0)
            {
               _loc5_ = MODE_DEATH_RAY;
               _loc6_ = "@SF_UI_MODE_DEATH_RAY";
            }
            else if(_loc4_.length > 1)
            {
               _loc5_ = MODE_MIXED_ID;
               _loc6_ = "@SF_UI_PLAYLIST_GAMEMODE_MIXED";
            }
            else if(_loc4_.length == 1)
            {
               _loc8_ = _loc4_[0];
               _loc5_ = _loc8_.id;
               _loc6_ = _loc8_.name;
               if(_loc5_ == "war" && _loc3_.maxPartySize == MODE_GROUND_WAR_PLAYERS)
               {
                  _loc5_ = MODE_GROUND_WAR;
                  _loc6_ = "@SF_UI_MODE_GROUND_WAR";
               }
            }
            if(_loc5_ != null)
            {
               if(_playlistModesById == null)
               {
                  _playlistModesById = {};
               }
               _loc9_ = _playlistModesById[_loc5_];
               if(_loc9_ == null)
               {
                  _loc10_ = false;
                  _loc11_ = 0;
                  while(_loc11_ < HOT_MODES.length)
                  {
                     if(_loc5_ == HOT_MODES[_loc11_])
                     {
                        _loc10_ = true;
                        break;
                     }
                     _loc11_++;
                  }
                  _loc9_ = new MatchSelectModeObj(LocalizeUtil.localize(_loc5_),LocalizeUtil.localize(_loc6_),null,false,MatchSelectOptionObj.UNLOCK_LEVEL_NONE,false,_loc10_);
                  _playlistModesById[_loc5_] = _loc9_;
               }
               _loc9_.playlists.push(_loc3_);
            }
            _loc2_++;
         }
         return _playlistModesById;
      }
      
      public function refreshPlaylists(param1:MatchSelectModeObj) : void
      {
         DAXDispatcher.setGameVariant("mp");
         var _loc2_:Array = null;
         var _loc3_:String = "";
         if(param1 != null)
         {
            _loc2_ = param1.playlists;
            _loc3_ = param1.name;
         }
         this._view.setSubtitleText(_loc3_);
         if(_loc2_ == null)
         {
            _loc2_ = [];
         }
         this.myGameListPanel.dataProvider = _loc2_;
         if(this._curPlaylistIdx < 0 || this._curPlaylistIdx >= _loc2_.length)
         {
            this._curPlaylistIdx = 0;
            this.myGameListPanel.selectedIndex = this._curPlaylistIdx;
         }
         this.showPlaylistInfo(this.getSelectedPlaylist(),true);
         this.updateAsymButtonVisibility();
      }
      
      private function refreshCreatePartyBtn() : void
      {
         var _loc1_:Boolean = false;
         if(MarketService.getInstance().isGameDataReady() == false)
         {
            this.myCreatePartyBtn.setUnavailable(true);
         }
         else
         {
            this.myCreatePartyBtn.setUnavailable(false);
            if(this.getSelectedPlaylist() == null)
            {
               return;
            }
            _loc1_ = true;
            _loc1_ &&= this.getSelectedPlaylist().maxPartySize != 0;
            _loc1_ &&= this.getDP(DataID.IS_IN_PARTY) == false;
            this.myCreatePartyBtn.setEnabled(_loc1_);
         }
      }
      
      private function onShowPartyPanel() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_CREATE_PARTY);
         broadcast(BCEvent.EVT_START_GAME_WITH_PARTY,{"data":this.getSelectedPlaylist()});
      }
      
      private function onPlaylistSelect(param1:ListEvent) : void
      {
         var _loc2_:PlayListObj = this.getSelectedPlaylist();
         if(Boolean(_loc2_))
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_PLAYLIST_SELECT,_loc2_.name);
            if(_loc2_.isNew)
            {
               _loc2_.isNew = false;
               broadcast(BCEvent.EVT_UI_NOTIFICATION,{
                  "notification":UINotifications.MP_PLAYLIST + _loc2_.id.toString(),
                  "clean":false
               });
            }
         }
         if(this.myGameListPanel.selectedIndex == this._curPlaylistIdx)
         {
            return;
         }
         this._curPlaylistIdx = this.myGameListPanel.selectedIndex;
         this._view.checkPlaylistHasTutorial(_loc2_.modes);
         this.showPlaylistInfo(_loc2_,true);
         this.updateAsymButtonVisibility();
      }
      
      private function onPlaylistRollOverHandle(param1:ListEvent) : void
      {
         this.showPlaylistInfo(this.getFocusedPlaylist(),false);
      }
      
      private function onPlaylistRollOutHandle(param1:ListEvent = null) : void
      {
         this.showPlaylistInfo(this.getSelectedPlaylist(),false);
      }
      
      private function updateAsymButtonVisibility() : void
      {
         var _loc2_:ModeObj = null;
         var _loc1_:PlayListObj = this.getSelectedPlaylist();
         if(_loc1_ != null)
         {
            for each(_loc2_ in _loc1_.modes)
            {
               if(AsymPvpUtil.instance.isAsymGameMode(_loc2_.id))
               {
                  this.showAsymButton();
                  break;
               }
               this.hideAsymButton();
            }
         }
      }
      
      public function hideAsymButton() : void
      {
         this.myAsymPurchase.visible = false;
      }
      
      public function showAsymButton() : void
      {
         if(!getDP(DataID.IS_ROBOT_PURCHASE_LOCKED))
         {
            this.myAsymPurchase.setImage(PvpPurchaseRobotButton.BUTTON_ICONS[FLOOR(RANDOM() * PvpPurchaseRobotButton.BUTTON_ICONS.length)]);
            this.myAsymPurchase.visible = true;
         }
      }
      
      private function showPlaylistInfo(param1:PlayListObj, param2:Boolean) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:QuickMatchType = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         this.myNumPlaylistMaps.visible = myTextBkg.visible = this._view.myBaseElems.myMissionTitle.visible = myDescriptionTF.visible = this.myOpenLevel.visible = this.myPlayerNumber.visible = myGPXPDisplay.visible = param1 != null;
         if(param1 == null)
         {
            myDescriptionTF.text = "";
            this.myNumPlaylistMaps.itemValue = "";
            this.myOpenLevel.itemValue = "";
            this.myPlayerNumber.itemValue = "";
            myGPXPDisplay.resetDisplayData();
            this._view.setDefaultMapImage();
         }
         else
         {
            _loc3_ = param1.unlockedLevels;
            _loc4_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc4_ += LocalizeUtil.param(DictRoom.PLAYLIST_OPEN_AT_VALUE,[_loc3_[_loc5_].start,_loc3_[_loc5_].end]);
               _loc5_++;
            }
            myDescriptionTF.text = param1.description;
            this.myNumPlaylistMaps.myValueTF.text = param1.maps.length.toString();
            this.myOpenLevel.itemValue = _loc4_;
            if(param1.vsrule == "")
            {
               this.myPlayerNumber.itemValue = param1.minRoomSize + " ~ " + param1.maxRoomSize;
            }
            else
            {
               this.myPlayerNumber.itemValue = param1.vsrule;
            }
            _loc6_ = getDP(DataID.CURRENT_MATCH_TYPE);
            _loc7_ = param1.index == 30 ? uint(PlayListType.GWTRAINING) : param1.type;
            _loc8_ = MathUtil.roundDecimal(param1.xpScale * 100,2);
            _loc9_ = MathUtil.roundDecimal(param1.gpScale * 100,2);
            _loc10_ = CFunctionContainer.AS_GetXPGPScalerForPlaylist(param1.index);
            _loc11_ = Math.round(_loc10_.xpScale * 10) / 10;
            _loc12_ = Math.round(_loc10_.gpScale * 10) / 10;
            _loc13_ = Math.round(_loc10_.firstWinXpScale * 10) / 10;
            _loc14_ = Math.round(_loc10_.firstWinGpScale * 10) / 10;
            _loc15_ = Math.round(_loc10_.partyFirstWinXpScale * 10) / 10;
            _loc16_ = Math.round(_loc10_.partyFirstWinGpScale * 10) / 10;
            myGPXPDisplay.setAndDisplayXPandGPRate(_loc8_,_loc9_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_);
            if(param1.rules.indexOf(MODE_DEATH_RAY_RULE) >= 0)
            {
               this._view.setGamemodeImage("GM_deathray.tga");
            }
            else if(Boolean(param1.modes) && param1.modes.length == 1)
            {
               this._view.setGamemodeImage(param1.modes[0].image);
            }
            else
            {
               this._view.setGamemodeImage("SP_Multi_Gamemode_.tga");
            }
            this.myNoProgressSupportTF.visible = param1.type == PlayListType.COMBAT;
         }
         if(param2)
         {
            this.refreshCreatePartyBtn();
         }
      }
      
      override protected function setMarketReady(param1:Boolean) : void
      {
         this.myAsymPurchase.setMarketReadyMode(param1);
      }
      
      override protected function invalidatePlaylists() : void
      {
         _playlistModesById = null;
         this._onPlaylistInvalidate();
      }
      
      private function startPlaylist() : void
      {
         var _loc1_:PlayListObj = this.getSelectedPlaylist();
         var _loc2_:String = BCEvent.EVT_BOTTOM_START_GAME;
         var _loc3_:Boolean = false;
         if(!this._view.doOpenSummaryPopup(UIStencils.SUMMARY_POPUP_PVP_VIEWED,_loc2_,_loc3_))
         {
            if(Boolean(_loc1_))
            {
               TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_BATTLE_PREP,_loc1_.id.toString());
            }
            broadcast(_loc2_,_loc3_);
         }
      }
      
      private function onClickStartPlaylist() : void
      {
         this.startPlaylist();
      }
      
      private function onPlaylistDblClick(param1:ListEvent) : void
      {
         this.startPlaylist();
      }
      
      protected function getSelectedPlaylist() : PlayListObj
      {
         return this.myGameListPanel.selectedValue as PlayListObj;
      }
      
      protected function getFocusedPlaylist() : PlayListObj
      {
         return this.myGameListPanel.focusedValue as PlayListObj;
      }
      
      private function onAsymPurchaseClick() : void
      {
         broadcast(BCEvent.EVT_TRY_BUY_ASYM_ROBOT,false);
      }
      
      private function bind_dataReceived(param1:Object) : void
      {
         if(param1.result == 1 && param1.data == Common.MARKET_RECEIVED)
         {
            DataManager.unbind(DataID.DATA_RECEIVE,this.bind_dataReceived);
            this.myAsymPurchase.setMarketReadyMode(true);
         }
      }
   }
}

