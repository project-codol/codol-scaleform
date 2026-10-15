package components.fsgkeyboardpanel_part
{
   import flash.display.MovieClip;
   
   public class FsgKeyboardPanelOption extends MovieClip
   {
      
      private static const FRAME_SELECTED:uint = 1;
      
      private static const FRAME_UNSELECTED:uint = 2;
      
      private static const FRAME_HIGHLIGHT:uint = 3;
      
      public var myHitArea:MovieClip;
      
      public var myCheckbox:MovieClip;
      
      public var myLayoutTexts:MovieClip;
      
      private var m_optionSelected:Boolean = false;
      
      private var m_optionID:int = 0;
      
      private var m_onSelectedCallBack:Function;
      
      public function FsgKeyboardPanelOption()
      {
         super();
         this.myCheckbox.gotoAndStop(FRAME_UNSELECTED);
      }
      
      public function setLayoutHeaderText(txt:String) : void
      {
         this.myLayoutTexts.myLayoutHeaderTF.text = txt;
      }
      
      public function setOnSelectedCallBack(func:Function) : void
      {
         this.m_onSelectedCallBack = func;
      }
      
      public function setLayoutSubHeaderText(txt:String) : void
      {
         this.myLayoutTexts.myLayoutSubTF.text = txt;
      }
      
      public function get selected() : Boolean
      {
         return this.m_optionSelected;
      }
      
      public function set selected(isSelected:Boolean) : void
      {
         this.m_optionSelected = isSelected;
         this.myCheckbox.gotoAndStop(isSelected ? FRAME_SELECTED : FRAME_UNSELECTED);
         this.gotoAndStop(isSelected ? FRAME_SELECTED : FRAME_UNSELECTED);
         if(isSelected && this.m_onSelectedCallBack != null)
         {
            this.m_onSelectedCallBack();
         }
      }
      
      public function set rollOver(isRollOver:Boolean) : void
      {
         if(!this.m_optionSelected)
         {
            this.myCheckbox.gotoAndStop(isRollOver ? FRAME_HIGHLIGHT : FRAME_UNSELECTED);
         }
      }
      
      public function get keyboardID() : int
      {
         return this.m_optionID;
      }
      
      public function set keyboardID(id:int) : void
      {
         this.m_optionID = id;
      }
   }
}

