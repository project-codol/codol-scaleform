package components.fsgmatchresult_part
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.SupplyDropRewardItem;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.GameInfo;
   import codo.constants.VideoRender;
   import codo.localization.Dict;
   import codo.localization.DictMatchResults;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import com.greensock.easing.RoughEase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import scaleform.gfx.DisplayObjectEx;
   
   public class FsgRandomRewardPresentation extends BaseSubElement
   {
      
      public static const REWARDS_PER_BOX:int = 2;
      
      public static const ONBOARD_REWARDS_PER_BOX:int = 3;
      
      private static const VIDEO_PAUSE_CUE:uint = 2300;
      
      private static const ITEM_LAUNCH_CUE:uint = 2600;
      
      private static const ITEM_PADDING:uint = 20;
      
      private static const SCREEN_CLOSE_TIMER_DURATION:Number = 5;
      
      private static const CONTINUE_DURATION:uint = 1000;
      
      private static const ITEM_START_SCALE:Number = 0.5;
      
      private static const ITEM_FADE_DURATION:Number = 0.25;
      
      private static const GOLD_VIDEO_PATH:String = "codo_random_reward_crate_reveal_gold";
      
      private static const SILVER_VIDEO_PATH:String = "codo_random_reward_crate_reveal_silver";
      
      private static const BRONZE_VIDEO_PATH:String = "codo_random_reward_crate_reveal_bronze";
      
      private static const PURPLE_VIDEO_PATH:String = "codo_random_reward_crate_reveal_purple";
      
      private static const REWARD_ITEM_Y:uint = 120;
      
      private static const FLY_IN_DURATION:Number = 0.3;
      
      private static const FLY_IN_START_SCALE:Number = 0.6;
      
      private static const FLY_IN_END_SCALE:Number = 1;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private var mNumItemsLeft:int;
      
      public var myAcceptBtn:Button;
      
      public var myVideoContainer:MovieClip;
      
      public var myScrim:MovieClip;
      
      public var myItemMount:MovieClip;
      
      public var mySkipOnboardingMessageTF:TextField;
      
      private var mOnCompleteCallback:Function;
      
      private var mCuePointTimer:Timer;
      
      private var mCloseScreenTimer:Timer;
      
      private var mItemPos:Vector.<uint>;
      
      public function FsgRandomRewardPresentation()
      {
         super();
         var bitmapData:BitmapData = new BitmapData(1706,960,true,0);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         this.myVideoContainer.addChild(bitmap);
         this.myVideoContainer.mouseChildren = false;
         this.myVideoContainer.mouseEnabled = false;
         this.myVideoContainer.x = -153;
         this.myVideoContainer.y = 0;
         this.myAcceptBtn.label = LocalizeUtil.localize(Dict.ACCEPT_CHALLENGE);
         this.myAcceptBtn.registerClickEvent(this.onAcceptButtonClicked);
         this.myAcceptBtn.alpha = 0;
         this.myAcceptBtn.enabled = this.myAcceptBtn.visible = false;
         if(this.mySkipOnboardingMessageTF != null)
         {
            this.mySkipOnboardingMessageTF.visible = false;
         }
         DisplayObjectEx.setRendererString(this.myVideoContainer,VideoRender.RENDER_WITH_ALPHA);
      }
      
      private function handleKeyboardInput(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.ESCAPE)
         {
            this.onAcceptButtonClicked(true);
         }
      }
      
      public function showRandomReward(rewardsData:Array, specifyTier:int = -1) : void
      {
         var path:String = null;
         this.gotoAndPlay(2);
         this.visible = true;
         var rewardTier:int = specifyTier;
         if(rewardTier == -1)
         {
            rewardTier = CFunctionContainer.AS_GetAARRandomRewardTier();
         }
         this.clearItems();
         this.myItemMount.alpha = 1;
         if(rewardsData != null)
         {
            this.buildCardsForRandomRewards(rewardsData);
         }
         this.mCuePointTimer = new Timer(ITEM_LAUNCH_CUE,1);
         this.mCuePointTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onLaunchItems);
         this.mCuePointTimer.start();
         switch(rewardTier)
         {
            case 1:
               path = SILVER_VIDEO_PATH;
               break;
            case 2:
               path = GOLD_VIDEO_PATH;
               break;
            case 3:
               path = PURPLE_VIDEO_PATH;
               break;
            default:
               path = BRONZE_VIDEO_PATH;
         }
         CFunctionCommonContainer.playvideo(path,false);
      }
      
      private function buildCardsForRandomRewards(rewardsData:Array) : void
      {
         var item:UIInteractiveComponent = null;
         var itemContainer:MovieClip = null;
         var halfWidth:Number = NaN;
         var halfHeight:Number = NaN;
         var i:int = 0;
         var rewardData:Object = null;
         var curX:Number = 0;
         var len:int = Math.min(rewardsData.length,REWARDS_PER_BOX);
         for(i = 0; i < len; )
         {
            itemContainer = new MovieClip();
            item = MarketFactory.BUILD_MARKET_ITEM_MEDIUM_CARD();
            (item as MarketplaceItem).withDiscountTag = false;
            item.isInteractiveEnabled = false;
            itemContainer.addChild(item);
            halfWidth = item.width * 0.5;
            halfHeight = item.height * 0.5;
            item.x = -halfWidth;
            item.y = -halfHeight;
            itemContainer.x = curX + halfWidth;
            itemContainer.y = halfHeight;
            itemContainer.alpha = 0;
            itemContainer.scaleX = ITEM_START_SCALE;
            itemContainer.scaleY = ITEM_START_SCALE;
            itemContainer.rotationX = 0;
            rewardData = rewardsData[i];
            if(rewardData.hasOwnProperty("gp"))
            {
               ProductObj.makeGpObj(rewardData,rewardData.gp);
            }
            item.setData(rewardData);
            this.myItemMount.addChild(itemContainer);
            curX += item.width + ITEM_PADDING;
            i++;
         }
         this.myItemMount.x = GameInfo.DEFAULT_WIDTH * 0.5 - (curX - ITEM_PADDING) * 0.5;
      }
      
      private function animateForRandomRewards() : void
      {
         var item:MovieClip = null;
         var animTimeline:TimelineLite = null;
         var animObj:Object = null;
         var startX:Number = this.myItemMount.width * 0.5;
         var animDelay:Number = 0;
         var len:int = this.myItemMount.numChildren;
         for(var i:int = 0; i < len; )
         {
            item = this.myItemMount.getChildAt(i) as MovieClip;
            TweenLite.to(item,ITEM_FADE_DURATION,{
               "delay":animDelay,
               "alpha":1
            });
            animObj = {
               "delay":animDelay,
               "x":item.x,
               "scaleX":1.4,
               "scaleY":1.4,
               "rotationX":720,
               "ease":Linear.easeOut
            };
            item.x = startX;
            if(i == len - 1)
            {
               animObj.onComplete = this.onItemsLanded;
            }
            animTimeline = new TimelineLite();
            animTimeline.append(new TweenLite(item,0.4,animObj));
            animTimeline.append(new TweenLite(item,0.3,{
               "scaleX":1,
               "scaleY":1,
               "ease":Back.easeOut
            }));
            animDelay += 0.15;
            i++;
         }
      }
      
      private function onItemsLaunched(item:SupplyDropRewardItem) : void
      {
         item.enabled = true;
      }
      
      private function onRewardClicked(rewardItem:SupplyDropRewardItem) : void
      {
         if(!rewardItem.isOpen)
         {
            TweenMax.fromTo(rewardItem,0.2,{"x":rewardItem.x - 1},{
               "x":rewardItem.x + 1,
               "ease":RoughEase.create(15,40,false,Linear.easeNone,"none",false),
               "onStart":rewardItem.open,
               "clearProps":"x"
            });
            --this.mNumItemsLeft;
            if(this.mNumItemsLeft == 0)
            {
               this.myAcceptBtn.visible = true;
               this.myAcceptBtn.registerClickEvent(this.onAcceptButtonClicked);
               this.myAcceptBtn.enabled = true;
               TweenLite.to(this.myAcceptBtn,FADE_DURATION,{"alpha":1});
            }
         }
      }
      
      public function setOnCompleteCallback(func:Function) : void
      {
         this.mOnCompleteCallback = func;
      }
      
      private function onLaunchItems(cEvt:TimerEvent) : void
      {
         this.animateForRandomRewards();
         this.mCuePointTimer.stop();
         this.mCuePointTimer = new Timer(VIDEO_PAUSE_CUE,1);
         this.mCuePointTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPauseVideo);
         this.mCuePointTimer.start();
      }
      
      private function onItemsLanded() : void
      {
         this.setContinueButtonText(SCREEN_CLOSE_TIMER_DURATION);
         this.mCloseScreenTimer = new Timer(CONTINUE_DURATION,SCREEN_CLOSE_TIMER_DURATION);
         this.mCloseScreenTimer.addEventListener(TimerEvent.TIMER,this.onUpdate);
         this.mCloseScreenTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.mCloseScreenTimer.start();
         this.myAcceptBtn.visible = true;
         TweenLite.to(this.myAcceptBtn,ITEM_FADE_DURATION,{"alpha":1});
         this.myAcceptBtn.enabled = true;
      }
      
      private function onPauseVideo(cEvt:TimerEvent) : void
      {
         this.mCuePointTimer.stop();
         CFunctionCommonContainer.pausevideo();
      }
      
      private function onAcceptButtonClicked(escClicked:Boolean = false) : void
      {
         if(null != this.mCloseScreenTimer)
         {
            this.mCloseScreenTimer.stop();
         }
         if(null != this.mCuePointTimer)
         {
            this.mCuePointTimer.stop();
         }
         this.myAcceptBtn.visible = false;
         this.myAcceptBtn.alpha = 0;
         this.myAcceptBtn.enabled = false;
         TweenLite.to(this.myItemMount,ITEM_FADE_DURATION,{"alpha":0});
         TweenLite.to(this.myScrim,ITEM_FADE_DURATION,{"alpha":0});
         if(this.mySkipOnboardingMessageTF != null && this.mySkipOnboardingMessageTF.visible)
         {
            TweenLite.to(this.mySkipOnboardingMessageTF,ITEM_FADE_DURATION,{"alpha":0});
         }
         if(!escClicked)
         {
            CFunctionCommonContainer.resumevideo();
            addEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
         }
         else
         {
            this.killPresentation();
         }
      }
      
      private function checkVideoStatus(e:Event) : void
      {
         if(!CFunctionCommonContainer.isvideoplaying())
         {
            this.killPresentation();
         }
      }
      
      public function killPresentation() : void
      {
         this.gotoAndStop(1);
         while(this.myItemMount.numChildren > 0)
         {
            this.myItemMount.removeChildAt(0);
         }
         removeEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
         CFunctionCommonContainer.stopvideo();
         parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyboardInput);
         this.visible = false;
         this.myAcceptBtn.enabled = false;
         if(this.mySkipOnboardingMessageTF != null)
         {
            this.mySkipOnboardingMessageTF.visible = false;
         }
         if(this.mOnCompleteCallback != null)
         {
            this.mOnCompleteCallback();
         }
      }
      
      private function onTimerComplete(evt:TimerEvent) : void
      {
         this.onAcceptButtonClicked();
      }
      
      private function onUpdate(evt:TimerEvent) : void
      {
         var count:uint = uint(this.mCloseScreenTimer.currentCount);
         this.setContinueButtonText(SCREEN_CLOSE_TIMER_DURATION - count);
      }
      
      private function setContinueButtonText(count:uint) : void
      {
         this.myAcceptBtn.label = LocalizeUtil.replace(LocalizeUtil.localize(DictMatchResults.ACCEPT_REWARD).toUpperCase(),[count]);
      }
      
      private function clearItems() : void
      {
         while(this.myItemMount.numChildren > 0)
         {
            this.myItemMount.removeChildAt(0);
         }
      }
   }
}

