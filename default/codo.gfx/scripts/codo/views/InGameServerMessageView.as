package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.ChatSpeakerType;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.objects.ChatMessageObj;
   import codo.style.ChatGuide;
   import codo.style.SystemMessageGuide;
   import codo.theme.ITheme;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class InGameServerMessageView extends BaseView
   {
      
      protected static const MESSAGE_TYPE_ANNOUNCEMENT:int = 0;
      
      protected static const MESSAGE_TYPE_BIGLOUDSPEAKER:int = 1;
      
      private static const NONE_SIZE:int = 0;
      
      private static const FULL_SIZE:int = 1;
      
      private static const FRONT_HALF_SIZE:int = 2;
      
      private static const BACK_HALF_SIZE:int = 3;
      
      private static const POS_ORIGIN_X:Number = 398;
      
      private static const POS_ORIGIN_Y:Number = 0;
      
      private static const PIXELS_PER_SECOND:uint = 75;
      
      private static const GAP:uint = 30;
      
      public var myBigLoudSpeakerIcon:MovieClip;
      
      public var myBigLoudSpeakerMask:MovieClip;
      
      public var myBigLoudSpeakerTF:TextField;
      
      public var myAnnouncementMask:MovieClip;
      
      public var myAnnouncementTF:TextField;
      
      protected var _visibleRect:Rectangle;
      
      protected var _defaultArea:Rectangle;
      
      protected var _isInGame:Boolean = true;
      
      protected var _announcement:Array;
      
      private var _currentAnnouncementIndex:int = -1;
      
      protected var _announcementShowing:Boolean = false;
      
      protected var _loudSpeakerShowing:Boolean = false;
      
      protected var _currentSpeakerChatObj:ChatMessageObj;
      
      private var _announcementTweenLite:TweenLite;
      
      private var _loudSpeakerTweenLite:TweenLite;
      
      private var _loudSpeakerTimer:Timer;
      
      private var _heroicTierMessages:Array;
      
      public function InGameServerMessageView()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         var theme:ITheme = null;
         this._heroicTierMessages = new Array();
         this.myAnnouncementTF.textStyle = SystemMessageGuide.styleAnnouncement;
         this.myBigLoudSpeakerTF.textStyle = SystemMessageGuide.styleBigLoudSpeaker;
         if(!this._isInGame)
         {
            theme = getDP(DataID.GET_THEME_SUITE);
            this.myAnnouncementTF.fontColor = theme.getThemeColor();
         }
         x = POS_ORIGIN_X;
         y = POS_ORIGIN_Y;
         this.myBigLoudSpeakerIcon.gotoAndStop(2);
         this._defaultArea = new Rectangle(0,0,484,25);
         this._visibleRect = this._defaultArea;
         this.adjustMaskArea();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         bind(DataCommonID.SERVER_MESSAGES,this.bindShowServerMessages);
         listen(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this.onShowSpeakerHandler);
         broadcast(BCEvent.EVT_SERVER_MESSAGE_VIEW_READY_STATE_CHANGE,true);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataCommonID.SERVER_MESSAGES,this.bindShowServerMessages);
         unlisten(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this.onShowSpeakerHandler);
         broadcast(BCEvent.EVT_SERVER_MESSAGE_VIEW_READY_STATE_CHANGE,false);
      }
      
      private function bindShowServerMessages(cRes:Object) : void
      {
         this._announcement = cRes.data;
         if(this._announcement == null)
         {
            return;
         }
         if(this._announcement.length > 0)
         {
            this.startAnnouncement();
         }
         else
         {
            this.endAnnouncement();
         }
      }
      
      protected function startAnnouncement() : void
      {
         var startX:int = 0;
         var endX:int = 0;
         var tweenSpeed:Number = NaN;
         if(this._announcement == null || this._announcement.length <= 0)
         {
            return;
         }
         this.myAnnouncementTF.visible = true;
         this._announcementShowing = true;
         ++this._currentAnnouncementIndex;
         if(this._currentAnnouncementIndex >= this._announcement.length)
         {
            this._currentAnnouncementIndex = 0;
         }
         this.adjustMaskArea();
         var timer:Timer = this._announcement[this._currentAnnouncementIndex].timer;
         if(timer != null)
         {
            timer.start();
            this.myAnnouncementTF.text = this._announcement[this._currentAnnouncementIndex].message;
            if(null == this._announcementTweenLite || !this._announcementTweenLite.active)
            {
               startX = this.myAnnouncementMask.x + this.myAnnouncementMask.width;
               endX = this.myAnnouncementMask.x - this.myAnnouncementTF.textWidth;
               this.myAnnouncementTF.x = startX;
               tweenSpeed = Math.abs(endX - startX) / PIXELS_PER_SECOND;
               this._announcementTweenLite = TweenLite.to(this.myAnnouncementTF,tweenSpeed,{
                  "x":endX,
                  "ease":Linear.easeNone,
                  "onUpdate":this.checkAnnPosition,
                  "onComplete":this.startAnnouncement
               });
            }
         }
         else
         {
            this.endAnnouncement();
         }
      }
      
      protected function endAnnouncement() : void
      {
         this._announcementShowing = false;
         this._currentAnnouncementIndex = -1;
         this.myAnnouncementTF.visible = false;
         this.adjustMaskArea();
      }
      
      private function checkAnnPosition() : void
      {
         var endX:int = this.myAnnouncementMask.x - this.myAnnouncementTF.textWidth;
         if(this.myAnnouncementTF.x < endX)
         {
            this._announcementTweenLite.kill();
            this.startAnnouncement();
         }
         this.switchVisibleAllElement(this._announcementShowing,this._loudSpeakerShowing);
      }
      
      private function onShowSpeakerHandler(cEvt:ParaEvent) : void
      {
         var duration:int = 0;
         if(cEvt.myPara.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            this._currentSpeakerChatObj = cEvt.myPara;
            this._loudSpeakerShowing = true;
            this.myBigLoudSpeakerIcon.gotoAndStop(ChatGuide.BIG_SPEAKER_ICON_FRAME);
            duration = getDP(DataCommonID.BIG_LOUD_SPEAKER_SHOW_DURATION) * 1000;
            this.resetShowTimer();
            this._loudSpeakerTimer = new Timer(duration);
            this._loudSpeakerTimer.addEventListener(TimerEvent.TIMER,this.onShowSpeakerDurationEnd);
            this._loudSpeakerTimer.start();
            this.startLoudSpeaker();
         }
         else if(cEvt.myPara.loudSpeakerType == ChatSpeakerType.HEROIC_TIER_NOTIFICATION)
         {
            this._currentSpeakerChatObj = cEvt.myPara;
            this._loudSpeakerShowing = true;
            this.myBigLoudSpeakerIcon.gotoAndStop(ChatGuide.HEROIC_TIER_ICON_FRAME);
            duration = getDP(DataCommonID.HEROIC_TIER_SHOW_DURATION) * 1000;
            this.resetShowTimer();
            this._loudSpeakerTimer = new Timer(duration);
            this._loudSpeakerTimer.addEventListener(TimerEvent.TIMER,this.onShowSpeakerDurationEnd);
            this._loudSpeakerTimer.start();
            this.startLoudSpeaker();
         }
      }
      
      protected function startLoudSpeaker() : void
      {
         var rollSpeed:int = 0;
         this.adjustMaskArea();
         this.myBigLoudSpeakerTF.visible = true;
         if(this._currentSpeakerChatObj.loudSpeakerType == ChatSpeakerType.HEROIC_TIER_NOTIFICATION)
         {
            this.myBigLoudSpeakerTF.text = this._currentSpeakerChatObj.message;
         }
         else
         {
            this.myBigLoudSpeakerTF.text = this._currentSpeakerChatObj.senderName + ":" + this._currentSpeakerChatObj.message;
         }
         var startX:int = this.myBigLoudSpeakerMask.x + this.myBigLoudSpeakerMask.width;
         var endX:int = this.myBigLoudSpeakerMask.x - this.myBigLoudSpeakerTF.textWidth;
         this.myBigLoudSpeakerTF.x = startX;
         if(this._currentSpeakerChatObj.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            rollSpeed = getDP(DataCommonID.BIG_LOUD_SPEAKER_ROLL_SPEED);
         }
         else if(this._currentSpeakerChatObj.loudSpeakerType == ChatSpeakerType.HEROIC_TIER_NOTIFICATION)
         {
            rollSpeed = getDP(DataCommonID.HEROIC_TIER_ROLL_SPEED);
         }
         var tweenSpeed:Number = Math.abs(endX - startX) / rollSpeed;
         if(Boolean(this._loudSpeakerTweenLite))
         {
            this._loudSpeakerTweenLite.kill();
            this._loudSpeakerTweenLite = null;
         }
         this._loudSpeakerTweenLite = TweenLite.to(this.myBigLoudSpeakerTF,tweenSpeed,{
            "x":endX,
            "ease":Linear.easeNone,
            "onComplete":this.startLoudSpeaker,
            "onUpdate":this.onLoudSpeakerRoll
         });
      }
      
      private function onShowSpeakerDurationEnd(e:TimerEvent) : void
      {
         this.resetShowTimer();
         var isHeroicTierNotification:Boolean = this._currentSpeakerChatObj.loudSpeakerType == ChatSpeakerType.HEROIC_TIER_NOTIFICATION;
         this._currentSpeakerChatObj = null;
         this._loudSpeakerShowing = false;
         this.endLoudSpeaker();
         if(this._isInGame || isHeroicTierNotification)
         {
            broadcast(BCCommonEvent.EVT_HIDE_SPEAKER_ANIMATION);
         }
      }
      
      private function resetShowTimer() : void
      {
         if(this._loudSpeakerTimer != null)
         {
            this._loudSpeakerTimer.stop();
            this._loudSpeakerTimer.removeEventListener(TimerEvent.TIMER,this.onShowSpeakerDurationEnd);
            this._loudSpeakerTimer = null;
         }
      }
      
      private function onLoudSpeakerRoll() : void
      {
         this.myBigLoudSpeakerIcon.x = this.myBigLoudSpeakerTF.x - this.myBigLoudSpeakerIcon.width;
         var endX:int = this.myBigLoudSpeakerMask.x - this.myBigLoudSpeakerTF.textWidth;
         if(this.myBigLoudSpeakerTF.x < endX)
         {
            this._loudSpeakerTweenLite.kill();
            this._loudSpeakerTweenLite = null;
            this.startLoudSpeaker();
         }
         this.switchVisibleAllElement(this._announcementShowing,this._loudSpeakerShowing);
      }
      
      protected function endLoudSpeaker() : void
      {
         this.adjustMaskArea();
         if(this._loudSpeakerTweenLite != null)
         {
            this._loudSpeakerTweenLite.kill();
            this._loudSpeakerTweenLite = null;
            this.myBigLoudSpeakerIcon.visible = false;
            this.myBigLoudSpeakerTF.visible = false;
         }
      }
      
      protected function adjustMaskArea() : void
      {
         if(this._announcementShowing && this._loudSpeakerShowing)
         {
            this.realAdjustMaskArea(MESSAGE_TYPE_ANNOUNCEMENT,FRONT_HALF_SIZE);
            this.realAdjustMaskArea(MESSAGE_TYPE_BIGLOUDSPEAKER,BACK_HALF_SIZE);
         }
         else if(this._announcementShowing && !this._loudSpeakerShowing)
         {
            this.realAdjustMaskArea(MESSAGE_TYPE_ANNOUNCEMENT,FULL_SIZE);
            this.realAdjustMaskArea(MESSAGE_TYPE_BIGLOUDSPEAKER,NONE_SIZE);
         }
         else if(!this._announcementShowing && this._loudSpeakerShowing)
         {
            this.realAdjustMaskArea(MESSAGE_TYPE_ANNOUNCEMENT,NONE_SIZE);
            this.realAdjustMaskArea(MESSAGE_TYPE_BIGLOUDSPEAKER,FULL_SIZE);
         }
         else if(!this._announcementShowing && !this._loudSpeakerShowing)
         {
            this.realAdjustMaskArea(MESSAGE_TYPE_ANNOUNCEMENT,NONE_SIZE);
            this.realAdjustMaskArea(MESSAGE_TYPE_BIGLOUDSPEAKER,NONE_SIZE);
         }
         this.switchVisibleAllElement(this._announcementShowing,this._loudSpeakerShowing);
      }
      
      public function realAdjustMaskArea(index:int, sizeType:int) : void
      {
         var curMask:MovieClip = index == MESSAGE_TYPE_ANNOUNCEMENT ? this.myAnnouncementMask : this.myBigLoudSpeakerMask;
         if(sizeType == NONE_SIZE)
         {
            curMask.width = 0;
            curMask.height = this._visibleRect.height;
         }
         else if(sizeType == FULL_SIZE)
         {
            curMask.x = this._visibleRect.x;
            curMask.y = this._visibleRect.y;
            curMask.width = this._visibleRect.width;
            curMask.height = this._visibleRect.height;
         }
         else if(sizeType == FRONT_HALF_SIZE)
         {
            curMask.x = this._visibleRect.x;
            curMask.y = this._visibleRect.y;
            curMask.width = this._visibleRect.width / 2 - GAP;
            curMask.height = this._visibleRect.height;
         }
         else if(sizeType == BACK_HALF_SIZE)
         {
            curMask.x = this._visibleRect.width / 2 + this._visibleRect.x;
            curMask.y = this._visibleRect.y;
            curMask.width = this._visibleRect.width / 2 + GAP;
            curMask.height = this._visibleRect.height;
         }
      }
      
      private function switchVisibleAllElement(announcementVisible:Boolean, speakerVisible:Boolean) : void
      {
         this.myAnnouncementMask.visible = this.myAnnouncementTF.visible = announcementVisible;
         this.myBigLoudSpeakerMask.visible = this.myBigLoudSpeakerIcon.visible = this.myBigLoudSpeakerTF.visible = speakerVisible;
         if(this._isInGame)
         {
            visible = (announcementVisible || speakerVisible) && Boolean(CFunctionInGameContainer.ShouldDrawHUD());
         }
      }
   }
}

