package codo.objects
{
   public class RightClickCustomData
   {
      
      public static const TYPE_UNDEFINED:int = -1;
      
      public static const TYPE_CHAT_MESSAGE:int = 0;
      
      public var type:int;
      
      public var content:Object;
      
      public function RightClickCustomData()
      {
         super();
         this.type = TYPE_UNDEFINED;
         this.content = null;
      }
   }
}

