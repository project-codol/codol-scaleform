package codo.views.party_parts
{
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.social.PlayerActionButton;
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.localization.DictParty;
   import codo.objects.PlayerNameSettings;
   import codo.style.GlobalGuide;
   import codo.style.PartyGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class MemberItemForParty extends UIInteractiveComponent
   {
      
      private static const TIMER_CHECK_INTERVAL:int = 100;
      
      public var myLeaderTag:MovieClip;
      
      public var myPlayerName:PlayerName;
      
      public var myPlayerActionButton:PlayerActionButton;
      
      public var myMiniClientTag:TextField;
      
      public var myBackground:MovieClip;
      
      public var myCountDown:TextField;
      
      public var myWaitingTag:MovieClip;
      
      private var mExpireTime:Number;
      
      private var mCurrentTime:Number;
      
      private var mTimer:Timer;
      
      public function MemberItemForParty()
      {
         super();
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = 18;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
         nameSetting.textWidth = 300;
         nameSetting.textHeight = 25;
         this.myPlayerName.settings = nameSetting;
         this.myMiniClientTag.textStyle = PartyGuide.styleMiniClientTag;
         this.myMiniClientTag.text = Dict.MINI_CLIENT;
         this.myCountDown.textStyle = PartyGuide.styleInviteCountDown;
         this.myCountDown.width = 105;
         this.mTimer = new Timer(TIMER_CHECK_INTERVAL);
      }
      
      override public function setData(data:*) : void
      {
         if(null == data)
         {
            return;
         }
         super.setData(data);
         this.myPlayerName.setData(data.name,data.id);
         this.myPlayerActionButton.setNameAndID(data.name,data.id);
         if(data["expireTime"] == null)
         {
            this.myLeaderTag.visible = data.isHost;
            this.myCountDown.visible = false;
            this.myWaitingTag.visible = false;
            this.myPlayerActionButton.visible = true;
            this.myPlayerName.x = 84;
         }
         else
         {
            this.myLeaderTag.visible = false;
            this.myCountDown.visible = true;
            this.myWaitingTag.visible = true;
            this.myPlayerActionButton.visible = false;
            this.myPlayerName.x = 34;
            this.mExpireTime = data.expireTime;
            this.mCurrentTime = data.serverTime;
            this.kickOffCountDownTimer();
         }
         this.myMiniClientTag.x = this.myPlayerName.x + this.myPlayerName.width + 5;
         this.myMiniClientTag.visible = data.isMiniClient;
         this.myLeaderTag.visible = data.isHost;
      }
      
      private function kickOffCountDownTimer() : void
      {
         this.mTimer.reset();
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTickTimer);
         this.mTimer.start();
         this.onTickTimer(null);
      }
      
      private function onTickTimer(e:TimerEvent) : void
      {
         this.mCurrentTime += TIMER_CHECK_INTERVAL / 1000;
         var remainSecond:int = Math.ceil(this.mExpireTime - this.mCurrentTime);
         if(remainSecond <= 0)
         {
            remainSecond = 0;
            this.mTimer.reset();
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.onTickTimer);
         }
         LocalizeUtil.paramFont(this.myCountDown.myTextClip,DictParty.PARTY_INVITING_COUNTDOWN,[String(remainSecond)],[GameInfo.GAME_FONT_AENCY_FB]);
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
   }
}

