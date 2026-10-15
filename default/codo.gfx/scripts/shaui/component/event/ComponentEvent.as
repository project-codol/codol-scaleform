package shaui.component.event
{
   import flash.events.Event;
   
   public class ComponentEvent extends Event
   {
      
      public static const ON_LOAD:String = "onload";
      
      public static const BUTTON_CLICK:String = "buttonclick";
      
      public static const BUTTON_DOWN:String = "buttondown";
      
      public static const BUTTON_UP:String = "buttonup";
      
      public static const BUTTON_ROLL_OVER:String = "buttonrollover";
      
      public static const BUTTON_ROLL_OUT:String = "buttonrollout";
      
      public static const SELECT_CHANGED:String = "selectchanged";
      
      public static const STOP_SCROLL:String = "stopscroll";
      
      public static const SCROLL:String = "scroll";
      
      public static const CHANGE:String = "change";
      
      public static const LIST_ITEM_CLICK:String = "listitemclick";
      
      public static const LIST_ITEM_DOUBLE_CLICK:String = "listitemdoubleclick";
      
      protected var _para:Object = null;
      
      public function ComponentEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._para = data;
      }
      
      public function get para() : Object
      {
         return this._para;
      }
   }
}

