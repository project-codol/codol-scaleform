package fsg.shared
{
   import codo.interfaces.IDisposable;
   import codo.utils.CursorUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.MouseEventEx;
   
   public class BehaviourClickable implements IDisposable
   {
      
      private var m_clickCallback:CallbackList;
      
      private var m_mouseOverCallback:CallbackList;
      
      private var m_mouseOutCallback:CallbackList;
      
      private var m_mouseRollOverCallback:CallbackList;
      
      private var m_mouseRollOutCallback:CallbackList;
      
      private var m_mouseDownCallback:CallbackList;
      
      private var m_mouseUpCallback:CallbackList;
      
      private var m_doubleClickCallback:CallbackList;
      
      private var m_rightClickCallback:CallbackList;
      
      private var m_mouseMoveCallback:CallbackList;
      
      private var m_hitObject:*;
      
      private var m_enabled:Boolean;
      
      private var m_mouseHoverOverride:Boolean;
      
      private var m_forceMouseHoverHighlight:Boolean;
      
      private var m_mouseHighlightEnabled:Boolean;
      
      private var m_stopClickEventPropagation:Boolean;
      
      protected var _hitObjStage:Stage;
      
      public function BehaviourClickable(hitObject:*, forceMouseHighlight:Boolean = false, useMouseRoll:Boolean = false)
      {
         super();
         this.m_hitObject = hitObject;
         this.m_enabled = true;
         this.m_mouseHoverOverride = false;
         this.m_mouseHighlightEnabled = true;
         this.m_forceMouseHoverHighlight = forceMouseHighlight;
         this.m_clickCallback = new CallbackList();
         this.m_mouseOverCallback = new CallbackList();
         this.m_mouseOutCallback = new CallbackList();
         this.m_mouseRollOverCallback = new CallbackList();
         this.m_mouseRollOutCallback = new CallbackList();
         this.m_mouseDownCallback = new CallbackList();
         this.m_mouseUpCallback = new CallbackList();
         this.m_doubleClickCallback = new CallbackList();
         this.m_rightClickCallback = new CallbackList();
         this.m_mouseMoveCallback = new CallbackList();
         if(Boolean(this.m_hitObject))
         {
            if(useMouseRoll)
            {
               this.m_hitObject.addEventListener(MouseEvent.ROLL_OVER,this.onMouseOver,false,0,true);
               this.m_hitObject.addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut,false,0,true);
            }
            else
            {
               this.m_hitObject.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
               this.m_hitObject.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
               this.m_hitObject.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
               this.m_hitObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,false,0,true);
               this.m_hitObject.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove,false,0,true);
            }
         }
      }
      
      public function dispose() : void
      {
         this.m_clickCallback.dispose();
         this.m_mouseOverCallback.dispose();
         this.m_mouseOutCallback.dispose();
         this.m_mouseRollOverCallback.dispose();
         this.m_mouseRollOutCallback.dispose();
         this.m_mouseDownCallback.dispose();
         this.m_mouseUpCallback.dispose();
         this.m_mouseMoveCallback.dispose();
         if(Boolean(this.m_hitObject))
         {
            this.m_hitObject.removeEventListener(MouseEvent.CLICK,this.onClick);
            this.m_hitObject.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this.m_hitObject.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            this.m_hitObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.m_hitObject.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
            this.m_hitObject.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
            this.m_hitObject.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.m_hitObject = null;
         }
      }
      
      public function clearCallbacks() : void
      {
         this.m_clickCallback.dispose();
      }
      
      public function isEnabled() : Boolean
      {
         return this.m_enabled;
      }
      
      public function setEnabled(enabled:Boolean) : void
      {
         this.m_enabled = enabled;
      }
      
      public function setMouseHoverOverride(enabled:Boolean) : void
      {
         this.m_mouseHoverOverride = enabled;
      }
      
      public function setEnableMouseHighlight(enabled:Boolean) : void
      {
         this.m_mouseHighlightEnabled = enabled;
      }
      
      public function set stopClickEventPropogation(stopClickEventPropogation:Boolean) : void
      {
         this.m_stopClickEventPropagation = stopClickEventPropogation;
      }
      
      public function addClickCallback(callback:Function, userData:Object = null) : void
      {
         this.m_clickCallback.addCallback(callback,userData);
      }
      
      public function addRightClickCallback(callback:Function, userData:Object = null) : void
      {
         this.m_rightClickCallback.addCallback(callback,userData);
      }
      
      public function removeRightClickCallback(callback:Function, userData:Object = null) : void
      {
         this.m_rightClickCallback.removeCallback(callback,userData);
      }
      
      public function addMouseOverCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseOverCallback.addCallback(callback,userData);
      }
      
      public function addMouseOutCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseOutCallback.addCallback(callback,userData);
      }
      
      public function addMouseRollOverCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseRollOverCallback.addCallback(callback,userData);
      }
      
      public function addMouseRollOutCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseRollOutCallback.addCallback(callback,userData);
      }
      
      public function addMouseDownCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseDownCallback.addCallback(callback,userData);
      }
      
      public function addMouseUpCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseUpCallback.addCallback(callback,userData);
      }
      
      public function addMouseMoveCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseMoveCallback.addCallback(callback,userData);
      }
      
      public function removeClickCallback(callback:Function, userData:Object = null) : void
      {
         this.m_clickCallback.removeCallback(callback,userData);
      }
      
      public function removeMouseOverCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseOverCallback.removeCallback(callback,userData);
      }
      
      public function removeMouseOutCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseOutCallback.removeCallback(callback,userData);
      }
      
      public function removeMouseRollOverCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseRollOverCallback.removeCallback(callback,userData);
      }
      
      public function removeMouseRollOutCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseRollOutCallback.removeCallback(callback,userData);
      }
      
      public function removeMouseDownCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseDownCallback.removeCallback(callback,userData);
      }
      
      public function removeMouseUpCallback(callback:Function, userData:Object = null) : void
      {
         this.m_mouseUpCallback.removeCallback(callback,userData);
      }
      
      public function addDoubleClickCallback(callback:Function, userData:Object = null) : void
      {
         if(Boolean(this.m_hitObject))
         {
            if(this.m_hitObject.hasEventListener(MouseEvent.DOUBLE_CLICK) == false)
            {
               this.m_hitObject.doubleClickEnabled = true;
               this.m_hitObject.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick,false,0,true);
            }
            this.m_doubleClickCallback.addCallback(callback,userData);
         }
      }
      
      public function removeDoubleClickCallback(callback:Function, userData:Object = null) : void
      {
         if(Boolean(this.m_hitObject))
         {
            this.m_doubleClickCallback.removeCallback(callback,userData);
            if(this.m_hitObject.hasEventListener(MouseEvent.DOUBLE_CLICK) == false)
            {
               this.m_hitObject.doubleClickEnabled = false;
               this.m_hitObject.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
            }
         }
      }
      
      private function onDoubleClick(e:MouseEvent) : void
      {
         var tempEvtEx:MouseEventEx = null;
         if(ScaleformUtil.isScaleform == true && e is MouseEventEx)
         {
            tempEvtEx = e as MouseEventEx;
            if(tempEvtEx.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               if(!this.m_enabled)
               {
                  return;
               }
               this.m_doubleClickCallback.call();
            }
         }
         else
         {
            if(!this.m_enabled)
            {
               return;
            }
            this.m_doubleClickCallback.call();
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var tempEvtEx:MouseEventEx = null;
         if(this.m_stopClickEventPropagation)
         {
            e.stopPropagation();
         }
         if(ScaleformUtil.isScaleform == true && e is MouseEventEx)
         {
            tempEvtEx = e as MouseEventEx;
            if(tempEvtEx.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               if(!this.m_enabled)
               {
                  return;
               }
               this.m_clickCallback.call();
            }
            else if(tempEvtEx.buttonIdx == MouseEventEx.RIGHT_BUTTON)
            {
               if(!this.m_enabled)
               {
                  return;
               }
               this.m_rightClickCallback.call();
            }
         }
         else
         {
            if(!this.m_enabled)
            {
               return;
            }
            this.m_clickCallback.call();
         }
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         if(!this.m_enabled && !this.m_mouseHoverOverride)
         {
            return;
         }
         if(e.type == MouseEvent.MOUSE_OVER)
         {
            this.m_mouseOverCallback.call();
         }
         else if(e.type == MouseEvent.ROLL_OVER)
         {
            this.m_mouseRollOverCallback.call();
         }
         if(this.m_mouseHighlightEnabled)
         {
            if(this.m_forceMouseHoverHighlight || this.m_clickCallback != null && this.m_clickCallback.Length > 0)
            {
               CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
            }
         }
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         if(!this.m_enabled && !this.m_mouseHoverOverride)
         {
            return;
         }
         if(e.type == MouseEvent.MOUSE_OUT)
         {
            this.m_mouseOutCallback.call();
         }
         else if(e.type == MouseEvent.ROLL_OUT)
         {
            this.m_mouseRollOutCallback.call();
         }
         if(this.m_mouseHighlightEnabled)
         {
            if(this.m_forceMouseHoverHighlight || this.m_clickCallback != null && this.m_clickCallback.Length > 0)
            {
               CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
            }
         }
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         if(!this.m_enabled && !this.m_mouseHoverOverride)
         {
            return;
         }
         if(e.type == MouseEvent.MOUSE_MOVE)
         {
            this.m_mouseMoveCallback.call();
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         var tempEvtEx:MouseEventEx = null;
         if(!this.m_enabled)
         {
            return;
         }
         var isLeftButton:Boolean = false;
         if(ScaleformUtil.isScaleform)
         {
            tempEvtEx = e as MouseEventEx;
            isLeftButton = tempEvtEx.buttonIdx == MouseEventEx.LEFT_BUTTON;
         }
         else
         {
            isLeftButton = true;
         }
         if(isLeftButton)
         {
            if(!this.m_enabled)
            {
               return;
            }
            if(Boolean(this.m_hitObject))
            {
               this._hitObjStage = this.m_hitObject.stage;
               this._hitObjStage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp,false,0,true);
            }
            this.m_mouseDownCallback.call();
         }
      }
      
      private function onStageMouseUp(e:MouseEvent) : void
      {
         var tempEvtEx:MouseEventEx = null;
         var isLeftButton:Boolean = false;
         if(ScaleformUtil.isScaleform)
         {
            tempEvtEx = e as MouseEventEx;
            isLeftButton = tempEvtEx.buttonIdx == MouseEventEx.LEFT_BUTTON;
         }
         else
         {
            isLeftButton = true;
         }
         if(isLeftButton)
         {
            if(!this.m_enabled)
            {
               return;
            }
            if(Boolean(this._hitObjStage))
            {
               this._hitObjStage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUp);
               this._hitObjStage = null;
            }
            this.m_mouseUpCallback.call();
         }
      }
      
      protected function getMyFullName(needTag:Boolean = true) : String
      {
         var thisObject:* = this.m_hitObject;
         if(thisObject.name.indexOf("myHitArea") >= 0)
         {
            thisObject = thisObject.parent;
         }
         var tempFullName:String = getQualifiedClassName(thisObject);
         tempFullName = getQualifiedClassName(thisObject.parent);
         var tempParent:DisplayObject = thisObject.parent;
         while(tempParent != thisObject.stage && tempParent != null && tempParent.name != "myContainer")
         {
            if(tempParent.name.indexOf("instance") >= 0 || tempParent.name.indexOf("myItemRenderer") >= 0)
            {
               tempFullName = getQualifiedClassName(tempParent) + "." + tempFullName;
            }
            else
            {
               tempFullName = tempParent.name + "." + tempFullName;
            }
            tempParent = tempParent.parent;
         }
         if(tempFullName.indexOf("components::DepthSprite.") == 0)
         {
            tempFullName = tempFullName.substr(51,tempFullName.length - 51);
         }
         tempFullName += "@" + thisObject.name;
         if(needTag == true)
         {
            tempFullName += this.tryGetChildNameTag(thisObject);
         }
         return tempFullName;
      }
      
      protected function tryGetChildNameTag(object:*) : String
      {
         var tempTag:String = "";
         if(object.getChildNameTag != null)
         {
            tempTag = object.getChildNameTag();
            if(tempTag != "")
            {
               tempTag = "$" + tempTag;
            }
         }
         return tempTag;
      }
   }
}

