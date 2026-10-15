package fsg.shared
{
   import flash.display.MovieClip;
   
   public class ButtonGeneric extends MovieClip
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      public var myButtonText:MovieClip;
      
      public var myHitArea:MovieClip;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_label:BehaviourLabel;
      
      private var m_audio:BehaviourAudio;
      
      private var m_tooltip:BehaviourTooltip;
      
      public function ButtonGeneric()
      {
         super();
         this.m_label = new BehaviourLabel(this.myButtonText.myButtonText);
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_animated = new BehaviourAnimatedClickable(this,this.m_clickable,UP_STATE_FRAME,OVER_STATE_FRAME,DOWN_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function setText(str:String, tooltip:String) : void
      {
         this.m_label.setText(str);
         if(tooltip != null)
         {
            this.m_tooltip = new BehaviourTooltip(this.m_clickable,tooltip,this.myHitArea);
         }
      }
      
      public function getText() : String
      {
         return this.m_label.getText();
      }
      
      public function registerClickEvent(callback:Function, userData:Object = null) : void
      {
         this.m_clickable.addClickCallback(callback,userData);
      }
   }
}

