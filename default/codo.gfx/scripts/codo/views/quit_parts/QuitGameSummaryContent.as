package codo.views.quit_parts
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.constants.BCCommonEvent;
   import codo.localization.DictCareer;
   import codo.localization.DictSummary;
   import codo.objects.EXPLevelObj;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.ProductObj;
   import codo.objects.SummaryObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.StringUtil;
   import com.society.comscore.DAXDispatcher;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import fsg.util.FsgUtil;
   
   public class QuitGameSummaryContent extends BaseSubElement
   {
      
      private static const FLOOR:Function = Math.floor;
      
      private static const ADD_ZERO:Function = StringUtil.addZero;
      
      private static const HOURS_PER_DAY:int = 24;
      
      private static const MINS_SECS:int = 60;
      
      public var myTitleTF:TextField;
      
      public var myQuitBtn:CallToActionButton;
      
      public var myReturnBtn:Button;
      
      public var myStatXP:QuitGameSummaryStat;
      
      public var myStatGP:QuitGameSummaryStat;
      
      public var myStatTimePlayed:QuitGameSummaryStat;
      
      public var myBkg:Sprite;
      
      public var myCareerProgressPanel:QuitGameSummaryProgressBar;
      
      public var myNextSupplyDrop:QuitGameSummaryContentNextDrop;
      
      public var myNextLoginReward:QuitGameSummaryContentNextLoginReward;
      
      public function QuitGameSummaryContent()
      {
         var test:SummaryObj = null;
         var tstData1:EXPLevelObj = null;
         var tstData2:EXPLevelObj = null;
         super();
         var glow:GlowFilter = new GlowFilter(806783,0.5,15,15);
         var LOCALIZE:Function = LocalizeUtil.localize;
         var BTN_PADDING:int = 40;
         this.myTitleTF.text = isDebugMode ? "SUMMARY" : LOCALIZE(DictSummary.SUMMARY_TITLE);
         this.myTitleTF.filters = [glow];
         this.myTitleTF.font = GlobalGuide.FONT_FACE_BOLD;
         this.myTitleTF.fontSize = 60;
         this.myTitleTF.width = this.myBkg.width;
         this.myTitleTF.height = 70;
         this.myQuitBtn.label = isDebugMode ? "QUIT" : LOCALIZE(DictSummary.SUMMARY_QUIT_GAME);
         this.myReturnBtn.label = isDebugMode ? "RETURN TO GAME" : LOCALIZE(DictSummary.SUMMARY_BACK_TO_GAME);
         this.myQuitBtn.width = this.myQuitBtn.myLabel.textWidth + BTN_PADDING;
         this.myReturnBtn.width = this.myReturnBtn.myLabel.textWidth + BTN_PADDING;
         this.myReturnBtn.x = this.myBkg.x + (this.myBkg.width - this.myReturnBtn.width);
         this.myQuitBtn.x = this.myReturnBtn.x - (this.myQuitBtn.width + 5);
         this.myQuitBtn.registerClickEvent(this.onQuit);
         this.myReturnBtn.registerClickEvent(this.onBack);
         if(isDebugMode)
         {
            test = new SummaryObj();
            tstData1 = new EXPLevelObj();
            tstData2 = new EXPLevelObj();
            tstData1.current = 3999;
            tstData1.total = 4000;
            tstData1.displayRank = 23;
            tstData2.current = 4300;
            tstData2.total = 4500;
            tstData2.displayRank = 24;
            test.timePlayed = 16308;
            test.gpGained = 2323;
            test.xpGained = 34344;
            test.levelIncrease = new <EXPLevelObj>[tstData1,tstData2];
            this.summaryData = test;
         }
      }
      
      private static function comScoreReport(action:String, value:String, doDispath:Boolean) : void
      {
         try
         {
            Logger.print("*** DAXDispatcher: action type =" + value);
            DAXDispatcher.queue(action,value);
            if(doDispath == true)
            {
               DAXDispatcher.dispatch();
               DAXDispatcher.dispatchScreens("critical_event");
            }
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.myNextLoginReward.deactive();
         this.myNextSupplyDrop.deactive();
      }
      
      public function setNextSupplyDropReward(prod:ProductObj, reward:MOTDCheckinRewardObj) : void
      {
         var rewardAvailable:Boolean = prod != null;
         if(rewardAvailable)
         {
            this.myNextLoginReward.setRewardData(prod,reward);
         }
         this.myNextLoginReward.rewardAvailabllity = rewardAvailable;
      }
      
      public function set summaryData(data:SummaryObj) : void
      {
         var timeVal:String = null;
         var RANK_DATA_INVALID_FOR_INCONSIST_VERSION:int = -1;
         var timeLabel:String = isDebugMode ? "TIME PLAYED" : DictCareer.CAREER_TIMEPLAYED;
         var XPLabel:String = isDebugMode ? "XP EARNED" : DictCareer.CAREER_SUMMARY_XP_EARNED;
         var GPLabel:String = isDebugMode ? "GP EARNED" : DictCareer.CAREER_SUMMARY_GP_EARNED;
         var timePlayed:Number = data.timePlayed;
         var minute:Number = FLOOR(timePlayed / MINS_SECS);
         var hours:Number = FLOOR(minute / MINS_SECS);
         var seconds:Number = FLOOR(timePlayed % MINS_SECS);
         minute %= MINS_SECS;
         hours %= HOURS_PER_DAY;
         timeVal = ADD_ZERO(hours).concat(":",ADD_ZERO(minute),":",ADD_ZERO(seconds));
         this.myStatGP.setContent(GPLabel,FsgUtil.commaFormatNumber(data.gpGained),QuitGameSummaryStat.FRAME_GP);
         this.myStatTimePlayed.setContent(timeLabel,timeVal);
         if(data.xpGained != RANK_DATA_INVALID_FOR_INCONSIST_VERSION)
         {
            this.myStatXP.setContent(XPLabel,FsgUtil.commaFormatNumber(data.xpGained),QuitGameSummaryStat.FRAME_XP);
            this.myCareerProgressPanel.data = data.levelIncrease;
         }
         else
         {
            this.myCareerProgressPanel.setDataInvalid();
            this.myStatXP.setContent(XPLabel,"-",QuitGameSummaryStat.FRAME_XP);
         }
         this.myStatGP.x = this.myStatXP.x + this.myStatXP.width + 40;
         this.myStatTimePlayed.x = this.myBkg.x + (this.myBkg.width - (this.myStatTimePlayed.width + 38));
         this.myNextSupplyDrop.active();
         this.myNextLoginReward.active();
      }
      
      override protected function onInitListener() : void
      {
         this.myCareerProgressPanel.initBarAnimListeners();
      }
      
      private function onQuit() : void
      {
         Logger.print("*** DAXDispatcher: onQuit Button Pressed");
         comScoreReport("action_type","game_exit",true);
         broadcast(BCCommonEvent.EVT_QUIT_GAME);
      }
      
      private function onBack() : void
      {
         comScoreReport("action_type","return_offer",true);
         broadcast(BCCommonEvent.EVT_CLOSE_SUMMARY);
      }
   }
}

