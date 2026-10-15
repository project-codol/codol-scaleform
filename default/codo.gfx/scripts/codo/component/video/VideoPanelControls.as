package codo.component.video
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import fsg.shared.BehaviourClickable;
   
   public class VideoPanelControls extends Sprite
   {
      
      private static const AUTO_HIDE_TIME:uint = 3000;
      
      private static const ANIM_SPEED:Number = 0.3;
      
      public static const CONTROL_PLAY_PAUSE:uint = 0;
      
      public static const CONTROL_STOP:uint = 1;
      
      public static const CONTROL_REPLAY:uint = 2;
      
      public static const CONTROL_FULLSCREEN:uint = 3;
      
      public var myPlayPauseBtn:VideoPlaybackButton;
      
      public var myStopBtn:VideoPlaybackButton;
      
      public var myReplayBtn:VideoPlaybackButton;
      
      public var myFullscreenBtn:VideoPlaybackButton;
      
      public var myBkg:Sprite;
      
      private var mControlByType:Vector.<VideoPlaybackButton>;
      
      private var mClickable:BehaviourClickable;
      
      private var mAutoHideTimer:Timer;
      
      public function VideoPanelControls()
      {
         super();
         this.myPlayPauseBtn.controlType = VideoPlaybackButton.ICON_FRAME_PLAY;
         this.myStopBtn.controlType = VideoPlaybackButton.ICON_FRAME_STOP;
         this.myReplayBtn.controlType = VideoPlaybackButton.ICON_FRAME_REPLAY_VIDEO;
         this.myFullscreenBtn.controlType = VideoPlaybackButton.ICON_FRAME_FULLSCREEN;
         this.mControlByType = new <VideoPlaybackButton>[this.myPlayPauseBtn,this.myStopBtn,this.myReplayBtn,this.myFullscreenBtn];
         this.mClickable = new BehaviourClickable(this);
         this.mAutoHideTimer = new Timer(AUTO_HIDE_TIME,1);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
      }
      
      private function onMouseOver() : void
      {
         this.setAutoTimer(false);
         this.showHideControls(true);
      }
      
      private function onMouseOut() : void
      {
         this.setAutoTimer(true);
      }
      
      private function setAutoTimer(restart:Boolean) : void
      {
         this.mAutoHideTimer.reset();
         if(restart)
         {
            this.mAutoHideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
            this.mAutoHideTimer.start();
         }
         else
         {
            this.mAutoHideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         }
      }
      
      private function showHideControls(isShow:Boolean) : void
      {
         var targetAlpha:uint = isShow ? 1 : 0;
         var onComplete:Function = function():void
         {
            if(!isShow)
            {
               this.visible = false;
            }
         };
         TweenLite.to(this,ANIM_SPEED,{
            "alpha":targetAlpha,
            "overwrite":1,
            "onComplete":onComplete
         });
      }
      
      private function onTimerComplete(e:TimerEvent) : void
      {
         this.showHideControls(false);
      }
      
      public function set enable(isEnable:Boolean) : void
      {
         var btn:VideoPlaybackButton = null;
         for each(btn in this.mControlByType)
         {
            btn.enabled = isEnable;
         }
         this.visible = isEnable;
         if(isEnable)
         {
            this.alpha = 0;
            this.setAutoTimer(true);
            this.showHideControls(true);
         }
         else
         {
            this.setAutoTimer(false);
         }
      }
      
      public function getControlByType(type:uint) : VideoPlaybackButton
      {
         return this.mControlByType[type];
      }
   }
}

