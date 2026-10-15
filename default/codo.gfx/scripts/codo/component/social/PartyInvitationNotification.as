package codo.component.social
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.DictInvitation;
   import codo.localization.DictParty;
   import codo.localization.DictSystem;
   import codo.objects.PartyInvitationObj;
   import codo.style.GlobalGuide;
   import codo.style.SystemMessageGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class PartyInvitationNotification extends BaseNotification
   {
      
      public var myTitle:TextField;
      
      public var myInviterName:TextField;
      
      public var myDescription:TextField;
      
      public var myBg:MovieClip;
      
      private var mCurrentInvitation:PartyInvitationObj;
      
      private var mTimer:Timer;
      
      private var mRemainSecond:uint;
      
      private var mTotalSecond:uint;
      
      public function PartyInvitationNotification()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myTitle.text = DictInvitation.INVITE_PARTY;
         myRejectBtn.width = myBlockBtn.width = this.myBg.width * GlobalGuide.GOLDEN_RATIO / 2;
         myAcceptBtn.width = this.myBg.width - myRejectBtn.width - myBlockBtn.width;
         myAcceptBtn.height = myRejectBtn.height = myBlockBtn.height = SystemMessageGuide.BUTTON_HEIGHT;
         myBlockBtn.x = 0;
         myRejectBtn.x = myBlockBtn.x + myBlockBtn.width;
         myAcceptBtn.x = myRejectBtn.x + myRejectBtn.width;
         myAcceptBtn.label = DictSystem.ACCEPT;
         myRejectBtn.label = DictSystem.REFUSE;
         myBlockBtn.label = DictSystem.BLOCK;
         this.myDescription.text = DictParty.PARTY_INVITATION_DESC;
         this.mTimer = new Timer(1000);
         myAcceptBtn.setLabelFontSize(GlobalGuide.FONT_SIZE_SMALL);
         myRejectBtn.setLabelFontSize(GlobalGuide.FONT_SIZE_SMALL);
         myBlockBtn.setLabelFontSize(GlobalGuide.FONT_SIZE_SMALL);
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.mCurrentInvitation = mData as PartyInvitationObj;
         this.showCurrentInvitation();
      }
      
      private function showCurrentInvitation() : void
      {
         this.myInviterName.text = this.mCurrentInvitation.senderName;
         var serverTime:uint = CFunctionCommonContainer.GetServerTimeStamp();
         var expireTime:uint = this.mCurrentInvitation.expireTime;
         var receiveTime:uint = this.mCurrentInvitation.timeStamp;
         this.mRemainSecond = expireTime - serverTime;
         this.mTotalSecond = expireTime - receiveTime;
         this.showCountDownTime();
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimerTicked);
         this.mTimer.start();
      }
      
      private function onTimerTicked(e:TimerEvent) : void
      {
         --this.mRemainSecond;
         this.showCountDownTime();
         if(this.mRemainSecond <= 0)
         {
            this.mTimer.reset();
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.onTimerTicked);
         }
      }
      
      private function showCountDownTime() : void
      {
         var para:Array = [LocalizeUtil.localize(DictSystem.ACCEPT),"[" + String(this.mRemainSecond) + "]"];
         LocalizeUtil.paramCustomizeFormat(myAcceptBtn.myLabel.myTextClip,DictParty.ACCEPT_BTN_COUNTDOWN,para,this.acceptLabelFormatter);
      }
      
      private function acceptLabelFormatter(tfm:TextFormat, paraIndex:int) : void
      {
         if(paraIndex == 0)
         {
            tfm.font = GlobalGuide.FONT_FACE_BOLD;
            tfm.size = GlobalGuide.FONT_SIZE_SMALL;
         }
         if(paraIndex == 1)
         {
            tfm.font = GlobalGuide.FONT_FACE_NUMBERS;
            tfm.size = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
            tfm.bold = true;
         }
      }
   }
}

