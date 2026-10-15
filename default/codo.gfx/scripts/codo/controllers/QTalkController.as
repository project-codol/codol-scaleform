package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.constants.MsgBtnCount;
   import codo.constants.PageID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.CodoPageObj;
   import codo.objects.QTGameCircleConfigObj;
   import codo.utils.Logger;
   import components.Input;
   
   public class QTalkController extends BaseController
   {
      
      private var _isQVideoOpened:Boolean = false;
      
      private var _isQTHALOpened:Boolean = false;
      
      private var _isQLiveOpened:Boolean = false;
      
      private var _mCurMainLayerPage:String;
      
      private var _mSpecialPopupIsShow:Boolean = false;
      
      private const MAIN_MENU_ID_WHITE_LIST:Array = [PageID.HOME,PageID.MATCH_SELECT,PageID.CAREER_BATTLE_EXPERIENCE,PageID.CAREER_CHALLENGES,PageID.MARKET,PageID.MARKET_COMPARE,PageID.FSG_LOADOUT,PageID.SUPPLY_DROP];
      
      private const SPEICAL_POPUPS:Array = [PageID.FSG_MATCHRESULT];
      
      public function QTalkController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         Input.FOCUS_CHANGE_CB = this.onTFFocusChange;
         if(Boolean(CFunctionCommonContainer.IsQtEnabled()))
         {
            listen(BCCommonEvent.OPEN_QT_GAMECIRCLE,this.onQTGameCircleClicked);
            listen(BCCommonEvent.OPEN_QLIVE,this.onOpenQLive);
            listen(BCCommonEvent.CLOSE_QLIVE,this.onCloseQLive);
            listen(BCEvent.EVT_PAGE_CHANGED,this.onTryToUpdateCanPopup);
            listen(BCEvent.EVT_CLOSE_POPUP_PAGE,this.onClosePopupPage);
            listen(BCEvent.EVT_RESET_QLIVE_TOOL_TIP_TIME,this.onResetQLiveToolTipTime);
            listen(BCEvent.EVT_REQUEST_QQ_PLAYER_DATA,this.onRequestQQPlayerData);
            listen(BCEvent.EVT_SEND_GAME_RECOMMENDATION,this.onSendGameRecommendation);
         }
         this.addDP(DataID.IS_QT_ENABLED,this.isQtEnabled);
         this.addDP(DataID.SHOULD_SHOW_QLIVE_TOOLTIP,this.shouldShowQLiveToolTip);
      }
      
      private function onTFFocusChange(isFocusIn:Boolean) : void
      {
         if(isFocusIn)
         {
            CFunctionCommonContainer.SwitchFocusingTextField(true);
         }
         else
         {
            CFunctionCommonContainer.SwitchFocusingTextField(false);
         }
      }
      
      private function shouldShowQLiveToolTip() : Boolean
      {
         return this.getDvarBool("ui_show_qlive_tool_tip");
      }
      
      private function isQtEnabled() : Boolean
      {
         return CFunctionCommonContainer.IsQtEnabled() as Boolean;
      }
      
      private function onShowQT(cEvt:ParaEvent) : void
      {
         var screenOffset:Object = CFunctionContainer.ConvertPosUIToScreen(Number(50),Number(120));
         var cmd:String = "qtalk.hal2 " + screenOffset.x + " " + screenOffset.y;
         CFunctionCommonContainer.execnow(cmd);
      }
      
      private function onToggleSetting(cEvt:ParaEvent) : void
      {
         var popx:int = (GameInfo.gameWidth - 471) / 2;
         var popy:int = (GameInfo.gameHeight - 406) / 2;
         var cmd:String = "qtalk.setting " + String(popx) + " " + String(popy);
         CFunctionCommonContainer.execnow(cmd);
      }
      
      private function onForceCloseQtSetting(cEvt:ParaEvent) : void
      {
         var popx:int = (GameInfo.gameWidth - 471) / 2;
         var popy:int = (GameInfo.gameHeight - 406) / 2;
         var cmd:String = "qtalk.forceclosesetting " + String(popx) + " " + String(popy);
         CFunctionCommonContainer.execnow(cmd);
      }
      
      private function onOpenQLive(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.execnow("qlive.tryopen");
      }
      
      private function onCloseQLive(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.execnow("qlive.tryclose");
      }
      
      public function cppGetQTButtonConfig() : Object
      {
         var cObj:QTGameCircleConfigObj = getDP(DataID.GET_QT_GAMECIRCLE_BTN_CONFIG) as QTGameCircleConfigObj;
         var returnObj:Object = null;
         if(cObj != null)
         {
            returnObj = {
               "x":cObj.btnPos.x,
               "y":cObj.btnPos.y,
               "width":cObj.btnWidth,
               "height":cObj.btnHeight,
               "isClickable":cObj.isButtonClickable,
               "isHidden":cObj.isButtonHidden
            };
         }
         else
         {
            returnObj = {
               "x":0,
               "y":0,
               "width":uint(0),
               "height":uint(0),
               "isClickable":false,
               "isHidden":true
            };
         }
         return returnObj;
      }
      
      public function cppOnQtVideoStateChanged(isOpen:Boolean) : void
      {
         if(this._isQVideoOpened != isOpen)
         {
            this._isQVideoOpened = isOpen;
            this.broadcast(BCEvent.QT_VIDEO_STATE_CHANGE,isOpen);
         }
      }
      
      public function cppOnQLiveStateChanged(isOpen:Boolean) : void
      {
         if(this._isQLiveOpened != isOpen)
         {
            this._isQVideoOpened = isOpen;
         }
         this.broadcast(BCEvent.QLIVE_STATE_CHANGE,isOpen);
      }
      
      public function cppOnQtHalStateChanged(isOpen:Boolean) : void
      {
         if(this._isQTHALOpened != isOpen)
         {
            this._isQTHALOpened = isOpen;
            this.broadcast(BCEvent.QT_HAL_STATE_CHANGE,isOpen);
         }
      }
      
      public function cppOnQtSettingStateChanged(isOpen:Boolean) : void
      {
         this.broadcast(BCEvent.QT_SETTING_STATE_CHANGED,isOpen);
      }
      
      public function cppOnGetQQUser(isSuccess:Boolean, object:Object) : void
      {
         setBindData(DataID.GET_QQ_MEMBER_DATA,isSuccess ? object : null);
      }
      
      public function cppOnQtEngineConfigVolumeLoaded(volume:Number, microphoneVolume:Number) : void
      {
         CFunctionCommonContainer.AS_SetQtEngineConfigVolume(volume,microphoneVolume);
      }
      
      private function onQTGameCircleClicked(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.execnow("circle.show");
      }
      
      private function onTryToUpdateCanPopup(cEvt:ParaEvent) : void
      {
         var pageObj:CodoPageObj = cEvt.myPara.pageObj;
         if(this.isSpecialPopup(pageObj.id))
         {
            this._mSpecialPopupIsShow = true;
            CFunctionCommonContainer.execnow("qlive.canOpen 0");
            return;
         }
         if(Boolean(pageObj.owner) && pageObj.owner.name == "instance_pageLayer_main")
         {
            Logger.print("Jump to page in main layer: ",pageObj.id);
            this._mCurMainLayerPage = pageObj.id;
            this.updateQLiveCanShowState();
            if(pageObj.id == PageID.HOME)
            {
               CFunctionCommonContainer.execnow("qlive.forceSendGameStatus");
            }
         }
      }
      
      private function updateQLiveCanShowState() : void
      {
         if(this._mSpecialPopupIsShow)
         {
            return;
         }
         var canOpen:int = 0;
         var count:int = int(this.MAIN_MENU_ID_WHITE_LIST.length);
         for(var i:int = 0; i < count; i++)
         {
            if(this.MAIN_MENU_ID_WHITE_LIST[i] == this._mCurMainLayerPage)
            {
               canOpen = 1;
            }
         }
         CFunctionCommonContainer.execnow("qlive.canOpen " + String(canOpen));
      }
      
      private function onClosePopupPage(cEvt:ParaEvent) : void
      {
         var pageID:String = cEvt.myPara.pageID;
         if(this.isSpecialPopup(pageID))
         {
            this._mSpecialPopupIsShow = false;
            this.updateQLiveCanShowState();
         }
      }
      
      private function onResetQLiveToolTipTime(cEvt:ParaEvent) : void
      {
         CFunctionContainer.ResetQLiveToolTipTime();
      }
      
      private function onRequestQQPlayerData(cEvt:ParaEvent) : void
      {
         var para:Object = cEvt.myPara;
         CFunctionContainer.AS_GetQQPlayer(para.category,para.startIndex,para.numRequest);
      }
      
      private function onSendGameRecommendation(cEvt:ParaEvent) : void
      {
         CFunctionContainer.AS_InviteQQFriend([cEvt.myPara.id]);
         showMsg(Dict.THANK_FOR_YOUR_RECOMMENDATION,MsgBtnCount.ONE);
      }
      
      private function isSpecialPopup(pageID:String) : Boolean
      {
         var specialPopupCount:int = int(this.SPEICAL_POPUPS.length);
         for(var i:int = 0; i < specialPopupCount; i++)
         {
            if(this.SPEICAL_POPUPS[i] == pageID)
            {
               return true;
            }
         }
         return false;
      }
   }
}

