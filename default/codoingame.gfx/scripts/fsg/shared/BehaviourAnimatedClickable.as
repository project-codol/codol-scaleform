package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.MovieClip;
   
   public class BehaviourAnimatedClickable implements IDisposable
   {
      
      private var m_movieClip:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_idleAnimFrame:uint;
      
      private var m_highlightAnimFrame:uint;
      
      private var m_pressedAnimFrame:uint;
      
      private var m_disabledAnimFrame:uint;
      
      private var m_enabled:Boolean;
      
      public function BehaviourAnimatedClickable(obj:MovieClip, clickable:BehaviourClickable, idleAnimFrame:uint, highlightAnimFrame:uint, pressedAnimFrame:uint, disabledAnimFrame:uint = 1)
      {
         super();
         this.m_movieClip = obj;
         this.m_clickable = clickable;
         this.m_idleAnimFrame = idleAnimFrame;
         this.m_highlightAnimFrame = highlightAnimFrame;
         this.m_pressedAnimFrame = pressedAnimFrame;
         this.m_disabledAnimFrame = disabledAnimFrame;
         this.m_enabled = true;
         this.m_movieClip.gotoAndStop(idleAnimFrame);
         this.registerEvents();
      }
      
      public function overrideAnimFrame(idleAnimFrame:uint, highlightAnimFrame:uint, pressedAnimFrame:uint, disabledAnimFrame:uint = 1) : void
      {
         this.m_idleAnimFrame = idleAnimFrame;
         this.m_highlightAnimFrame = highlightAnimFrame;
         this.m_pressedAnimFrame = pressedAnimFrame;
         this.m_disabledAnimFrame = disabledAnimFrame;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.m_clickable))
         {
            this.m_clickable.removeMouseOverCallback(this.onMouseOver);
            this.m_clickable.removeMouseOutCallback(this.onMouseOut);
            this.m_clickable.removeMouseDownCallback(this.onMouseDown);
            this.m_clickable.removeMouseUpCallback(this.onMouseUp);
            this.m_clickable = null;
         }
         this.m_movieClip = null;
      }
      
      public function setEnabled(enabled:Boolean) : void
      {
         this.m_enabled = enabled;
         if(this.m_disabledAnimFrame != -1 && !this.m_enabled)
         {
            this.m_movieClip.gotoAndStop(this.m_disabledAnimFrame);
         }
         else if(this.m_enabled)
         {
            this.m_movieClip.gotoAndStop(this.m_idleAnimFrame);
         }
      }
      
      private function registerEvents() : void
      {
         this.m_clickable.addMouseOverCallback(this.onMouseOver);
         this.m_clickable.addMouseOutCallback(this.onMouseOut);
         this.m_clickable.addMouseDownCallback(this.onMouseDown);
         this.m_clickable.addMouseUpCallback(this.onMouseUp);
      }
      
      private function onMouseOver() : void
      {
         if(this.m_enabled)
         {
            this.m_movieClip.gotoAndStop(this.m_highlightAnimFrame);
         }
      }
      
      private function onMouseOut() : void
      {
         if(this.m_enabled)
         {
            this.m_movieClip.gotoAndStop(this.m_idleAnimFrame);
         }
      }
      
      private function onMouseDown() : void
      {
         if(this.m_enabled)
         {
            this.m_movieClip.gotoAndStop(this.m_pressedAnimFrame);
         }
      }
      
      private function onMouseUp() : void
      {
      }
   }
}

