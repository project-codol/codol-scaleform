package codo.constants
{
   import codo.tasks.MatchStatusTask;
   import codo.tasks.TencentSanitizeStringTask;
   import flash.utils.Dictionary;
   
   public class AsyncTaskInGameName
   {
      
      private static var _asyncTaskNames:Dictionary;
      
      public function AsyncTaskInGameName()
      {
         super();
      }
      
      public static function getClass(id:uint = 0) : Class
      {
         if(_asyncTaskNames == null)
         {
            _asyncTaskNames = new Dictionary();
            _asyncTaskNames[DataCommonID.TENCENT_SANITIZE_STRING] = TencentSanitizeStringTask;
            _asyncTaskNames[DataCommonID.MATCH_STATUS] = MatchStatusTask;
         }
         if(id == DataID.NONE || !_asyncTaskNames.hasOwnProperty(id.toString()))
         {
            return null;
         }
         return _asyncTaskNames[id];
      }
   }
}

