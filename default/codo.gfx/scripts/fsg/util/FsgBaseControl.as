package fsg.util
{
   import flash.display.MovieClip;
   
   public class FsgBaseControl extends MovieClip
   {
      
      protected var EVT_MOUSE_OVER:String = "evt_mouse_over";
      
      protected var EVT_ACTIVATE:String = "evt_activate";
      
      public var NO_STATE:int = 0;
      
      protected var m_state:int = this.NO_STATE;
      
      public function FsgBaseControl()
      {
         super();
      }
      
      protected function onInit() : void
      {
      }
      
      public function get state() : int
      {
         return this.m_state;
      }
      
      public function set state(value:int) : void
      {
         this.m_state = value;
         this.onStateChanged();
      }
      
      protected function onStateChanged() : void
      {
      }
   }
}

