package codo.interfaces
{
   import flash.display.DisplayObject;
   
   public interface IBasePageLayer
   {
      
      function addChild(param1:DisplayObject) : DisplayObject;
      
      function addChildAt(param1:DisplayObject, param2:int) : DisplayObject;
      
      function removeChild(param1:DisplayObject) : DisplayObject;
      
      function removeChildAt(param1:int) : DisplayObject;
   }
}

