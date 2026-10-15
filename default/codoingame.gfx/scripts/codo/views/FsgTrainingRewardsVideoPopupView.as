package codo.views
{
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.interfaces.IDisposable;
   import codo.objects.ItemObj;
   import codo.objects.VideoCuePointObject;
   import codo.services.OnboardService;
   import codo.utils.ScaleformUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenAlign;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Linear;
   import components.fsgTrainingComplete_part.FsgTrainingRewardsVideoItem;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import fsg.shared.VideoDisplayBaseView;
   
   public class FsgTrainingRewardsVideoPopupView extends VideoDisplayBaseView implements IDisposable
   {
      
      private static const ITEM_LAUNCH_CUE:uint = ScaleformUtil.isScaleform ? 2500 : 0;
      
      private static const VIDEO_PAUSE_CUE:uint = ScaleformUtil.isScaleform ? 2300 : 0;
      
      private static const CLOSE_VIDEO_PAUSE:uint = 3000;
      
      private static const CLOSE_VIEW_PAUSE:uint = 2000;
      
      private static const OFFSET_WIDTH:Number = 123.5;
      
      private static const OFFSET_HEIGHT:Number = 80.5;
      
      private static const TOTAL_SCORE_VALS:uint = 6;
      
      private static const BRONZE_VIDEO_PATH:String = "codo_random_reward_crate_reveal_bronze";
      
      private var mNumUnlocks:uint = 0;
      
      private var mItemsContainer:Sprite;
      
      private var mInitTimer:Timer;
      
      private var mVidPath:String;
      
      private var mItems:Vector.<FsgTrainingRewardsVideoItem>;
      
      public function FsgTrainingRewardsVideoPopupView()
      {
         var d1:ItemObj = null;
         var d2:ItemObj = null;
         var d3:ItemObj = null;
         var data:Vector.<ItemObj> = null;
         super();
         if(!ScaleformUtil.isScaleform)
         {
            this.mNumUnlocks = 3;
            d1 = new ItemObj();
            d2 = new ItemObj();
            d3 = new ItemObj();
            d1.name = "ITEM 1";
            d2.name = "ITEM 2";
            d3.name = "ITEM 3";
            data = new <ItemObj>[d1,d2,d3,d1];
            this.setDataProvider(data);
         }
      }
      
      private function setDataProvider(data:Vector.<ItemObj>) : void
      {
         var i:uint = 0;
         var itemData:ItemObj = null;
         var item:FsgTrainingRewardsVideoItem = null;
         var prevItem:FsgTrainingRewardsVideoItem = null;
         i = 0;
         var star:uint = (data.shift() as ItemObj).level;
         var len:uint = this.mNumUnlocks;
         var cls:Class = fsgTrainingRewardsVideoItem;
         var numRewardsUnlocked:int = this.getNumUnlocks(star);
         var PADDING:uint = 20;
         this.mItemsContainer = addChild(new Sprite()) as Sprite;
         for(this.mItems = new Vector.<FsgTrainingRewardsVideoItem>(0); i < len; )
         {
            itemData = data[i];
            item = this.mItemsContainer.addChild(new cls()) as FsgTrainingRewardsVideoItem;
            item.setData(itemData);
            item.alpha = 0;
            this.mItems[i] = item;
            if(i > 0)
            {
               prevItem = this.mItems[i - 1];
               item.x = prevItem.x + prevItem.width + PADDING;
            }
            item.scoreDisplay = i;
            i++;
         }
         for(i = uint(numRewardsUnlocked); i > 0; i--)
         {
            this.mItems[i - 1].rewardComplete = true;
         }
         this.mItemsContainer.x = (GameInfo.DEFAULT_WIDTH - this.mItemsContainer.width) * 0.5 + OFFSET_WIDTH;
         this.mItemsContainer.y = (GameInfo.DEFAULT_HEIGHT - this.mItemsContainer.height) * 0.5 + OFFSET_HEIGHT;
         var TIMER_DELAY:uint = ScaleformUtil.isScaleform ? 500 : 0;
         this.mInitTimer = new Timer(TIMER_DELAY,1);
         this.mInitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.mInitTimer.start();
      }
      
      private function getNumUnlocks(finalScore:uint) : int
      {
         var unlockNum:int = 0;
         if(finalScore > 0 && finalScore < 3)
         {
            unlockNum = 1;
         }
         else if(finalScore > 2 && finalScore < 5)
         {
            unlockNum = 2;
         }
         else if(finalScore == 5)
         {
            unlockNum = 3;
         }
         return unlockNum;
      }
      
      private function onTimerComplete(e:TimerEvent) : void
      {
         this.mInitTimer.reset();
         this.mInitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         playVideo();
      }
      
      private function onLaunchItems() : void
      {
         var callback:Function;
         var item:FsgTrainingRewardsVideoItem = null;
         var xPos:int = 0;
         var yPos:int = 0;
         var i:uint = 0;
         var len:uint = this.mItems.length;
         var transitionTimeline:TimelineLite = new TimelineLite();
         var tweens:Array = [];
         for(callback = function():void
         {
         }; i < len; )
         {
            if(i == len - 1)
            {
               callback = this.onItemsLanded;
            }
            item = this.mItems[i];
            xPos = item.x;
            yPos = item.y;
            item.scaleX = item.scaleY = 0;
            tweens.push(new TweenLite(item,0.2,{
               "alpha":1,
               "x":xPos,
               "y":yPos,
               "scaleX":1.4,
               "scaleY":1.4,
               "rotationX":720,
               "ease":Linear.easeOut
            }),new TweenLite(item,0.2,{
               "scaleX":1,
               "scaleY":1,
               "ease":Back.easeOut,
               "onComplete":callback
            }));
            i++;
         }
         transitionTimeline.appendMultiple(tweens,0,TweenAlign.SEQUENCE);
      }
      
      private function onItemsLanded() : void
      {
         this.mInitTimer.delay = CLOSE_VIDEO_PAUSE;
         this.mInitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onItemPauseComplete);
         this.mInitTimer.start();
      }
      
      override protected function hideView() : void
      {
         this.dispose();
         super.hideView();
      }
      
      override protected function get videoPath() : String
      {
         return this.mVidPath;
      }
      
      public function dispose() : void
      {
         if(this.mItemsContainer != null)
         {
            removeChild(this.mItemsContainer);
            this.mItems.length = 0;
         }
      }
      
      override public function pauseVideo() : void
      {
         super.pauseVideo();
      }
      
      private function onItemPauseComplete(e:TimerEvent) : void
      {
         var item:FsgTrainingRewardsVideoItem = null;
         var xPos:int = 0;
         var yPos:int = 0;
         var transitionTimeline:TimelineLite = new TimelineLite();
         var tweens:Array = [];
         var i:uint = 0;
         var len:uint = this.mItems.length;
         var SCALE_OUT:Number = 1.7;
         resumeVideo();
         this.mInitTimer.reset();
         this.mInitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onItemPauseComplete);
         this.mInitTimer.delay = CLOSE_VIEW_PAUSE;
         this.mInitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.killView);
         for(this.mInitTimer.start(); i < len; )
         {
            item = this.mItems[i];
            xPos = item.x;
            yPos = item.y;
            if(this.mNumUnlocks > 1)
            {
               if(i == 0)
               {
                  xPos -= OFFSET_WIDTH;
               }
               else if(i == len - 1)
               {
                  xPos += OFFSET_WIDTH;
               }
            }
            tweens.push(new TweenLite(item,0.15,{
               "alpha":0,
               "x":xPos,
               "y":yPos,
               "scaleX":SCALE_OUT,
               "scaleY":SCALE_OUT,
               "ease":Linear.easeOut
            }));
            i++;
         }
         transitionTimeline.appendMultiple(tweens,0,TweenAlign.SEQUENCE);
      }
      
      protected function killView(e:TimerEvent) : void
      {
         this.mInitTimer.reset();
         this.mInitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onVideoComplete);
         if(ScaleformUtil.isScaleform)
         {
            this.mInitTimer = null;
         }
         broadcast(BCInGameEvent.EVT_CLOSE_TRAINING_REWARD_VIDEO_POPUP_PAGE);
      }
      
      override protected function get videoCuePointCallbacks() : Vector.<VideoCuePointObject>
      {
         var initCuePoint:uint = ScaleformUtil.isScaleform ? ITEM_LAUNCH_CUE : 0;
         return new <VideoCuePointObject>[new VideoCuePointObject(ITEM_LAUNCH_CUE,this.onLaunchItems),new VideoCuePointObject(VIDEO_PAUSE_CUE,this.pauseVideo)];
      }
      
      override public function set routeData(data:*) : void
      {
         this.mNumUnlocks = data as uint;
         this.mVidPath = BRONZE_VIDEO_PATH;
         this.dispose();
         this.setDataProvider(OnboardService.getInstance().getTrainEOGUnlocks());
      }
      
      override protected function get videoSize() : Point
      {
         return new Point(1706,960);
      }
      
      override protected function get videoPosition() : Point
      {
         return new Point(-153,0);
      }
   }
}

