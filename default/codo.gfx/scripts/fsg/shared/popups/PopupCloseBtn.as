package fsg.shared.popups
{
   import codo.constants.SE_ID;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgAudioUtil;
   
   public class PopupCloseBtn extends MovieClip
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const PULSE_STATE_FRAME:int = 3;
      
      private var m_Clickable:BehaviourClickable;
      
      private var m_Audio:BehaviourAudio;
      
      public var myHitArea:Sprite;
      
      private var mIsPulsingAnim:Boolean = false;
      
      public function PopupCloseBtn()
      {
         super();
         this.m_Clickable = new BehaviourClickable(this.myHitArea);
         this.m_Clickable.addClickCallback(this.onMouseClick);
         this.m_Clickable.addMouseOutCallback(this.onMouseOut);
         this.m_Clickable.addMouseOverCallback(this.onMouseOver);
         this.m_Audio = new BehaviourAudio(this.m_Clickable);
         addFrameScript(PULSE_STATE_FRAME,this.playPulseSound);
      }
      
      public function overrideClickAudio(cSndName:String) : void
      {
         this.m_Audio.overrideClickAudio(cSndName);
      }
      
      public function registerClickEvent(callback:Function, userData:Object = null) : void
      {
         this.m_Clickable.addClickCallback(callback,userData);
      }
      
      public function unregisterClickEvent(callback:Function, userData:Object = null) : void
      {
         this.m_Clickable.removeClickCallback(callback,userData);
      }
      
      public function set isPulsingAnim(doPulse:Boolean) : void
      {
         this.mIsPulsingAnim = doPulse;
         if(doPulse)
         {
            gotoAndPlay(PULSE_STATE_FRAME);
         }
         else
         {
            gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      private function playPulseSound() : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_STENCIL_READY_PULSE);
      }
      
      private function onMouseOver() : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mIsPulsingAnim)
         {
            gotoAndPlay(OVER_STATE_FRAME);
         }
      }
      
      private function onMouseOut() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mIsPulsingAnim)
         {
            gotoAndPlay(UP_STATE_FRAME);
         }
      }
      
      private function onMouseClick() : void
      {
         gotoAndPlay(OVER_STATE_FRAME);
      }
   }
}

