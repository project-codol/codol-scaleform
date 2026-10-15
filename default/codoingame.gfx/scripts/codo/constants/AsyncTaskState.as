package codo.constants
{
   public class AsyncTaskState
   {
      
      public static const NONE:uint = 0;
      
      public static const PENDING:uint = 1;
      
      public static const STARTED:uint = 2;
      
      public static const WAITING:uint = 3;
      
      public static const SUCCEEDED:uint = 4;
      
      public static const FAILED:uint = 5;
      
      public static const CANCELLED:uint = 6;
      
      public static const COMPLETE:uint = 7;
      
      public function AsyncTaskState()
      {
         super();
      }
   }
}

