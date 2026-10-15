package components.fsgmatchresult_part
{
   import codo.localization.DictMatchResults;
   import codo.objects.AARProgressObj;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgAudioUtil;
   
   public class FsgCurrencyRewardBox extends MovieClip
   {
      
      public static const BOX_HEIGHT_SMALL:int = 80;
      
      private static const CURRENCY_LABEL_PADDING_X:int = 10;
      
      private static const TEXT_MARGIN:int = 10;
      
      private static const COUNT_DURATION:int = 1;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const TICK_SOUND_INTERVAL:Number = 20;
      
      private static const BONUS_COUNT_DELAY:Number = 0.15;
      
      public var myContainer:MovieClip;
      
      public var myBonusContainer:MovieClip;
      
      public var myGPIcon:MovieClip;
      
      public var myRewardValue:TextField;
      
      public var myBonusValue:TextField;
      
      public var myBonusLabel:TextField;
      
      public var mCurrentGP:Number = 0;
      
      public var mCurrentBonusGP:Number = 0;
      
      public var mTargetGP:Number = 0;
      
      public var mBonusTarget:Number = 0;
      
      public var mFrameHeight:Number = 0;
      
      private var mFrameWidth:Number = 0;
      
      private var mCounterSoundTick:int;
      
      private var mTransitionTimeline:TimelineLite;
      
      public function FsgCurrencyRewardBox()
      {
         super();
         this.myGPIcon = this.myContainer["myGPIcon"];
         this.myRewardValue = this.myContainer["myRewardValue"];
         this.myBonusContainer = this.myContainer["myBonusContainer"];
         this.myBonusValue = this.myBonusContainer["myBonusValue"];
         this.myBonusLabel = this.myBonusContainer["myBonusLabel"];
         this.myBonusValue.autoSize = this.myBonusLabel.autoSize = TextFieldAutoSize.RIGHT;
         this.myBonusLabel.text = LocalizeUtil.localize(DictMatchResults.BONUS_LABEL);
      }
      
      private static function onCounterAnimComplete() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_gpbonus_stop");
      }
      
      public function setData(data:AARProgressObj) : void
      {
         this.mCurrentGP = 0;
         this.mCurrentBonusGP = 0;
         this.mTargetGP = data.gainedGpValue - data.bonusGP;
         this.myBonusValue.text = String("+0");
         this.myBonusContainer.alpha = 0;
         this.myBonusContainer.visible = false;
         this.mBonusTarget = data.gainedGpValue;
         this.myRewardValue.visible = false;
         this.myRewardValue.text = String(this.mBonusTarget);
         this.mFrameHeight = BOX_HEIGHT_SMALL;
         this.mFrameWidth = TEXT_MARGIN * 2 + this.myRewardValue.textWidth + CURRENCY_LABEL_PADDING_X + this.myGPIcon.width;
         this.myRewardValue.text = String(this.mCurrentGP);
         this.myRewardValue.visible = true;
      }
      
      public function startAnimation() : void
      {
         this.myContainer.gotoAndPlay(2);
         FsgAudioUtil.getInstance().playSound("ui_gpbonus_start");
         this.mTransitionTimeline = new TimelineLite();
         alpha = 0;
         this.mTransitionTimeline.append(TweenLite.to(this,FADE_DURATION,{"alpha":1}));
         this.mTransitionTimeline.append(TweenLite.to(this,COUNT_DURATION,{
            "mCurrentGP":this.mTargetGP,
            "onUpdate":this.onCounterAnimUpdate,
            "onComplete":onCounterAnimComplete,
            "ease":Linear.easeNone
         }));
         if(this.mBonusTarget > this.mTargetGP)
         {
            this.myBonusContainer.visible = true;
            this.mTransitionTimeline.append(TweenLite.to(this.myBonusContainer,0.1,{"alpha":1}));
            this.mTransitionTimeline.append(TweenLite.to(this,COUNT_DURATION,{
               "delay":BONUS_COUNT_DELAY,
               "mCurrentBonusGP":this.mBonusTarget - this.mTargetGP,
               "onUpdate":this.onBonusCounterAnimUpdate,
               "onComplete":onCounterAnimComplete,
               "ease":Linear.easeNone
            }));
         }
      }
      
      public function skipAnimation() : void
      {
         if(null != this.mTransitionTimeline)
         {
            this.mTransitionTimeline.complete();
         }
         this.myRewardValue.text = String(Math.round(this.mTargetGP));
         if(this.mBonusTarget > this.mTargetGP)
         {
            this.myBonusContainer.alpha = 1;
         }
      }
      
      public function getWidth() : Number
      {
         return this.mFrameWidth;
      }
      
      public function getHeight() : Number
      {
         return this.mFrameHeight;
      }
      
      private function onBonusCounterAnimUpdate() : void
      {
         ++this.mCounterSoundTick;
         if(this.mCounterSoundTick > TICK_SOUND_INTERVAL)
         {
            this.mCounterSoundTick = 0;
            FsgAudioUtil.getInstance().playSound("ui_gpbonus_point");
         }
         this.myBonusValue.text = String("+" + Math.round(this.mCurrentBonusGP));
      }
      
      private function onCounterAnimUpdate() : void
      {
         ++this.mCounterSoundTick;
         if(this.mCounterSoundTick > TICK_SOUND_INTERVAL)
         {
            this.mCounterSoundTick = 0;
            FsgAudioUtil.getInstance().playSound("ui_gpbonus_point");
         }
         this.myRewardValue.text = String(Math.round(this.mCurrentGP));
      }
   }
}

