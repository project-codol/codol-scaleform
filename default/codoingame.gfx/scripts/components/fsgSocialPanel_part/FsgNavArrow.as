package components.fsgSocialPanel_part
{
   import codo.constants.SE_ID;
   import flash.display.MovieClip;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgNavArrow extends MovieClip
   {
      
      private static const NORMAL_FRAME:int = 1;
      
      private static const OVER_FRAME:int = 2;
      
      private static const DOWN_FRAME:int = 3;
      
      private static const HIGH_LIGHT_FRAME:int = 4;
      
      public var myHitArea:MovieClip;
      
      private var m_isHighlight:Boolean = false;
      
      private var m_clickCB:Function;
      
      private var m_isOver:Boolean = false;
      
      private var m_behaviourClickable:BehaviourClickable;
      
      private var m_audio:BehaviourAudio;
      
      public function FsgNavArrow()
      {
         super();
         this.m_behaviourClickable = new BehaviourClickable(this.myHitArea);
         this.m_audio = new BehaviourAudio(this.m_behaviourClickable,SE_ID.GENERAL_ROLLOVER,SE_ID.GENERAL_CYCLE);
         this.m_behaviourClickable.addMouseOverCallback(this.onMouseOver);
         this.m_behaviourClickable.addMouseOutCallback(this.onMouseOut);
         this.m_behaviourClickable.addMouseDownCallback(this.onDownMouse);
         this.m_behaviourClickable.addMouseUpCallback(this.onUpMouse);
         this.m_behaviourClickable.addClickCallback(this.onClickedHandler);
      }
      
      public function setClickCB(cb:Function) : void
      {
         this.m_clickCB = cb;
      }
      
      public function switchHighlight(value:Boolean) : void
      {
         this.m_isHighlight = value;
         if(!this.m_isOver)
         {
            if(this.m_isHighlight)
            {
               gotoAndStop(HIGH_LIGHT_FRAME);
            }
            else
            {
               gotoAndStop(NORMAL_FRAME);
            }
         }
      }
      
      private function onMouseOut() : void
      {
         this.m_isOver = false;
         var nextFrame:int = this.m_isHighlight ? HIGH_LIGHT_FRAME : NORMAL_FRAME;
         gotoAndStop(nextFrame);
      }
      
      private function onMouseOver() : void
      {
         this.m_isOver = true;
         gotoAndStop(OVER_FRAME);
      }
      
      private function onUpMouse() : void
      {
         gotoAndStop(OVER_FRAME);
      }
      
      private function onDownMouse() : void
      {
         gotoAndStop(DOWN_FRAME);
      }
      
      private function onClickedHandler() : void
      {
         if(this.m_clickCB != null)
         {
            this.m_clickCB();
         }
      }
   }
}

