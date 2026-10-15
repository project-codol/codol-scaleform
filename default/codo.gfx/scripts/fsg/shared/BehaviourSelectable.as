package fsg.shared
{
   import codo.interfaces.IDisposable;
   
   public class BehaviourSelectable implements IDisposable
   {
      
      public static const STATE_UNSELECTED:uint = 0;
      
      public static const STATE_SELECTED:uint = 1;
      
      private var m_uState:uint = 0;
      
      private var m_selectedCallbacks:CallbackList;
      
      private var m_unselectedCallbacks:CallbackList;
      
      private var m_Clickable:BehaviourClickable;
      
      private var m_canUnselectClick:Boolean;
      
      public function BehaviourSelectable(clickable:BehaviourClickable, canUnselectClick:Boolean = false)
      {
         super();
         this.m_Clickable = clickable;
         this.m_Clickable.addClickCallback(this.onClick);
         this.m_selectedCallbacks = new CallbackList();
         this.m_unselectedCallbacks = new CallbackList();
         this.m_canUnselectClick = canUnselectClick;
      }
      
      public function dispose() : void
      {
         this.state = STATE_UNSELECTED;
         this.m_Clickable.removeClickCallback(this.onClick);
         this.m_Clickable = null;
         this.m_selectedCallbacks.dispose();
         this.m_unselectedCallbacks.dispose();
      }
      
      public function resetCallbacks() : void
      {
         this.m_selectedCallbacks.dispose();
         this.m_selectedCallbacks = new CallbackList();
         this.m_unselectedCallbacks.dispose();
         this.m_unselectedCallbacks = new CallbackList();
      }
      
      public function addSelectedCallback(fnSelectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectedCallbacks.addCallback(fnSelectedCallback,userData);
      }
      
      public function addUnselectedCallback(fnUnselectedCallback:Function, userData:Object = null) : void
      {
         this.m_unselectedCallbacks.addCallback(fnUnselectedCallback,userData);
      }
      
      public function removeSelectedCallback(fnSelectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectedCallbacks.removeCallback(fnSelectedCallback,userData);
      }
      
      public function removeUnselectedCallback(fnUnselectedCallback:Function, userData:Object = null) : void
      {
         this.m_unselectedCallbacks.removeCallback(fnUnselectedCallback,userData);
      }
      
      private function onClick() : void
      {
         switch(this.m_uState)
         {
            case STATE_UNSELECTED:
               this.state = STATE_SELECTED;
               break;
            case STATE_SELECTED:
               this.state = this.m_canUnselectClick ? STATE_UNSELECTED : STATE_SELECTED;
         }
      }
      
      public function set state(uState:uint) : void
      {
         if(this.m_uState == uState)
         {
            return;
         }
         switch(uState)
         {
            case STATE_UNSELECTED:
               this.m_uState = STATE_UNSELECTED;
               this.m_unselectedCallbacks.call();
               break;
            case STATE_SELECTED:
               this.m_uState = STATE_SELECTED;
               this.m_selectedCallbacks.call();
         }
      }
      
      public function get state() : uint
      {
         return this.m_uState;
      }
   }
}

