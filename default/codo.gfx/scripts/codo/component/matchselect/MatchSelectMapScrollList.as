package codo.component.matchselect
{
   import codo.component.ScrollList;
   import codo.component.scrollgrid.parts.ScrollListNavArrow;
   
   public class MatchSelectMapScrollList extends ScrollList
   {
      
      private static const ITEM_WIDTH:Number = 161;
      
      private static const LIST_WIDTH:Number = 454;
      
      public function MatchSelectMapScrollList()
      {
         super();
      }
      
      override protected function onNavArrowClick(arrow:ScrollListNavArrow) : void
      {
         if(!arrow.enabled)
         {
            return;
         }
         this.doNavButtonScroll(arrow == myNavArrowRight);
      }
      
      private function doNavButtonScroll(forward:Boolean) : void
      {
         var fullWidth:Number = _listData.length * ITEM_WIDTH + (_listData.length - 1) * mSettings.itemPadding - LIST_WIDTH;
         var singleWidth:Number = ITEM_WIDTH + mSettings.itemPadding;
         var delta:Number = singleWidth / fullWidth;
         var newPos:Number = myScrollBar.position + (forward ? delta : -delta);
         newPos = Math.max(0,Math.min(newPos,1));
         myScrollBar.setPosition(newPos,true);
      }
   }
}

