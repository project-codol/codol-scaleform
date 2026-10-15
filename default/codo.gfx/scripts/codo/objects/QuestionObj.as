package codo.objects
{
   public dynamic class QuestionObj extends CustomObject
   {
      
      public static const TYPE_OPEN:uint = 0;
      
      public static const TYPE_SINGLE:uint = 1;
      
      public static const TYPE_MULTI:uint = 2;
      
      public static const MESSAGETYPE_NONE:uint = 0;
      
      public static const MESSAGETYPE_FREE:uint = 1;
      
      public static const MESSAGETYPE_WITHLASTOPTION:uint = 2;
      
      public var content:String = "";
      
      public var type:uint = 1;
      
      public var messageType:uint = 0;
      
      public var optionNum:uint = 0;
      
      public var options:Array = [];
      
      public function QuestionObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

