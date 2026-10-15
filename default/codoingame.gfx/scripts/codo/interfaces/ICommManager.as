package codo.interfaces
{
   public interface ICommManager
   {
      
      function preInit() : void;
      
      function cppFirstLogin() : void;
      
      function cppInLoginQueue() : void;
      
      function cppActivate() : void;
      
      function cppUpdate(param1:Number) : void;
      
      function cppCloseAll() : void;
   }
}

