package codo.objects
{
   public dynamic class InvitationObj extends CustomObject
   {
      
      public var id:uint = 0;
      
      public var type:uint = 0;
      
      public var senderID:String = "";
      
      public var senderName:String = "";
      
      public var receivedTime:String = "";
      
      public var targetID:String = "";
      
      public var targetName:String = "";
      
      public var title:String = "";
      
      public var playlistID:uint = 0;
      
      public var gameType:String = "";
      
      public var isLog:Boolean = false;
      
      public var isClan:Boolean = false;
      
      public var isRead:Boolean = false;
      
      public var isAlerted:Boolean = false;
      
      public function InvitationObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

