package codo.objects
{
   public dynamic class ResultObj extends CustomObject
   {
      
      public static const RESULT_NONE:uint = uint(-1);
      
      public static const RESULT_FAIL:uint = 0;
      
      public static const RESULT_SUCCESS:uint = 1;
      
      public var id:uint = 0;
      
      public var result:uint = RESULT_NONE;
      
      public var resultMsg:String = "";
      
      public var params:* = null;
      
      public var data:* = null;
      
      public var dataVersion:int = 0;
      
      public function ResultObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public static function getObj(cID:uint = 0, cData:* = null, cResult:uint = 1) : ResultObj
      {
         var obj:ResultObj = new ResultObj();
         obj.id = cID;
         obj.result = cResult;
         obj.data = cData;
         return obj;
      }
   }
}

