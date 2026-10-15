package codo.component.home
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.constants.BCEvent;
   import codo.constants.ItemType;
   import codo.localization.Dict;
   import codo.localization.DictChallenge;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.ComponentListener;
   import codo.objects.DailyChallengeObj;
   import codo.objects.MatchResultsChallengeObj;
   import codo.objects.ProductObj;
   import codo.objects.VetChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class HomeChallengeListItem extends UIInteractiveComponent
   {
      
      public static const STYLE_NORMAL:int = 1;
      
      public static const STYLE_SMALL:int = 2;
      
      public var myDataContainer:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myChallengeName:TextField;
      
      public var myChallengeDescription:TextField;
      
      public var myChallengeReward:TextField;
      
      public var myChallengeRewardItem:TextField;
      
      public var myDifficulty:TextField;
      
      public var myProgressFill:MovieClip;
      
      public var myGainFill:MovieClip;
      
      public var myProgressFillCap:MovieClip;
      
      public var myProgressBarBackground:Sprite;
      
      public var myIcon:FsgImageHolder;
      
      public var myChainModule:MovieClip;
      
      public var myCompleteModule:MovieClip;
      
      public var myCompleteLabel:TextField;
      
      public var myProgressCurrent:TextField;
      
      public var myFocusBackground:MovieClip;
      
      public var myDataShadow:MovieClip;
      
      public var myDataOverlay:MovieClip;
      
      public var myButtonContainer:MovieClip;
      
      public var myButtonShadow:Sprite;
      
      public var myButtonOverlay:Sprite;
      
      public var myRewardButton:Button;
      
      public var myPinButton:Button;
      
      public var myInstructions:TextField;
      
      public var myButtonInstructions:TextField;
      
      public var myButtonContainerHitArea:MovieClip;
      
      public var myButtonContainerFocus:MovieClip;
      
      public var myLock:IconLock;
      
      public var myScrim:Sprite;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mButtonOverlayShowing:Boolean = false;
      
      private var mFlashTimeline:TimelineLite;
      
      private var mChallenge:ChallengeBaseObj;
      
      private var mComponentListener:ComponentListener;
      
      private var mRewardItem:ProductObj;
      
      private var mStyle:int;
      
      private var mChallengeDifficulties:Array = ["@SF_UI_CHALLENGE_DIFFICULTY_EASY","@SF_UI_CHALLENGE_DIFFICULTY_MEDIUM","@SF_UI_CHALLENGE_DIFFICULTY_HARD"];
      
      public function HomeChallengeListItem()
      {
         super();
      }
      
      public function setupStyle(style:int) : void
      {
         this.mStyle = style;
         gotoAndStop(style);
         this.myDataContainer.gotoAndStop(style);
         this.myButtonContainer.gotoAndStop(style);
         myHitArea = this.myDataContainer["myHitArea"];
         this.myBackground = this.myDataContainer["myBackground"];
         this.myChallengeName = this.myDataContainer["myChallengeName"];
         this.myChallengeReward = this.myDataContainer["myChallengeReward"];
         this.myChallengeRewardItem = this.myDataContainer["myChallengeRewardItem"];
         this.myChallengeDescription = this.myDataContainer["myChallengeDescription"];
         this.myDifficulty = this.myDataContainer["myDifficulty"];
         this.myGainFill = this.myDataContainer["myGainFill"];
         this.myProgressFill = this.myDataContainer["myProgressFill"];
         this.myProgressFillCap = this.myDataContainer["myProgressFillCap"];
         this.myProgressBarBackground = this.myDataContainer["myProgressBarBackground"];
         this.myIcon = this.myDataContainer["myIcon"];
         this.myChainModule = this.myDataContainer["myChainModule"];
         this.myCompleteModule = this.myDataContainer["myCompleteModule"];
         this.myProgressCurrent = this.myDataContainer["myProgressCurrent"];
         this.myFocusBackground = this.myDataContainer["myFocusBackground"];
         this.myDataShadow = this.myDataContainer["myShadow"];
         this.myDataOverlay = this.myDataContainer["myOverlay"];
         this.myButtonShadow = this.myButtonContainer["myShadow"];
         this.myButtonOverlay = this.myButtonContainer["myOverlay"];
         this.myRewardButton = this.myButtonContainer["myRewardButton"];
         this.myPinButton = this.myButtonContainer["myPinButton"];
         this.myInstructions = this.myButtonContainer["myInstructions"];
         this.myButtonInstructions = this.myButtonContainer["myButtonInstructions"];
         this.myButtonContainerHitArea = this.myButtonContainer["myHitArea"];
         this.myButtonContainerFocus = this.myButtonContainer["myFocusBackground"];
         isInteractiveEnabled = true;
         registerClickEvent(this.onViewClicked);
         this.myButtonContainerHitArea.addEventListener(MouseEvent.CLICK,this.onButtonContainerClicked);
         this.myButtonContainerHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.onButtonContainerMouseOver);
         this.myButtonContainerHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.onButtonContainerMouseOut);
         this.myInstructions.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myInstructions.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myInstructions.alignment = TextStyle.HALIGN_CENTER;
         this.myButtonInstructions.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myButtonInstructions.alignment = TextStyle.HALIGN_CENTER;
         this.myInstructions.width = 390;
         this.myInstructions.height = 58;
         this.myButtonInstructions.width = 390;
         this.myButtonInstructions.height = 58;
         this.myPinButton.height = 36;
         this.myRewardButton.height = 36;
         this.myRewardButton.label = LocalizeUtil.localize("@SF_UI_CHALLENGE_REWARD");
         this.myPinButton.registerClickEvent(this.onPinClicked);
         this.myRewardButton.registerClickEvent(this.onRewardClicked);
         this.myCompleteLabel = this.myCompleteModule["myCompleteLabel"];
         this.myCompleteLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myCompleteLabel.fontColor = style == STYLE_NORMAL ? 16776528 : 4240617;
         this.myCompleteLabel.text = LocalizeUtil.localize(DictChallenge.CHALLENGES_COMPLETED);
         this.myCompleteLabel.width = 128;
         this.myCompleteModule.visible = false;
         this.myButtonShadow.visible = false;
         this.myGainFill.visible = false;
         this.myFocusBackground.alpha = 0;
         this.myDifficulty.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myDifficulty.font = GlobalGuide.FONT_FACE_BOLD;
         this.myDifficulty.alignment = TextStyle.HALIGN_CENTER;
         this.myChallengeName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myChallengeName.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myChallengeName.alignment = TextStyle.HALIGN_LEFT;
         this.myChallengeDescription.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myChallengeDescription.fontColor = 9680068;
         this.myChallengeReward.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myChallengeReward.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myChallengeRewardItem.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myChallengeRewardItem.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myProgressCurrent.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myProgressCurrent.alignment = TextStyle.HALIGN_RIGHT;
         this.myProgressCurrent.width = 200;
         this.myChallengeName.width = this.myProgressBarBackground.width;
         this.myChallengeDescription.width = this.myProgressBarBackground.width;
         this.myChallengeDescription.height = 40;
         this.myChallengeReward.width = this.myProgressBarBackground.width;
         this.myChallengeRewardItem.width = this.myProgressBarBackground.width;
         this.mWidth = 413;
         this.mHeight = myHitArea.height;
         this.myProgressCurrent.x = this.mWidth - this.myProgressCurrent.width - 8;
         this.mComponentListener = new ComponentListener(this);
         this.mComponentListener.componentListen(ComponentListener.CEVT_CLOSE_CHALLENGE_ITEM,this.closeOverlay);
      }
      
      override public function setData(data:*) : void
      {
         var baseChallenge:ChallengeBaseObj = null;
         var dailyChallenge:DailyChallengeObj = null;
         var frameIndex:int = 0;
         var vetChallenge:VetChallengeObj = null;
         var reward:String = null;
         var item:String = null;
         super.setData(data);
         this.mButtonOverlayShowing = false;
         this.myButtonContainer.y = -this.mHeight;
         this.myDataContainer.y = 0;
         this.onAnimationComplete();
         baseChallenge = data as ChallengeBaseObj;
         this.mChallenge = baseChallenge;
         if(baseChallenge == null)
         {
            visible = false;
            return;
         }
         visible = true;
         this.myChallengeRewardItem.visible = false;
         this.myRewardButton.visible = false;
         dailyChallenge = data as DailyChallengeObj;
         if(dailyChallenge != null)
         {
            frameIndex = dailyChallenge.isPvp ? 3 : 2;
            this.myBackground.gotoAndStop(frameIndex);
            this.myProgressFill.gotoAndStop(frameIndex);
            this.myDifficulty.text = LocalizeUtil.localize(this.mChallengeDifficulties[dailyChallenge.difficulty]);
            this.myDifficulty.visible = true;
            this.myChainModule.visible = dailyChallenge.chainBonus;
            this.myPinButton.x = this.myBackground.width / 2 - this.myPinButton.width;
            this.myButtonInstructions.text = LocalizeUtil.localize(Dict.CHALLENGE_PIN_INSTRUCTIONS);
         }
         else
         {
            this.myBackground.gotoAndStop(1);
            this.myProgressFill.gotoAndStop(1);
            this.myDifficulty.visible = false;
            this.myPinButton.x = this.mWidth * 0.5 - this.myPinButton.width * 0.5;
            vetChallenge = data as VetChallengeObj;
            if(vetChallenge != null)
            {
               if(vetChallenge.awardSkuID > 0)
               {
                  this.mRewardItem = CFunctionCommonContainer.GetItemInfoBySku(int(vetChallenge.awardSkuID));
                  reward = LocalizeUtil.localize(MarketItemUtil.ITEM_TIER_LABELS[this.mRewardItem.tier]).toUpperCase();
                  if(Boolean(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(this.mRewardItem.group)))
                  {
                     item = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(this.mRewardItem.group));
                  }
                  else
                  {
                     item = LocalizeUtil.localize(this.getItemNameFromType(this.mRewardItem.type));
                  }
                  this.myChallengeRewardItem.text = LocalizeUtil.param("@SF_UI_CHALLENGE_REWARD_ITEM",[reward,item]);
                  this.myChallengeRewardItem.fontColor = MarketGuide.COLOR_BY_TIER[this.mRewardItem.tier];
                  this.myChallengeRewardItem.visible = true;
                  this.myRewardButton.visible = true;
                  this.myPinButton.x = this.myRewardButton.x - this.myPinButton.width - GlobalGuide.COMPONENT_PADDING;
               }
               this.showLock(vetChallenge);
            }
            this.myChainModule.visible = false;
            this.myButtonInstructions.text = LocalizeUtil.localize(Dict.CHALLENGE_PIN_INSTRUCTIONS);
         }
         this.myChallengeName.text = baseChallenge.name.toUpperCase();
         this.myInstructions.text = this.myChallengeDescription.text = LocalizeUtil.getLocalizationWithKeyBinding(baseChallenge.description);
         this.myButtonInstructions.y = this.myInstructions.y + this.myInstructions.textHeight + 10;
         this.myIcon.setImage(baseChallenge.icon);
         var rewardText:String = baseChallenge.getRewardText();
         this.myChallengeReward.text = rewardText;
         this.myChallengeRewardItem.x = this.myChallengeReward.x + this.myChallengeReward.textWidth + 3;
         this.myGainFill.visible = false;
         this.myProgressFill.visible = false;
         this.myProgressFillCap.visible = false;
         this.myProgressBarBackground.visible = false;
         var matchChallenge:MatchResultsChallengeObj = data as MatchResultsChallengeObj;
         if(matchChallenge != null && dailyChallenge == null)
         {
            if(matchChallenge.getFinished())
            {
               this.myCompleteModule.visible = true;
               this.myChallengeDescription.visible = false;
               this.myChallengeReward.alignment = TextStyle.HALIGN_CENTER;
               this.myChallengeName.alignment = TextStyle.HALIGN_CENTER;
            }
            else
            {
               this.myCompleteModule.visible = false;
               this.myChallengeDescription.visible = true;
               this.myChallengeReward.alignment = TextStyle.HALIGN_LEFT;
               this.myChallengeName.alignment = TextStyle.HALIGN_LEFT;
               this.setProgressBar(baseChallenge.progress,matchChallenge.gainedValue,baseChallenge.target);
            }
         }
         else
         {
            this.myChallengeReward.alignment = TextStyle.HALIGN_LEFT;
            this.myChallengeName.alignment = TextStyle.HALIGN_LEFT;
            this.myCompleteModule.visible = false;
            this.myChallengeDescription.visible = true;
            this.setProgressBar(baseChallenge.progress,0,baseChallenge.target);
         }
         this.myProgressFillCap.x = this.myProgressFill.x + this.myProgressFill.width - 14;
         this.myProgressCurrent.text = Math.floor(baseChallenge.progress).toString() + "/" + baseChallenge.target.toString();
         this.myPinButton.visible = !baseChallenge.getFinished();
         if(this.mStyle == STYLE_SMALL)
         {
            this.myCompleteModule.visible = baseChallenge.getFinished();
            this.myProgressCurrent.visible = !this.myCompleteModule.visible;
         }
      }
      
      private function getItemNameFromType(type:String) : String
      {
         var item:String = "";
         switch(type)
         {
            case ItemType.PCT:
               item = DictMarket.CATEGORY_CALLSIGN_TITLE;
               break;
            case ItemType.PCB:
               item = DictMarket.CATEGORY_CALLSIGN_PCB;
               break;
            case ItemType.PCI:
               item = DictMarket.CATEGORY_CALLSIGN_EMBLEM;
         }
         return item;
      }
      
      private function showLock(challengeData:VetChallengeObj) : void
      {
         var lockClass:Class = null;
         if(null == this.myLock)
         {
            this.myScrim = new Sprite();
            addChild(this.myScrim);
            this.myScrim.graphics.beginFill(0,0.5);
            this.myScrim.graphics.drawRect(0,0,this.mWidth - 1,this.mHeight);
            this.myScrim.graphics.endFill();
            lockClass = getDefinitionByName("codo.shared.IconLock") as Class;
            this.myLock = new lockClass() as IconLock;
            addChild(this.myLock);
            this.myLock.scaleX = this.myLock.scaleY = 0.4;
            this.myLock.x = this.mWidth * 0.5 - 19;
            this.myLock.y = this.mHeight * 0.5 - 23;
         }
         if(!challengeData.unlocked)
         {
            this.myLock.setLockLevel(CFunctionCommonContainer.GetDisplayLevel(challengeData.unlock_rank),FsgUtil.getPrestigeIcon(challengeData.unlock_prestige));
         }
         this.myLock.visible = this.myScrim.visible = !challengeData.unlocked;
      }
      
      private function setProgressBar(progress:Number, gainedValue:Number, target:uint) : void
      {
         this.myProgressFill.visible = true;
         this.myProgressFillCap.visible = true;
         this.myProgressBarBackground.visible = true;
         this.myProgressFill.width = this.myProgressBarBackground.width * ((progress - gainedValue) / target);
         if(gainedValue > 0)
         {
            this.myGainFill.width = this.myProgressBarBackground.width * (gainedValue / target);
            this.myGainFill.x = this.myProgressFill.x + this.myProgressFill.width;
            this.myGainFill.visible = true;
         }
      }
      
      private function onViewClicked() : void
      {
         this.mButtonOverlayShowing = !this.mButtonOverlayShowing;
         this.myButtonShadow.visible = true;
         this.myButtonOverlay.visible = true;
         this.myDataShadow.visible = true;
         this.myDataOverlay.visible = true;
         this.mFlashTimeline = new TimelineLite();
         swapChildren(this.myDataContainer,this.myButtonContainer);
         if(this.mButtonOverlayShowing)
         {
            this.myButtonContainer.y = -(this.mHeight - 1);
            TweenLite.to(this.myButtonContainer,0.24,{"y":0});
            TweenLite.to(this.myButtonShadow,0.24,{"alpha":1});
            TweenLite.to(this.myDataContainer,0.24,{"y":this.mHeight + 1});
            TweenLite.to(this.myDataShadow,0.24,{"alpha":0});
            this.mFlashTimeline.append(new TweenLite(this.myButtonOverlay,0.24,{"alpha":1}));
            this.mFlashTimeline.append(new TweenLite(this.myButtonOverlay,0.24,{
               "alpha":0,
               "onComplete":this.onAnimationComplete
            }));
            this.myPinButton.label = this.mChallenge.isPinned() ? "@SF_UI_UNPIN_CHALLENGE" : Dict.PIN_CHALLENGE;
         }
         else
         {
            this.myDataContainer.y = -(this.mHeight - 1);
            TweenLite.to(this.myDataContainer,0.24,{"y":0});
            TweenLite.to(this.myDataShadow,0.24,{"alpha":1});
            TweenLite.to(this.myButtonContainer,0.24,{"y":this.mHeight + 1});
            TweenLite.to(this.myButtonShadow,0.24,{"alpha":0});
            this.mFlashTimeline.append(new TweenLite(this.myDataOverlay,0.12,{"alpha":1}));
            this.mFlashTimeline.append(new TweenLite(this.myDataOverlay,0.12,{
               "alpha":0,
               "onComplete":this.onAnimationComplete
            }));
         }
         this.mFlashTimeline.play();
      }
      
      private function onAnimationComplete() : void
      {
         this.myButtonShadow.visible = false;
         this.myButtonOverlay.visible = false;
         this.myDataOverlay.visible = false;
         this.myDataShadow.visible = false;
      }
      
      private function onButtonContainerClicked(evt:MouseEvent) : void
      {
         this.onViewClicked();
      }
      
      private function onButtonContainerMouseOver(evt:MouseEvent) : void
      {
         TweenLite.to(this.myButtonContainerFocus,0.12,{"alpha":0.16});
      }
      
      private function onButtonContainerMouseOut(evt:MouseEvent) : void
      {
         TweenLite.to(this.myButtonContainerFocus,0.12,{"alpha":0});
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         TweenLite.to(this.myFocusBackground,0.12,{"alpha":0.16});
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         TweenLite.to(this.myFocusBackground,0.12,{"alpha":0});
      }
      
      private function onPinClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.OPEN_PIN_CHALLENGE,this.mChallenge);
         this.mComponentListener.getView().dispatchComponentEvent(ComponentListener.CEVT_CLOSE_CHALLENGE_ITEM);
      }
      
      private function closeOverlay() : void
      {
         if(this.mButtonOverlayShowing)
         {
            this.onViewClicked();
         }
      }
      
      private function onRewardClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":this.mRewardItem});
      }
   }
}

