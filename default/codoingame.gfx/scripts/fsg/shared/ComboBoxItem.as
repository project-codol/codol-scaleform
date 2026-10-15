package fsg.shared
{
   import codo.constants.SE_ID;
   import codo.event.ComboBoxItemEvent;
   import codo.objects.ToolTipObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class ComboBoxItem extends MovieClip
   {
      
      private static const FRAME_IDLE:uint = 1;
      
      private static const FRAME_HIGHLIGHTED:uint = 2;
      
      private static const FRAME_PRESSED:uint = 2;
      
      private static const FRAME_DISABLED:uint = 5;
      
      public var myHitArea:MovieClip;
      
      public var myLabel:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_labelBehaviour:BehaviourLabel;
      
      private var m_anim:BehaviourAnimatedClickable;
      
      private var m_audio:BehaviourAudio;
      
      private var m_toolTipObject:ToolTipObject;
      
      public function ComboBoxItem()
      {
         super();
         this.myLabel.myTF.defaultTextFormat = this.myLabel.myTF.getTextFormat();
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_anim = new BehaviourAnimatedClickable(this,this.m_clickable,FRAME_IDLE,FRAME_HIGHLIGHTED,FRAME_PRESSED,FRAME_DISABLED);
         this.m_audio = new BehaviourAudio(this.m_clickable,SE_ID.GENERAL_ROLLOVER,SE_ID.UI_MENU_ROLLOUT_PROCEED);
         this.m_labelBehaviour = new BehaviourLabel(this.myLabel.myTF);
      }
      
      public function set label(cLabel:String) : void
      {
         this.m_labelBehaviour.setText(cLabel);
      }
      
      override public function set enabled(isEnabled:Boolean) : void
      {
         super.enabled = mouseEnabled = isEnabled;
         this.m_anim.setEnabled(isEnabled);
         if(!isEnabled)
         {
            this.m_audio.overrideClickAudio(SE_ID.GENERAL_LOCKED);
            this.m_clickable.addMouseOverCallback(this.onDisabledItemMouseEvent,{
               "hasFocus":true,
               "label":this.myLabel.myTF.text
            });
            this.m_clickable.addMouseOutCallback(this.onDisabledItemMouseEvent,{"hasFocus":false});
         }
      }
      
      private function onDisabledItemMouseEvent(data:Object) : void
      {
         var disabledItemEvent:ComboBoxItemEvent = null;
         if(Boolean(data.hasFocus))
         {
            disabledItemEvent = new ComboBoxItemEvent(ComboBoxItemEvent.ITEM_DISABLED_ONFOCUS,this.myLabel.myTF.text,true);
         }
         else
         {
            disabledItemEvent = new ComboBoxItemEvent(ComboBoxItemEvent.ITEM_DISABLED_ONUNFOCUS,null,false);
         }
         dispatchEvent(disabledItemEvent);
      }
      
      public function returnToolTipConfig() : ToolTipObject
      {
         var TOOL_TIP_FONT:String = null;
         var toolTipFormat:TextFormat = null;
         if(this.m_toolTipObject == null)
         {
            TOOL_TIP_FONT = "$font_2";
            toolTipFormat = new TextFormat();
            toolTipFormat.font = TOOL_TIP_FONT;
            this.m_toolTipObject = new ToolTipObject(this.myHitArea);
            this.m_toolTipObject.offsetPoint = new Point(this.myHitArea.width,0);
            this.m_toolTipObject.textFormatting = toolTipFormat;
         }
         return this.m_toolTipObject;
      }
      
      public function get label() : String
      {
         return this.m_labelBehaviour.getText();
      }
      
      override public function get height() : Number
      {
         return 21;
      }
      
      public function registerMouseDownEvent(callback:Function, userData:Object = null) : void
      {
         this.m_clickable.addMouseDownCallback(callback,userData);
      }
      
      public function dispose() : void
      {
      }
   }
}

