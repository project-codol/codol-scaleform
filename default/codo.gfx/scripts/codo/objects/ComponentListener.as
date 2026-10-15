package codo.objects
{
   import codo.base.BaseView;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class ComponentListener
   {
      
      public static const CEVT_CLOSE_CHALLENGE_ITEM:uint = 0;
      
      private var _component:DisplayObject;
      
      private var _view:BaseView;
      
      private var _callbacks:Array = [];
      
      public function ComponentListener(component:DisplayObject)
      {
         super();
         this._component = component;
         component.addEventListener(Event.ADDED_TO_STAGE,this.onAddToStage);
         component.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
      }
      
      public function componentListen(id:uint, callback:Function) : void
      {
         this._callbacks[id] = callback;
      }
      
      public function onComponentEvent(id:uint) : void
      {
         if(this._callbacks[id] != null)
         {
            this._callbacks[id]();
         }
      }
      
      public function getView() : BaseView
      {
         return this._view;
      }
      
      private function onAddToStage(evt:Event) : void
      {
         var parent:DisplayObjectContainer = this._component.parent;
         while(parent != null)
         {
            if(parent is BaseView)
            {
               this._view = parent as BaseView;
               this._view.addComponentListener(this._component,this);
               break;
            }
            parent = parent.parent;
         }
      }
      
      private function onRemoveFromStage(evt:Event) : void
      {
         if(this._view != null)
         {
            this._view.removeComponentListener(this._component);
            this._view = null;
         }
      }
   }
}

