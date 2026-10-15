package fsg.shared
{
   import codo.interfaces.IDisposable;
   
   public class CallbackList implements IDisposable
   {
      
      private var m_callbacks:Vector.<Closure>;
      
      public function CallbackList()
      {
         super();
         this.m_callbacks = new Vector.<Closure>();
      }
      
      public function dispose() : void
      {
         this.m_callbacks.length = 0;
      }
      
      public function get Length() : int
      {
         return this.m_callbacks.length;
      }
      
      public function addCallback(callback:Function, userData:Object = null) : void
      {
         if(this.getCallbackIndex(callback,userData) != -1)
         {
            return;
         }
         this.m_callbacks.push(new Closure(callback,userData));
      }
      
      public function removeCallback(callback:Function, userData:Object = null) : void
      {
         for(var i:uint = 0; i < this.m_callbacks.length; i++)
         {
            if(this.m_callbacks[i].m_callback == callback && this.m_callbacks[i].m_userData == userData)
            {
               this.m_callbacks.splice(i,1);
               break;
            }
         }
      }
      
      public function call() : void
      {
         for(var i:uint = 0; i < this.m_callbacks.length; i++)
         {
            this.m_callbacks[i].call();
         }
      }
      
      private function getCallbackIndex(callback:Function, userData:Object) : int
      {
         var result:int = -1;
         var everyFunc:Function = function(entry:Closure, index:int, vec:Vector.<Closure>):Boolean
         {
            if(entry.m_callback == callback && entry.m_userData == userData)
            {
               result = index;
               return false;
            }
            return true;
         };
         this.m_callbacks.every(everyFunc);
         return result;
      }
   }
}

