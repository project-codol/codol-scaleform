package codo.manager
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.ControllerInGameName;
   import codo.constants.DataCommonID;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.controllers.AntiBotController;
   import codo.controllers.ChattingInGameController;
   import codo.controllers.EOGController;
   import codo.controllers.GameMomentsController;
   import codo.controllers.PauseMenuController;
   import codo.controllers.QTalkController;
   import codo.controllers.ServerMsgController;
   import codo.controllers.SummaryBaseController;
   import codo.interfaces.ICommManager;
   import codo.services.CommonService;
   import codo.services.InGameService;
   import codo.services.OnboardService;
   import codo.services.SettingsInGameService;
   import codo.utils.AsymPvpUtil;
   import codo.utils.ClashPvpUtil;
   import codo.utils.CursorUtil;
   import codo.utils.Logger;
   import com.society.comscore.DAXDispatcher;
   
   public class CommInGameManager implements ICommManager
   {
      
      private static var _instance:CommInGameManager;
      
      public function CommInGameManager()
      {
         super();
      }
      
      public static function getInstance() : CommInGameManager
      {
         if(_instance == null)
         {
            _instance = new CommInGameManager();
         }
         return _instance;
      }
      
      public function preInit() : void
      {
         ServiceManager.getInstance().addService(CommonService.getInstance());
         ServiceManager.getInstance().addService(SettingsInGameService.getInstance());
         ServiceManager.getInstance().addService(OnboardService.getInstance());
      }
      
      public function cppFirstLogin() : void
      {
      }
      
      public function cppInLoginQueue() : void
      {
      }
      
      public function cppActivate() : void
      {
         this.initCommon();
         ServiceManager.getInstance().addService(InGameService.getInstance());
         ServiceManager.getInstance().addService(OnboardService.getInstance());
         ControllerManager.getInstance().init(ControllerInGameName.controllerClasses);
         if(Boolean(this.serverMsgController))
         {
            this.serverMsgController.isInGame = true;
            this.antiBotController.isInGame = true;
         }
         if(Boolean(this.summaryController))
         {
            this.summaryController.isInGame = true;
         }
         ServiceManager.getInstance().postActivate();
         PageInGameManager.getInstance().startUI({
            "entry":"",
            "ready":true
         });
         this.ComScoreStartMatch();
      }
      
      private function initCommon() : void
      {
         CursorUtil.InitCursorUtil(CFunctionCommonContainer.SetCursorType);
         var resArr:Array = this.getDP(DataCommonID.CURRENT_RESOLUTION);
         Logger.print("CommManager:::initCommon resArr: " + resArr);
         if(resArr.length > 1)
         {
            GameInfo.gameWidth = int(resArr[0]);
            GameInfo.gameHeight = int(resArr[1]);
            GameInfo.updateStageDimensionsForAspectRatio();
         }
      }
      
      public function cppUpdate(deltaTime:Number) : void
      {
         AsyncTaskManager.getInstance().update(deltaTime);
         ServiceManager.getInstance().update(deltaTime);
         ControllerManager.getInstance().update(deltaTime);
      }
      
      public function cppInitLog(logType:int) : void
      {
         Logger.init(logType,Boolean(CFunctionCommonContainer.IsShipBuild()),CFunctionCommonContainer.PrintLog);
      }
      
      public function cppCloseAll() : void
      {
         this.cppCloseChatMenu();
         this.cppClosePauseMenu();
         this.cppCloseCoopSpecEOGMenu();
         this.cppCloseTrainEOGMenu();
         this.cppCloseRespawnMenu();
         this.cppCloseScoreboardMenu();
      }
      
      public function cppOpenChatMenu() : void
      {
         if(Boolean(this.chattingController))
         {
            this.chattingController.openChatMenu();
         }
      }
      
      public function cppCloseChatMenu() : void
      {
         if(Boolean(this.chattingController))
         {
            this.chattingController.closeChatMenu();
         }
      }
      
      public function cppOpenPauseMenu(loadoutOnly:int, changeClassType:int, openedByServerCommand:Boolean) : void
      {
         var gametype:String = null;
         if(Boolean(this.pauseController))
         {
            gametype = this.getDP(DataInGameID.GAME_TYPE);
            if(Boolean(CFunctionCommonContainer.GametypeUsesAsymRobots(gametype)))
            {
               AsymPvpUtil.instance.preOpenPauseMenu(changeClassType);
            }
            if(gametype == ClashPvpUtil.MODE_ID && !ClashPvpUtil.isClashHardcore())
            {
               ClashPvpUtil.Instantiate();
            }
            this.pauseController.isOpenedByServerCommand = openedByServerCommand;
            this.pauseController.openPauseMenu(loadoutOnly);
            PageInGameManager.getInstance().isPauseMenuOpen = true;
         }
      }
      
      public function cppClosePauseMenu() : void
      {
         if(Boolean(this.pauseController))
         {
            this.pauseController.closePauseMenu();
         }
      }
      
      public function cppOpenCoopSpecEOGMenu() : void
      {
         if(Boolean(this.eogController))
         {
            this.eogController.openCoopSpecEOG(true);
         }
      }
      
      public function cppCloseCoopSpecEOGMenu() : void
      {
         if(Boolean(this.eogController))
         {
            this.eogController.openCoopSpecEOG(false);
         }
      }
      
      public function cppOpenTrainEOGMenu() : void
      {
         if(Boolean(this.eogController))
         {
            this.eogController.openTrainEOG(true);
         }
      }
      
      public function cppCloseTrainEOGMenu() : void
      {
         if(Boolean(this.eogController))
         {
            this.eogController.openTrainEOG(false);
         }
      }
      
      public function cppOpenScoreboardMenu() : void
      {
         PageInGameManager.getInstance().showScoreboard(true);
      }
      
      public function cppCloseScoreboardMenu() : void
      {
         PageInGameManager.getInstance().showScoreboard(false);
      }
      
      public function cppOpenRespawnMenu() : void
      {
         PageInGameManager.getInstance().showRevivePrompt(true);
      }
      
      public function cppCloseRespawnMenu() : void
      {
         PageInGameManager.getInstance().showRevivePrompt(false);
      }
      
      public function cppOpenTop3PlayersMenu() : void
      {
         PageInGameManager.getInstance().showTop3Players(true);
      }
      
      public function cppCloseTop3PlayersMenu() : void
      {
         PageInGameManager.getInstance().showTop3Players(false);
      }
      
      public function cppShowInGameHelpMenu() : void
      {
         PageInGameManager.getInstance().showHelpMenu();
      }
      
      public function cppCloseInGameHelpMenu() : void
      {
         PageInGameManager.getInstance().closeHelpMenu();
      }
      
      public function cppShowTutorialOverlay(step:int, stepData:int) : void
      {
         PageInGameManager.getInstance().showTutorialOverlay(step,stepData);
      }
      
      public function cppCloseTutorialOverlay() : void
      {
         PageInGameManager.getInstance().closeTutorialOverlay();
      }
      
      public function isFocused() : Boolean
      {
         if(this.chattingController.isInChat())
         {
            return true;
         }
         if(PageInGameManager.getInstance().currentFocusedPage != null)
         {
            return true;
         }
         return false;
      }
      
      private function get serverMsgController() : ServerMsgController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.SERVER_MSG) as ServerMsgController;
      }
      
      private function get antiBotController() : AntiBotController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.ANTIBOT_CONTROLLER) as AntiBotController;
      }
      
      private function get pauseController() : PauseMenuController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.PAUSE) as PauseMenuController;
      }
      
      private function get summaryController() : SummaryBaseController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.SUMMARY) as SummaryBaseController;
      }
      
      private function get chattingController() : ChattingInGameController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.CHATTING) as ChattingInGameController;
      }
      
      private function get qtController() : QTalkController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.QT) as QTalkController;
      }
      
      private function get eogController() : EOGController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.EOG) as EOGController;
      }
      
      private function get gamemomentsController() : GameMomentsController
      {
         return ControllerManager.getInstance().getController(ControllerInGameName.GAME_MOMENTS) as GameMomentsController;
      }
      
      protected function getDP(cDataID:String, cParams:Array = null) : *
      {
         return DataManager.getInstance().getDP(cDataID,cParams);
      }
      
      private function ComScoreStartMatch() : void
      {
         var sampleRateDvar:int = CFunctionCommonContainer.Dvar_GetInt("dax_sample_rate");
         DAXDispatcher.daxInitialise(sampleRateDvar,false);
         Logger.print("DAX:::ComScoreMatchStartEvent");
         DAXDispatcher.queue("action_type","match_start");
         trace("get game type");
         var mpGameType:String = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
         trace("GameType: " + mpGameType);
         var gameDescriptorStrings:Array = DAXDispatcher.getGameVariantAndMode(mpGameType);
         DAXDispatcher.queue("game_variant",gameDescriptorStrings[0]);
         DAXDispatcher.queue("game_mode",gameDescriptorStrings[1]);
         DAXDispatcher.dispatch();
      }
   }
}

