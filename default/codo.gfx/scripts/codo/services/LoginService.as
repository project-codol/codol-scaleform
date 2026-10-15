package codo.services
{
   import codo.base.ServiceBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.localization.Dict;
   import codo.localization.DictLobbyError;
   import codo.localization.DictRoom;
   import codo.tasks.CreateUserNameTask;
   
   public class LoginService extends ServiceBase
   {
      
      private static var _instance:LoginService;
      
      public function LoginService()
      {
         super(ServiceID.LOGIN);
      }
      
      public static function getInstance() : LoginService
      {
         if(LoginService._instance == null)
         {
            LoginService._instance = new LoginService();
         }
         return LoginService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.CREATE_CHARACTER,this.createCharacter);
         this.register(DataID.JUMP_GAME,this.jumpGame);
      }
      
      private function createCharacter(cParams:Object) : void
      {
         if(this.createTask(DataID.CREATE_CHARACTER,AsyncTaskGroup.CHARACTER,{
            "name":cParams.userName,
            "feedback":false
         }))
         {
            this.showMsg(Dict.CHARACTER_CREATE_IN_PROGRESS);
         }
      }
      
      private function jumpGame(cParams:Object) : void
      {
         cParams.feedback = false;
         if(this.createTask(DataID.JUMP_GAME,AsyncTaskGroup.IN_CHANNEL,cParams))
         {
            this.showMsg(DictRoom.NOTE_SEARCHING_SERVER);
         }
      }
      
      public function getLogonErrorMsg(type:int, id:int, errorCode:int) : String
      {
         var msg:String = null;
         switch(type)
         {
            case CreateUserNameTask.DW_NOTIFICATION_LOGON:
               msg = CreateUserNameTask.LogonNotification[id];
               break;
            case CreateUserNameTask.DW_NOTIFICATION_SETUSERNAME:
               msg = CreateUserNameTask.SetUsernameNotification[id];
               break;
            case CreateUserNameTask.DW_NOTIFICATION_CREATEACCOUNT:
               msg = CreateUserNameTask.CreateAccountNotification[id];
         }
         if(errorCode != -1)
         {
            if(CreateUserNameTask.LobbyErrorNotification.hasOwnProperty(errorCode.toString()))
            {
               msg = CreateUserNameTask.LobbyErrorNotification[errorCode];
            }
            else
            {
               msg = DictLobbyError.LOBBY_ERROR_DEFAULT;
            }
         }
         return msg;
      }
   }
}

