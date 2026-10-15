package fsg.util
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgBaseButton extends FsgBaseControl
   {
      
      public var m_bHasFocus:Boolean;
      
      public var m_isSettable:Boolean;
      
      public var m_buttonType:int = 0;
      
      public var UP_STATE:int = 1;
      
      public var OVER_STATE:int = 2;
      
      public var DOWN_STATE:int = 3;
      
      public var HIT_STATE:int = 4;
      
      public var DISABLED_STATE:int = 5;
      
      private var m_hitObject:MovieClip;
      
      private var m_LabelObject:MovieClip;
      
      protected var m_isActive:Boolean;
      
      protected var m_button:MovieClip;
      
      protected var m_label:TextField;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_clickedCallBack:Function;
      
      private var m_audio:BehaviourAudio;
      
      public function FsgBaseButton(button:MovieClip)
      {
         super();
         this.m_button = button;
         this.onInit();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.m_bHasFocus = false;
         this.m_isSettable = true;
      }
      
      public function setHitObject(obj:MovieClip) : void
      {
         try
         {
         }
         finally
         {
            this.m_hitObject = obj;
            if(this.m_hitObject != null)
            {
               this.m_clickable = new BehaviourClickable(this.m_hitObject);
               this.m_clickable.addMouseOverCallback(this.onMouseOver);
               this.m_clickable.addMouseOutCallback(this.onMouseOut);
               this.m_clickable.addMouseDownCallback(this.callMouseDownCallBack);
               this.m_clickable.addClickCallback(this.onSelect);
               this.m_audio = new BehaviourAudio(this.m_clickable);
            }
         }
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
      
      public function set audio(cBehaviour:BehaviourAudio) : void
      {
         this.m_audio = cBehaviour;
      }
      
      public function set onClickCallback(func:Function) : void
      {
         this.m_clickedCallBack = func;
      }
      
      public function setLabelField(f:TextField) : void
      {
         this.m_label = f;
      }
      
      override protected function onStateChanged() : void
      {
         if(this.m_bHasFocus == false)
         {
            gotoAndStop(state);
            this.m_button.gotoAndStop(state);
         }
      }
      
      private function onMouseOver() : void
      {
         state = this.OVER_STATE;
      }
      
      private function onMouseOut() : void
      {
         state = this.UP_STATE;
      }
      
      protected function onSelect() : void
      {
         gotoAndStop(this.DOWN_STATE);
         if(this.m_isSettable == true)
         {
            this.m_bHasFocus = true;
         }
      }
      
      private function callMouseDownCallBack() : void
      {
         if(this.m_clickedCallBack != null)
         {
            this.m_clickedCallBack(this.m_button);
         }
      }
      
      public function setLabel(label:String) : void
      {
         if(this.m_label != null)
         {
            this.m_label.text = label;
         }
      }
      
      public function setActive(cActive:Boolean) : void
      {
         this.m_bHasFocus = false;
         if(cActive == true)
         {
            state = this.DOWN_STATE;
            this.m_isActive = true;
         }
         else
         {
            state = this.UP_STATE;
            this.m_isActive = false;
         }
         this.m_bHasFocus = cActive;
      }
      
      public function isActive() : Boolean
      {
         return this.m_isActive;
      }
      
      public function setInert(bState:Boolean) : void
      {
         this.m_bHasFocus = false;
         if(bState == true)
         {
            state = this.DISABLED_STATE;
         }
         else
         {
            state = this.UP_STATE;
         }
         this.m_bHasFocus = bState;
      }
   }
}

