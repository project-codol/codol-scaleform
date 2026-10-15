package codo.manager
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoVersion;
   import codo.constants.ControllerName;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.constants.SystemMsgPriority;
   import codo.constants.UIEntry;
   import codo.cpp.UiCppMainMenu;
   import codo.cpp.UiCppOnboarding;
   import codo.interfaces.ICommManager;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.objects.SystemMsgObj;
   import codo.services.ChallengeService;
   import codo.services.CharacterLoadoutService;
   import codo.services.ClanService;
   import codo.services.CommonService;
   import codo.services.CommunicationService;
   import codo.services.CommunityService;
   import codo.services.LeaderboardService;
   import codo.services.LoginService;
   import codo.services.MarketService;
   import codo.services.OnboardService;
   import codo.services.PartyService;
   import codo.services.PublisherStorageService;
   import codo.services.RewardService;
   import codo.services.SettingsService;
   import codo.services.TutorialService;
   import codo.services.UIStencilService;
   import codo.services.WeaponLoadoutService;
   import codo.utils.CommonUtil;
   import codo.utils.CursorUtil;
   import codo.utils.Logger;
   import codo.utils.PrivilegeUtil;
   import codo.utils.TLogUtil;
   
   public class CommManager implements ICommManager
   {
      
      private static var _instance:CommManager;
      
      private var m_servicesInitialised:Boolean = false;
      
      private var m_lsgInterrupted:Boolean = false;
      
      private var m_lsgReconnectedMsg:SystemMsgObj = null;
      
      public function CommManager()
      {
         super();
      }
      
      public static function getInstance() : CommManager
      {
         if(_instance == null)
         {
            _instance = new CommManager();
         }
         return _instance;
      }
      
      public function preInit() : void
      {
         ServiceManager.getInstance().addService(CharacterLoadoutService.getInstance());
         ServiceManager.getInstance().addService(LoginService.getInstance());
         ServiceManager.getInstance().addService(SettingsService.getInstance());
      }
      
      public function initUIServices() : void
      {
         if(this.m_servicesInitialised == true)
         {
            return;
         }
         ServiceManager.getInstance().addService(CommonService.getInstance());
         ServiceManager.getInstance().addService(CommunityService.getInstance());
         ServiceManager.getInstance().addService(SettingsService.getInstance());
         ServiceManager.getInstance().addService(CommunicationService.getInstance());
         ServiceManager.getInstance().addService(PartyService.getInstance());
         ServiceManager.getInstance().addService(ClanService.getInstance());
         ServiceManager.getInstance().addService(LeaderboardService.getInstance());
         ServiceManager.getInstance().addService(WeaponLoadoutService.getInstance());
         ServiceManager.getInstance().addService(MarketService.getInstance());
         ServiceManager.getInstance().addService(ChallengeService.getInstance());
         ServiceManager.getInstance().addService(OnboardService.getInstance());
         ServiceManager.getInstance().addService(UIStencilService.getInstance());
         ServiceManager.getInstance().addService(PublisherStorageService.getInstance());
         ServiceManager.getInstance().addService(TutorialService.getInstance());
         ServiceManager.getInstance().addService(RewardService.getInstance());
         ControllerManager.getInstance().init(ControllerName.controllerClasses);
         ServiceManager.getInstance().postActivate();
         this.m_servicesInitialised = true;
      }
      
      public function cppFirstLogin() : void
      {
         Logger.print("CommManager:::cppFirstLogin");
         this.initCommon();
         PageManagerMain.getInstance().startUI({
            "entry":UIEntry.UI_LOGIN,
            "ready":false,
            "page":null
         });
         UiCppOnboarding.instance.StartUI();
      }
      
      public function cppInLoginQueue() : void
      {
         Logger.print("CommManager:::cppInLoginQueue");
         this.initCommon();
         PageManagerMain.getInstance().startUI({
            "entry":UIEntry.UI_LOGINQUEUE,
            "ready":false
         });
      }
      
      public function cppActivate() : void
      {
         Logger.print("CommManager:::cppActivate");
         this.initCommon();
         this.broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":PageID.LOGIN_QUEUE});
         this.initUIServices();
         PageManagerMain.getInstance().initAllPageLayerSize();
         UiCppOnboarding.instance.StartUI();
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
      
      public function cppNewPublisherFileAvailable(eFileType:uint) : void
      {
         Logger.print("cppNewPublisherFileAvailable " + eFileType);
         this.broadcast(BCEvent.EVT_PUBLISHERSTORAGE_UPDATEAVAILABLE,{"fileType":eFileType});
      }
      
      public function cppCloseAll() : void
      {
      }
      
      public function cppWebCloseCurrentPage() : void
      {
         this.broadcast(BCEvent.EVT_TRY_CLOSE_WEBIMG);
      }
      
      public function cppOnDWDisconnected() : void
      {
         this.m_lsgInterrupted = true;
         this.broadcast(BCEvent.EVT_DW_CONNECTION_CHANGED,{"isDWNowConnected":false});
         AsyncTaskManager.getInstance().onDWDisconnected();
         if(this.m_lsgReconnectedMsg != null)
         {
            this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{"systemMsg":this.m_lsgReconnectedMsg});
         }
         var reconnectingMsg:SystemMsgObj = SystemMsgObj.getObj(Dict.LSG_RECONNECTING,MsgBtnCount.ONE,SystemMsgPriority.ERROR,CommonUtil.quit,DictSystem.QUIT);
         reconnectingMsg.alwaysShowSpinner = true;
         this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,reconnectingMsg);
      }
      
      public function cppOnDWConnected() : void
      {
         if(this.m_lsgInterrupted)
         {
            this.broadcast(BCEvent.EVT_HIDE_SYSTEM_MSG,{"priority":SystemMsgPriority.ERROR});
            this.m_lsgReconnectedMsg = SystemMsgObj.getObj(Dict.LSG_RECONNECTED,MsgBtnCount.ONE,SystemMsgPriority.WARNING);
            this.broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,this.m_lsgReconnectedMsg);
            this.broadcast(BCEvent.EVT_DW_CONNECTION_CHANGED,{"isDWNowConnected":true});
         }
      }
      
      private function initCommon() : void
      {
         UiCppMainMenu.Init();
         CFunctionCommonContainer.setdvar("ui_hide_pausemenu_class","0");
         CursorUtil.InitCursorUtil(CFunctionCommonContainer.SetCursorType);
         var resArr1:Array = CFunctionCommonContainer.Dvar_GetString("r_mode").split("x");
         Logger.print("CommManager:::initCommon resArr1: " + resArr1);
         var resArr:Array = this.getDP(DataCommonID.CURRENT_RESOLUTION);
         Logger.print("CommManager:::initCommon resArr: " + resArr);
         if(resArr.length > 1)
         {
            GameInfo.gameWidth = int(resArr[0]);
            GameInfo.gameHeight = int(resArr[1]);
            GameInfo.updateStageDimensionsForAspectRatio();
         }
         CodoVersion.currentVersion = CFunctionCommonContainer.Dvar_GetString("build_version");
         Logger.print("CommManager:::initCommon version: " + CodoVersion.currentVersion);
         CodoVersion.currentVersionColumn = CFunctionCommonContainer.Dvar_GetInt("build_version_column");
         Logger.print("CommManager:::initCommon version_column: " + CodoVersion.currentVersionColumn);
         if(TLogUtil.TLog == null)
         {
            TLogUtil.TLog = CFunctionContainer.UILog;
         }
         PrivilegeUtil.enableBlueDiamondDeluxe = !CFunctionCommonContainer.Dvar_GetBool("ui_lock_blue_diamond_deluxe");
      }
      
      protected function getDP(cDataID:String, cParams:Array = null) : *
      {
         return DataManager.getInstance().getDP(cDataID,cParams);
      }
      
      protected function broadcast(cType:String, cData:* = null) : void
      {
         EventManager.getInstance().broadcast(cType,cData);
      }
      
      protected function setBindData(cDataID:*, cValue:Object) : void
      {
         DataManager.getInstance().setBindData(cDataID,cValue);
      }
   }
}

