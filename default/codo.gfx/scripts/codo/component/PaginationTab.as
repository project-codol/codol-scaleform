package codo.component
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.shared.BehaviourClickable;
   
   public class PaginationTab extends MovieClip
   {
      
      private static const IDLE_FRAME:int = 1;
      
      private static const OVER_FRAME:int = 2;
      
      private static const SELECTED_FRAME:int = 3;
      
      public var myHitArea:Sprite;
      
      private var mClickable:BehaviourClickable;
      
      private var mSelected:Boolean = false;
      
      public function PaginationTab()
      {
         super();
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
      }
      
      public function addClickCallback(f:Function) : void
      {
         this.mClickable.addClickCallback(f,this);
      }
      
      public function set selected(s:Boolean) : void
      {
         this.mSelected = s;
         gotoAndStop(true == this.mSelected ? SELECTED_FRAME : IDLE_FRAME);
      }
      
      private function onMouseOver() : void
      {
         gotoAndStop(OVER_FRAME);
      }
      
      private function onMouseOut() : void
      {
         if(true == this.mSelected)
         {
            gotoAndStop(SELECTED_FRAME);
         }
         else
         {
            gotoAndStop(IDLE_FRAME);
         }
      }
   }
}

