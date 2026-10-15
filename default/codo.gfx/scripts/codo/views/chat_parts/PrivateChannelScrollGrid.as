package codo.views.chat_parts
{
   import codo.component.ScrollGrid;
   import codo.component.core.UIInteractiveComponent;
   
   public class PrivateChannelScrollGrid extends ScrollGrid
   {
      
      private var mCloseCallback:Function;
      
      public function PrivateChannelScrollGrid()
      {
         super();
      }
      
      override protected function makeRenderer(itemLinkage:String) : UIInteractiveComponent
      {
         var preMakeLen:int = int(mItems.length);
         var item:UIInteractiveComponent = super.makeRenderer(itemLinkage);
         var reality:ChannelSelectorButton = item as ChannelSelectorButton;
         if(reality != null)
         {
            reality.setCloseCallback(this.onItemCloseClick,preMakeLen);
         }
         return item;
      }
      
      private function onItemCloseClick(index:uint) : void
      {
         if(null != this.mCloseCallback)
         {
            this.mCloseCallback(_itemDataIndices[index]);
         }
      }
      
      public function set closeCallback(callback:Function) : void
      {
         this.mCloseCallback = callback;
      }
      
      public function forceRefreshData() : void
      {
         var item:UIInteractiveComponent = null;
         var numItems:int = int(mItems.length);
         for(var i:int = 0; i < numItems; i++)
         {
            item = mItems[i];
            item.setData(item.getData());
         }
      }
   }
}

