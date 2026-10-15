package codo.views.onboarding_parts
{
   import codo.base.BaseSubElement;
   import codo.component.CallToActionButton;
   import codo.component.LoadingSpinner;
   import codo.component.TextField;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.setTimeout;
   
   public class ClaimOnboardingRewardContent extends BaseSubElement
   {
      
      private static const LOCALIZE:Function = LocalizeUtil.localize;
      
      private static const CARD_STACK_OFFSET:int = 132;
      
      private static const ANIM_SPEED:Number = 0.2;
      
      public var myTitleTF:TextField;
      
      public var myBkg:Sprite;
      
      public var myLoadingSpinner:LoadingSpinner;
      
      public var myLoadingOverlay:Sprite;
      
      public var myFailMsgTF:TextField;
      
      public var myCloseBtn:CallToActionButton;
      
      public var myFailMsgIcon:Sprite;
      
      public var myGPDisplay:Sprite;
      
      public var myRewardItemHolder:Sprite;
      
      private var mGPValue:TextField;
      
      private var mCards:Vector.<ClaimOnboardingRewardItem>;
      
      private var mGlower:GlowFilter;
      
      private var mNumRewards:int = 0;
      
      private var mAnimIndex:int = 0;
      
      private var mRewardItems:Vector.<ProductObj>;
      
      private var mAnimateOutCallback:Function;
      
      private var mAnimatedInCallback:Function;
      
      public function ClaimOnboardingRewardContent()
      {
         super();
         var glow:GlowFilter = new GlowFilter(806783,0.5,15,15);
         this.mGlower = new GlowFilter(41981,0.5,40,40);
         this.myTitleTF.filters = [glow];
         this.myTitleTF.font = GlobalGuide.FONT_FACE_BOLD;
         this.myTitleTF.fontSize = 60;
         var txtStyle:TextStyle = GlobalGuide.styleTextDescription;
         txtStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         txtStyle.alignment = TextStyle.HALIGN_CENTER;
         txtStyle.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myFailMsgTF.width = 360;
         this.myFailMsgTF.height = 250;
         this.myFailMsgTF.x = this.myLoadingOverlay.x + (this.myLoadingOverlay.width - this.myFailMsgTF.width) * 0.5;
         this.myFailMsgTF.text = isDebugMode ? "An error occurred while attempting to claim your reward.  Click CLOSE and try to claim your reward again shortly." : LOCALIZE("@SF_UI_CLAIM_REWARD_FAIL_DESCRIPTION");
         this.myFailMsgTF.textStyle = txtStyle;
         this.myFailMsgTF.visible = this.myFailMsgIcon.visible = false;
         txtStyle = GlobalGuide.styleNumericTextSmall;
         txtStyle.fontSize = 86;
         txtStyle.autoSize = TextFieldAutoSize.NONE;
         txtStyle.alignment = TextStyle.HALIGN_CENTER;
         this.mGPValue = this.myGPDisplay.getChildByName("myValueTF") as TextField;
         this.mGPValue.textStyle = txtStyle;
         this.mGPValue.width = this.myGPDisplay.width;
         this.mGPValue.height = 110;
         this.myGPDisplay.visible = this.myRewardItemHolder.visible = false;
         this.myTitleTF.width = this.myBkg.width;
         this.myTitleTF.height = 70;
         this.myCloseBtn.label = isDebugMode ? "CLOSE" : LOCALIZE("@SF_UI_CLOSE_LOADOUT");
         this.myCloseBtn.x = this.myBkg.x + (this.myBkg.width - this.myCloseBtn.width);
      }
      
      public function set animatedInCallback(callback:Function) : void
      {
         this.mAnimatedInCallback = callback;
      }
      
      public function set animatedOutCallback(callback:Function) : void
      {
         this.mAnimateOutCallback = callback;
      }
      
      override public function active() : void
      {
         super.active();
         this.myTitleTF.text = isDebugMode ? "CLAIMING REWARD..." : LOCALIZE("@SF_UI_CLAIM_REWARD_IN_PROGRESS");
         this.resetAssets();
         playSound("ui_rewardclaim_clicked_01");
      }
      
      public function resetAssets() : void
      {
         var reward:ClaimOnboardingRewardItem = null;
         var prevReward:Sprite = null;
         var isGPDisplay:Boolean = false;
         var i:int = 0;
         var listHeight:int = 0;
         isGPDisplay = this.mNumRewards == 0;
         var OFFSET_Y:int = 153;
         this.myLoadingOverlay.alpha = 0.8;
         this.myLoadingSpinner.alpha = 1;
         this.myGPDisplay.visible = isGPDisplay;
         this.myRewardItemHolder.visible = !isGPDisplay;
         this.myGPDisplay.alpha = 1;
         this.myGPDisplay.scaleX = this.myGPDisplay.scaleY = 1;
         this.myCloseBtn.filters = [];
         this.myCloseBtn.enabled = false;
         this.myCloseBtn.visible = false;
         while(this.myRewardItemHolder.numChildren > 0)
         {
            this.myRewardItemHolder.removeChildAt(0);
         }
         for(this.mCards = new Vector.<ClaimOnboardingRewardItem>(0); i < this.mNumRewards; )
         {
            reward = this.myRewardItemHolder.addChild(new claimOnboardingRewardItem()) as ClaimOnboardingRewardItem;
            this.myRewardItemHolder.setChildIndex(reward,0);
            reward.myCard.setCardStyle(3,false);
            reward.myCard.withDiscountTag = false;
            if(!isDebugMode)
            {
               reward.myCard.setData(this.mRewardItems[i]);
               reward.myCard.withOwnStateHint = false;
            }
            listHeight += reward.myOverlay.height;
            if(i > 0)
            {
               prevReward = this.mCards[i - 1];
               if(i == 1)
               {
                  reward.myOverlay.alpha = 0.4;
               }
               else
               {
                  reward.myOverlay.alpha = 0.7;
               }
               reward.y = prevReward.y + (reward.myOverlay.height - OFFSET_Y);
               listHeight -= reward.myOverlay.height - CARD_STACK_OFFSET;
            }
            else
            {
               reward.myOverlay.alpha = 0;
            }
            this.mCards[i] = reward;
            i++;
         }
         this.myLoadingOverlay.height = isGPDisplay ? 276 : listHeight + 2;
         this.myLoadingSpinner.y = this.myLoadingOverlay.y + (this.myLoadingOverlay.height - this.myLoadingSpinner.height) * 0.5;
         this.myBkg.width = 660;
         this.myBkg.height = isGPDisplay ? 374 : listHeight + 80;
         setTimeout(this.mAnimatedInCallback,1000);
      }
      
      public function set gpValue(val:int) : void
      {
         this.mGPValue.text = val.toString();
      }
      
      public function set data(prodObjs:Vector.<ProductObj>) : void
      {
         this.mRewardItems = prodObjs;
         this.mNumRewards = prodObjs.length;
      }
      
      public function onClaimComplete(isSuccess:Boolean = true) : void
      {
         var targetCard:Sprite = null;
         this.myLoadingSpinner.alpha = 0;
         if(isSuccess)
         {
            this.myTitleTF.text = isDebugMode ? "CLAIM SUCCESS!" : LOCALIZE("@SF_UI_CLAIM_REWARD_SUCCESS");
            targetCard = this.mNumRewards == 0 ? this.myGPDisplay : this.mCards[0];
            TweenMax.to(targetCard,ANIM_SPEED,{
               "glowFilter":this.mGlower,
               "yoyo":true,
               "repeat":6,
               "onStart":this.playClaim,
               "onComplete":this.initAnimateOut
            });
            this.myLoadingOverlay.alpha = 0;
         }
         else
         {
            this.myTitleTF.text = isDebugMode ? "CLAIM FAILED..." : LOCALIZE("@SF_UI_CLAIM_REWARD_IN_PROGRESS");
            this.myCloseBtn.y = this.myBkg.y + this.myBkg.height + 20;
            this.myCloseBtn.enabled = true;
            this.myCloseBtn.visible = true;
            this.myFailMsgTF.visible = this.myFailMsgIcon.visible = true;
            this.myCloseBtn.registerClickEvent(this.mAnimateOutCallback);
         }
      }
      
      private function initAnimateOut() : void
      {
         var isGPDisplay:Boolean = this.mNumRewards == 0;
         var targetCard:Sprite = isGPDisplay ? this.myGPDisplay : this.mCards[0];
         TweenLite.to(targetCard,ANIM_SPEED,{
            "scaleY":1.2,
            "scaleX":1.2,
            "alpha":0,
            "ease":Back.easeIn,
            "onComplete":(this.mNumRewards == 0 ? this.deactive : this.initAdditionalAnimateOut),
            "delay":0.2
         });
      }
      
      private function initAdditionalAnimateOut() : void
      {
         ++this.mAnimIndex;
         var tmMax:TimelineMax = new TimelineMax();
         if(this.mAnimIndex == this.mNumRewards)
         {
            this.deactive();
            return;
         }
         var targetHeight:int = this.myBkg.height - CARD_STACK_OFFSET;
         var isLastItem:Boolean = this.mAnimIndex + 1 == this.mNumRewards;
         TweenLite.to(this.mCards[this.mAnimIndex].myOverlay,ANIM_SPEED,{
            "alpha":0,
            "ease":Linear.easeOut,
            "delay":0.2
         });
         if(!isLastItem)
         {
            TweenLite.to(this.mCards[this.mAnimIndex + 1],ANIM_SPEED,{
               "y":this.mCards[this.mAnimIndex].y,
               "ease":Linear.easeOut,
               "delay":0.1
            });
         }
         TweenLite.to(this.myBkg,ANIM_SPEED,{
            "height":targetHeight,
            "ease":Back.easeIn,
            "delay":0.1
         });
         tmMax.append(new TweenLite(this.mCards[this.mAnimIndex],ANIM_SPEED,{"y":this.mCards[0].y}));
         tmMax.append(new TweenMax(this.mCards[this.mAnimIndex],ANIM_SPEED,{
            "glowFilter":this.mGlower,
            "yoyo":true,
            "repeat":6,
            "onStart":this.playClaim,
            "onComplete":this.initAdditionalAnimateOut
         }));
         tmMax.append(new TweenLite(this.mCards[this.mAnimIndex],ANIM_SPEED,{
            "scaleY":1.2,
            "scaleX":1.2,
            "alpha":0,
            "ease":Back.easeIn
         }));
         tmMax.play();
      }
      
      private function playClaim() : void
      {
         playSound("ui_rewardclaim_glow_01");
      }
      
      override public function deactive() : void
      {
         if(Boolean(this.mCards))
         {
            this.mCards.length = 0;
         }
         TweenLite.to(this.myBkg,0.4,{
            "width":0,
            "ease":Back.easeIn,
            "onComplete":this.killContent
         });
         playSound("ui_rewardclaim_exited_01");
      }
      
      private function killContent() : void
      {
         this.mAnimIndex = this.mNumRewards = 0;
         this.myGPDisplay.filters = [];
         this.myCloseBtn.y = this.myBkg.y + this.myBkg.height + 20;
         this.mAnimateOutCallback();
      }
   }
}

