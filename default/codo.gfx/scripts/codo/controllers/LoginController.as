package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.localization.DictSystem;
   import codo.objects.SystemMsgObj;
   import codo.services.LoginService;
   import codo.utils.LocalizeUtil;
   
   public class LoginController extends BaseController
   {
      
      public function LoginController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.PLAYER_USER_NAME,this.getPlayerUserName);
      }
      
      public function cppShowLogonErrorMsg(type:int, id:int, errorCode:int) : void
      {
         if(errorCode == 0)
         {
            return;
         }
         var msg:String = LocalizeUtil.localize(LoginService.getInstance().getLogonErrorMsg(type,id,errorCode)) + "[" + errorCode + "]";
         var msgPriority:uint = uint(SystemMsgPriority.ERROR);
         switch(errorCode)
         {
            case 730:
            case 704:
               msgPriority = uint(SystemMsgPriority.FATAL);
         }
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(msg,MsgBtnCount.ONE,msgPriority));
      }
      
      public function cppShowIIPSNotification() : void
      {
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,SystemMsgObj.getObj(DictSystem.IIPS_MSG,MsgBtnCount.ONE,SystemMsgPriority.ERROR,this.onConfirm,DictSystem.CONFIRM));
      }
      
      private function onConfirm() : void
      {
         this.onIIPSResponse(true);
      }
      
      private function onIIPSResponse(restart:Boolean) : void
      {
         this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{
            "delayTime":0,
            "callback":null,
            "triggerType":SystemMsgObj.TRIGGER_TYPE_CPP,
            "priority":SystemMsgPriority.ERROR
         });
      }
      
      private function getPlayerUserName() : String
      {
         return CFunctionCommonContainer.GetPlayerName().name;
      }
   }
}

