package fsg.shared
{
   import flash.display.MovieClip;
   
   public class ComboBoxDropDownMenu extends ScrollList
   {
      
      public var myItemBackground:MovieClip;
      
      private var m_maxItemCount:int = 4;
      
      public function ComboBoxDropDownMenu()
      {
         super();
      }
      
      public function set menuHeight(menuHeight:int) : void
      {
         this.myMask.height = menuHeight;
         this.myItemBackground.height = menuHeight;
         this.myScrollBar.height = menuHeight;
      }
      
      public function get menuHeight() : int
      {
         return this.myMask.height;
      }
      
      public function set maxVisibleItemCount(count:int) : void
      {
         this.m_maxItemCount = count;
      }
      
      public function get maxVisibleItemCount() : int
      {
         return this.m_maxItemCount;
      }
      
      override public function push(listItem:MovieClip) : uint
      {
         var result:uint = super.push(listItem);
         this.refreshHeight();
         return result;
      }
      
      public function refreshHeight() : void
      {
         var c:int = 0;
         if(this.length <= this.maxVisibleItemCount)
         {
            c = int(this.length);
            this.myScrollBar.setVisible(false);
            this.myScrollBar.setEnabled(false);
         }
         else
         {
            c = this.maxVisibleItemCount;
            this.myScrollBar.setVisible(true);
            this.myScrollBar.setEnabled(true);
         }
         this.menuHeight = this.customItemHeight * c;
      }
      
      override public function set visible(bVisible:Boolean) : void
      {
         super.visible = bVisible;
         if(this.stage != null)
         {
            if(bVisible)
            {
               this.myScrollBar.setMouseWheelListener(this.stage);
            }
            else
            {
               this.myScrollBar.setMouseWheelListener(null);
            }
         }
      }
   }
}

