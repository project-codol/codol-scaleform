package codo.utils
{
   public class CursorUtil
   {
      
      private static var _cursorFunc:Function;
      
      private static var _activeCursors:Vector.<int>;
      
      private static var _selectedCursor:int;
      
      public static const CURSOR_STANDARD:int = 0;
      
      public static const CURSOR_OVER_BUTTON:int = 1;
      
      public static const NUM_CURSORS:int = 2;
      
      public function CursorUtil()
      {
         super();
      }
      
      public static function InitCursorUtil(cursorFunc:Function) : void
      {
         _cursorFunc = cursorFunc;
         _activeCursors = new Vector.<int>(NUM_CURSORS);
         _selectedCursor = CURSOR_STANDARD;
      }
      
      public static function BeginCursor(cursorType:int) : void
      {
         if(_activeCursors == null)
         {
            return;
         }
         if(_activeCursors[cursorType] < 1)
         {
            ++_activeCursors[cursorType];
         }
         UpdateCursor();
      }
      
      public static function EndCursor(cursorType:int) : void
      {
         if(_activeCursors == null)
         {
            return;
         }
         if(_activeCursors[cursorType] > 0)
         {
            --_activeCursors[cursorType];
         }
         UpdateCursor();
      }
      
      private static function UpdateCursor() : void
      {
         var newCursor:int = CURSOR_STANDARD;
         for(var i:int = NUM_CURSORS - 1; i >= 0; i--)
         {
            if(_activeCursors[i] > 0)
            {
               newCursor = i;
               break;
            }
         }
         if(newCursor != _selectedCursor)
         {
            _cursorFunc(newCursor);
            _selectedCursor = newCursor;
         }
      }
   }
}

