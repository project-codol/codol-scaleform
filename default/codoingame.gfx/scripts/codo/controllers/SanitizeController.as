package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCCommonEvent;
   import codo.constants.DataCommonID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SanitizedType;
   import codo.event.ParaEvent;
   import codo.localization.DictRoom;
   import codo.objects.ResultObj;
   import codo.services.CommonService;
   
   public class SanitizeController extends BaseController
   {
      
      private var _stringsToSanitize:Array = [];
      
      public function SanitizeController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCCommonEvent.EVT_SANITIZE_STRING,this.onSanitizeHandle);
      }
      
      private function onSanitizeHandle(cEvt:ParaEvent) : void
      {
         if(this.isSanitizing())
         {
            this._stringsToSanitize.push(cEvt.myPara);
         }
         else
         {
            this.sanitize(cEvt.myPara);
         }
      }
      
      private function onSanitizeComplete(cRes:Object) : void
      {
         if(cRes.result == ResultObj.RESULT_SUCCESS)
         {
            this.broadcast(BCCommonEvent.EVT_ON_STRING_SANITIZED,cRes.data);
         }
         else
         {
            this.showMsg(DictRoom.NOTE_SANITIZE_FAILED,MsgBtnCount.ONE);
         }
         if(this._stringsToSanitize.length > 0)
         {
            this.sanitize(this._stringsToSanitize.shift());
         }
      }
      
      private function isSanitizing() : Boolean
      {
         return CommonService.getInstance().isSanitizing();
      }
      
      private function sanitize(sanitizeObj:Object) : void
      {
         if(sanitizeObj == null || sanitizeObj.type == SanitizedType.NONE)
         {
            return;
         }
         switch(sanitizeObj.type)
         {
            case SanitizedType.ROOM_NAME:
               if(sanitizeObj.content.length == 0)
               {
                  this.showMsg(DictRoom.NOTE_EMPTY_ROOM_NAME,MsgBtnCount.ONE);
                  return;
               }
         }
         this.request(DataCommonID.TENCENT_SANITIZE_STRING,sanitizeObj,this.onSanitizeComplete);
      }
   }
}

