package awesomium
{
   public class MessageBoxObj
   {
      
      public static const TYPE_ALERT:int = 0;
      
      public static const TYPE_CONFIRM:int = 1;
      
      public var type:int;
      
      public var buttonLabels:Array;
      
      public var label:String;
      
      public function MessageBoxObj()
      {
         super();
      }
   }
}

