package components
{
   import codo.constants.SE_Flag;
   import codo.event.ParaEvent;
   import codo.utils.CursorUtil;
   import codo.utils.ScaleformUtil;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import scaleform.gfx.MouseEventEx;
   import shaui.component.core.InteractiveComponent;
   
   public class BaseButton extends InteractiveComponent
   {
      
      public static const EVT_MOUSE_DOWN:String = "evt_mouse_down";
      
      public static const EVT_CLICK:String = "evt_click";
      
      public static const EVT_RIGHT_CLICK:String = "evt_right_click";
      
      public static const EVT_DOUBLE_CLICK:String = "evt_double_click";
      
      public static const EVT_MOUSE_OVER:String = "evt_mouse_over";
      
      public static const EVT_MOUSE_OUT:String = "evt_mouse_out";
      
      public static const EVT_MOUSE_MOVE:String = "evt_mouse_move";
      
      private static const VISUAL_STATUS_NORMAL:String = "normal";
      
      private static const VISUAL_STATUS_ROLLOVER:String = "rollover";
      
      private static const VISUAL_STATUS_DISABLE:String = "disable";
      
      protected var _isFocusIn:Boolean = false;
      
      protected var _hoverCursorType:int;
      
      protected var _showingHoverCursor:Boolean;
      
      protected var _isSoundOn:Boolean = true;
      
      protected var _isSoundLoop:Boolean = false;
      
      private var _currentVisualStatus:String;
      
      private var _allowClickEvtBubble:Boolean = true;
      
      private var _doubleClickEnabled:Boolean = true;
      
      private var _customizeClickSfx:Boolean = false;
      
      private var _customizeOverSfx:Boolean = false;
      
      public function BaseButton()
      {
         super();
         this._hoverCursorType = CursorUtil.CURSOR_OVER_BUTTON;
      }
      
      override public function set enable(value:Boolean) : void
      {
         if(enable != value)
         {
            super.enable = value;
            if(enable)
            {
               this.setToNormal();
            }
            else
            {
               this.setToDisable();
            }
         }
      }
      
      override protected function updateMouseInteractivity(value:Boolean) : void
      {
         doubleClickEnabled = value && this._doubleClickEnabled;
      }
      
      public function set customizeClickSfx(value:Boolean) : void
      {
         this._customizeClickSfx = value;
      }
      
      public function set customizeOverSfx(value:Boolean) : void
      {
         this._customizeOverSfx = value;
      }
      
      public function set allowClickEvtBubble(cSwi:Boolean) : void
      {
         this._allowClickEvtBubble = cSwi;
      }
      
      public function get data() : *
      {
         return null;
      }
      
      public function set data(cDat:*) : void
      {
      }
      
      public function enableDoubleClick() : void
      {
         this._doubleClickEnabled = true;
         doubleClickEnabled = enable && this._doubleClickEnabled;
      }
      
      public function disableDoubleClick() : void
      {
         this._doubleClickEnabled = false;
         doubleClickEnabled = enable && this._doubleClickEnabled;
      }
      
      protected function UsesHoverCursor() : Boolean
      {
         return (willTrigger(EVT_CLICK) || willTrigger(MouseEvent.CLICK)) && enable && this._hoverCursorType != CursorUtil.CURSOR_STANDARD;
      }
      
      protected function EndHoverCursor() : void
      {
         this.playSound_stopLooping();
         if(this._showingHoverCursor)
         {
            CursorUtil.EndCursor(this._hoverCursorType);
            this._showingHoverCursor = false;
         }
      }
      
      protected function setToNormal(cTween:Boolean = true) : void
      {
         if(this._currentVisualStatus != VISUAL_STATUS_NORMAL)
         {
            this._currentVisualStatus = VISUAL_STATUS_NORMAL;
            this.refreshNormalStatus(cTween);
         }
      }
      
      protected function setToRollOver(cTween:Boolean = true) : void
      {
         if(this._currentVisualStatus != VISUAL_STATUS_ROLLOVER)
         {
            this._currentVisualStatus = VISUAL_STATUS_ROLLOVER;
            this.refreshRollOverStatus(cTween);
         }
      }
      
      protected function setToDisable() : void
      {
         if(this._currentVisualStatus != VISUAL_STATUS_DISABLE)
         {
            this._currentVisualStatus = VISUAL_STATUS_DISABLE;
            this.refreshDisableStatus();
         }
      }
      
      protected function onButtonMouseOutHandler(cEvt:MouseEvent) : void
      {
         this._isFocusIn = false;
         this.setToNormal();
         dispatchEvent(new ParaEvent(EVT_MOUSE_OUT));
      }
      
      protected function refreshNormalStatus(cTween:Boolean = true) : void
      {
      }
      
      protected function refreshRollOverStatus(cTween:Boolean = true) : void
      {
      }
      
      protected function refreshDisableStatus() : void
      {
      }
      
      protected function playSound_down() : void
      {
      }
      
      protected function playSound_rollOver() : void
      {
         if(this._isSoundOn)
         {
            this._isSoundLoop = true;
            if(this._customizeOverSfx == false)
            {
               SOUND_UTIL.playSoundByFullName(getMyFullName(),SE_Flag.over,currentMatchType);
            }
         }
      }
      
      protected function playSound_click() : void
      {
         if(this._isSoundOn)
         {
            this._isSoundLoop = true;
            if(this._customizeClickSfx == false)
            {
               SOUND_UTIL.playSoundByFullName(getMyFullName(),SE_Flag.click,currentMatchType);
            }
         }
      }
      
      protected function playSound_stopLooping() : void
      {
         if(this._isSoundOn && this._isSoundLoop)
         {
            this._isSoundLoop = false;
            SOUND_UTIL.stopSound();
         }
      }
      
      final override protected function onClickHandler(cEvt:MouseEvent) : void
      {
         if(this._allowClickEvtBubble == false)
         {
            cEvt.stopImmediatePropagation();
         }
         this.playSound_click();
         dispatchEvent(new ParaEvent(EVT_CLICK));
      }
      
      final override protected function onMiddleClickHandler(cEvt:MouseEvent) : void
      {
         if(this._allowClickEvtBubble == false)
         {
            cEvt.stopImmediatePropagation();
         }
         if(ScaleformUtil.isScaleform)
         {
            exportUIName();
         }
      }
      
      final override protected function onRightClickHandler(cEvt:MouseEvent) : void
      {
         if(this._allowClickEvtBubble == false)
         {
            cEvt.stopImmediatePropagation();
         }
         if(cEvt.shiftKey)
         {
            exportFullPath();
         }
         else
         {
            dispatchEvent(new ParaEvent(EVT_RIGHT_CLICK));
         }
      }
      
      final override protected function onMouseDoubleClickHandler(cEvt:MouseEvent) : void
      {
         var tempEvtEx:MouseEventEx = cEvt as MouseEventEx;
         if(tempEvtEx.buttonIdx == MouseEventEx.RIGHT_BUTTON)
         {
            return;
         }
         dispatchEvent(new ParaEvent(EVT_DOUBLE_CLICK));
      }
      
      final override protected function onMouseDownHandler(cEvt:MouseEvent) : void
      {
         this.playSound_down();
         dispatchEvent(new ParaEvent(EVT_MOUSE_DOWN));
      }
      
      final override protected function onMouseMoveHandler(cEvt:MouseEvent) : void
      {
         dispatchEvent(new ParaEvent(EVT_MOUSE_MOVE));
      }
      
      final override protected function onMouseOverHandler(cEvt:MouseEvent) : void
      {
         this.playSound_rollOver();
         this._isFocusIn = true;
         this.setToRollOver();
         dispatchEvent(new ParaEvent(EVT_MOUSE_OVER));
         if(this.UsesHoverCursor() && !this._showingHoverCursor)
         {
            CursorUtil.BeginCursor(this._hoverCursorType);
            this._showingHoverCursor = true;
         }
      }
      
      final override protected function onMouseOutHandler(cEvt:MouseEvent) : void
      {
         this.onButtonMouseOutHandler(cEvt);
         this.EndHoverCursor();
      }
      
      final protected function onRemovedFromStageHandle(event:Event) : void
      {
         this.EndHoverCursor();
      }
   }
}

