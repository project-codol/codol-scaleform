package codo.views.motd_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.interfaces.IDisposable;
   import codo.localization.DictMOTD;
   import codo.style.GlobalGuide;
   import codo.style.MOTDGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MOTDCheckinRewardsDuration extends Sprite implements IDisposable
   {
      
      private static const LOCALIZE:Function = LocalizeUtil.localize;
      
      private static const FLOOR:Function = Math.floor;
      
      private static const ADD_ZERO:Function = StringUtil.addZero;
      
      private static const HOURS_PER_DAY:int = 24;
      
      private static const MINS_SECS:int = 60;
      
      public var myDurationLabelTF:TextField;
      
      public var myDaysLabelTF:TextField;
      
      public var myHoursLabelTF:TextField;
      
      public var myMinutesLabelTF:TextField;
      
      public var mySecondsLabelTF:TextField;
      
      public var myDaysTF:TextField;
      
      public var myHoursTF:TextField;
      
      public var myMinutesTF:TextField;
      
      public var mySecondsTF:TextField;
      
      private var mTimerCount:Timer;
      
      private var mEndOfMonthDate:Date;
      
      private var mShowMonthCountdown:Boolean = false;
      
      public function MOTDCheckinRewardsDuration()
      {
         var style:TextStyle = null;
         super();
         style = MOTDGuide.styleRewardDurationTitle;
         style.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myDurationLabelTF.width = 224;
         this.myDurationLabelTF.alpha = 0.7;
         style.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myDaysLabelTF.alpha = this.myHoursLabelTF.alpha = this.myMinutesLabelTF.alpha = this.mySecondsLabelTF.alpha = 0.7;
         this.myDaysLabelTF.textStyle = this.myHoursLabelTF.textStyle = this.myMinutesLabelTF.textStyle = this.mySecondsLabelTF.textStyle = style;
         this.myDaysLabelTF.text = LOCALIZE(DictMOTD.LABEL_DAYS);
         this.myHoursLabelTF.text = LOCALIZE(DictMOTD.LABEL_HOURS);
         this.myMinutesLabelTF.text = LOCALIZE(DictMOTD.LABEL_MINUTES);
         this.mySecondsLabelTF.text = LOCALIZE(DictMOTD.LABEL_SECONDS);
         style = GlobalGuide.styleNumericTextSmall;
         style.fontSize = 60;
         this.myDaysTF.text = this.myHoursTF.text = this.myMinutesTF.text = this.mySecondsTF.text = "";
         this.myDaysTF.textStyle = this.myHoursTF.textStyle = this.myMinutesTF.textStyle = this.mySecondsTF.textStyle = style;
         visible = false;
      }
      
      public function init() : void
      {
         var currDate:Date = null;
         var INIT_Y:int = 0;
         var PADDING:int = 0;
         var isDecember:Boolean = false;
         this.mTimerCount = new Timer(1000);
         currDate = new Date();
         INIT_Y = 57;
         PADDING = 5;
         visible = true;
         isDecember = currDate.getUTCMonth() == 11;
         var nextMonthYear:Number = !isDecember ? currDate.getUTCFullYear() : currDate.getUTCFullYear() + 1;
         var nextMonth:Number = !isDecember ? currDate.getUTCMonth() + 1 : 0;
         this.mEndOfMonthDate = new Date(nextMonthYear,nextMonth,1,0);
         this.updateTimeEndOfMonth();
         if(this.mShowMonthCountdown)
         {
            this.myDurationLabelTF.text = LOCALIZE(DictMOTD.TIME_REMAINING_BEFORE_ITEMS_EXPIRE);
            this.myDaysLabelTF.y = this.myDaysTF.y = INIT_Y;
            this.myHoursLabelTF.y = this.myHoursTF.y = this.myDaysTF.y + this.myDaysTF.textHeight + PADDING;
            this.myMinutesLabelTF.y = this.myMinutesTF.y = this.myHoursTF.y + this.myHoursTF.textHeight + PADDING;
            this.myDaysLabelTF.visible = this.myDaysTF.visible = true;
            this.mySecondsLabelTF.visible = this.mySecondsTF.visible = false;
         }
         else
         {
            this.myDurationLabelTF.text = LOCALIZE(DictMOTD.TIME_REMAINING_LOGIN_AGAIN);
            this.myHoursLabelTF.y = this.myHoursTF.y = INIT_Y;
            this.myMinutesLabelTF.y = this.myMinutesTF.y = this.myHoursTF.y + this.myHoursTF.textHeight + PADDING;
            this.mySecondsLabelTF.y = this.mySecondsTF.y = this.myMinutesTF.y + this.myMinutesTF.textHeight + PADDING;
            this.myDaysLabelTF.visible = this.myDaysTF.visible = false;
            this.mySecondsLabelTF.visible = this.mySecondsTF.visible = true;
         }
         this.mTimerCount.addEventListener(TimerEvent.TIMER,this.updateTimeEndOfMonth);
         this.mTimerCount.start();
      }
      
      public function dispose() : void
      {
         visible = false;
         if(this.mTimerCount == null)
         {
            return;
         }
         this.mTimerCount.removeEventListener(TimerEvent.TIMER,this.updateTimeEndOfMonth);
         this.mTimerCount.stop();
         this.mTimerCount = null;
      }
      
      private function updateTimeEndOfMonth(e:TimerEvent = null) : void
      {
         var remainTime:Number = this.mEndOfMonthDate.getTime() / 1000 - CFunctionCommonContainer.GetServerTimeStamp();
         var minute:Number = FLOOR(remainTime / MINS_SECS);
         var hours:Number = FLOOR(minute / MINS_SECS);
         var days:Number = FLOOR(hours / HOURS_PER_DAY);
         var seconds:Number = FLOOR(remainTime % MINS_SECS);
         minute %= MINS_SECS;
         hours %= HOURS_PER_DAY;
         this.myHoursTF.text = ADD_ZERO(hours);
         this.myMinutesTF.text = ADD_ZERO(minute);
         if(this.mShowMonthCountdown)
         {
            this.myDaysTF.text = ADD_ZERO(days);
         }
         else
         {
            this.mySecondsTF.text = ADD_ZERO(seconds);
         }
      }
      
      public function set modeShowMonthCountdown(showMonth:Boolean) : void
      {
         this.mShowMonthCountdown = showMonth;
      }
   }
}

