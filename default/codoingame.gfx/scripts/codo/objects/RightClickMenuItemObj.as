package codo.objects
{
   public dynamic class RightClickMenuItemObj extends CustomObject
   {
      
      public var label:String = "";
      
      public var handle:Function;
      
      public var enableChecker:Function;
      
      public var enable:Boolean = true;
      
      public var updateEnableFnc:Function;
      
      public function RightClickMenuItemObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

