package codo.views.persistentView_parts
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.component.CloseButton;
   import codo.component.InfoButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.constants.PlayListType;
   import codo.event.ParaEvent;
   import codo.localization.DictWarGod;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.ItemBanObj;
   import codo.objects.PlayListObj;
   import codo.objects.RoomObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlaylistObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class MatchMakingStripView extends BaseView
   {
      
      private static const DOT_ANIMATION_INTERVAL:int = 500;
      
      private static const DOT_ANIMATION_COUNT:int = 3;
      
      private static const X_POS:int = 1475;
      
      private static const Y_POS:int = 984;
      
      private static const LABEL_BUTTON_GAP:int = 10;
      
      private static const READY_WAY_UNDEFINED:int = 0;
      
      private static const READY_WAY_WAIT_WHILE:int = 1;
      
      private static const READY_WAY_IMMEDIATE:int = 2;
      
      private static const READY_WAIT_DURATION:int = 15000;
      
      public var myPlaylistName:TextField;
      
      public var myLabel:TextField;
      
      public var myRestrictBtn:InfoButton;
      
      public var myCancelBtn:CloseButton;
      
      public var myBg:MovieClip;
      
      public var myDevPanel:MovieClip;
      
      private var mDotTimer:Timer;
      
      private var mDotTimerCounter:int;
      
      private var mIsHost:Boolean;
      
      private var mReadyWay:int;
      
      private var mReadyTimer:Timer;
      
      private var mShowBanPopup:Boolean;
      
      private var isInHiddenRoom:Boolean;
      
      private var isPanelAvailable:Boolean;
      
      public function MatchMakingStripView()
      {
         var devPanelClass:Class = null;
         super();
         this.mDotTimer = new Timer(DOT_ANIMATION_INTERVAL);
         this.myCancelBtn.registerClickEvent(this.onCancelButtonClicked);
         this.myRestrictBtn.registerClickEvent(this.onRestictButtonClicked);
         this.setLabelTFPosition();
         x = X_POS;
         y = Y_POS;
         this.isInHiddenRoom = false;
         this.isPanelAvailable = false;
         if(ScaleformUtil.isScaleform)
         {
            devPanelClass = getDefinitionByName("codo.component.lobby.lobbyDevPanel") as Class;
            if(Boolean(devPanelClass))
            {
               this.myDevPanel = new devPanelClass() as MovieClip;
               addChild(this.myDevPanel);
               this.myDevPanel.x = 0;
               this.myDevPanel.y = 0 - this.myDevPanel.height;
               this.myDevPanel.initListener();
            }
            this.myDevPanel.visible = false;
         }
         this.mIsHost = false;
         this.mReadyWay = READY_WAY_UNDEFINED;
         this.mShowBanPopup = true;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.isPanelAvailable = true;
         this.updateVisibility();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.isPanelAvailable = false;
         this.updateVisibility();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         bind(DataID.ROOM_INFO,this.bindRoomInfo);
         listen(BCEvent.EVT_ENTER_HIDDEN_ROOM_COMPLETE,this.onEnterRoomComplete);
         this.mDotTimer.addEventListener(TimerEvent.TIMER,this.onDotAnimationTicked);
         this.mDotTimerCounter = 0;
         this.mDotTimer.start();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataID.ROOM_INFO,this.bindRoomInfo);
         unlisten(BCEvent.EVT_ENTER_HIDDEN_ROOM_COMPLETE,this.onEnterRoomComplete);
         this.mDotTimer.removeEventListener(TimerEvent.TIMER,this.onDotAnimationTicked);
         this.mDotTimer.stop();
      }
      
      private function setLabelTFPosition() : void
      {
         var labelStr:String = LocalizeUtil.localize(DictWarGod.MATCH_MAKING) + "...";
         this.myLabel.text = labelStr;
         this.myLabel.width = this.myLabel.textWidth + 5;
         this.myLabel.x = this.myRestrictBtn.x - this.myLabel.textWidth - LABEL_BUTTON_GAP;
      }
      
      private function bindRoomInfo(cRes:Object) : void
      {
         var roomObj:RoomObj = null;
         if(null != cRes.data)
         {
            this.isInHiddenRoom = false;
            roomObj = cRes.data;
            if(!this.isInHiddenRoom && this.showWarGodHiddenRoomInfo(roomObj))
            {
               this.isInHiddenRoom = true;
            }
            if(!this.isInHiddenRoom && this.showBattleCityLeagueHiddenRoomInfo(roomObj))
            {
               this.isInHiddenRoom = true;
            }
            this.checkReadyState(roomObj);
            if(ScaleformUtil.isScaleform)
            {
               if(this.mIsHost != roomObj.forces.isHost)
               {
                  this.mIsHost = roomObj.forces.isHost;
               }
               this.myDevPanel.visible = this.mIsHost && Boolean(getDP(DataID.IS_DEV_BUILD));
            }
         }
         else
         {
            this.mShowBanPopup = true;
            this.isInHiddenRoom = false;
            this.mReadyWay = READY_WAY_UNDEFINED;
            this.resetReadyTimer();
         }
         this.updateVisibility();
      }
      
      private function updateVisibility() : void
      {
         this.visible = this.isPanelAvailable && this.isInHiddenRoom;
      }
      
      private function checkReadyState(roomObj:RoomObj) : void
      {
         if(!this.isInHiddenRoom)
         {
            return;
         }
         var playlist:PlayListObj = getDP(DataID.PLAY_LIST_OBJ,[roomObj.playListID]);
         if(this.mReadyWay != READY_WAY_UNDEFINED)
         {
            return;
         }
         if(playlist.type != PlayListType.COMBAT)
         {
            Logger.print("Combat training, this is not combat training, ignore.");
            return;
         }
         if(roomObj.currentPlayers == 1)
         {
            Logger.print("Combat training choose to wait for a while.");
            this.chooseWaitWhileToReady();
            return;
         }
         if(roomObj.currentPlayers > 1)
         {
            Logger.print("Combat training get ready immediately.");
            this.chooseReadyImmediate();
            return;
         }
      }
      
      private function chooseWaitWhileToReady() : void
      {
         this.mReadyWay = READY_WAY_WAIT_WHILE;
         this.mReadyTimer = new Timer(READY_WAIT_DURATION);
         this.mReadyTimer.addEventListener(TimerEvent.TIMER,this.onReadyTimerTickHandler);
         this.mReadyTimer.start();
      }
      
      private function onReadyTimerTickHandler(timerEvent:TimerEvent) : void
      {
         this.resetReadyTimer();
         this.getReady();
      }
      
      private function resetReadyTimer() : void
      {
         if(null == this.mReadyTimer)
         {
            return;
         }
         this.mReadyTimer.stop();
         this.mReadyTimer.reset();
         this.mReadyTimer.removeEventListener(TimerEvent.TIMER,this.onReadyTimerTickHandler);
      }
      
      private function chooseReadyImmediate() : void
      {
         this.mReadyWay = READY_WAY_IMMEDIATE;
         this.getReady();
      }
      
      private function onEnterRoomComplete(para:ParaEvent) : void
      {
         var listData:Vector.<Object> = null;
         var i:int = 0;
         var equippedBans:Vector.<ItemBanObj> = CFunctionContainer.GetItemBanEquippedList();
         var numEquippedBans:uint = equippedBans.length;
         if(numEquippedBans > 0 && getDP(DataID.CURRENT_BACKGROUND_POPUP_PAGE_ID) != PageID.FSG_MATCHRESULT && this.mShowBanPopup)
         {
            listData = new Vector.<Object>();
            for(i = 0; i < numEquippedBans; i++)
            {
               listData.push(equippedBans[i]);
            }
            broadcast(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS_WARNING,listData);
            this.mShowBanPopup = false;
         }
      }
      
      private function onCancelButtonClicked() : void
      {
         broadcast(BCEvent.LEAVE_ROOM,{"isUserInput":true});
      }
      
      private function onRestictButtonClicked() : void
      {
         broadcast(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS,new Vector.<Object>());
      }
      
      private function getReady() : void
      {
         Logger.print("WarGod combat training playlist getting ready.");
         broadcast(BCEvent.CHANGE_READY_STATE);
      }
      
      private function onDotAnimationTicked(e:TimerEvent) : void
      {
         var labelStr:String = LocalizeUtil.localize(DictWarGod.MATCH_MAKING);
         for(var i:int = 0; i < this.mDotTimerCounter; i++)
         {
            labelStr += ".";
         }
         this.myLabel.text = labelStr;
         if(++this.mDotTimerCounter > DOT_ANIMATION_COUNT)
         {
            this.mDotTimerCounter = 0;
         }
      }
      
      private function showWarGodHiddenRoomInfo(roomObj:RoomObj) : Boolean
      {
         var wargodPlaylistWrapper:WarGodPlaylistObj = null;
         var juniorWarGodPlayList:Array = null;
         var i:int = 0;
         var isInWarGodRoom:Boolean = roomObj.isWarGod;
         var wargodSetting:WarGodGlobalSettingObj = getDP(DataID.WARGOD_GLOBAL_SETTING);
         var seasonObj:WarGodSeasonObj = getDP(DataID.CURRENT_WARGOD_INFO);
         var roomPlaylistNum:int = roomObj.playListID;
         var roomPlaylistID:int = CFunctionContainer.AS_GetPlayListIdForNum(roomPlaylistNum);
         var streakBreakHostPlaylistID:int = CFunctionContainer.AS_GetStreakBreakHostPlaylistId(roomPlaylistID);
         if(0 != streakBreakHostPlaylistID)
         {
            roomPlaylistID = streakBreakHostPlaylistID;
         }
         var warGodWarmRoundHostPlaylistID:int = CFunctionContainer.AS_GetWarGodWarmRoundHostPlaylistId(roomPlaylistID);
         if(0 != warGodWarmRoundHostPlaylistID)
         {
            roomPlaylistID = warGodWarmRoundHostPlaylistID;
         }
         if(roomPlaylistID == wargodSetting.playlistId)
         {
            this.myRestrictBtn.visible = true;
            this.myPlaylistName.text = LocalizeUtil.param(DictWarGod.SENIOR_WARGOD_DESCRIPTION_LABEL,[seasonObj.name]);
         }
         else
         {
            this.myRestrictBtn.visible = false;
            wargodPlaylistWrapper = getDP(DataID.GET_JUNIOR_WARGOD_MATCHMAKING_PLAYLIST);
            juniorWarGodPlayList = wargodPlaylistWrapper.playlist;
            for(i = 0; i < juniorWarGodPlayList.length; i++)
            {
               if(juniorWarGodPlayList[i].id == roomPlaylistID)
               {
                  this.myPlaylistName.text = LocalizeUtil.param(DictWarGod.MATCH_MAKING_LABEL,[juniorWarGodPlayList[i].label]);
                  break;
               }
            }
         }
         return isInWarGodRoom;
      }
      
      private function showBattleCityLeagueHiddenRoomInfo(roomObj:RoomObj) : Boolean
      {
         var playlist:PlayListObj = null;
         var battleCityLeagueSetting:BattleCityLeagueGlobalObj = getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         var roomPlaylistNum:int = roomObj.playListID;
         var roomPlaylistID:int = CFunctionContainer.AS_GetPlayListIdForNum(roomPlaylistNum);
         var isBattleCityLeague:Boolean = false;
         for(var i:int = 0; i < battleCityLeagueSetting.playlist.length; i++)
         {
            if(battleCityLeagueSetting.playlist[i] == roomPlaylistID)
            {
               isBattleCityLeague = true;
               break;
            }
         }
         if(isBattleCityLeague)
         {
            playlist = getDP(DataID.PLAY_LIST_OBJ,[roomPlaylistNum]);
            this.myPlaylistName.text = playlist.name;
         }
         return isBattleCityLeague;
      }
   }
}

