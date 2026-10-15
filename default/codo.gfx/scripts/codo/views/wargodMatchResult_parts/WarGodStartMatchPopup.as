package codo.views.wargodMatchResult_parts
{
   import codo.base.PopupView;
   import codo.constants.BCEvent;
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.localization.DictRoom;
   import codo.localization.DictWarGod;
   import codo.utils.SoundUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class WarGodStartMatchPopup extends PopupView
   {
      
      private static const POPUP_WIDTH:int = 450;
      
      private static const POPUP_HEIGHT:int = 300;
      
      private static const FORCE_LEAVE_TIME:int = 8000;
      
      public var myLabel:TextField;
      
      public var myCountDown:MovieClip;
      
      private var mForceLeaveTimer:Timer = new Timer(FORCE_LEAVE_TIME);
      
      public function WarGodStartMatchPopup()
      {
         super();
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         headerTitle = DictRoom.RANKED_MATCH_READY_TO_START;
         this.myLabel.text = DictWarGod.LEAVE_WARNING;
         this.myCountDown.visible = false;
         myPopup.myCloseButton.setClickCallback(this.forceStopMatchMaking);
      }
      
      private function setCountDownNumber(value:int) : void
      {
         this.myCountDown.visible = true;
         this.myCountDown.mySecond.myTF.text = String(value);
         this.myCountDown.gotoAndPlay(1);
         SoundUtil.getInstance().playSound(SE_ID.GENERAL_COUNTDOWN);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myCountDown.visible = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.RANKED_MATCH_GO_ROOM_TIMER,this.onSetMatchTimer);
         this.triggerForceLeaveTimer();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.RANKED_MATCH_GO_ROOM_TIMER,this.onSetMatchTimer);
         this.stopForceLeaveTimerInternal();
      }
      
      private function onSetMatchTimer(e:ParaEvent) : void
      {
         this.setCountDownNumber(e.myPara);
      }
      
      private function triggerForceLeaveTimer() : void
      {
         this.triggerForceLeaveTimerInternal();
      }
      
      private function triggerForceLeaveTimerInternal() : void
      {
         this.mForceLeaveTimer.addEventListener(TimerEvent.TIMER,this.onLeaveTimerTicked);
         this.mForceLeaveTimer.start();
         myPopup.myCloseButton.visible = false;
      }
      
      private function onLeaveTimerTicked(e:TimerEvent) : void
      {
         this.stopForceLeaveTimerInternal();
      }
      
      private function stopForceLeaveTimerInternal() : void
      {
         this.mForceLeaveTimer.removeEventListener(TimerEvent.TIMER,this.onLeaveTimerTicked);
         this.mForceLeaveTimer.stop();
         this.mForceLeaveTimer.reset();
         myPopup.myCloseButton.visible = true;
         this.myCountDown.mySecond.myTF.text = "";
         this.myLabel.text = DictWarGod.ENEMY_HAS_GONE;
      }
      
      private function forceStopMatchMaking() : void
      {
         closePopupView();
         broadcast(BCEvent.LEAVE_ROOM,{"isUserInput":true});
      }
   }
}

