package fsg.shared
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.GameInfo;
   import codo.constants.VideoRender;
   import codo.objects.VideoCuePointObject;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import scaleform.gfx.DisplayObjectEx;
   
   public class VideoDisplayBaseView extends BaseView
   {
      
      private var mVideoCuePointCallback:Vector.<VideoCuePointObject>;
      
      private var mCuePointTimer:Timer;
      
      private var mPendingCuePoint:VideoCuePointObject;
      
      protected var mVideoContainer:Sprite;
      
      public function VideoDisplayBaseView()
      {
         super();
         var containerPosition:Point = this.videoPosition;
         var videoSize:Point = this.videoSize;
         this.mVideoContainer = new Sprite();
         this.mVideoContainer.x = containerPosition.x;
         this.mVideoContainer.y = containerPosition.y;
         var bitmapData:BitmapData = new BitmapData(videoSize.x,videoSize.y,true,0);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         this.mVideoContainer.addChild(bitmap);
         this.mVideoContainer.mouseChildren = false;
         this.mVideoContainer.mouseEnabled = false;
         addChild(this.mVideoContainer);
         DisplayObjectEx.setRendererString(this.mVideoContainer,VideoRender.RENDER_WITH_ALPHA);
      }
      
      public function playVideo() : void
      {
         this.mVideoCuePointCallback = this.videoCuePointCallbacks;
         if(this.mVideoCuePointCallback.length > 0)
         {
            this.mPendingCuePoint = this.mVideoCuePointCallback.shift();
            this.mCuePointTimer = new Timer(this.mPendingCuePoint.timeMark,1);
            this.mCuePointTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.mCuePointTimer.start();
         }
         addEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
         CFunctionCommonContainer.playvideo(this.videoPath,this.loopVideo);
      }
      
      public function pauseVideo() : void
      {
         CFunctionCommonContainer.pausevideo();
      }
      
      public function stopVideo() : void
      {
         CFunctionCommonContainer.stopvideo();
      }
      
      public function resumeVideo() : void
      {
         CFunctionCommonContainer.resumevideo();
      }
      
      override protected function hideView() : void
      {
         this.clearCuePoints();
         super.hideView();
      }
      
      private function onTimerComplete(e:TimerEvent) : void
      {
         this.mCuePointTimer.reset();
         this.mPendingCuePoint.callback();
         if(this.mVideoCuePointCallback.length > 0)
         {
            this.mPendingCuePoint = this.mVideoCuePointCallback.shift();
            this.mCuePointTimer.delay = this.mPendingCuePoint.timeMark;
            this.mCuePointTimer.start();
         }
         else
         {
            this.clearCuePoints();
         }
      }
      
      private function clearCuePoints() : void
      {
         if(this.mCuePointTimer != null)
         {
            this.mCuePointTimer.removeEventListener(TimerEvent.TIMER,this.onTimerComplete);
            this.mVideoCuePointCallback.length = 0;
            this.mCuePointTimer.reset();
            this.mCuePointTimer = null;
         }
      }
      
      private function checkVideoStatus(e:Event) : void
      {
         if(CFunctionCommonContainer.isvideoplaying() == false)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
            CFunctionCommonContainer.stopvideo();
            this.onVideoComplete();
         }
      }
      
      protected function get videoLengthInMilliseconds() : Number
      {
         var BINK_FPS:uint = 30;
         return this.videoFrameCount / BINK_FPS * 1000;
      }
      
      protected function get videoCuePointCallbacks() : Vector.<VideoCuePointObject>
      {
         return new Vector.<VideoCuePointObject>(0);
      }
      
      protected function get videoFrameCount() : uint
      {
         return 0;
      }
      
      protected function onVideoComplete() : void
      {
      }
      
      protected function get loopVideo() : Boolean
      {
         return false;
      }
      
      protected function get videoPath() : String
      {
         return null;
      }
      
      protected function get videoPosition() : Point
      {
         return new Point(0,0);
      }
      
      protected function get videoSize() : Point
      {
         return new Point(GameInfo.gameWidth,GameInfo.gameHeight);
      }
   }
}

