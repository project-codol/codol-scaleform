package codo.interfaces
{
   public interface IEventManager
   {
      
      function broadcast(param1:String, param2:* = null) : void;
      
      function listen(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
      
      function unlisten(param1:String, param2:Function, param3:Boolean = false) : void;
   }
}

