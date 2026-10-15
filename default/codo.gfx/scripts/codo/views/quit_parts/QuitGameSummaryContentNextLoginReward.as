package codo.views.quit_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.localization.DictMarket;
   import codo.objects.MOTDCheckinRewardObj;
   import codo.objects.ProductObj;
   import codo.utils.MarketItemUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class QuitGameSummaryContentNextLoginReward extends BaseSubElement
   {
      
      public var myFeatureDisplay:QuitGameSummaryFeatureDisplay;
      
      public var myNextMarketItem:MarketplaceItemCard;
      
      public var myNoAwardDisplay:QuitGameRewardUnavailable;
      
      private var mTimerCount:Timer;
      
      private var mEndOfMonthDate:Date;
      
      public function QuitGameSummaryContentNextLoginReward()
      {
         super();
         this.myFeatureDisplay.setText(isDebugMode ? "COMING SOON" : DictMarket.QUIT_SCREEN_DAILY_LOGIN_TITLE,isDebugMode ? "NEXT LOGIN" : DictMarket.QUIT_SCREEN_DAILY_LOGIN_LABEL);
         this.myNextMarketItem.visible = isDebugMode;
         this.myNextMarketItem.setCardStyle(MarketItemUtil.ITEM_CARD_LARGE_FRAME,false);
         this.myNextMarketItem.withDiscountTag = false;
      }
      
      override public function active() : void
      {
         super.active();
         var currDate:Date = new Date();
         var utcMonth:Number = currDate.getUTCMonth();
         this.myNoAwardDisplay.deactive();
         if(utcMonth > 12)
         {
            utcMonth %= 12;
         }
         this.mEndOfMonthDate = new Date(currDate.getUTCFullYear(),++utcMonth,0,24);
         this.updateTimeToNextLogin();
         this.mTimerCount = new Timer(1000);
         this.mTimerCount.addEventListener(TimerEvent.TIMER,this.updateTimeToNextLogin);
         this.mTimerCount.start();
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.mTimerCount.reset();
         this.mTimerCount.removeEventListener(TimerEvent.TIMER,this.updateTimeToNextLogin);
         this.mTimerCount = null;
      }
      
      public function setRewardData(prod:ProductObj, reward:MOTDCheckinRewardObj) : void
      {
         this.myNextMarketItem.setData(prod);
         this.myNextMarketItem.myTimeRemainingTF.htmlText = reward.getDurationText(prod);
         this.myNextMarketItem.myTimeRemainingTF.visible = !prod.isGP;
         this.myNextMarketItem.myItemRentalStatus.visible = false;
      }
      
      public function set rewardAvailabllity(isAvailable:Boolean) : void
      {
         if(!isAvailable)
         {
            this.myNoAwardDisplay.active();
         }
         this.myNextMarketItem.visible = isAvailable;
         this.myFeatureDisplay.showHideTimeDisplay(isAvailable);
      }
      
      private function updateTimeToNextLogin(e:TimerEvent = null) : void
      {
         if(isDebugMode)
         {
            return;
         }
         var timeStamp:Number = CFunctionCommonContainer.GetServerTimeStamp();
         var remainTime:Number = this.mEndOfMonthDate.getTime() / 1000 - timeStamp;
         this.myFeatureDisplay.setValueInSeconds(Math.floor(remainTime));
      }
   }
}

