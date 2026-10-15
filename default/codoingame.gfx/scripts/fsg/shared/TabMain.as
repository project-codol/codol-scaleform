package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class TabMain extends TabBase
   {
      
      public var myButtonText:MovieClip;
      
      public var myNewTag:MovieClip;
      
      private var m_Animated:BehaviourAnimatedSelectable;
      
      private var UNSELECTED_STATE_FRAME:int = 1;
      
      private var HIGHLIGHTED_STATE_FRAME:int = 2;
      
      private var SELECTED_STATE_FRAME:int = 3;
      
      public function TabMain()
      {
         super();
         this.m_Animated = new BehaviourAnimatedSelectable(this,m_selectable,m_clickable,this.UNSELECTED_STATE_FRAME,this.SELECTED_STATE_FRAME,this.HIGHLIGHTED_STATE_FRAME);
      }
      
      override public function set tabTitle(value:String) : void
      {
         super.tabTitle = value;
         this.myButtonText.myTextTF.text = value;
      }
      
      override public function set autoSize(value:Boolean) : void
      {
         this.myButtonText.myTextTF.autoSize = value ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
         if(value == true)
         {
            tabWidth = this.myButtonText.x * 2 + this.myButtonText.myText.text_txt.width;
         }
      }
      
      private function enableNewTag(enable:Boolean) : void
      {
         this.myNewTag.gotoAndStop(1);
         this.myNewTag.visible = enable;
         this.myNewTag.gotoAndPlay(2);
      }
   }
}

