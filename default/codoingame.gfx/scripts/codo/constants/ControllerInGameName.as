package codo.constants
{
   import codo.controllers.AnimatedProductController;
   import codo.controllers.AntiBotController;
   import codo.controllers.ChattingInGameController;
   import codo.controllers.ComplaintInGameController;
   import codo.controllers.ContactController;
   import codo.controllers.DMZLoadoutController;
   import codo.controllers.EOGController;
   import codo.controllers.FSGAutoTestController;
   import codo.controllers.GVoiceInGameController;
   import codo.controllers.GameMomentsController;
   import codo.controllers.HUDPopupController;
   import codo.controllers.LeaveInGameController;
   import codo.controllers.MarketInGameController;
   import codo.controllers.NotificationInGameController;
   import codo.controllers.PauseMenuController;
   import codo.controllers.QTalkController;
   import codo.controllers.QuickChatController;
   import codo.controllers.SanitizeController;
   import codo.controllers.ScreenshotController;
   import codo.controllers.ServerMsgController;
   import codo.controllers.SummaryBaseController;
   import codo.controllers.VoteInGameController;
   import flash.utils.Dictionary;
   
   public class ControllerInGameName
   {
      
      private static var _controllerClasses:Dictionary;
      
      private static var _preControllerClasses:Dictionary;
      
      public static var SANITIZE:String = "SanitizeController";
      
      public static var SERVER_MSG:String = "ServerMsgController";
      
      public static var CHATTING:String = "ChattingInGameController";
      
      public static var NOTIFICATION:String = "NotificationInGameController";
      
      public static var EOG:String = "EOGController";
      
      public static var QT:String = "QTalkController";
      
      public static var SCREEN_SHOT:String = "ScreenshotController";
      
      public static var COMPLAINT:String = "ComplaintController";
      
      public static var CONTACT:String = "ContactController";
      
      public static var MARKET_INGAME:String = "MarketInGameController";
      
      public static var ANTIBOT_CONTROLLER:String = "AntiBotController";
      
      public static var GAME_MOMENTS:String = "GameMomentsController";
      
      public static var VOTE:String = "VoteInGameController";
      
      public static var DMZ_LOADOUT:String = "DMZLoadoutController";
      
      public static var QUICK_CHAT:String = "QuickChatController";
      
      public static var ANIMATED_PRODUCT:String = "AnimatedProductController";
      
      public static var HUD_POPUP:String = "HUDPopupController";
      
      public static var LEAVE_INGAME:String = "LeaveInGameController";
      
      public static var GVOICE:String = "GVoiceInGameController";
      
      public static const PAUSE:String = "PauseMenuController";
      
      public static const SUMMARY:String = "SummaryBaseController";
      
      public static var FSG_AUTO_TEST:String = "FSGAutoTestController";
      
      public function ControllerInGameName()
      {
         super();
      }
      
      public static function get controllerClasses() : Dictionary
      {
         if(_controllerClasses == null)
         {
            _controllerClasses = new Dictionary();
            _controllerClasses[ControllerInGameName.SANITIZE] = SanitizeController;
            _controllerClasses[ControllerInGameName.SERVER_MSG] = ServerMsgController;
            _controllerClasses[ControllerInGameName.CHATTING] = ChattingInGameController;
            _controllerClasses[ControllerInGameName.NOTIFICATION] = NotificationInGameController;
            _controllerClasses[ControllerInGameName.EOG] = EOGController;
            _controllerClasses[ControllerInGameName.PAUSE] = PauseMenuController;
            _controllerClasses[ControllerInGameName.ANTIBOT_CONTROLLER] = AntiBotController;
            _controllerClasses[ControllerInGameName.FSG_AUTO_TEST] = FSGAutoTestController;
            _controllerClasses[ControllerInGameName.QT] = QTalkController;
            _controllerClasses[ControllerInGameName.CONTACT] = ContactController;
            _controllerClasses[ControllerInGameName.COMPLAINT] = ComplaintInGameController;
            _controllerClasses[ControllerInGameName.MARKET_INGAME] = MarketInGameController;
            _controllerClasses[ControllerInGameName.GAME_MOMENTS] = GameMomentsController;
            _controllerClasses[ControllerInGameName.VOTE] = VoteInGameController;
            _controllerClasses[ControllerInGameName.DMZ_LOADOUT] = DMZLoadoutController;
            _controllerClasses[ControllerInGameName.QUICK_CHAT] = QuickChatController;
            _controllerClasses[ControllerInGameName.ANIMATED_PRODUCT] = AnimatedProductController;
            _controllerClasses[ControllerInGameName.HUD_POPUP] = HUDPopupController;
            _controllerClasses[ControllerInGameName.LEAVE_INGAME] = LeaveInGameController;
            _controllerClasses[ControllerInGameName.GVOICE] = GVoiceInGameController;
         }
         return _controllerClasses;
      }
      
      public static function get preControllerClasses() : Dictionary
      {
         if(_preControllerClasses == null)
         {
            _preControllerClasses = new Dictionary();
            _preControllerClasses[ControllerInGameName.SUMMARY] = SummaryBaseController;
            _preControllerClasses[ControllerInGameName.SCREEN_SHOT] = ScreenshotController;
         }
         return _preControllerClasses;
      }
   }
}

