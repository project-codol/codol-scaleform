package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class Tab extends TabBase
   {
      
      public var myTabTitle:MovieClip;
      
      public var myTabBG:MovieClip;
      
      private var m_animatedText:BehaviourAnimatedSelectable;
      
      protected var m_animatedBG:BehaviourAnimatedSelectable;
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var SELECTED_STATE_FRAME:int = 2;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 2;
      
      public function Tab()
      {
         super();
         this.m_animatedText = new BehaviourAnimatedSelectable(this,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
         this.m_animatedBG = new BehaviourAnimatedSelectable(this.myTabBG,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.UNSELECTED_STATE_FRAME);
      }
      
      override public function set autoSize(value:Boolean) : void
      {
         if(value)
         {
            this.myTabTitle.myTextTF.autoSize = TextFieldAutoSize.LEFT;
            this.tabWidth = this.myTabTitle.x * 2 + this.myTabTitle.myTextTF.width;
         }
         else
         {
            this.myTabTitle.myTextTF.autoSize = TextFieldAutoSize.NONE;
         }
      }
      
      override public function set tabTitle(str:String) : void
      {
         super.tabTitle = str;
         this.myTabTitle.myTextTF.text = str;
      }
      
      override public function get tabTitle() : String
      {
         return this.myTabTitle.myTextTF.text;
      }
      
      override public function set tabWidth(nWidth:Number) : void
      {
         super.tabWidth = nWidth;
         this.myTabTitle.myTextTF.width = nWidth;
         this.myTabBG.width = nWidth;
      }
   }
}

