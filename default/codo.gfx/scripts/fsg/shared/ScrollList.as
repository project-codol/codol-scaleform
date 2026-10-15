package fsg.shared
{
   import flash.display.MovieClip;
   
   public class ScrollList extends ScrollPane
   {
      
      protected var m_listItems:Vector.<MovieClip> = new Vector.<MovieClip>(0);
      
      private var m_customHeight:Number = -1;
      
      public function ScrollList()
      {
         super();
      }
      
      public function get length() : uint
      {
         return this.m_listItems.length;
      }
      
      public function set customItemHeight(customHeight:Number) : void
      {
         this.m_customHeight = customHeight;
      }
      
      public function get customItemHeight() : Number
      {
         return this.m_customHeight;
      }
      
      public function push(listItem:MovieClip) : uint
      {
         var oldLastItem:MovieClip = null;
         var itemHeight:Number = NaN;
         var newItemY:Number = 0;
         if(this.m_listItems.length > 0)
         {
            oldLastItem = this.m_listItems[this.m_listItems.length - 1];
            itemHeight = this.m_customHeight > 0 ? this.m_customHeight : oldLastItem.height;
            newItemY = oldLastItem.y + itemHeight;
         }
         listItem.y = newItemY;
         myScrollItem.addChild(listItem);
         var uNewLength:uint = this.m_listItems.push(listItem);
         m_scrollPaneBehaviour.refreshScrollBar();
         return uNewLength;
      }
      
      public function getItem(index:int) : MovieClip
      {
         if(this.m_listItems.length == 0)
         {
            return null;
         }
         return this.m_listItems[index];
      }
      
      public function clearList() : void
      {
         var uNumListItems:uint = this.m_listItems.length;
         for(var uIndex:int = 0; uIndex < uNumListItems; uIndex++)
         {
            myScrollItem.removeChild(this.m_listItems[uIndex]);
         }
         this.m_listItems = new Vector.<MovieClip>(0);
         m_scrollPaneBehaviour.refreshScrollBar();
      }
   }
}

