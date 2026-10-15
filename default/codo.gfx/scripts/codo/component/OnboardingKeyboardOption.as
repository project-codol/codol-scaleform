package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.Common;
   import codo.localization.DictKeyboard;
   import codo.utils.KeyboardUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class OnboardingKeyboardOption extends UIInteractiveComponent
   {
      
      private static const FRAME_SELECTED:uint = 1;
      
      private static const FRAME_UNSELECTED:uint = 2;
      
      public var myCheckbox:MovieClip;
      
      public var myLayoutDescriptionTF:flash.text.TextField;
      
      public var myLayoutSubTF:flash.text.TextField;
      
      public var myLayoutHeaderTF:flash.text.TextField;
      
      public var myKeyboardLayout:MovieClip;
      
      private var mSelected:Boolean = false;
      
      private var mKeyboardID:int = 1;
      
      public function OnboardingKeyboardOption()
      {
         super();
         isInteractiveEnabled = true;
         this.updateHighlightState();
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         this.updateHighlightState();
      }
      
      public function get keyboardID() : int
      {
         return this.mKeyboardID;
      }
      
      override public function setData(data:*) : void
      {
         var txtLoc:String = null;
         super.setData(data);
         this.mKeyboardID = data as int;
         switch(this.mKeyboardID)
         {
            case Common.KEYBOARD_CODO:
               txtLoc = KeyboardUtil.LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_LAYOUT_COD_TITLE);
               this.myLayoutHeaderTF.text = txtLoc.toUpperCase();
               txtLoc = KeyboardUtil.LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_LAYOUT_COD_SUBTITLE);
               this.myLayoutSubTF.htmlText = txtLoc.toUpperCase();
               this.myLayoutDescriptionTF.text = DictKeyboard.KEYBOARD_CONTROL_LAYOUT_COD_DESCRIPTION;
               KeyboardUtil.populateKeyboardControls(this.myKeyboardLayout,true,1);
               break;
            case Common.KEYBOARD_CROSSFIRE:
               txtLoc = KeyboardUtil.LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_LAYOUT_OTHER_FPS_TITLE);
               this.myLayoutHeaderTF.text = txtLoc.toUpperCase();
               txtLoc = KeyboardUtil.LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_LAYOUT_OTHER_FPS_SUBTITLE);
               this.myLayoutSubTF.htmlText = txtLoc.toUpperCase();
               this.myLayoutDescriptionTF.text = DictKeyboard.KEYBOARD_CONTROL_LAYOUT_OTHER_FPS_DESCRIPTION;
               KeyboardUtil.populateKeyboardControls(this.myKeyboardLayout,false,1);
         }
         this.myLayoutDescriptionTF.y = this.myLayoutSubTF.y + this.myLayoutSubTF.textHeight + 17;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mSelected)
         {
            gotoAndStop(FRAME_SELECTED);
            this.myLayoutDescriptionTF.textColor = 16777215;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.updateHighlightState();
      }
      
      private function updateHighlightState() : void
      {
         var frame:int = this.mSelected ? int(FRAME_SELECTED) : int(FRAME_UNSELECTED);
         gotoAndStop(frame);
         this.myCheckbox.gotoAndStop(frame);
         this.myLayoutDescriptionTF.textColor = this.mSelected ? 16777215 : 8049659;
      }
   }
}

