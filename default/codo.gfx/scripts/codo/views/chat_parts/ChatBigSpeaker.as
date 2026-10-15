package codo.views.chat_parts
{
   import codo.component.CloseButton;
   import codo.component.TextField;
   import codo.constants.ChatSpeakerType;
   import codo.style.ChatGuide;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ChatBigSpeaker extends MovieClip
   {
      
      private static const ANIMATE_FROM_X:int = 710;
      
      private static const ANIMATE_TO_X:int = 337;
      
      private static const ANIMATE_DURATION:Number = 0.2;
      
      private static const ICON_X:int = 36;
      
      private static const ICON_Y:int = 36;
      
      private static const ICON_WIDTH:int = 48;
      
      private static const ICON_HEIGHT:int = 48;
      
      private static const BG_HEIGHT:int = 70;
      
      private static const BG_SHRINK_HEIGHT:int = 24;
      
      private static const ICON_SHRINK_WIDTH:int = 20;
      
      private static const ICON_SHRINK_HEIGHT:int = 20;
      
      public var myIcon:MovieClip;
      
      public var myUserName:TextField;
      
      public var myMessage:TextField;
      
      public var myBlueLine:MovieClip;
      
      public var myBg:MovieClip;
      
      public var myCloseBtn:CloseButton;
      
      public var myShine:MovieClip;
      
      private var mShowDuration:int = 0;
      
      private var mAnimateTimeLine:TimelineLite;
      
      private var mShowAnimationCompleteHandler:Function;
      
      public function ChatBigSpeaker()
      {
         super();
         this.mAnimateTimeLine = new TimelineLite();
         this.myCloseBtn.registerClickEvent(this.onCloseClicked);
         this.myIcon.myIcon.gotoAndStop(ChatGuide.BIG_SPEAKER_ICON_FRAME);
         this.myBlueLine.visible = false;
      }
      
      public function registerShowAnimationCompleteHandler(callback:Function) : void
      {
         this.mShowAnimationCompleteHandler = callback;
      }
      
      public function showMessage(type:int, senderName:String, msg:String, duration:int) : void
      {
         var frame:int = 0;
         this.myShine.visible = true;
         visible = true;
         alpha = 1;
         this.myIcon.x = ICON_X;
         this.myIcon.y = ICON_Y;
         this.myIcon.width = ICON_WIDTH;
         this.myIcon.height = ICON_HEIGHT;
         if(type == ChatSpeakerType.SPEAKER_TYPE_SMALL)
         {
            frame = ChatGuide.SMALL_SPEAKER_ICON_FRAME;
         }
         else
         {
            frame = ChatGuide.BIG_SPEAKER_ICON_FRAME;
         }
         this.myIcon.myIcon.gotoAndStop(frame);
         this.myUserName.width = 180;
         this.myUserName.textStyle = ChatGuide.styleBigLoudSpeakerSender;
         this.myUserName.enableTruncate(true);
         this.myUserName.x = 75;
         this.myUserName.y = 20;
         this.myBg.height = BG_HEIGHT;
         this.myMessage.x = this.myUserName.x + this.myUserName.width + 2;
         this.myMessage.y = 20;
         this.myMessage.textStyle = ChatGuide.styleBigLoudSpeakerMessage;
         this.myMessage.width = ChatGuide.BIG_LOUD_SPEAKER_MESSAGE_WIDTH;
         this.myMessage.height = ChatGuide.BIG_LOUD_SPEAKER_MESSAGE_HEIGHT;
         this.myMessage.enableTruncate(false);
         this.myCloseBtn.visible = true;
         this.myIcon.gotoAndStop(1);
         this.myUserName.text = senderName;
         this.middleText(this.myUserName);
         this.myMessage.text = msg;
         this.middleText(this.myMessage);
         this.mShowDuration = duration;
         this.playAppearAnimation();
      }
      
      private function playAppearAnimation() : void
      {
         x = ANIMATE_FROM_X;
         this.myBlueLine.y = this.myBg.y + this.myBg.height;
         if(this.mAnimateTimeLine != null)
         {
            this.mAnimateTimeLine.clear();
         }
         this.myShine.visible = false;
         this.mAnimateTimeLine = new TimelineLite();
         this.mAnimateTimeLine.append(TweenLite.to(this,ANIMATE_DURATION,{
            "x":ANIMATE_TO_X,
            "onComplete":this.onAppearComplete
         }));
         this.mAnimateTimeLine.append(TweenLite.to(this,this.mShowDuration,{"onComplete":this.onShowComplete}));
         this.mAnimateTimeLine.play();
      }
      
      private function onAppearComplete() : void
      {
         this.myIcon.gotoAndPlay(1);
      }
      
      private function onShowComplete() : void
      {
         TweenLite.to(this,0.2,{
            "alpha":0,
            "delay":2,
            "onComplete":this.onWholeAnimationComplete
         });
      }
      
      private function onWholeAnimationComplete() : void
      {
         visible = false;
         if(null != this.mShowAnimationCompleteHandler)
         {
            this.mShowAnimationCompleteHandler();
         }
      }
      
      private function onCloseClicked() : void
      {
         if(Boolean(this.mAnimateTimeLine))
         {
            this.mAnimateTimeLine.kill();
            this.mAnimateTimeLine.clear();
            this.onWholeAnimationComplete();
         }
      }
      
      private function middleText(tf:TextField) : void
      {
         tf.y = (this.myBg.height - tf.textHeight) * 0.5;
      }
   }
}

