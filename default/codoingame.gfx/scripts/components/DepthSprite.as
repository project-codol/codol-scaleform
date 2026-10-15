package components
{
   import flash.display.Sprite;
   
   public class DepthSprite extends Sprite
   {
      
      private var _depth:Number;
      
      private var _needsSorting:Boolean = false;
      
      private var _isInGeneralContainer:Boolean = false;
      
      public function DepthSprite()
      {
         super();
      }
      
      public function get depth() : Number
      {
         return this._depth;
      }
      
      public function set depth(n:Number) : void
      {
         this._depth = n;
         var depthSpriteParent:DepthSprite = parent as DepthSprite;
         if(Boolean(depthSpriteParent))
         {
            depthSpriteParent._needsSorting = true;
            depthSpriteParent.sortDisplayList();
         }
      }
      
      protected function sortDisplayList() : void
      {
         var childDS_A:DepthSprite = null;
         var j:uint = 0;
         var childDS_B:DepthSprite = null;
         var len:uint = uint(numChildren);
         for(var i:uint = 0; i < len - 1; i++)
         {
            childDS_A = getChildAt(i) as DepthSprite;
            j = i + 1;
            while(j < len && Boolean(childDS_A))
            {
               childDS_B = getChildAt(j) as DepthSprite;
               if(childDS_A._depth > childDS_B._depth)
               {
                  swapChildrenAt(i,j);
               }
               j++;
            }
         }
      }
      
      public function get inGeneralContainer() : Boolean
      {
         return this._isInGeneralContainer;
      }
      
      public function set inGeneralContainer(bIn:Boolean) : void
      {
         this._isInGeneralContainer = bIn;
      }
   }
}

