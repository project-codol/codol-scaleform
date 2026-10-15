package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.localization.DictClan;
   import codo.utils.Logger;
   import com.society.comscore.DAXDispatcher;
   
   public class ClanService extends ServiceBase
   {
      
      private static var _instance:ClanService;
      
      private var _isInClan:Boolean = false;
      
      public function ClanService()
      {
         super(ServiceID.CLAN);
      }
      
      public static function getInstance() : ClanService
      {
         if(ClanService._instance == null)
         {
            ClanService._instance = new ClanService();
         }
         return ClanService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.LIST_CLAN,this.listClan);
         this.register(DataID.CREATE_CLAN,this.createClan);
         this.register(DataID.LEAVE_CLAN,this.leaveClan);
         this.register(DataID.RENAME_CLAN,this.renameClan);
         this.register(DataID.PROMOTE_CLAN_MEMBER,this.promoteClanMember);
         this.register(DataID.DEMOTE_CLAN_MEMBER,this.demoteClanMember);
         this.register(DataID.KICK_CLAN_MEMBER,this.kickClanMember);
         this.register(DataID.APPLY_TO_JOIN_CLAN,this.applyToJoinClan);
         this.register(DataID.PROPOSE_CLAN_MEMBERSHIP,this.proposeClanMembership);
         this.register(DataID.WITHDRAW_CLAN_PROPOSAL,this.withdrawClanProposal);
         this.register(DataID.ACCEPT_CLAN_MEMBERSHIP,this.acceptClanMembership);
         this.register(DataID.REJECT_CLAN_MEMBERSHIP,this.rejectClanMembership);
         this.register(DataID.SET_CLAN_PROFILE,this.setClanProfile);
         this.register(DataID.SET_CLAN_MEMBER_PROFILE,this.setClanMemberProfile);
      }
      
      public function isAcceptingClanMembership() : Boolean
      {
         return this.isTaskInProgress(DataID.ACCEPT_CLAN_MEMBERSHIP);
      }
      
      private function listClan() : void
      {
         CFunctionContainer.ListClan();
      }
      
      private function createClan(name:String) : void
      {
         if(this.createTask(DataID.CREATE_CLAN,AsyncTaskGroup.CLAN,name))
         {
            this.comScoreLogging("action_type","create_clan");
            this.showMsg(DictClan.NOTE_CREATE_CLAN);
         }
      }
      
      private function leaveClan(newOwner:String) : void
      {
         if(this.createTask(DataID.LEAVE_CLAN,AsyncTaskGroup.CLAN,{"newOwner":newOwner}))
         {
            this.comScoreLogging("action_type","leave_clan");
            this.showMsg(DictClan.NOTE_LEAVE_CLAN);
         }
      }
      
      private function renameClan(newName:String) : void
      {
         if(this.createTask(DataID.RENAME_CLAN,AsyncTaskGroup.CLAN,newName))
         {
            this.comScoreLogging("action_type","rename_clan");
            this.showMsg(DictClan.NOTE_RENAME_CLAN);
         }
      }
      
      private function promoteClanMember(params:Object) : void
      {
         if(this.createTask(DataID.PROMOTE_CLAN_MEMBER,AsyncTaskGroup.CLAN,{
            "user":params.userObj,
            "type":params.type,
            "queue":true
         }))
         {
            this.comScoreLogging("action_type","promote_player");
            this.showMsg(DictClan.NOTE_PROMOTE_CLAN_MEM);
         }
      }
      
      private function demoteClanMember(userObj:Object) : void
      {
         if(this.createTask(DataID.DEMOTE_CLAN_MEMBER,AsyncTaskGroup.CLAN,{
            "user":userObj,
            "queue":true
         }))
         {
            this.comScoreLogging("action_type","demote_player");
            this.showMsg(DictClan.NOTE_DEMOTE_CLAN_MEM);
         }
      }
      
      private function kickClanMember(userObj:Object) : void
      {
         if(this.createTask(DataID.KICK_CLAN_MEMBER,AsyncTaskGroup.CLAN,{
            "user":userObj,
            "queue":true
         }))
         {
            this.comScoreLogging("action_type","kick_player");
            this.showMsg(DictClan.NOTE_KICK_CLAN_MEM);
         }
      }
      
      private function proposeClanMembership(userObj:Object) : void
      {
         this.createTask(DataID.PROPOSE_CLAN_MEMBERSHIP,AsyncTaskGroup.CLAN,{
            "user":userObj,
            "queue":true
         });
      }
      
      private function withdrawClanProposal() : void
      {
      }
      
      private function acceptClanMembership(invitationObj:Object) : void
      {
         this.createTask(DataID.ACCEPT_CLAN_MEMBERSHIP,AsyncTaskGroup.CLAN,{
            "invitation":invitationObj,
            "queue":true
         });
      }
      
      private function rejectClanMembership(invitationObj:Object) : void
      {
         this.comScoreLogging("action_type","decline_clan_application");
         this.createTask(DataID.REJECT_CLAN_MEMBERSHIP,AsyncTaskGroup.CLAN,{
            "invitation":invitationObj,
            "queue":true
         });
      }
      
      private function setClanProfile() : void
      {
      }
      
      private function setClanMemberProfile() : void
      {
      }
      
      private function applyToJoinClan(para:Object) : void
      {
         CFunctionContainer.ApplyForClan(para);
      }
      
      public function set isInClan(cIn:Boolean) : void
      {
         this._isInClan = cIn;
      }
      
      public function get isInClan() : Boolean
      {
         return CFunctionContainer.IsInClan() as Boolean;
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

