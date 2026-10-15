package fsg.shared
{
   import flash.display.MovieClip;
   
   public class SubTab extends TabBase
   {
      
      public var myLabel:MovieClip;
      
      private var m_animBehaviour:BehaviourAnimatedSelectable;
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var SELECTED_STATE_FRAME:int = 3;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 2;
      
      public function SubTab()
      {
         super();
         this.m_animBehaviour = new BehaviourAnimatedSelectable(this,this.m_selectable,this.m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         audio.overrideMouseOverAudio("ui_secondaryselect_rollover");
         audio.overrideClickAudio("ui_secondaryselect_proceed");
      }
      
      override public function set tabTitle(value:String) : void
      {
         this.myLabel.text_txt.text = value;
      }
      
      override public function set autoSize(value:Boolean) : void
      {
      }
      
      override public function set tabWidth(value:Number) : void
      {
      }
   }
}

