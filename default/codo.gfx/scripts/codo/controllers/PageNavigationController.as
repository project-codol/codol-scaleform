package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.MusicID;
   import codo.constants.PageID;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.manager.PageManagerMain;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.services.MatchService;
   import codo.utils.CommonUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import codo.utils.TLogUtil;
   import codo.views.UITutorialBaseView;
   import com.society.comscore.DAXDispatcher;
   import flash.utils.Dictionary;
   
   public class PageNavigationController extends BaseController
   {
      
      private var _currentMainPageObj:CodoPageObj = null;
      
      private var _queueDict:Dictionary = new Dictionary();
      
      private var _showWelcomePage:Boolean = true;
      
      public function PageNavigationController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         addDP(DataID.CURRENT_PAGE_ID_AT_HIGHEST_DEPTH,this.getCurrentPageIDAtHighestDepth);
         addDP(DataID.CURRENT_MAIN_PAGE_ID,this.getCurrentMainPageID);
         addDP(DataID.CURRENT_BACKGROUND_POPUP_PAGE_ID,this.getCurrentBackgroundPopupPageID);
         addDP(DataID.HAS_POPUP,this.hasPopup);
         listen(BCEvent.CLOSE_ALL_POPUP,this.onCloseAllPopupHandle);
         listen(BCEvent.GOTO_PAGE_BY_PAGEOBJ,this.onGotoPageByPageObjHandle);
         listen(BCEvent.GOTO_PREV_PAGE,this.onGotoPrevPageHandle);
         listen(BCEvent.GOTO_PREV_MAIN_PAGE,this.onGotoPrevMainPageHandle);
         listen(BCEvent.EVT_CLOSE_POPUP_PAGE,this.onClosePopupPageHandle);
         listen(BCEvent.EVT_ROUTE_TO_PAGE,this.onRouteToPageByPageID);
         listen(BCEvent.EVT_OPEN_CHAT_WINDOW,this.onInvokeChat);
         listen(BCEvent.EVT_OPEN_UI_TOUR_FROM_TOOLTIP,this.onOpenUITourHandle);
         listen(BCEvent.EVT_NAVIGATE_TO_CLAN_MARKETPLACE,this.onNavigateToClanMarketplace);
         listen(BCEvent.EVT_NAVIGATE_TO_WARGOD_MARKETPLACE,this.onNavigateToWarGodMarketplace);
      }
      
      private function playBGMMusic(cPageObj:CodoPageObj) : void
      {
         switch(cPageObj)
         {
            case CodoPageViewDB.PAGE_CHARACTER_SELECT:
            case CodoPageViewDB.PAGE_HOME:
            case CodoPageViewDB.PAGE_CAREER_BATTLE_EXPERIENCE:
            case CodoPageViewDB.PAGE_CAREER_CHALLENGES:
            case CodoPageViewDB.PAGE_MATCH_SELECT:
               SoundUtil.getInstance().playMusic(MusicID.FSG_BGM_HOME,"");
               break;
            case CodoPageViewDB.PAGE_SUPPLY_DROP:
               SoundUtil.getInstance().playMusic(MusicID.BGM_SUPPLY_DROP,"");
            case CodoPageViewDB.PAGE_MAIN_IN_ROOM:
               SoundUtil.getInstance().playMusic(MusicID.FSG_BGM_LOBBY,"");
               break;
            case CodoPageViewDB.PAGE_MARKET_ITEM_DETAILS:
            case CodoPageViewDB.PAGE_MAIN_LOGIN:
            case CodoPageViewDB.PAGE_QUIT:
               break;
            default:
               if(cPageObj != null && cPageObj.owner == CodoPageViewDB.PAGE_LAYER_MAIN)
               {
                  SoundUtil.getInstance().playMusic(MusicID.FSG_BGM_HOME,"");
               }
         }
      }
      
      public function cppIsInHomePage() : Boolean
      {
         return this._currentMainPageObj != null && this._currentMainPageObj.id == PageID.HOME;
      }
      
      private function gotoPageByPageObj(cPageObj:CodoPageObj, cParams:Object = null, cCallBeforeGoto:Function = null, cCallAfterGoto:Function = null) : void
      {
         var prevMainPageID:String = null;
         var pageName:String = null;
         Logger.print("PageNavigationController:::gotoPageByPageObj cPageObj: " + cPageObj.id);
         if(cPageObj == null)
         {
            cPageObj = CodoPageViewDB.PAGE_HOME;
         }
         broadcast(BCEvent.EVT_PAGE_START_CHANGE,{"pageObj":cPageObj});
         if(cCallBeforeGoto != null)
         {
            if(cParams == null)
            {
               cCallBeforeGoto();
            }
            else
            {
               cCallBeforeGoto(cParams);
            }
         }
         this.playBGMMusic(cPageObj);
         if(cPageObj.id == PageID.HOME || cPageObj.id == PageID.MARKET || cPageObj.id == PageID.MATCH_SELECT)
         {
            ScaleformUtil.setInFrontendLoadout(false);
         }
         else if(cPageObj.id == PageID.FSG_LOADOUT)
         {
            ScaleformUtil.setInFrontendLoadout(true);
         }
         switch(cPageObj)
         {
            case CodoPageViewDB.PAGE_MATCH_SELECT:
               this.setUIViewerMode(Common.UIVIEWER_MODE_DISABLE);
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_PERSISTENT);
               break;
            case CodoPageViewDB.PAGE_MAIN_IN_ROOM:
               PageManagerMain.getInstance().cleanPageLayer(CodoPageViewDB.PAGE_LAYER_PERSISTENT);
               PageManagerMain.getInstance().showPage(cPageObj);
               this.setUIViewerMode(Common.UIVIEWER_MODE_TEAM);
               break;
            case CodoPageViewDB.PAGE_POPUP_FSG_SUMMARY:
               if(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj == null)
               {
                  PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_POPUP_FSG_SUMMARY);
               }
               else
               {
                  Logger.print("PageNavigationController:::gotoPageByPageObj Quit game summary popup is already open, skipping.");
               }
               break;
            case CodoPageViewDB.PAGE_MAIN_LOGIN:
               PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_MAIN_LOGIN);
               this.setUIViewerMode(Common.UIVIEWER_MODE_NONE,Common.UIVIEWER_POS_CENTER,Common.UIVIEWER_GAME_MP);
               break;
            case CodoPageViewDB.PAGE_QUIT:
               CommonUtil.quit();
               break;
            case CodoPageViewDB.PAGE_HOME:
               PageManagerMain.getInstance().showPage(cPageObj);
               this.checkShowWelcome();
               PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_PERSISTENT);
               this.setUIViewerMode(Common.UIVIEWER_MODE_NONE,Common.UIVIEWER_POS_CENTER,Common.UIVIEWER_GAME_MP);
               break;
            case CodoPageViewDB.PAGE_ONBOARD_WELCOME_NEW_PLAYER:
            case CodoPageViewDB.PAGE_ONBOARD_PLAYER_TRAINING_INTRO:
            case CodoPageViewDB.PAGE_CHARACTER_SELECT:
            case CodoPageViewDB.PAGE_ONBOARD_EXPERIENCE_SELECT:
            case CodoPageViewDB.PAGE_ONBOARD_KEYBOARD_SELECT:
               PageManagerMain.getInstance().showPage(cPageObj);
               this.setUIViewerMode(Common.UIVIEWER_MODE_DISABLE,Common.UIVIEWER_POS_CENTER,Common.UIVIEWER_GAME_MP);
               break;
            case CodoPageViewDB.PAGE_MAIN_MARKET_COMPARE:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               break;
            case CodoPageViewDB.PAGE_MOTD_CHECKIN_REWARDS:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               this.setUIViewerMode(Common.UIVIEWER_MODE_DAILY_REWARD);
               break;
            case CodoPageViewDB.PAGE_CHARACTER_SELECT_DETAILS:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               this.setUIViewerMode(Common.UIVIEWER_MODE_ONBOARDING_CHAR);
               break;
            case CodoPageViewDB.PAGE_ADV_FSG_MATCH_RESULT:
               broadcast(BCEvent.EVT_MATCH_RESULTS_OPEN);
            case CodoPageViewDB.PAGE_CAREER_CHALLENGES:
            case CodoPageViewDB.PAGE_CAREER_BATTLE_EXPERIENCE:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               this.setUIViewerMode(Common.UIVIEWER_MODE_CAREER);
               break;
            case CodoPageViewDB.PAGE_MARKET_ITEM_DETAILS:
               if(cParams == null)
               {
                  cParams = {};
                  cParams.useExistingData = true;
               }
               else
               {
                  cParams.useExistingData = false;
               }
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               break;
            case CodoPageViewDB.PAGE_FSG_LOADOUT:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               PageManagerMain.getInstance().showPage(CodoPageViewDB.PAGE_PERSISTENT);
               this.setUIViewerMode(Common.UIVIEWER_MODE_NONE,Common.UIVIEWER_POS_CENTER);
               break;
            case CodoPageViewDB.PAGE_SUPPLY_DROP:
            case CodoPageViewDB.PAGE_SUPPLY_DROP_REWARD_SELECTION:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               this.setUIViewerMode(Common.UIVIEWER_MODE_SUPPLY_DEPOT);
               break;
            default:
               PageManagerMain.getInstance().showPage(cPageObj,true,-1,cParams);
               if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_MAIN)
               {
                  this.setUIViewerMode(Common.UIVIEWER_MODE_NONE,Common.UIVIEWER_POS_CENTER);
               }
         }
         if(cCallAfterGoto != null)
         {
            if(cParams == null)
            {
               cCallAfterGoto();
            }
            else
            {
               cCallAfterGoto(cParams);
            }
         }
         TLogUtil.TLog_currentPageID(cPageObj.id);
         broadcast(BCEvent.EVT_PAGE_CHANGED,{"pageObj":cPageObj});
         SoundUtil.getInstance().playSound("ui_general_trans_fall");
         if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_MAIN)
         {
            prevMainPageID = this._currentMainPageObj != null ? this._currentMainPageObj.id : "";
            this._currentMainPageObj = cPageObj;
            broadcast(BCEvent.EVT_MAIN_PAGE_CHANGED,{
               "id":this._currentMainPageObj.id,
               "prev_id":prevMainPageID
            });
         }
         if(this._currentMainPageObj != null)
         {
            broadcast(BCEvent.EVT_MAIN_PAGE_ID_CHANGED,{"id":this._currentMainPageObj.id});
         }
         try
         {
            DAXDispatcher.setScreenAtLevel(cPageObj.id);
            pageName = DAXDispatcher.getScreenString();
            DAXDispatcher.queueScreen(pageName);
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      protected function checkShowWelcome() : void
      {
         if(this._showWelcomePage == true && !CFunctionCommonContainer.IsWelcomePageShowed() && !UITutorialBaseView.isTutorialShowing() && !UiCppOnboarding.instance.GetJustPlayedMission())
         {
            this._showWelcomePage = false;
            this.broadcast(BCEvent.EVT_OPEN_MOTD_DASHBOARD,{
               "category":0,
               "index":0
            });
         }
      }
      
      private function onGotoPageByPageObjHandle(cEvt:ParaEvent) : void
      {
         var pageObj:CodoPageObj = cEvt.myPara.pageObj;
         if(pageObj.owner != null && pageObj.owner.queue == true)
         {
            if(this._queueDict[pageObj.owner] == null)
            {
               this._queueDict[pageObj.owner] = [];
            }
            this._queueDict[pageObj.owner].push(cEvt.myPara);
            if(this._queueDict[pageObj.owner].length != 1)
            {
               Logger.print("PageNavigationController::onGotoPageByPageObjHandle: queued " + pageObj.id);
               return;
            }
         }
         this.gotoPageByPageObj(pageObj,cEvt.myPara.params,cEvt.myPara.callBeforeGoto,cEvt.myPara.callAfterGoto);
      }
      
      private function onInvokeChat(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
         {
            this.closePageLayerPopup();
         }
      }
      
      private function onOpenUITourHandle(cEvt:ParaEvent) : void
      {
         var pageID:String = cEvt.myPara.tourPage;
         var pageObj:CodoPageObj = CodoPageObj.getObjByID(pageID);
         PageManagerMain.getInstance().initTutorial(pageObj,cEvt.myPara.tourFlag);
      }
      
      private function onNavigateToClanMarketplace(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
         {
            this.closePageLayerPopup();
         }
         this.gotoPageByPageObj(CodoPageViewDB.PAGE_MAIN_MARKET,{
            "categories":null,
            "tabIndex":MarketMenuData.TAB_CLAN
         });
      }
      
      private function onNavigateToWarGodMarketplace(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
         {
            this.closePageLayerPopup();
         }
         this.gotoPageByPageObj(CodoPageViewDB.PAGE_MAIN_MARKET,{
            "categories":null,
            "tabIndex":MarketMenuData.TAB_WARGOD
         });
      }
      
      private function onRouteToPageByPageID(cEvt:ParaEvent) : void
      {
         var pageID:String = cEvt.myPara.page as String;
         gotoPage(CodoPageObj.getObjByID(pageID),cEvt.myPara.routeData);
      }
      
      private function closePageLayerPopup() : void
      {
         var queuedPage:Object = null;
         var targetPageObj:CodoPageObj = null;
         var tempParams:Object = null;
         var tempCallBeforeGoto:Function = null;
         var tempCallAfterGoto:Function = null;
         var queue:Array = this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP];
         queue.shift();
         if(queue.length > 0)
         {
            queuedPage = queue[0];
            targetPageObj = queuedPage.pageObj;
            tempParams = queuedPage.params;
            tempCallBeforeGoto = queuedPage.callBeforeGoto;
            tempCallAfterGoto = queuedPage.callAfterGoto;
            PageManagerMain.getInstance().cleanPageLayer(CodoPageViewDB.PAGE_LAYER_POPUP);
            if(targetPageObj != null)
            {
               Logger.print("PageNavigationController:::closePageLayerPopup targetPageObj: " + targetPageObj.id);
               this.gotoPageByPageObj(targetPageObj,tempParams,tempCallBeforeGoto,tempCallAfterGoto);
            }
         }
         else
         {
            Logger.print("PageNavigationController:::closePageLayerPopup [Closing Popup]");
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_POPUP,true);
            this.playBGMMusic(this._currentMainPageObj);
         }
      }
      
      private function onCloseAllPopupHandle(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP,true);
         }
         else if(CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj != null)
         {
            PageManagerMain.getInstance().tryCloseAllSysMsg();
            PageManagerMain.getInstance().showMask(false);
         }
         else if(CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj != null)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_ADV_POPUP,true);
         }
         else if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null && this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP] != null && this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP].length > 0)
         {
            this.closePageLayerPopup();
         }
      }
      
      private function cleanLayer(layer:CodoPageLayerObj, showMask:Boolean = false) : void
      {
         PageManagerMain.getInstance().cleanPageLayer(layer);
         PageManagerMain.getInstance().showMask(showMask);
      }
      
      private function gotoPrevPageInStack() : void
      {
         var notInRoomPage:Boolean = !MatchService.getInstance().isInRoom || Boolean(CFunctionContainer.AS_IsWarGodRoom());
         var targetPageObj:CodoPageObj = PageManagerMain.getInstance().popHistory();
         if(targetPageObj == null)
         {
            targetPageObj = CodoPageViewDB.PAGE_HOME;
         }
         else if(targetPageObj == CodoPageViewDB.PAGE_MAIN_IN_ROOM && notInRoomPage)
         {
            targetPageObj = CodoPageViewDB.PAGE_MATCH_SELECT;
         }
         Logger.print("PageNavigationController:::onGotoPrevPageHandle targetPageObj: " + targetPageObj.id);
         this.gotoPageByPageObj(targetPageObj);
      }
      
      private function onGotoPrevPageHandle(cEvt:ParaEvent) : void
      {
         if(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP);
         }
         else if(CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj != null)
         {
            PageManagerMain.getInstance().tryCloseAllSysMsg();
            PageManagerMain.getInstance().showMask(false);
         }
         else if(CodoPageViewDB.PAGE_LAYER_GVOICE_SETTINGS.currentPageObj != null)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_GVOICE_SETTINGS,true);
         }
         else if(CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj != null)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_ADV_POPUP,true);
         }
         else if(CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj != null)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP);
         }
         else if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
         {
            CFunctionCommonContainer.Assert(this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP] != null && this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP].length > 0,new Error("Uninitialized pop-up queue."));
            this.closePageLayerPopup();
         }
         else
         {
            this.gotoPrevPageInStack();
         }
         DAXDispatcher.setScreenAtLevel(this.getCurrentPageIDAtHighestDepth());
         DAXDispatcher.queueScreen(DAXDispatcher.getScreenString());
      }
      
      private function onGotoPrevMainPageHandle(cEvt:ParaEvent) : void
      {
         this.gotoPrevPageInStack();
         DAXDispatcher.setScreenAtLevel(this.getCurrentPageIDAtHighestDepth());
         DAXDispatcher.queueScreen(DAXDispatcher.getScreenString());
      }
      
      private function onClosePopupPageHandle(cEvt:ParaEvent) : void
      {
         var targetPageObj:CodoPageObj = null;
         var targetPageID:String = cEvt.myPara.pageID;
         if(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null && CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj.id == targetPageID)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP,true);
         }
         else if(CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj != null && CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj.id == targetPageID)
         {
            this.cleanLayer(CodoPageViewDB.PAGE_LAYER_ADV_POPUP);
            targetPageObj = PageManagerMain.getInstance().getPrevPageOnClosingAdvPopup();
            if(targetPageObj != null)
            {
               Logger.print("PageNavigationController:::onClosePopupPageHandle targetPageObj: " + targetPageObj.id);
               this.gotoPageByPageObj(targetPageObj);
            }
         }
         else if(CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj != null && CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj.id == targetPageID)
         {
            PageManagerMain.getInstance().cleanPageLayer(CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP);
            PageManagerMain.getInstance().showMask(false);
         }
         else if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null && CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj.id == targetPageID && this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP] != null && this._queueDict[CodoPageViewDB.PAGE_LAYER_POPUP].length > 0)
         {
            this.closePageLayerPopup();
         }
      }
      
      private function getCurrentPageIDAtHighestDepth() : String
      {
         if(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null)
         {
            return CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj.id;
         }
         if(CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj != null)
         {
            return CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj.id;
         }
         if(CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj != null)
         {
            return CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj.id;
         }
         if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
         {
            return CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj.id;
         }
         if(CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj != null)
         {
            return CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj.id;
         }
         return this.getCurrentMainPageID();
      }
      
      private function getCurrentMainPageID() : String
      {
         return this._currentMainPageObj != null ? this._currentMainPageObj.id : "";
      }
      
      private function getCurrentBackgroundPopupPageID() : String
      {
         return CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj != null ? CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj.id : "";
      }
      
      private function hasPopup() : Boolean
      {
         return CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null || CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj != null || CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null || CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj != null;
      }
      
      private function setUIViewerMode(cMode:uint, cStatus:uint = 0, cGameType:int = -1) : void
      {
         if(cGameType == -1)
         {
            cGameType = Boolean(getDP(DataID.IS_CYBORG)) ? int(Common.UIVIEWER_GAME_ZM) : int(Common.UIVIEWER_GAME_MP);
         }
         broadcast(BCEvent.EVT_SET_UIVIEWER_MODE,{
            "mode":cMode,
            "status":cStatus,
            "gametype":cGameType
         });
      }
   }
}

