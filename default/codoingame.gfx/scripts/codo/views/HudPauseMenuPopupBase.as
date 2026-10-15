package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.Button;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.DataInGameID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.HUDPopupComponent;
   import components.fsg_pausemenu_part.FsgInGameOption;
   import components.fsgpopups_part.FsgQuitGameWarningPopupViewContent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class HudPauseMenuPopupBase extends HUDPopupComponent
   {
      
      public var myBackBtn:Button;
      
      public var myQuitBtn:Button;
      
      public var myComplainsBtn:MovieClip;
      
      public var myQTBtn:MovieClip;
      
      public var myRecordBtn:MovieClip;
      
      public var myOptions:FsgInGameOption;
      
      public var myQtSettingMask:MovieClip;
      
      private var mPopupOverlay:Sprite;
      
      private var m_complainsAnimated:BehaviourAnimatedClickable;
      
      private var m_complainsClickable:BehaviourClickable;
      
      private var m_complainsAudio:BehaviourAudio;
      
      private var m_isInGameComplaintsLocked:Boolean;
      
      private var mIsComplaintWindowOpen:Boolean = false;
      
      private var m_qtAnimated:BehaviourAnimatedClickable;
      
      private var m_qtClickable:BehaviourClickable;
      
      private var m_qtAudio:BehaviourAudio;
      
      private var m_qtSettingShowing:Boolean = false;
      
      private var m_recordAnimated:BehaviourAnimatedClickable;
      
      private var m_recordClickable:BehaviourClickable;
      
      private var m_recordAudio:BehaviourAudio;
      
      public function HudPauseMenuPopupBase()
      {
         super();
         this.myBackBtn.label = DictInGame.BackToGame;
         this.myQuitBtn.label = DictInGame.ExitToLobby;
         this.myBackBtn.registerClickEvent(this.backToGame);
         this.myQuitBtn.registerClickEvent(this.confirmQuit);
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         if(this.myComplainsBtn != null)
         {
            this.m_isInGameComplaintsLocked = ScaleformUtil.isScaleform ? CFunctionCommonContainer.Dvar_GetBool("ui_lock_in_game_complaints") as Boolean : false;
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
               this.myComplainsBtn.visible = true;
               this.myComplainsBtn.myComplainsTextTF.text = Dict.REPORT_USER;
               this.m_complainsClickable = new BehaviourClickable(this.myComplainsBtn.myHitArea);
               this.m_complainsAnimated = new BehaviourAnimatedClickable(this.myComplainsBtn,this.m_complainsClickable,1,2,2,3);
               this.m_complainsAudio = new BehaviourAudio(this.m_complainsClickable);
               this.m_complainsClickable.addClickCallback(this.onComplainsButtonClicked);
            }
         }
         if(this.myQTBtn != null)
         {
            this.myQTBtn.myQTTextTF.text = Dict.QT_OPT_PANEL;
            this.m_qtClickable = new BehaviourClickable(this.myQTBtn.myHitArea);
            this.m_qtAnimated = new BehaviourAnimatedClickable(this.myQTBtn,this.m_qtClickable,1,2,2);
            this.m_qtAudio = new BehaviourAudio(this.m_qtClickable);
            this.m_qtClickable.addClickCallback(this.onQtButtonClicked,"");
         }
         if(this.myQtSettingMask != null)
         {
            this.myQtSettingMask.visible = false;
         }
         if(this.myRecordBtn != null)
         {
            this.m_recordClickable = new BehaviourClickable(this.myRecordBtn.myHitArea);
            this.m_recordAnimated = new BehaviourAnimatedClickable(this.myRecordBtn,this.m_recordClickable,1,2,2,3);
            this.m_recordAudio = new BehaviourAudio(this.m_recordClickable);
            this.m_recordClickable.addClickCallback(this.onRecordClicked);
         }
         if(this.myOptions != null)
         {
            this.myOptions.setTitle(DictInGame.Options);
            this.myOptions.showBrightness(getDP(DataInGameID.IS_FULL_SCREEN));
            this.myOptions.initOption();
         }
      }
      
      protected function backToGame() : void
      {
         broadcast(BCInGameEvent.BACK_TO_GAME);
      }
      
      protected function confirmQuit() : void
      {
         var msg:String = null;
         if(Boolean(CFunctionInGameContainer.IsSpectator()))
         {
            msg = DictInGame.QUIT_GAME_CONFIRM;
         }
         else
         {
            msg = DictInGame.QUIT_GAME_WARNING_DESCRIPTION;
         }
         broadcast(BCInGameEvent.EVT_OPEN_QUIT_GAME_WARNING_POPUP,{
            "msg":msg,
            "style":FsgQuitGameWarningPopupViewContent.STYLE_RED_WARNING
         });
         broadcast(BCInGameEvent.SHOW_NOTIFICATION_POPUP);
      }
      
      override protected function showView() : void
      {
         var playerList:Array = null;
         var complainEnabled:Boolean = false;
         super.showView();
         this.mPopupOverlay.visible = false;
         if(this.myComplainsBtn != null)
         {
            playerList = getDP(DataID.GET_ACTIVE_PLAYER_LIST);
            complainEnabled = !this.m_isInGameComplaintsLocked && Boolean(playerList) && playerList.length > 0;
            this.m_complainsAnimated.setEnabled(complainEnabled);
            this.m_complainsClickable.setEnableMouseHighlight(complainEnabled);
            this.m_complainsAudio.setEnabled(complainEnabled);
         }
         bind(DataInGameID.IS_COMPLAINT_WINDOW_OPEN,this.onIsComplaintWindowOpenStateChanged);
      }
      
      override protected function hideView() : void
      {
         unbind(DataInGameID.IS_COMPLAINT_WINDOW_OPEN,this.onIsComplaintWindowOpenStateChanged);
         this.myOptions.stopSliderDragState();
         super.hideView();
      }
      
      override protected function onInitListener() : void
      {
         var status:int = 0;
         super.showView();
         var overlayClass:Class = getDefinitionByName("fsg.popups.fsgPopupOverlay") as Class;
         this.mPopupOverlay = addChild(new overlayClass()) as Sprite;
         this.mPopupOverlay.visible = false;
         listen(BCInGameEvent.SHOW_NOTIFICATION_POPUP,this.onPopupShowStateChangeHandle);
         listen(BCInGameEvent.HIDE_NOTIFICATION_POPUP,this.onPopupShowStateChangeHandle);
         listen(BCEvent.QT_SETTING_STATE_CHANGED,this.onQtSettingStateChanged);
         if(this.myRecordBtn != null)
         {
            status = CFunctionCommonContainer.GetGameMomentsStatus();
            this.setRecordButtonStatus(status);
            listen(BCEvent.EVT_GAMEMOMENTS_STATUS_CHANGED,this.onGameMomentsStatusChanged);
         }
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(this.complaintViewIsOpenning())
         {
            return;
         }
         if(this.m_qtSettingShowing)
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
      }
      
      private function onQtButtonClicked() : void
      {
         broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
      }
      
      private function onRecordClicked() : void
      {
         broadcast(BCEvent.EVT_GAMEMOMENTS_TOGGLE);
      }
      
      private function onComplainsButtonClicked() : void
      {
         broadcast(BCEvent.EVT_REPORT_ACTIVE_PLAYER);
      }
      
      private function onGameMomentsStatusChanged(cEvt:ParaEvent) : void
      {
         var status:int = cEvt.myPara as int;
         this.setRecordButtonStatus(status);
      }
      
      private function setRecordButtonStatus(status:int) : void
      {
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
      
      private function onQtSettingStateChanged(cEvt:ParaEvent) : void
      {
         var isShow:Boolean = cEvt.myPara as Boolean;
         if(this.myQtSettingMask != null)
         {
            this.myQtSettingMask.visible = isShow;
         }
         this.m_qtSettingShowing = isShow;
      }
      
      private function onPopupShowStateChangeHandle(cEvt:ParaEvent) : void
      {
         this.mPopupOverlay.visible = cEvt.type == BCInGameEvent.SHOW_NOTIFICATION_POPUP;
      }
   }
}

