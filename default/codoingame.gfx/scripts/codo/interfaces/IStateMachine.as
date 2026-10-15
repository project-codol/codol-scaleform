package codo.interfaces
{
   public interface IStateMachine
   {
      
      function get state() : uint;
      
      function set state(param1:uint) : void;
      
      function update(param1:Number) : void;
   }
}

