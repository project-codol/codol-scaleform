package fsg.shared
{
   internal class Closure
   {
      
      internal var m_callback:Function;
      
      internal var m_userData:Object;
      
      public function Closure(callback:Function, userData:Object = null)
      {
         super();
         this.m_callback = callback;
         this.m_userData = userData;
      }
      
      public function call() : void
      {
         if(this.m_userData != null)
         {
            this.m_callback(this.m_userData);
         }
         else
         {
            this.m_callback();
         }
      }
   }
}

