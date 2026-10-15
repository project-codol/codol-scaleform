package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.ChattingChannelType;
   import codo.constants.DataID;
   import codo.constants.InvitationType;
   import codo.constants.MsgBtnCount;
   import codo.constants.RankedMatchStatus;
   import codo.event.ParaEvent;
   import codo.localization.DictAAS;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.objects.ChatMessageObj;
   import codo.objects.InvitationObj;
   import codo.objects.PartyInvitationObj;
   import codo.objects.PartyMemberObj;
   import codo.objects.PartyObj;
   import codo.objects.ResultObj;
   import codo.objects.TimeObj;
   import codo.objects.UserObj;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.StringUtil;
   import codo.utils.TimeUtil;
   
   public class PartyController extends BaseController
   {
      
      private static const MAX_PARTY_CANDIDATE_ALLOWED:int = 9;
      
      private var _partyInfo:PartyObj = new PartyObj();
      
      private var _isPartyJoinNotified:Boolean = false;
      
      private var _selectedPlayer:Array = [];
      
      private var _partyInviteeQueue:Vector.<Object> = new Vector.<Object>();
      
      private var _everSendProposalSuccess:Boolean = false;
      
      private var _invitationFetched:Boolean = false;
      
      private var _invitationGoingToAccept:PartyInvitationObj;
      
      public function PartyController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.IS_IN_PARTY,this.isInParty);
         addDP(DataID.IS_PARTY_HOST,this.isPartyHost);
         addDP(DataID.IS_IN_MY_PARTY,this.isInMyParty);
         addDP(DataID.IS_SELECTED_PARTY_PLAYER,this.isSelectedPlayer);
         addDP(DataID.PARTY_INFO,this.getPartyInfo);
         addDP(DataID.PLAYER_QUERY_PARTY,this.getMemberData);
         addDP(DataID.MAX_PARTY_CANDIDATE_ALLOWED,this.getMaxPartyCandidateAllowed);
         addDP(DataID.GET_PARTY_XP_BUFF,this.getPartyXPBuff);
         addDP(DataID.IS_PARTY_MEMBER_ALL_IN_ROOM,this.getIsPartyMemberAllInRoom);
         listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandler);
         listen(BCEvent.EVT_KICK_PARTY_MEMBER,this.onKickPartyMemberHandle);
         listen(BCEvent.EVT_PROMOTE_PARTY_MEMBER,this.onPromotePartyMemberHandle);
         listen(BCEvent.EVT_PROPOSE_PARTY_MEMBERSHIP,this.onProposePartyMembershipHandle);
         listen(BCEvent.EVT_ACCEPT_PARTY_MEMBERSHIP,this.onAcceptPartyMembershipHandle);
         listen(BCEvent.EVT_REJECT_PARTY_MEMBERSHIP,this.onRejectPartyMembershipHandle);
         listen(BCEvent.EVT_ADD_SELECT_PARTY_PLAYER,this.onAddSelectPlayer);
         listen(BCEvent.EVT_REMOVE_SELECT_PARTY_PLAYER,this.onRemoveSelectPlayer);
         listen(BCEvent.EVT_CLEAN_ALL_SELECT_PARTY_PLAYER,this.onCleanAllSelectPartyPlayer);
         listen(BCEvent.PARTY_CREATE,this.onCreatePartyHandle);
         listen(BCEvent.PARTY_JOIN,this.onJoinPartyHandle);
         listen(BCEvent.PARTY_LEAVE,this.onLeavePartyHandle);
         listen(BCEvent.TRY_OPEN_PARTY,this.onTryOpenPartyHandle);
         listen(BCEvent.EVT_CLOSE_PARTY,this.onCloseParty);
         bind(DataID.LEAVE_PARTY,this.onLeaveParty);
      }
      
      public function cppSendPartyEventLogInvitationSent(from:String, inviteeName:String) : void
      {
         this.sendNotification(DictParty.NOTE_INVITE_NEW_PARTY_MEMBER,[from,inviteeName]);
      }
      
      public function cppSendPartyEventLogInvitationRefused(invitee:String, isReject:Boolean) : void
      {
         if(isReject)
         {
            this.sendNotification(DictParty.NOTE_PARTY_INVITE_REJECTED,[invitee]);
         }
         else
         {
            this.sendNotification(DictParty.NOTE_PARTY_INVITE_TIMEOUT,[invitee]);
         }
      }
      
      public function cppSetPartyInvitations(invitations:Array) : void
      {
         Logger.print("Update party invitation list. cppSetPartyInvitations",invitations.length);
         this._invitationFetched = true;
         setBindData(DataID.PARTY_INVITATION,invitations);
      }
      
      public function cppSetExpiredPartyInvitations(expiredInvitations:Array) : void
      {
         var expiredPartyInvitation:PartyInvitationObj = null;
         var time:TimeObj = null;
         var whenMiss:String = null;
         var invitation:InvitationObj = null;
         for(var i:int = 0; i < expiredInvitations.length; i++)
         {
            expiredPartyInvitation = expiredInvitations[i];
            time = CFunctionCommonContainer.GetFormatTimeByTimeStamp(int(expiredPartyInvitation.timeStamp));
            whenMiss = StringUtil.zeroPad(time.hour,2) + ":" + StringUtil.zeroPad(time.min,2);
            invitation = new InvitationObj();
            invitation.title = DictParty.MISS_PARTY_TITLE;
            invitation.message = LocalizeUtil.param(DictParty.MISS_PARTY_INVITATION,[whenMiss,expiredPartyInvitation.senderName]);
            invitation.type = InvitationType.EXPIRE_PARTY_INVITATION;
            invitation.targetName = DictAAS.AAS_SYSTEM;
            invitation.senderName = DictAAS.AAS_SYSTEM;
            invitation.formattedTime = TimeUtil.now();
            invitation.isLog = true;
            broadcast(BCEvent.ADD_NEW_INVITATION,invitation);
         }
      }
      
      public function cppSetPartyInfo(info:Object) : void
      {
         if(info == null)
         {
            return;
         }
         this._partyInfo.id = info.id;
         this._partyInfo.description = info.description;
         this._partyInfo.size = info.size;
         this._partyInfo.type = info.type;
         this._partyInfo.partyDLCLevel = info.partyDLCLevel;
         this.refreshParty();
      }
      
      public function cppOnBeingKicked() : void
      {
         showMsg(DictParty.NOTE_YOU_ARE_KICKED_FROM_PARTY,MsgBtnCount.ONE);
      }
      
      public function cppSetPartyMembers(members:Array) : void
      {
         var partyMember:PartyMemberObj = null;
         if(members == null)
         {
            return;
         }
         Logger.print("PartyController::cppSetPartyMembers",members.length);
         this.notifyWhoJoinWhoLeave(members);
         this._partyInfo.members.splice(0);
         for(var i:int = 0; i < members.length; i++)
         {
            partyMember = new PartyMemberObj();
            this.fillPartyMemberObj(partyMember,members[i]);
            if(partyMember.isHost)
            {
               this.checkAndNotifyIfHostIsChanged(partyMember.id,partyMember.name);
            }
            this._partyInfo.members.push(partyMember);
         }
         if(this._partyInfo.members.length > 1)
         {
            this._partyInfo.members.sortOn(["isHost","name"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         }
         this.onPartyStateChanged();
         this.refreshParty();
      }
      
      public function cppSetPendingPartyMembers(members:Array) : void
      {
         Logger.print("Update pendingPartyMembers in cppSetPendingPartyMembers",members.length);
         setBindData(DataID.PARTY_PENDING_MEMBER,members);
      }
      
      private function onPlayerStatsReadyHandler(cEvt:ParaEvent) : void
      {
         if(this._invitationFetched == false)
         {
            CFunctionContainer.FetchPartyInvitation();
         }
      }
      
      private function checkAndNotifyIfHostIsChanged(hostId:String, hostName:String) : void
      {
         if(this._partyInfo.hostId != hostId)
         {
            if(this._partyInfo.hostId != "")
            {
               this.sendNotification(DictParty.NOTE_PARTY_HOST_CHANGED,[hostName]);
            }
            this._partyInfo.hostId = hostId;
         }
      }
      
      private function notifyWhoJoinWhoLeave(members:Array) : void
      {
         var i:int = 0;
         var whoJoin:Array = new Array();
         var whoLeave:Array = new Array();
         this.getWhoJoinWhoLeave(members,whoJoin,whoLeave);
         for(i = 0; i < whoJoin.length; i++)
         {
            this.sendNotification(DictParty.NOTE_PARTY_NEW_MEMBER,[whoJoin[i].name]);
         }
         for(i = 0; i < whoLeave.length; i++)
         {
            this.sendNotification(DictParty.NOTE_PARTY_MEMBER_LEFT,[whoLeave[i].name]);
         }
      }
      
      private function getWhoJoinWhoLeave(newMembers:Array, whoJoin:Array, whoLeave:Array) : void
      {
         var i:int = 0;
         var j:int = 0;
         var exist:Boolean = false;
         if(this._partyInfo.members.length == 0)
         {
            return;
         }
         var oldMembers:Array = this._partyInfo.members;
         var numOldMembers:int = int(oldMembers.length);
         var numNewMembers:int = int(newMembers.length);
         for(i = 0; i < numNewMembers; i++)
         {
            exist = false;
            for(j = 0; j < numOldMembers; j++)
            {
               if(newMembers[i].id == oldMembers[j].id)
               {
                  exist = true;
                  break;
               }
            }
            if(!exist)
            {
               whoJoin.push(newMembers[i]);
            }
         }
         for(i = 0; i < numOldMembers; i++)
         {
            exist = false;
            for(j = 0; j < numNewMembers; j++)
            {
               if(oldMembers[i].id == newMembers[j].id)
               {
                  exist = true;
                  break;
               }
            }
            if(!exist)
            {
               whoLeave.push(oldMembers[i]);
            }
         }
      }
      
      private function refreshParty() : void
      {
         if(this.isPartyReady())
         {
            if(!this._isPartyJoinNotified)
            {
               this._isPartyJoinNotified = true;
               broadcast(BCEvent.PARTY_JOINED,this._partyInfo);
               setBindData(DataID.IS_IN_PARTY_CHANGED,true);
            }
            setBindData(DataID.PARTY_INFO,this._partyInfo);
         }
      }
      
      private function isPartyReady() : Boolean
      {
         return this._partyInfo.id.length > 0 && this._partyInfo.members.length > 0;
      }
      
      private function onCloseParty(cEvt:ParaEvent) : void
      {
         prevPage();
      }
      
      private function onLeaveParty(cRes:Object) : void
      {
         this._isPartyJoinNotified = false;
         this._partyInfo.id = "";
         this._partyInfo.description = "";
         this._partyInfo.size = 0;
         this._partyInfo.type = 0;
         this._partyInfo.hostId = "";
         this._partyInfo.members.splice(0);
         this.clearSelectPlayer();
         broadcast(BCEvent.PARTY_LEFT);
         setBindData(DataID.IS_IN_PARTY_CHANGED,false);
         this.onPartyStateChanged();
         if(cRes.resultMsg != null && cRes.resultMsg.length > 0)
         {
            showMsg(cRes.resultMsg,MsgBtnCount.ONE);
         }
         else if(Boolean(this._invitationGoingToAccept))
         {
            request(DataID.JOIN_PARTY,this._invitationGoingToAccept);
            this._invitationGoingToAccept = null;
         }
      }
      
      private function onKickPartyMemberHandle(cEvt:ParaEvent) : void
      {
         CFunctionContainer.KickPartyMember(cEvt.myPara.id);
      }
      
      private function onPromotePartyMemberHandle(cEvt:ParaEvent) : void
      {
         CFunctionContainer.PromotePartyMember(cEvt.myPara.id);
      }
      
      private function onProposePartyMembershipHandle(cEvt:ParaEvent) : void
      {
         if(this._partyInfo.members.length >= this._partyInfo.size)
         {
            showMsg(DictParty.NOTE_PARTY_MAX_MEMBERS,MsgBtnCount.ONE);
            return;
         }
         if(Boolean(getDP(DataID.IS_IN_ROOM)) || Boolean(getDP(DataID.IS_IN_RANKED_MATCH)))
         {
            showMsg(DictParty.PARTY_CANT_INVITE_PARTY_IN_ROOM_OR_RANKED_MATCH,MsgBtnCount.ONE);
            return;
         }
         var invitees:Array = cEvt.myPara;
         if(invitees == null)
         {
            invitees = this._selectedPlayer;
         }
         var inviteesLen:int = int(invitees.length);
         this._partyInviteeQueue.length = 0;
         for(var i:int = 0; i < inviteesLen; i++)
         {
            this._partyInviteeQueue.push(invitees[i]);
         }
         if(this._partyInviteeQueue.length > 0)
         {
            this._everSendProposalSuccess = false;
            this.checkPartyInviteeCandidate();
         }
         this.notifyMyInvitation(invitees);
      }
      
      private function checkPartyInviteeCandidate() : void
      {
         this.inviteFriend();
      }
      
      private function inviteFriend() : void
      {
         CFunctionCommonContainer.Assert(this._partyInviteeQueue.length > 0,new Error());
         var candidate:Object = this._partyInviteeQueue[0];
         CFunctionContainer.ProposePartyMembership(candidate.id);
         this._everSendProposalSuccess = true;
         this.finishCheckACandidate();
      }
      
      private function finishCheckACandidate() : void
      {
         CFunctionCommonContainer.Assert(this._partyInviteeQueue.length > 0,new Error());
         this._partyInviteeQueue.shift();
         if(this._partyInviteeQueue.length > 0)
         {
            this.checkPartyInviteeCandidate();
         }
         else if(this._everSendProposalSuccess)
         {
            broadcast(BCEvent.PARTY_INVITATION_SENT);
         }
         this._everSendProposalSuccess = false;
      }
      
      private function notifyMyInvitation(invitees:Array) : void
      {
         CFunctionContainer.NotifyMyPartyInvitation(invitees);
      }
      
      private function onAcceptPartyMembershipHandle(cEvt:ParaEvent) : void
      {
         var invitation:PartyInvitationObj = null;
         if(Boolean(getDP(DataID.IS_IN_ROOM)))
         {
            if(Boolean(CFunctionContainer.AS_IsHiddenRoomMatch()))
            {
               showMsg(DictParty.HIDDEN_ROOM_MATCH_MAKING_IN_PROGRESS,MsgBtnCount.ONE);
            }
            else
            {
               showMsg(DictParty.PARTY_CANT_ACCEPT_PARTY_IN_ROOM,MsgBtnCount.ONE);
            }
            return;
         }
         if(Boolean(getDP(DataID.IS_IN_PARTY)))
         {
            this.leaveParty();
            this._invitationGoingToAccept = cEvt.myPara as PartyInvitationObj;
         }
         else
         {
            invitation = cEvt.myPara as PartyInvitationObj;
            request(DataID.JOIN_PARTY,invitation);
         }
      }
      
      private function onRejectPartyMembershipHandle(cEvt:ParaEvent) : void
      {
         var invitation:PartyInvitationObj = cEvt.myPara as PartyInvitationObj;
         CFunctionContainer.RejectPartyMembership(invitation.senderID,invitation.ticketID);
      }
      
      private function onCreatePartyHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(getDP(DataID.IS_IN_RANKED_MATCH)))
         {
            showMsg(DictParty.PARTY_CANT_CREATE_PARTY_IN_RANK_PROGRESS,MsgBtnCount.ONE);
            return;
         }
         if(Boolean(getDP(DataID.IS_IN_ROOM)))
         {
            showMsg(DictParty.PARTY_CANT_CREATE_PARTY_IN_ROOM,MsgBtnCount.ONE);
            return;
         }
         if(!this.isInParty())
         {
            this.createParty();
         }
      }
      
      private function createParty() : void
      {
         if(!this.isInParty())
         {
            request(DataID.CREATE_PARTY,null,this.onPartyJoined);
         }
      }
      
      private function onJoinPartyHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(getDP(DataID.IS_IN_ROOM)))
         {
            showMsg(Boolean(getDP(DataID.IS_IN_RANKED_MATCH)) ? DictRoom.NOTE_ALREADY_IN_RANKED_MATCH : DictRoom.NOTE_ALREADY_IN_ROOM,MsgBtnCount.ONE);
            return;
         }
         request(DataID.JOIN_PARTY,cEvt.myPara,this.onPartyJoined);
      }
      
      private function onLeavePartyHandle(cEvt:ParaEvent) : void
      {
         var isInRoom:Boolean = getDP(DataID.IS_IN_ROOM);
         var isInRankedMatch:Boolean = getDP(DataID.IS_IN_RANKED_MATCH);
         var canLeave:Boolean = !isInRoom && !isInRankedMatch;
         var customizeMsg:String = cEvt.myPara as String;
         if(canLeave)
         {
            showMsg(customizeMsg != null ? customizeMsg : DictParty.LEAVE_PARTY_CONFIRM,MsgBtnCount.TWO,0,this.leaveParty);
         }
         else if(isInRankedMatch)
         {
            showMsg(DictParty.LEAVE_PARTY_CONFIRM_IN_RANKED_MATCH,MsgBtnCount.ONE);
         }
         else
         {
            showMsg(DictParty.LEAVE_PARTY_CONFIRM_IN_ROOM,MsgBtnCount.ONE);
         }
      }
      
      private function leaveParty() : void
      {
         if(getDP(DataID.CURRENT_RANKED_MATCH_STATUS) != RankedMatchStatus.IDLE)
         {
            broadcast(BCEvent.LEAVE_ROOM);
         }
         else
         {
            request(DataID.LEAVE_PARTY);
         }
      }
      
      private function sendNotification(msg:String, param:Array = null) : void
      {
         var msgObj:ChatMessageObj = new ChatMessageObj();
         msgObj.channelID = ChattingChannelType.PARTY;
         msgObj.senderName = LocalizeUtil.localize(DictAAS.AAS_SYSTEM);
         msgObj.isNew = true;
         msgObj.message = param != null && param.length != 0 ? LocalizeUtil.param(msg,param) : msg;
         msgObj.isSystem = true;
         broadcast(BCEvent.EVT_CHAT_MSG_FROM_SYSTEM,msgObj);
      }
      
      private function isInParty() : Boolean
      {
         return CFunctionContainer.IsInParty() as Boolean;
      }
      
      private function isPartyHost() : Boolean
      {
         return this.isInParty() && CFunctionContainer.IsPartyHost() as Boolean;
      }
      
      private function isInMyParty(cUser:Object) : Boolean
      {
         return DataUtil.isInArray(cUser.id,this._partyInfo.members);
      }
      
      private function isSelectedPlayer(user:Object) : Boolean
      {
         return -1 != this.indexOfSelectedPlayer(user);
      }
      
      private function indexOfSelectedPlayer(player:Object) : int
      {
         var numSelectedPlayer:int = int(this._selectedPlayer.length);
         for(var i:int = 0; i < numSelectedPlayer; i++)
         {
            if(this._selectedPlayer[i].id == player.id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function onAddSelectPlayer(evt:ParaEvent) : void
      {
         var player:Object = null;
         var addSuccess:Boolean = false;
         var addedMemberList:Array = evt.myPara;
         var everAdded:Boolean = false;
         for(var i:int = 0; i < addedMemberList.length; i++)
         {
            player = addedMemberList[i];
            addSuccess = this.realAddSelectPlayer(player);
            everAdded = addSuccess || everAdded;
         }
         if(everAdded)
         {
            setBindData(DataID.PARTY_SELECTED_CANDIDATE,this._selectedPlayer);
         }
      }
      
      private function onRemoveSelectPlayer(evt:ParaEvent) : void
      {
         var player:Object = null;
         var removeSuccess:Boolean = false;
         var removedMemberList:Array = evt.myPara;
         var everRemoved:Boolean = false;
         for(var i:int = 0; i < removedMemberList.length; i++)
         {
            player = removedMemberList[i];
            removeSuccess = this.realRemoveSelectPlayer(player);
            everRemoved ||= removeSuccess;
         }
         if(everRemoved)
         {
            setBindData(DataID.PARTY_SELECTED_CANDIDATE,this._selectedPlayer);
         }
      }
      
      private function realAddSelectPlayer(player:Object) : Boolean
      {
         var playerIndex:int = this.indexOfSelectedPlayer(player);
         if(-1 == playerIndex)
         {
            this._selectedPlayer.push(player);
            return true;
         }
         return false;
      }
      
      private function realRemoveSelectPlayer(player:Object) : Boolean
      {
         var playerIndex:int = this.indexOfSelectedPlayer(player);
         if(-1 != playerIndex)
         {
            this._selectedPlayer.splice(playerIndex,1);
            return true;
         }
         return false;
      }
      
      private function onCleanAllSelectPartyPlayer(evt:ParaEvent) : void
      {
         this.clearSelectPlayer();
         setBindData(DataID.PARTY_SELECTED_CANDIDATE,this._selectedPlayer);
      }
      
      private function clearSelectPlayer() : void
      {
         this._selectedPlayer.splice(0,this._selectedPlayer.length);
      }
      
      private function getPartyInfo() : PartyObj
      {
         if(this.isPartyReady())
         {
            return this._partyInfo;
         }
         return null;
      }
      
      private function onPartyJoined(cRes:Object) : void
      {
         var success:Boolean = cRes.result == ResultObj.RESULT_SUCCESS;
         if(success)
         {
            this.onPartyStateChanged();
            this.invitePlayersToParty(this._selectedPlayer);
            this.clearSelectPlayer();
         }
      }
      
      private function onPartyStateChanged() : void
      {
         broadcast(BCEvent.PARTY_STATE_CHANGED);
      }
      
      private function onTryOpenPartyHandle(cEvt:ParaEvent) : void
      {
         if(!this.isInParty())
         {
            if(!getDP(DataID.IS_IN_ROOM) && !getDP(DataID.IS_IN_RANKED_MATCH))
            {
               broadcast(BCEvent.SHOW_PARTY_CREATOR);
               broadcast(BCEvent.SHOW_PARTY_CREATOR_FSG);
            }
         }
         else
         {
            broadcast(BCEvent.SHOW_PARTY_LIST_FSG);
         }
      }
      
      private function fillPartyMemberObj(dest:PartyMemberObj, src:Object) : void
      {
         if(dest == null || src == null)
         {
            return;
         }
         dest.name = src.name;
         dest.clanTag = src.clanTag;
         dest.id = src.id || "";
         dest.isOnline = true;
         dest.friendStatus = -1;
         dest.isHost = Boolean(src.isHost);
         dest.isReady = Boolean(src.isReady);
         dest.level = int(src.level) || 0;
         dest.prestige = int(src.prestige) || 0;
         dest.isKicked = Boolean(src.isKicked);
         dest.isMe = getDP(DataID.IS_ME,[src]);
         dest.isMiniClient = src.dlcLevel < getDP(DataID.DLC_GET_MAXDLCLEVEL);
         dest.showQuit = dest.isMe;
         dest.showReassign = dest.showKick = !dest.isMe && this.isPartyHost();
         dest.wargodPhase = src.wargodPhase;
         dest.wargodScore = src.wargodScore;
         dest.meetWarGodWeaponRequirement = src.meetWarGodWeaponRequirement;
         dest.meetWarGodCreditRatingRequirement = src.meetWarGodCreditRatingRequirement;
         dest.creditRatingDataReady = src.creditRatingDataReady;
         dest.isBlocked = src.isBlocked;
         dest.isEnoughSpyKarma = src.isEnoughSpyKarma;
         dest.meetDMZLeagueTicketRequirement = src.meetDMZLeagueTicketRequirement;
         if(src.badgeObj != null)
         {
            dest.badgeObj.id = uint(src.badgeObj.id) || 0;
            dest.badgeObj.name = src.badgeObj.name || "";
            dest.badgeObj.description = src.badgeObj.description || "";
            dest.badgeObj.imageURL = src.badgeObj.imageURL || "";
         }
         else
         {
            dest.badgeObj = null;
         }
      }
      
      private function invitePlayersToParty(players:Array) : void
      {
         if(!this.isInParty() || !players)
         {
            return;
         }
         broadcast(BCEvent.EVT_PROPOSE_PARTY_MEMBERSHIP);
      }
      
      public function getMemberData(id:String) : UserObj
      {
         for(var i:int = 0; i < this._partyInfo.members.length; i++)
         {
            if(this._partyInfo.members[i].id == id)
            {
               return this._partyInfo.members[i];
            }
         }
         return null;
      }
      
      public function getMaxPartyCandidateAllowed() : int
      {
         return MAX_PARTY_CANDIDATE_ALLOWED;
      }
      
      public function getPartyXPBuff() : Number
      {
         return getDvarFloat("dw_playWithPartyMemberXPBuff");
      }
      
      public function getIsPartyMemberAllInRoom() : Boolean
      {
         var userID:String = null;
         if(!this.isInParty())
         {
            return false;
         }
         for(var i:int = 0; i < this._partyInfo.members.length; i++)
         {
            userID = this._partyInfo.members[i].id;
            if(!CFunctionContainer.IsPartyMemberInRoom(userID))
            {
               return false;
            }
         }
         return true;
      }
   }
}

