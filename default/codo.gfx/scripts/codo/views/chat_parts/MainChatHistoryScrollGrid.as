package codo.views.chat_parts
{
   import codo.component.ScrollGrid;
   
   public class MainChatHistoryScrollGrid extends ScrollGrid
   {
      
      public function MainChatHistoryScrollGrid()
      {
         super();
      }
      
      public function gotoSpecificPosition(position:Number) : void
      {
         if(myScrollBar.visible)
         {
            onScroll(position);
            myScrollBar.setPosition(position,false);
         }
      }
      
      public function getCurrentPosition() : Number
      {
         if(myScrollBar.visible)
         {
            return myScrollBar.position;
         }
         return 1;
      }
   }
}

