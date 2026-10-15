package codo.manager
{
   import codo.event.ParaEvent;
   import codo.interfaces.IEventManager;
   import flash.events.EventDispatcher;
   
   public class EventManager extends EventDispatcher implements IEventManager
   {
      
      private static var _instance:EventManager;
      
      public function EventManager()
      {
         super();
      }
      
      public static function getInstance() : EventManager
      {
         if(EventManager._instance == null)
         {
            EventManager._instance = new EventManager();
         }
         return EventManager._instance;
      }
      
      public function broadcast(type:String, data:* = null) : void
      {
         this.dispatchEvent(new ParaEvent(type,data));
      }
      
      public function listen(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true) : void
      {
         this.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function unlisten(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this.removeEventListener(type,listener,useCapture);
      }
   }
}

