package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.ClanMemberPosition;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.PlayListType;
   import codo.constants.RightClickMenuType;
   import codo.event.ParaEvent;
   import codo.localization.*;
   import codo.objects.PlayListObj;
   import codo.objects.RightClickMenuItemObj;
   import codo.objects.UserObj;
   
   public class RightClickMenuController extends BaseController
   {
      
      private var _rightClickMenuItemsDetailOnly:Vector.<RightClickMenuItemObj>;
      
      private var _rightClickMenuItemsFull:Vector.<RightClickMenuItemObj>;
      
      private var _rightClickMenuItemsBlacklist:Vector.<RightClickMenuItemObj>;
      
      private var _userToInviteToParty:UserObj;
      
      private var _optDetail:RightClickMenuItemObj;
      
      private var _optChat:RightClickMenuItemObj;
      
      private var _optAddFriend:RightClickMenuItemObj;
      
      private var _optDeleteFriend:RightClickMenuItemObj;
      
      private var _optInviteGame:RightClickMenuItemObj;
      
      private var _optInviteParty:RightClickMenuItemObj;
      
      private var _optReassignPartyLeader:RightClickMenuItemObj;
      
      private var _optKickPartyMember:RightClickMenuItemObj;
      
      private var _optInviteClan:RightClickMenuItemObj;
      
      private var _optPromptClanMember:RightClickMenuItemObj;
      
      private var _optDemoteClanMember:RightClickMenuItemObj;
      
      private var _optKickClanMember:RightClickMenuItemObj;
      
      private var _optReport:RightClickMenuItemObj;
      
      private var _optAddBlacklist:RightClickMenuItemObj;
      
      private var _optRemoveBlacklist:RightClickMenuItemObj;
      
      public function RightClickMenuController()
      {
         this._optDetail = new RightClickMenuItemObj({
            "label":DictClan.BUTTON_DETAIL_LABEL,
            "handle":this.onShowPlayerDetailProfileHandle,
            "enableChecker":this.canShowPlayerDetailInfo
         });
         this._optChat = new RightClickMenuItemObj({
            "label":DictRightClick.SEND_PRIVATE_MESSAGE,
            "handle":this.onInviteToPrivateChatHandle,
            "enableChecker":this.canInviteToPrivateChat
         });
         this._optAddFriend = new RightClickMenuItemObj({
            "label":DictRightClick.ADD_TO_FRIEND,
            "handle":this.onAddToFriendHandle,
            "enableChecker":this.canInviteToFriend
         });
         this._optDeleteFriend = new RightClickMenuItemObj({
            "label":DictRightClick.DELETE_FRIEND,
            "handle":this.onDeleteFriendHandle,
            "enableChecker":this.canDeleteFriend
         });
         this._optInviteGame = new RightClickMenuItemObj({
            "label":DictRightClick.INVITE_TO_GAME,
            "handle":this.onInviteToGameHandle,
            "enableChecker":this.canInviteToGame
         });
         this._optInviteParty = new RightClickMenuItemObj({
            "label":DictRightClick.INVITE_TO_PARTY,
            "handle":this.onInviteToPartyHandle,
            "enableChecker":this.canInviteToParty
         });
         this._optReassignPartyLeader = new RightClickMenuItemObj({
            "label":DictParty.REASSIGN_PARTY_LEADER,
            "handle":this.onReassignPartyLeaderHandle,
            "enableChecker":this.canReassignPartyLeader
         });
         this._optKickPartyMember = new RightClickMenuItemObj({
            "label":DictParty.KICK_OUT_PARTY,
            "handle":this.onKickPartyMemberHandle,
            "enableChecker":this.canKickPartyMember
         });
         this._optInviteClan = new RightClickMenuItemObj({
            "label":DictRightClick.INVITE_TO_CLAN,
            "handle":this.onInviteToClanHandle,
            "enableChecker":this.canInviteToClan
         });
         this._optPromptClanMember = new RightClickMenuItemObj({
            "label":DictClan.CLAN_PROMOTE_MEMBER,
            "handle":this.onPromoteClanMember,
            "enableChecker":this.canPromoteClanMember
         });
         this._optDemoteClanMember = new RightClickMenuItemObj({
            "label":DictClan.CLAN_DEMOTE_MEMBER,
            "handle":this.onDemoteClanMember,
            "enableChecker":this.canDemoteClanMember
         });
         this._optKickClanMember = new RightClickMenuItemObj({
            "label":DictClan.CLAN_KICK_MEMBER,
            "handle":this.onKickClanMemberHandle,
            "enableChecker":this.canKickClanMember
         });
         this._optReport = new RightClickMenuItemObj({
            "label":Dict.REPORT_USER,
            "handle":this.onReportHandle,
            "enableChecker":this.canReportUser
         });
         this._optAddBlacklist = new RightClickMenuItemObj({
            "label":DictRightClick.BLOCK_USER,
            "handle":this.onBlockFriendHandle,
            "enableChecker":this.canBlacklistUser
         });
         this._optRemoveBlacklist = new RightClickMenuItemObj({
            "label":DictRightClick.UNBLOCK_USER,
            "handle":this.onUnBlockFriendHandle,
            "enableChecker":this.canUnblacklistUser
         });
         super();
         this._rightClickMenuItemsDetailOnly = Vector.<RightClickMenuItemObj>([this._optDetail]);
         this._rightClickMenuItemsFull = Vector.<RightClickMenuItemObj>([this._optDetail,this._optInviteParty,this._optChat,this._optReport,this._optAddFriend,this._optDeleteFriend,this._optInviteGame,this._optReassignPartyLeader,this._optKickPartyMember,this._optInviteClan,this._optPromptClanMember,this._optDemoteClanMember,this._optKickClanMember,this._optAddBlacklist,this._optRemoveBlacklist]);
         this._rightClickMenuItemsBlacklist = Vector.<RightClickMenuItemObj>([this._optRemoveBlacklist]);
      }
      
      override protected function onInitialized() : void
      {
         addDP(DataID.RIGHT_CLICK_MENU,this.generateRightClickMenu);
         addDP(DataID.ENABLE_FLOATING_PLAYERCARD,this.isEnableFloatingPlayerCard);
         listen(BCEvent.PARTY_JOINED,this.onPartyJoinedHandle);
         listen(BCEvent.JOIN_ROOM_BY_TICKET,this.onJoinRoomByTicketHandle);
      }
      
      private function generateRightClickMenu(cType:String, cUser:Object) : Vector.<RightClickMenuItemObj>
      {
         var rightClickMenuItems:Vector.<RightClickMenuItemObj> = null;
         switch(cType)
         {
            case RightClickMenuType.FULL:
               rightClickMenuItems = this._rightClickMenuItemsFull;
               break;
            case RightClickMenuType.DETAIL_ONLY:
               rightClickMenuItems = this._rightClickMenuItemsDetailOnly;
               break;
            case RightClickMenuType.BLACKLIST:
               rightClickMenuItems = this._rightClickMenuItemsBlacklist;
         }
         var userObj:UserObj = cUser is UserObj ? cUser as UserObj : new UserObj(cUser);
         var numRightClickMenuItems:int = int(rightClickMenuItems.length);
         for(var i:int = 0; i < numRightClickMenuItems; i++)
         {
            rightClickMenuItems[i].enable = rightClickMenuItems[i].enableChecker(userObj);
         }
         return rightClickMenuItems;
      }
      
      private function isEnableFloatingPlayerCard() : Boolean
      {
         return !getDvarBool("ui_lock_floatingPlayerCard");
      }
      
      private function canShowPlayerDetailInfo(cUser:UserObj) : Boolean
      {
         return true;
      }
      
      private function canInviteToPrivateChat(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser);
      }
      
      private function canInviteToFriend(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && !this.isMyFriend(cUser) && cUser.name != getDP(DataID.PLAYER_NAME_WITH_CLANTAG);
      }
      
      private function canDeleteFriend(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && this.isMyFriend(cUser);
      }
      
      private function canInviteToGame(cUser:UserObj) : Boolean
      {
         var playlist:PlayListObj = null;
         if(this.isMe(cUser))
         {
            return false;
         }
         if(!getDP(DataID.IS_IN_ROOM))
         {
            return false;
         }
         if(this.isRoomFull())
         {
            return false;
         }
         if(this.isInMyRoom(cUser))
         {
            return false;
         }
         if(Boolean(CFunctionContainer.IsRankedMatch()))
         {
            return false;
         }
         var roomInfo:Object = CFunctionContainer.GetRoomInfo();
         if(roomInfo != null && roomInfo.playListID >= 0)
         {
            playlist = getDP(DataID.PLAY_LIST_OBJ,[roomInfo.playListID]);
            if(playlist.type == PlayListType.COMBAT)
            {
               return false;
            }
         }
         return true;
      }
      
      private function canInviteToParty(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && !this.isInMyParty(cUser);
      }
      
      private function canReassignPartyLeader(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && this.isPartyHost() && !this.isInRoom() && !this.isRankedMatch() && this.isInMyParty(cUser);
      }
      
      private function canKickPartyMember(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && this.isPartyHost() && !this.isInRoom() && !this.isRankedMatch() && this.isInMyParty(cUser);
      }
      
      private function canInviteToClan(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && Boolean(getDP(DataID.CAN_PROPOSE_CLAN_MEMBERSHIP,[cUser]));
      }
      
      private function canPromoteClanMember(cUser:UserObj) : Boolean
      {
         var myId:String = null;
         var myClanUserObj:UserObj = null;
         var clanUserObj:UserObj = null;
         var result:Boolean = false;
         var isInClan:Boolean = getDP(DataID.IS_IN_CLAN);
         var isInMyClan:Boolean = getDP(DataID.IS_IN_MY_CLAN,[cUser]);
         if(isInClan == true && isInMyClan == true)
         {
            myId = CFunctionCommonContainer.GetPlayerID();
            myClanUserObj = getDP(DataID.PLAYER_QUERY_CLAN,[myId]);
            clanUserObj = getDP(DataID.PLAYER_QUERY_CLAN,[cUser.id]);
            if(Boolean(myClanUserObj) && myClanUserObj.clanPos == ClanMemberPosition.OWNER)
            {
               result = clanUserObj.clanPos == ClanMemberPosition.ORDINARY || clanUserObj.clanPos == ClanMemberPosition.ADMIN;
            }
         }
         return result;
      }
      
      private function canDemoteClanMember(cUser:UserObj) : Boolean
      {
         var myId:String = null;
         var myClanUserObj:UserObj = null;
         var clanUserObj:UserObj = null;
         var result:Boolean = false;
         var isInClan:Boolean = getDP(DataID.IS_IN_CLAN);
         if(isInClan == true && Boolean(getDP(DataID.IS_IN_MY_CLAN,[cUser])))
         {
            myId = CFunctionCommonContainer.GetPlayerID();
            myClanUserObj = getDP(DataID.PLAYER_QUERY_CLAN,[myId]);
            clanUserObj = getDP(DataID.PLAYER_QUERY_CLAN,[cUser.id]);
            if(Boolean(myClanUserObj) && myClanUserObj.clanPos == ClanMemberPosition.OWNER)
            {
               result = clanUserObj.clanPos == ClanMemberPosition.ADMIN;
            }
         }
         return result;
      }
      
      private function canKickClanMember(cUser:UserObj) : Boolean
      {
         var myId:String = null;
         var myClanUserObj:UserObj = null;
         var clanUserObj:UserObj = null;
         var result:Boolean = false;
         var isInClan:Boolean = getDP(DataID.IS_IN_CLAN);
         if(!this.isMe(cUser) && isInClan && Boolean(getDP(DataID.IS_IN_MY_CLAN,[cUser])))
         {
            myId = CFunctionCommonContainer.GetPlayerID();
            myClanUserObj = getDP(DataID.PLAYER_QUERY_CLAN,[myId]);
            clanUserObj = getDP(DataID.PLAYER_QUERY_CLAN,[cUser.id]);
            if(Boolean(myClanUserObj) && myClanUserObj.clanPos == ClanMemberPosition.OWNER)
            {
               result = true;
            }
            else if(Boolean(myClanUserObj) && myClanUserObj.clanPos == ClanMemberPosition.ADMIN)
            {
               result = clanUserObj.clanPos == ClanMemberPosition.ORDINARY;
            }
         }
         return result;
      }
      
      private function canReportUser(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser);
      }
      
      private function canBlacklistUser(cUser:UserObj) : Boolean
      {
         return !this.isMe(cUser) && !this.isInBlackList(cUser.id);
      }
      
      private function canUnblacklistUser(cUser:UserObj) : Boolean
      {
         return this.isInBlackList(cUser.id);
      }
      
      private function onShowPlayerDetailProfileHandle(cUser:Object) : void
      {
         broadcast(BCEvent.VIEW_PLAYER_DETAIL_INFO,{
            "id":cUser.id,
            "name":cUser.name
         });
      }
      
      private function onInviteToPrivateChatHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_START_PRIVATE_CHAT,cUser);
      }
      
      private function onAddToFriendHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_ADD_FRIEND,{
            "isName":false,
            "value":cUser.id
         });
      }
      
      private function onDeleteFriendHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_DELETE_FRIEND,cUser);
      }
      
      private function onInviteToGameHandle(cUser:Object) : void
      {
         var InviteFriend:Function;
         if(!getDP(DataID.IS_IN_ROOM))
         {
            showMsg(DictRoom.NOTE_INVALID_ROOM,MsgBtnCount.ONE);
            return;
         }
         InviteFriend = function():void
         {
            broadcast(BCEvent.PROPOSE_ROOM_MEMBERSHIP,cUser);
         };
         InviteFriend();
      }
      
      private function onInviteToPartyHandle(cUser:Object) : void
      {
         if(this.isInParty())
         {
            broadcast(BCEvent.EVT_PROPOSE_PARTY_MEMBERSHIP,[cUser]);
         }
         else
         {
            this._userToInviteToParty = cUser as UserObj;
            broadcast(BCEvent.PARTY_CREATE);
         }
      }
      
      private function onReassignPartyLeaderHandle(cUser:Object) : void
      {
         if(Boolean(getDP(DataID.IS_IN_MY_PARTY,[cUser])))
         {
            broadcast(BCEvent.EVT_PROMOTE_PARTY_MEMBER,cUser);
         }
      }
      
      private function onKickPartyMemberHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_KICK_PARTY_MEMBER,cUser);
      }
      
      private function onInviteToClanHandle(cUser:Object) : void
      {
         if(this.canInviteToClan(cUser as UserObj))
         {
            broadcast(BCEvent.INVITE_USERS_TO_CLAN,{"users":[cUser]});
         }
      }
      
      public function onPromoteClanMember(cUser:Object) : void
      {
         var clanUserObj:UserObj = this.getDP(DataID.PLAYER_QUERY_CLAN,[cUser.id]);
         broadcast(BCEvent.PROMOTE_CLAN_MEMBER,clanUserObj);
      }
      
      public function onDemoteClanMember(cUser:Object) : void
      {
         var clanUserObj:UserObj = this.getDP(DataID.PLAYER_QUERY_CLAN,[cUser.id]);
         broadcast(BCEvent.DEMOTE_CLAN_MEMBER,clanUserObj);
      }
      
      public function onKickClanMemberHandle(cUser:Object) : void
      {
         var clanUserObj:UserObj = this.getDP(DataID.PLAYER_QUERY_CLAN,[cUser.id]);
         broadcast(BCEvent.KICK_CLAN_MEMBER,clanUserObj);
      }
      
      private function onReportHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_REPORT_PLAYER,{
            "target":cUser,
            "playerList":[cUser]
         });
      }
      
      private function onBlockFriendHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_MOVE_FRIEND_TO_BLACKLIST,cUser);
      }
      
      private function onUnBlockFriendHandle(cUser:Object) : void
      {
         broadcast(BCEvent.EVT_REMOVE_FRIEND_FROM_BLACKLIST,cUser);
      }
      
      private function onPartyJoinedHandle(cEvt:ParaEvent) : void
      {
         if(this._userToInviteToParty != null)
         {
            if(this.isInParty() && this.isPartyHost())
            {
               this.broadcast(BCEvent.EVT_PROPOSE_PARTY_MEMBERSHIP,[this._userToInviteToParty]);
               this._userToInviteToParty = null;
            }
         }
      }
      
      private function isRankedMatch() : Boolean
      {
         return getDP(DataID.IS_IN_RANKED_MATCH);
      }
      
      private function isRoomFull() : Boolean
      {
         return getDP(DataID.IS_ROOM_FULL);
      }
      
      private function isInRoom() : Boolean
      {
         return getDP(DataID.IS_IN_ROOM);
      }
      
      private function isInMyRoom(cUser:UserObj) : Boolean
      {
         return getDP(DataID.IS_IN_MY_ROOM,[cUser]);
      }
      
      private function isInParty() : Boolean
      {
         return getDP(DataID.IS_IN_PARTY);
      }
      
      private function isPartyHost() : Boolean
      {
         return getDP(DataID.IS_PARTY_HOST);
      }
      
      private function isInMyParty(cUser:UserObj) : Boolean
      {
         return getDP(DataID.IS_IN_MY_PARTY,[cUser]);
      }
      
      private function isMe(cUser:UserObj) : Boolean
      {
         return getDP(DataID.IS_ME,[cUser]);
      }
      
      private function isMyFriend(cUser:Object) : Boolean
      {
         return getDP(DataID.IS_FRIEND,[cUser]);
      }
      
      private function isInBlackList(id:String) : Boolean
      {
         return Boolean(getDP(DataID.GET_IS_IN_BLACKLIST,[id]));
      }
      
      private function onJoinRoomByTicketHandle(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.JOIN_ROOM,{
            "invite":{
               "senderID":cEvt.myPara.inviter,
               "targetID":cEvt.myPara.session
            },
            "ticket":true
         });
      }
   }
}

