package codo.views.hud.shared
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class HUDSimpleButton extends MovieClip
   {
      
      private var mMouseOver:Boolean;
      
      private var mClickHandler:Function;
      
      private var mLocked:Boolean;
      
      private var mMouseDown:Boolean;
      
      public function HUDSimpleButton()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.reset();
      }
      
      public function reset() : void
      {
         this.mMouseOver = false;
         this.mLocked = false;
         this.refresh();
      }
      
      public function set clickHandler(handler:Function) : void
      {
         this.mClickHandler = handler;
      }
      
      public function set locked(locked:Boolean) : void
      {
         this.mLocked = locked;
         this.refresh();
      }
      
      protected function onMouseOver(cEvt:MouseEvent) : void
      {
         if(this.mLocked)
         {
            return;
         }
         this.mMouseOver = true;
         this.refresh();
      }
      
      protected function onMouseOut(cEvt:MouseEvent) : void
      {
         if(this.mLocked)
         {
            return;
         }
         this.mMouseOver = false;
         this.refresh();
      }
      
      protected function onMouseDown(cEvt:MouseEvent) : void
      {
         if(this.mLocked)
         {
            return;
         }
         this.mMouseDown = true;
         this.refresh();
      }
      
      protected function onMouseUp(cEvt:MouseEvent) : void
      {
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
         if(!this.mLocked)
         {
            this.alpha = 1;
            if(this.mMouseOver)
            {
               if(this.mMouseDown)
               {
                  gotoAndStop(3);
               }
               else
               {
                  gotoAndStop(2);
               }
            }
            else
            {
               gotoAndStop(1);
            }
         }
         else
         {
            gotoAndStop(1);
            this.alpha = 0.2;
         }
      }
   }
}

