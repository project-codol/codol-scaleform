package components.fsgTrainingComplete_part
{
   import codo.constants.SE_ID;
   import codo.localization.DictCoopSummary;
   import codo.objects.FsgTrainingSummaryObj;
   import flash.display.MovieClip;
   import flash.events.Event;
   import fsg.util.FsgAudioUtil;
   
   public class FsgCombinedStatBarPanel extends MovieClip
   {
      
      public var myAccuracyBar:FsgSingleStatBar;
      
      public var myTimeBar:FsgSingleStatBar;
      
      public var myCustomBar:FsgSingleStatBar;
      
      private var m_onCompleteCallback:Function;
      
      public function FsgCombinedStatBarPanel()
      {
         super();
         stop();
      }
      
      public function setup(accuracyData:FsgTrainingSummaryObj, timeData:FsgTrainingSummaryObj, targetsData:FsgTrainingSummaryObj) : void
      {
         this.myAccuracyBar.headerText = accuracyData.label;
         this.myAccuracyBar.setData(accuracyData);
         this.myTimeBar.headerText = DictCoopSummary.TIME_LABEL;
         this.myTimeBar.setData(timeData,FsgSingleStatBar.TIME_STAT_TYPE);
         this.myCustomBar.headerText = targetsData.label;
         this.myCustomBar.setData(targetsData);
         addFrameScript(2,this.playTransitionSwoop());
         addFrameScript(15,this.playTransitionSwoop());
         addFrameScript(30,this.playTransitionSwoop());
      }
      
      private function playTransitionSwoop() : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_ONBOARD_TRAINING_COMPLETE_STAT_TRANSITION);
      }
      
      public function get total() : int
      {
         return this.myAccuracyBar.finalScore + this.myTimeBar.finalScore + this.myCustomBar.finalScore;
      }
      
      public function start() : void
      {
         gotoAndPlay(1);
         addEventListener(Event.ENTER_FRAME,this._startStatAnim);
         this.myAccuracyBar.start();
      }
      
      public function set onCompleteCallback(func:Function) : void
      {
         this.m_onCompleteCallback = func;
      }
      
      private function _startStatAnim(event:Event) : void
      {
         if(currentFrame == 15)
         {
            this.myTimeBar.start();
         }
         if(currentFrame == 30)
         {
            this.myCustomBar.start();
         }
         if(currentFrame == 42)
         {
            removeEventListener(Event.ENTER_FRAME,this._startStatAnim);
            if(this.m_onCompleteCallback != null)
            {
               this.m_onCompleteCallback(this.total);
            }
         }
      }
   }
}

