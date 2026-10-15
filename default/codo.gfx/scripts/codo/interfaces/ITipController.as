package codo.interfaces
{
   public interface ITipController
   {
      
      function registerTip(param1:ITipAbleElement, param2:uint, param3:String = "", param4:String = "") : void;
      
      function unRegisterTip(param1:ITipAbleElement) : void;
   }
}

