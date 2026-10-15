package components.matchselect_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.UIStencils;
   import codo.constants.table.UINotifications;
   import codo.event.ListEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.objects.MatchSelectDifficultyObj;
   import codo.objects.MatchSelectOptionObj;
   import codo.objects.PlayListObj;
   import codo.services.MarketService;
   import codo.services.MatchService;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.MathUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import codo.views.MatchSelectBaseView;
   import com.society.comscore.DAXDispatcher;
   import components.CodoList;
   import components.fsggamemodes_part.MatchSelectSharedInfoItem;
   import components.fsggamemodes_part.pve.PveViewRandomRewardButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.shared.BarDialogButton;
   import fsg.shared.BarIconButton;
   import fsg.shared.PveTokenCounter;
   
   public class MatchSelectPveElems extends MatchSelectPvElemsBase
   {
      
      private static const DIFFICULTY_UNLIMTED_SURVIVAL_INDEX:uint = 3;
      
      public static const IDX_NULL:int = -1;
      
      public static const DIFFICULTY_UNKNOWN:String = "?";
      
      public var myRepairKits:PveTokenCounter;
      
      public var myTokens:PveTokenCounter;
      
      public var myOpenLevel:MatchSelectSharedInfoItem;
      
      public var myPlayerNumber:MatchSelectSharedInfoItem;
      
      public var myRandomRewardButton:PveViewRandomRewardButton;
      
      public var myGameListPanel:CodoList;
      
      public var myCreatePartyBtn:BarIconButton;
      
      public var myStartMatchBtn:BarDialogButton;
      
      protected var _view:MatchSelectBaseView;
      
      protected var _curDifficultyIdx:int;
      
      protected var _curPlaylistIdx:int;
      
      private var _dpMatchType:QuickMatchType = new QuickMatchType();
      
      private var _difficultiesData:Array;
      
      public function MatchSelectPveElems()
      {
         super();
         this.myStartMatchBtn.setText(DictRoom.JOIN);
         this.myStartMatchBtn.registerClickEvent(this.onClickStart);
         MatchSelectBaseView.SetHeader(myDifficultyList,DictRoom.ROOM_LEVEL);
         MatchSelectBaseView.SetHeader(this.myGameListPanel,"@SF_UI_MAP_SELECTION");
         this.myOpenLevel.itemName = LocalizeUtil.localize(DictRoom.PLAYLIST_OPEN_AT).toUpperCase();
         this.myPlayerNumber.itemName = LocalizeUtil.localize(DictRoom.LIST_LABEL_PLAYER_MIN_MAX).toUpperCase();
         var _loc1_:uint = Math.max(this.myOpenLevel.nameWidth,this.myPlayerNumber.nameWidth);
         this.myOpenLevel.valueXPosition = this.myPlayerNumber.valueXPosition = _loc1_ + 30;
         myDifficultyList.disableListRightClick = this.myGameListPanel.disableListRightClick = true;
         this.myCreatePartyBtn.setText(Dict.CREATE_PARTY);
         this.myCreatePartyBtn.registerClickEvent(this.onShowPartyPanel);
         this.resetSelection();
         if(!ScaleformUtil.isScaleform)
         {
            this.showTokens();
            this.setMarketReady(true);
         }
      }
      
      public function setView(param1:MatchSelectBaseView) : void
      {
         this._view = param1;
      }
      
      public function resetSelection() : void
      {
         this._curDifficultyIdx = IDX_NULL;
         this._curPlaylistIdx = IDX_NULL;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myGameListPanel.setRows(MatchSelectBaseView.LIST_ROWS);
         myDifficultyList.setRows(MatchSelectBaseView.LIST_ROWS);
         this.myGameListPanel.doubleClickEnabled = true;
         this.myRepairKits.setImage("item_repair_kit_icon.tga");
         this.myRepairKits.addClickCallback(this.onRepairKitsClick);
         this.myTokens.addClickCallback(this.onTokensClick);
         this.myCreatePartyBtn.visible = ScaleformUtil.isTempContentEnabled_3();
         this.myRandomRewardButton.addClickCallback(this.onClickMapRewards);
      }
      
      override public function showView() : void
      {
         super.showView();
         myDifficultyList.addEventListener(CodoList.EVT_LINE_CLICK,this.onDifficultySelect);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_CLICK,this.onPlaylistSelect);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_ROLLOVER,this.onPlaylistRollOverHandle);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_ROLLOUT,this.onPlaylistRollOutHandle);
         this.myGameListPanel.addEventListener(CodoList.EVT_LINE_DOUBLE_CLICK,this.onListItemDoubleClickHandle);
         listen(BCEvent.EVT_GAME_DATA_STATE_CHANGE,this.refreshCreatePartyBtn);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.showTokens);
         if(Boolean(getDP(DataID.IS_DATA_AVAILABLE)))
         {
            this.setMarketReady(true);
         }
         addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         listen(BCEvent.EVT_FULLCLIENT_DOWNLOADED,this.onFullClientDownloaded);
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            this.bind(DataID.IS_IN_PARTY_CHANGED,this.bind_IsInPartyChanged);
         }
         this.showTokens();
      }
      
      private function showTokens() : void
      {
         var _loc1_:uint = 2;
         var _loc2_:uint = 612;
         var _loc3_:uint = ScaleformUtil.isScaleform ? uint(CFunctionCommonContainer.GetCyborgTokenCount()) : 21;
         var _loc4_:int = this.myTokens.updateCount(_loc3_);
         this.myTokens.x = _loc2_ - this.myTokens.width;
         _loc3_ = ScaleformUtil.isScaleform ? uint(CFunctionCommonContainer.GetInventoryCount("repair_kit")) : 31;
         this.myRepairKits.updateCount(_loc3_);
         this.myRepairKits.x = this.myTokens.x - (this.myRepairKits.width - Math.abs(_loc4_)) - _loc1_;
      }
      
      override public function hideView() : void
      {
         super.hideView();
         myDifficultyList.removeEventListener(CodoList.EVT_LINE_CLICK,this.onDifficultySelect);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_CLICK,this.onPlaylistSelect);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_ROLLOVER,this.onPlaylistRollOverHandle);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_ROLLOUT,this.onPlaylistRollOutHandle);
         this.myGameListPanel.removeEventListener(CodoList.EVT_LINE_DOUBLE_CLICK,this.onListItemDoubleClickHandle);
         unlisten(BCEvent.EVT_GAME_DATA_STATE_CHANGE,this.refreshCreatePartyBtn);
         unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.showTokens);
         removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            this.unbind(DataID.IS_IN_PARTY_CHANGED,this.bind_IsInPartyChanged);
         }
      }
      
      override protected function setMarketReady(param1:Boolean) : void
      {
         this.myRandomRewardButton.setMarketReadyMode(param1);
         this.myRepairKits.setMarketReadyMode(param1);
         this.myTokens.setMarketReadyMode(param1);
         this.refreshCreatePartyBtn();
      }
      
      private function bind_IsInPartyChanged(param1:Object) : void
      {
         this.refreshCreatePartyBtn();
      }
      
      private function onFullClientDownloaded(param1:ParaEvent) : void
      {
         this.invalidatePlaylists();
      }
      
      private function refreshCreatePartyBtn() : void
      {
         if(this.myCreatePartyBtn != null)
         {
            if(MarketService.getInstance().isGameDataReady() == false)
            {
               this.myCreatePartyBtn.setUnavailable(true);
            }
            else
            {
               this.myCreatePartyBtn.setUnavailable(false);
               this.myCreatePartyBtn.setEnabled(this.getSelectedPlaylist() != null && this.getSelectedPlaylist().maxPartySize != 0 && this.getSelectedPlaylist().maxPartySize != 1 && this.getDP(DataID.IS_IN_PARTY) == false);
            }
         }
      }
      
      private function onPlaylistSelect(param1:ListEvent) : void
      {
         var cEvt:ListEvent = param1;
         var playlistObj:PlayListObj = this.getSelectedPlaylist();
         if(Boolean(playlistObj) && playlistObj.isNew)
         {
            playlistObj.isNew = false;
            broadcast(BCEvent.EVT_UI_NOTIFICATION,{
               "notification":UINotifications.MP_PLAYLIST + playlistObj.id.toString(),
               "clean":false
            });
         }
         if(this.myGameListPanel.selectedIndex == this._curPlaylistIdx)
         {
            return;
         }
         this._curPlaylistIdx = this.myGameListPanel.selectedIndex;
         this.showPlaylistInfo(playlistObj,true);
         this._view.checkPlaylistHasTutorial(playlistObj.modes);
         if(playlistObj != null)
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_PLAYLIST_SELECT,playlistObj.name);
         }
         try
         {
            DAXDispatcher.DIFFICULTY_LEVEL = String(playlistObj.leagueID);
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      private function onShowPartyPanel() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_CREATE_PARTY);
         broadcast(BCEvent.EVT_START_GAME_WITH_PARTY,{"data":this.getSelectedPlaylist()});
      }
      
      private function onListItemDoubleClickHandle(param1:ListEvent) : void
      {
         this.startGame();
      }
      
      private function onPlaylistRollOverHandle(param1:ListEvent) : void
      {
         this.showPlaylistInfo(this.getFocusedPlaylist(),false);
      }
      
      private function onPlaylistRollOutHandle(param1:ListEvent = null) : void
      {
         this.showPlaylistInfo(this.getSelectedPlaylist(),false);
      }
      
      private function showPlaylistInfo(param1:PlayListObj, param2:Boolean) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:QuickMatchType = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:uint = 0;
         this._view.myBaseElems.myImgSlider.visible = myDescriptionTF.visible = this.myOpenLevel.visible = this.myPlayerNumber.visible = myGPXPDisplay.visible = param1 != null;
         if(param1 == null)
         {
            myDescriptionTF.text = "";
            this.myOpenLevel.itemValue = "";
            this.myPlayerNumber.itemValue = "";
            myGPXPDisplay.resetDisplayData();
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
            _loc6_ = "";
            if(this._dpMatchType.isSurvival())
            {
               _loc6_ = PlayListType.SURVIVAL_IMAGE;
            }
            else if(this._dpMatchType.isEvac())
            {
               _loc6_ = PlayListType.EVACUATION_IMAGE;
            }
            else if(this._dpMatchType.isDeathmarch())
            {
               _loc6_ = PlayListType.DEATHMARCH_IMAGE;
            }
            else if(this._dpMatchType.isGunship())
            {
               _loc6_ = PlayListType.CHOPPER_GUNNER_IMAGE;
            }
            else if(this._dpMatchType.isCyborgs())
            {
               _loc6_ = PlayListType.CYBORG_IMAGE;
            }
            this._view.setGamemodeImage(_loc6_);
            this.myOpenLevel.itemValue = _loc4_;
            if(param1.vsrule == "")
            {
               this.myPlayerNumber.itemValue = param1.minRoomSize + " ~ " + param1.maxRoomSize;
            }
            else
            {
               this.myPlayerNumber.itemValue = param1.vsrule;
            }
            _loc7_ = getDP(DataID.CURRENT_MATCH_TYPE);
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
            _loc17_ = param1.type;
            if(param1.isUnlimitedSurvival)
            {
               _loc17_ = uint(PlayListType.UNLIMITED_SURVIVAL);
            }
            broadcast(BCEvent.EVT_SET_PLAYLIST_TYPE,_loc17_);
         }
         if(param2)
         {
            this.refreshCreatePartyBtn();
         }
      }
      
      private function startGame() : void
      {
         var _loc1_:PlayListObj = this.getSelectedPlaylist();
         var _loc2_:String = BCEvent.EVT_SHOW_TOKEN_BUY_POPUP;
         if(!this._view.doOpenSummaryPopup(UIStencils.SUMMARY_POPUP_PVE_VIEWED,_loc2_))
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_BATTLE_PREP,_loc1_.id.toString());
            broadcast(_loc2_);
         }
      }
      
      private function onClickStart() : void
      {
         this.startGame();
      }
      
      private function onClickMapRewards() : void
      {
         broadcast(BCEvent.EVT_SHOW_MAP_REWARDS,{"index":0});
      }
      
      protected function onDifficultySelect(param1:ListEvent) : void
      {
         if(myDifficultyList.selectedIndex == this._curDifficultyIdx)
         {
            return;
         }
         this._curDifficultyIdx = myDifficultyList.selectedIndex;
         this._curPlaylistIdx = IDX_NULL;
         this.refreshPlaylists();
      }
      
      public function onModeSelected(param1:MatchSelectOptionObj) : void
      {
         this._view.setSubtitleText(param1.name);
         var _loc2_:QuickMatchType = getDP(DataID.CURRENT_MATCH_TYPE);
         DAXDispatcher.setGameVariantByType(_loc2_);
         this.refreshDifficulties();
      }
      
      public function refreshDifficulties() : void
      {
         var _loc1_:QuickMatchType = getDP(DataID.CURRENT_MATCH_TYPE);
         this.myRepairKits.visible = false;
         if(_loc1_.isGunship())
         {
            this.myRepairKits.visible = true;
         }
         var _loc2_:Array = this.getDifficultiesData();
         if(_loc2_ == null)
         {
            _loc2_ = [];
         }
         myDifficultyList.dataProvider = _loc2_;
         var _loc3_:Sprite = myDifficultyList.getChildByName("myQuickPlayBG") as Sprite;
         var _loc4_:MovieClip = myDifficultyList.getChildByName("myItemRenderer") as MovieClip;
         var _loc5_:uint = _loc4_.height;
         _loc3_.height = _loc4_.y + _loc5_ * _loc2_.length;
         if(this._curDifficultyIdx < 0 || this._curDifficultyIdx >= _loc2_.length)
         {
            this._curDifficultyIdx = 0;
            myDifficultyList.selectedIndex = this._curDifficultyIdx;
         }
         this.refreshPlaylists();
      }
      
      private function getDifficultiesData() : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:PlayListObj = null;
         var _loc9_:int = 0;
         var _loc10_:MatchSelectDifficultyObj = null;
         var _loc1_:QuickMatchType = getDP(DataID.CURRENT_MATCH_TYPE);
         if(this._dpMatchType != _loc1_)
         {
            this._difficultiesData = null;
         }
         if(this._difficultiesData == null || this._difficultiesData.length == 0)
         {
            this._dpMatchType = _loc1_;
            _loc3_ = [];
            if(this._dpMatchType.isSurvival())
            {
               _loc3_ = getDP(DataID.LIST_PLAY_LIST_SURVIVAL);
            }
            else if(this._dpMatchType.isEvac())
            {
               _loc3_ = getDP(DataID.LIST_PLAY_LIST_EVAC);
            }
            else if(this._dpMatchType.isDeathmarch())
            {
               _loc3_ = getDP(DataID.LIST_PLAY_LIST_EVAC_DEATHMARCH);
            }
            else if(this._dpMatchType.isCyborgs())
            {
               _loc3_ = getDP(DataID.LIST_PLAY_LIST_CYBORG);
            }
            else if(this._dpMatchType.isGunship())
            {
               _loc3_ = getDP(DataID.LIST_PLAY_LIST_CHOPPER_GUNNER);
            }
            for each(_loc4_ in _loc3_)
            {
               _loc6_ = Boolean(_loc4_.unlocked);
               _loc7_ = _loc4_.unlockFlag;
               if(_loc7_.length > 0)
               {
                  _loc6_ &&= Boolean(CFunctionContainer.IsFlagUnlocked(_loc7_,1));
               }
               _loc4_.unlocked = _loc6_;
            }
            _loc5_ = [];
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               _loc8_ = _loc3_[_loc2_];
               _loc9_ = _loc8_.leagueID;
               _loc8_.isUnlimitedSurvival = MatchService.getInstance().getIsPlayListUnlimitedSurvival(_loc8_);
               if(_loc8_.isUnlimitedSurvival)
               {
                  _loc9_ = int(DIFFICULTY_UNLIMTED_SURVIVAL_INDEX);
               }
               if(_loc5_.length <= _loc9_)
               {
                  _loc5_.length = _loc9_ + 1;
               }
               if(_loc5_[_loc9_] == null)
               {
                  _loc5_[_loc9_] = [];
               }
               _loc5_[_loc9_].push(_loc8_);
               _loc2_++;
            }
            this._difficultiesData = [];
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length)
            {
               if(_loc5_[_loc2_] != null)
               {
                  _loc10_ = new MatchSelectDifficultyObj();
                  _loc10_.playlists = _loc5_[_loc2_];
                  if(_loc2_ >= 0 && _loc2_ < DictRoom.ROOM_LEVELS.length)
                  {
                     _loc10_.name = DictRoom.ROOM_LEVELS[_loc2_];
                  }
                  else
                  {
                     _loc10_.name = DIFFICULTY_UNKNOWN;
                  }
                  this._difficultiesData.push(_loc10_);
               }
               _loc2_++;
            }
         }
         return this._difficultiesData;
      }
      
      protected function refreshPlaylists() : void
      {
         var _loc1_:Array = this.getCurDifficultyPlaylists();
         if(_loc1_ == null)
         {
            _loc1_ = [];
         }
         this.myGameListPanel.dataProvider = _loc1_;
         if(this._curPlaylistIdx < 0 || this._curPlaylistIdx >= _loc1_.length)
         {
            this._curPlaylistIdx = 0;
            this.myGameListPanel.selectedIndex = this._curPlaylistIdx;
         }
         this.showPlaylistInfo(this.getSelectedPlaylist(),true);
      }
      
      protected function getCurDifficultyPlaylists() : Array
      {
         var _loc1_:MatchSelectDifficultyObj = this.getSelectedDifficulty();
         if(_loc1_ != null)
         {
            return _loc1_.playlists;
         }
         return null;
      }
      
      override protected function invalidatePlaylists() : void
      {
         this._difficultiesData = null;
         if(isActive)
         {
            this.refreshDifficulties();
         }
      }
      
      private function onRepairKitsClick() : void
      {
         broadcast(BCEvent.EVT_TRY_BUY_REPAIR_KIT);
      }
      
      private function onTokensClick() : void
      {
         broadcast(BCEvent.EVT_TRY_BUY_TOKEN);
      }
      
      protected function getSelectedPlaylist() : PlayListObj
      {
         return this.myGameListPanel.selectedValue as PlayListObj;
      }
      
      protected function getFocusedPlaylist() : PlayListObj
      {
         return this.myGameListPanel.focusedValue as PlayListObj;
      }
      
      protected function getSelectedDifficulty() : MatchSelectDifficultyObj
      {
         return myDifficultyList.selectedValue as MatchSelectDifficultyObj;
      }
   }
}

