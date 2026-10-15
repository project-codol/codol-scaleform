package codo.controllers
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataInGameID;
   import codo.constants.MsgBtnCount;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.localization.DictDmz;
   import codo.localization.DictSystem;
   import codo.manager.CommInGameManager;
   import codo.manager.PageInGameManager;
   import codo.objects.SystemMsgObj;
   
   public class NotificationInGameController extends NotificationBaseController
   {
      
      private var _isUIKeyCatcherBound:Boolean = false;
      
      public function NotificationInGameController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataInGameID.IS_UIKEYCATCHER_BOUND,this.isUIKeyCatcherBound);
         this.listen(BCInGameEvent.BIND_UI_KEY_CATCHER,this.onBindUIKeyCatcherHandle);
      }
      
      override public function update(deltaTime:Number) : void
      {
         PageInGameManager.getInstance().updateCurrentFocusedPage();
         if(CommInGameManager.getInstance().isFocused() || this.getShoutCastMenuFocused())
         {
            if(!this.isUIKeyCatcherBound())
            {
               this.bindUIKeyCatcher(true);
            }
            if(!CommInGameManager.getInstance().isFocused())
            {
               CFunctionInGameContainer.AssignUIKeyCatcherToDotMenu();
            }
         }
         else if(this._isUIKeyCatcherBound && this.isUIKeyCatcherBound())
         {
            this.bindUIKeyCatcher(false);
         }
      }
      
      private function getShoutCastMenuFocused() : Boolean
      {
         var shoutCastMode:int = CFunctionCommonContainer.Dvar_GetInt("cl_shoutCastMode");
         var SHOUTCAST_PANELMODE:int = 2;
         return shoutCastMode == SHOUTCAST_PANELMODE;
      }
      
      private function getHudKitFocused() : Boolean
      {
         var hudKitWantsInput:Boolean = CFunctionCommonContainer.Dvar_GetBool("HUDKIT_WANTS_INPUT") as Boolean;
         trace("yarp hudkitwantsinput =  " + hudKitWantsInput);
         return hudKitWantsInput;
      }
      
      override protected function show(cSysMsgObj:Object) : void
      {
         var sysMsgObj:SystemMsgObj = null;
         sysMsgObj = cSysMsgObj as SystemMsgObj;
         this._currentNotification = sysMsgObj;
         if(!(sysMsgObj.btn0Handle is Function))
         {
            sysMsgObj.btn0Handle = this.hide;
         }
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_SYS_MSG_FSG,true);
         CodoInGamePageDB.PAGE_LAYER_NOTIFICATION.instance.showATField();
         broadcast(BCEvent.EVT_SET_SYS_VIEW_MSG,sysMsgObj);
         broadcast(BCInGameEvent.SHOW_NOTIFICATION_POPUP);
      }
      
      override protected function hide(cDelaySecond:Number = 0, cCallback:Function = null) : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_NOTIFICATION);
         broadcast(BCInGameEvent.HIDE_NOTIFICATION_POPUP);
      }
      
      private function isUIKeyCatcherBound() : Boolean
      {
         return CFunctionInGameContainer.IsUIKeyCatcherBound() as Boolean;
      }
      
      private function onBindUIKeyCatcherHandle(cEvt:ParaEvent) : void
      {
         this.bindUIKeyCatcher(cEvt.myPara);
      }
      
      private function bindUIKeyCatcher(bind:Boolean) : void
      {
         this._isUIKeyCatcherBound = bind;
         CFunctionInGameContainer.BindUIKeyCatcher(this._isUIKeyCatcherBound);
      }
      
      public function cppPromptToLeaveWithPartyMember() : void
      {
         var systemMessageObj:SystemMsgObj = SystemMsgObj.getObj(DictDmz.LEAVE_WITH_PARTY_MEMBER_PROMPT,MsgBtnCount.TWO,0,this.confirmLeaveWithPartyMember,DictSystem.QUIT,this.cancelLeaveWithPartyMember,DictSystem.CANCEL);
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_SYS_MSG_FSG,false,ViewState.ACTIVATED,systemMessageObj);
         CodoInGamePageDB.PAGE_LAYER_NOTIFICATION.instance.showATField();
         broadcast(BCEvent.EVT_SET_SYS_VIEW_MSG,systemMessageObj);
      }
      
      private function confirmLeaveWithPartyMember() : void
      {
         broadcast(BCInGameEvent.BACK_TO_MAIN_MENU);
      }
      
      private function cancelLeaveWithPartyMember() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_NOTIFICATION);
      }
   }
}

