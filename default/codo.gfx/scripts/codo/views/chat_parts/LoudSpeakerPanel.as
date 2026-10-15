package codo.views.chat_parts
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.component.social.TextArea;
   import codo.constants.BCEvent;
   import codo.constants.ChatSpeakerType;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictChatting;
   import codo.objects.InputBoxSettings;
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class LoudSpeakerPanel extends BaseSubElement
   {
      
      private static const SHOW_Y:int = -340;
      
      private static const PANEL_WIDTH:int = 406;
      
      private static const PANEL_HEIGHT:int = 355;
      
      public var myTitle:TextField;
      
      public var myTextLeftRemainder:TextField;
      
      public var myInputArea:TextArea;
      
      public var mySendBtn:Button;
      
      public var myCancelBtn:Button;
      
      public var myRemainText:TextField;
      
      public var myIcon:MovieClip;
      
      public var myContentContainer:ContentContainer;
      
      private var mType:int;
      
      private var mTextCount:int;
      
      private var mBigLoudSpeakerCoolDownTimer:Timer;
      
      private var mSmallLoudSpeakerCoolDownTimer:Timer;
      
      private var mBigLoudSpeakerCoolDownSecond:int;
      
      private var mSmallLoudSpeakerCoolDownSecond:int;
      
      public function LoudSpeakerPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         y = SHOW_Y;
         this.myContentContainer.hudMode();
         this.myContentContainer.width = PANEL_WIDTH;
         this.myContentContainer.height = PANEL_HEIGHT;
         var setting:InputBoxSettings = new InputBoxSettings();
         setting.textValidator = this.textCounter;
         setting.width = 360;
         setting.height = 180;
         setting.hasBg = false;
         setting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myInputArea.settings = setting;
         this.myInputArea.text = "";
         this.myTextLeftRemainder.textStyle = ChatGuide.styleInputCharacterRemain;
         this.myTextLeftRemainder.text = LocalizeUtil.param(DictChatting.INPUT_TEXT_REMAIN,[0]);
         this.myCancelBtn.label = Dict.CANCEL;
         this.mySendBtn.label = DictChatting.SEND_MESSAGE;
         this.myCancelBtn.width = 108;
         this.myCancelBtn.height = 36;
         this.mySendBtn.width = 108;
         this.mySendBtn.height = 36;
         this.myRemainText.textStyle = ChatGuide.styleLoudSpeakerRemain;
         this.mySendBtn.registerClickEvent(this.onSendCallback);
         this.myCancelBtn.registerClickEvent(this.onCancelCallback);
         this.mBigLoudSpeakerCoolDownTimer = new Timer(1000);
         this.mSmallLoudSpeakerCoolDownTimer = new Timer(1000);
         this.mBigLoudSpeakerCoolDownTimer.addEventListener(TimerEvent.TIMER,this.onBigLoudSpeakerCoolDownTimer);
         this.mSmallLoudSpeakerCoolDownTimer.addEventListener(TimerEvent.TIMER,this.onSmallLoudSpeakerCoolDownTimer);
         this.mBigLoudSpeakerCoolDownSecond = getDP(DataID.BIG_LOUD_SPEAKER_COOLDOWN);
         this.mSmallLoudSpeakerCoolDownSecond = getDP(DataID.SMALL_LOUD_SPEAKER_COOLDOWN);
         this.myTitle.textStyle = ChatGuide.styleTitle;
      }
      
      public function setLoudSpeakerType(type:int) : void
      {
         var str:String = null;
         this.mType = type;
         var maxCharacterCount:int = 0;
         if(type == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            this.myTitle.text = DictChatting.BIG_LOUD_SPEAKER;
            this.myIcon.gotoAndStop(ChatGuide.BIG_SPEAKER_ICON_FRAME);
            this.myRemainText.text = LocalizeUtil.param(DictChatting.LOUD_SPEAKER_COUNT,[getDP(DataID.BIG_LOUD_SPEAKER_COUNT)]);
            maxCharacterCount = getDP(DataID.BIG_LOUD_SPEAKER_MESSAGE_LEN);
         }
         else
         {
            this.myTitle.text = DictChatting.SMALL_LOUD_SPEAKER;
            this.myIcon.gotoAndStop(ChatGuide.SMALL_SPEAKER_ICON_FRAME);
            this.myRemainText.text = LocalizeUtil.param(DictChatting.LOUD_SPEAKER_COUNT,[getDP(DataID.SMALL_LOUD_SPEAKER_COUNT)]);
            maxCharacterCount = getDP(DataID.SMALL_LOUD_SPEAKER_MESSAGE_LEN);
         }
         if(!this.textCounter(this.myInputArea.text))
         {
            str = this.myInputArea.text;
            this.myInputArea.text = str.substr(0,maxCharacterCount);
            this.textCounter(this.myInputArea.text);
         }
      }
      
      public function updateLoudSpeakerCount(type:int, count:int) : void
      {
         if(type == this.mType)
         {
            this.myRemainText.text = LocalizeUtil.param(DictChatting.LOUD_SPEAKER_COUNT,[count]);
         }
      }
      
      private function textCounter(text:String) : Boolean
      {
         if(text.indexOf("\n") != -1)
         {
            return false;
         }
         var maxCharacterCount:int = 0;
         if(this.mType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            maxCharacterCount = getDP(DataID.BIG_LOUD_SPEAKER_MESSAGE_LEN);
         }
         else
         {
            maxCharacterCount = getDP(DataID.SMALL_LOUD_SPEAKER_MESSAGE_LEN);
         }
         var textCount:int = text.length;
         this.mTextCount = textCount;
         this.updateSendButton();
         if(textCount <= maxCharacterCount)
         {
            this.myTextLeftRemainder.text = LocalizeUtil.param(DictChatting.INPUT_TEXT_REMAIN,[maxCharacterCount - textCount]);
            return true;
         }
         return false;
      }
      
      private function onSendCallback() : void
      {
         broadcast(BCEvent.EVT_SEND_LOUD_SPEAKER,{
            "type":this.mType,
            "message":this.myInputArea.text
         });
         this.deactive();
      }
      
      private function onCancelCallback() : void
      {
         this.deactive();
      }
      
      override public function active() : void
      {
         TweenLite.to(this,0.2,{
            "y":SHOW_Y,
            "autoAlpha":1
         });
      }
      
      override public function deactive() : void
      {
         TweenLite.to(this,0.2,{
            "y":68,
            "autoAlpha":0
         });
      }
      
      private function updateSendButton() : void
      {
         var btnEnable:Boolean = true;
         btnEnable = this.mTextCount > 0;
         var coolDownRemaining:int = 0;
         if(this.mType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            btnEnable &&= !this.mBigLoudSpeakerCoolDownTimer.running;
            coolDownRemaining = this.mBigLoudSpeakerCoolDownSecond - this.mBigLoudSpeakerCoolDownTimer.currentCount;
         }
         else if(this.mType == ChatSpeakerType.SPEAKER_TYPE_SMALL)
         {
            btnEnable &&= !this.mSmallLoudSpeakerCoolDownTimer.running;
            coolDownRemaining = this.mSmallLoudSpeakerCoolDownSecond - this.mSmallLoudSpeakerCoolDownTimer.currentCount;
         }
         this.mySendBtn.enabled = btnEnable;
         this.mySendBtn.alpha = btnEnable ? 1 : 0.5;
         var buttonLabel:String = LocalizeUtil.localize(DictChatting.SEND_MESSAGE);
         if(this.mType == ChatSpeakerType.SPEAKER_TYPE_BIG && this.mBigLoudSpeakerCoolDownTimer.running)
         {
            buttonLabel += String(coolDownRemaining);
         }
         else if(this.mType == ChatSpeakerType.SPEAKER_TYPE_SMALL && this.mSmallLoudSpeakerCoolDownTimer.running)
         {
            buttonLabel += String(coolDownRemaining);
         }
         this.mySendBtn.label = buttonLabel;
      }
      
      public function sendLoudSpeakerSuccess(loudSpeakerType:int) : void
      {
         if(loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            this.mBigLoudSpeakerCoolDownTimer.reset();
            this.mBigLoudSpeakerCoolDownTimer.start();
         }
         else if(loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_SMALL)
         {
            this.mSmallLoudSpeakerCoolDownTimer.reset();
            this.mSmallLoudSpeakerCoolDownTimer.start();
         }
         this.updateSendButton();
      }
      
      private function onBigLoudSpeakerCoolDownTimer(e:Event) : void
      {
         if(this.mBigLoudSpeakerCoolDownTimer.currentCount >= this.mBigLoudSpeakerCoolDownSecond)
         {
            this.mBigLoudSpeakerCoolDownTimer.stop();
         }
         this.updateSendButton();
      }
      
      private function onSmallLoudSpeakerCoolDownTimer(e:Event) : void
      {
         if(this.mSmallLoudSpeakerCoolDownTimer.currentCount >= this.mSmallLoudSpeakerCoolDownSecond)
         {
            this.mSmallLoudSpeakerCoolDownTimer.stop();
         }
         this.updateSendButton();
      }
   }
}

