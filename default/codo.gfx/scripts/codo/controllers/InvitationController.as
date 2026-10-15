package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.InvitationType;
   import codo.constants.MsgBtnCount;
   import codo.constants.PlayListType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.localization.DictInvitation;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.objects.InvitationGroupObj;
   import codo.objects.PlayListObj;
   import codo.objects.UserObj;
   import codo.utils.DataUtil;
   import codo.utils.IDGeneratorUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   
   public class InvitationController extends BaseController
   {
      
      private static const INVITATION_MESSAGE_TYPE_GROUP:Array = [InvitationType.ROOM,InvitationType.FRIEND_OUTGOING_PROPOSAL,InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED,InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED,InvitationType.GAME_OUTGOING_PROPOSAL];
      
      private var _invitations:Array = [];
      
      private var _isInvitationFetched:Boolean = false;
      
      private var _idGenerator:IDGeneratorUtil = new IDGeneratorUtil();
      
      private var _currentMessagePanelMsgCount:int = 0;
      
      private var _logContainer:Array = [];
      
      private var _invitationGroups:Array = [];
      
      private var _acceptedHighLatencyTicket:String;
      
      private var _newUnreadLogCount:int = 0;
      
      public function InvitationController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.ACCEPTED_HIGH_LATENCY_TICKET,this.getAcceptedHighLatencyTicket);
         this.bind(DataID.FRIENDS,this.bind_friendDP);
         this.listen(BCEvent.EVT_ACCEPT_INVITATION,this.onAcceptInvitationHandle);
         this.listen(BCEvent.EVT_REJECT_INVITATION,this.onRejectInvitationHandle);
         this.listen(BCEvent.ADD_NEW_INVITATION,this.onAddNewInvitationHandle);
         this.listen(BCEvent.PARTY_JOINED,this.onPartyJoinedHandle);
         this.listen(BCEvent.MESSAGE_READ,this.onMessageRead);
         this.listen(BCEvent.REFRESH_CLAN_INVITATION_LIST_DATA,this.onClanInvitationUpdated);
         this.listen(BCEvent.EVT_ON_LOG_READ,this.onLogRead);
         this.listen(BCEvent.EVT_ON_LOG_READ_BATCH,this.onLogReadBatch);
         this.listen(BCEvent.CLEAR_ALL_UNREAD_LOG,this.clearAllUnreadLog);
         this.listen(BCEvent.REMOVE_ALL_INVITATIONS,this.onRemoveAllInvitations);
         this.listen(BCEvent.BOOK_HIGH_LATENCY_TICKET,this.onBookHighLatencyTicket);
         this.cfgInvitationGroup(DataID.MESSAGE_BOX,InvitationType.ROOM,InvitationType.FRIEND_OUTGOING_PROPOSAL,InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED,InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED,InvitationType.GAME_OUTGOING_PROPOSAL);
         this.cfgInvitationGroup(DataID.MESSAGE_FRIEND,InvitationType.FRIEND);
         this.cfgInvitationGroup(DataID.MESSAGE_PARTY,InvitationType.PARTY);
         this.cfgInvitationGroup(DataID.MESSAGE_CLAN,InvitationType.CLAN,InvitationType.CLAN_MAIL_HEADER);
         this.cfgInvitationGroup(DataID.MESSAGE_SYSTEM,InvitationType.SYSTEM);
      }
      
      private function bind_friendDP(cRes:Object) : void
      {
         var len:uint = this._invitations.length;
         for(var i:uint = 0; i < this._invitations.length; i++)
         {
            if(this._invitations[i].type == InvitationType.FRIEND && DataUtil.isInArray(this._invitations[i].senderID,cRes.data))
            {
               this.removeInvitationByIndex(i);
            }
            else
            {
               i++;
            }
         }
         if(len != this._invitations.length)
         {
            this.dispatchInvitationChangeEvent(InvitationType.FRIEND);
         }
      }
      
      private function cfgInvitationGroup(asyncID:uint, ... rest) : void
      {
         if(rest.length == 0)
         {
            return;
         }
         var groupObj:InvitationGroupObj = new InvitationGroupObj();
         groupObj.asyncID = asyncID;
         for(var i:int = 0; i < rest.length; i++)
         {
            groupObj.invitationTypesArray.push(rest[i]);
         }
         this._invitationGroups.push(groupObj);
      }
      
      public function cppAddNewInvitation(invitation:Object) : void
      {
         this.addInvitation(invitation);
         this.dispatchInvitationChangeEvent(invitation.type,true,true);
      }
      
      private function onMessageRead(cEvt:ParaEvent) : void
      {
         var groupObj:InvitationGroupObj = this.getInvitationGroupByAsyncID(cEvt.myPara.asyncID);
         if(groupObj != null)
         {
            this.dispatchInvitationChangeEventByGroup(this.getInvitationGroupByAsyncID(groupObj.asyncID),true,false);
         }
      }
      
      private function clearAllUnreadLog(cEvt:ParaEvent) : void
      {
         this._newUnreadLogCount = 0;
         this.setBindData(DataID.UNREAD_LOG_COUNT,this._newUnreadLogCount);
      }
      
      private function onRemoveAllInvitations(cEvt:ParaEvent) : void
      {
         this.removeAllInvitations();
         this.setBindData(DataID.LOG_INFO,{"dp":this._logContainer});
      }
      
      private function onBookHighLatencyTicket(cEvt:ParaEvent) : void
      {
         this._acceptedHighLatencyTicket = cEvt.myPara;
      }
      
      private function onClanInvitationUpdated(cEvt:ParaEvent) : void
      {
         var i:int = 0;
         var j:int = 0;
         var found:Boolean = false;
         var localClanInvitations:Array = this.getInvitationsByGroup(this.getInvitationGroup(InvitationType.CLAN));
         var cppClanInvitations:Array = cEvt.myPara.dp;
         var newClanInvitations:Array = new Array();
         for(i = 0; i < cppClanInvitations.length; i++)
         {
            found = false;
            for(j = 0; j < localClanInvitations.length; j++)
            {
               if(localClanInvitations[j].senderID == cppClanInvitations[i].senderID)
               {
                  if(localClanInvitations[j].targetID != cppClanInvitations[i].targetID)
                  {
                     this.removeInvitation(localClanInvitations[j]);
                     found = false;
                  }
                  else
                  {
                     found = true;
                  }
                  break;
               }
            }
            if(found == false)
            {
               cppClanInvitations[i].isClan = true;
               newClanInvitations.push(cppClanInvitations[i]);
            }
         }
         for(i = 0; i < newClanInvitations.length; i++)
         {
            this.addInvitation(newClanInvitations[i]);
            this.dispatchInvitationChangeEvent(InvitationType.CLAN,true);
         }
      }
      
      private function onClanApplicationUpdated(cEvt:ParaEvent) : void
      {
         var i:int = 0;
         var j:int = 0;
         var found:Boolean = false;
         var localClanApplication:Array = this.getInvitationsByGroup(this.getInvitationGroup(InvitationType.CLAN_APPLICATION));
         var cppClanApplications:Array = cEvt.myPara.dp;
         var newClanApplications:Array = new Array();
         for(i = 0; i < cppClanApplications.length; i++)
         {
            found = false;
            for(j = 0; j < localClanApplication.length; j++)
            {
               if(localClanApplication[j].senderID == cppClanApplications[i].senderID)
               {
                  found = true;
                  break;
               }
            }
            if(found == false)
            {
               newClanApplications.push(cppClanApplications[i]);
            }
         }
         for(i = 0; i < newClanApplications.length; i++)
         {
            this.addInvitation(newClanApplications[i]);
            this.dispatchInvitationChangeEvent(InvitationType.CLAN_APPLICATION,true);
         }
      }
      
      private function onAcceptInvitationHandle(cEvt:ParaEvent) : void
      {
         var acceptPartyInvitation:Function;
         var invitation:Object = null;
         var isBootCampRoom:Boolean = false;
         var dlcLevel:uint = 0;
         var msgText:String = null;
         var playlistObj:PlayListObj = null;
         var msg:String = null;
         invitation = cEvt.myPara;
         switch(invitation.type)
         {
            case InvitationType.FRIEND:
               this.removeInvitation(invitation);
               this.dispatchInvitationChangeEvent(invitation.type);
               if(this.getInvitationArrayByType(invitation.type).length <= 0)
               {
               }
               this.broadcast(BCEvent.EVT_ACCEPT_FRIEND_PROPOSAL,invitation);
               break;
            case InvitationType.PARTY:
               if(Boolean(this.getDP(DataID.IS_IN_ROOM)))
               {
                  if(Boolean(CFunctionContainer.AS_IsHiddenRoomMatch()))
                  {
                     showMsg(DictParty.HIDDEN_ROOM_MATCH_MAKING_IN_PROGRESS,MsgBtnCount.ONE);
                  }
                  else
                  {
                     showMsg(DictParty.PARTY_CANT_ACCEPT_PARTY_IN_ROOM,MsgBtnCount.ONE);
                  }
               }
               else if(Boolean(this.getDP(DataID.IS_IN_PARTY)))
               {
                  this.showMsg(DictParty.PARTY_CANT_ACCEPT_PARTY_IN_PARTY,MsgBtnCount.ONE);
               }
               else if(Boolean(this.getDP(DataID.IS_IN_RANKED_MATCH)))
               {
                  this.showMsg(DictParty.PARTY_CANT_ACCEPT_PARTY_IN_RANKED_MATCH,MsgBtnCount.ONE);
               }
               else
               {
                  acceptPartyInvitation = function():void
                  {
                     removeInvitation(invitation);
                     dispatchInvitationChangeEvent(invitation.type);
                     invitation.initiative = false;
                     broadcast(BCEvent.PARTY_JOIN,invitation);
                  };
                  dlcLevel = getDP(DataID.DLC_GET_LEVEL);
                  if(dlcLevel > invitation.PartyDLClevel)
                  {
                     msgText = LocalizeUtil.localize(DictSystem.FRIEND_PARTYJOIN_NODLC_WARNING);
                     showMsg(msgText,MsgBtnCount.TWO,0,acceptPartyInvitation);
                  }
                  else
                  {
                     acceptPartyInvitation();
                  }
               }
               break;
            case InvitationType.ROOM:
               isBootCampRoom = invitation.gameType == "playlist" && invitation.playlistID == 0;
               if(Boolean(this.getDP(DataID.IS_IN_PARTY)))
               {
                  this.showMsg(DictParty.PARTY_CANT_ACCEPT_ROOM_IN_PARTY,MsgBtnCount.ONE);
                  return;
               }
               if(!this.getDP(DataID.IS_IN_ROOM) && !this.getDP(DataID.IS_IN_PARTY))
               {
                  this.removeInvitation(invitation);
                  this.dispatchInvitationChangeEvent(invitation.type);
                  if(this.getInvitationArrayByType(invitation.type).length <= 0)
                  {
                  }
               }
               if(invitation.gameType == "playlist")
               {
                  playlistObj = this.getDP(DataID.PLAY_LIST_OBJ,[int(invitation.playlistID)]);
                  if(Boolean(playlistObj))
                  {
                     if(!playlistObj.unlocked || playlistObj.dlcLocked)
                     {
                        msg = LocalizeUtil.localize(Dict.NOTE_PLAYLIST_LOCKED).replace("&&1",playlistObj.name);
                        this.showMsg(msg,MsgBtnCount.ONE);
                        CFunctionContainer.AS_MessageDelete(invitation.messageid);
                        return;
                     }
                     if(playlistObj.index == PlayListType.SPY_PLAYLIST_ID && !CFunctionCommonContainer.AS_IsEnoughSpyKarma())
                     {
                        showMsg(DictSystem.SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                        CFunctionContainer.AS_MessageDelete(invitation.messageid);
                        return;
                     }
                  }
               }
               else
               {
                  if(Boolean(getDP(DataID.IS_UNAVAILABLE_MINICLIENT_MODE,[invitation.gameType])) && !getDP(DataID.DLC_IS_FULLCLIENT))
                  {
                     showMsg(DictRoom.ROOM_NODLC_WARNING,MsgBtnCount.ONE);
                     CFunctionContainer.AS_MessageDelete(invitation.messageid);
                     return;
                  }
                  if(invitation.gameType == "spy" && !CFunctionCommonContainer.AS_IsEnoughSpyKarma())
                  {
                     showMsg(DictSystem.SPY_KARMA_NOT_ENOUGH,MsgBtnCount.ONE);
                     CFunctionContainer.AS_MessageDelete(invitation.messageid);
                     return;
                  }
               }
               this.broadcast(BCEvent.JOIN_ROOM_BY_TICKET,{
                  "inviter":invitation.senderID,
                  "session":invitation.targetID,
                  "isBootCampRoom":isBootCampRoom
               });
               if(ScaleformUtil.isTempContentEnabled_3() == true)
               {
                  CFunctionContainer.AS_MessageDelete(invitation.messageid);
               }
               this.broadcast(BCEvent.EVT_CLOSE_FSG_SOCIAL);
               break;
            case InvitationType.CLAN:
               if(!this.getDP(DataID.CAN_ACCEPT_CLAN_MEMBERSHIP))
               {
                  this.showMsg(DictClan.NOTE_CLAN_CANT_ACCEPT_PROPOSAL,MsgBtnCount.ONE);
                  return;
               }
               if(Boolean(this.getDP(DataID.CLAN_ONOBOARD_LOCKED)))
               {
                  this.showMsg(DictClan.NOTE_CLAN_IS_LOCKED,MsgBtnCount.ONE);
                  return;
               }
               this.dispatchInvitationChangeEvent(invitation.type);
               this.request(DataID.ACCEPT_CLAN_MEMBERSHIP,invitation);
               break;
            case InvitationType.CLAN_MAIL_HEADER:
               this.removeInvitation(invitation);
               this.dispatchInvitationChangeEvent(invitation.type);
               this.request(DataID.PROPOSE_CLAN_MEMBERSHIP,new UserObj({
                  "id":invitation.senderID,
                  "name":invitation.senderName
               }));
               this.request(DataID.DELETE_CLAN_MAILS,[invitation.id],this.onDeleteClanMailsComplete);
               break;
            case InvitationType.SYSTEM:
               this.removeInvitation(invitation);
               CFunctionContainer.AS_MessageDelete(invitation.messageid);
               break;
            case InvitationType.CLAN_APPLICATION:
               if(Boolean(getDP(DataID.IS_CLAN_FULL)))
               {
                  showMsg(DictClan.CLAN_IS_FULL,MsgBtnCount.ONE);
                  break;
               }
               if(Boolean(getDP(DataID.IS_ACCEPTING_APPLICATION)))
               {
                  showMsg(DictClan.IS_ACCEPTING_APPLICATION,MsgBtnCount.ONE);
                  break;
               }
               this.broadcast(BCEvent.EVT_ACCEPTING_CLAN_APPLICATION);
               CFunctionContainer.AS_MessageAccept(invitation.messageid);
               break;
            default:
               CFunctionContainer.AS_MessageAccept(invitation.messageid);
         }
      }
      
      private function onRejectInvitationHandle(cEvt:ParaEvent) : void
      {
         var invitation:Object = cEvt.myPara;
         switch(invitation.type)
         {
            case InvitationType.FRIEND:
               this.broadcast(BCEvent.EVT_REJECT_FRIEND_PROPOSAL,invitation);
               break;
            case InvitationType.PARTY:
               this.broadcast(BCEvent.EVT_REJECT_PARTY_MEMBERSHIP,invitation);
               break;
            case InvitationType.ROOM:
               this.broadcast(BCEvent.REJECT_ROOM_MEMBERSHIP,invitation);
               break;
            case InvitationType.CLAN:
               this.request(DataID.REJECT_CLAN_MEMBERSHIP,invitation);
               break;
            case InvitationType.FRIEND_OUTGOING_PROPOSAL:
            case InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED:
            case InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED:
            case InvitationType.GAME_OUTGOING_PROPOSAL:
            case InvitationType.EXPIRE_MESSAGE:
            case InvitationType.EXPIRE_PARTY_INVITATION:
               this.removeInvitation(invitation);
               break;
            default:
               CFunctionContainer.AS_MessageReject(invitation.messageid);
         }
      }
      
      private function onLogRead(cEvt:ParaEvent) : void
      {
         cEvt.myPara.isRead = true;
         this.setBindData(DataID.LOG_INFO,{"dp":this._logContainer});
      }
      
      private function onLogReadBatch(cEvt:ParaEvent) : void
      {
         var invitations:Array = cEvt.myPara;
         var count:int = int(invitations.length);
         for(var i:int = 0; i < count; i++)
         {
            invitations[i].isRead = true;
         }
         this.setBindData(DataID.LOG_INFO,{"dp":this._logContainer});
      }
      
      private function onPartyJoinedHandle(cEvt:ParaEvent) : void
      {
         var len:uint = this._invitations.length;
         for(var i:int = 0; i < this._invitations.length; )
         {
            if(this._invitations[i].type == InvitationType.PARTY)
            {
               this.broadcast(BCEvent.EVT_REJECT_PARTY_MEMBERSHIP,this._invitations[i]);
               this.removeInvitationByIndex(i);
            }
            else
            {
               i++;
            }
         }
         if(len != this._invitations.length)
         {
            this.dispatchInvitationChangeEvent(InvitationType.PARTY);
         }
      }
      
      private function onAddNewInvitationHandle(cEvt:ParaEvent) : void
      {
         this.addInvitation(cEvt.myPara);
         this.dispatchInvitationChangeEvent(cEvt.myPara.type,true);
      }
      
      private function onDeleteClanMailsComplete() : void
      {
         this.broadcast(BCEvent.FETCH_CLAN_MAIL);
      }
      
      private function addInvitation(invitation:Object) : void
      {
         var targetInvitationArray:Array = this._invitations;
         var duplicated:Boolean = false;
         var duplicatedInvitation:Object = null;
         for(var i:int = 0; i < targetInvitationArray.length; i++)
         {
            if(!invitation.isLog && !targetInvitationArray[i].isLog && !invitation.isClan && !targetInvitationArray[i].isClan)
            {
               if(targetInvitationArray[i].id == invitation.id)
               {
                  duplicated = true;
                  duplicatedInvitation = targetInvitationArray[i];
                  break;
               }
            }
         }
         if(!duplicated)
         {
            invitation.receivedTime = invitation.formattedTime;
            if(Boolean(invitation.isLog))
            {
               invitation.messageid = this._idGenerator.generateID();
            }
            if(Boolean(invitation.isClan))
            {
               invitation.clanid = this._idGenerator.generateID();
            }
            this.addInvitationTitle(invitation);
            this.filterInvitations(targetInvitationArray,invitation);
            targetInvitationArray.unshift(invitation);
            targetInvitationArray.sortOn("receivedTime",Array.DESCENDING);
            if(INVITATION_MESSAGE_TYPE_GROUP.indexOf(invitation.type) != -1)
            {
               ++this._newUnreadLogCount;
               this.setBindData(DataID.UNREAD_LOG_COUNT,this._newUnreadLogCount);
            }
            if(Boolean(invitation.isLog))
            {
               this._logContainer.push(invitation);
               this.setBindData(DataID.LOG_INFO,{"dp":this._logContainer});
            }
         }
         else
         {
            duplicatedInvitation.receivedTime = invitation.formattedTime;
            targetInvitationArray.sortOn("receivedTime",Array.DESCENDING);
         }
      }
      
      private function removeInvitation(invitation:Object) : Boolean
      {
         var logIndex:int = 0;
         for(var i:int = 0; i < this._invitations.length; i++)
         {
            if(Boolean(invitation.isLog))
            {
               if(Boolean(this._invitations[i].isLog) && this._invitations[i].messageid == invitation.messageid)
               {
                  logIndex = this._logContainer.indexOf(invitation);
                  if(logIndex != -1)
                  {
                     this._logContainer.splice(logIndex,1);
                     this.setBindData(DataID.LOG_INFO,{"dp":this._logContainer});
                  }
                  this.removeInvitationByIndex(i);
                  this._idGenerator.releaseID(invitation.messageid);
                  return true;
               }
            }
            else if(Boolean(invitation.isClan))
            {
               if(Boolean(this._invitations[i].isClan) && this._invitations[i].clanid == invitation.clanid)
               {
                  this.removeInvitationByIndex(i);
                  this._idGenerator.releaseID(invitation.clanid);
                  return true;
               }
            }
            else if(invitation.id == this._invitations[i].id)
            {
               this.removeInvitationByIndex(i);
               return true;
            }
         }
         return false;
      }
      
      private function removeAllInvitations() : void
      {
         for(var i:int = 0; i < this._invitations.length; i++)
         {
            this.removeInvitation(this._invitations[i]);
            i--;
         }
      }
      
      private function removeInvitationByIndex(idx:int) : Boolean
      {
         if(idx < 0 || idx >= this._invitations.length)
         {
            return false;
         }
         this._invitations.splice(idx,1);
         return true;
      }
      
      private function dispatchInvitationChangeEvent(invitationType:int, readFlagSet:Boolean = false, unreadFlag:Boolean = false) : void
      {
         this.dispatchInvitationChangeEventByGroup(this.getInvitationGroup(invitationType),readFlagSet,unreadFlag);
      }
      
      private function dispatchInvitationChangeEventByGroup(invgroup:InvitationGroupObj, readFlagSet:Boolean = false, unreadFlag:Boolean = false) : void
      {
         if(invgroup == null)
         {
            return;
         }
         if(readFlagSet)
         {
            invgroup.unread = unreadFlag;
         }
         this.setBindData(invgroup.asyncID,{
            "dp":this.getInvitationsByGroup(invgroup),
            "readFlagSet":readFlagSet,
            "unreadFlag":invgroup.unread
         });
      }
      
      private function addInvitationTitle(invitation:Object) : void
      {
         if(invitation == null)
         {
            return;
         }
         switch(invitation.type)
         {
            case InvitationType.PARTY:
               invitation.title = DictInvitation.INVITE_PARTY;
               break;
            case InvitationType.CLAN:
               invitation.title = DictInvitation.INVITE_CLAN;
               break;
            case InvitationType.FRIEND:
               invitation.title = DictInvitation.INVITE_ADD_FRIEND;
               break;
            case InvitationType.ROOM:
               invitation.title = DictInvitation.INVITE_GAME;
               break;
            case InvitationType.CLAN_MAIL_HEADER:
               invitation.title = DictInvitation.INVITE_CLAN_MAIL_HEADERS;
               break;
            case InvitationType.FRIEND_OUTGOING_PROPOSAL:
               invitation.title = DictInvitation.FRIEND_MEMBERSHIP_PROPOSED;
               break;
            case InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED:
            case InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED:
               break;
            case InvitationType.GAME_OUTGOING_PROPOSAL:
               invitation.title = DictInvitation.GAME_INVITATION_SENT;
         }
      }
      
      private function filterInvitations(invitations:Array, invitation:Object) : void
      {
         var i:int = 0;
         var inv:Object = null;
         if(!invitation.isLog)
         {
            for(i = 0; i < invitations.length; )
            {
               inv = invitations[i];
               if(inv.type == invitation.type && inv.senderID == invitation.senderID && inv.senderName == invitation.senderName && inv.targetID == invitation.targetID && inv.receiverName == invitation.receiverName)
               {
                  invitations.splice(i,1);
               }
               else
               {
                  i++;
               }
            }
         }
      }
      
      private function getInvitationArrayByType(invitationType:int) : Array
      {
         var retinvs:Array = new Array();
         for(var i:int = 0; i < this._invitations.length; i++)
         {
            if(invitationType == this._invitations[i].type)
            {
               retinvs.push(this._invitations[i].type);
            }
         }
         return retinvs;
      }
      
      private function getInvitationGroup(invitationType:int) : InvitationGroupObj
      {
         var j:int = 0;
         if(invitationType == InvitationType.NONE)
         {
            return null;
         }
         loop0:
         for(var i:int = 0; i < this._invitationGroups.length; )
         {
            j = 0;
            while(true)
            {
               if(j >= this._invitationGroups[i].invitationTypesArray.length)
               {
                  i++;
                  continue loop0;
               }
               if(invitationType == this._invitationGroups[i].invitationTypesArray[j])
               {
                  break;
               }
               j++;
            }
            return this._invitationGroups[i];
         }
         return null;
      }
      
      private function getInvitationGroupByAsyncID(asyncID:int) : InvitationGroupObj
      {
         for(var i:int = 0; i < this._invitationGroups.length; i++)
         {
            if(this._invitationGroups[i].asyncID == asyncID)
            {
               return this._invitationGroups[i];
            }
         }
         return null;
      }
      
      private function isInvitationInGroup(invitationType:int, group:InvitationGroupObj) : Boolean
      {
         for(var i:int = 0; i < group.invitationTypesArray.length; i++)
         {
            if(invitationType == group.invitationTypesArray[i])
            {
               return true;
            }
         }
         return false;
      }
      
      private function getInvitationsByGroup(invgroup:InvitationGroupObj) : Array
      {
         var ret:Array = new Array();
         if(null == invgroup)
         {
            return ret;
         }
         for(var i:int = 0; i < this._invitations.length; i++)
         {
            if(this.isInvitationInGroup(this._invitations[i].type,invgroup))
            {
               ret.push(this._invitations[i]);
            }
         }
         return ret;
      }
      
      private function getAcceptedHighLatencyTicket() : String
      {
         return this._acceptedHighLatencyTicket;
      }
   }
}

