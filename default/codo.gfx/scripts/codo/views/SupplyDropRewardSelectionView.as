package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.SupplyDropRewardItem2;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.constants.MarketMenuData;
   import codo.constants.UIAnimScheduleFlag;
   import codo.constants.UIViewerAnimType;
   import codo.constants.VideoRender;
   import codo.localization.DictMarket;
   import codo.localization.DictOnBoard;
   import codo.objects.ConsumeSupplyDropResponseObj;
   import codo.objects.ProductObj;
   import codo.objects.SupplyDropGrantedItemObj;
   import codo.objects.SupplyDropRewardItemObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.supplyDrop_parts.SupplyDropDust;
   import codo.views.supplyDrop_parts.SupplyDropRewardDustProgressPanel;
   import com.greensock.TweenLite;
   import components.Clock;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import scaleform.gfx.DisplayObjectEx;
   
   public class SupplyDropRewardSelectionView extends BaseView
   {
      
      private static const MASK_ALPHA:Number = 0.8;
      
      private static const CARD_PADDING:int = 50;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const VIDEO_SPEED_SCALE:Number = 1.5;
      
      private static const VIDEO_PAUSE_CUE:uint = 2300 / VIDEO_SPEED_SCALE;
      
      private static const ITEM_LAUNCH_CUE:uint = 2600 / VIDEO_SPEED_SCALE;
      
      private static const REWARD_ITEM_Y:uint = 520;
      
      private static const SUPPLY_DROP_DUST_LINKAGE:String = "codo.views.supplydrop.supplyDropDust";
      
      private static const SUPPLY_DROP_DUST_SHADOW_LINKAGE:String = "codo.views.supplydrop.supplyDropDustShadow";
      
      private static const STATE_NULL:uint = 0;
      
      private static const STATE_START:uint = 1;
      
      private static const STATE_WAIT_INTRO:uint = 2;
      
      private static const STATE_INTRO_DONE:uint = 3;
      
      private static const STATE_UPDATE_PROGRESS:uint = 4;
      
      private static const STATE_WAIT_FOR_END:uint = 5;
      
      private static const ACTION_NULL:uint = 0;
      
      private static const ACTION_MORE:uint = 1;
      
      private static const ACTION_QUIT:uint = 2;
      
      private static var sTierColors:Array = [[0.4,0.4,0.4],[0.5255,0.8588,0.2392],[0.2078,0.7882,0.9882],[0.7255,0.3608,1],[1,0.5451,0]];
      
      public var myFinishButton:Button;
      
      public var myOpenMoreButton:Button;
      
      public var myVideoContainer:MovieClip;
      
      public var myCountdownTimer:Clock;
      
      public var myRoomName:TextField;
      
      public var myItemHolder:Sprite;
      
      public var myScrimHolder:Sprite;
      
      public var myDustProgressPanel:SupplyDropRewardDustProgressPanel;
      
      private var mNumItemsLeft:int = 0;
      
      private var mLaunchCueTimeout:uint;
      
      private var mPauseCueTimeout:uint;
      
      private var supplyDropResponses:Array;
      
      private var mSupplyDropID:int;
      
      private var mRewardItems:Vector.<SupplyDropRewardItem2>;
      
      private var mRewardItemsEffects:Vector.<MovieClip>;
      
      private var mCrateTypeKey:String;
      
      private var mUpdateStateTimer:Timer;
      
      private var mCurrentVideoPath:String;
      
      private var mScrim:Sprite;
      
      private var mCurrentDusts:uint;
      
      private var mCompleteFirstOpenAnimationRewardItems:uint;
      
      private var mCompleteAnimationRewardItems:uint;
      
      private var mCurrentDustFlyRewardItemIndex:uint;
      
      private var mFlyingDusts:Vector.<MovieClip>;
      
      private var mLeftCrashAmountToRunProgressBar:int;
      
      private var mLeftCrashAmountToFly:int;
      
      private var mNewCratesGained:int;
      
      private var mTotalCrushAmount:int;
      
      private var mVideoState:uint;
      
      private var mPendingAction:uint;
      
      private var mNumCratesOfTypeToOpen:int;
      
      private var mQuartermasterReaction:uint = 0;
      
      public function SupplyDropRewardSelectionView()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var layerMaskCls:Class = null;
         if(this.myCountdownTimer != null)
         {
            this.myCountdownTimer.visible = false;
            this.myCountdownTimer.enableHour = false;
         }
         this.mFlyingDusts = new Vector.<MovieClip>(0);
         this.mCompleteAnimationRewardItems = 0;
         this.mCompleteFirstOpenAnimationRewardItems = 0;
         this.mCurrentDustFlyRewardItemIndex = 0;
         this.myFinishButton.label = ScaleformUtil.isScaleform ? LocalizeUtil.localize(DictOnBoard.ONBOARD_TRAINING_FINISH).toUpperCase() : "FINISH";
         this.myOpenMoreButton.label = ScaleformUtil.isScaleform ? LocalizeUtil.localize(DictMarket.SUPPLY_DROP_OPEN_ANOTHER_CRATE).toUpperCase() : "OPEN ANOTHER";
         this.myFinishButton.width = this.myFinishButton.myLabel.textWidth + 80;
         this.myOpenMoreButton.width = this.myOpenMoreButton.myLabel.textWidth + 80;
         if(ScaleformUtil.isScaleform)
         {
            layerMaskCls = getDefinitionByName("$layerMask") as Class;
            this.mScrim = new layerMaskCls();
            this.mScrim.width = GameInfo.stageSize.x;
            this.mScrim.height = GameInfo.stageSize.y;
            this.mScrim.x = GameInfo.stagePosition.x;
            this.mScrim.y = GameInfo.stagePosition.y;
            this.mScrim.alpha = 0;
            this.myScrimHolder.addChild(this.mScrim);
         }
         this.myDustProgressPanel.alpha = 0;
         this.initVideo();
      }
      
      private function set videoState(state:int) : void
      {
         this.mVideoState = state;
         switch(this.mVideoState)
         {
            case STATE_INTRO_DONE:
               this.myFinishButton.registerClickEvent(this.onFinishClicked);
               this.myFinishButton.enabled = true;
               TweenLite.killTweensOf(this.myFinishButton);
               TweenLite.to(this.myFinishButton,FADE_DURATION,{"alpha":1});
               if(this.myOpenMoreButton.visible)
               {
                  this.myOpenMoreButton.enabled = true;
                  this.myOpenMoreButton.registerClickEvent(this.reOpenCrate);
                  TweenLite.killTweensOf(this.myOpenMoreButton);
                  TweenLite.to(this.myOpenMoreButton,FADE_DURATION,{
                     "alpha":1,
                     "delay":0.1
                  });
               }
         }
      }
      
      private function initVideo() : void
      {
         var bitmapData:BitmapData = new BitmapData(1706,1080,true,0);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         this.myVideoContainer.addChild(bitmap);
         this.myVideoContainer.mouseChildren = false;
         this.myVideoContainer.mouseEnabled = false;
         this.myVideoContainer.x = -153;
         this.myVideoContainer.y = 0;
         DisplayObjectEx.setRendererString(this.myVideoContainer,VideoRender.RENDER_WITH_ALPHA);
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.supplyDropResponses = data;
         var supplyDropResponse:ConsumeSupplyDropResponseObj = this.supplyDropResponses[0];
         this.mSupplyDropID = supplyDropResponse.supplyDropID;
         clearTimeout(this.mLaunchCueTimeout);
         clearTimeout(this.mPauseCueTimeout);
         this.cleanAllSupplyDropDusts();
         this.mCompleteAnimationRewardItems = 0;
         this.mCompleteFirstOpenAnimationRewardItems = 0;
         this.mCurrentDustFlyRewardItemIndex = 0;
         this.myDustProgressPanel.dropID = this.mSupplyDropID;
         this.currentDusts = getDP(DataID.GET_SUPPLY_DROP_DUST_NUM,[this.mSupplyDropID]);
         broadcast(BCEvent.EVT_DEFER_CHAR_LIMIT_POPUP,true);
      }
      
      override protected function showView() : void
      {
         var i:int = 0;
         var j:int = 0;
         var item:SupplyDropRewardItem2 = null;
         var effect:MovieClip = null;
         var supplyDropResponse:ConsumeSupplyDropResponseObj = null;
         var grantedItemObj:SupplyDropGrantedItemObj = null;
         var supplyDropRewardItemObj:SupplyDropRewardItemObj = null;
         var colorTransform:ColorTransform = null;
         super.showView();
         TweenLite.killTweensOf(this);
         this.myDustProgressPanel.killAllTweens();
         this.clearCards();
         this.cleanAllSupplyDropDusts();
         this.mCompleteAnimationRewardItems = 0;
         this.mCompleteFirstOpenAnimationRewardItems = 0;
         this.mCurrentDustFlyRewardItemIndex = 0;
         this.mLeftCrashAmountToRunProgressBar = 0;
         this.mLeftCrashAmountToFly = 0;
         this.mNewCratesGained = 0;
         CFunctionCommonContainer.ForceCollectGarbage();
         this.myDustProgressPanel.initializeAddSupplyDropTF();
         if(Boolean(this.mScrim))
         {
            this.mScrim.visible = true;
            TweenLite.to(this.mScrim,FADE_DURATION,{"alpha":MASK_ALPHA});
         }
         var supplyDropName:String = "";
         var videoName:String = "";
         bind(DataID.SUPPLY_DROP_COUNT,this.updateCardsToOpen);
         var highestTier:int = 0;
         this.mRewardItems = new Vector.<SupplyDropRewardItem2>(0);
         this.mRewardItemsEffects = new Vector.<MovieClip>(0);
         this.mTotalCrushAmount = 0;
         for(i = 0; i < this.supplyDropResponses.length; i++)
         {
            supplyDropResponse = this.supplyDropResponses[i];
            if(supplyDropResponse != null)
            {
               this.mSupplyDropID = supplyDropResponse.supplyDropID;
               for(j = 0; j < supplyDropResponse.grantedItems.length; j++)
               {
                  grantedItemObj = supplyDropResponse.grantedItems[j];
                  supplyDropRewardItemObj = this.BuildSupplyDropRewardItemObj(supplyDropResponse.supplyDropID,grantedItemObj);
                  item = MarketFactory.BUILD_SUPPLY_DROP_ITEM_CARD2();
                  item.setData(supplyDropRewardItemObj);
                  item.visible = false;
                  item.gotoAndStop(1);
                  item.itemLaunchedCallback = this.onItemsLaunched;
                  item.itemCrushAnimationPlayedCallback = this.onItemCrushAnimationPlayed;
                  this.mRewardItems.push(item);
                  this.myItemHolder.addChild(item);
                  effect = MarketFactory.BUILD_SUPPLY_DROP_ITEM_OPEN_EFFECT(grantedItemObj.isFeatured,grantedItemObj.showOff);
                  colorTransform = new ColorTransform();
                  colorTransform.redMultiplier = sTierColors[supplyDropRewardItemObj.product.tier][0];
                  colorTransform.greenMultiplier = sTierColors[supplyDropRewardItemObj.product.tier][1];
                  colorTransform.blueMultiplier = sTierColors[supplyDropRewardItemObj.product.tier][2];
                  effect.transform.colorTransform = colorTransform;
                  this.mRewardItemsEffects.push(effect);
                  this.myItemHolder.addChild(effect);
                  effect.visible = false;
                  if(grantedItemObj.wasCrushed)
                  {
                     this.mTotalCrushAmount += grantedItemObj.crushAmount;
                  }
                  highestTier = int(Math.max(supplyDropRewardItemObj.product.tier,highestTier));
               }
            }
         }
         this.mLeftCrashAmountToFly = this.mTotalCrushAmount;
         for(i = 0; i < this.mRewardItems.length; i++)
         {
            this.mRewardItems[i].zoom = 1.3;
            this.mRewardItemsEffects[i].scaleX = this.mRewardItemsEffects[i].scaleY = 1.3;
            if(this.mRewardItems.length > 3)
            {
               this.mRewardItems[i].zoom = 0.8;
               this.mRewardItemsEffects[i].scaleX = this.mRewardItemsEffects[i].scaleY = 0.8;
            }
         }
         if(this.mTotalCrushAmount > 0 && 0 != getDP(DataID.GET_SUPPLY_DROP_EXCHANGE_SKU,[this.mSupplyDropID]))
         {
            switch(this.mSupplyDropID)
            {
               case MarketMenuData.SUPPLY_DROP_EVENT:
                  broadcast(BCEvent.EVT_CHANGE_LSD_DUST,this.mTotalCrushAmount);
                  break;
               case MarketMenuData.SUPPLY_DROP_ADVANCED:
                  broadcast(BCEvent.EVT_CHANGE_ASD_DUST,this.mTotalCrushAmount);
                  break;
               case MarketMenuData.SUPPLY_DROP_BASIC:
                  broadcast(BCEvent.EVT_CHANGE_BSD_DUST,this.mTotalCrushAmount);
            }
         }
         switch(highestTier)
         {
            case ProductObj.TIER_BASIC:
            case ProductObj.TIER_COMMON:
               this.mQuartermasterReaction = UIViewerAnimType.kAnimOpenCommon;
               break;
            case ProductObj.TIER_RARE:
               this.mQuartermasterReaction = UIViewerAnimType.kAnimOpenRare;
               break;
            case ProductObj.TIER_EPIC:
               this.mQuartermasterReaction = UIViewerAnimType.kAnimOpenEpic;
               break;
            case ProductObj.TIER_LEGENDARY:
               this.mQuartermasterReaction = UIViewerAnimType.kAnimOpenLegendary;
               break;
            default:
               this.mQuartermasterReaction = UIViewerAnimType.kAnimNone;
         }
         this.myVideoContainer.x = -153;
         if(this.mRewardItems.length == 1)
         {
            this.myVideoContainer.x = 197;
         }
         else if(this.mRewardItems.length == 2)
         {
            this.myVideoContainer.x = 34.5;
         }
         if(this.myCountdownTimer != null)
         {
            this.myCountdownTimer.visible = false;
         }
         this.myRoomName.visible = false;
         broadcast(BCEvent.EVT_HIDE_PERSISTENT_VIEW,{"exclude":[]});
         this.mNumItemsLeft = this.mRewardItems.length;
         TweenLite.killTweensOf(this.myFinishButton);
         TweenLite.killTweensOf(this.myOpenMoreButton);
         this.myFinishButton.enabled = this.myOpenMoreButton.enabled = false;
         this.myFinishButton.alpha = this.myOpenMoreButton.alpha = 0;
         this.myDustProgressPanel.alpha = 0;
         switch(this.mSupplyDropID)
         {
            case MarketMenuData.SUPPLY_DROP_BASIC:
               supplyDropName = DictMarket.MARKET_SUPPLY_DROP_BASIC;
               videoName = "codo_random_reward_crate_reveal_silver";
               this.mCrateTypeKey = "basic";
               break;
            case MarketMenuData.SUPPLY_DROP_ADVANCED:
               supplyDropName = DictMarket.MARKET_SUPPLY_DROP_ADVANCED;
               videoName = "codo_random_reward_crate_reveal_gold";
               this.mCrateTypeKey = "adv";
               break;
            case MarketMenuData.SUPPLY_DROP_EVENT:
               supplyDropName = DictMarket.MARKET_SUPPLY_DROP_EVENT;
               videoName = "codo_random_reward_crate_reveal_red";
               this.mCrateTypeKey = "event";
               break;
            default:
               supplyDropName = "(UNSUPPORTED SUPPLY DROP)";
         }
         this.mCurrentVideoPath = videoName;
         if(this.mUpdateStateTimer != null)
         {
            this.mUpdateStateTimer.removeEventListener(TimerEvent.TIMER,this.updateVideoState);
            this.mUpdateStateTimer.reset();
         }
         this.mUpdateStateTimer = new Timer(1);
         this.mUpdateStateTimer.addEventListener(TimerEvent.TIMER,this.updateVideoState);
         this.mUpdateStateTimer.start();
         this.videoState = STATE_START;
         TweenLite.killTweensOf(this.myFinishButton);
         TweenLite.killTweensOf(this.myOpenMoreButton);
         this.myFinishButton.enabled = this.myOpenMoreButton.enabled = false;
         this.myFinishButton.alpha = this.myOpenMoreButton.alpha = 0;
         this.mPendingAction = ACTION_NULL;
      }
      
      private function BuildSupplyDropRewardItemObj(supplyDropID:int, grantedItemObj:SupplyDropGrantedItemObj) : SupplyDropRewardItemObj
      {
         var itemData:ProductObj = null;
         if(grantedItemObj.productID == 0)
         {
            itemData = CFunctionCommonContainer.GetItemInfo(grantedItemObj.itemID);
         }
         else
         {
            itemData = new ProductObj(CFunctionCommonContainer.GetBundleInfo(grantedItemObj.productID));
         }
         itemData.supplyDropRentalDurationSeconds = grantedItemObj.rentalDurationSeconds;
         if(grantedItemObj.rentalDurationSeconds == 0)
         {
            itemData.isPermanentHave = itemData.isBought = true;
            itemData.remainSecond = 0;
         }
         itemData.stackNumber = grantedItemObj.quantity;
         itemData.stackDelta = grantedItemObj.quantityDelta;
         if(grantedItemObj.wasCrushed)
         {
            return new SupplyDropRewardItemObj(supplyDropID,itemData,null,true,grantedItemObj.crushCurrencyID,grantedItemObj.crushAmount,grantedItemObj.isFeatured,grantedItemObj.isPartialCrushed,grantedItemObj.showOff);
         }
         return new SupplyDropRewardItemObj(supplyDropID,itemData,grantedItemObj.itemDependencies,false,0,0,grantedItemObj.isFeatured,false,grantedItemObj.showOff);
      }
      
      private function cleanAllSupplyDropDusts() : void
      {
         var clip:MovieClip = null;
         if(this.mFlyingDusts.length == 0)
         {
            return;
         }
         for(var i:int = 0; i < this.mFlyingDusts.length; i++)
         {
            clip = this.mFlyingDusts[i];
            TweenLite.killTweensOf(clip);
            removeChild(clip);
         }
         this.mFlyingDusts = new Vector.<MovieClip>();
      }
      
      private function updateVideoState(evt:TimerEvent) : void
      {
         var frameNum:int = 0;
         var totalCrashAmount:int = 0;
         var i:int = 0;
         var supplyDropResponse:ConsumeSupplyDropResponseObj = null;
         var j:int = 0;
         var item:SupplyDropGrantedItemObj = null;
         if(this.mPendingAction == ACTION_QUIT)
         {
            this.videoState = STATE_WAIT_FOR_END;
            CFunctionCommonContainer.resumevideo();
         }
         if(this.mPendingAction == ACTION_MORE)
         {
            this.mPendingAction = ACTION_NULL;
            CFunctionCommonContainer.stopvideo();
            this.videoState = STATE_NULL;
            broadcast(BCEvent.EVT_REWARD_CONSUME_SUPPLY_DROP_REQUEST,{
               "dropID":this.mSupplyDropID,
               "quantity":this.supplyDropResponses.length,
               "gotoPrevPageIfFailed":true
            });
            return;
         }
         if(this.mVideoState == STATE_NULL)
         {
            this.cleanAllSupplyDropDusts();
            this.mCompleteAnimationRewardItems = 0;
            this.mCompleteFirstOpenAnimationRewardItems = 0;
         }
         else if(this.mVideoState == STATE_START)
         {
            this.cleanAllSupplyDropDusts();
            if(!CFunctionCommonContainer.isvideoplaying())
            {
               frameNum = VIDEO_SPEED_SCALE * 30;
               CFunctionCommonContainer.playvideo(this.mCurrentVideoPath,false,frameNum);
               this.videoState = STATE_WAIT_INTRO;
               this.mLaunchCueTimeout = setTimeout(this.launchItems,ITEM_LAUNCH_CUE);
            }
         }
         else if(this.mVideoState == STATE_INTRO_DONE)
         {
            totalCrashAmount = 0;
            for(i = 0; i < this.supplyDropResponses.length; i++)
            {
               supplyDropResponse = this.supplyDropResponses[i];
               for(j = 0; j < supplyDropResponse.grantedItems.length; j++)
               {
                  item = supplyDropResponse.grantedItems[j];
                  if(item.wasCrushed)
                  {
                     totalCrashAmount += item.crushAmount;
                  }
               }
            }
            this.videoState = STATE_UPDATE_PROGRESS;
         }
         else if(this.mVideoState == STATE_WAIT_FOR_END)
         {
            if(!CFunctionCommonContainer.isvideoplaying())
            {
               this.videoState = STATE_NULL;
               if(this.mPendingAction == ACTION_QUIT)
               {
                  this.mPendingAction = ACTION_NULL;
                  broadcast(BCEvent.GOTO_PREV_MAIN_PAGE);
                  if(this.mQuartermasterReaction != UIViewerAnimType.kAnimNone)
                  {
                     CFunctionContainer.CL_PlayAnimation(this.mQuartermasterReaction,UIAnimScheduleFlag.NO_BLEND_IN);
                  }
               }
            }
         }
      }
      
      private function updateCardsToOpen(cRes:Object) : void
      {
         this.mNumCratesOfTypeToOpen = cRes.data[this.mCrateTypeKey];
         this.myOpenMoreButton.visible = this.mNumCratesOfTypeToOpen >= this.supplyDropResponses.length;
         if(this.supplyDropResponses.length == 1)
         {
            this.myOpenMoreButton.label = DictMarket.SUPPLY_DROP_OPEN_ANOTHER_CRATE;
         }
         else
         {
            this.myOpenMoreButton.label = LocalizeUtil.param(DictMarket.SUPPLY_DROP_OPEN_MORE_CRATES,[this.supplyDropResponses.length.toString()]);
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         if(Boolean(this.mScrim))
         {
            TweenLite.to(this.mScrim,FADE_DURATION,{
               "delay":1,
               "autoAlpha":0
            });
         }
         unbind(DataID.SUPPLY_DROP_COUNT,this.updateCardsToOpen);
         broadcast(BCEvent.EVT_SHOW_PERSISTENT_VIEW);
         this.clearCards();
         broadcast(BCEvent.EVT_DEFER_CHAR_LIMIT_POPUP,false);
         if(this.mUpdateStateTimer != null)
         {
            this.mUpdateStateTimer.removeEventListener(TimerEvent.TIMER,this.updateVideoState);
            this.mUpdateStateTimer.reset();
            this.mUpdateStateTimer = null;
         }
         clearTimeout(this.mLaunchCueTimeout);
         clearTimeout(this.mPauseCueTimeout);
         CFunctionCommonContainer.stopvideo();
         this.mCompleteAnimationRewardItems = 0;
         this.mCompleteFirstOpenAnimationRewardItems = 0;
         this.cleanAllSupplyDropDusts();
         CFunctionCommonContainer.ForceCollectGarbage();
      }
      
      private function clearCards() : void
      {
         var card:DisplayObject = null;
         while(this.myItemHolder.numChildren > 0)
         {
            card = this.myItemHolder.getChildAt(0);
            TweenLite.killTweensOf(card);
            this.myItemHolder.removeChildAt(0);
         }
      }
      
      private function onFinishClicked() : void
      {
         var rewardItem:SupplyDropRewardItem2 = null;
         for each(rewardItem in this.mRewardItems)
         {
            TweenLite.to(rewardItem,FADE_DURATION,{"alpha":0});
         }
         TweenLite.killTweensOf(this.myFinishButton);
         TweenLite.killTweensOf(this.myOpenMoreButton);
         this.mFlyingDusts.forEach(TweenLite.killTweensOf);
         this.mFlyingDusts = new Vector.<MovieClip>(0);
         this.mRewardItems.forEach(TweenLite.killTweensOf);
         this.mRewardItems.forEach(function(item:SupplyDropRewardItem2):void
         {
            item.visible = false;
         });
         this.mRewardItems = new Vector.<SupplyDropRewardItem2>(0);
         this.mRewardItemsEffects.forEach(TweenLite.killTweensOf);
         this.mRewardItemsEffects.forEach(function(effect:MovieClip):void
         {
            effect.visible = false;
         });
         this.mRewardItemsEffects = new Vector.<MovieClip>(0);
         TweenLite.to(this.myFinishButton,FADE_DURATION,{"alpha":0});
         TweenLite.to(this.myOpenMoreButton,FADE_DURATION,{"alpha":0});
         TweenLite.to(this.myDustProgressPanel,FADE_DURATION,{"alpha":0});
         this.myFinishButton.unRegisterClickEvent(this.onFinishClicked);
         this.myOpenMoreButton.unRegisterClickEvent(this.reOpenCrate);
         this.mPendingAction = ACTION_QUIT;
      }
      
      private function reOpenCrate() : void
      {
         this.clearCards();
         TweenLite.killTweensOf(this.myFinishButton);
         TweenLite.killTweensOf(this.myOpenMoreButton);
         this.mFlyingDusts.forEach(TweenLite.killTweensOf);
         this.mFlyingDusts = new Vector.<MovieClip>(0);
         this.mRewardItems.forEach(TweenLite.killTweensOf);
         this.mRewardItems = new Vector.<SupplyDropRewardItem2>(0);
         this.mRewardItemsEffects.forEach(TweenLite.killTweensOf);
         this.mRewardItemsEffects = new Vector.<MovieClip>(0);
         this.myFinishButton.enabled = this.myOpenMoreButton.enabled = false;
         this.myFinishButton.alpha = this.myOpenMoreButton.alpha = 0;
         this.myFinishButton.unRegisterClickEvent(this.onFinishClicked);
         this.myOpenMoreButton.unRegisterClickEvent(this.reOpenCrate);
         this.myDustProgressPanel.alpha = 0;
         this.mPendingAction = ACTION_MORE;
         CFunctionCommonContainer.ForceCollectGarbage();
      }
      
      private function launchItems() : void
      {
         var i:int = 0;
         var rewardObj:SupplyDropRewardItemObj = null;
         var launchDelay:Number = NaN;
         var effectDelay:Number = NaN;
         var nextOpenDelay:Number = NaN;
         clearTimeout(this.mLaunchCueTimeout);
         var startX:Number = 652;
         var scrollX:Number = 1;
         if(this.mRewardItems.length == 1)
         {
            startX = 1002;
         }
         if(this.mRewardItems.length == 2)
         {
            startX = 813;
         }
         if(this.mRewardItems.length > 3)
         {
            startX = 500;
            scrollX = 0.6;
         }
         var CARD_WIDTH:uint = 300;
         for(i = 0; i < this.mRewardItems.length; i++)
         {
            if(this.mRewardItems.length <= 5)
            {
               this.mRewardItems[i].x = this.mRewardItemsEffects[i].x = startX + (CARD_WIDTH * scrollX + CARD_PADDING) * i;
               this.mRewardItems[i].y = this.mRewardItemsEffects[i].y = this.mRewardItems.length < 3 ? REWARD_ITEM_Y : 440;
            }
            else
            {
               this.mRewardItems[i].x = this.mRewardItemsEffects[i].x = startX + (CARD_WIDTH * scrollX + CARD_PADDING) * (i % 5);
               this.mRewardItems[i].y = this.mRewardItemsEffects[i].y = i < 5 ? 280 : 600;
            }
         }
         var delay:Number = 0;
         for(i = 0; i < this.mRewardItems.length; i++)
         {
            rewardObj = this.mRewardItems[i].getData();
            launchDelay = 0;
            effectDelay = 0.5;
            nextOpenDelay = 0.1;
            if(rewardObj.isFeatured)
            {
               nextOpenDelay = 1.5;
               launchDelay = 0.6;
               effectDelay = 0;
               delay += 0.5;
            }
            else if(rewardObj.shouldShowOff)
            {
               nextOpenDelay = 1.2;
               launchDelay = 0.4;
               effectDelay = 0;
               delay += 1;
            }
            TweenLite.to(this.mRewardItems[i],0.1,{
               "delay":delay,
               "onStart":this.onLaunchItem,
               "onStartParams":[this.mRewardItems[i],this.mRewardItemsEffects[i],launchDelay,effectDelay]
            });
            delay += nextOpenDelay;
         }
         this.mPauseCueTimeout = setTimeout(this.onPauseVideo,VIDEO_PAUSE_CUE);
      }
      
      private function onLaunchItem(item:SupplyDropRewardItem2, effect:MovieClip, launchDelay:Number, effectDelay:Number) : void
      {
         TweenLite.killTweensOf(item);
         item.launch(launchDelay);
         if(effectDelay == 0)
         {
            this.playLaunchEffect(effect);
         }
         else
         {
            TweenLite.to(this,0.1,{
               "delay":effectDelay,
               "onComplete":this.playLaunchEffect,
               "onCompleteParams":[effect]
            });
         }
      }
      
      private function playLaunchEffect(effect:MovieClip) : void
      {
         effect.visible = true;
         effect.gotoAndPlay(1);
      }
      
      private function onItemsLaunched(item:SupplyDropRewardItem2) : void
      {
         var startX:int = 0;
         var endX:int = 0;
         var totalButtonWidth:int = 0;
         if(item == this.mRewardItems[this.mRewardItems.length - 1])
         {
            startX = this.mRewardItems[0].x - this.mRewardItems[0].width * this.mRewardItems[0].scaleX * 0.5;
            endX = this.mRewardItems[this.mRewardItems.length - 1].x + this.mRewardItems[this.mRewardItems.length - 1].width * this.mRewardItems[this.mRewardItems.length - 1].scaleX * 0.5;
            if(this.myOpenMoreButton.visible)
            {
               totalButtonWidth = this.myFinishButton.width + this.myOpenMoreButton.width + 10;
               this.myFinishButton.x = startX + (endX - startX - totalButtonWidth) / 2;
               this.myOpenMoreButton.x = this.myFinishButton.x + this.myFinishButton.width + 10;
            }
            else
            {
               this.myFinishButton.x = startX + (endX - startX - this.myFinishButton.width) / 2;
            }
            this.onAllItemsLaunched();
         }
      }
      
      private function onAllItemsLaunched() : void
      {
         var i:int = 0;
         if(this.mSupplyDropID != MarketMenuData.SUPPLY_DROP_BASIC)
         {
            TweenLite.to(this.myDustProgressPanel,0.1,{"alpha":1});
         }
         for(i = 0; i < this.mRewardItems.length; i++)
         {
            this.mRewardItems[i].playCrushAnimation();
         }
      }
      
      private function onItemCrushAnimationPlayed(item:SupplyDropRewardItem2) : void
      {
         var i:int = 0;
         var exchangeRatio:int = 0;
         for(i = 0; i < this.mRewardItems.length; i++)
         {
            if(!this.mRewardItems[i].crushAnimationPlayed)
            {
               return;
            }
         }
         this.videoState = STATE_INTRO_DONE;
         if(this.mSupplyDropID != MarketMenuData.SUPPLY_DROP_BASIC)
         {
            if(this.mTotalCrushAmount > 0)
            {
               exchangeRatio = CFunctionContainer.AS_GetSupplyDropDustExchangeRatio(this.mSupplyDropID);
               this.mLeftCrashAmountToRunProgressBar = this.mLeftCrashAmountToFly;
               this.mNewCratesGained = Math.floor((this.mLeftCrashAmountToRunProgressBar + this.myDustProgressPanel.dusts) / exchangeRatio);
               this.myDustProgressPanel.iconOpen();
               this.myDustProgressPanel.animateToDusts(this.myDustProgressPanel.dusts + this.mLeftCrashAmountToRunProgressBar,1.5,null);
            }
            for(i = 0; i < this.mRewardItems.length; i++)
            {
               if(this.mRewardItems[i].shouldCrush())
               {
                  this.playCrushDustFlyToProgressBarEffect(this.mRewardItems[i]);
               }
            }
         }
      }
      
      private function playCrushDustFlyToProgressBarEffect(item:SupplyDropRewardItem2) : void
      {
         var DUST_FLY_DEST_X:Number = this.myDustProgressPanel.x + this.myDustProgressPanel.myImage.x;
         var DUST_FLY_DEST_Y:Number = this.myDustProgressPanel.y + this.myDustProgressPanel.myImage.y;
         var DELAY_PER_DUST_ITEM:Number = 0.1;
         var delay:Number = 0.5;
         for(var i:int = 0; i < 10; i++)
         {
            this.createDustTween(item,DUST_FLY_DEST_X,DUST_FLY_DEST_Y,delay,i == 9);
            this.createShadowTween(item,DUST_FLY_DEST_X,DUST_FLY_DEST_Y,delay);
            delay += DELAY_PER_DUST_ITEM;
         }
      }
      
      private function createDustTween(item:SupplyDropRewardItem2, destX:Number, destY:Number, delay:Number, isLast:Boolean) : Number
      {
         var i:int = 0;
         var radius:Number = NaN;
         var angle:Number = NaN;
         var dustCls:Class = null;
         var dust:SupplyDropDust = null;
         var shardNum:int = 1 + Math.floor(Math.random() * 3);
         for(i = 0; i < shardNum; i++)
         {
            dustCls = getDefinitionByName(SUPPLY_DROP_DUST_LINKAGE) as Class;
            dust = new dustCls() as SupplyDropDust;
            addChild(dust);
            this.mFlyingDusts.push(dust);
            radius = Math.random() * 50;
            angle = Math.random() * Math.PI * 2;
            dust.x = item.x + radius * Math.sin(angle);
            dust.y = item.y + radius * Math.cos(angle);
            dust.dropID = this.mSupplyDropID;
            dust.quantity = 0;
            if(isLast && i == shardNum - 1)
            {
               dust.quantity = item.crushAmount;
            }
            dust.visible = false;
            dust.rotation = Math.random() * 360;
            dust.gotoAndStop(Math.floor(Math.random() * 6) + 1);
            TweenLite.to(dust,0.5,{
               "x":destX,
               "y":destY,
               "delay":delay,
               "scaleX":0.5,
               "scaleY":0.5,
               "onStart":this.onDustFlyToProgressBarStart,
               "onStartParams":[dust],
               "onComplete":this.onDustFlyToProgressBarComplete,
               "onCompleteParams":[dust]
            });
            delay += 0.02;
         }
         return delay;
      }
      
      private function createShadowTween(item:SupplyDropRewardItem2, destX:Number, destY:Number, delay:Number) : Number
      {
         var radius:Number = NaN;
         var angle:Number = NaN;
         var i:int = 0;
         var shadowCls:Class = null;
         var shadow:MovieClip = null;
         var startX:Number = NaN;
         var startY:Number = NaN;
         var shadowNum:int = 1 + Math.floor(Math.random() * 2);
         for(i = 0; i < shadowNum; i++)
         {
            shadowCls = getDefinitionByName(SUPPLY_DROP_DUST_SHADOW_LINKAGE) as Class;
            shadow = new shadowCls() as MovieClip;
            addChild(shadow);
            this.mFlyingDusts.push(shadow);
            radius = Math.random() * 60;
            angle = Math.random() * Math.PI * 2;
            startX = item.x;
            startY = item.y;
            shadow.x = startX + radius * Math.sin(angle);
            shadow.y = startY + radius * Math.cos(angle);
            shadow.visible = false;
            shadow.rotation = (Math.PI / 2 + Math.atan((destY - startY) / (destX - startX))) * 180 / Math.PI;
            TweenLite.to(shadow,0.5,{
               "x":destX,
               "y":destY,
               "delay":delay,
               "alpha":0,
               "scaleX":0.5,
               "scaleY":0.5,
               "onStart":this.onDustFlyToProgressBarStart,
               "onStartParams":[shadow]
            });
            delay += 0.02;
         }
         return delay;
      }
      
      private function onPauseVideo() : void
      {
         clearTimeout(this.mPauseCueTimeout);
         CFunctionCommonContainer.pausevideo();
      }
      
      public function set currentDusts(val:uint) : void
      {
         this.mCurrentDusts = val;
         var exchangeRatio:int = CFunctionContainer.AS_GetSupplyDropDustExchangeRatio(this.mSupplyDropID);
         this.myDustProgressPanel.setDustExchangeRatio(exchangeRatio);
         if(exchangeRatio > 0)
         {
            this.myDustProgressPanel.initDusts(this.mCurrentDusts % exchangeRatio);
         }
         else
         {
            this.myDustProgressPanel.initDusts(0);
         }
      }
      
      private function onDustFlyToProgressBarStart(clip:MovieClip) : void
      {
         clip.visible = true;
      }
      
      private function onDustFlyToProgressBarComplete(dust:SupplyDropDust) : void
      {
         dust.visible = false;
         this.mLeftCrashAmountToFly -= dust.quantity;
         if(this.mLeftCrashAmountToFly > 0)
         {
            return;
         }
         this.cleanAllSupplyDropDusts();
         this.myDustProgressPanel.iconClose(this.onProgressUpdateComplete);
      }
      
      private function onProgressUpdateComplete() : void
      {
         if(this.mNewCratesGained > 0)
         {
            this.myDustProgressPanel.playSupplyDropIncreaseAnimation(this.mNewCratesGained,this.onPlaySupplyDropIncreaseAnimationComplete);
         }
         else
         {
            this.videoState = STATE_INTRO_DONE;
         }
      }
      
      private function onPlaySupplyDropIncreaseAnimationComplete() : void
      {
         var exchangeRatio:int = CFunctionContainer.AS_GetSupplyDropDustExchangeRatio(this.mSupplyDropID);
         if(exchangeRatio == 0)
         {
            this.videoState = STATE_INTRO_DONE;
            return;
         }
         var leftDusts:int = this.myDustProgressPanel.dusts % exchangeRatio;
         var duration:Number = 1.5 * leftDusts / exchangeRatio;
         this.myDustProgressPanel.initDusts(0);
         this.myDustProgressPanel.animateToDusts(leftDusts,duration,this.onResetProgressBarComplete);
      }
      
      private function onResetProgressBarComplete() : void
      {
         bind(DataID.SUPPLY_DROP_COUNT,this.updateCardsToOpen);
         this.videoState = STATE_INTRO_DONE;
      }
   }
}

