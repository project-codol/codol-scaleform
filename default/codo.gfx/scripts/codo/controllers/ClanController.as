package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.ChattingChannelType;
   import codo.constants.ClanMemberPosition;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SanitizedType;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictAAS;
   import codo.localization.DictClan;
   import codo.localization.DictInvitation;
   import codo.localization.DictSystem;
   import codo.objects.ChatMessageObj;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.ClanMemberObj;
   import codo.objects.ClanObj;
   import codo.objects.ClanSearchRequestObj;
   import codo.objects.InvitationObj;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.ProductObj;
   import codo.objects.ResultObj;
   import codo.objects.UserObj;
   import codo.services.ClanService;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import codo.utils.StringUtil;
   import codo.views.RenameConfirm;
   import com.society.comscore.DAXDispatcher;
   
   public class ClanController extends BaseController
   {
      
      private static const MAX_CLAN_MEMBER:int = 100;
      
      private static const CHANGE_CLAN_NAME_TOKEN_ITEM_ID:int = 50007;
      
      private var _clanObj:ClanObj = new ClanObj();
      
      private var _clanIncomingProposals:Array = [];
      
      private var _clanOutgoingProposals:Array = [];
      
      private var _clanApplication:Array = [];
      
      private var _memberToOperate:Object = null;
      
      private var _isClanJoinDispatched:Boolean = false;
      
      private var _isClanOwner:Boolean = false;
      
      private var _clanOpening:Boolean = false;
      
      private var _requestedPlayerName:String;
      
      private var _requestdPlayerId:String;
      
      private var _isAcceptingApplication:Boolean = false;
      
      private var _clanGlobalConfig:ClanGlobalConfig;
      
      private var _playerCCPState:Array;
      
      private var _clanMemberBasicInfoQueryUtil:PlayerBasicInfoQueryUtil = new PlayerBasicInfoQueryUtil();
      
      private var _autoJoinLevel:int;
      
      private var _recruitState:int;
      
      public function ClanController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.CLAN_GLOBAL_CONFIG,this.getClanGlobalConfig);
         addDP(DataID.IS_IN_CLAN,this.isInClan);
         addDP(DataID.IS_CLAN_ADMIN,this.isClanAdmin);
         addDP(DataID.IS_CLAN_OWNER,this.isClanOwner);
         addDP(DataID.IS_IN_MY_CLAN,this.isInMyClan);
         addDP(DataID.IS_IN_CLAN_PROPOSALS,this.isInClanOutgoingProposals);
         addDP(DataID.CAN_PROPOSE_CLAN_MEMBERSHIP,this.canProposeClanMembership);
         addDP(DataID.CAN_ACCEPT_CLAN_MEMBERSHIP,this.canAcceptClanMembership);
         addDP(DataID.CLAN_ONOBOARD_LOCKED,this.isClanOnboardLocked);
         addDP(DataID.PLAYER_QUERY_CLAN,this.GetMemberData);
         addDP(DataID.LOCK_BEST_CLAN,this.isLockBestClan);
         addDP(DataID.APPLICATION_PENDING,this.isClanApplicationPending);
         addDP(DataID.CLAN_XP_BOOST_VALUE,this.getClanXpBoostPercentByType);
         addDP(DataID.SHOULD_HAVE_CLAN_REWARD,this.shouldHaveClanReward);
         addDP(DataID.REQUESTED_DETAIL_PLAYER_NAME,this.getRequestedDetailPlayerName);
         addDP(DataID.REQUESTED_DETAIL_PLAYER_ID,this.getRequestedDetailPlayerId);
         addDP(DataID.LOCK_CLAN,this.getClanIsLocked);
         addDP(DataID.IS_CLAN_MEMBER,this.isClanMember);
         addDP(DataID.IS_CLAN_FULL,this.isClanFull);
         addDP(DataID.IS_ACCEPTING_APPLICATION,this.isAcceptingApplication);
         addDP(DataID.BEST_CLAN_DATA_FROM_TENCENT,this.isBestClanDataFromTencent);
         addDP(DataID.CLAN_CREATE_COOL_DOWN_DAYS,this.getClanCreateCoolDown);
         addDP(DataID.PLAYER_CCP_STATE,this.getPlayerCCPState);
         bind(DataID.LEAVE_CLAN,this.bind_clanLeft);
         bind(DataID.CLAN_PROFILE_UPDATED,this.bind_clanProfileUpdated);
         bind(DataID.CLAN_PROFILE_GOT,this.bind_clanProfileReceived);
         listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onClanDescriptionSanitizedHandle);
         listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onClanAnnouncementSanitizedHandle);
         listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onClanCreateNameSanitizedHandle);
         listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onClanRenameNameSanitizedHandle);
         listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandler);
         listen(BCEvent.CREATE_CLAN_BY_NAME,this.onCreateClanByName);
         listen(BCEvent.LEAVE_CLAN,this.onLeaveClanHandle);
         listen(BCEvent.PROMOTE_CLAN_MEMBER,this.onPromoteClanMemberHandle);
         listen(BCEvent.DEMOTE_CLAN_MEMBER,this.onDemoteClanMemberHandle);
         listen(BCEvent.KICK_CLAN_MEMBER,this.onKickClanMemberHandle);
         listen(BCEvent.INVITE_USERS_TO_CLAN,this.onInviteUsersToClanHandle);
         listen(BCEvent.EVT_APPLY_FOR_CLAN,this.onApplyForClan);
         listen(BCEvent.EVT_EDIT_CLAN_MOTTO,this.onEditClanMotto);
         listen(BCEvent.EVT_EDIT_CLAN_MESSAGE,this.onEditClanMsg);
         listen(BCEvent.EVT_CHANGE_CLAN_TAGS,this.onChangeClanTagsHandle);
         listen(BCEvent.EVT_CHANGE_CLAN_DESCRIPTION_AND_RECRUIT,this.onChangeClanDescriptionAndRecruitHandle);
         listen(BCEvent.EVT_CHANGE_CLAN_ANNOUNCEMENT,this.onChangeClanAnnouncementHandle);
         listen(BCEvent.EVT_ON_OPEN_CLAN,this.onOpenClan);
         listen(BCEvent.EVT_CLOSE_CLAN,this.onCloseClan);
         listen(BCEvent.EVT_CLOSE_DETAIL,this.onCloseDetail);
         listen(BCEvent.EVT_OPEN_CREATE_CLAN_CONFIRM,this.onOpenCreateClanConfirm);
         listen(BCEvent.GET_SEARCH_CLAN,this.onRequestGetSearchClan);
         listen(BCEvent.VIEW_PLAYER_DETAIL_INFO,this.onShowDetailPlayerInfoHandle);
         listen(BCEvent.CLAIM_CLAN_JOIN_REWARD,this.onClaimClanJoinReward);
         listen(BCEvent.EVT_ACCEPTING_CLAN_APPLICATION,this.onAcceptingClanApplication);
         listen(BCEvent.TRY_TO_CHANGE_CLAN_NAME,this.onTryToChangeClanName);
         listen(BCEvent.EVT_REDEEM_CLAN_CHANGE_NAME,this.onRedeemClanChangeName);
         listen(BCEvent.EVT_REQUEST_RETRIEVE_CLAN_INFO,this.onRequestRetrieveClanInfo);
         listen(BCEvent.EVT_CLAIM_CLAN_DAILY_REWARD,this.onClaimClanDailyReward);
         this._clanMemberBasicInfoQueryUtil.registerPlayerBasicInfoHandler(this.onClanMemberBasicInfo);
         this._clanMemberBasicInfoQueryUtil.registerCompleteHandler(this.onClanMemberBasicInfoComplete);
      }
      
      private function onClanMemberBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(!info.available)
         {
            return;
         }
         var cachedMemberCount:int = int(this._clanObj.members.length);
         for(var i:int = 0; i < cachedMemberCount; i++)
         {
            if(this._clanObj.members[i].id == info.entityID)
            {
               this._clanObj.members[i].level = info.level;
               this._clanObj.members[i].prestige = info.prestige;
               this._clanObj.members[i].wargodScore = info.wargodScore;
               this._clanObj.members[i].wargodSeason = info.wargodSeason;
               break;
            }
         }
      }
      
      private function onClanMemberBasicInfoComplete() : void
      {
         this.refreshClanMemberInfo();
      }
      
      private function onPlayerStatsReadyHandler(cEvt:ParaEvent) : void
      {
         this.fetchClanInfo();
         this.fetchClanEntitlement();
      }
      
      public function cppRefreshClan(info:ClanObj) : void
      {
         this.fillClanInfo(info);
      }
      
      public function cppRefreshClanMembers(members:Array) : void
      {
         this.fillClanMember(members);
      }
      
      public function cppRefreshClanMembersPresence(members:Array) : void
      {
         var j:int = 0;
         var cachedMemberCount:int = int(this._clanObj.members.length);
         var dataCount:int = int(members.length);
         for(var i:int = 0; i < cachedMemberCount; i++)
         {
            for(j = 0; j < dataCount; j++)
            {
               if(this._clanObj.members[i].id == members[j].id)
               {
                  this._clanObj.members[i].friendStatus = members[j].friendStatus;
                  break;
               }
            }
         }
         this.refreshClanMemberInfo();
      }
      
      public function cppRefreshClanMemberCCP(members:Array) : void
      {
         var j:int = 0;
         var cachedMemberCount:int = int(this._clanObj.members.length);
         var dataCount:int = int(members.length);
         for(var i:int = 0; i < cachedMemberCount; i++)
         {
            for(j = 0; j < dataCount; j++)
            {
               if(this._clanObj.members[i].id == members[j].id)
               {
                  this._clanObj.members[i].ccpCurrent = members[j].ccpCurrent;
                  this._clanObj.members[i].ccpDaily = members[j].ccpDaily;
                  this._clanObj.members[i].ccpWeekly = members[j].ccpWeekly;
                  this._clanObj.members[i].ccpForever = members[j].ccpForever;
                  break;
               }
            }
         }
         this.refreshClanMemberInfo();
      }
      
      public function cppOnClanMemberNameUpdated(member:Object) : void
      {
         var cachedMemberCount:int = int(this._clanObj.members.length);
         for(var i:int = 0; i < cachedMemberCount; i++)
         {
            if(this._clanObj.members[i].id == member.id)
            {
               this._clanObj.members[i].name = member.name;
               break;
            }
         }
         this.refreshClanMemberInfo();
      }
      
      public function cppRefreshOneClanMemberPresence(member:Object) : void
      {
         var memberCount:int = int(this._clanObj.members.length);
         for(var i:int = 0; i < memberCount; i++)
         {
            if(this._clanObj.members[i].id == member.id)
            {
               this._clanObj.members[i].friendStatus = member.friendStatus;
               break;
            }
         }
         this.refreshClanMemberInfo();
      }
      
      public function cppRefreshClanProposals(proposals:Array, incoming:Boolean) : void
      {
         var proposal:InvitationObj = null;
         var i:int = 0;
         var j:int = 0;
         if(proposals == null)
         {
            return;
         }
         if(incoming)
         {
            this._clanIncomingProposals.splice(0);
            for(i = 0; i < proposals.length; i++)
            {
               proposal = new InvitationObj(proposals[i]);
               proposal.title = DictInvitation.INVITE_CLAN;
               this._clanIncomingProposals.push(proposal);
            }
         }
         else
         {
            this._clanOutgoingProposals.splice(0);
            for(j = 0; j < proposals.length; j++)
            {
               this._clanOutgoingProposals.push(proposals[j]);
            }
         }
         this.broadcast(BCEvent.REFRESH_CLAN_INVITATION_LIST_DATA,{"dp":this._clanIncomingProposals});
         this.broadcast(BCEvent.REFRESH_CLAN_INVITATION_LIST_UI);
      }
      
      public function cppRefreshClanApplications(applications:Array) : void
      {
         var application:InvitationObj = null;
         if(applications == null)
         {
            return;
         }
         for(var i:int = 0; i < applications.length; i++)
         {
            application = new InvitationObj(applications[i]);
            application.title = DictInvitation.INVITE_CLAN;
            this._clanApplication.push(application);
         }
         this.broadcast(BCEvent.REFRESH_CLAN_INVITATION_LIST_DATA,{"dp":this._clanIncomingProposals});
         this.broadcast(BCEvent.REFRESH_CLAN_INVITATION_LIST_UI);
      }
      
      public function cppRefreshClanMemberTitle(userID:String, status:int) : void
      {
         var msg:String = null;
         for(var i:int = 0; i < this._clanObj.members.length; i++)
         {
            if(status == ClanMemberPosition.OWNER && this._clanObj.members[i].clanPos == ClanMemberPosition.OWNER)
            {
               this._clanObj.members[i].clanPos = ClanMemberPosition.ADMIN;
            }
            if(this._clanObj.members[i].id == userID && this._clanObj.members[i].clanPos != status)
            {
               msg = "";
               switch(status)
               {
                  case ClanMemberPosition.ORDINARY:
                     msg = DictClan.NOTE_CLAN_DEMOTE_TO_ORDINARY;
                     break;
                  case ClanMemberPosition.ADMIN:
                     msg = DictClan.NOTE_CLAN_PROMOTE_TO_ADMIN;
                     break;
                  case ClanMemberPosition.OWNER:
                     msg = DictClan.NOTE_CLAN_PROMOTE_TO_OWNER;
               }
               if(msg != "")
               {
                  this.sendNotification(msg,[this._clanObj.members[i].name]);
               }
               this._clanObj.members[i].clanPos = status;
               if(CFunctionCommonContainer.GetPlayerID() == userID)
               {
                  this._clanObj.status = status;
                  broadcast(BCEvent.EVT_CLAN_TITLE_CHANGED);
               }
            }
         }
         this.refreshClanMemberInfo();
      }
      
      public function cppOnClanMemberLeft(userID:String, kicked:Boolean) : void
      {
         var isMe:Boolean = this.getDP(DataID.IS_ME,[{"id":userID}]);
         for(var i:int = 0; i < this._clanObj.members.length; i++)
         {
            if(this._clanObj.members[i].id == userID)
            {
               if(kicked && isMe)
               {
                  this.showMsg(DictClan.NOTE_KICKED_FROM_CLAN,MsgBtnCount.ONE);
               }
               else
               {
                  this.sendNotification(kicked ? DictClan.NOTE_CLAN_MEMBER_KICKED : DictClan.NOTE_CLAN_MEMBER_LEFT,[this._clanObj.members[i].name]);
               }
               this._clanObj.members.splice(i,1);
               this.broadcast(BCEvent.CLAN_MEMBER_LEFT);
               break;
            }
         }
         this.refreshClanMember();
      }
      
      public function cppOnClanDissolved() : void
      {
         this.showMsg(DictClan.NOTE_CLAN_DISSOLVED,MsgBtnCount.ONE);
         this.reset();
         this.fetchClanInfo();
      }
      
      private function bind_clanLeft(cRes:Object) : void
      {
         if(cRes.result == 0)
         {
            this.showMsg(cRes.resultMsg,MsgBtnCount.ONE);
            return;
         }
         this.broadcast(BCEvent.EVT_DELETE_ALL_CLAN_APPLICATION);
         this.reset();
         this.fetchClanInfo();
      }
      
      private function bind_clanProfileUpdated(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_FAIL)
         {
            showMsg(cRes.resultMsg,MsgBtnCount.ONE);
         }
      }
      
      private function bind_clanProfileReceived(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            CFunctionContainer.RefreshClan();
         }
      }
      
      private function onClanCreateNameSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type != SanitizedType.CLAN_CREATE_NAME)
         {
            return;
         }
         if(true == cEvt.myPara.sanitized)
         {
            this.setBindData(DataID.CLAN_CREATE_NAME_IPT,cEvt.myPara.content);
            this.showMsg(LocalizeUtil.param(DictClan.NOTE_SANITIZED_CLAN_NAME,[cEvt.myPara.content]),MsgBtnCount.ONE);
            return;
         }
         this.request(DataID.CREATE_CLAN,cEvt.myPara.content,this.onClanCreated);
      }
      
      private function onClanRenameNameSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type != SanitizedType.CLAN_RENAME_NAME)
         {
            return;
         }
         if(true == cEvt.myPara.sanitized)
         {
            showMsg(LocalizeUtil.param(DictClan.NOTE_SANITIZED_CLAN_NAME,[cEvt.myPara.content]),MsgBtnCount.ONE);
            setBindData(DataID.SANITIZED_NEW_CLAN_NAME,cEvt.myPara.content);
            return;
         }
         setBindData(DataID.SANITIZED_NEW_CLAN_NAME,"");
         CFunctionContainer.RedeemClanNameChangeToken(cEvt.myPara.content);
      }
      
      private function onClanDescriptionSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type != SanitizedType.CLAN_DESCRIPTION)
         {
            return;
         }
         var sanitizedMotto:String = cEvt.myPara.content;
         CFunctionContainer.EditClanDescriptionAndRecruit(sanitizedMotto,this._recruitState,this._autoJoinLevel);
         if(Boolean(cEvt.myPara.sanitized))
         {
            showMsg(DictClan.NOTE_SANITIZED_CLAN_MOTTO,MsgBtnCount.ONE);
         }
      }
      
      private function onClanAnnouncementSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type != SanitizedType.CLAN_ANNOUNCEMENT)
         {
            return;
         }
         var sanitizedAnnouncement:String = cEvt.myPara.content;
         CFunctionContainer.EditClanAnnouncement(sanitizedAnnouncement);
         if(Boolean(cEvt.myPara.sanitized))
         {
            showMsg(DictClan.NOTE_SANITIZED_CLAN_MODO,MsgBtnCount.ONE);
         }
      }
      
      private function onCreateClanByName(cEvt:ParaEvent) : void
      {
         var candidateClanName:String = cEvt.myPara as String;
         if(this.clanCreationBasicCheck(candidateClanName) == false)
         {
            return;
         }
         this.clanCreationSanitizeCheck(candidateClanName);
      }
      
      private function clanCreationBasicCheck(name:String) : Boolean
      {
         var candidateClanName:String = StringUtil.trim(name," ");
         if(candidateClanName.length <= 0)
         {
            this.showMsg(DictClan.NOTE_EMPTY_CLAN_NAME,MsgBtnCount.ONE);
            return false;
         }
         return true;
      }
      
      private function clanCreationSanitizeCheck(name:String) : void
      {
         broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
            "type":SanitizedType.CLAN_CREATE_NAME,
            "content":name
         });
      }
      
      private function onLeaveClanHandle(cEvt:ParaEvent) : void
      {
         if(!this.isInClan())
         {
            return;
         }
         if(this.isClanOwner())
         {
            if(this._clanObj.members.length <= 1)
            {
               this.showMsg(DictClan.NOTE_LEAVE_CLAN_WARNING_0,MsgBtnCount.TWO,0,this.leaveClan);
            }
            else
            {
               this.showMsg(DictClan.NOTE_LEAVE_CLAN_WARNING_1,MsgBtnCount.TWO,0,this.transferClan,DictClan.CLAN_TRANSFER,null,DictSystem.CANCEL);
            }
         }
         else
         {
            this.showMsg(DictClan.NOTE_LEAVE_CLAN_WARNING_2,MsgBtnCount.TWO,0,this.leaveClan);
         }
      }
      
      private function onPromoteClanMemberHandle(cEvt:ParaEvent) : void
      {
         var msg:String = null;
         var user:Object = cEvt.myPara;
         if(user == null)
         {
            return;
         }
         this._memberToOperate = user;
         var tempOwnClanUnlockLV:int = this.getDP(DataID.OWN_CLAN_UNLOCKED_LEVEL);
         Logger.print("Promotion Candidate prestige and level:",user.prestige,user.level + 1);
         if(user.clanPos == ClanMemberPosition.ORDINARY || user.clanPos == ClanMemberPosition.ADMIN && (user.level + 1 >= tempOwnClanUnlockLV || user.prestige > 0))
         {
            msg = user.clanPos == ClanMemberPosition.ADMIN ? DictClan.NOTE_CLAN_OWNER_TRANSFER : DictClan.NOTE_TO_PROMOTE_CLAN_MEM;
            this.showMsg(LocalizeUtil.localize(msg),MsgBtnCount.TWO,0,this.promoteClanMember);
         }
         else
         {
            this.showMsg(LocalizeUtil.replace(LocalizeUtil.localize(DictClan.CANT_OWN_CLAN_UNTIL_LV_X),[tempOwnClanUnlockLV]),MsgBtnCount.ONE);
         }
      }
      
      private function onDemoteClanMemberHandle(cEvt:ParaEvent) : void
      {
         this._memberToOperate = cEvt.myPara;
         this.showMsg(LocalizeUtil.localize(DictClan.NOTE_TO_DEMOTE_CLAN_MEM),MsgBtnCount.TWO,0,this.demoteClanMember);
      }
      
      private function onKickClanMemberHandle(cEvt:ParaEvent) : void
      {
         this._memberToOperate = cEvt.myPara;
         this.showMsg(LocalizeUtil.localize(DictClan.NOTE_TO_KICK_CLAN_MEM),MsgBtnCount.TWO,0,this.kickClanMember);
      }
      
      private function onInviteUsersToClanHandle(cEvt:ParaEvent) : void
      {
         if(this._clanObj.members.length >= MAX_CLAN_MEMBER)
         {
            this.showMsg(DictClan.ERROR_CLAN_FULL,MsgBtnCount.ONE);
            return;
         }
         CFunctionCommonContainer.Assert(cEvt.myPara.users.length == 1,new Error("onInviteUsersToClanHandler can only invite one friend within one invite request"));
         var inviteeID:String = cEvt.myPara.users[0].id;
         if(Boolean(CFunctionContainer.ExistInApplicationList(inviteeID)))
         {
            this.showMsg(DictClan.PLAYER_HAS_SENT_JOIN_APPLICATION,MsgBtnCount.ONE);
            return;
         }
         if(!CFunctionContainer.IsClanMembershipProposed(inviteeID))
         {
            this.request(DataID.PROPOSE_CLAN_MEMBERSHIP,cEvt.myPara.users[0]);
         }
         this.showMsg(DictClan.CLAN_REQUEST_SENT,MsgBtnCount.ONE);
         this.comScoreLogging("action_type","add_friend");
      }
      
      private function onApplyForClan(cEvt:ParaEvent) : void
      {
         var para:Object = cEvt.myPara;
         if(this.isExistInvitation(para.id))
         {
            showMsg(DictClan.EXIST_CLAN_INVITE,MsgBtnCount.ONE);
         }
         else
         {
            CFunctionContainer.ApplyForClan(para);
         }
      }
      
      public function cppOnApplyForClanComplete(isSuccess:Boolean, reason:String) : void
      {
         if(isSuccess)
         {
            showMsg(DictClan.NOTE_CLAN_APPLICATION_SUCCESS,MsgBtnCount.ONE);
         }
         else
         {
            showMsg(reason,MsgBtnCount.ONE);
         }
      }
      
      public function cppClanApplicationSentListChanged() : void
      {
         broadcast(BCEvent.PENDING_CLAN_APPLICATION_CHANGED);
      }
      
      public function cppOnAcceptClanApplicationComplete(isSuccess:Boolean, reason:String) : void
      {
         if(!isSuccess)
         {
            showMsg(reason,MsgBtnCount.ONE);
         }
         this._isAcceptingApplication = false;
      }
      
      private function sendNotification(msg:String, param:Array = null) : void
      {
         var msgObj:ChatMessageObj = new ChatMessageObj();
         msgObj.channelID = ChattingChannelType.CLAN;
         msgObj.senderName = LocalizeUtil.localize(DictAAS.AAS_SYSTEM);
         msgObj.isNew = true;
         msgObj.message = param != null && param.length != 0 ? LocalizeUtil.param(msg,param) : msg;
         msgObj.isSystem = true;
         broadcast(BCEvent.EVT_CHAT_MSG_FROM_SYSTEM,msgObj);
      }
      
      private function onClanCreated(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            broadcast(BCEvent.EVT_ON_CLAN_CREATED);
            ClanService.getInstance().isInClan = true;
            CFunctionContainer.InitClanProfile();
            this.comScoreLogging("action_type","create_clan");
         }
      }
      
      private function getClanGlobalConfig() : ClanGlobalConfig
      {
         if(this._clanGlobalConfig == null)
         {
            this._clanGlobalConfig = CFunctionContainer.GetClanGlobalConfigs();
         }
         return this._clanGlobalConfig;
      }
      
      private function isInClan() : Boolean
      {
         return ClanService.getInstance().isInClan;
      }
      
      private function isClanOwner() : Boolean
      {
         return this._clanObj.status == ClanMemberPosition.OWNER;
      }
      
      private function isClanAdmin() : Boolean
      {
         return this._clanObj.status == ClanMemberPosition.ADMIN;
      }
      
      private function isInMyClan(user:Object) : Boolean
      {
         return DataUtil.isInArray(user.id,this._clanObj.members);
      }
      
      private function isInClanOutgoingProposals(user:Object) : Boolean
      {
         var i:int = 0;
         if(this._clanOutgoingProposals != null)
         {
            for(i = 0; i < this._clanOutgoingProposals.length; i++)
            {
               if(user.id == this._clanOutgoingProposals[i].senderID)
               {
                  return true;
               }
            }
         }
         return this.isInMyClan(user);
      }
      
      private function canProposeClanMembership(user:Object) : Boolean
      {
         this.comScoreLogging("action_type","invite_to_clan");
         return this.isInClan() && (this.isClanOwner() || this.isClanAdmin()) && !this.isInMyClan(user);
      }
      
      private function canAcceptClanMembership() : Boolean
      {
         this.comScoreLogging("action_type","join_clan");
         return !this.isInClan() && !ClanService.getInstance().isAcceptingClanMembership();
      }
      
      private function isClanOnboardLocked() : Boolean
      {
         var onboardUnlockLevel:String = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_CLANS);
         return onboardUnlockLevel != null;
      }
      
      private function fillClanInfo(data:ClanObj) : void
      {
         if(data == null)
         {
            return;
         }
         if(this._clanObj.name != data.name)
         {
            broadcast(BCEvent.EVT_ON_CLAN_NAME_CHANGED);
         }
         this._clanObj.id = data.id;
         this._clanObj.name = data.name;
         this._clanObj.ownerID = data.ownerID;
         this._clanObj.ownerName = data.ownerName;
         this._clanObj.status = data.status;
         this._clanObj.autoJoinLevel = data.autoJoinLevel;
         this._clanObj.recruitState = data.recruitState;
         this._clanObj.clanAnnouncement = data.clanAnnouncement;
         this._clanObj.clanDescription = data.clanDescription;
         this._clanObj.ctp = data.ctp;
         this._clanObj.ctpEarnedToday = data.ctpEarnedToday;
         this._clanObj.level = data.level;
         this._clanObj.tags = data.tags;
         if(this._isClanOwner && !this.isClanOwner())
         {
            broadcast(BCEvent.EVT_DELETE_ALL_CLAN_APPLICATION);
         }
         this._isClanOwner = this.isClanOwner();
         this.refreshClanInfo();
      }
      
      private function fillClanMember(members:Array) : void
      {
         var member:ClanMemberObj = null;
         var clanMemberBasicInfoIDs:Array = new Array();
         var isInit:Boolean = this._clanObj.members.length == 0;
         var copiedMembers:Array = this._clanObj.members.concat();
         this.checkAnyMemberRenamed(members);
         this._clanObj.members.splice(0);
         for(var i:int = 0; i < members.length; i++)
         {
            member = new ClanMemberObj(members[i]);
            clanMemberBasicInfoIDs.push(member.id);
            this._clanObj.members.push(member);
            if(this._clanObj.members[i].clanPos == ClanMemberPosition.OWNER)
            {
               this._clanObj.ownerName = this._clanObj.members[i].name;
            }
            if(!DataUtil.isInArray(this._clanObj.members[i].id,copiedMembers) && !isInit)
            {
               this.sendNotification(DictClan.NOTE_CLAN_NEW_MEMBER,[this._clanObj.members[i].name]);
            }
         }
         this._clanMemberBasicInfoQueryUtil.queryPlayerBasicInfo(clanMemberBasicInfoIDs);
         this.refreshClanMember();
      }
      
      private function checkAnyMemberRenamed(newMembers:Array) : void
      {
         var newMember:Object = null;
         var j:int = 0;
         var oldMember:ClanMemberObj = null;
         var memberCount:int = int(newMembers.length);
         var oldMemberCount:int = int(this._clanObj.members.length);
         for(var i:int = 0; i < memberCount; i++)
         {
            newMember = newMembers[i];
            for(j = 0; j < oldMemberCount; j++)
            {
               oldMember = this._clanObj.members[j];
               if(oldMember.id == newMember.id && oldMember.name != newMember.name)
               {
                  this.broadcast(BCEvent.EVT_DETECT_NAME_CHANGE,{
                     "id":newMember.id,
                     "oldName":oldMember.name,
                     "newName":newMember.name
                  });
               }
            }
         }
      }
      
      private function refreshClanInfo() : void
      {
         if(!this._isClanJoinDispatched)
         {
            this._isClanJoinDispatched = true;
            this.resetClanNameSearchResult();
            CFunctionContainer.ClanStateChanged();
            broadcast(BCEvent.EVT_ON_CLAN_JOINED);
         }
         setBindData(DataID.CLAN_INFO,this._clanObj);
      }
      
      private function refreshClanMember() : void
      {
         setBindData(DataID.CLAN_MEMBER,this._clanObj.members);
      }
      
      private function refreshClanMemberInfo() : void
      {
         setBindData(DataID.CLAN_MEMBER_INFO,this._clanObj.members);
      }
      
      private function resetClanObj() : void
      {
         this._clanObj.id = "";
         this._clanObj.name = "";
         this._clanObj.members.splice(0);
      }
      
      private function reset() : void
      {
         ClanService.getInstance().isInClan = false;
         this._isClanJoinDispatched = false;
         this.resetClanObj();
         this.resetClanNameSearchResult();
         this.broadcast(BCEvent.EVT_ON_CLAN_LEFT);
         CFunctionContainer.ClanStateChanged();
      }
      
      private function fetchClanInfo() : void
      {
         CFunctionContainer.FetchClanInfo();
         var remainTime:int = CFunctionContainer.GetRemainTimeClaimClanReward();
         setBindData(DataID.SECONDS_TO_CLAIM_CLAN_DAILY_REWARD,remainTime);
      }
      
      private function fetchClanEntitlement() : void
      {
         CFunctionContainer.FetchClanEntitlement();
      }
      
      private function promoteClanMember() : void
      {
         if(this._memberToOperate != null)
         {
            this.request(DataID.PROMOTE_CLAN_MEMBER,{
               "userObj":this._memberToOperate,
               "type":this._memberToOperate.clanPos
            });
            this._memberToOperate = null;
         }
      }
      
      private function demoteClanMember() : void
      {
         if(this._memberToOperate != null)
         {
            this.request(DataID.DEMOTE_CLAN_MEMBER,this._memberToOperate);
            this._memberToOperate = null;
         }
      }
      
      private function kickClanMember() : void
      {
         if(this.isInClan() && this._memberToOperate != null)
         {
            this.request(DataID.KICK_CLAN_MEMBER,this._memberToOperate);
         }
         this._memberToOperate = null;
      }
      
      private function transferClan() : void
      {
         var i:int = 0;
         var newOwner:Object = null;
         var members:Array = null;
         var tempOwnClanUnlockLV:int = 0;
         if(this.isInClan())
         {
            newOwner = null;
            members = this._clanObj.members.concat();
            for(i = 0; i < members.length; i++)
            {
               if(Boolean(members[i].isMe))
               {
                  members.splice(i,1);
                  break;
               }
            }
            tempOwnClanUnlockLV = this.getDP(DataID.OWN_CLAN_UNLOCKED_LEVEL);
            for(i = 0; i < members.length; i++)
            {
               if(members[i].clanPos == ClanMemberPosition.ADMIN && (members[i].level + 1 >= tempOwnClanUnlockLV || members[i].prestige > 0))
               {
                  newOwner = members[i];
                  break;
               }
            }
            if(newOwner == null)
            {
               for(i = 0; i < members.length; i++)
               {
                  if(members[i].level + 1 >= tempOwnClanUnlockLV || members[i].prestige > 0)
                  {
                     newOwner = members[i];
                     break;
                  }
               }
            }
            if(newOwner != null)
            {
               this.request(DataID.LEAVE_CLAN,newOwner.id);
            }
            else
            {
               this.showMsg(LocalizeUtil.replace(LocalizeUtil.localize(DictClan.CANT_OWN_CLAN_UNTIL_LV_X),[tempOwnClanUnlockLV]),MsgBtnCount.ONE);
            }
         }
      }
      
      private function doubleMakeSureToLeaveClan() : void
      {
         if(this.isInClan())
         {
            this.showMsg(DictClan.NOTE_DISSOLVE_CLAN_WARNING,MsgBtnCount.TWO,0,this.leaveClan);
         }
      }
      
      private function leaveClan() : void
      {
         if(this.isInClan())
         {
            this.request(DataID.LEAVE_CLAN,"0");
         }
      }
      
      private function onEditClanMotto(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_EDIT_CLAN_MOTTO);
      }
      
      private function onEditClanMsg(cEvt:ParaEvent) : void
      {
         gotoPage(CodoPageViewDB.PAGE_ADV_EDIT_CLAN_MSG);
      }
      
      private function onChangeClanTagsHandle(cEvt:ParaEvent) : void
      {
         CFunctionContainer.EditClanTags(cEvt.myPara);
      }
      
      private function onChangeClanDescriptionAndRecruitHandle(cEvt:ParaEvent) : void
      {
         var newMotto:String = StringUtil.trim(cEvt.myPara.text);
         this._recruitState = cEvt.myPara.recruitState;
         this._autoJoinLevel = cEvt.myPara.autoJoinLevel;
         if(newMotto != "")
         {
            this.broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
               "type":SanitizedType.CLAN_DESCRIPTION,
               "content":cEvt.myPara.text
            });
         }
         else
         {
            CFunctionContainer.EditClanDescriptionAndRecruit("",this._recruitState,this._autoJoinLevel);
         }
      }
      
      private function onChangeClanAnnouncementHandle(cEvt:ParaEvent) : void
      {
         var newAnnouncement:String = StringUtil.trim(cEvt.myPara.text);
         if(newAnnouncement != "")
         {
            this.broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
               "type":SanitizedType.CLAN_ANNOUNCEMENT,
               "content":cEvt.myPara.text
            });
         }
         else
         {
            CFunctionContainer.EditClanAnnouncement("");
         }
      }
      
      private function onOpenClan(cEvt:ParaEvent) : void
      {
         this._clanOpening = true;
      }
      
      private function onCloseClan(cEvt:ParaEvent) : void
      {
         this._clanOpening = false;
         this.prevPage();
      }
      
      private function onCloseDetail(cEvt:ParaEvent) : void
      {
         this.prevPage();
      }
      
      private function onOpenCreateClanConfirm(cEvt:ParaEvent) : void
      {
         this.gotoPage(CodoPageViewDB.PAGE_CREATE_CLAN_POPUP);
      }
      
      private function getClanIsLocked() : Boolean
      {
         return getDvarBool("ui_lock_clan");
      }
      
      public function GetMemberData(id:String) : UserObj
      {
         for(var i:int = 0; i < this._clanObj.members.length; i++)
         {
            if(this._clanObj.members[i].id == id)
            {
               return this._clanObj.members[i];
            }
         }
         return null;
      }
      
      public function isLockBestClan() : Boolean
      {
         return getDvarBool("ui_lock_bestClan");
      }
      
      private function onRequestGetSearchClan(evt:ParaEvent) : void
      {
         CFunctionContainer.SearchClan(evt.myPara);
      }
      
      private function onShowDetailPlayerInfoHandle(cEvt:ParaEvent) : void
      {
         this._requestedPlayerName = cEvt.myPara.name;
         this._requestdPlayerId = cEvt.myPara.id;
         gotoPage(CodoPageViewDB.PAGE_PLAYER_DETAIL_INFO);
         CFunctionContainer.AS_GetPlayerInfoById(cEvt.myPara);
      }
      
      private function isClanMember(cUser:Object) : Boolean
      {
         if(!this.isInClan())
         {
            return false;
         }
         var memberCount:int = int(this._clanObj.members.length);
         for(var i:int = 0; i < memberCount; i++)
         {
            if(this._clanObj.members[i].id == cUser.id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isClanFull() : Boolean
      {
         if(!this.isInClan())
         {
            return false;
         }
         var memberCount:int = int(this._clanObj.members.length);
         return memberCount >= MAX_CLAN_MEMBER;
      }
      
      private function isAcceptingApplication() : Boolean
      {
         return this._isAcceptingApplication;
      }
      
      private function isBestClanDataFromTencent() : Boolean
      {
         return this.getClanGlobalConfig().readBestClanFromTencent;
      }
      
      private function onAcceptingClanApplication(evt:ParaEvent) : void
      {
         this._isAcceptingApplication = true;
      }
      
      private function isExistInvitation(teamID:String) : Boolean
      {
         return CFunctionContainer.ExistInInvitationList(teamID) as Boolean;
      }
      
      private function onClaimClanJoinReward(cEvt:ParaEvent) : void
      {
         CFunctionContainer.ClaimClanJoinReward();
      }
      
      private function onTryToChangeClanName(cEvt:ParaEvent) : void
      {
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(CHANGE_CLAN_NAME_TOKEN_ITEM_ID);
         if(prod.stackNumber >= 1)
         {
            broadcast(BCEvent.EVT_CHANGE_NAME_POPUP,{"type":RenameConfirm.RENAME_TYPE_CLAN});
         }
         else
         {
            broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prod});
         }
      }
      
      private function onRedeemClanChangeName(cEvt:ParaEvent) : void
      {
         showMsg(Dict.REDEEM_NAME_IN_PROGRESS);
         var newName:String = cEvt.myPara;
         broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
            "type":SanitizedType.CLAN_RENAME_NAME,
            "content":newName
         });
      }
      
      private function onRequestRetrieveClanInfo(cEvt:ParaEvent) : void
      {
         CFunctionContainer.ForceRefreshClanInfo();
      }
      
      private function onClaimClanDailyReward(cEvt:ParaEvent) : void
      {
         CFunctionContainer.ClaimClanDailyReward();
      }
      
      private function resetClanNameSearchResult() : void
      {
         setBindData(DataID.SEARCH_CLAN_LIST,null);
      }
      
      private function getClanCreateCoolDown() : int
      {
         return this.getClanGlobalConfig().createClanCoolDown;
      }
      
      private function getPlayerCCPState() : Array
      {
         if(this._playerCCPState == null)
         {
            this._playerCCPState = CFunctionContainer.GetCCPGatherStateForToday();
         }
         return this._playerCCPState;
      }
      
      public function cppClanSearchResultReturns(result:Object) : void
      {
         var dataId:String = null;
         var isSuccess:Boolean = Boolean(result.isSuccess);
         var type:int = int(result.type);
         switch(type)
         {
            case ClanSearchRequestObj.CLAN_SEARCH_TYPE_BEST:
            case ClanSearchRequestObj.CLAN_SEARCH_TYPE_TENCENT_BEST:
               dataId = DataID.BEST_CLAN_LIST;
               break;
            case ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW:
               dataId = DataID.NEW_CLAN_LIST;
               break;
            case ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW_JOINABLE:
               dataId = DataID.NEW_JOINABLE_CLAN_LIST;
               break;
            case ClanSearchRequestObj.CLAN_SEARCH_TYPE_BY_NAME:
               dataId = DataID.SEARCH_CLAN_LIST;
               break;
            default:
               CFunctionCommonContainer.Assert(false,new Error("cppClanSearchResultReturns::no search type defined."));
         }
         setBindData(dataId,result);
      }
      
      public function isClanApplicationPending(id:String) : Boolean
      {
         return CFunctionContainer.IsClanApplicationEverSent(id) as Boolean;
      }
      
      public function getClanXpBoostPercentByType(type:int) : Number
      {
         return CFunctionContainer.GetClanXpBoostPercentByType(type) as Number;
      }
      
      public function shouldHaveClanReward() : Boolean
      {
         return getDvarBool("dw_needRewardJoinClan");
      }
      
      public function cppShowClanMemberInfo(result:Object) : void
      {
         var dataWrapper:Object = new Object();
         dataWrapper.isSuccess = result != null;
         dataWrapper.content = result;
         setBindData(DataID.PLAYER_QUERY_INFO,dataWrapper);
      }
      
      public function cppOnRedeemClanNameChangeTokenComplete(success:Boolean, errMsg:String) : void
      {
         if(success)
         {
            closePopupPage(PageID.CHANGE_NAME);
            broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         showMsg(errMsg,MsgBtnCount.ONE);
      }
      
      public function cppOnClaimClanDailyRewardComplete(success:Boolean, errMsg:String) : void
      {
         showMsg(errMsg,MsgBtnCount.ONE);
         var remainTime:int = CFunctionContainer.GetRemainTimeClaimClanReward();
         setBindData(DataID.SECONDS_TO_CLAIM_CLAN_DAILY_REWARD,remainTime);
      }
      
      public function getRequestedDetailPlayerName() : String
      {
         return this._requestedPlayerName;
      }
      
      public function getRequestedDetailPlayerId() : String
      {
         return this._requestdPlayerId;
      }
      
      private function comScoreLogging(action:String, value:String) : void
      {
         try
         {
            DAXDispatcher.queue(action,value);
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("** DAXDispatcher: " + e.message);
         }
      }
   }
}

