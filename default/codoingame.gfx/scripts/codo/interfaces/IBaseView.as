package codo.interfaces
{
   import flash.events.KeyboardEvent;
   
   public interface IBaseView
   {
      
      function addToBlur() : void;
      
      function removeFromBlur() : void;
      
      function initState(param1:int) : void;
      
      function onKeyboardEvent(param1:KeyboardEvent) : void;
   }
}

