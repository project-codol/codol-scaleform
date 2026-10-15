package fsg.shared
{
   import codo.constants.SE_ID;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgAudioUtil;
   
   public class CheckBox extends MovieClip
   {
      
      public var myLabel:MovieClip;
      
      public var myHitArea:MovieClip;
      
      public var myCheckBox:MovieClip;
      
      private var m_animated:BehaviourAnimatedClickable;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_selectable:BehaviourSelectable;
      
      private var m_label:BehaviourLabel;
      
      private var m_tooltip:BehaviourTooltip;
      
      private var m_audio:BehaviourAudio;
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var SELECTED_STATE_FRAME:int = 3;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 2;
      
      public function CheckBox()
      {
         super();
         this.m_label = new BehaviourLabel(this.myLabel.myCheckBoxText);
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_selectable = new BehaviourSelectable(this.m_clickable,true);
         this.m_animated = new BehaviourAnimatedClickable(this.myCheckBox,this.m_clickable,this.UNSELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME,this.SELECTED_STATE_FRAME);
         this.m_audio = new BehaviourAudio(this.m_clickable,SE_ID.GENERAL_ROLLOVER,SE_ID.MUTE);
         this.myCheckBox.myTick.visible = false;
         this.m_selectable.addSelectedCallback(this.onSelected);
         this.m_selectable.addUnselectedCallback(this.onUnselected);
         this.myLabel.myCheckBoxText.autoSize = TextFieldAutoSize.LEFT;
         this.m_clickable.addClickCallback(this.onClicked);
      }
      
      public function setText(str:String, tooltip:String = null) : void
      {
         this.m_label.setText(str);
         if(tooltip != null)
         {
            this.m_tooltip = new BehaviourTooltip(this.m_clickable,tooltip,this.myCheckBox);
         }
      }
      
      public function set checked(value:Boolean) : void
      {
         this.m_selectable.state = value ? BehaviourSelectable.STATE_SELECTED : BehaviourSelectable.STATE_UNSELECTED;
      }
      
      public function get checked() : Boolean
      {
         return this.m_selectable.state == BehaviourSelectable.STATE_SELECTED;
      }
      
      public function addCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.addSelectedCallback(fnCallback,userData);
      }
      
      public function removeCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.removeSelectedCallback(fnCallback,userData);
      }
      
      public function addUncheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.addUnselectedCallback(fnCallback,userData);
      }
      
      public function removeUncheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.removeUnselectedCallback(fnCallback,userData);
      }
      
      public function set enable(enabled:Boolean) : void
      {
         if(enabled)
         {
            this.myCheckBox.alpha = 1;
            this.myLabel.alpha = 1;
         }
         else
         {
            this.myCheckBox.alpha = 0.5;
            this.myLabel.alpha = 0.5;
         }
         this.m_clickable.setMouseHoverOverride(!enabled);
         this.m_clickable.setEnabled(enabled);
      }
      
      public function get enable() : Boolean
      {
         return this.m_clickable.isEnabled();
      }
      
      private function onSelected() : void
      {
         this.myCheckBox.myTick.visible = true;
      }
      
      private function onUnselected() : void
      {
         this.myCheckBox.myTick.visible = false;
      }
      
      private function onClicked() : void
      {
         if(this.checked)
         {
            FsgAudioUtil.getInstance().playSound("ui_checkbox_check");
         }
         else
         {
            FsgAudioUtil.getInstance().playSound("ui_checkbox_uncheck");
         }
      }
   }
}

