package codo.component.social
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.localization.DictClan;
   import codo.style.ClanGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ClaimBuffButton extends MovieClip
   {
      
      public static const GP_BUFF:int = 1;
      
      public static const XP_BUFF:int = 2;
      
      public var myIcon:MovieClip;
      
      public var myLabel:TextField;
      
      public var myRemainLabel:TextField;
      
      public var myButton:Button;
      
      public var mClickCallback:Function;
      
      private var mSecondLeft:int;
      
      private var mTimer:Timer;
      
      public function ClaimBuffButton()
      {
         super();
         this.myButton.width = 148;
         this.myButton.height = 23;
         this.myButton.label = DictClan.CLAIM;
         this.myLabel.textStyle = ClanGuide.styleClaimButtonLabel;
         this.myRemainLabel.textStyle = ClanGuide.styleClaimRemainLabel;
         this.myRemainLabel.width = 148;
         this.myButton.registerClickEvent(this.onClaimButtonClicked);
         this.mTimer = new Timer(1000,0);
      }
      
      public function registerClickCallback(callback:Function) : void
      {
         this.mClickCallback = callback;
      }
      
      public function setReward(type:int, label:String) : void
      {
         this.myIcon.gotoAndStop(type);
         this.myLabel.text = label;
      }
      
      public function setClaimRemainingTime(second:int) : void
      {
         this.mSecondLeft = second;
         this.setClaimRemainingTimeInternal(this.mSecondLeft);
         if(this.mSecondLeft > 0)
         {
            this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimerTicked);
            this.mTimer.start();
         }
         else
         {
            this.mTimer.stop();
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.onTimerTicked);
         }
      }
      
      private function onTimerTicked(e:TimerEvent) : void
      {
         --this.mSecondLeft;
         if(this.mSecondLeft < 0)
         {
            this.mSecondLeft = 0;
            this.mTimer.stop();
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.onTimerTicked);
         }
         this.setClaimRemainingTimeInternal(this.mSecondLeft);
      }
      
      private function setClaimRemainingTimeInternal(second:int) : void
      {
         var hourRemain:int = 0;
         var minRemain:int = 0;
         var secRemain:int = 0;
         if(second > 0)
         {
            this.myButton.visible = false;
            this.myRemainLabel.visible = true;
            hourRemain = Math.floor(second / 3600);
            minRemain = Math.floor((second - hourRemain * 3600) / 60);
            secRemain = second % 60;
            if(hourRemain > 0)
            {
               this.myRemainLabel.text = LocalizeUtil.param(DictClan.CLAIM_REMAIN_HOUR,[hourRemain,minRemain]);
            }
            else
            {
               this.myRemainLabel.text = LocalizeUtil.param(DictClan.CLAIM_REMAIN_MIN,[minRemain,secRemain]);
            }
         }
         else
         {
            this.myButton.enabled = true;
            this.myButton.visible = true;
            this.myRemainLabel.visible = false;
         }
      }
      
      private function onClaimButtonClicked() : void
      {
         if(null != this.mClickCallback)
         {
            this.myButton.enabled = false;
            this.mClickCallback();
         }
      }
   }
}

