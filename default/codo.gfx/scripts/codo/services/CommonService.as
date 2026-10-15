package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataCommonID;
   import codo.constants.SanitizedType;
   import codo.constants.ServiceID;
   import codo.localization.DictRoom;
   
   public class CommonService extends ServiceBase
   {
      
      private static var _instance:CommonService;
      
      public function CommonService()
      {
         super(ServiceID.COMMON);
      }
      
      public static function getInstance() : CommonService
      {
         if(CommonService._instance == null)
         {
            CommonService._instance = new CommonService();
         }
         return CommonService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataCommonID.TENCENT_SANITIZE_STRING,this.tencentSanitizeString);
      }
      
      public function tencentSanitizeString(sanitizeObj:Object) : void
      {
         var isAuto:Boolean = sanitizeObj.type == SanitizedType.CHATTING_MSG || sanitizeObj.type == SanitizedType.MAIL_TITLE || sanitizeObj.type == SanitizedType.MAIL_MSG || sanitizeObj.type == SanitizedType.VOTE || sanitizeObj.type == SanitizedType.CLAN_TAG || sanitizeObj.type == SanitizedType.CLAN_DESCRIPTION || sanitizeObj.type == SanitizedType.CLAN_ANNOUNCEMENT;
         var taskParams:Object = {
            "auto":isAuto,
            "sanitizeObj":sanitizeObj
         };
         if(this.createTask(DataCommonID.TENCENT_SANITIZE_STRING,AsyncTaskGroup.HARMONY,taskParams,sanitizeObj))
         {
            if(!isAuto)
            {
               this.showMsg(DictRoom.NOTE_STRING_TO_SANITIZE);
            }
         }
      }
      
      public function isDevBuild() : Boolean
      {
         return CFunctionCommonContainer.IsDevelopmentBuild() == true;
      }
      
      public function isShipBuild() : Boolean
      {
         return CFunctionCommonContainer.IsShipBuild() == true;
      }
      
      public function isSanitizing() : Boolean
      {
         return this.isTaskInProgress(DataCommonID.TENCENT_SANITIZE_STRING);
      }
   }
}

