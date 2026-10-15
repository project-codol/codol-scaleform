package components.interfaces
{
   import flash.events.IEventDispatcher;
   import flash.geom.Rectangle;
   
   public interface IListItemRendererBase extends IEventDispatcher
   {
      
      function set index(param1:int) : void;
      
      function get index() : int;
      
      function set enable(param1:Boolean) : void;
      
      function get enable() : Boolean;
      
      function set selected(param1:Boolean) : void;
      
      function get selected() : Boolean;
      
      function setData(param1:Object) : void;
      
      function getData() : Object;
      
      function set style(param1:uint) : void;
      
      function get style() : uint;
      
      function set name(param1:String) : void;
      
      function get name() : String;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get width() : Number;
      
      function set width(param1:Number) : void;
      
      function get height() : Number;
      
      function set height(param1:Number) : void;
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
      
      function get tabEnabled() : Boolean;
      
      function set tabEnabled(param1:Boolean) : void;
      
      function get scale9Grid() : Rectangle;
      
      function set scale9Grid(param1:Rectangle) : void;
      
      function get alpha() : Number;
      
      function set alpha(param1:Number) : void;
      
      function enableDoubleClick() : void;
      
      function disableDoubleClick() : void;
   }
}

