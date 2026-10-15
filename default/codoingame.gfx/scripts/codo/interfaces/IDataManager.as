package codo.interfaces
{
   import codo.objects.ResultObj;
   
   public interface IDataManager
   {
      
      function bind(param1:*, param2:Function, param3:* = null, param4:Boolean = true, param5:Boolean = false, param6:Boolean = false, param7:uint = 0) : void;
      
      function unbind(param1:*, param2:Function) : uint;
      
      function request(param1:*, param2:* = null, param3:Function = null) : void;
      
      function register(param1:*, param2:Function) : void;
      
      function setBindData(param1:*, param2:Object) : void;
      
      function setData(param1:ResultObj) : void;
      
      function addDP(param1:*, param2:Function) : void;
      
      function getDP(param1:*, param2:Array = null) : *;
      
      function removeDP(param1:*, param2:Function) : void;
   }
}

