package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   import codo.objects.RemainDateObj;
   
   public class TimeUtil
   {
      
      public static const SECONDS_IN_A_MINUTE:uint = 60;
      
      public static const SECONDS_IN_A_HOUR:uint = 3600;
      
      public static const SECONDS_IN_HALF_A_DAY:uint = 43200;
      
      public static const SECONDS_IN_A_DAY:uint = 86400;
      
      public static const REWARD_MAXIMUM_DURATION:uint = 60;
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function timeToString(seconds:Number) : String
      {
         return uint(seconds / SECONDS_IN_A_HOUR) + LocalizeUtil.localize(Dict.HOUR_SHORT) + " " + uint(seconds % SECONDS_IN_A_HOUR / SECONDS_IN_A_MINUTE) + LocalizeUtil.localize(Dict.MINUTE) + " " + uint(seconds % SECONDS_IN_A_MINUTE) + LocalizeUtil.localize(Dict.SECOND);
      }
      
      public static function timeToStringEN(seconds:Number) : String
      {
         var tempH:String = String(uint(seconds / SECONDS_IN_A_HOUR));
         var tempM:String = String(uint(seconds % SECONDS_IN_A_HOUR / SECONDS_IN_A_MINUTE));
         var tempS:String = String(uint(seconds % SECONDS_IN_A_MINUTE));
         if(tempH.length == 1)
         {
            tempH = "0" + tempH;
         }
         if(tempM.length == 1)
         {
            tempM = "0" + tempM;
         }
         if(tempS.length == 1)
         {
            tempS = "0" + tempS;
         }
         return tempH + " : " + tempM + " : " + tempS;
      }
      
      public static function sec2Str(seconds:Number) : String
      {
         var m:int = seconds % SECONDS_IN_A_HOUR / SECONDS_IN_A_MINUTE;
         var s:int = seconds % SECONDS_IN_A_MINUTE;
         return StringUtil.addZero(m) + ":" + StringUtil.addZero(s);
      }
      
      public static function secondToRemainDate(cSecond:uint) : RemainDateObj
      {
         var tempDay:uint = Math.floor(cSecond / SECONDS_IN_A_DAY);
         var tempHour:uint = Math.floor((cSecond - tempDay * SECONDS_IN_A_DAY) / SECONDS_IN_A_HOUR);
         var tempMinute:uint = Math.floor((cSecond - tempDay * SECONDS_IN_A_DAY - tempHour * SECONDS_IN_A_HOUR) / SECONDS_IN_A_MINUTE);
         var tempSec:uint = cSecond % SECONDS_IN_A_MINUTE;
         return new RemainDateObj(tempDay,tempHour,tempMinute,tempSec);
      }
      
      public static function time(timeStamp:Number = 0) : String
      {
         var now:Date = new Date();
         if(timeStamp > 0)
         {
            now.setTime(timeStamp * 1000);
         }
         return StringUtil.addZero(now.hours) + ":" + StringUtil.addZero(now.minutes) + ":" + StringUtil.addZero(now.seconds);
      }
      
      public static function date(timeStamp:Number = 0, delimiter:String = "-") : String
      {
         var now:Date = new Date();
         if(timeStamp > 0)
         {
            now.setTime(timeStamp * 1000);
         }
         return now.fullYear + delimiter + StringUtil.addZero(now.month + 1) + delimiter + StringUtil.addZero(now.date);
      }
      
      public static function compareDateWithCurrentData(cSec:uint) : String
      {
         var result:String = null;
         var diffYear:uint = 0;
         var diffMonth:uint = 0;
         var diffDay:uint = 0;
         var diffHour:uint = 0;
         var diffMinute:uint = 0;
         var nowDat:Date = new Date();
         var nowSec:uint = Math.floor(nowDat.getTime() / 1000);
         var diffSec:int = nowSec - cSec;
         if(diffSec >= 0)
         {
            diffYear = Math.floor(diffSec / (SECONDS_IN_A_DAY * 365));
            diffMonth = Math.floor(diffSec / (SECONDS_IN_A_DAY * 30));
            diffDay = Math.floor(diffSec / SECONDS_IN_A_DAY);
            diffHour = Math.floor(diffSec / SECONDS_IN_A_HOUR);
            diffMinute = Math.floor(diffSec / SECONDS_IN_A_MINUTE);
            if(diffYear > 0)
            {
               result = LocalizeUtil.localize(Dict.COMPARE_DATE_1_YEAR_AGO);
            }
            else if(diffMonth > 0)
            {
               result = LocalizeUtil.replace(LocalizeUtil.localize(Dict.COMPARE_DATE_X_MONTH_AGO),[diffMonth.toString()]);
            }
            else if(diffDay > 0)
            {
               result = LocalizeUtil.replace(LocalizeUtil.localize(Dict.COMPARE_DATE_X_DAY_AGO),[diffDay.toString()]);
            }
            else if(diffHour > 0)
            {
               result = LocalizeUtil.replace(LocalizeUtil.localize(Dict.COMPARE_DATE_X_HOUR_AGO),[diffHour.toString()]);
            }
            else if(diffMinute > 0)
            {
               result = LocalizeUtil.replace(LocalizeUtil.localize(Dict.COMPARE_DATE_X_MIN_AGO),[diffMinute.toString()]);
            }
            else
            {
               result = LocalizeUtil.localize(Dict.COMPARE_DATE_JUST);
            }
         }
         else
         {
            result = LocalizeUtil.localize(Dict.COMPARE_DATE_FUTURE);
         }
         return result;
      }
      
      public static function now(timeStamp:Number = 0, delimiter:String = "-") : String
      {
         return TimeUtil.date(timeStamp,delimiter) + " " + TimeUtil.time(timeStamp);
      }
      
      public static function secondsToDays(cSeconds:uint) : uint
      {
         var nDays:Number = cSeconds / SECONDS_IN_A_DAY;
         if(nDays >= 1)
         {
            nDays -= 0.001;
         }
         return Math.ceil(nDays);
      }
      
      public static function remainingTime(cSeconds:uint, labelLoc:String = null, isRandomReward:Boolean = false) : String
      {
         var hourBand:int = 0;
         var remainingHours:int = 0;
         if(labelLoc == null)
         {
            labelLoc = Dict.TIME_REMAINING;
         }
         if(cSeconds <= SECONDS_IN_HALF_A_DAY)
         {
            hourBand = 12;
            remainingHours = Math.floor(cSeconds / SECONDS_IN_A_HOUR);
            if(remainingHours <= 1)
            {
               hourBand = 1;
            }
            else if(remainingHours <= 3)
            {
               hourBand = 3;
            }
            else if(remainingHours <= 6)
            {
               hourBand = 6;
            }
            return LocalizeUtil.localize(labelLoc) + " <font face=\"$font_5\">" + hourBand + "</font> " + LocalizeUtil.localize(Dict.HOUR);
         }
         var uDays:uint = TimeUtil.secondsToDays(cSeconds);
         if(isRandomReward && uDays == REWARD_MAXIMUM_DURATION)
         {
            return LocalizeUtil.localize(labelLoc) + " <font face=\"$font_5\">" + uDays + "</font> " + LocalizeUtil.localize(Dict.DAY) + " " + LocalizeUtil.localize(Dict.INVENTORY_MAXIMUM_REWARD);
         }
         return LocalizeUtil.localize(labelLoc) + " <font face=\"$font_5\">" + uDays + "</font> " + LocalizeUtil.localize(Dict.DAY);
      }
      
      private static function divideRoundUp(seconds:uint, interval:uint) : uint
      {
         var div:uint = seconds / interval;
         return seconds % interval != 0 ? uint(div + 1) : div;
      }
      
      private static function timeLeftStr(val:uint, str:String, useHTML:Boolean) : String
      {
         var valStr:String = val.toString();
         if(useHTML)
         {
            valStr = "<font face=\"$font_5\">" + valStr + "</font>";
         }
         return LocalizeUtil.replace(LocalizeUtil.localize(str),[valStr]);
      }
      
      public static function convertTimeRemainingToHHMMSS(seconds:int, useHTML:Boolean = true, keptRemainHeader:Boolean = false) : String
      {
         CFunctionCommonContainer.Assert(seconds > 0,new Error("Invalid time remaining."));
         var headerWithRemain:Array = [Dict.DAYS_LEFT,Dict.HOURS_LEFT,Dict.MINUTES_LEFT,Dict.MINUTE_LEFT];
         var headerWithoutRemain:Array = [Dict.DAYS_HAVE,Dict.HOURS_HAVE,Dict.MINUTES_HAVE,Dict.MINUTE_HAVE];
         var header:Array = keptRemainHeader ? headerWithRemain : headerWithoutRemain;
         var d:uint = divideRoundUp(seconds,SECONDS_IN_A_DAY);
         if(d > 1)
         {
            return timeLeftStr(d,header[0],useHTML);
         }
         var h:uint = divideRoundUp(seconds,SECONDS_IN_A_HOUR);
         CFunctionCommonContainer.Assert(h <= 24,new Error("Bad hours left."));
         if(h > 1)
         {
            return timeLeftStr(h,header[1],useHTML);
         }
         var m:uint = divideRoundUp(seconds,SECONDS_IN_A_MINUTE);
         CFunctionCommonContainer.Assert(m <= 60 && m > 0,new Error("Bad minutes left."));
         var mStr:String = m == 1 ? header[3] : header[2];
         return timeLeftStr(m,mStr,useHTML);
      }
      
      public static function timeInMinutes(cSeconds:int) : int
      {
         return cSeconds / SECONDS_IN_A_MINUTE;
      }
      
      public static function timeInHours(cSeconds:int) : int
      {
         return cSeconds / SECONDS_IN_A_HOUR;
      }
      
      public static function forever() : String
      {
         return LocalizeUtil.localize(Dict.FOREVER);
      }
      
      public static function convertToUnix(value:Date) : int
      {
         var currentDate:Number = value.date;
         var currentMonth:Number = value.month;
         var currentYear:Number = value.fullYear;
         var dt:Date = new Date(currentYear,currentMonth,currentDate);
         return Math.round(dt.getTime() / 1000);
      }
   }
}

