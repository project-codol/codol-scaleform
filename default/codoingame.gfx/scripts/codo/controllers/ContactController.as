package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.ContactListType;
   import codo.constants.DWServiceStatus;
   import codo.constants.DataID;
   import codo.constants.InvitationType;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictInvitation;
   import codo.localization.DictSystem;
   import codo.objects.FriendObj;
   import codo.objects.InvitationObj;
   import codo.objects.PlayerObj;
   import codo.objects.RecentmetObj;
   import codo.objects.UserObj;
   import codo.utils.DataUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.TimeUtil;
   import com.society.comscore.DAXDispatcher;
   
   public class ContactController extends BaseController
   {
      
      private var _friends:Array = [];
      
      private var _recentPlaymates:Array = [];
      
      private var _blacklist:Array = [];
      
      private var _filteredFriends:Array = [];
      
      private var _filteredPlaymates:Array = [];
      
      private var _isContactFetched:Boolean = false;
      
      private var _currentConfirmRemoveFriendID:String;
      
      private var _currentConfirmRemoveRecentmetID:String;
      
      public function ContactController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.IS_FRIEND,this.isFriend);
         addDP(DataID.IS_FRIEND_ONLINE,this.isFriendOnline);
         addDP(DataID.GET_FRIEND_OBJ_BY_ID,this.getFriendObjById);
         addDP(DataID.FRIEND_MEMBER_INFO,this.getFriends);
         addDP(DataID.FILTERED_FRIEND_INFO,this.getFilteredFriends);
         addDP(DataID.RECENT_PLAYERMATE_INFO,this.getRecentPlayermate);
         addDP(DataID.FILTERED_PLAYMATE_INFO,this.getFilteredRecentPlaymate);
         addDP(DataID.GET_FRIEND_USER_NAME,this.getFriendUserName);
         addDP(DataID.GET_MUTEINFO,this.getMutInfo);
         addDP(DataID.GET_IS_IN_BLACKLIST,this.isInBlacklist);
         addDP(DataID.PLAYER_QUERY_FRIENDS,this.GetFriendData);
         listen(BCEvent.EVT_ADD_FRIEND,this.onAddFriendHandle);
         listen(BCEvent.EVT_DELETE_FRIEND,this.onRemoveFriendHandle);
         listen(BCEvent.EVT_DELETE_RECENT,this.onRemoveRecentmetHandle);
         listen(BCEvent.EVT_MOVE_FRIEND_TO_BLACKLIST,this.onMoveFriendToBlackListHandle);
         listen(BCEvent.EVT_REMOVE_FRIEND_FROM_BLACKLIST,this.onRemoveFriendFromBlackListHandle);
         listen(BCEvent.EVT_ACCEPT_FRIEND_PROPOSAL,this.onAcceptFriendProposalHandle);
         listen(BCEvent.EVT_REJECT_FRIEND_PROPOSAL,this.onRejectFriendProposalHandle);
         listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
         bind(DataID.LIST_FRIEND,this.bind_friendListDP);
         bind(DataID.LIST_BLACKLIST,this.bind_blackList);
         bind(DataID.LIST_RECENTPLAYMATE,this.fillRecentPlaymateInfo);
         bind(DataID.REMOVE_FRIEND,this.bind_friendRemoved);
         bind(DataID.UPDATE_FRIEND_RICH_PRESENCE,this.bind_friendRichPresenceUpdated);
         bind(DataID.EAsyncTaskID_Demonware,this.bind_demonwareFriendStatusChange);
      }
      
      private function onAddFriendHandle(cEvt:ParaEvent) : void
      {
         var confirmAdd:Function = null;
         confirmAdd = function():void
         {
            var player:PlayerObj = PlayerObj.getObj();
            if(cEvt.myPara.value == player.name)
            {
               showMsg(DictInvitation.INVALID_FRIEND_NAME_YOURSELFT,MsgBtnCount.ONE);
               return;
            }
            request(DataID.PROPOSE_FRIEND_MEMBERSHIP,{
               "auto":true,
               "isName":cEvt.myPara.isName,
               "value":cEvt.myPara.value,
               "userName":cEvt.myPara.userName
            },onFriendMembershipProposed);
         };
         if(cEvt.myPara.value == null || cEvt.myPara.value.length == 0)
         {
            return;
         }
         if(Boolean(cEvt.myPara.isName) && Boolean(this.isInBlacklistByName(cEvt.myPara.value)) || !cEvt.myPara.isName && this.isInBlacklist(cEvt.myPara.value))
         {
            showMsg(DictInvitation.INVITE_GUY_IN_BLACK_LIST,MsgBtnCount.TWO,0,confirmAdd,DictSystem.CONFIRM,null,DictSystem.CANCEL);
         }
         else
         {
            confirmAdd();
         }
      }
      
      private function onRemoveFriendHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.id == null || cEvt.myPara.id.length == 0)
         {
            return;
         }
         this._currentConfirmRemoveFriendID = cEvt.myPara.id;
         var tempMsg:String = LocalizeUtil.localize(Dict.CONFIRM_DELETE_FRIEND);
         showMsg(tempMsg,MsgBtnCount.TWO,SystemMsgPriority.NORMAL,this.onConfirmDeleteFriend,DictSystem.CONFIRM,this.onCancelDeleteFriend);
      }
      
      private function onConfirmDeleteFriend() : void
      {
         CFunctionContainer.RemoveFriend(this._currentConfirmRemoveFriendID);
      }
      
      private function onRemoveRecentmetHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.id == null || cEvt.myPara.id.length == 0)
         {
            return;
         }
         this._currentConfirmRemoveRecentmetID = cEvt.myPara.id;
         Logger.print("ContactController::onRemoveRecentmetHandle:" + this._currentConfirmRemoveRecentmetID);
         var tempMsg:String = LocalizeUtil.localize(Dict.CONFIRM_DELETE_FRIEND);
         showMsg(tempMsg,MsgBtnCount.TWO,SystemMsgPriority.NORMAL,this.onConfirmDeleteRecentmet,DictSystem.CONFIRM,this.onCancelDeleteFriend);
      }
      
      private function onConfirmDeleteRecentmet() : void
      {
         Logger.print("ContactController::onConfirmDeleteRecentmet:" + this._currentConfirmRemoveRecentmetID);
         CFunctionContainer.RemoveRecentmet(this._currentConfirmRemoveRecentmetID);
      }
      
      private function onCancelDeleteFriend() : void
      {
         hideMsg();
      }
      
      private function onMoveFriendToBlackListHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.name == null || cEvt.myPara.name.length == 0)
         {
            return;
         }
         var res:uint = CFunctionContainer.AddToBlackList(cEvt.myPara.name,cEvt.myPara.id);
         var msg:String = "";
         switch(res)
         {
            case 0:
               request(DataID.LIST_BLACKLIST);
               msg = Dict.ADDED_INTO_BLACKLIST;
               showMsg(msg,MsgBtnCount.ONE);
               break;
            case 1:
               msg = Dict.BLACKLIST_FULL;
               showMsg(msg,MsgBtnCount.ONE);
               break;
            case 2:
               msg = Dict.BLACKLIST_EXISTED;
               showMsg(msg,MsgBtnCount.ONE);
         }
      }
      
      private function onRemoveFriendFromBlackListHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.name == null || cEvt.myPara.name.length == 0)
         {
            return;
         }
         CFunctionContainer.RemoveFromBlackList(cEvt.myPara.id);
         request(DataID.LIST_BLACKLIST);
         showMsg(Dict.REMOVED_FROM_BLACKLIST,MsgBtnCount.ONE);
      }
      
      private function onAcceptFriendProposalHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.senderID == null || cEvt.myPara.senderID.length == 0)
         {
            return;
         }
         CFunctionContainer.AS_MessageAccept(cEvt.myPara.messageid);
      }
      
      private function onRejectFriendProposalHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.senderID == null || cEvt.myPara.senderID.length == 0)
         {
            return;
         }
         CFunctionContainer.AS_MessageReject(cEvt.myPara.messageid);
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         this.fetchFriend();
         CFunctionContainer.RequireRecentmetData();
      }
      
      public function fillRecentPlaymateInfo(cRes:Object) : void
      {
         var player:RecentmetObj = null;
         this._recentPlaymates.splice(0);
         for(var i:int = 0; i < cRes.length; i++)
         {
            player = cRes[i] as RecentmetObj;
            if(Boolean(player))
            {
               this._recentPlaymates.push(player);
            }
         }
         this.updateRecent();
      }
      
      private function bind_blackList(cRes:Object) : void
      {
         this._blacklist = cRes.data;
         this.filterBlackList(this._friends,this._filteredFriends);
         setBindData(DataID.FILTERED_FRIEND,this._filteredFriends);
         this.filterBlackList(this._recentPlaymates,this._filteredPlaymates);
         setBindData(DataID.FILTERED_PLAYMATE,this._filteredPlaymates);
      }
      
      private function filterBlackList(rawData:Array, result:Array) : void
      {
         var found:Boolean = false;
         var j:int = 0;
         var rawDataLength:int = int(rawData.length);
         result.splice(0);
         var blacklistLength:int = int(this._blacklist.length);
         for(var i:int = 0; i < rawDataLength; i++)
         {
            found = false;
            for(j = 0; j < blacklistLength; j++)
            {
               if(this._blacklist[j].id == rawData[i].id)
               {
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               result.push(rawData[i]);
            }
         }
      }
      
      private function bind_friendListDP(cRes:Object) : void
      {
         var i:int = 0;
         var friendObj:FriendObj = null;
         var info:Object = null;
         var index:int = 0;
         var friends:Array = [];
         for(i = 0; i < this._friends.length; )
         {
            if(!DataUtil.isInArray(this._friends[i].id,cRes.data))
            {
               this._friends.splice(i,1);
            }
            else
            {
               i++;
            }
         }
         for(i = 0; i < cRes.data.length; i++)
         {
            info = cRes.data[i];
            index = DataUtil.indexInArray(info.id,this._friends);
            if(-1 != index)
            {
               friendObj = this._friends[index];
            }
            else
            {
               friendObj = new FriendObj();
            }
            this.fillFriendObj(friendObj,info);
            friends.push(friendObj);
         }
         this._friends = friends.concat();
         this.updateFriend();
      }
      
      private function onFriendMembershipProposed(cRes:Object) : void
      {
         Logger.print("ContactController:::onFriendMembershipProposed cRes.data: " + cRes.data);
         this.comScoreLogging("action_type","add_friend");
         hideMsg();
         showMsg(cRes.data,MsgBtnCount.ONE);
      }
      
      public function cppOnFriendUserNameChanged(userID:String, newName:String) : void
      {
         var friendObj:FriendObj = null;
         var idx:int = DataUtil.indexInArray(userID,this._friends);
         if(-1 != idx)
         {
            friendObj = this._friends[idx];
            friendObj.name = newName;
            this.updateFriend();
         }
      }
      
      public function cppOnFriendMembershipProposalResponded(responder:String, accept:Boolean) : void
      {
         Logger.print("ContactController:::cppOnFriendMembershipProposalResponded",responder,accept);
         var invitation:InvitationObj = new InvitationObj();
         invitation.title = accept ? DictInvitation.FRIEND_MEMBERSHIP_PROPOSAL_ACCEPTED : DictInvitation.FRIEND_MEMBERSHIP_PROPOSAL_REJECTED;
         invitation.type = accept ? InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED : InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED;
         invitation.targetName = responder;
         invitation.senderName = invitation.targetName;
         invitation.formattedTime = TimeUtil.now();
         invitation.isLog = true;
         broadcast(BCEvent.ADD_NEW_INVITATION,invitation);
      }
      
      public function cppOnClanMemberProposalResponded(responder:String, accept:Boolean) : void
      {
         var invitation:InvitationObj = new InvitationObj();
         invitation.title = accept ? DictInvitation.CLAN_MEMBERSHIP_PROPOSAL_ACCEPTED : DictInvitation.CLAN_MEMBERSHIP_PROPOSAL_REJECTED;
         invitation.type = accept ? InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED : InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED;
         invitation.targetName = responder;
         invitation.senderName = invitation.targetName;
         invitation.formattedTime = TimeUtil.now();
         invitation.isLog = true;
         broadcast(BCEvent.ADD_NEW_INVITATION,invitation);
      }
      
      public function cppOnClanApplicationResponded(responder:String, accept:Boolean) : void
      {
         Logger.print("ContactController:::cppOnClanApplicationResponded teamname: " + responder);
         var invitation:InvitationObj = new InvitationObj();
         invitation.title = LocalizeUtil.param(accept ? DictInvitation.CLAN_APPLICATION_ACCEPT : DictInvitation.CLAN_APPLICATION_REJECT,[responder]);
         invitation.type = accept ? InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED : InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED;
         invitation.targetName = responder;
         invitation.senderName = responder;
         invitation.formattedTime = TimeUtil.now();
         invitation.isLog = true;
         broadcast(BCEvent.ADD_NEW_INVITATION,invitation);
      }
      
      public function cppOnFriendAcceptProposalFailed(reason:uint = 0) : void
      {
         if(reason != 0)
         {
            showMsg(DictInvitation.FRIEND_LIST_FULL_CANTACCEPT,MsgBtnCount.ONE);
         }
      }
      
      private function bind_friendRemoved(cRes:Object) : void
      {
         var index:int = 0;
         if(cRes.data == null)
         {
            return;
         }
         if(Boolean(cRes.data.isRemoved))
         {
            index = DataUtil.indexInArray(cRes.data.id,this._friends);
            if(-1 != index)
            {
               this._friends.splice(index,1);
            }
         }
         this.updateFriend();
      }
      
      private function bind_friendRichPresenceUpdated(cRes:Object) : void
      {
         var aFriendRP:Object = null;
         var idx:int = 0;
         var friendObj:FriendObj = null;
         var rpArrays:Array = cRes.data;
         var hasChanges:Boolean = false;
         for(var i:int = 0; i < rpArrays.length; i++)
         {
            aFriendRP = rpArrays[i];
            idx = DataUtil.indexInArray(aFriendRP.id,this._friends);
            if(-1 != idx)
            {
               friendObj = this._friends[idx];
               friendObj.friendStatus = aFriendRP.friendStatus;
               friendObj.qqMembershipBits = aFriendRP.qqMembershipBits;
               friendObj.netCafePrivileges = aFriendRP.netcafePriviligeBits;
               hasChanges = true;
            }
         }
         if(hasChanges)
         {
            this.updateFriend();
         }
      }
      
      private function bind_demonwareFriendStatusChange(cRes:Object) : void
      {
         var i:uint = 0;
         for(i = 0; i < cRes.data.length; i++)
         {
            if(cRes.data[i].name == "friends" && cRes.data[i].status == DWServiceStatus.UNRESPONSIVE)
            {
               Logger.print("ContactController::bind_demonwareFriendStatusChange: friends UNRESPONSIVE - timestamp: " + cRes.data[i].timestamp + "\n");
            }
         }
      }
      
      private function updateFriend() : void
      {
         this._friends.sortOn(["friendStatus","name"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         setBindData(DataID.FRIENDS,this._friends);
         this.filterBlackList(this._friends,this._filteredFriends);
         setBindData(DataID.FILTERED_FRIEND,this._filteredFriends);
      }
      
      private function updateRecent() : void
      {
         var compResult:String = null;
         this._recentPlaymates.sortOn(["metTime","name"],[Array.NUMERIC | Array.DESCENDING,Array.DESCENDING]);
         for(var i:uint = 0; i < this._recentPlaymates.length; i++)
         {
            compResult = TimeUtil.compareDateWithCurrentData(this._recentPlaymates[i].metTime);
            this._recentPlaymates[i].displayName = this._recentPlaymates[i].name + " - " + compResult;
            if(Boolean(this._recentPlaymates[i].isOnline) && this._recentPlaymates[i].friendStatus == Common.CODO_BASIC_PRESENCE_OFFLINE)
            {
               this._recentPlaymates[i].friendStatus = Common.CODO_BASIC_PRESENCE_MENU;
            }
         }
         this.filterBlackList(this._recentPlaymates,this._filteredPlaymates);
         setBindData(DataID.FILTERED_PLAYMATE,this._filteredPlaymates);
         setBindData(DataID.RECENT_PLAYMATES,this._recentPlaymates);
      }
      
      private function fillFriendObj(friendObj:FriendObj, friendInfo:Object) : void
      {
         if(friendObj == null || friendInfo == null)
         {
            return;
         }
         friendObj.id = friendInfo.id;
         if(friendObj.name != "" && friendObj.name != friendInfo.name)
         {
            broadcast(BCEvent.EVT_DETECT_NAME_CHANGE,{
               "id":friendObj.id,
               "oldName":friendObj.name,
               "newName":friendInfo.name
            });
         }
         friendObj.name = friendInfo.name;
         friendObj.friendStatus = friendInfo.friendStatus;
         friendObj.qqMembershipBits = friendInfo.qqMembershipBits;
         friendObj.netCafePrivileges = friendInfo.netCafePrivileges;
      }
      
      private function isFriend(cUser:Object) : Boolean
      {
         for(var i:int = 0; i < this._friends.length; i++)
         {
            if(this._friends[i].id == cUser.id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isFriendOnline(userID:String) : Boolean
      {
         for(var i:int = 0; i < this._friends.length; i++)
         {
            if(this._friends[i].id == userID)
            {
               return this._friends[i].friendStatus >= Common.CODO_BASIC_PRESENCE_MENU;
            }
         }
         return true;
      }
      
      private function getFriendObjById(userID:String) : FriendObj
      {
         for(var i:int = 0; i < this._friends.length; i++)
         {
            if(this._friends[i].id == userID)
            {
               return this._friends[i];
            }
         }
         return null;
      }
      
      private function getFriends(newCopy:Boolean = false) : Array
      {
         return newCopy ? this._friends.concat() : this._friends;
      }
      
      private function getFilteredFriends(newCopy:Boolean = false) : Array
      {
         return newCopy ? this._filteredFriends.concat() : this._filteredFriends;
      }
      
      private function getRecentPlayermate(newCopy:Boolean = false) : Array
      {
         return newCopy ? this._recentPlaymates.concat() : this._recentPlaymates;
      }
      
      private function getFilteredRecentPlaymate(newCopy:Boolean = false) : Array
      {
         return newCopy ? this._filteredPlaymates.concat() : this._filteredPlaymates;
      }
      
      private function fetchFriend() : void
      {
         if(!this._isContactFetched)
         {
            this._isContactFetched = true;
            request(DataID.LIST_FRIEND,{
               "type":ContactListType.FRIEND,
               "auto":true
            });
            request(DataID.LIST_RECENTPLAYMATE,{
               "type":ContactListType.RECENT,
               "auto":true
            });
            request(DataID.LIST_BLACKLIST);
         }
      }
      
      private function getFriendUserName(clanName:String) : String
      {
         for(var i:int = 0; i < this._friends.length; i++)
         {
            if(this._friends[i].name == clanName)
            {
               return this._friends[i].name;
            }
         }
         return clanName;
      }
      
      private function getMutInfo() : Object
      {
         return CFunctionContainer.GetMutInfo();
      }
      
      private function isInBlacklist(id:String) : Boolean
      {
         return CFunctionContainer.IsInBlackList(id) as Boolean;
      }
      
      private function isInBlacklistByName(name:String) : Boolean
      {
         return CFunctionContainer.IsInBlackListByName(name) as Boolean;
      }
      
      public function GetFriendData(id:String) : UserObj
      {
         for(var i:int = 0; i < this._friends.length; i++)
         {
            if(this._friends[i].id == id)
            {
               return this._friends[i];
            }
         }
         return null;
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

