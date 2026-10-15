package components.matchselect_part
{
   import codo.component.ScrollGrid;
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   
   public class MatchSelectRoomScrollGrid extends ScrollGrid
   {
      
      private static const LAST_POSITION_PIXEL:Number = 20;
      
      private var mScrollInLastPosition:Boolean = false;
      
      public function MatchSelectRoomScrollGrid()
      {
         super();
      }
      
      override protected function onScroll(position:Number) : void
      {
         super.onScroll(position);
         if(mHeight >= _contentLength)
         {
            return;
         }
         var lengthLeft:Number = _contentLength * (1 - position);
         if(lengthLeft < LAST_POSITION_PIXEL)
         {
            if(!this.mScrollInLastPosition)
            {
               EventManager.getInstance().broadcast(BCEvent.ROOM_LIST_VIEW_ALMOST_VIEWED_FINISH,_listData.length);
            }
            this.mScrollInLastPosition = true;
         }
         else
         {
            this.mScrollInLastPosition = false;
         }
      }
      
      override public function addItemsByVector(content:Vector.<Object>) : void
      {
         var currentViewingPosition:Number = myScrollBar.position * _contentLength;
         super.addItemsByVector(content);
         var newPosition:Number = currentViewingPosition / _contentLength;
         myScrollBar.setPosition(newPosition,false);
         this.onScroll(newPosition);
      }
   }
}

