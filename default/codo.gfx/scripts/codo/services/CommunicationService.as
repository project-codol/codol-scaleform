package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.objects.MailObj;
   import codo.utils.ScaleformUtil;
   
   public class CommunicationService extends ServiceBase
   {
      
      private static var _instance:CommunicationService;
      
      private var _fakeMailHeaders:Array = [];
      
      private var _fakeMailBodies:Array = [];
      
      public function CommunicationService()
      {
         super(ServiceID.COMMUNICATION);
      }
      
      public static function getInstance() : CommunicationService
      {
         if(CommunicationService._instance == null)
         {
            CommunicationService._instance = new CommunicationService();
         }
         return CommunicationService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.ENABLE_VOICE_TALK,this.enableVoiceChat);
         this.register(DataID.SEND_CLAN_INSTANT_MESSAGE,this.sendClanInstantMessage);
         this.register(DataID.SEND_GLOBAL_INSTANT_MESSAGE,this.sendGlobalInstantMessage);
         this.register(DataID.SEND_MAIL,this.sendMail);
         this.register(DataID.FETCH_MAIL_HEADERS,this.fetchMailHeaders);
         this.register(DataID.FETCH_MAIL_BODIES,this.fetchMailBodies);
         this.register(DataID.DELETE_MAILS,this.deleteMails);
         this.register(DataID.FETCH_CLAN_MAIL_HEADERS,this.fetchClanMailHeaders);
         this.register(DataID.DELETE_CLAN_MAILS,this.deleteClanMails);
      }
      
      private function get fakeMailHeaders() : Array
      {
         var i:uint = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeMailHeaders.length <= 0)
         {
            for(i = 1; i <= 15; i++)
            {
               this._fakeMailHeaders.push(new MailObj({
                  "senderName":"ANDY0" + i,
                  "senderID":i.toString(),
                  "id":i.toString(),
                  "timeStamp":String((new Date().time + i * 99999) / 1000)
               }));
            }
         }
         return this._fakeMailHeaders;
      }
      
      private function get fakeMailBodies() : Array
      {
         var i:uint = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeMailBodies.length <= 0)
         {
            for(i = 1; i <= 15; i++)
            {
               this._fakeMailBodies.push(new MailObj({
                  "message":"<A>" + String(i % 2 == 0 ? 11111 * i : "") + "</A>" + "<T>MailTile" + i + "</T>" + "<M>" + i + "</M>",
                  "id":i.toString()
               }));
            }
         }
         return this._fakeMailBodies;
      }
      
      private function enableVoiceChat(cParams:Object) : void
      {
         CFunctionContainer.EnableVoiceTalk(cParams);
      }
      
      private function sendClanInstantMessage(msgObj:Object) : void
      {
         CFunctionContainer.SendTeamInstantMessage(msgObj);
      }
      
      private function sendGlobalInstantMessage(msgObj:Object) : void
      {
         CFunctionContainer.SendGlobalInstantMessage(msgObj);
      }
      
      private function sendMail(mail:MailObj) : void
      {
         this.createTask(DataID.SEND_MAIL,AsyncTaskGroup.MAIL,{
            "auto":true,
            "feedback":false,
            "mail":mail
         });
      }
      
      private function fetchMailHeaders(startIndex:uint) : void
      {
         this.createTask(DataID.FETCH_MAIL_HEADERS,AsyncTaskGroup.MAIL,{
            "auto":true,
            "feedback":false,
            "startIndex":startIndex
         },this.fakeMailHeaders);
      }
      
      private function fetchMailBodies(mailHeaders:Array) : void
      {
         this.createTask(DataID.FETCH_MAIL_BODIES,AsyncTaskGroup.MAIL,{
            "auto":true,
            "feedback":false,
            "headers":mailHeaders
         },this.fakeMailBodies);
      }
      
      private function deleteMails(mailIDs:Array) : void
      {
         this.createTask(DataID.DELETE_MAILS,AsyncTaskGroup.MAIL,{
            "auto":true,
            "feedback":false,
            "mails":mailIDs
         });
      }
      
      private function fetchClanMailHeaders(startIndex:uint) : void
      {
         this.createTask(DataID.FETCH_CLAN_MAIL_HEADERS,AsyncTaskGroup.MAIL,{
            "auto":true,
            "startIndex":startIndex
         });
      }
      
      private function deleteClanMails(mails:Array) : void
      {
         this.createTask(DataID.DELETE_CLAN_MAILS,AsyncTaskGroup.MAIL,{
            "auto":true,
            "mails":mails
         });
      }
   }
}

