package codo.views.hudSpy
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.CallToActionButton;
   import codo.component.ContentContainer;
   import codo.localization.DictHud;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class KarmaPunishmentHint extends MovieClip
   {
      
      private static const CONTAINER_HEIGHT:int = 614;
      
      private static const CONTAINER_WIDTH:int = 550;
      
      private static const BUTTON_CLOSE_TIMER_TICK:int = 1000;
      
      private static const CLOSE_ENABLE_DELAY:int = 5;
      
      public var myContainer:ContentContainer;
      
      public var myHeader:TextField;
      
      public var myTitle:TextField;
      
      public var myDesc:TextField;
      
      public var myPunish1:TextField;
      
      public var myPunish2:TextField;
      
      public var myPunish3:TextField;
      
      public var myPunishDesc1:TextField;
      
      public var myPunishDesc2:TextField;
      
      public var myPunishDesc3:TextField;
      
      public var myTip:TextField;
      
      public var myOk:CallToActionButton;
      
      public var myBG:MovieClip;
      
      private var mTimer:Timer;
      
      private var mTimerCounter:int;
      
      public function KarmaPunishmentHint()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myContainer.myContainer.gotoAndStop(7);
         this.myContainer.width = CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myHeader.text = LocalizeUtil.localize(DictHud.SPY_DEATH_PUNISH);
         this.myTitle.text = LocalizeUtil.localize(DictHud.SPY_KILLED_BY_DEATH_PUNISH);
         this.myDesc.text = LocalizeUtil.localize(DictHud.SPY_ATTACK_ALLIES_CONSEQUENCE);
         this.myPunish1.text = LocalizeUtil.localize(DictHud.SPY_KARMA_DEATH_PUNISH);
         this.myPunishDesc1.text = LocalizeUtil.localize(DictHud.SPY_KARMA_DEATH_PUNISH_DESC);
         this.myPunish2.text = LocalizeUtil.localize(DictHud.SPY_KARMA_REPUTATION_PUNISH);
         this.myPunishDesc2.text = LocalizeUtil.localize(DictHud.SPY_KARMA_REPUTATION_PUNISH_DESC);
         this.myPunish3.text = LocalizeUtil.localize(DictHud.SPY_KARMA_KICK_PUNISH);
         this.myPunishDesc3.text = LocalizeUtil.localize(DictHud.SPY_KARMA_KICK_PUNISH_DESC);
         this.myTip.text = LocalizeUtil.localize(DictHud.SPY_KARMA_PUNISH_TIP);
         this.mTimer = new Timer(BUTTON_CLOSE_TIMER_TICK);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.myOk.registerClickEvent(this.onOkClick);
      }
      
      private function onTimerTick(evt:TimerEvent) : void
      {
         --this.mTimerCounter;
         if(this.mTimerCounter > 0)
         {
            this.myOk.label = LocalizeUtil.localize(DictHud.SPY_KARMA_PUNISH_CONFIRM_LABEL) + " [" + this.mTimerCounter.toString() + "]";
         }
         else
         {
            this.myOk.label = LocalizeUtil.localize(DictHud.SPY_KARMA_PUNISH_CONFIRM_LABEL);
            this.myOk.enabled = true;
            this.myOk.myBackground.gotoAndStop(1);
            this.mTimer.stop();
         }
      }
      
      private function onOkClick() : void
      {
         CFunctionInGameContainer.AS_SpyCloseKarmaPunishHint();
      }
      
      public function showKarmaPunishHint() : void
      {
         this.myOk.enabled = false;
         this.myOk.myBackground.gotoAndStop(3);
         this.myOk.label = LocalizeUtil.localize(DictHud.SPY_KARMA_PUNISH_CONFIRM_LABEL) + " [" + this.mTimerCounter.toString() + "]";
         this.mTimerCounter = CLOSE_ENABLE_DELAY;
         this.mTimer.reset();
         visible = true;
         this.mTimer.start();
      }
      
      public function hideKarmaPunishHint() : void
      {
         if(this.mTimer.running)
         {
            this.mTimer.stop();
         }
         visible = false;
      }
   }
}

