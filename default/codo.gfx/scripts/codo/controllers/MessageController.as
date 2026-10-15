package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.InvitationType;
   import codo.event.ParaEvent;
   import codo.localization.DictInvitation;
   
   public class MessageController extends BaseController
   {
      
      private var _clanApplicationKeeper:Array = [];
      
      public function MessageController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
         this.listen(BCEvent.EVT_DELETE_ALL_CLAN_APPLICATION,this.onDeleteAllClanApplicationHandler);
         this.listen(BCEvent.MESSAGE_REFRESH_ALL,this.onMessageRefreshAll);
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_MessageActiveFetch();
      }
      
      public function cppOnMessageUpdate(whatevet:int, allMessages:Array) : void
      {
         var i:int = 0;
         for(i = 0; i < allMessages.length; i++)
         {
            this.addTitle(allMessages[i]);
         }
         var friendInvitation:Array = new Array();
         var clanInvitation:Array = new Array();
         var partyInvitation:Array = new Array();
         var roomInvitation:Array = new Array();
         var mailMessage:Array = new Array();
         var clanApplication:Array = new Array();
         var systemMessage:Array = new Array();
         for(i = 0; i < allMessages.length; i++)
         {
            if(allMessages[i].type == InvitationType.FRIEND)
            {
               friendInvitation.push(allMessages[i]);
            }
            else if(allMessages[i].type == InvitationType.PARTY)
            {
               clanInvitation.push(allMessages[i]);
            }
            else if(allMessages[i].type == InvitationType.CLAN)
            {
               partyInvitation.push(allMessages[i]);
            }
            else if(allMessages[i].type == InvitationType.ROOM)
            {
               roomInvitation.push(allMessages[i]);
            }
            else if(allMessages[i].type == InvitationType.Message_MAIL)
            {
               mailMessage.push(allMessages[i]);
            }
            else if(allMessages[i].type == InvitationType.CLAN_APPLICATION)
            {
               if(Boolean(getDP(DataID.IS_CLAN_OWNER)))
               {
                  clanApplication.push(allMessages[i]);
               }
            }
            else if(allMessages[i].type == InvitationType.SYSTEM)
            {
               systemMessage.push(allMessages[i]);
            }
         }
         this.setBindData(DataID.MESSAGE_FRIEND,{"dp":friendInvitation});
         this.setBindData(DataID.MESSAGE_PARTY,{"dp":clanInvitation});
         this.setBindData(DataID.MESSAGE_CLAN,{"dp":partyInvitation});
         this.setBindData(DataID.MESSAGE_BOX,{"dp":roomInvitation});
         this.setBindData(DataID.MESSAGE_CLAN_APPLICATION,{"dp":clanApplication});
         this.setBindData(DataID.MESSAGE_SYSTEM,{"dp":systemMessage});
         this._clanApplicationKeeper = clanApplication;
         this.broadcast(BCEvent.MESSAGE_MAILRAWDATA,mailMessage);
      }
      
      private function onDeleteAllClanApplicationHandler(cEvt:ParaEvent) : void
      {
         var messageid:uint = 0;
         var clanAppCount:int = int(this._clanApplicationKeeper.length);
         for(var i:int = 0; i < clanAppCount; i++)
         {
            messageid = uint(this._clanApplicationKeeper[i].messageid);
            CFunctionContainer.AS_MessageDelete(messageid);
         }
      }
      
      private function onMessageRefreshAll(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_MessageActiveFetch();
      }
      
      private function addTitle(message:Object) : void
      {
         if(message == null)
         {
            return;
         }
         switch(message.type)
         {
            case InvitationType.PARTY:
               message.title = DictInvitation.INVITE_PARTY;
               break;
            case InvitationType.CLAN:
               message.title = DictInvitation.INVITE_CLAN;
               break;
            case InvitationType.FRIEND:
               message.title = DictInvitation.INVITE_ADD_FRIEND;
               break;
            case InvitationType.ROOM:
               message.title = DictInvitation.INVITE_GAME;
               break;
            case InvitationType.FRIEND_OUTGOING_PROPOSAL:
               message.title = DictInvitation.FRIEND_MEMBERSHIP_PROPOSED;
               break;
            case InvitationType.FRIEND_OUTGOING_PROPOSAL_ACCEPTED:
            case InvitationType.FRIEND_OUTGOING_PROPOSAL_REJECTED:
               break;
            case InvitationType.GAME_OUTGOING_PROPOSAL:
               message.title = DictInvitation.GAME_INVITATION_SENT;
               break;
            case InvitationType.CLAN_APPLICATION:
               message.title = DictInvitation.INVITE_CLAN_APPLICATION;
         }
      }
   }
}

