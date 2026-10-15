package codo.constants
{
   import codo.controllers.*;
   import flash.utils.Dictionary;
   
   public class ControllerName
   {
      
      private static var _controllerClasses:Dictionary;
      
      private static var _preControllerClasses:Dictionary;
      
      public static var StageKey:String = "StageKeyController";
      
      public static var PageNavigation:String = "PageNavigationController";
      
      public static var Tip:String = "TipController";
      
      public static var Contact:String = "ContactController";
      
      public static var Invitation:String = "InvitationController";
      
      public static var Career:String = "CareerController";
      
      public static var Mail:String = "MailController";
      
      public static var Message:String = "MessageController";
      
      public static var MainMenu:String = "MainMenuController";
      
      public static var Common:String = "CommonController";
      
      public static var Complaint:String = "ComplaintController";
      
      public static var RightClickMenu:String = "RightClickMenuController";
      
      public static var Chatting:String = "ChattingController";
      
      public static var SERVER_MSG:String = "ServerMsgController";
      
      public static var LanguageBar:String = "LanguageBarController";
      
      public static var CharacterCreation:String = "CharacterCreationController";
      
      public static var WeaponLoadOut:String = "WeaponLoadOutController";
      
      public static var CharacterLoadOut:String = "CharacterLoadOutController";
      
      public static var Leaderboard:String = "LeaderboardController";
      
      public static var PlayerBasicInfo:String = "PlayerBasicInfoController";
      
      public static var TournamentLeaderboard:String = "TournamentLeaderboardController";
      
      public static var Market:String = "MarketController";
      
      public static var Option:String = "OptionController";
      
      public static var Onboarding:String = "OnboardController";
      
      public static var Match:String = "MatchController";
      
      public static var Lobby:String = "LobbyController";
      
      public static var UIUnlock:String = "UIUnlockController";
      
      public static var Party:String = "PartyController";
      
      public static var Clan:String = "ClanController";
      
      public static var QTalk:String = "QTalkController";
      
      public static var Summary:String = "SummaryController";
      
      public static var Notification:String = "NotificationController";
      
      public static var Coupon:String = "CouponController";
      
      public static var UIViewer:String = "UIViewerController";
      
      public static var Sanitize:String = "SanitizeController";
      
      public static var SharedObject:String = "SharedObjectController";
      
      public static var PublisherStorage:String = "PublisherStorageController";
      
      public static var Questionnaire:String = "QuestionnaireController";
      
      public static var MainMenuAAR:String = "MainMenuAARController";
      
      public static var Video:String = "VideoController";
      
      public static var Challenge:String = "ChallengeController";
      
      public static var LobbySummary:String = "LobbySummaryController";
      
      public static var Login:String = "LoginController";
      
      public static var FSGAutoTest:String = "FSGAutoTestController";
      
      public static var Screenshot:String = "ScreenshotController";
      
      public static var OptionVideo:String = "OptionVideoController";
      
      public static var ANTIBOT_CONTROLLER:String = "AntiBotController";
      
      public static var Reward:String = "RewardController";
      
      public static var GAME_MOMENTS:String = "GameMomentsController";
      
      public static var WARGOD:String = "WarGodController";
      
      public static var Theme:String = "ThemeController";
      
      public static var BattleCityLeague:String = "BattleCityLeagueController";
      
      public static var Datamore:String = "DatamoreController";
      
      public static var AnimatedProduct:String = "AnimatedProductController";
      
      public static var GVoice:String = "GVoiceController";
      
      public function ControllerName()
      {
         super();
      }
      
      public static function get preControllerClasses() : Dictionary
      {
         if(_preControllerClasses == null)
         {
            _preControllerClasses = new Dictionary();
            _preControllerClasses[ControllerName.Common] = CommonController;
            _preControllerClasses[ControllerName.Notification] = NotificationController;
            _preControllerClasses[ControllerName.LanguageBar] = LanguageBarController;
            _preControllerClasses[ControllerName.PageNavigation] = PageNavigationController;
            _preControllerClasses[ControllerName.Option] = OptionController;
            _preControllerClasses[ControllerName.Onboarding] = OnboardController;
            _preControllerClasses[ControllerName.Login] = LoginController;
            _preControllerClasses[ControllerName.UIUnlock] = UIUnlockController;
            _preControllerClasses[ControllerName.CharacterCreation] = CharacterCreationController;
            _preControllerClasses[ControllerName.CharacterLoadOut] = CharacterLoadOutController;
            _preControllerClasses[ControllerName.UIViewer] = UIViewerController;
            _preControllerClasses[ControllerName.Video] = VideoController;
            _preControllerClasses[ControllerName.FSGAutoTest] = FSGAutoTestControllerFEM;
            _preControllerClasses[ControllerName.Screenshot] = ScreenshotController;
         }
         return _preControllerClasses;
      }
      
      public static function get controllerClasses() : Dictionary
      {
         if(_controllerClasses == null)
         {
            _controllerClasses = new Dictionary();
            _controllerClasses[ControllerName.SharedObject] = SharedObjectController;
            _controllerClasses[ControllerName.Common] = CommonController;
            _controllerClasses[ControllerName.Complaint] = ComplaintFrontendController;
            _controllerClasses[ControllerName.Sanitize] = SanitizeController;
            _controllerClasses[ControllerName.StageKey] = StageKeyController;
            _controllerClasses[ControllerName.Tip] = TipController;
            _controllerClasses[ControllerName.Contact] = ContactController;
            _controllerClasses[ControllerName.Invitation] = InvitationController;
            _controllerClasses[ControllerName.Career] = CareerController;
            _controllerClasses[ControllerName.Mail] = MailController;
            _controllerClasses[ControllerName.Message] = MessageController;
            _controllerClasses[ControllerName.MainMenu] = MainMenuController;
            _controllerClasses[ControllerName.Chatting] = ChattingController;
            _controllerClasses[ControllerName.SERVER_MSG] = ServerMsgController;
            _controllerClasses[ControllerName.LanguageBar] = LanguageBarController;
            _controllerClasses[ControllerName.CharacterCreation] = CharacterCreationController;
            _controllerClasses[ControllerName.WeaponLoadOut] = WeaponLoadOutController;
            _controllerClasses[ControllerName.CharacterLoadOut] = CharacterLoadOutController;
            _controllerClasses[ControllerName.UIViewer] = UIViewerController;
            _controllerClasses[ControllerName.Leaderboard] = LeaderboardController;
            _controllerClasses[ControllerName.PlayerBasicInfo] = PlayerBasicInfoController;
            _controllerClasses[ControllerName.TournamentLeaderboard] = TournamentLeaderboardController;
            _controllerClasses[ControllerName.Market] = MarketController;
            _controllerClasses[ControllerName.Option] = OptionController;
            _controllerClasses[ControllerName.Match] = MatchController;
            _controllerClasses[ControllerName.Lobby] = LobbyController;
            _controllerClasses[ControllerName.UIUnlock] = UIUnlockController;
            _controllerClasses[ControllerName.QTalk] = QTalkController;
            _controllerClasses[ControllerName.Party] = PartyController;
            _controllerClasses[ControllerName.Clan] = ClanController;
            _controllerClasses[ControllerName.Summary] = SummaryController;
            _controllerClasses[ControllerName.Coupon] = CouponController;
            _controllerClasses[ControllerName.RightClickMenu] = RightClickMenuController;
            _controllerClasses[ControllerName.PublisherStorage] = PublisherStorageController;
            _controllerClasses[ControllerName.Questionnaire] = QuestionnaireController;
            _controllerClasses[ControllerName.MainMenuAAR] = MainMenuAARController;
            _controllerClasses[ControllerName.Challenge] = ChallengeController;
            _controllerClasses[ControllerName.LobbySummary] = LobbySummaryController;
            _controllerClasses[ControllerName.OptionVideo] = OptionVideoController;
            _controllerClasses[ControllerName.ANTIBOT_CONTROLLER] = AntiBotController;
            _controllerClasses[ControllerName.Reward] = RewardController;
            _controllerClasses[ControllerName.GAME_MOMENTS] = GameMomentsController;
            _controllerClasses[ControllerName.WARGOD] = WarGodController;
            _controllerClasses[ControllerName.Theme] = ThemeController;
            _controllerClasses[ControllerName.BattleCityLeague] = BattleCityLeagueController;
            _controllerClasses[ControllerName.Datamore] = DatamoreController;
            _controllerClasses[ControllerName.AnimatedProduct] = AnimatedProductController;
            _controllerClasses[ControllerName.GVoice] = GVoiceController;
         }
         return _controllerClasses;
      }
   }
}

