package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class CircleTimer extends MovieClip
   {
      
      private static const TIMER_TICK:int = 1000;
      
      private static const TIMER_STATE_NONE:int = 0;
      
      private static const TIMER_STATE_NEXT:int = 1;
      
      private static const TIMER_STATE_CLOSING:int = 2;
      
      private static const TEXT_COLOR_YELLOW:uint = 16776960;
      
      public var myLabel:TextField;
      
      public var myTime:TextField;
      
      private var mTimer:Timer;
      
      private var mTimeLeft:int;
      
      public function CircleTimer()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myLabel.text = LocalizeUtil.localize(DictDmz.TIMER_CIRCLE_NEXT);
         this.mTimer = new Timer(TIMER_TICK);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
      }
      
      private function set time(seconds:int) : void
      {
         var minute:int = seconds / 60;
         var second:int = seconds % 60;
         this.myTime.text = minute.toString() + ":" + StringUtil.addZero(second);
      }
      
      public function updateTimer(timerState:int, secondsLeft:int) : void
      {
         this.mTimeLeft = secondsLeft - 1;
         if(timerState == TIMER_STATE_NONE)
         {
            this.myLabel.visible = this.myTime.visible = false;
         }
         else
         {
            this.myLabel.visible = this.myTime.visible = true;
            if(timerState == TIMER_STATE_NEXT)
            {
               this.myLabel.text = LocalizeUtil.localize(DictDmz.TIMER_CIRCLE_NEXT);
               this.myLabel.textColor = GlobalGuide.WHITE;
            }
            else
            {
               this.myLabel.text = LocalizeUtil.localize(DictDmz.TIMER_CIRCLE_CLOSING);
               this.myLabel.textColor = TEXT_COLOR_YELLOW;
            }
            this.time = this.mTimeLeft;
            this.mTimer.reset();
            this.mTimer.start();
         }
      }
      
      private function onTimerTick(evt:TimerEvent) : void
      {
         --this.mTimeLeft;
         if(this.mTimeLeft < 0)
         {
            this.mTimer.stop();
            return;
         }
         this.time = this.mTimeLeft;
      }
   }
}

