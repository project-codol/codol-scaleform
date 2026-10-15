package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictInGame;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LeaveInGameController extends BaseController
   {
      
      private static var LEAVE_TIMEOUT_INTERVAL:int = 5000;
      
      private var mLeaving:Boolean = false;
      
      private var mTimer:Timer;
      
      public function LeaveInGameController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         super.onInitialized();
         listen(BCInGameEvent.EVT_REQUEST_LEAVE_INGAME,this.leaveInGameRequestHandler);
         LEAVE_TIMEOUT_INTERVAL = getDvarInt("cl_sendDisconnectToDSTimeout");
         this.mTimer = new Timer(LEAVE_TIMEOUT_INTERVAL);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onLeaveTimeout);
      }
      
      private function leaveInGameRequestHandler(evt:ParaEvent) : void
      {
         if(this.mLeaving)
         {
            return;
         }
         this.mLeaving = true;
         showMsg(DictInGame.LEAVE_IN_PROGRESS);
         CFunctionCommonContainer.LeaveRoom(false,false);
         CFunctionInGameContainer.AS_RequestLeaveInGame();
         this.mTimer.start();
      }
      
      private function onLeaveTimeout(evt:TimerEvent) : void
      {
         this.mTimer.stop();
         this.mTimer.reset();
         this.forceToLeaveInGame();
      }
      
      private function forceToLeaveInGame() : void
      {
         CFunctionCommonContainer.execnow("disconnect");
      }
   }
}

