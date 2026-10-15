package components.fsg_pausemenu_part
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgSocialInfo extends MovieClip
   {
      
      public var myServerMessagesTF:TextField;
      
      public var myConsumerMessagesTF:TextField;
      
      public var myMailMessage:FsgSocialInfoButton;
      
      public var myMessagesMessage:FsgSocialInfoButton;
      
      public var myClanMessage:FsgSocialInfoButton;
      
      public var myUnionMessage:FsgSocialInfoButton;
      
      public var mySocialmessage:FsgSocialInfoButton;
      
      public var myRankingMessage:FsgSocialInfoButton;
      
      public function FsgSocialInfo()
      {
         super();
         this.myMailMessage.setButtonText("邮 件");
         this.myMailMessage.steMessageNumber(0);
         this.myMailMessage.setCallbackOnClick(this.onMailClicked);
         this.myMessagesMessage.setButtonText("消 息");
         this.myMessagesMessage.steMessageNumber(1);
         this.myMessagesMessage.setCallbackOnClick(this.onMessagesClicked);
         this.myClanMessage.setButtonText("战 队");
         this.myClanMessage.steMessageNumber(1);
         this.myClanMessage.setCallbackOnClick(this.onClanClicked);
         this.myUnionMessage.setButtonText("工会");
         this.myUnionMessage.steMessageNumber(1);
         this.myUnionMessage.setCallbackOnClick(this.onUnionClicked);
         this.mySocialmessage.setButtonText("社 交");
         this.mySocialmessage.steMessageNumber(3);
         this.mySocialmessage.setCallbackOnClick(this.onSocialClicked);
         this.myRankingMessage.setButtonText("排行榜");
         this.myRankingMessage.steMessageNumber(0);
         this.myRankingMessage.setCallbackOnClick(this.onRankingClicked);
      }
      
      public function setText(ServerMessagesText:String, ConsumerMessagesText:String) : void
      {
         this.myServerMessagesTF.text = ServerMessagesText;
         this.myConsumerMessagesTF.text = ConsumerMessagesText;
      }
      
      public function onMailClicked() : void
      {
      }
      
      public function onMessagesClicked() : void
      {
      }
      
      public function onClanClicked() : void
      {
      }
      
      public function onUnionClicked() : void
      {
      }
      
      public function onSocialClicked() : void
      {
      }
      
      public function onRankingClicked() : void
      {
      }
   }
}

