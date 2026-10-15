package components.fsgmatchresult_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.aar.MatchResultsProgressArrowDisplay;
   import codo.localization.Dict;
   import codo.objects.AARProgressLevelObj;
   import codo.objects.AARProgressObj;
   import codo.objects.PlayerObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgAudioUtil;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgMatchResultRankBar extends MovieClip
   {
      
      private static const ARROW_FADE_DURATION:Number = 0.4;
      
      private static const DEFAULT_ANIMATION_SPEED:Number = 4.1;
      
      private static const FILL_COLOR_PRESTIGE:String = "prestige";
      
      public var myTextContainer:MovieClip;
      
      public var myPrimaryFillMask:MovieClip;
      
      public var myBonusFillMask:MovieClip;
      
      public var myFillBG:MovieClip;
      
      public var myFill:MovieClip;
      
      public var myArrow:MatchResultsProgressArrowDisplay;
      
      public var myBonusArrow:MovieClip;
      
      public var myCurrentRank:TextField;
      
      public var myNextRank:TextField;
      
      public var myNextRankLabel:TextField;
      
      public var myCurrentRankLabel:TextField;
      
      public var myPrestigeIcon:FsgImageHolder;
      
      public var myNextPrestigeIcon:FsgImageHolder;
      
      public var myMaxLevelText:MovieClip;
      
      private var mCurrentAnimTarget:int;
      
      private var mProgressData:AARProgressObj;
      
      private var mFillTween:TweenLite;
      
      private var mFillMask:MovieClip;
      
      private var mNumFills:Number;
      
      private var mNumBonusFills:Number;
      
      private var mFirstBonusAnim:Boolean = true;
      
      private var mPlaySound:Boolean = true;
      
      private var mXPLabels:Vector.<AARProgressLevelObj>;
      
      private var mBonusAnimationCallback:Function;
      
      private var mLevelUpCallback:Function = null;
      
      private var mAnimateCompleteCallback:Function = null;
      
      private var mPrestigedIndex:Number;
      
      private var mPrestigeLevel:Number;
      
      private var mLevelledUp:Boolean;
      
      private var mAnimationSpeed:Number;
      
      private var mBonusAnimationSpeed:Number;
      
      private var mIsPlayerMaxedOut:Boolean = false;
      
      private var mOnboardingEnabled:Boolean = false;
      
      private var mFillBaseWidth:uint;
      
      private var mBarMidPoint:int;
      
      public function FsgMatchResultRankBar()
      {
         super();
         this.myCurrentRank = this.myTextContainer["myCurrentRank"];
         this.myNextRank = this.myTextContainer["myNextRank"];
         this.myNextRankLabel = this.myTextContainer["myNextRankLabel"];
         this.myCurrentRankLabel = this.myTextContainer["myCurrentRankLabel"];
         this.mFillMask = this.myPrimaryFillMask;
         this.mFillBaseWidth = this.myPrimaryFillMask.width;
         this.mFillMask.width = 0;
         this.myBonusFillMask.width = 0;
         this.myArrow.alpha = 0;
         this.myBonusArrow.alpha = 0;
         this.myBonusArrow.visible = false;
         var maxLevelText:TextField = this.myMaxLevelText.getChildByName("myMaxLevelTF") as TextField;
         TextFieldEx.setVerticalAlign(maxLevelText,TextFieldEx.VALIGN_CENTER);
         maxLevelText.text = Dict.PLAYER_LEVEL_MAX;
         this.myMaxLevelText.visible = false;
         this.mBarMidPoint = this.mFillMask.x + this.mFillMask.width * 0.5;
      }
      
      public function onboardingEnabled(b:Boolean) : void
      {
         this.mOnboardingEnabled = b;
      }
      
      public function allowPlaySound(play:Boolean) : void
      {
         this.mPlaySound = play;
      }
      
      public function setBonusAnimationCallback(callback:Function) : void
      {
         this.mBonusAnimationCallback = callback;
      }
      
      public function setLevelUpCallback(func:Function) : void
      {
         this.mLevelUpCallback = func;
      }
      
      public function setAnimationCompleteCallback(func:Function) : void
      {
         this.mAnimateCompleteCallback = func;
      }
      
      public function setData(progressData:AARProgressObj) : void
      {
         this.mProgressData = progressData;
         this.mNumBonusFills = this.mProgressData.bonusEndPercent;
         this.mNumFills = this.mProgressData.normalEndPercent;
         this.mXPLabels = this.mProgressData.expLabels;
         this.mPrestigedIndex = this.mProgressData.prestigedIndex;
         this.mPrestigeLevel = this.mProgressData.prestige;
         this.mAnimationSpeed = DEFAULT_ANIMATION_SPEED / Math.ceil(this.mNumFills);
         this.mBonusAnimationSpeed = DEFAULT_ANIMATION_SPEED / Math.ceil(this.mNumBonusFills);
         this.mCurrentAnimTarget = 0;
         this.setupLabels();
         this.setProgress(this.mProgressData.startPercent);
      }
      
      public function startAnimation() : void
      {
         if(this.mPlaySound)
         {
            FsgAudioUtil.getInstance().playSound("ui_combat_exp_bonus_open");
         }
         this.gotoAndPlay(2);
         TweenLite.to(this.myBonusArrow,ARROW_FADE_DURATION,{
            "alpha":1,
            "onComplete":this.onArrowFadeComplete
         });
         this.runNextAnimTarget(true);
      }
      
      public function skipAnimation() : void
      {
         FsgAudioUtil.getInstance().stopSound();
         this.allowPlaySound(false);
      }
      
      private function onArrowFadeComplete() : void
      {
         if(this.mPlaySound)
         {
            FsgAudioUtil.getInstance().playSound("ui_exp_fill_lp");
         }
      }
      
      public function setProgress(progress:Number) : void
      {
         var playerObj:PlayerObj = null;
         var rank:String = null;
         var iRank:int = 0;
         var prestige:int = 0;
         var xpMin:int = 0;
         var xpMax:int = 0;
         var xpCurrent:int = 0;
         this.mFillMask.width = this.myFillBG.width * progress;
         this.myBonusArrow.x = this.myBonusFillMask.x + this.myBonusFillMask.width;
         if(ScaleformUtil.isScaleform)
         {
            playerObj = PlayerObj.getObj();
            rank = playerObj.careerData.currentLevel;
            iRank = parseInt(rank);
            prestige = int(playerObj.careerData.prestige);
            xpMin = CFunctionCommonContainer.GetXpForRank(iRank - 1,prestige);
            xpMax = CFunctionCommonContainer.GetTargetXpForRank(iRank - 1,prestige);
            xpCurrent = CFunctionCommonContainer.GetPlayerXP();
            this.myArrow.setProgressValDisplay(xpCurrent - xpMin,xpMax - xpMin,"XP");
         }
      }
      
      private function runNextAnimTarget(isStart:Boolean) : void
      {
         var ease:Function = null;
         if(this.mNumFills >= 1)
         {
            ease = isStart ? Cubic.easeIn : Linear.easeNone;
            this.animateBar(this.myFillBG.width,this.mNumFills != 1 ? ease : Cubic.easeInOut);
            this.mNumFills -= 1;
            ++this.mCurrentAnimTarget;
            this.mLevelledUp = true;
         }
         else
         {
            this.animateBar(this.myFillBG.width * this.mNumFills,isStart ? Cubic.easeInOut : Cubic.easeOut);
            this.mNumFills -= 1;
         }
      }
      
      private function animateBar(targetWidth:Number, ease:Function) : void
      {
         if(this.mIsPlayerMaxedOut)
         {
            return;
         }
         this.mFillTween = new TweenLite(this.mFillMask,targetWidth != 0 ? this.mAnimationSpeed : 0.1,{
            "width":targetWidth,
            "onUpdate":this.onFillTweenUpdate,
            "onComplete":this.onFillTweenComplete,
            "ease":ease
         });
      }
      
      private function runNextBonusAnimTarget(isStart:Boolean) : void
      {
         var targetWidth:Number = this.myFillBG.width;
         if(this.mNumBonusFills > 1)
         {
            this.mFillTween = new TweenLite(this.myBonusFillMask,this.mBonusAnimationSpeed,{
               "width":targetWidth,
               "onUpdate":this.onFillTweenUpdate,
               "onComplete":this.onFillTweenComplete,
               "ease":(isStart ? Cubic.easeIn : Linear.easeNone)
            });
            this.mNumBonusFills -= 1;
            ++this.mCurrentAnimTarget;
            this.mLevelledUp = true;
         }
         else
         {
            targetWidth = this.myFillBG.width * this.mNumBonusFills;
            this.mFillTween = new TweenLite(this.myBonusFillMask,this.mBonusAnimationSpeed,{
               "width":targetWidth,
               "onUpdate":this.onFillTweenUpdate,
               "onComplete":this.onFillTweenComplete,
               "ease":(isStart ? Cubic.easeInOut : Cubic.easeOut)
            });
            this.mNumBonusFills -= 1;
         }
      }
      
      private function setupLabels() : void
      {
         var nextLabelObj:AARProgressLevelObj = null;
         if(!ScaleformUtil.isScaleform)
         {
            return;
         }
         var currentLabelObj:AARProgressLevelObj = this.mXPLabels[this.mCurrentAnimTarget];
         this.myCurrentRank.text = currentLabelObj.displayLevel;
         this.myCurrentRankLabel.text = LocalizeUtil.localize(currentLabelObj.fullLabel);
         if(currentLabelObj.isMaxRank && this.mPrestigedIndex < 0)
         {
            this.myNextRank.text = "--";
            this.myNextRankLabel.text = " ";
            this.mNumBonusFills = 0;
            this.myMaxLevelText.visible = true;
            this.myMaxLevelText.alpha = 0;
            TweenLite.to(this.myMaxLevelText,0.3,{
               "delay":0.5,
               "alpha":1
            });
            this.myBonusArrow.visible = false;
            this.myPrimaryFillMask.width = this.mFillBaseWidth;
            this.animateBar(this.mFillBaseWidth,Cubic.easeInOut);
            this.mIsPlayerMaxedOut = true;
         }
         else
         {
            nextLabelObj = this.mXPLabels[this.mCurrentAnimTarget + 1];
            this.myNextRank.text = nextLabelObj.displayLevel;
            this.myNextRankLabel.text = LocalizeUtil.localize(nextLabelObj.fullLabel);
            this.myMaxLevelText.visible = false;
            this.myBonusArrow.visible = true;
            this.mIsPlayerMaxedOut = false;
         }
         var currentPrestigeLevel:int = 0;
         if(this.mPrestigeLevel > 0)
         {
            if(this.mPrestigedIndex > 0)
            {
               currentPrestigeLevel = this.mPrestigedIndex > this.mCurrentAnimTarget ? int(this.mPrestigeLevel - 1) : int(this.mPrestigeLevel);
            }
            else
            {
               currentPrestigeLevel = this.mPrestigeLevel;
            }
         }
         if(currentPrestigeLevel > 0)
         {
            this.myPrestigeIcon.visible = true;
            this.myPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(currentPrestigeLevel));
            this.myFill.myColor.gotoAndStop(FILL_COLOR_PRESTIGE);
         }
         else
         {
            this.myPrestigeIcon.visible = false;
         }
         var nextPrestigeLevel:int = 0;
         if(this.mPrestigedIndex > 0)
         {
            nextPrestigeLevel = this.mPrestigedIndex > this.mCurrentAnimTarget + 1 ? int(this.mPrestigeLevel - 1) : int(this.mPrestigeLevel);
         }
         else if(currentLabelObj.displayLevel == CFunctionCommonContainer.GetPlayerMaxLevel().toString())
         {
            nextPrestigeLevel = this.mPrestigeLevel != CFunctionCommonContainer.GetPlayerMaxPrestige() ? int(this.mPrestigeLevel + 1) : int(this.mPrestigeLevel);
         }
         else if(this.mPrestigeLevel > 0)
         {
            nextPrestigeLevel = this.mPrestigeLevel;
         }
         if(nextPrestigeLevel > 0)
         {
            this.myNextPrestigeIcon.visible = true;
            this.myNextPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(nextPrestigeLevel));
         }
         else
         {
            this.myNextPrestigeIcon.visible = false;
         }
      }
      
      private function onFillTweenComplete() : void
      {
         var startPoint:Number = NaN;
         if(this.mAnimateCompleteCallback != null)
         {
            this.mAnimateCompleteCallback(this.mLevelledUp);
         }
         if(this.mLevelledUp)
         {
            if(null != this.mLevelUpCallback)
            {
               this.mLevelUpCallback();
            }
            this.mLevelledUp = false;
         }
         this.setupLabels();
         if(this.mNumFills >= 0)
         {
            this.mFillMask.width = 0;
            this.runNextAnimTarget(false);
         }
         else if(this.mOnboardingEnabled)
         {
            if(this.mPlaySound)
            {
               FsgAudioUtil.getInstance().playSound("ui_exp_fill_stop");
            }
            this.showArrow();
         }
         else if(this.mNumBonusFills > 0)
         {
            if(this.mFirstBonusAnim)
            {
               startPoint = this.mNumFills;
               if(startPoint < 0)
               {
                  startPoint += 1;
               }
               startPoint = this.myFillBG.width * startPoint;
               this.myPrimaryFillMask.width = startPoint;
               this.myBonusFillMask.width = startPoint;
               this.myBonusArrow.x = this.myBonusFillMask.x + this.myBonusFillMask.width;
               this.mFirstBonusAnim = false;
               if(null != this.mBonusAnimationCallback)
               {
                  this.mBonusAnimationCallback();
               }
               this.runNextBonusAnimTarget(true);
            }
            else
            {
               this.myArrow.visible = false;
               this.myBonusFillMask.width = 0;
               this.myPrimaryFillMask.width = 0;
               this.runNextBonusAnimTarget(false);
            }
         }
         else
         {
            if(this.mPlaySound)
            {
               FsgAudioUtil.getInstance().playSound("ui_exp_fill_stop");
            }
            this.showArrow();
         }
      }
      
      private function showArrow() : void
      {
         this.myArrow.x = this.mFillMask.x + this.mFillMask.width;
         if(this.myArrow.x <= this.mBarMidPoint)
         {
            this.myArrow.orientLeft();
         }
         TweenLite.to(this.myArrow,ARROW_FADE_DURATION,{"alpha":1});
      }
      
      private function onFillTweenUpdate() : void
      {
         this.myArrow.x = this.myPrimaryFillMask.x + this.myPrimaryFillMask.width;
         this.myBonusArrow.x = this.myBonusFillMask.x + this.myBonusFillMask.width;
      }
      
      public function getCurrentLevel() : int
      {
         return this.mXPLabels[this.mCurrentAnimTarget].rank;
      }
   }
}

