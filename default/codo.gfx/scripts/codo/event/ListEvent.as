package codo.event
{
   import components.interfaces.IListItemRendererBase;
   import flash.events.Event;
   
   public class ListEvent extends Event
   {
      
      protected var _myPara:* = null;
      
      protected var _targetLine:IListItemRendererBase;
      
      public function ListEvent(cType:String, cTargetLine:IListItemRendererBase, cPara:Object = null)
      {
         super(cType);
         this._targetLine = cTargetLine;
         this._myPara = cPara;
      }
      
      public function get itemRenderer() : IListItemRendererBase
      {
         return this._targetLine;
      }
      
      public function get myPara() : *
      {
         return this._myPara;
      }
   }
}

