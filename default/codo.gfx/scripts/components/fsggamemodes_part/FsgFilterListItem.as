package components.fsggamemodes_part
{
   import flash.display.MovieClip;
   import fsg.shared.BehaviourAnimatedSelectable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.BehaviourSelectable;
   
   public class FsgFilterListItem extends MovieClip
   {
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var SELECTED_STATE_FRAME:int = 2;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 3;
      
      public var myHitArea:MovieClip;
      
      public var myLabelText:MovieClip;
      
      private var m_animated:BehaviourAnimatedSelectable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_selectable:BehaviourSelectable;
      
      private var m_audio:BehaviourAudio;
      
      public function FsgFilterListItem()
      {
         super();
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_selectable = new BehaviourSelectable(this.m_clickable,false);
         this.m_animated = new BehaviourAnimatedSelectable(this,this.m_selectable,this.m_clickable,this.UNSELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME,this.SELECTED_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function addSelectedCallback(fnSelectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.addSelectedCallback(fnSelectedCallback,userData);
      }
      
      public function removeSelectedCallback(fnSelectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.addSelectedCallback(fnSelectedCallback,userData);
      }
      
      public function setText(str:String) : void
      {
         this.myLabelText.myTextTF.text = str;
      }
      
      public function select() : void
      {
         this.m_selectable.state = BehaviourSelectable.STATE_SELECTED;
      }
      
      public function unselect() : void
      {
         this.m_selectable.state = BehaviourSelectable.STATE_UNSELECTED;
      }
   }
}

