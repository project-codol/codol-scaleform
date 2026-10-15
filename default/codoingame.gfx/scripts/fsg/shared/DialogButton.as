package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class DialogButton extends MovieClip
   {
      
      public static const TYPE_APPLY:int = 0;
      
      public static const TYPE_CANCEL:int = 1;
      
      public static const TYPE_SPECIAL:int = 2;
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      private static const HIT_STATE_FRAME:int = 4;
      
      private static const DISABLED_STATE_FRAME:int = 5;
      
      private static const APPLY_BG_FRAME:int = 2;
      
      private static const CANCEL_BG_FRAME:int = 1;
      
      private static const SPECIAL_BG_FRAME:int = 3;
      
      public var myHitArea:MovieClip;
      
      public var myTextField:TextField;
      
      public var myBackGround:MovieClip;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_label:BehaviourLabel;
      
      private var m_audio:BehaviourAudio;
      
      public function DialogButton()
      {
         super();
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_label = new BehaviourLabel(this.myTextField);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function setDialogButtonType(type:int) : void
      {
         if(type == TYPE_APPLY)
         {
            this.myBackGround.gotoAndStop(APPLY_BG_FRAME);
         }
         else if(type == TYPE_CANCEL)
         {
            this.myBackGround.gotoAndStop(CANCEL_BG_FRAME);
         }
         else
         {
            this.myBackGround.gotoAndStop(SPECIAL_BG_FRAME);
         }
      }
      
      public function setText(str:String) : void
      {
         this.m_label.setText(str);
      }
      
      public function registerClickEvent(callback:Function) : void
      {
         this.m_clickable.addClickCallback(callback);
      }
   }
}

