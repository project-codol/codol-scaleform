package codo.component.video
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.constants.GameInfo;
   import codo.constants.VideoRender;
   import codo.interfaces.IDisposable;
   import codo.objects.VideoCuePointObject;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import fsg.util.ImageHolderSimple;
   import scaleform.gfx.DisplayObjectEx;
   
   public class VideoPanel extends BaseSubElement implements IDisposable
   {
      
      public static const EVENT_TOGGLE_PLAY_PAUSE_CLICKED:String = "evt_video_play_pause_click";
      
      private static const ANIM_SPEED:Number = 0.3;
      
      private var mVideoCuePointCallback:Vector.<VideoCuePointObject>;
      
      private var mCuePointTimer:Timer;
      
      private var mVideoReadyTimer:Timer;
      
      private var mPendingCuePoint:VideoCuePointObject;
      
      private var mVideoContainer:Sprite;
      
      private var mVideoPath:String;
      
      private var mVideoControls:VideoPanelControls;
      
      private var mPlayPauseBtn:VideoPlaybackButton;
      
      private var mReplayVideoBtn:VideoPlaybackButton;
      
      private var mStopBtn:VideoPlaybackButton;
      
      private var mFullScreenBtn:VideoPlaybackButton;
      
      private var mIsInFullscreen:Boolean = false;
      
      private var mIsPlaying:Boolean = false;
      
      private var mWasPaused:Boolean = false;
      
      private var mStagePos:Point;
      
      private var mVideoControlsBasePos:Point;
      
      private var mLetterBoxOverlay:Sprite;
      
      private var mFullScreenScaleFactor:Number;
      
      private var mOnVideoStopped:Function;
      
      private var mOnVideoClosed:Function;
      
      private var mSetVideoDimensions:Point;
      
      private var mClearButton:CloseButton;
      
      private var mViewIsHandlingKeyESC:Boolean = false;
      
      public var myPlayIconBtn:VideoPlaybackButton;
      
      public var myTogglePlayHitArea:Sprite;
      
      public var myVideoCoverImage:ImageHolderSimple;
      
      public var myScrimHolder:Sprite;
      
      public function VideoPanel()
      {
         super();
         if(!ScaleformUtil.isScaleform)
         {
            this.initVideoPanel(new Point(1280,720),0.4,false);
            this.useLetterBox(false);
            this.active();
         }
      }
      
      public function set fullscreenOffsetPoint(pt:Point) : void
      {
         if(this.mStagePos == null)
         {
            this.mStagePos = pt;
            this.mStagePos = localToGlobal(new Point(this.mVideoContainer.x + this.mStagePos.x,this.mVideoContainer.y + this.mStagePos.y));
         }
      }
      
      private function onVideoCoverFromFileLoaded(e:Event) : void
      {
         this.myVideoCoverImage.removeEventListener(Event.COMPLETE,this.onVideoCoverFromFileLoaded);
         this.myVideoCoverImage.loadedAsset.width = this.mSetVideoDimensions.x;
         this.myVideoCoverImage.loadedAsset.height = this.mSetVideoDimensions.y;
      }
      
      public function set videoCoverFromFile(url:String) : void
      {
         this.myVideoCoverImage.addEventListener(Event.COMPLETE,this.onVideoCoverFromFileLoaded);
         this.myVideoCoverImage.setImage(url);
      }
      
      public function drawScrim() : void
      {
         this.myScrimHolder.graphics.beginFill(0,this.mLetterBoxOverlay.alpha);
         this.myScrimHolder.graphics.drawRect(GameInfo.stagePosition.x - this.x,GameInfo.stagePosition.y - this.y,GameInfo.stageSize.x,GameInfo.stageSize.y);
         this.myScrimHolder.graphics.endFill();
      }
      
      public function set videoCoverImage(image:DisplayObject) : void
      {
         this.myVideoCoverImage.addChild(image);
         this.myVideoCoverImage.visible = true;
         if(this.mSetVideoDimensions != null)
         {
            this.myVideoCoverImage.width = this.mSetVideoDimensions.x;
            this.myVideoCoverImage.height = this.mSetVideoDimensions.y;
         }
      }
      
      public function set onVideoClosedCallback(callback:Function) : void
      {
         this.mOnVideoClosed = callback;
      }
      
      private function handleKeyboardInput(e:KeyboardEvent) : void
      {
         if(e.type == KeyboardEvent.KEY_UP)
         {
            switch(e.keyCode)
            {
               case Keyboard.SPACE:
                  this.playVideo();
                  break;
               case Keyboard.ESCAPE:
                  if(this.mViewIsHandlingKeyESC)
                  {
                     return;
                  }
                  if(this.isFullscreen)
                  {
                     this.toggleFullscreen();
                  }
                  else
                  {
                     this.deactive();
                  }
            }
         }
      }
      
      override public function active() : void
      {
         super.active();
         this.myPlayIconBtn.reset();
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyboardInput,false,0,true);
      }
      
      override public function deactive() : void
      {
         if(this.mOnVideoClosed != null)
         {
            this.mOnVideoClosed();
         }
         super.deactive();
         this.dispose();
      }
      
      public function set onVideoStopped(callback:Function) : void
      {
         this.mOnVideoStopped = callback;
      }
      
      public function set viewIsHandlingKeyESC(isHandlingInput:Boolean) : void
      {
         this.mViewIsHandlingKeyESC = isHandlingInput;
      }
      
      public function get isFullscreen() : Boolean
      {
         return this.mIsInFullscreen;
      }
      
      public function get isVideoPlaying() : Boolean
      {
         return this.mIsPlaying;
      }
      
      public function get currentVideoScale() : Number
      {
         return this.mFullScreenScaleFactor;
      }
      
      public function useLetterBox(useBox:Boolean = false) : void
      {
         this.mLetterBoxOverlay.visible = useBox;
      }
      
      public function initVideoPanel(videoSize:Point, overlayAlpha:Number = 1, useCloseButton:Boolean = true) : void
      {
         videoSize = this.mSetVideoDimensions = videoSize;
         var bitmapData:BitmapData = new BitmapData(videoSize.x,videoSize.y,true,0);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         var tmpScaler:Sprite = addChild(new Sprite()) as Sprite;
         var closeBtnClass:Class = getDefinitionByName("codo.shared.video.VideoPlayerCloseButton") as Class;
         tmpScaler.graphics.beginFill(0);
         tmpScaler.graphics.drawRect(0,0,videoSize.x,videoSize.y);
         tmpScaler.graphics.endFill();
         tmpScaler.width = GameInfo.stageSize.x;
         tmpScaler.height = GameInfo.stageSize.y;
         this.mFullScreenScaleFactor = Math.min(tmpScaler.scaleX,tmpScaler.scaleY);
         removeChild(tmpScaler);
         tmpScaler = null;
         this.mVideoContainer = new Sprite();
         this.mLetterBoxOverlay = addChild(new Sprite()) as Sprite;
         this.mVideoContainer.addChild(bitmap);
         this.mVideoContainer.mouseChildren = false;
         this.mVideoContainer.mouseEnabled = false;
         var videoControlClass:Class = getDefinitionByName("codo.shared.video.VideoPanelControls") as Class;
         this.mVideoControls = addChild(new videoControlClass()) as VideoPanelControls;
         this.mVideoControls.alpha = 0;
         this.mLetterBoxOverlay.graphics.beginFill(0,overlayAlpha);
         var size:Point = ScaleformUtil.isScaleform ? new Point(GameInfo.stageSize.x,GameInfo.stageSize.y) : new Point(GameInfo.gameWidth,GameInfo.gameHeight);
         this.mLetterBoxOverlay.graphics.drawRect(0,0,size.x,size.y);
         this.mLetterBoxOverlay.graphics.endFill();
         this.mLetterBoxOverlay.visible = false;
         addChild(this.mVideoContainer);
         this.mPlayPauseBtn = this.mVideoControls.getControlByType(VideoPanelControls.CONTROL_PLAY_PAUSE);
         this.mPlayPauseBtn.registerClickEvent(this.playVideo);
         this.myPlayIconBtn.registerClickEvent(this.playVideo);
         this.myPlayIconBtn.x = videoSize.x * 0.5;
         this.myPlayIconBtn.y = videoSize.y * 0.5;
         this.mVideoControls.x = videoSize.x * 0.5;
         this.mVideoControls.y = videoSize.y - this.mVideoControls.height;
         this.mVideoControls.enable = false;
         this.mStopBtn = this.mVideoControls.getControlByType(VideoPanelControls.CONTROL_STOP);
         this.mStopBtn.registerClickEvent(this.stopVideo);
         this.mReplayVideoBtn = this.mVideoControls.getControlByType(VideoPanelControls.CONTROL_REPLAY);
         this.mReplayVideoBtn.registerClickEvent(this.replayVideo);
         this.mFullScreenBtn = this.mVideoControls.getControlByType(VideoPanelControls.CONTROL_FULLSCREEN);
         this.mFullScreenBtn.registerClickEvent(this.toggleFullscreen);
         swapChildren(this.mVideoControls,this.mVideoContainer);
         swapChildren(this.mVideoContainer,this.myPlayIconBtn);
         swapChildren(this.mVideoContainer,this.mLetterBoxOverlay);
         swapChildren(this.mLetterBoxOverlay,this.myTogglePlayHitArea);
         this.myTogglePlayHitArea.alpha = 0;
         this.mVideoControlsBasePos = new Point(this.mVideoControls.x,this.mVideoControls.y);
         DisplayObjectEx.setRendererString(this.mVideoContainer,VideoRender.RENDER_NO_ALPHA);
         if(useCloseButton)
         {
            this.mClearButton = addChild(new closeBtnClass()) as CloseButton;
            this.mClearButton.x = videoSize.x - this.mClearButton.width;
            this.mClearButton.y = 0;
            this.mClearButton.registerClickEvent(this.deactive);
         }
      }
      
      public function dispose() : void
      {
         this.stopVideo();
         this.myScrimHolder.graphics.clear();
         this.mWasPaused = this.mIsPlaying = this.mIsInFullscreen = false;
         removeEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.handleKeyboardInput);
      }
      
      public function set videoPath(path:String) : void
      {
         this.mVideoPath = path;
         this.myPlayIconBtn.alpha = 1;
         this.myPlayIconBtn.enabled = true;
      }
      
      public function playVideo(isReplayRequest:Boolean = false) : void
      {
         this.myVideoCoverImage.visible = false;
         if(!this.mIsPlaying)
         {
            this.mVideoCuePointCallback = this.videoCuePointCallbacks;
            if(this.mVideoCuePointCallback.length > 0)
            {
               this.mPendingCuePoint = this.mVideoCuePointCallback.shift();
               this.mCuePointTimer = new Timer(this.mPendingCuePoint.timeMark,1);
               this.mCuePointTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCuePointTimerComplete);
               this.mCuePointTimer.start();
            }
            addEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
            this.mPlayPauseBtn.controlType = VideoPlaybackButton.ICON_FRAME_PAUSE;
            this.myPlayIconBtn.controlType = VideoPlaybackButton.ICON_FRAME_PLAY;
            if(!this.mWasPaused)
            {
               if(!isReplayRequest)
               {
                  if(this.mVideoControls != null)
                  {
                     this.mVideoControls.alpha = 0;
                  }
                  this.setVideoControlsEnabled(true);
               }
               CFunctionCommonContainer.playvideo(this.mVideoPath,false);
            }
            else
            {
               this.resumeVideo();
            }
            this.mIsPlaying = true;
         }
         else
         {
            this.mPlayPauseBtn.controlType = VideoPlaybackButton.ICON_FRAME_PLAY;
            this.myPlayIconBtn.controlType = VideoPlaybackButton.ICON_FRAME_PAUSE;
            this.pauseVideo();
         }
         this.pulsePlayPauseIcon();
      }
      
      private function setVideoControlsEnabled(enable:Boolean) : void
      {
         var onComplete:Function;
         var targetControlsAlpha:uint = 0;
         var targetBtnAlpha:uint = !enable ? 1 : 0;
         targetControlsAlpha = enable ? 1 : 0;
         if(this.mVideoControls == null || this.myPlayIconBtn == null)
         {
            return;
         }
         onComplete = function():void
         {
            if(mVideoControls == null || myPlayIconBtn == null)
            {
               return;
            }
            mVideoControls.enable = enable;
            TweenLite.to(mVideoControls,ANIM_SPEED,{
               "alpha":targetControlsAlpha,
               "overwrite":1
            });
         };
         TweenLite.to(this.myPlayIconBtn,ANIM_SPEED,{
            "alpha":targetBtnAlpha,
            "overwrite":1,
            "onComplete":onComplete
         });
      }
      
      public function pulsePlayPauseIcon() : void
      {
         TweenLite.killTweensOf(this.myPlayIconBtn,true);
         this.myPlayIconBtn.alpha = 1;
         this.myPlayIconBtn.visible = true;
         TweenLite.to(this.myPlayIconBtn,ANIM_SPEED,{
            "autoAlpha":0,
            "overwrite":1,
            "delay":0.4
         });
      }
      
      public function toggleFullscreen() : void
      {
         var stageSize:Point = null;
         var stagePosition:Point = null;
         if(this.mIsInFullscreen)
         {
            this.mFullScreenBtn.controlType = VideoPlaybackButton.ICON_FRAME_FULLSCREEN;
            this.mVideoContainer.scaleY = this.mVideoContainer.scaleX = this.myTogglePlayHitArea.scaleY = this.myTogglePlayHitArea.scaleX = 1;
            this.mIsInFullscreen = false;
            this.mVideoContainer.x = 0;
            this.mVideoContainer.y = 0;
            this.myTogglePlayHitArea.x = 0;
            this.myTogglePlayHitArea.y = 0;
            this.mVideoControls.scaleX = this.mVideoControls.scaleY = 1;
            this.mVideoControls.x = this.mVideoControlsBasePos.x;
            this.mVideoControls.y = this.mVideoControlsBasePos.y;
            this.mLetterBoxOverlay.visible = false;
            this.myVideoCoverImage.width = this.mSetVideoDimensions.x;
            this.myVideoCoverImage.height = this.mSetVideoDimensions.y;
            this.myPlayIconBtn.x = this.mSetVideoDimensions.x * 0.5;
            this.myPlayIconBtn.y = this.mSetVideoDimensions.y * 0.5;
            if(this.mClearButton != null)
            {
               this.mClearButton.scaleX = this.mClearButton.scaleY = 1;
               this.mClearButton.x = this.myVideoCoverImage.width - this.mClearButton.width;
               this.mClearButton.y = 0;
            }
         }
         else
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
            this.mFullScreenBtn.controlType = VideoPlaybackButton.ICON_FRAME_EXIT_FULLSCREEN;
            this.mIsInFullscreen = true;
            this.mLetterBoxOverlay.visible = true;
            this.mVideoContainer.scaleY = this.mVideoContainer.scaleX = this.myTogglePlayHitArea.scaleY = this.myTogglePlayHitArea.scaleX = this.mFullScreenScaleFactor;
            this.mLetterBoxOverlay.x = stagePosition.x - this.mStagePos.x;
            this.mLetterBoxOverlay.y = stagePosition.y - this.mStagePos.y;
            this.mVideoContainer.x = this.myTogglePlayHitArea.x = this.mLetterBoxOverlay.x + (stageSize.x - this.mVideoContainer.width) * 0.5;
            this.mVideoContainer.y = this.myTogglePlayHitArea.y = this.mLetterBoxOverlay.y + (stageSize.y - this.mVideoContainer.height) * 0.5;
            this.mVideoControls.scaleX = this.mVideoControls.scaleY = this.mFullScreenScaleFactor;
            this.mVideoControls.x = stagePosition.x + (stageSize.x - this.mVideoControls.width / 2) * 0.5;
            this.mVideoControls.y = this.mLetterBoxOverlay.y + stageSize.y - this.mVideoControls.height;
            this.myVideoCoverImage.width = stageSize.x;
            this.myVideoCoverImage.height = stageSize.y;
            if(this.mClearButton != null)
            {
               this.mClearButton.scaleX = this.mClearButton.scaleY = 2;
               this.mClearButton.x = this.mVideoContainer.x + (this.mVideoContainer.width - this.mClearButton.width);
               this.mClearButton.y = this.mVideoContainer.y;
            }
         }
      }
      
      public function pauseVideo() : void
      {
         CFunctionCommonContainer.pausevideo();
         this.mIsPlaying = false;
         this.mWasPaused = true;
      }
      
      public function replayVideo() : void
      {
         this.mIsPlaying = this.mWasPaused = false;
         this.stopVideo(true);
         this.mVideoReadyTimer = new Timer(1);
         this.mVideoReadyTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.checkVideoReady);
         this.mVideoReadyTimer.start();
      }
      
      private function checkVideoReady() : void
      {
         if(CFunctionCommonContainer.isvideoplaying() == false)
         {
            this.mVideoReadyTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.checkVideoReady);
            this.mVideoReadyTimer = null;
            this.playVideo(true);
         }
      }
      
      public function stopVideo(isReplayRequest:Boolean = false) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.checkVideoStatus);
         CFunctionCommonContainer.stopvideo();
         this.myVideoCoverImage.x = this.myVideoCoverImage.y = 0;
         if(!isReplayRequest)
         {
            this.myVideoCoverImage.visible = true;
            if(this.mIsInFullscreen)
            {
               this.toggleFullscreen();
            }
            dispatchEvent(new Event(EVENT_TOGGLE_PLAY_PAUSE_CLICKED));
            this.resetVideo();
         }
         this.myPlayIconBtn.visible = true;
         this.myPlayIconBtn.alpha = 1;
         this.myPlayIconBtn.controlType = VideoPlaybackButton.ICON_FRAME_PLAY;
      }
      
      public function resumeVideo() : void
      {
         CFunctionCommonContainer.resumevideo();
      }
      
      public function resetVideo() : void
      {
         if(this.mCuePointTimer != null)
         {
            this.mCuePointTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onCuePointTimerComplete);
            this.mCuePointTimer = null;
         }
         if(this.mOnVideoStopped != null)
         {
            this.mOnVideoStopped();
         }
         this.mIsPlaying = this.mWasPaused = this.mIsInFullscreen = false;
         this.setVideoControlsEnabled(false);
      }
      
      private function onCuePointTimerComplete(e:TimerEvent) : void
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
            this.mCuePointTimer.removeEventListener(TimerEvent.TIMER,this.onCuePointTimerComplete);
            this.mVideoCuePointCallback.length = 0;
            this.mCuePointTimer.reset();
            this.mCuePointTimer = null;
         }
      }
      
      private function checkVideoStatus(e:Event) : void
      {
         if(CFunctionCommonContainer.isvideoplaying() == false && ScaleformUtil.isScaleform)
         {
            this.stopVideo();
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
   }
}

