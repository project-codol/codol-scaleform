package components.fsgTrainingComplete_part
{
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.localization.DictCoopSummary;
   import codo.localization.DictOnBoard;
   import codo.objects.FsgTrainingSummaryObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import fsg.util.FsgAudioUtil;
   
   public class FsgTrainingStarBar extends MovieClip
   {
      
      public static const EVT_STAR_AWARDED:String = "evt_star_awarded";
      
      private static const DURATION:int = 1;
      
      public var myPreviousTF:TextField;
      
      public var myTotalLabelTF:TextField;
      
      public var myPreviousBestTitleTF:TextField;
      
      public var myResultTF:TextField;
      
      public var myResultLabelTF:TextField;
      
      public var myStartAnimGroup:MovieClip;
      
      private var m_stars:Vector.<MovieClip>;
      
      private var m_data:FsgTrainingSummaryObj;
      
      private var m_numberStars:int = 1;
      
      private var m_increment:Number = 0;
      
      private var m_score:Number = 0;
      
      private var m_timer:Timer = new Timer(1000 / 60);
      
      private var mStarIndexCounter:uint = 1;
      
      public function FsgTrainingStarBar()
      {
         super();
         this.myTotalLabelTF.autoSize = TextFieldAutoSize.LEFT;
         this.myResultLabelTF.autoSize = this.myResultTF.autoSize = TextFieldAutoSize.RIGHT;
         this.m_stars = new <MovieClip>[this.myStartAnimGroup.myStar01,this.myStartAnimGroup.myStar02,this.myStartAnimGroup.myStar03,this.myStartAnimGroup.myStar04,this.myStartAnimGroup.myStar05];
      }
      
      public function setData(data:FsgTrainingSummaryObj) : void
      {
         var LOCALIZE:Function = LocalizeUtil.localize;
         this.reset();
         this.m_data = data;
         this.myTotalLabelTF.text = LOCALIZE(DictCoopSummary.YOUR_SCORE).toUpperCase();
         this.myPreviousTF.text = this.m_data.preBestScore.toString();
         this.myPreviousBestTitleTF.text = DictOnBoard.ONBOARD_TRAINING_RESULTS_PREVIOUS_BEST;
         this.myResultLabelTF.text = DictOnBoard.ONBOARD_TRAINING_RESULTS_POINTS;
         this.m_timer.addEventListener(TimerEvent.TIMER,this._update);
      }
      
      public function start() : void
      {
         this.m_score = 0;
         this.m_numberStars = this.mStarIndexCounter = this.m_data.star;
         this.m_increment = this.m_data.score / (60 * DURATION);
         this.m_timer.start();
      }
      
      public function get finalScore() : uint
      {
         return this.m_data.score;
      }
      
      public function reset() : void
      {
         this.myPreviousTF.text = "0";
         this.myResultTF.text = "0";
         this.mStarIndexCounter = 1;
         for(var i:int = 0; i < this.m_stars.length; i++)
         {
            this.m_stars[i].gotoAndStop(1);
         }
      }
      
      private function _update(event:TimerEvent) : void
      {
         this.m_score += this.m_increment;
         if(this.m_score > this.finalScore)
         {
            this.m_score = this.finalScore;
            this.m_timer.stop();
            this.m_timer.removeEventListener(TimerEvent.TIMER,this._update);
            this.dispatchEvent(new ParaEvent(EVT_STAR_AWARDED));
         }
         this.myResultTF.text = Math.floor(this.m_score).toString();
         var star:int = this.m_score / this.finalScore * this.m_numberStars;
         if(star >= 1)
         {
            this.playNextStar(star);
         }
      }
      
      private function playNextStar(index:int) : void
      {
         if(this.m_stars[index - 1].currentFrame == 1)
         {
            this.m_stars[index - 1].play();
            FsgAudioUtil.getInstance().playSound(SE_ID.UI_ONBOARD_TRAINING_COMPLETE_UNLOCK_AWARDED);
         }
      }
   }
}

