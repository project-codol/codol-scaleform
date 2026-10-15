package fsg.shared
{
   import codo.constants.GameInfo;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class BarDialogButton extends MovieClip
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 1;
      
      private static const DISABLED_STATE_FRAME:int = 3;
      
      private static const POSITIVE_FRAME:int = 1;
      
      private static const NEGATIVE_FRAME:int = 2;
      
      public static const TYPE_NEGATIVE:int = 2;
      
      public static const TYPE_POSITIVE:int = 1;
      
      public var myButtonText:MovieClip;
      
      public var myHitArea:MovieClip;
      
      public var myButtonBackground:MovieClip;
      
      protected var m_animated:BehaviourAnimatedClickable;
      
      protected var m_clickable:BehaviourClickable;
      
      protected var m_label:BehaviourLabel;
      
      protected var m_audio:BehaviourAudio;
      
      public function BarDialogButton()
      {
         super();
         var buttonTextfield:TextField = this.myButtonText.myButtonText != null ? this.myButtonText.myButtonText : this.myButtonText.myTextTF;
         this.m_label = new BehaviourLabel(buttonTextfield);
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME,DISABLED_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
      
      public function setText(str:String) : void
      {
         var buttonTextfield:TextField = this.myButtonText.myButtonText != null ? this.myButtonText.myButtonText : this.myButtonText.myTextTF;
         TextUtil.replaceEnFont(buttonTextfield,str,GameInfo.GAME_FONT_AENCY_FB_BOLD,0,GameInfo.GAME_FONT_S,0);
      }
      
      public function isEnabled() : Boolean
      {
         return this.m_clickable.isEnabled();
      }
      
      public function setEnabled(cEnable:Boolean) : void
      {
         this.m_audio.setEnabled(cEnable);
         this.m_clickable.setEnabled(cEnable);
         this.m_animated.setEnabled(cEnable);
      }
      
      public function registerClickEvent(callback:Function, userData:Object = null) : void
      {
         this.m_clickable.addClickCallback(callback,userData);
      }
      
      public function clearClickEvent() : void
      {
         this.m_clickable.dispose();
      }
      
      public function setDialogButtonType(type:int) : void
      {
         if(this.myButtonBackground != null)
         {
            if(type == TYPE_POSITIVE)
            {
               this.myButtonBackground.gotoAndStop(POSITIVE_FRAME);
            }
            else if(type == TYPE_NEGATIVE)
            {
               this.myButtonBackground.gotoAndStop(NEGATIVE_FRAME);
            }
         }
      }
      
      public function forceSelect() : void
      {
         this.m_animated.overrideAnimFrame(OVER_STATE_FRAME,OVER_STATE_FRAME,OVER_STATE_FRAME,OVER_STATE_FRAME);
         this.setEnabled(this.isEnabled());
      }
      
      public function resetSelection() : void
      {
         this.m_animated.overrideAnimFrame(UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME,DISABLED_STATE_FRAME);
         this.setEnabled(this.isEnabled());
      }
   }
}

