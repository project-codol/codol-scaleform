package codo.objects
{
   import codo.constants.ChattingChannelType;
   
   public dynamic class ChatChannelObj extends CustomObject
   {
      
      public var name:String = "";
      
      public var id:uint = ChattingChannelType.NONE;
      
      public var targetName:String = "";
      
      public var targetID:String = "";
      
      public var canBeClosed:Boolean = false;
      
      public var isNew:Boolean = false;
      
      public var msgHistory:Array = [];
      
      public var targetLevel:int = 0;
      
      public var numUnread:int = 0;
      
      public var readonly:Boolean = false;
      
      public function ChatChannelObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

