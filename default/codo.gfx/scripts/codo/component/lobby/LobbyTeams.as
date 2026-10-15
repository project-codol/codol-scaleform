package codo.component.lobby
{
   import codo.base.BaseSubElement;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.objects.PlayListObj;
   import codo.objects.PlayerObj;
   import codo.objects.RankedMatchLobbyUpdateObj;
   import codo.objects.RoomInfoObj;
   import codo.objects.RoomMemberObj;
   import codo.objects.RoomObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class LobbyTeams extends BaseSubElement
   {
      
      private static const VIEW_MODE_NULL:int = -1;
      
      private static const VIEW_MODE_TEAMS:int = 0;
      
      private static const VIEW_MODE_SPECTATOR:int = 1;
      
      private static const TWEEN_DURATION:Number = 0.5;
      
      public var myRequiredPlayersTF:TextField;
      
      public var myRequiredPlayersBG:MovieClip;
      
      public var myRoomDetails:LobbyRoomSizeDetails;
      
      public var myTeamPanel141:LobbyTeamPanel;
      
      public var myTeamPanelScar:LobbyTeamPanel;
      
      public var myTeamPanelSpectator:LobbyTeamPanel;
      
      private var m_currentTeamData:Array;
      
      private var m_teamPanels:Array;
      
      private var m_currentViewMode:int = -1;
      
      private var m_isInIntermission:Boolean = false;
      
      private var m_nonSpectators:int = 0;
      
      private var m_currentPlayers:int = 0;
      
      private var m_minimumPlayers:int = 0;
      
      private var m_maximumPlayers:int = 0;
      
      private var m_forceVisibleState:Array = [false,false,false];
      
      private var m_roomObj:RoomObj;
      
      public function LobbyTeams()
      {
         super();
         this.myTeamPanel141.setTeamId(LobbyConstants.TEAM_TF141);
         this.myTeamPanelScar.setTeamId(LobbyConstants.TEAM_SCAR);
         this.myTeamPanelSpectator.setTeamId(LobbyConstants.TEAM_SPECTATOR);
         this.m_teamPanels = new Array();
         this.m_teamPanels[0] = this.myTeamPanel141;
         this.m_teamPanels[1] = this.myTeamPanelScar;
         this.m_teamPanels[2] = this.myTeamPanelSpectator;
         this.myRequiredPlayersTF.visible = false;
         this.myRequiredPlayersBG.visible = false;
      }
      
      override public function active() : void
      {
         var teamPanel:LobbyTeamPanel = null;
         super.active();
         for each(teamPanel in this.m_teamPanels)
         {
            teamPanel.addEventListener(LobbyConstants.EVENT_TEAM_PANEL_TITLE_CLICK,this.onTeamsPanelClicked);
            teamPanel.addEventListener(LobbyConstants.EVENT_TEAM_JOIN_BUTTON_CLICKED,this.onJoinButtonClicked);
         }
         this.m_isInIntermission = false;
         this.m_currentViewMode = VIEW_MODE_NULL;
         bind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember);
         bind(DataID.ROOM_INFO,this.bind_onSetRoomInfo);
         listen(BCEvent.ROOM_STATE_CHANGED,this.onRoomStateChanged);
         listen(BCEvent.RANKED_MATCH_LOBBY_UPDATE,this.onRankedMatchLobbyUpdate);
      }
      
      override public function deactive() : void
      {
         var teamPanel:LobbyTeamPanel = null;
         super.deactive();
         for each(teamPanel in this.m_teamPanels)
         {
            teamPanel.removeEventListener(LobbyConstants.EVENT_TEAM_PANEL_TITLE_CLICK,this.onTeamsPanelClicked);
            teamPanel.removeEventListener(LobbyConstants.EVENT_TEAM_JOIN_BUTTON_CLICKED,this.onJoinButtonClicked);
         }
         unbind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember);
         unbind(DataID.ROOM_INFO,this.bind_onSetRoomInfo);
         unlisten(BCEvent.ROOM_STATE_CHANGED,this.onRoomStateChanged);
         unlisten(BCEvent.RANKED_MATCH_LOBBY_UPDATE,this.onRankedMatchLobbyUpdate);
      }
      
      public function setTeamPanelVisibility(showTeamPanel141:Boolean, showTeamPaneScar:Boolean, showTeamPanelSpectator:Boolean) : void
      {
         this.myTeamPanel141.visible = showTeamPanel141;
         this.myTeamPanelScar.visible = showTeamPaneScar;
         this.myTeamPanelSpectator.visible = showTeamPanelSpectator;
      }
      
      public function updateMembers(team141Data:Array, teamScarData:Array, teamSpectatorData:Array) : void
      {
         var localPlayerId:String = null;
         var teamId:int = 0;
         this.m_currentTeamData = [team141Data,teamScarData,teamSpectatorData];
         this.myTeamPanel141.updateMembers(team141Data);
         this.myTeamPanelScar.updateMembers(teamScarData);
         this.myTeamPanelSpectator.updateMembers(teamSpectatorData);
         this.updateSelectedMember();
         if(this.m_currentViewMode == VIEW_MODE_NULL)
         {
            localPlayerId = PlayerObj.getObj().id;
            teamId = this.getTeamIdFromMemberId(localPlayerId);
            this.setViewedTeam(teamId,false);
            if(teamId == LobbyConstants.TEAM_TF141)
            {
               broadcast(BCEvent.TEAM_AVATAR,LobbyConstants.TEAM_TF141);
            }
            else if(teamId == LobbyConstants.TEAM_SCAR)
            {
               broadcast(BCEvent.TEAM_AVATAR,LobbyConstants.TEAM_SCAR);
            }
            else if(teamId == LobbyConstants.TEAM_SPECTATOR)
            {
               broadcast(BCEvent.TEAM_AVATAR,LobbyConstants.TEAM_SPECTATOR);
            }
            else if(this.myTeamPanel141.visible)
            {
               broadcast(BCEvent.TEAM_AVATAR,LobbyConstants.TEAM_TF141);
            }
            else if(this.myTeamPanelScar.visible)
            {
               broadcast(BCEvent.TEAM_AVATAR,LobbyConstants.TEAM_SCAR);
            }
            else if(this.myTeamPanelSpectator.visible)
            {
               broadcast(BCEvent.TEAM_AVATAR,LobbyConstants.TEAM_SPECTATOR);
            }
         }
      }
      
      private function updateMemberViewAccess(roomInfoObj:RoomInfoObj) : void
      {
         this.myTeamPanel141.setFriendly(roomInfoObj.isInForce0 || roomInfoObj.isInForce2);
         this.myTeamPanelScar.setFriendly(roomInfoObj.isInForce1 && !roomInfoObj.isInForce2);
         this.myTeamPanelSpectator.setFriendly(roomInfoObj.isInForce2);
         this.myTeamPanel141.switchEnableViewMember(roomInfoObj.isInForce0);
         this.myTeamPanelScar.switchEnableViewMember(roomInfoObj.isInForce1);
         this.myTeamPanelSpectator.switchEnableViewMember(roomInfoObj.isInForce2);
         if(!this.m_roomObj)
         {
            return;
         }
         var setting:WarGodGlobalSettingObj = getDP(DataID.WARGOD_GLOBAL_SETTING);
         var playlistObj:PlayListObj = getDP(DataID.PLAY_LIST_OBJ,[this.m_roomObj.playListID]);
         if(this.m_roomObj.isPlayList && playlistObj.index == setting.playlistId)
         {
            this.myTeamPanel141.switchEnableViewPlayerName(roomInfoObj.isInForce0);
            this.myTeamPanelScar.switchEnableViewPlayerName(roomInfoObj.isInForce1);
         }
         else
         {
            this.myTeamPanel141.switchEnableViewPlayerName(true);
            this.myTeamPanelScar.switchEnableViewPlayerName(true);
         }
      }
      
      public function setJoinButtonState(teamId:int, isEnabled:Boolean, isVisible:Boolean) : void
      {
         if(teamId == LobbyConstants.TEAM_TF141)
         {
            this.myTeamPanel141.setJoinButtonState(isEnabled,isVisible);
         }
         if(teamId == LobbyConstants.TEAM_SCAR)
         {
            this.myTeamPanelScar.setJoinButtonState(isEnabled,isVisible);
         }
         if(teamId == LobbyConstants.TEAM_SPECTATOR)
         {
            this.myTeamPanelSpectator.setJoinButtonState(isEnabled,isVisible);
         }
      }
      
      private function setViewedTeam(teamId:int, shouldAnimate:Boolean) : void
      {
         var viewMode:int = VIEW_MODE_NULL;
         if(teamId == LobbyConstants.TEAM_TF141 || teamId == LobbyConstants.TEAM_SCAR)
         {
            viewMode = VIEW_MODE_TEAMS;
         }
         else if(teamId == LobbyConstants.TEAM_SPECTATOR)
         {
            viewMode = VIEW_MODE_SPECTATOR;
         }
         if(this.m_currentViewMode == viewMode)
         {
            return;
         }
         this.m_currentViewMode = viewMode;
         if(this.m_currentViewMode == VIEW_MODE_TEAMS)
         {
            this.myTeamPanel141.setExpanded(true,shouldAnimate);
            this.myTeamPanelScar.setExpanded(true,shouldAnimate);
            this.myTeamPanelSpectator.setExpanded(false,shouldAnimate);
         }
         else if(this.m_currentViewMode == VIEW_MODE_SPECTATOR)
         {
            this.myTeamPanel141.setExpanded(false,shouldAnimate);
            this.myTeamPanelScar.setExpanded(false,shouldAnimate);
            this.myTeamPanelSpectator.setExpanded(true,shouldAnimate);
         }
         this.updatePanelOffsets(shouldAnimate);
      }
      
      private function updatePanelOffsets(shouldAnimate:Boolean) : void
      {
         var teamPanel:LobbyTeamPanel = null;
         var currentOffset:int = 25;
         for each(teamPanel in this.m_teamPanels)
         {
            if(teamPanel.visible)
            {
               if(shouldAnimate)
               {
                  TweenLite.to(teamPanel,TWEEN_DURATION,{"y":currentOffset});
               }
               else
               {
                  TweenLite.killTweensOf(teamPanel);
                  teamPanel.y = currentOffset;
               }
               if(teamPanel.m_isExpanded)
               {
                  currentOffset += teamPanel.m_ExpandedHeight;
               }
               else
               {
                  currentOffset += teamPanel.m_CollapsedHeight;
               }
            }
         }
      }
      
      private function onTeamsPanelClicked(event:Event) : void
      {
         var teamId:int = LobbyConstants.TEAM_SPECTATOR;
         if(event.currentTarget == this.myTeamPanel141)
         {
            teamId = LobbyConstants.TEAM_TF141;
         }
         else if(event.currentTarget == this.myTeamPanelScar)
         {
            teamId = LobbyConstants.TEAM_SCAR;
         }
         this.setViewedTeam(teamId,true);
      }
      
      private function onJoinButtonClicked(event:Event) : void
      {
         var teamId:int = LobbyConstants.TEAM_SPECTATOR;
         if(event.currentTarget == this.myTeamPanel141)
         {
            teamId = LobbyConstants.TEAM_TF141;
         }
         else if(event.currentTarget == this.myTeamPanelScar)
         {
            teamId = LobbyConstants.TEAM_SCAR;
         }
         this.setViewedTeam(teamId,true);
         this.broadcast(BCEvent.CHANGE_TEAM,teamId);
      }
      
      private function bind_onSetCurrentlySelectedTeamMember(cRes:Object) : void
      {
         var teamPanel:LobbyTeamPanel = null;
         var selectedTeamMemberID:String = cRes.data;
         var teamID:int = this.getTeamIdFromMemberId(selectedTeamMemberID);
         if(teamID == -1)
         {
            return;
         }
         this.setViewedTeam(teamID,true);
         for each(teamPanel in this.m_teamPanels)
         {
            teamPanel.updateSelectedState(selectedTeamMemberID);
         }
      }
      
      private function bind_onSetRoomInfo(cRes:Object) : void
      {
         if(cRes.data == null)
         {
            return;
         }
         var roomObj:RoomObj = cRes.data;
         this.m_roomObj = roomObj;
         if(roomObj == null)
         {
            return;
         }
         var roomInfoObj:RoomInfoObj = roomObj.forces;
         var ShowPartyMemberTag:Boolean = roomObj.currentMatchMode.isDMZ && !roomObj.currentMatchMode.isTDMZ;
         this.myTeamPanel141.switchShowPartyMemberTag(ShowPartyMemberTag);
         this.myTeamPanelScar.switchShowPartyMemberTag(ShowPartyMemberTag);
         var onlyOneTeam:Boolean = roomInfoObj.showForce0 != roomInfoObj.showForce1;
         this.myTeamPanel141.unnamedTitle = this.myTeamPanelScar.unnamedTitle = onlyOneTeam;
         if(onlyOneTeam && roomObj.currentMaxPlayers > RoomObj.PLAYER_MAX_NUM / 2)
         {
            this.myTeamPanel141.setPanelHeight(LobbyTeamPanel.MEMBER_LIST_TYPE_FULL);
            this.myTeamPanelScar.setPanelHeight(LobbyTeamPanel.MEMBER_LIST_TYPE_FULL);
         }
         else
         {
            this.myTeamPanel141.setPanelHeight(LobbyTeamPanel.MEMBER_LIST_TYPE_TEAM);
            this.myTeamPanelScar.setPanelHeight(LobbyTeamPanel.MEMBER_LIST_TYPE_TEAM);
         }
         this.m_nonSpectators = roomInfoObj.force0.length + roomInfoObj.force1.length;
         this.m_currentPlayers = roomObj.currentPlayers;
         this.m_minimumPlayers = roomObj.currentMinPlayers;
         this.m_maximumPlayers = roomObj.currentMaxPlayers;
         this.setTeamPanelVisibility(roomInfoObj.showForce0,roomInfoObj.showForce1,this.hasSpectator(roomObj));
         this.setJoinButtonState(LobbyConstants.TEAM_TF141,roomObj.forces.enableChangeForce0,roomObj.forces.showChangeForceBtn);
         this.setJoinButtonState(LobbyConstants.TEAM_SCAR,roomObj.forces.enableChangeForce1,roomObj.forces.showChangeForceBtn);
         this.setJoinButtonState(LobbyConstants.TEAM_SPECTATOR,roomObj.forces.enableChangeForce2,roomObj.forces.showChangeForceBtn);
         if(this.m_forceVisibleState[0] != roomInfoObj.showForce0 || this.m_forceVisibleState[1] != roomInfoObj.showForce1 || this.m_forceVisibleState[2] != !roomObj.isPlayList)
         {
            this.m_forceVisibleState[0] = roomInfoObj.showForce0;
            this.m_forceVisibleState[1] = roomInfoObj.showForce1;
            this.m_forceVisibleState[2] = !roomObj.isPlayList;
            this.m_currentViewMode = VIEW_MODE_NULL;
         }
         this.updateMemberViewAccess(roomInfoObj);
         this.updateMembers(roomInfoObj.force0,roomInfoObj.force1,roomInfoObj.force2);
         this.updateLobbyStatusText();
      }
      
      private function getTeamIdFromMemberId(memberId:String) : int
      {
         var member:RoomMemberObj = null;
         loop0:
         for(var i:int = 0; i < this.m_currentTeamData.length; )
         {
            var _loc4_:int = 0;
            var _loc5_:* = this.m_currentTeamData[i];
            do
            {
               for each(member in _loc5_)
               {
               }
               i++;
               continue loop0;
            }
            while(member.id != memberId);
            return member.team;
         }
         return -1;
      }
      
      private function updateSelectedMember() : void
      {
         var teamPanel:LobbyTeamPanel = null;
         var selectedTeamMemberID:String = "0";
         var curRoomMemberObj:RoomMemberObj = getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ);
         if(curRoomMemberObj != null)
         {
            selectedTeamMemberID = curRoomMemberObj.id;
         }
         for each(teamPanel in this.m_teamPanels)
         {
            teamPanel.updateSelectedState(selectedTeamMemberID);
         }
      }
      
      private function updateLobbyStatusText() : void
      {
         var tooManySpectator:String = null;
         this.myRoomDetails.update(this.m_currentPlayers,this.m_maximumPlayers);
         if(this.m_isInIntermission)
         {
            this.myRequiredPlayersTF.visible = true;
            this.myRequiredPlayersBG.visible = true;
            this.myRequiredPlayersTF.text = LocalizeUtil.localize("@SF_UI_INTERMISSION");
         }
         else if(this.m_nonSpectators < this.m_minimumPlayers)
         {
            this.myRequiredPlayersTF.visible = true;
            this.myRequiredPlayersBG.visible = true;
            this.myRequiredPlayersTF.text = LocalizeUtil.param("@SF_UI_X_MORE_PLAYERS_REQUIRED",[this.m_minimumPlayers - this.m_nonSpectators]);
            if(this.m_currentPlayers == this.m_maximumPlayers)
            {
               tooManySpectator = "\n" + LocalizeUtil.localize("@SF_UI_TOO_MANY_SPECTATORS");
               this.myRequiredPlayersTF.appendText(tooManySpectator);
            }
         }
         else
         {
            this.myRequiredPlayersTF.visible = false;
            this.myRequiredPlayersBG.visible = false;
         }
      }
      
      private function onRoomStateChanged(parameterEvent:ParaEvent) : void
      {
         var roomInfoObj:RoomInfoObj = parameterEvent.myPara.forces;
         this.updateMembers(roomInfoObj.force0,roomInfoObj.force1,roomInfoObj.force2);
         this.updateMemberViewAccess(roomInfoObj);
         this.setJoinButtonState(LobbyConstants.TEAM_TF141,roomInfoObj.enableChangeForce0,roomInfoObj.showChangeForceBtn);
         this.setJoinButtonState(LobbyConstants.TEAM_SCAR,roomInfoObj.enableChangeForce1,roomInfoObj.showChangeForceBtn);
         this.setJoinButtonState(LobbyConstants.TEAM_SPECTATOR,roomInfoObj.enableChangeForce2,roomInfoObj.showChangeForceBtn);
         this.updateLobbyStatusText();
      }
      
      private function onRankedMatchLobbyUpdate(parameterEvent:ParaEvent) : void
      {
         var lobbyUpdateObj:RankedMatchLobbyUpdateObj = parameterEvent.myPara as RankedMatchLobbyUpdateObj;
         this.m_isInIntermission = false;
         if(lobbyUpdateObj.intermissionElapsedTime > 0 && lobbyUpdateObj.intermissionElapsedTime < lobbyUpdateObj.intermissionTotalTime)
         {
            this.m_isInIntermission = true;
         }
         this.updateLobbyStatusText();
      }
      
      private function hasSpectator(roomObj:RoomObj) : Boolean
      {
         return roomObj.enableSpectator;
      }
   }
}

