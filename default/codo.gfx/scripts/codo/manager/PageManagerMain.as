package codo.manager
{
   import avmplus.getQualifiedClassName;
   import codo.base.BasePageLayer;
   import codo.base.PageManagerBase;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.CodoPageViewDB;
   import codo.constants.DataID;
   import codo.constants.UIEntry;
   import codo.constants.UITutorialFlags;
   import codo.constants.ViewState;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.objects.CodoViewObj;
   import codo.services.MatchService;
   import codo.services.TutorialService;
   import codo.views.UITutorialBaseView;
   import flash.display.Sprite;
   
   public class PageManagerMain extends PageManagerBase
   {
      
      private static var _instance:PageManagerMain;
      
      protected var _currentPage:CodoPageObj = null;
      
      protected var _mainPageHistoryAry:Array = [];
      
      public function PageManagerMain()
      {
         super();
         _pageLayers = [CodoPageViewDB.PAGE_LAYER_BG,CodoPageViewDB.PAGE_LAYER_MAIN,CodoPageViewDB.PAGE_LAYER_MENU,CodoPageViewDB.PAGE_LAYER_PERSISTENT,CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP,CodoPageViewDB.PAGE_LAYER_POPUP,CodoPageViewDB.PAGE_LAYER_UI_TUTORIAL,CodoPageViewDB.PAGE_LAYER_ADV_POPUP,CodoPageViewDB.PAGE_LAYER_SYS_MSG,CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP,CodoPageViewDB.PAGE_LAYER_LANG_BAR,CodoPageViewDB.PAGE_LAYER_TIP,CodoPageViewDB.PAGE_LAYER_WEBIMG,CodoPageViewDB.PAGE_LAYER_FLOATING_ELEMENT,CodoPageViewDB.PAGE_LAYER_LETTERBOX,CodoPageViewDB.PAGE_LAYER_GVOICE_SETTINGS,CodoPageViewDB.PAGE_LAYER_GVOICE_CHAT_PANEL];
      }
      
      public static function getInstance() : PageManagerMain
      {
         if(_instance == null)
         {
            _instance = new PageManagerMain();
         }
         return _instance;
      }
      
      override public function init(cContainer:Sprite) : void
      {
         super.init(cContainer);
         this.showPage(CodoPageViewDB.PAGE_LETTERBOX);
         this.showPage(CodoPageViewDB.PAGE_SYS_MSG_FSG,true,ViewState.BACKGROUND);
      }
      
      override public function startUI(cParams:Object) : void
      {
         if(Boolean(cParams.ready))
         {
            MatchService.getInstance();
         }
         super.startUI(cParams);
         this.showPage(CodoPageViewDB.PAGE_LANG_BAR);
         this.showPage(CodoPageViewDB.PAGE_FLOATING_ELEMENT);
         this.showPage(CodoPageViewDB.PAGE_GVOICE_CHAT_PANEL);
         switch(cParams.entry)
         {
            case UIEntry.UI_LOGIN:
               if(cParams.page != null)
               {
                  broadcast(BCEvent.GOTO_PAGE_BY_PAGEOBJ,{
                     "pageObj":cParams.page,
                     "params":null,
                     "callBeforeGoto":null,
                     "callAfterGoto":null
                  });
               }
               this.showPage(CodoPageViewDB.PAGE_TIP);
               break;
            case UIEntry.UI_HOME:
               this.showPage(CodoPageViewDB.PAGE_BG);
               this.showPage(CodoPageViewDB.PAGE_TIP);
               this.showPage(CodoPageViewDB.PAGE_WEB_IMG);
               broadcast(BCEvent.GOTO_FIRST_PAGE);
               break;
            case UIEntry.UI_LOGINQUEUE:
               this.showPage(CodoPageViewDB.PAGE_BG);
               this.showPage(CodoPageViewDB.PAGE_TIP);
               this.showPage(CodoPageViewDB.PAGE_LOGIN_QUEUE);
         }
      }
      
      public function popHistory() : CodoPageObj
      {
         var targetPageObj:CodoPageObj = null;
         var prevPageData:Object = null;
         if(this._mainPageHistoryAry.length >= 1)
         {
            this._mainPageHistoryAry.pop();
            if(this._mainPageHistoryAry.length > 0)
            {
               prevPageData = this._mainPageHistoryAry[this._mainPageHistoryAry.length - 1];
               targetPageObj = prevPageData.pageObj;
            }
         }
         this.debugHistory("popHistory");
         return targetPageObj;
      }
      
      public function getPrevPageOnClosingAdvPopup() : CodoPageObj
      {
         var targetPageObj:CodoPageObj = null;
         var activeLayer:CodoPageLayerObj = this.getHighestActivePageLayer();
         if(activeLayer.depth <= CodoPageViewDB.PAGE_LAYER_ADV_POPUP.depth)
         {
            if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
            {
               targetPageObj = CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj;
            }
         }
         return targetPageObj;
      }
      
      final override public function showPage(cPageObj:CodoPageObj, cMask:Boolean = true, cState:int = -1, routeData:* = null) : void
      {
         var viewObj:CodoViewObj = null;
         var targetIsPopup:Boolean = false;
         this._currentPage = cPageObj;
         var tryHideSysMsg:Boolean = true;
         if(cState == -1)
         {
            cState = int(ViewState.ACTIVATED);
         }
         if(cPageObj != cPageObj.owner.currentPageObj)
         {
            cleanPageLayer(cPageObj.owner);
         }
         cPageObj.owner.currentPageObj = cPageObj;
         if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_MAIN && (this._mainPageHistoryAry.length <= 0 || this._mainPageHistoryAry[this._mainPageHistoryAry.length - 1].pageObj != cPageObj) && cPageObj.historyAble == true)
         {
            this._mainPageHistoryAry.push({
               "pageObj":cPageObj,
               "mask":cMask,
               "status":cState
            });
            this.debugHistory("showPage");
         }
         if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_POPUP)
         {
            targetIsPopup = true;
            cleanPageLayer(CodoPageViewDB.PAGE_LAYER_ADV_POPUP);
         }
         else if(cPageObj.owner != CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP)
         {
            if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_ADV_POPUP)
            {
               targetIsPopup = true;
            }
            else if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_SYS_MSG)
            {
               targetIsPopup = true;
               tryHideSysMsg = false;
            }
            else if(cPageObj.owner == CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP)
            {
               targetIsPopup = true;
               tryHideSysMsg = false;
            }
         }
         if(targetIsPopup)
         {
            broadcast(BCEvent.POPUP_OPENED,true);
         }
         this.showMask(tryHideSysMsg);
         var tutorialFlag:uint = UITutorialFlags.NULL;
         if(cPageObj.tutorialView != null)
         {
            tutorialFlag = TutorialService.getInstance().initTutorialFlagByPageID(cPageObj.id);
         }
         var showingTutorial:Boolean = tutorialFlag != UITutorialFlags.NULL;
         for each(viewObj in cPageObj.views)
         {
            this.initView(viewObj,cState,cPageObj.owner,cPageObj.id,routeData,showingTutorial);
         }
         if(showingTutorial)
         {
            this.initTutorial(cPageObj,tutorialFlag);
         }
         else
         {
            this.cleanTutorial(cPageObj);
         }
      }
      
      public function initView(viewObj:CodoViewObj, cState:int, layerObj:CodoPageLayerObj, pageID:String, routeData:*, showingTutorial:Boolean) : void
      {
         var viewClass:Class = null;
         if(viewObj.instance == null)
         {
            viewClass = viewObj.src as Class;
            viewObj.instance = new viewClass();
            viewObj.instance.initState(cState);
            viewObj.instance.pageID = pageID;
            if(routeData != null)
            {
               viewObj.instance.routeData = routeData;
            }
            viewObj.instance.setShowingTutorial(showingTutorial);
            viewObj.instance.name = "instance_" + getQualifiedClassName(viewClass).replace(".","_").replace("::","__");
            layerObj.instance.addChild(viewObj.instance);
         }
         else
         {
            if(routeData != null)
            {
               viewObj.instance.routeData = routeData;
            }
            viewObj.instance.setShowingTutorial(showingTutorial);
            layerObj.instance.addChild(viewObj.instance);
            viewObj.instance.state = ViewState.ACTIVATED;
            viewObj.instance.pageID = pageID;
         }
      }
      
      public function initNextTutorialStep(pageID:String) : void
      {
         var pageObj:CodoPageObj = null;
         var tutorialFlag:uint = TutorialService.getInstance().initTutorialFlagByPageID(pageID);
         if(tutorialFlag != UITutorialFlags.NULL)
         {
            pageObj = CodoPageObj.getObjByID(pageID);
            this.cleanTutorial(pageObj);
            this.initTutorial(pageObj,tutorialFlag);
         }
      }
      
      override protected function onCleanPageViews(cPageLayerObj:CodoPageLayerObj) : void
      {
         this.cleanTutorial(cPageLayerObj.currentPageObj);
      }
      
      public function cleanTutorial(pageObj:CodoPageObj) : void
      {
         var layer:CodoPageLayerObj = null;
         var tutorial:CodoViewObj = pageObj.tutorialView;
         if(tutorial != null && tutorial.instance != null)
         {
            tutorial.instance.state = ViewState.DEACTIVATED;
            layer = this.getTutorialLayer(pageObj);
            layer.instance.removeChild(tutorial.instance);
            tutorial.instance = null;
         }
      }
      
      public function initTutorial(pageObj:CodoPageObj, tutorialFlag:uint) : void
      {
         var layer:CodoPageLayerObj = this.getTutorialLayer(pageObj);
         UITutorialBaseView.startMouseBlock(_container);
         this.initView(pageObj.tutorialView,ViewState.ACTIVATED,layer,pageObj.id,tutorialFlag,false);
      }
      
      protected function getTutorialLayer(pageObj:CodoPageObj) : CodoPageLayerObj
      {
         var layer:CodoPageLayerObj = CodoPageViewDB.PAGE_LAYER_UI_TUTORIAL;
         if(pageObj.owner.depth > layer.depth)
         {
            layer = pageObj.owner;
         }
         return layer;
      }
      
      public function getHighestActivePageLayer() : CodoPageLayerObj
      {
         var highestPageLayerObj:CodoPageLayerObj = null;
         if(CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP.currentPageObj != null)
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP;
         }
         else if(CodoPageViewDB.PAGE_LAYER_GVOICE_SETTINGS.currentPageObj != null)
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_GVOICE_SETTINGS;
         }
         else if(CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj != null)
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_SYS_MSG;
         }
         else if(CodoPageViewDB.PAGE_LAYER_ADV_POPUP.currentPageObj != null)
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_ADV_POPUP;
         }
         else if(CodoPageViewDB.PAGE_LAYER_POPUP.currentPageObj != null)
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_POPUP;
         }
         else if(CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP.currentPageObj != null)
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_BACKGROUND_POPUP;
         }
         else
         {
            highestPageLayerObj = CodoPageViewDB.PAGE_LAYER_MAIN;
         }
         return highestPageLayerObj;
      }
      
      public function showMask(cTryHideSysMsg:Boolean = true) : void
      {
         var highestPageLayerDepth:uint = 0;
         var highestPageLayerObj:CodoPageLayerObj = null;
         var pageLayerObjA:CodoPageLayerObj = null;
         var showBlackLayerOnHighestPageLayerObj:Boolean = false;
         var pageLayerObjB:CodoPageLayerObj = null;
         var pageLayerInstance:BasePageLayer = null;
         if(cTryHideSysMsg)
         {
            this.tryCloseAllSysMsg();
         }
         highestPageLayerObj = this.getHighestActivePageLayer();
         highestPageLayerDepth = highestPageLayerObj.depth;
         for each(pageLayerObjA in _pageLayers)
         {
            pageLayerInstance = pageLayerObjA.instance;
            if(highestPageLayerDepth <= pageLayerObjA.depth)
            {
               if(pageLayerInstance.inGeneralContainer == false)
               {
                  _subContainer_general.addChild(pageLayerInstance);
                  pageLayerInstance.depth = pageLayerObjA.depth;
                  pageLayerInstance.inGeneralContainer = true;
               }
            }
         }
         showBlackLayerOnHighestPageLayerObj = highestPageLayerObj != CodoPageViewDB.PAGE_LAYER_MAIN || CodoPageViewDB.PAGE_LAYER_SYS_MSG.currentPageObj != null;
         if(highestPageLayerObj.currentPageObj != null && highestPageLayerObj.currentPageObj.bypassDrawMask)
         {
            showBlackLayerOnHighestPageLayerObj = false;
         }
         for each(pageLayerObjB in _pageLayers)
         {
            if(!(showBlackLayerOnHighestPageLayerObj && pageLayerObjB == highestPageLayerObj))
            {
               pageLayerObjB.instance.hideATField();
            }
         }
         if(showBlackLayerOnHighestPageLayerObj)
         {
            highestPageLayerObj.instance.showATField();
            broadcast(BCCommonEvent.MASK_STATE_CHANGED,true);
         }
      }
      
      public function tryCloseAllSysMsg() : void
      {
         if(Boolean(getDP(DataID.CAN_SYS_MSG_FORCE_BE_CLOSED)))
         {
            cleanPageLayer(CodoPageViewDB.PAGE_LAYER_SYS_MSG);
         }
      }
      
      protected function debugHistory(header:String) : void
      {
      }
   }
}

