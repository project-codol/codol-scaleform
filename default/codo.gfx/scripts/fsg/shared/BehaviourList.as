package fsg.shared
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class BehaviourList
   {
      
      protected static const INVALID_VALUE:int = -1;
      
      protected var m_itemContainer:DisplayObjectContainer;
      
      private var m_customizeHeight:Number;
      
      private var m_customizeWidth:Number;
      
      private var m_growVertical:Boolean;
      
      private var m_gap:Number;
      
      protected var m_nextPos:Number;
      
      public function BehaviourList(itemContainer:DisplayObjectContainer, growVertical:Boolean = true, gap:Number = 0, customizeItemHeight:Number = -1, customizeItemWidth:Number = -1)
      {
         super();
         this.m_itemContainer = itemContainer;
         this.m_growVertical = growVertical;
         this.m_gap = gap;
         this.m_customizeHeight = customizeItemHeight;
         this.m_customizeWidth = customizeItemWidth;
         this.m_nextPos = 0;
      }
      
      public function clear() : void
      {
         while(this.m_itemContainer.numChildren > 0)
         {
            this.m_itemContainer.removeChildAt(0);
         }
         this.m_nextPos = 0;
      }
      
      public function addItem(item:DisplayObject) : void
      {
         this.m_itemContainer.addChild(item);
         if(this.m_growVertical)
         {
            item.x = 0;
            item.y = this.m_nextPos;
            this.m_nextPos += this.m_customizeHeight == INVALID_VALUE ? item.height : this.m_customizeHeight;
         }
         else
         {
            item.x = this.m_nextPos;
            item.y = 0;
            this.m_nextPos += this.m_customizeWidth == INVALID_VALUE ? item.width : this.m_customizeWidth;
         }
         this.m_nextPos += this.m_gap;
      }
      
      public function indexOf(item:DisplayObject) : int
      {
         if(item.parent == this.m_itemContainer)
         {
            return this.m_itemContainer.getChildIndex(item);
         }
         return INVALID_VALUE;
      }
   }
}

