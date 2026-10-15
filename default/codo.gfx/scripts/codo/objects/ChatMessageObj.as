package codo.objects
{
   import codo.constants.ChattingChannelType;
   
   public dynamic class ChatMessageObj extends CustomObject
   {
      
      public var channelID:int = ChattingChannelType.NONE;
      
      public var channelName:String = "";
      
      public var targetID:String = "";
      
      public var targetName:String = "";
      
      public var senderID:String = "";
      
      public var senderName:String = "";
      
      public var message:String = "";
      
      public var formatedTime:String = "";
      
      public var isNew:Boolean = true;
      
      public var isSystem:Boolean = false;
      
      public var selfSend:Boolean = false;
      
      public var receiverName:String = "";
      
      public var receiverID:String = "";
      
      public var loudSpeakerType:int = -1;
      
      public var isInvestigator:Boolean = false;
      
      public function ChatMessageObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

