package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.Button;
   import codo.component.ContentContainer;
   import codo.component.TabNavigation;
   import codo.component.TextField;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.DataInGameID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.services.InGameService;
   import codo.style.GlobalGuide;
   import codo.utils.PauseUtil;
   import codo.utils.ScaleformUtil;
   import components.fsg_pausemenu_part.FsgInGameOption;
   import components.fsg_pausemenu_part.FsgSocialInfo;
   import components.fsgpopups_part.FsgQuitGameWarningPopupViewContent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgPauseMenuBaseView extends BaseView
   {
      
      protected static const FRAME_WIDTH:Number = 1184;
      
      protected static const SMALL_FRAME_WIDTH:Number = 734;
      
      protected static const MAP_FRAME_WIDTH:Number = 780;
      
      protected static const FRAME_HEIGHT:Number = 566;
      
      private static const TITLE_HEIGHT:Number = 100;
      
      private static const NO_XP_GP_WARNING_MODE:Array = ["dmz","tdmz"];
      
      private static const TITLE_NO_TABS_OFFSET:int = 35;
      
      public var myFrame:ContentContainer;
      
      public var myTitle:TextField;
      
      public var myQtSettingMask:MovieClip;
      
      public var myTabNavigation:TabNavigation;
      
      public var myCyborgImg:MovieClip;
      
      public var myOptions:FsgInGameOption;
      
      public var mySocialInfo:FsgSocialInfo;
      
      public var myBackBtn:Button;
      
      public var myQuitBtn:Button;
      
      public var myComplainsBtn:MovieClip;
      
      public var myQTBtn:MovieClip;
      
      public var myRecordBtn:MovieClip;
      
      private var m_recordAnimated:BehaviourAnimatedClickable;
      
      private var m_recordClickable:BehaviourClickable;
      
      private var m_recordAudio:BehaviourAudio;
      
      private var m_complainsAnimated:BehaviourAnimatedClickable;
      
      private var m_complainsClickable:BehaviourClickable;
      
      private var m_complainsAudio:BehaviourAudio;
      
      private var m_qtAnimated:BehaviourAnimatedClickable;
      
      private var m_qtClickable:BehaviourClickable;
      
      private var m_qtAudio:BehaviourAudio;
      
      protected var mPopupOverlay:Sprite;
      
      public var background:Sprite;
      
      private var m_isInGameComplaintsLocked:Boolean;
      
      protected var _currentClassIndex:int = -1;
      
      protected var _classes:Array;
      
      protected var _useOverrideLoadout:Boolean;
      
      protected var _qtSettingShowing:Boolean = false;
      
      protected var m_cachedTitleY:int = 0;
      
      private var _recordBtnInited:Boolean = false;
      
      private var mIsComplaintWindowOpen:Boolean = false;
      
      public function FsgPauseMenuBaseView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         if(null != this.myFrame)
         {
            this.myFrame.width = FRAME_WIDTH;
            this.myFrame.height = FRAME_HEIGHT;
         }
         this.myQtSettingMask.visible = false;
         this.myTitle.width = FRAME_WIDTH;
         this.myTitle.height = TITLE_HEIGHT;
         this.myTitle.font = GlobalGuide.FONT_FACE_BOLD;
         this.myTitle.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         var charInfo:Object = getDP(DataInGameID.CHARACTER_INFO);
         this.myTitle.text = Boolean(charInfo) ? charInfo.name : "";
         this.myOptions.setTitle(DictInGame.Options);
         this.myOptions.showBrightness(getDP(DataInGameID.IS_FULL_SCREEN));
         this.myOptions.initOption();
         if(this.myCyborgImg != null)
         {
            this.myCyborgImg.myCyborgTitle_TF.text = Dict.FORCE_ZM;
         }
         if(this.mySocialInfo != null)
         {
            this.mySocialInfo.visible = false;
         }
         this.initLoadoutPanel();
         this.m_cachedTitleY = this.myTitle.y;
         this.myBackBtn.registerClickEvent(this.backToGame);
         this.myQuitBtn.registerClickEvent(this.confirmQuit);
      }
      
      private function setPopupOverlay() : void
      {
         var overlayClass:Class = getDefinitionByName("fsg.popups.fsgPopupOverlay") as Class;
         this.mPopupOverlay = addChild(new overlayClass()) as Sprite;
         this.mPopupOverlay.visible = false;
      }
      
      override protected function onInitListener() : void
      {
         this.setPopupOverlay();
         this.m_isInGameComplaintsLocked = false;
         if(ScaleformUtil.isScaleform)
         {
            this.m_isInGameComplaintsLocked = CFunctionCommonContainer.Dvar_GetBool("ui_lock_in_game_complaints") as Boolean;
         }
         if(this.m_isInGameComplaintsLocked)
         {
            this.myComplainsBtn.visible = false;
            if(this.m_complainsClickable != null)
            {
               this.m_complainsClickable.dispose();
            }
         }
         else
         {
            this.myComplainsBtn.myComplainsTextTF.text = Dict.REPORT_USER;
            this.m_complainsClickable = new BehaviourClickable(this.myComplainsBtn.myHitArea);
            this.m_complainsAnimated = new BehaviourAnimatedClickable(this.myComplainsBtn,this.m_complainsClickable,1,2,2,3);
            this.m_complainsAudio = new BehaviourAudio(this.m_complainsClickable);
            this.m_complainsClickable.addClickCallback(this.onComplainsButtonClicked);
         }
         this.myQTBtn.myQTTextTF.text = Dict.QT_OPT_PANEL;
         this.m_qtClickable = new BehaviourClickable(this.myQTBtn.myHitArea);
         this.m_qtAnimated = new BehaviourAnimatedClickable(this.myQTBtn,this.m_qtClickable,1,2,2);
         this.m_qtAudio = new BehaviourAudio(this.m_qtClickable);
         this.m_qtClickable.addClickCallback(this.onQtButtonClicked,"");
         var status:int = CFunctionCommonContainer.GetGameMomentsStatus();
         this.setRecordButtonStatus(status);
         listen(BCInGameEvent.CHARACTER_LOADOUT_RELOADED,this.onCharacterLoadoutLoaded);
         listen(BCEvent.QT_SETTING_STATE_CHANGED,this.onQtSettingStateChanged);
         listen(BCInGameEvent.SHOW_NOTIFICATION_POPUP,this.onPopupShowStateChangeHandle);
         listen(BCInGameEvent.HIDE_NOTIFICATION_POPUP,this.onPopupShowStateChangeHandle);
         listen(BCEvent.EVT_GAMEMOMENTS_STATUS_CHANGED,this.onGameMomentsStatusChanged);
      }
      
      protected function shouldShowNavigateTab() : Boolean
      {
         var _isZhuntGameMode:Boolean = getDP(DataInGameID.IS_ZHUNT);
         var _isOpenedByServerCommand:Boolean = getDP(DataInGameID.IS_PAUSEMENU_OPENED_BY_SERVER_COMMAND);
         var _isZMGameMode:Boolean = getDP(DataInGameID.IS_ZM);
         var _isHeroOps:Boolean = InGameService.getInstance().isHeroOps();
         var _isFiringrangetTrain:Boolean = InGameService.getInstance().curMapIsFiringrangetTrain();
         var _hideClassSelectionMenu:Boolean = getDP(DataInGameID.HIDE_CLASS_SELECTION_MENU);
         if(_hideClassSelectionMenu)
         {
            return false;
         }
         if(_isZhuntGameMode)
         {
            if(_isOpenedByServerCommand)
            {
               return true;
            }
            return false;
         }
         if(_isZMGameMode && this.isClassSelected())
         {
            return false;
         }
         if(_isHeroOps && this.isClassSelected() && !_isFiringrangetTrain)
         {
            return false;
         }
         return true;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mPopupOverlay.visible = false;
         this.mIsComplaintWindowOpen = false;
         this.myBackBtn.label = DictInGame.BackToGame;
         this.myQuitBtn.label = DictInGame.ExitToLobby;
         this.refreshLayout();
         var playerList:Array = getDP(DataID.GET_ACTIVE_PLAYER_LIST);
         if(this.m_isInGameComplaintsLocked == false)
         {
            this.m_complainsAnimated.setEnabled(Boolean(playerList) ? playerList.length > 0 : false);
            this.m_complainsClickable.setEnableMouseHighlight(Boolean(playerList) ? playerList.length > 0 : false);
            this.m_complainsAudio.setEnabled(Boolean(playerList) ? playerList.length > 0 : false);
         }
         if(this.myCyborgImg != null)
         {
            this.myCyborgImg.visible = getDP(DataInGameID.IS_ZM);
         }
         this.updateClassSelection();
         this.hideClassSelection(getDP(DataInGameID.HIDE_CLASS_SELECTION_MENU));
         this.myTabNavigation.visible = this.shouldShowNavigateTab();
         if(Boolean(CFunctionInGameContainer.IsSpectator()))
         {
            this.myTabNavigation.visible = false;
         }
         broadcast(BCInGameEvent.EVT_PAUSE_MENU_OPENED);
         bind(DataInGameID.IS_COMPLAINT_WINDOW_OPEN,this.onIsComplaintWindowOpenStateChanged);
      }
      
      override protected function hideView() : void
      {
         this.myOptions.stopSliderDragState();
         super.hideView();
      }
      
      protected function isClassSelected() : Boolean
      {
         return this._currentClassIndex != -1;
      }
      
      private function updateClassSelection() : void
      {
         if(!this.shouldShowNavigateTab())
         {
            this.myTabNavigation.visible = false;
            this.myTitle.y = this.m_cachedTitleY + TITLE_NO_TABS_OFFSET;
         }
         else
         {
            this.myTabNavigation.visible = true;
            this.myTitle.y = this.m_cachedTitleY;
         }
         if(Boolean(CFunctionInGameContainer.IsSpectator()))
         {
            this.myTabNavigation.visible = false;
            this.myTitle.y = this.m_cachedTitleY + TITLE_NO_TABS_OFFSET;
         }
      }
      
      protected function hideClassSelection(hide:Boolean) : void
      {
         if(this.myTabNavigation.visible == true)
         {
            this.myTabNavigation.visible = !hide;
         }
      }
      
      private function initLoadoutPanel() : void
      {
         var data:Object = null;
         this._classes = getDP(DataInGameID.CHARACTER_WEAPON_LOADOUTS);
         var overrideLoadoutIdx:int = getDP(DataInGameID.OVERRIDE_WEAPON_LOADOUT_IDX);
         this._useOverrideLoadout = overrideLoadoutIdx != -1;
         if(this._useOverrideLoadout)
         {
            this._currentClassIndex = overrideLoadoutIdx;
         }
         var tabs:Array = new Array();
         var len:int = int(this._classes.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.isLoadoutSlotUnlocked(i))
            {
               data = {
                  "id":i,
                  "label":this._classes[i].name
               };
               tabs.push(data);
            }
         }
         var tabData:Object = new Object();
         tabData.tabClickedCallback = this.onSelectLoadout;
         tabData.tabs = tabs;
         tabData.tabLinkage = ButtonFactory.SCROLL_LIST_TAB_BUTTON_LINKAGE;
         this.myTabNavigation.setData(tabData);
         if(Boolean(getDP(DataInGameID.IS_ZHUNT)))
         {
            this._currentClassIndex = CFunctionInGameContainer.AS_GetZhuntLoadoutIndex() - 1;
         }
         this.displayLoadoutDetail(this.isClassSelected() ? this._currentClassIndex : 0);
      }
      
      protected function isLoadoutSlotUnlocked(idx:int) : Boolean
      {
         return CFunctionCommonContainer.isLoadoutUsable(idx);
      }
      
      protected function refreshLayout() : void
      {
         if(Boolean(getDP(DataInGameID.HIDE_CLASS_SELECTION_MENU)))
         {
            gotoAndStop(5);
            this.myTitle.x = 254;
            this.myTabNavigation.x = 258;
            if(this.myFrame != null)
            {
               this.myFrame.x = 258;
               this.myFrame.width = MAP_FRAME_WIDTH;
            }
         }
         else if(PauseUtil.getPauseMapHidden())
         {
            gotoAndStop(2);
            this.myTitle.x = 324;
            this.myTabNavigation.x = 328;
            if(this.myFrame != null)
            {
               this.myFrame.x = 328;
               this.myFrame.width = SMALL_FRAME_WIDTH;
            }
         }
         else
         {
            gotoAndStop(1);
            this.myTitle.x = 68;
            this.myTabNavigation.x = 67;
            if(this.myFrame != null)
            {
               this.myFrame.x = 67;
               this.myFrame.width = FRAME_WIDTH;
            }
         }
         if(Boolean(getDP(DataInGameID.HIDE_OPTION_MENU)))
         {
            this.myQuitBtn.visible = false;
            this.myOptions.visible = false;
         }
         else
         {
            this.myQuitBtn.visible = true;
            this.myOptions.visible = true;
         }
      }
      
      private function onSelectLoadout(idx:int) : void
      {
         this._currentClassIndex = this.myTabNavigation.currentTabId;
         this.displayLoadoutDetail(this._currentClassIndex);
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         var loadoutId:int = 0;
         if(this.complaintViewIsOpenning())
         {
            return;
         }
         var switchLoadoutKeys:Array = [Keyboard.NUMBER_1,Keyboard.NUMBER_2,Keyboard.NUMBER_3,Keyboard.NUMBER_4,Keyboard.NUMBER_5];
         if(this._qtSettingShowing)
         {
            if(cEvt.keyCode == Keyboard.ESCAPE)
            {
               broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
            }
         }
         else if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            this.backToGame();
         }
         else if(cEvt.keyCode == Keyboard.B)
         {
            if(!getDP(DataInGameID.HAS_POPUP))
            {
               this.backToGame();
            }
         }
         else if(this.shouldShowNavigateTab())
         {
            loadoutId = switchLoadoutKeys.indexOf(cEvt.keyCode);
            if(loadoutId >= 0)
            {
               if(this.myTabNavigation.getTabById(loadoutId) != null)
               {
                  this.myTabNavigation.SetSelectedIndexById(loadoutId);
                  this.backToGame();
               }
            }
         }
      }
      
      protected function backToGame() : void
      {
         if(this.isClassSelected())
         {
            if(!this._useOverrideLoadout)
            {
               this._currentClassIndex = this.myTabNavigation.currentTabId;
            }
            broadcast(BCInGameEvent.SELECT_WEAPON_LOADOUT,this._currentClassIndex);
            broadcast(BCInGameEvent.BACK_TO_GAME);
         }
         else if(Boolean(getDP(DataInGameID.HIDE_CLASS_SELECTION_MENU)))
         {
            broadcast(BCInGameEvent.SELECT_WEAPON_LOADOUT,this.myTabNavigation.currentTabId);
            broadcast(BCInGameEvent.BACK_TO_GAME);
         }
         else
         {
            if(!this._useOverrideLoadout)
            {
               this._currentClassIndex = this.myTabNavigation.currentTabId;
            }
            if(this._currentClassIndex < 0)
            {
               this._currentClassIndex = 0;
            }
            this.displayLoadoutDetail(this._currentClassIndex);
            broadcast(BCInGameEvent.SELECT_WEAPON_LOADOUT,this._currentClassIndex);
            broadcast(BCInGameEvent.BACK_TO_GAME);
         }
      }
      
      private function confirmQuit() : void
      {
         var msg:String = null;
         var isspectator:Boolean = CFunctionInGameContainer.IsSpectator() as Boolean;
         var warningStyle:uint = FsgQuitGameWarningPopupViewContent.STYLE_RED_WARNING;
         if(isspectator)
         {
            msg = DictInGame.QUIT_GAME_CONFIRM;
         }
         else if(-1 != NO_XP_GP_WARNING_MODE.indexOf(getDP(DataInGameID.GAME_TYPE)) && Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            msg = DictInGame.QUIT_GAME_WITH_BONUS;
            warningStyle = FsgQuitGameWarningPopupViewContent.STYLE_BLUE_TIP;
         }
         else if(InGameService.getInstance().isHeroOps())
         {
            msg = DictInGame.QUIT_STORYMODE_WARNING_DESCRIPTION;
         }
         else
         {
            msg = DictInGame.QUIT_GAME_WARNING_DESCRIPTION;
         }
         broadcast(BCInGameEvent.EVT_OPEN_QUIT_GAME_WARNING_POPUP,{
            "msg":msg,
            "style":warningStyle
         });
         broadcast(BCInGameEvent.SHOW_NOTIFICATION_POPUP);
      }
      
      protected function displayLoadoutDetail(loadoutIdx:int) : void
      {
      }
      
      protected function onCharacterLoadoutLoaded(cEvt:ParaEvent) : void
      {
         this._classes = getDP(DataInGameID.CHARACTER_WEAPON_LOADOUTS);
         var overrideLoadoutIdx:int = getDP(DataInGameID.OVERRIDE_WEAPON_LOADOUT_IDX);
         this._useOverrideLoadout = overrideLoadoutIdx != -1;
         if(this._useOverrideLoadout)
         {
            this._currentClassIndex = overrideLoadoutIdx;
         }
         if(Boolean(getDP(DataInGameID.IS_ZHUNT)))
         {
            this._currentClassIndex = CFunctionInGameContainer.AS_GetZhuntLoadoutIndex() - 1;
         }
         this.displayLoadoutDetail(this.isClassSelected() ? this._currentClassIndex : 0);
         this.updateClassSelection();
      }
      
      private function onQtSettingStateChanged(cEvt:ParaEvent) : void
      {
         var isShow:Boolean = cEvt.myPara as Boolean;
         this.myQtSettingMask.visible = isShow;
         this._qtSettingShowing = isShow;
      }
      
      private function onComplainsButtonClicked() : void
      {
         broadcast(BCEvent.EVT_REPORT_ACTIVE_PLAYER);
      }
      
      private function onQtButtonClicked() : void
      {
         broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
      }
      
      private function onRecordClicked() : void
      {
         broadcast(BCEvent.EVT_GAMEMOMENTS_TOGGLE);
      }
      
      private function onGameMomentsStatusChanged(cEvt:ParaEvent) : void
      {
         var status:int = cEvt.myPara as int;
         this.setRecordButtonStatus(status);
      }
      
      private function setRecordButtonStatus(status:int) : void
      {
         if(!this._recordBtnInited)
         {
            this._recordBtnInited = true;
            this.m_recordClickable = new BehaviourClickable(this.myRecordBtn.myHitArea);
            this.m_recordAnimated = new BehaviourAnimatedClickable(this.myRecordBtn,this.m_recordClickable,1,2,2,3);
            this.m_recordAudio = new BehaviourAudio(this.m_recordClickable);
            this.m_recordClickable.addClickCallback(this.onRecordClicked);
         }
         if(status <= Common.GAMEMOMENTS_FAILED_STATUS)
         {
            this.myRecordBtn.enabled = false;
            this.myRecordBtn.myRecordTextTF.text = Dict.DISABLE_GAMEMOMENTS_VIDEO;
            if(this.m_recordClickable != null)
            {
               this.m_recordClickable.dispose();
            }
         }
         else
         {
            this.myRecordBtn.enabled = true;
            if(status == Common.GAMEMOMENTS_PREINIT_SUCCESSFUL)
            {
               this.myRecordBtn.myRecordTextTF.text = Dict.START_GAMEMOMENTS_VIDEO;
            }
            else if(status == Common.GAMEMOMENTS_RECORD_START)
            {
               this.myRecordBtn.myRecordTextTF.text = Dict.PAUSE_GAMEMOMENTS_VIDEO;
            }
            else if(status == Common.GAMEMOMENTS_RECORD_PAUSE)
            {
               this.myRecordBtn.myRecordTextTF.text = Dict.RESUME_GAMEMOMENTS_VIDEO;
            }
            else if(status == Common.GAMEMOMENTS_RECORD_STOP)
            {
               this.myRecordBtn.myRecordTextTF.text = Dict.START_GAMEMOMENTS_VIDEO;
            }
         }
      }
      
      protected function onPopupShowStateChangeHandle(cEvt:ParaEvent) : void
      {
         this.mPopupOverlay.visible = cEvt.type == BCInGameEvent.SHOW_NOTIFICATION_POPUP;
      }
      
      private function complaintViewIsOpenning() : Boolean
      {
         return this.mIsComplaintWindowOpen;
      }
      
      private function onIsComplaintWindowOpenStateChanged(res:Object) : void
      {
         if(res.data == null)
         {
            this.mIsComplaintWindowOpen = false;
            return;
         }
         this.mIsComplaintWindowOpen = res.data;
      }
   }
}

