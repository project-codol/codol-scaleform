package codo.event
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class ImageLoaderEvent extends Event
   {
      
      public static const TYPE:String = "ImageLoaderEvent";
      
      public static const COMPLETE:uint = 0;
      
      public static const IO_ERROR:uint = 1;
      
      public static const CANCELED:uint = 2;
      
      public var m_displayObject:DisplayObject;
      
      public var m_status:uint;
      
      public function ImageLoaderEvent(displayObject:DisplayObject, status:uint)
      {
         super(TYPE);
         this.m_displayObject = displayObject;
         this.m_status = status;
      }
   }
}

