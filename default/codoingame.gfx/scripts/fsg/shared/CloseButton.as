package fsg.shared
{
   import codo.constants.ButtonTLog;
   import codo.utils.TLogUtil;
   import flash.display.MovieClip;
   
   public class CloseButton extends MovieClip
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      public var myHitArea:MovieClip;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_audio:BehaviourAudio;
      
      public function CloseButton()
      {
         super();
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,UP_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable,"ui_general_rollover","ui_general_back");
         this.registerClickEvent(this.performTLog);
      }
      
      private function performTLog() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_CLOSE);
      }
      
      public function overrideClickAudio(cSndName:String) : void
      {
         this.m_audio.overrideClickAudio(cSndName);
      }
      
      public function registerClickEvent(callback:Function) : void
      {
         this.m_clickable.addClickCallback(callback);
      }
      
      public function unregisterClickEvent(callback:Function) : void
      {
         this.m_clickable.removeClickCallback(callback);
      }
      
      public function set interactive(interactive:Boolean) : void
      {
         this.m_clickable.setEnabled(interactive);
         this.m_clickable.setEnableMouseHighlight(interactive);
      }
   }
}

