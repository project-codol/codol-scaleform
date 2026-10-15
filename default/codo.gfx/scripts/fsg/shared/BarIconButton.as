package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class BarIconButton extends MovieClip
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 1;
      
      private static const POSITIVE_FRAME:int = 1;
      
      private static const NEGATIVE_FRAME:int = 2;
      
      public static const TYPE_NEGATIVE:int = 2;
      
      public static const TYPE_POSITIVE:int = 1;
      
      public var myButtonText:MovieClip;
      
      public var myHitArea:MovieClip;
      
      public var myButtonBackground:MovieClip;
      
      public var myIcon:MovieClip;
      
      public var myDWIcon:MovieClip;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_label:BehaviourLabel;
      
      private var m_audio:BehaviourAudio;
      
      public function BarIconButton()
      {
         super();
         this.myDWIcon.visible = false;
         var buttonTextfield:TextField = this.myButtonText.myButtonText != null ? this.myButtonText.myButtonText : this.myButtonText.myTextTF;
         this.m_label = new BehaviourLabel(buttonTextfield);
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME,3);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
      
      public function setIcon(str:String) : void
      {
         this.myIcon.gotoAndStop(str);
      }
      
      public function setText(str:String) : void
      {
         var buttonTextfield:TextField = this.myButtonText.myButtonText != null ? this.myButtonText.myButtonText : this.myButtonText.myTextTF;
         buttonTextfield.text = str;
      }
      
      public function setEnabled(cEnable:Boolean) : void
      {
         this.m_animated.setEnabled(cEnable);
      }
      
      public function setUnavailable(cUnavailable:Boolean) : void
      {
         if(cUnavailable == true)
         {
            this.setEnabled(false);
         }
         this.myDWIcon.visible = cUnavailable;
      }
      
      public function registerClickEvent(callback:Function, userData:Object = null) : void
      {
         this.m_clickable.addClickCallback(callback,userData);
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
   }
}

