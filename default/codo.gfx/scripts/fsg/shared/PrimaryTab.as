package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class PrimaryTab extends TabBase
   {
      
      public var myBackground:MovieClip;
      
      public var myText:MovieClip;
      
      public var myHighlight:MovieClip;
      
      public var myGridLines:MovieClip;
      
      public var myBottomBar:MovieClip;
      
      private var m_bgAnim:BehaviourAnimatedSelectable;
      
      private var m_textAnim:BehaviourAnimatedSelectable;
      
      private var m_highlightAnim:BehaviourAnimatedSelectable;
      
      private var m_gridLinesAnim:BehaviourAnimatedSelectable;
      
      private var m_bottomBarAnim:BehaviourAnimatedSelectable;
      
      private var m_hitAreaAnim:BehaviourAnimatedSelectable;
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 2;
      
      private var SELECTED_STATE_FRAME:int = 3;
      
      public function PrimaryTab()
      {
         super();
         this.m_bgAnim = new BehaviourAnimatedSelectable(this.myBackground,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         this.m_textAnim = new BehaviourAnimatedSelectable(this.myText,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         this.m_highlightAnim = new BehaviourAnimatedSelectable(this.myHighlight,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         this.m_gridLinesAnim = new BehaviourAnimatedSelectable(this.myGridLines,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         this.m_bottomBarAnim = new BehaviourAnimatedSelectable(this.myBottomBar,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         this.m_hitAreaAnim = new BehaviourAnimatedSelectable(myHitArea,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
      }
      
      override public function set tabTitle(value:String) : void
      {
         super.tabTitle = value;
         this.myText.myText.text_txt.text = value;
      }
      
      override public function set autoSize(value:Boolean) : void
      {
         this.myText.myText.text_txt.autoSize = value ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
         if(value == true)
         {
            this.tabWidth = this.myText.x * 2 + this.myText.myText.text_txt.width;
         }
      }
      
      override public function set tabWidth(value:Number) : void
      {
         super.tabWidth = value;
         this.myHighlight.width = value;
         this.myGridLines.width = value;
         this.myBottomBar.width = value;
         this.myBackground.width = value;
      }
   }
}

