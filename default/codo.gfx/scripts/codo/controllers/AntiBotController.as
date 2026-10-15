package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.DictSystem;
   import codo.objects.SystemMsgObj;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AntiBotController extends BaseController
   {
      
      private const INTERVAL_CHECK_DELAY:int = 5000;
      
      private var m_fetchAntiBotPunishTipTimer:Timer;
      
      private var m_punishPopShowing:Boolean = false;
      
      private var m_isInGame:Boolean = false;
      
      private var m_pendingTips:Array;
      
      public function AntiBotController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         addDP(DataID.PUNISH_POPUP_SHOWING,this.getIsPunishPopShowing);
         this.m_fetchAntiBotPunishTipTimer = new Timer(this.INTERVAL_CHECK_DELAY);
         this.m_fetchAntiBotPunishTipTimer.addEventListener(TimerEvent.TIMER,this.onFetchAntiBotPunishTipHandler);
         this.m_fetchAntiBotPunishTipTimer.start();
         listen(BCInGameEvent.EVT_PAUSE_MENU_OPENED,this.onPauseMenuOpened);
      }
      
      private function onFetchAntiBotPunishTipHandler(event:TimerEvent) : void
      {
         this.m_pendingTips = CFunctionCommonContainer.AS_ClaimPunishTips();
         this.processPunishTips(false);
      }
      
      private function onPauseMenuOpened(cEvt:ParaEvent) : void
      {
         if(Boolean(this.m_pendingTips) && this.m_pendingTips.length > 0)
         {
            this.processPunishTips(true);
         }
      }
      
      private function processPunishTips(forceShowMessage:Boolean) : void
      {
         var currentIndex:int = 0;
         var sysMsgObj:SystemMsgObj = null;
         var onConfirmBtnClicked:Function = null;
         var tryShowMsg:Function = function():void
         {
            if(currentIndex < m_pendingTips.length)
            {
               if(m_isInGame && forceShowMessage == false)
               {
                  broadcast(BCCommonEvent.EVT_GOTO_SHOW_PUNISH_TIP);
               }
               if(!m_isInGame || forceShowMessage)
               {
                  m_punishPopShowing = true;
                  sysMsgObj = showMsg(m_pendingTips[currentIndex].reason,MsgBtnCount.ONE,0,onConfirmBtnClicked,DictSystem.CONFIRM);
               }
            }
            else
            {
               m_pendingTips.splice(0);
               m_punishPopShowing = false;
               m_fetchAntiBotPunishTipTimer.start();
            }
         };
         onConfirmBtnClicked = function():void
         {
            hideSpecificMsg(sysMsgObj);
            var temp:Object = m_pendingTips[currentIndex];
            CFunctionCommonContainer.AS_RemovePunishTips(temp.time,temp.rawReason,temp.rawInfo);
            ++currentIndex;
            tryShowMsg();
         };
         currentIndex = 0;
         this.m_fetchAntiBotPunishTipTimer.stop();
         tryShowMsg();
      }
      
      private function getIsPunishPopShowing() : Boolean
      {
         return this.m_punishPopShowing;
      }
      
      public function set isInGame(value:Boolean) : void
      {
         this.m_isInGame = value;
      }
   }
}

