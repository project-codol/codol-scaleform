package fsg.component
{
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.SE_ID;
   import codo.localization.DictOnBoard;
   import codo.utils.CursorUtil;
   import codo.utils.KeyboardUtil;
   import codo.views.option_sub.FsgOptionPanel;
   import components.fsgkeyboardpanel_part.FsgKeyboardPanelOption;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import fsg.shared.BarDialogButton;
   import fsg.util.FsgAudioUtil;
   
   public class FsgKeyboardPanel extends FsgOptionPanel
   {
      
      public static const COD_FRAME:int = 2;
      
      public var myOptionStandard:FsgKeyboardPanelOption;
      
      public var myOptionTraditional:FsgKeyboardPanelOption;
      
      public var myConfirmBtn:BarDialogButton;
      
      public var myKeyboardImage:MovieClip;
      
      private var m_currentSelectedOption:FsgKeyboardPanelOption;
      
      private var m_userDefinedSelectedOptionID:int = 1;
      
      public function FsgKeyboardPanel()
      {
         super();
      }
      
      public function get isDirty() : Boolean
      {
         return this.m_userDefinedSelectedOptionID != this.m_currentSelectedOption.keyboardID;
      }
      
      public function get keyboard() : int
      {
         return this.m_currentSelectedOption.keyboardID;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         buttonMode = mouseEnabled = false;
         if(this.myConfirmBtn != null)
         {
            this.myConfirmBtn.setText(DictOnBoard.CONFIRM_KEYBOARD);
         }
         this.myOptionStandard.setLayoutHeaderText(DictOnBoard.FIRST_KEYBOARD_BUTTON_01_TITLE);
         this.myOptionStandard.setLayoutSubHeaderText(DictOnBoard.FIRST_KEYBOARD_BUTTON_01_SUBTITLE);
         this.myOptionStandard.keyboardID = Common.KEYBOARD_CODO;
         this.myOptionStandard.setOnSelectedCallBack(this.onStandardSelected);
         this.myOptionTraditional.setLayoutHeaderText(DictOnBoard.FIRST_KEYBOARD_BUTTON_02_TITLE);
         this.myOptionTraditional.setLayoutSubHeaderText(DictOnBoard.FIRST_KEYBOARD_BUTTON_02_SUBTITLE);
         this.myOptionTraditional.keyboardID = Common.KEYBOARD_CROSSFIRE;
         this.myOptionTraditional.setOnSelectedCallBack(this.onTraditionalSelected);
         KeyboardUtil.populateKeyboardControls(this.myKeyboardImage.myKeyboardStandardImage,true,COD_FRAME);
         KeyboardUtil.populateKeyboardControls(this.myKeyboardImage.myKeyboardTraditionalImage,false,COD_FRAME);
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         listen(BCEvent.EVT_REFRESH_CONTROL_VIEW,this.onRefreshControlViewHandle);
      }
      
      private function onStandardSelected() : void
      {
         this.myKeyboardImage.gotoAndPlay("standard");
      }
      
      private function onTraditionalSelected() : void
      {
         this.myKeyboardImage.gotoAndPlay("traditional");
      }
      
      private function onRefreshControlViewHandle() : void
      {
         this.setUserDefinedKeyboardType(Common.KEYBOARD_CODO);
      }
      
      public function setUserDefinedKeyboardType(keyboardType:int) : void
      {
         this.m_userDefinedSelectedOptionID = keyboardType;
         this.myOptionStandard.selected = keyboardType != Common.KEYBOARD_CROSSFIRE;
         this.myOptionTraditional.selected = !this.myOptionStandard.selected;
         if(this.myOptionStandard.selected)
         {
            this.m_currentSelectedOption = this.myOptionStandard;
         }
         else
         {
            this.m_currentSelectedOption = this.myOptionTraditional;
         }
      }
      
      override protected function onMouseOutHandler(e:MouseEvent) : void
      {
         if(!(e.target is MovieClip))
         {
            return;
         }
         var clickedBtn:MovieClip = e.target as MovieClip;
         var keyboardOption:FsgKeyboardPanelOption = clickedBtn.parent as FsgKeyboardPanelOption;
         if(Boolean(keyboardOption))
         {
            keyboardOption.rollOver = false;
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
      }
      
      override protected function onMouseOverHandler(e:MouseEvent) : void
      {
         if(!(e.target is MovieClip))
         {
            return;
         }
         var clickedBtn:MovieClip = e.target as MovieClip;
         var keyboardOption:FsgKeyboardPanelOption = clickedBtn.parent as FsgKeyboardPanelOption;
         if(Boolean(keyboardOption))
         {
            keyboardOption.rollOver = true;
            FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
            CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
      }
      
      override protected function onClickHandler(e:MouseEvent) : void
      {
         var selectedOption:FsgKeyboardPanelOption = null;
         if(!e.target is MovieClip)
         {
            return;
         }
         var clickedBtn:MovieClip = e.target as MovieClip;
         if(clickedBtn.parent is FsgKeyboardPanelOption)
         {
            selectedOption = clickedBtn.parent as FsgKeyboardPanelOption;
            if(this.m_currentSelectedOption == selectedOption)
            {
               return;
            }
            selectedOption.selected = true;
            if(this.m_currentSelectedOption != null)
            {
               this.m_currentSelectedOption.selected = false;
               FsgAudioUtil.getInstance().playSound(SE_ID.CHECKBOX_UNCHECK);
            }
            this.m_currentSelectedOption = selectedOption;
            FsgAudioUtil.getInstance().playSound(SE_ID.CHECKBOX_CHECK);
         }
      }
   }
}

