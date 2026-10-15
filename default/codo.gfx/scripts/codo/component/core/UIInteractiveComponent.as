package codo.component.core
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Breadcrumb;
   import codo.utils.Logger;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class UIInteractiveComponent extends MovieClip
   {
      
      protected var mClickable:BehaviourClickable;
      
      protected var mInitYPos:Number;
      
      protected var mInitXPos:Number;
      
      private var mAudio:BehaviourAudio;
      
      private var mBreadcrumb:Breadcrumb;
      
      public var myHitArea:Sprite;
      
      protected var mData:*;
      
      protected var _isFocused:Boolean;
      
      public function UIInteractiveComponent()
      {
         super();
      }
      
      public static function logPrint(str:String) : void
      {
         Logger.print(str);
      }
      
      public static function printStack() : void
      {
         var e:Error = new Error();
         Logger.print(e.getStackTrace());
      }
      
      public function get isInteractiveEnabled() : Boolean
      {
         return this.mClickable != null && this.mClickable.isEnabled();
      }
      
      public function set stopClickEventPropagation(stopEvent:Boolean) : void
      {
         this.mClickable.stopClickEventPropogation = stopEvent;
      }
      
      public function set isInteractiveEnabled(setEnabled:Boolean) : void
      {
         if(null == this.mClickable)
         {
            if(null != this.myHitArea)
            {
               this.mClickable = new BehaviourClickable(this.myHitArea);
            }
            else
            {
               this.mClickable = new BehaviourClickable(this,false,true);
            }
            this.mClickable.addMouseRollOverCallback(this.onMouseOver);
            this.mClickable.addMouseRollOutCallback(this.onMouseOut);
            this.mClickable.addMouseOverCallback(this.onMouseOver);
            this.mClickable.addMouseOutCallback(this.onMouseOut);
            this.mClickable.addMouseDownCallback(this.onMouseClick);
            this.mClickable.addMouseUpCallback(this.onMouseClickUp);
            this.mClickable.addMouseMoveCallback(this.onMouseMoved);
            this.mAudio = new BehaviourAudio(this.mClickable);
         }
         this.mClickable.setEnabled(setEnabled);
      }
      
      public function get audioRef() : BehaviourAudio
      {
         return this.mAudio;
      }
      
      public function setClickCallback(callback:Function, data:* = null, disposeCallbacks:Boolean = false) : void
      {
         if(this.mClickable != null)
         {
            if(data == null)
            {
               data = this;
            }
            if(disposeCallbacks)
            {
               this.mClickable.clearCallbacks();
               this.mAudio = new BehaviourAudio(this.mClickable);
            }
            this.mClickable.addClickCallback(callback,data);
         }
      }
      
      public function setDoubleClickCallback(callback:Function, data:* = null) : void
      {
         if(this.mClickable != null)
         {
            if(data == null)
            {
               data = this;
            }
            this.mClickable.addDoubleClickCallback(callback,data);
         }
      }
      
      public function registerFocusEvent(callback:Function, userData:Object = null) : void
      {
         this.mClickable.addMouseOverCallback(callback,userData);
      }
      
      public function unRegisterFocusEvent(callback:Function, userData:Object = null) : void
      {
         this.mClickable.removeMouseOverCallback(callback,userData);
      }
      
      public function registerUnfocusEvent(callback:Function, userData:Object = null) : void
      {
         this.mClickable.addMouseOutCallback(callback,userData);
      }
      
      public function unRegisterUnfocusEvent(callback:Function, userData:Object = null) : void
      {
         this.mClickable.removeMouseOutCallback(callback,userData);
      }
      
      public function set currentDisplayFrame(frame:uint) : void
      {
         gotoAndStop(frame);
      }
      
      override public function get enabled() : Boolean
      {
         return this.mClickable.isEnabled();
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         if(!this.mClickable)
         {
            return;
         }
         this.mClickable.setEnabled(enabled);
         this.mAudio.setEnabled(enabled);
      }
      
      public function registerClickEvent(callback:Function, userData:Object = null) : void
      {
         if(!this.mClickable)
         {
            return;
         }
         this.mClickable.addClickCallback(callback,userData);
      }
      
      public function unRegisterClickEvent(callback:Function, userData:Object = null) : void
      {
         if(!this.mClickable)
         {
            return;
         }
         this.mClickable.removeClickCallback(callback,userData);
      }
      
      public function registerRightClickEvent(callback:Function, userData:Object = null) : void
      {
         if(!this.mClickable)
         {
            return;
         }
         this.mClickable.addRightClickCallback(callback,userData);
      }
      
      public function unRegisterRightClickEvent(callback:Function, userData:Object = null) : void
      {
         if(!this.mClickable)
         {
            return;
         }
         this.mClickable.removeRightClickCallback(callback,userData);
      }
      
      public function registerClickUpEvent(callback:Function, userData:Object = null) : void
      {
         this.mClickable.addMouseUpCallback(callback,userData);
      }
      
      public function unRegisterClickUpEvent(callback:Function, userData:Object = null) : void
      {
         this.mClickable.removeMouseUpCallback(callback,userData);
      }
      
      protected function onMouseOver() : void
      {
         this._isFocused = true;
      }
      
      protected function onMouseOut() : void
      {
         this._isFocused = false;
      }
      
      public function isFocused() : Boolean
      {
         return this._isFocused;
      }
      
      protected function onMouseClick() : void
      {
      }
      
      protected function onMouseClickUp() : void
      {
      }
      
      protected function onMouseMoved() : void
      {
      }
      
      public function set clickFooterItemCallback(callback:Function) : void
      {
      }
      
      public function positionCenterOffset() : Point
      {
         return null;
      }
      
      public function getBreadcrumb() : Breadcrumb
      {
         return this.mBreadcrumb;
      }
      
      public function addBreadcrumb(x:Number = NaN, y:Number = NaN, isEnd:Boolean = true) : Breadcrumb
      {
         CFunctionCommonContainer.Assert(this.mBreadcrumb == null,new Error("Faulty breadcrumb"));
         this.mBreadcrumb = Breadcrumb.addBreadcrumb(this,x,y,isEnd);
         return this.mBreadcrumb;
      }
      
      public function getData() : *
      {
         return this.mData;
      }
      
      public function setData(data:*) : void
      {
         this.mData = data;
      }
      
      public function set initX(value:Number) : void
      {
         this.mInitXPos = value;
      }
      
      public function set initY(value:Number) : void
      {
         this.mInitXPos = value;
      }
      
      public function resetCallback() : void
      {
         this.mClickable.clearCallbacks();
         this.mAudio = new BehaviourAudio(this.mClickable);
      }
   }
}

