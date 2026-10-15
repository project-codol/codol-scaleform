package fsg.shared
{
   import flash.display.MovieClip;
   
   public class BehaviourAnimatedSelectable
   {
      
      private var m_movieClip:MovieClip;
      
      private var m_selectable:BehaviourSelectable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_unselectedAnimFrame:uint;
      
      private var m_selectedAnimFrame:uint;
      
      private var m_highlightedAnimFrame:uint;
      
      private var m_enabled:Boolean;
      
      public function BehaviourAnimatedSelectable(obj:MovieClip, selectable:BehaviourSelectable, clickable:BehaviourClickable, unselectedAnimFrame:uint, selectableAnimFrame:uint, highlightedAnimFrame:uint)
      {
         super();
         this.m_enabled = true;
         this.m_movieClip = obj;
         this.m_selectable = selectable;
         this.m_clickable = clickable;
         this.setAnimationFrames(unselectedAnimFrame,selectableAnimFrame,highlightedAnimFrame);
         this.m_selectable.addSelectedCallback(this.onSelected);
         this.m_selectable.addUnselectedCallback(this.onUnselected);
         this.m_clickable.addMouseOverCallback(this.onMouseOver);
         this.m_clickable.addMouseOutCallback(this.onMouseOut);
      }
      
      public function setAnimationFrames(unselectedAnimFrame:uint, selectableAnimFrame:uint, highlightedAnimFrame:uint) : void
      {
         this.m_unselectedAnimFrame = unselectedAnimFrame;
         this.m_selectedAnimFrame = selectableAnimFrame;
         this.m_highlightedAnimFrame = highlightedAnimFrame;
         this.m_movieClip.gotoAndStop(unselectedAnimFrame);
      }
      
      public function isEnabled() : Boolean
      {
         return this.m_enabled;
      }
      
      public function setEnabled(enabled:Boolean) : void
      {
         this.m_enabled = enabled;
      }
      
      private function onSelected() : void
      {
         if(this.m_enabled == false)
         {
            return;
         }
         this.m_movieClip.gotoAndStop(this.m_selectedAnimFrame);
      }
      
      private function onUnselected() : void
      {
         this.m_movieClip.gotoAndStop(this.m_unselectedAnimFrame);
      }
      
      private function onMouseOver() : void
      {
         if(this.m_enabled == false)
         {
            return;
         }
         if(this.m_selectable.state == BehaviourSelectable.STATE_UNSELECTED)
         {
            this.m_movieClip.gotoAndStop(this.m_highlightedAnimFrame);
         }
      }
      
      private function onMouseOut() : void
      {
         if(this.m_enabled == false)
         {
            return;
         }
         if(this.m_selectable.state == BehaviourSelectable.STATE_UNSELECTED)
         {
            this.m_movieClip.gotoAndStop(this.m_unselectedAnimFrame);
         }
         else if(this.m_selectable.state == BehaviourSelectable.STATE_UNSELECTED)
         {
            this.m_movieClip.gotoAndStop(this.m_selectedAnimFrame);
         }
      }
   }
}

