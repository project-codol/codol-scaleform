package codo.objects
{
   import codo.constants.ServerMessageDuration;
   import codo.constants.ServerMessageType;
   import flash.utils.Timer;
   
   public dynamic class ServerMessageObj
   {
      
      public var message:String = "";
      
      public var type:uint = ServerMessageType.NONE;
      
      public var duration:Number = ServerMessageDuration.INFINITE;
      
      public var priority:uint = 0;
      
      public var timer:Timer = null;
      
      public function ServerMessageObj()
      {
         super();
      }
   }
}

