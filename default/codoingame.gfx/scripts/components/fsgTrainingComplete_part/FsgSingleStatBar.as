package components.fsgTrainingComplete_part
{
   import codo.objects.FsgTrainingSummaryObj;
   import codo.utils.TimeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgSingleStatBar extends MovieClip
   {
      
      private static var DURATION:int = 2;
      
      public static const NUMBER_STAT_TYPE:uint = 1;
      
      public static const TIME_STAT_TYPE:uint = 3;
      
      public var myHeaderTF:TextField;
      
      public var myCurrentScoreTF:TextField;
      
      public var myResultTF:TextField;
      
      public var myBackground:Sprite;
      
      public var myIcons:FsgImageHolder;
      
      private var m_score:Number;
      
      private var m_ScoreIncrement:Number = 0;
      
      private var m_ScoreCurrent:Number = 0;
      
      private var m_interval:int = 100;
      
      private var m_timer:Timer = new Timer(1000 / this.m_interval);
      
      private var m_data:Object;
      
      public function FsgSingleStatBar()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myHeaderTF,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(this.myCurrentScoreTF,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(this.myResultTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function set headerText(str:String) : void
      {
         this.myHeaderTF.text = str;
      }
      
      public function setData(data:FsgTrainingSummaryObj, type:uint = 1) : void
      {
         this.m_data = data;
         this.myIcons.gotoAndStop(data.iconFrame);
         if(type == TIME_STAT_TYPE)
         {
            data.val = TimeUtil.sec2Str(data.val as Number);
            this.myResultTF.text = data.val;
         }
         else if(data.val == "")
         {
            this.myResultTF.text = "0";
         }
         else
         {
            this.myResultTF.text = data.val;
         }
         this.myCurrentScoreTF.text = "0";
      }
      
      public function get finalScore() : int
      {
         return this.m_data.score;
      }
      
      public function start() : void
      {
         this.m_score = 0;
         this.m_ScoreCurrent = 0;
         this.m_ScoreIncrement = this.m_data.score / (60 * DURATION);
         this.m_timer.addEventListener(TimerEvent.TIMER,this._update);
         this.m_timer.start();
      }
      
      public function zeroPad(number:int, width:int) : String
      {
         var ret:String = "" + number;
         while(ret.length < width)
         {
            ret = "0" + ret;
         }
         return ret;
      }
      
      private function _update(event:TimerEvent) : void
      {
         this.m_ScoreCurrent += this.m_ScoreIncrement;
         if(this.m_ScoreCurrent > this.m_data.score)
         {
            this.m_ScoreCurrent = this.m_data.score;
         }
         if(this.m_ScoreCurrent == this.m_data.score)
         {
            this.m_timer.stop();
         }
         this.myCurrentScoreTF.text = Math.floor(this.m_ScoreCurrent).toString();
      }
   }
}

