package codo.event
{
   import flash.events.Event;
   
   public class ComboBoxItemEvent extends Event
   {
      
      public static const ITEM_DISABLED_ONFOCUS:String = "combox_item_disabled_focus";
      
      public static const ITEM_DISABLED_ONUNFOCUS:String = "combox_item_disabled_unfocus";
      
      public var itemLabel:String;
      
      public var itemHasFocus:Boolean;
      
      public function ComboBoxItemEvent(type:String, itemLabel:String = null, itemHasFocus:Boolean = false)
      {
         super(type,true,false);
         this.itemLabel = itemLabel;
         this.itemHasFocus = itemHasFocus;
      }
   }
}

