package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.ServiceID;
   import codo.localization.DictParty;
   
   public class PartyService extends ServiceBase
   {
      
      private static var _instance:PartyService;
      
      public function PartyService()
      {
         super(ServiceID.PARTY);
      }
      
      public static function getInstance() : PartyService
      {
         if(PartyService._instance == null)
         {
            PartyService._instance = new PartyService();
         }
         return PartyService._instance;
      }
      
      override public function init() : void
      {
         register(DataID.CREATE_PARTY,this.createParty);
         register(DataID.JOIN_PARTY,this.joinParty);
         register(DataID.LEAVE_PARTY,this.leaveParty);
      }
      
      private function createParty() : void
      {
         if(createTask(DataID.CREATE_PARTY,AsyncTaskGroup.PARTY,null,null))
         {
            showMsg(DictParty.NOTE_CREATE_PARTY);
         }
      }
      
      private function joinParty(msgObj:Object) : void
      {
         if(this.isInParty)
         {
            showMsg(DictParty.NOTE_ALREADY_IN_PARTY,MsgBtnCount.ONE);
            return;
         }
         if(createTask(DataID.JOIN_PARTY,AsyncTaskGroup.PARTY,msgObj))
         {
            showMsg(DictParty.NOTE_JOIN_PARTY);
         }
      }
      
      private function leaveParty() : void
      {
         if(!this.isInParty)
         {
            return;
         }
         if(createTask(DataID.LEAVE_PARTY,AsyncTaskGroup.PARTY))
         {
            showMsg(DictParty.NOTE_LEAVE_PARTY);
         }
      }
      
      public function get isInParty() : Boolean
      {
         return CFunctionContainer.IsInParty() as Boolean;
      }
   }
}

