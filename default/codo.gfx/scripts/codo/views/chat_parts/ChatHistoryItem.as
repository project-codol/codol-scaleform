package codo.views.chat_parts
{
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.ChatSpeakerType;
   import codo.objects.PlayerNameSettings;
   import codo.objects.RightClickCustomData;
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   
   public class ChatHistoryItem extends UIInteractiveComponent
   {
      
      private static var mRightClickHandler:Function;
      
      private static const ITEM_HEIGHT:int = 24;
      
      private static const ITEM_WIDTH:int = 705;
      
      private static const SENDER_WIDTH:int = 150;
      
      private static const MESSAGE_WIDTH:int = 700;
      
      private static const MESSAGE_HEIGHT:int = 22;
      
      private static const SENDER_MESSAGE_GAP:int = 5;
      
      public var mySender:PlayerName;
      
      public var myMessage:TextField;
      
      public var myIcon:MovieClip;
      
      public var mySmallSpeakerBg:MovieClip;
      
      public function ChatHistoryItem()
      {
         super();
         this.mySender.y = 2;
         this.myMessage.y = 2;
         var senderSetting:PlayerNameSettings = new PlayerNameSettings();
         senderSetting.mode = PlayerNameSettings.MODE_DIRECT;
         senderSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         senderSetting.textWidth = SENDER_WIDTH;
         senderSetting.textHeight = MESSAGE_HEIGHT;
         senderSetting.textColor = GlobalGuide.CODO_BLUE_LIGHT;
         senderSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_TRUNCATE;
         this.mySender.settings = senderSetting;
         this.myMessage.textStyle = ChatGuide.styleChatMessage;
         this.myMessage.width = MESSAGE_WIDTH;
         this.myMessage.height = MESSAGE_HEIGHT;
      }
      
      public static function registerSenderNameRightClickHandler(handler:Function) : void
      {
         mRightClickHandler = handler;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data == null)
         {
            return;
         }
         this.mySender.setData(data.senderName,data.senderID);
         var customData:RightClickCustomData = new RightClickCustomData();
         customData.type = RightClickCustomData.TYPE_CHAT_MESSAGE;
         customData.content = data;
         this.mySender.customData = customData;
         this.myMessage.text = data.message;
         this.myMessage.x = this.mySender.x + this.mySender.textField.textWidth + SENDER_MESSAGE_GAP;
         if(Boolean(data.isSystem))
         {
            isInteractiveEnabled = false;
            this.myMessage.fontColor = ChatGuide.SYS_SEND_COLOR;
         }
         else if(!data.selfSend)
         {
            this.myMessage.fontColor = ChatGuide.OTHER_SEND_COLOR;
         }
         else
         {
            isInteractiveEnabled = false;
            this.myMessage.fontColor = GlobalGuide.WHITE;
         }
         this.formatLoudSpeaker(data);
         this.myMessage.width = MESSAGE_WIDTH - this.myMessage.x;
         TextUtil.resizeTextToFitWidth(this.myMessage.myTextClip);
      }
      
      private function formatLoudSpeaker(data:*) : void
      {
         if(data.loudSpeakerType != -1)
         {
            this.myIcon.visible = true;
            this.mySender.x = this.myIcon.x + this.myIcon.width + SENDER_MESSAGE_GAP;
            this.myMessage.fontColor = ChatGuide.LOUD_SPEAKER_COLOR;
         }
         else
         {
            this.myIcon.visible = false;
            this.mySender.x = SENDER_MESSAGE_GAP;
         }
         this.myMessage.x = this.mySender.x + this.mySender.textField.textWidth + SENDER_MESSAGE_GAP;
         this.myIcon.gotoAndStop(data.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG ? ChatGuide.BIG_SPEAKER_ICON_FRAME : ChatGuide.SMALL_SPEAKER_ICON_FRAME);
         if(data.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_SMALL)
         {
            this.mySmallSpeakerBg.visible = true;
         }
         else
         {
            this.mySmallSpeakerBg.visible = false;
         }
      }
      
      override public function get height() : Number
      {
         return ITEM_HEIGHT;
      }
      
      override public function get width() : Number
      {
         return ITEM_WIDTH;
      }
   }
}

