package codo.objects
{
   public dynamic class BindCallbackObj
   {
      
      public var callback:Function;
      
      public var fromController:Boolean = false;
      
      public var dataVersion:uint = 0;
      
      public var params:* = null;
      
      public function BindCallbackObj()
      {
         super();
      }
   }
}

