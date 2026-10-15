package fsg.shared
{
   import codo.constants.SE_ID;
   import codo.interfaces.IDisposable;
   import fsg.util.FsgAudioUtil;
   
   public class BehaviourAudio implements IDisposable
   {
      
      private var m_clickable:BehaviourClickable;
      
      private var m_mouseOverSndName:String;
      
      private var m_mouseClickSndName:String;
      
      private var m_mouseClickLockedSndName:String;
      
      private var m_isEnable:Boolean;
      
      public function BehaviourAudio(clickable:BehaviourClickable, cMouseOverSndName:String = "ui_general_rollover", cMouseClickSndName:String = "UI_General_Select_Alt_01", cMouseClickLockedSndName:String = "ui_general_locked")
      {
         super();
         this.m_clickable = clickable;
         this.m_mouseOverSndName = cMouseOverSndName;
         this.m_mouseClickSndName = cMouseClickSndName;
         this.m_mouseClickLockedSndName = cMouseClickLockedSndName;
         this.m_clickable.addClickCallback(this.onClickHandler);
         this.m_isEnable = false;
         this.setEnabled(true);
      }
      
      public function dispose() : void
      {
         if(this.m_clickable == null)
         {
            return;
         }
         this.m_clickable.removeClickCallback(this.onClickHandler);
         this.setEnabled(false);
         this.m_clickable = null;
      }
      
      public function overrideMouseOverAudio(cSndName:String) : void
      {
         this.m_mouseOverSndName = cSndName;
      }
      
      public function overrideClickAudio(cSndName:String) : void
      {
         this.m_mouseClickSndName = cSndName;
      }
      
      public function overrideLockedAudio(cSndName:String) : void
      {
         this.m_mouseClickLockedSndName = cSndName;
      }
      
      public function setEnabled(value:Boolean) : void
      {
         if(this.m_isEnable == value)
         {
            return;
         }
         this.m_isEnable = value;
         if(this.m_isEnable)
         {
            this.m_clickable.addMouseOverCallback(this.onMouseOverHandler);
            this.m_clickable.addMouseRollOverCallback(this.onMouseOverHandler);
         }
         else
         {
            this.m_clickable.removeMouseOverCallback(this.onMouseOverHandler);
            this.m_clickable.removeMouseRollOverCallback(this.onMouseOverHandler);
         }
      }
      
      private function onClickHandler() : void
      {
         if(this.m_isEnable)
         {
            if(this.m_mouseClickSndName != null && this.m_mouseClickSndName != "" && this.m_mouseClickSndName != SE_ID.MUTE)
            {
               this.playSound(this.m_mouseClickSndName);
            }
         }
         else if(this.m_mouseClickLockedSndName != null && this.m_mouseClickLockedSndName != "" && this.m_mouseClickLockedSndName != SE_ID.MUTE)
         {
            this.playSound(this.m_mouseClickLockedSndName);
         }
      }
      
      private function onMouseOverHandler() : void
      {
         if(this.m_mouseOverSndName != null && this.m_mouseOverSndName != "" && this.m_mouseOverSndName != SE_ID.MUTE)
         {
            this.playSound(this.m_mouseOverSndName);
         }
      }
      
      private function playSound(cSndName:String) : void
      {
         FsgAudioUtil.getInstance().playSound(cSndName);
      }
   }
}

