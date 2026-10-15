package codo.component.matchselect
{
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.GlobalBottomBtnStatus;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.cpp.UiCppView;
   import codo.cpp.UiCppViewPanel;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.utils.AsymPvpUtil;
   import codo.utils.MathUtil;
   import codo.utils.TLogUtil;
   import com.society.comscore.DAXDispatcher;
   
   public class MatchSelectPVPPanel2 extends MatchSelectPanelBase2
   {
      
      public var myAsymPurchaseButton:AsymPurchaseButton;
      
      public function MatchSelectPVPPanel2()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         myGameTypeHeader.text = Dict.MATCH_SELECT_MENU_OPTION_PVP;
         this.myAsymPurchaseButton.myLabel.fontSize = 28;
         this.myAsymPurchaseButton.height = 60;
         this.myAsymPurchaseButton.width = 309;
         this.myAsymPurchaseButton.registerClickEvent(this.onAsymPurchaseClick);
         myMissionHeader.text = DictRoom.PLAYLIST;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DAXDispatcher.setGameVariant("mp");
         var matchType:QuickMatchType = QuickMatchType.makePvp();
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,matchType);
         DataManager.getInstance().addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppViewPanel(this);
      }
      
      override public function onModeSelect() : void
      {
         super.onModeSelect();
         this.switchShowModeInfo(false);
      }
      
      public function onTypeSelect(showRoomLoadInfo:Boolean = false) : void
      {
         var bottomStartStatus:uint = 0;
         var tlogBtn:int = 0;
         bottomStartStatus = GlobalBottomBtnStatus.STATUS_IDLE_MP_PLAYLIST_CHOOSE;
         tlogBtn = int(ButtonTLog.BUTTON_GAMEMODE_QUICK_MATCH_MENU);
         TLogUtil.TLog_UserInput(tlogBtn);
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_BOTTOM_START_STATUS,bottomStartStatus);
      }
      
      public function onMatchDisplay(mode:uint, match:uint, isSelection:Boolean) : void
      {
         this.showPlaylistInfo(mode,match,isSelection);
      }
      
      private function showPlaylistInfo(mode:uint, match:uint, isSelection:Boolean) : void
      {
         var cDat:PlayListObj = null;
         var modeObj:MatchSelectModeObj = null;
         var curMode:ModeObj = null;
         var numXPRate:Number = NaN;
         var numGPRate:Number = NaN;
         var xpgpBonusInfoObj:Object = null;
         var xpScale:Number = NaN;
         var gpScale:Number = NaN;
         var firstWinXPScale:Number = NaN;
         var firstWinGPScale:Number = NaN;
         var partyFirstWinXPScale:Number = NaN;
         var partyFirstWinGPScale:Number = NaN;
         if(mode < myLeftList.listData.length)
         {
            modeObj = myLeftList.listData[mode] as MatchSelectModeObj;
            if(match < modeObj.playlists.length)
            {
               cDat = modeObj.playlists[match];
            }
         }
         if(cDat == null)
         {
            return;
         }
         this.switchShowModeInfo(true);
         this.arrangePartyButton(cDat);
         myModeInfo.setModeName(cDat.name);
         myModeInfo.setGameName(modeObj.name);
         myModeInfo.setMaps(cDat.maps,getTutorialVideos(cDat));
         myModeInfo.setNumMaps(cDat);
         myModeInfo.setOpenLevel(cDat);
         if(cDat.vsrule == "")
         {
            myModeInfo.setPlayerLimit(playerRangeString(cDat.minRoomSize,cDat.maxRoomSize));
         }
         else
         {
            myModeInfo.setPlayerLimit(cDat.vsrule);
         }
         this.myAsymPurchaseButton.visible = false;
         for each(curMode in cDat.modes)
         {
            if(this.checkShowAsymButton(curMode.id))
            {
               break;
            }
         }
         myModeInfo.setModeDescription(cDat.description);
         myModeInfo.showNoLevelProgressWarning(cDat.type == PlayListType.COMBAT);
         numXPRate = MathUtil.roundDecimal(cDat.xpScale * 100,2);
         numGPRate = MathUtil.roundDecimal(cDat.gpScale * 100,2);
         xpgpBonusInfoObj = CFunctionContainer.AS_GetXPGPScalerForPlaylist(cDat.index);
         xpScale = Math.round(xpgpBonusInfoObj.xpScale * 10) / 10;
         gpScale = Math.round(xpgpBonusInfoObj.gpScale * 10) / 10;
         firstWinXPScale = Math.round(xpgpBonusInfoObj.firstWinXpScale * 10) / 10;
         firstWinGPScale = Math.round(xpgpBonusInfoObj.firstWinGpScale * 10) / 10;
         partyFirstWinXPScale = Math.round(xpgpBonusInfoObj.partyFirstWinXpScale * 10) / 10;
         partyFirstWinGPScale = Math.round(xpgpBonusInfoObj.partyFirstWinGpScale * 10) / 10;
         myModeInfo.setXPandGPRate(numXPRate,numGPRate,xpScale,gpScale,firstWinXPScale,firstWinGPScale,partyFirstWinXPScale,partyFirstWinGPScale);
         myModeInfo.setOnboardBonus(cDat);
      }
      
      private function checkShowAsymButton(modeID:String) : Boolean
      {
         if(AsymPvpUtil.instance.isAsymGameMode(modeID))
         {
            if(!DataManager.getInstance().getDP(DataID.IS_ROBOT_PURCHASE_LOCKED))
            {
               this.myAsymPurchaseButton.visible = true;
               return true;
            }
         }
         return false;
      }
      
      override protected function onStartMatch() : void
      {
         super.onStartMatch();
         this.startPlaylist();
      }
      
      public function getSelectedPlaylist() : PlayListObj
      {
         return myMiddleList.selectedData as PlayListObj;
      }
      
      private function startPlaylist() : void
      {
         var playlistObj:PlayListObj = this.getSelectedPlaylist();
         var broadcastEvent:String = BCEvent.EVT_BOTTOM_START_GAME;
         var needBuyAsymRobotPopup:Boolean = false;
         if(Boolean(playlistObj))
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_BATTLE_PREP,playlistObj.id.toString());
         }
         EventManager.getInstance().broadcast(broadcastEvent,needBuyAsymRobotPopup);
      }
      
      override protected function arrangePartyButton(playlist:PlayListObj) : void
      {
         super.arrangePartyButton(playlist);
         if(myPartyButton.visible)
         {
            this.myAsymPurchaseButton.x = myPartyButton.x - 6 - this.myAsymPurchaseButton.width;
         }
         else
         {
            this.myAsymPurchaseButton.x = myConfirmButton.x - 6 - this.myAsymPurchaseButton.width;
         }
      }
      
      override protected function setMarketReady(ready:Boolean) : void
      {
         super.setMarketReady(ready);
         this.myAsymPurchaseButton.setMarketReadyMode(ready);
      }
      
      private function onAsymPurchaseClick() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_TRY_BUY_ASYM_ROBOT,false);
      }
      
      override protected function switchShowModeInfo(isShow:Boolean) : void
      {
         super.switchShowModeInfo(isShow);
         this.myAsymPurchaseButton.visible = isShow;
      }
   }
}

