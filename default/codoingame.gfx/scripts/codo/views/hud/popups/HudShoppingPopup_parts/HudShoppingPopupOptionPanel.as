package codo.views.hud.popups.HudShoppingPopup_parts
{
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class HudShoppingPopupOptionPanel extends MovieClip
   {
      
      public var myPopupText:TextField;
      
      private var mMessage:int = -1;
      
      private var mMouseOver:Boolean;
      
      private var mClickHandler:Function;
      
      private var mLocked:Boolean;
      
      private var mMouseDown:Boolean;
      
      private var mOrgX:Number;
      
      private var mOrgY:Number;
      
      private var mPendingPopupText:Array;
      
      private var mShowingPopupText:Boolean;
      
      public function HudShoppingPopupOptionPanel()
      {
         super();
         this.mOrgX = x;
         this.mOrgY = y;
         this.mPendingPopupText = [];
         this.mShowingPopupText = false;
      }
      
      public function reset() : void
      {
         this.mMouseOver = false;
         this.mLocked = false;
         this.mPendingPopupText = [];
         if(this.myPopupText != null)
         {
            TweenLite.killTweensOf(this.myPopupText);
            this.myPopupText.alpha = 0;
         }
         this.refresh();
      }
      
      public function cppPopupText(s:String) : void
      {
         this.mPendingPopupText.push(s);
         if(!this.mShowingPopupText)
         {
            this.processPopupText();
         }
      }
      
      private function processPopupText() : void
      {
         if(this.mPendingPopupText.length == 0)
         {
            this.mShowingPopupText = false;
            return;
         }
         this.mShowingPopupText = true;
         var s:String = this.mPendingPopupText[0];
         this.mPendingPopupText = this.mPendingPopupText.slice(1);
         TweenLite.killTweensOf(this.myPopupText);
         this.myPopupText.text = s;
         this.myPopupText.alpha = 0;
         var timeLineLite1:TimelineLite = new TimelineLite({"onComplete":this.processPopupText});
         timeLineLite1.append(TweenLite.to(this.myPopupText,0.3,{"alpha":1}));
         timeLineLite1.append(TweenLite.to(this.myPopupText,0.3,{
            "delay":0.6,
            "alpha":0
         }));
      }
      
      public function set clickHandler(handler:Function) : void
      {
         this.mClickHandler = handler;
      }
      
      public function bindListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OVER,this.onOptionMouseOver);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OUT,this.onOptionMouseOut);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK,this.onOptionMouseClick);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK_UP,this.onOptionMouseClickUp);
      }
      
      public function unbindListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OVER,this.onOptionMouseOver);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OUT,this.onOptionMouseOut);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK,this.onOptionMouseClick);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK_UP,this.onOptionMouseClickUp);
      }
      
      public function set locked(locked:Boolean) : void
      {
         this.mLocked = locked;
         this.refresh();
      }
      
      public function set message(message:int) : void
      {
         this.mMessage = message;
      }
      
      protected function onMouseOver() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OVER,this.mMessage);
      }
      
      protected function onMouseOut() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OUT,this.mMessage);
      }
      
      protected function onMouseDown() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK,this.mMessage);
      }
      
      protected function onMouseUp() : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK_UP,this.mMessage);
      }
      
      private function onOptionMouseOver(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         if(this.mLocked)
         {
            return;
         }
         this.mMouseOver = true;
         this.refresh();
      }
      
      private function onOptionMouseOut(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         if(this.mLocked)
         {
            return;
         }
         this.mMouseOver = false;
         this.refresh();
      }
      
      private function onOptionMouseClick(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         if(this.mLocked)
         {
            return;
         }
         this.mMouseDown = true;
         this.refresh();
      }
      
      private function onOptionMouseClickUp(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         if(this.mLocked)
         {
            return;
         }
         this.mMouseDown = false;
         if(!this.mLocked && this.mMouseOver)
         {
            if(this.mClickHandler != null)
            {
               this.mClickHandler();
            }
         }
         this.refresh();
      }
      
      protected function refresh() : void
      {
         x = this.mOrgX;
         y = this.mOrgY;
         if(!this.mLocked)
         {
            this.alpha = 1;
            if(this.mMouseOver)
            {
               if(this.mMouseDown)
               {
                  this.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
                  x = this.mOrgX + 5;
                  y = this.mOrgY + 5;
               }
               else
               {
                  this.transform.colorTransform = new ColorTransform(1.5,1.5,1.5);
               }
            }
            else
            {
               this.transform.colorTransform = new ColorTransform(1,1,1);
            }
         }
         else
         {
            this.transform.colorTransform = new ColorTransform(1,1,1);
         }
      }
   }
}

