package codo.interfaces
{
   public interface ICyborgTokenItem
   {
      
      function startProgress() : void;
      
      function stopProgress() : void;
      
      function setTokenState(param1:int, param2:Boolean = false) : void;
   }
}

