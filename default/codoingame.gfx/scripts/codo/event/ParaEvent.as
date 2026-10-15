package codo.event
{
   import flash.events.Event;
   
   public class ParaEvent extends Event
   {
      
      protected var _myPara:* = null;
      
      public function ParaEvent(cType:String, cPara:Object = null, bubbles:Boolean = false)
      {
         super(cType,bubbles);
         this._myPara = cPara;
      }
      
      public function get myPara() : *
      {
         return this._myPara;
      }
   }
}

