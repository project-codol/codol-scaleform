package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TextFieldTab extends TabBase
   {
      
      public var myTabTitle:MovieClip;
      
      public var myTitle:TextField;
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var SELECTED_STATE_FRAME:int = 2;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 2;
      
      private var m_animatedText:BehaviourAnimatedSelectable;
      
      public function TextFieldTab()
      {
         super();
         this.myTitle = this.myTabTitle["myText"];
         this.m_animatedText = new BehaviourAnimatedSelectable(this,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
      }
      
      override public function set autoSize(value:Boolean) : void
      {
         if(value)
         {
            this.myTitle.autoSize = TextFieldAutoSize.LEFT;
            this.tabWidth = this.myTabTitle.x * 2 + this.myTabTitle.width;
         }
         else
         {
            this.myTitle.autoSize = TextFieldAutoSize.NONE;
         }
      }
      
      override public function set tabTitle(str:String) : void
      {
         super.tabTitle = str;
         this.myTitle.text = str;
         myHitArea.width = this.myTitle.textWidth;
      }
      
      override public function get tabTitle() : String
      {
         return this.myTitle.text;
      }
      
      override public function set tabWidth(nWidth:Number) : void
      {
         super.tabWidth = nWidth;
         this.myTitle.width = nWidth;
      }
   }
}

