package codo.interfaces
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public interface ITipAbleElement
   {
      
      function get tipTargetID() : String;
      
      function get tipLocString() : String;
      
      function get tipHitArea() : DisplayObject;
      
      function get tipOffset() : Point;
      
      function get tipAble() : Boolean;
   }
}

