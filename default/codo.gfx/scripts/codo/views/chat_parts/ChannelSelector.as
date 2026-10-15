package codo.views.chat_parts
{
   import codo.objects.ScrollListSettings;
   import flash.display.MovieClip;
   
   public class ChannelSelector extends MovieClip
   {
      
      private static const ITEM_LINKAGE:String = "codo.chat.channelselectorbutton";
      
      public var myPrivateChannelList:PrivateChannelScrollGrid;
      
      private var mSelectedUserId:String = "";
      
      private var mData:Vector.<Object>;
      
      private var mSelectionChangeCallback:Function;
      
      private var mChannelCloseCallback:Function;
      
      public function ChannelSelector()
      {
         var scrollListSetting:ScrollListSettings = null;
         super();
         scrollListSetting = new ScrollListSettings();
         scrollListSetting.useNavArrows = false;
         scrollListSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         scrollListSetting.itemLinkage = ITEM_LINKAGE;
         scrollListSetting.itemPadding = 3;
         this.myPrivateChannelList.initGrid(scrollListSetting,8,false,1);
         this.myPrivateChannelList.addItemsByVector(new Vector.<Object>());
         this.myPrivateChannelList.selectionChangeCallback = this.onChannelChangedHandler;
         this.myPrivateChannelList.closeCallback = this.onChannelClosedHandler;
      }
      
      public function setData(data:Vector.<Object>) : void
      {
         this.mData = data;
         this.myPrivateChannelList.addItemsByVector(data);
         var exist:Boolean = false;
         for(var i:int = 0; i < data.length; i++)
         {
            if(data[i].rawChannel.targetID == this.mSelectedUserId)
            {
               this.selectChannelByIndex(i);
               exist = true;
               break;
            }
         }
         if(!exist)
         {
            this.selectChannelByIndex(0);
         }
      }
      
      public function selectUserById(id:String) : void
      {
         if(this.mData == null)
         {
            return;
         }
         for(var i:int = 0; i < this.mData.length; i++)
         {
            if(this.mData[i].rawChannel.targetID == id)
            {
               this.selectChannelByIndex(i);
               break;
            }
         }
      }
      
      public function registerSelectionChangeCallback(callback:Function) : void
      {
         this.mSelectionChangeCallback = callback;
      }
      
      public function registerChannelCloseCallback(callback:Function) : void
      {
         this.mChannelCloseCallback = callback;
      }
      
      public function cleanRedDot() : void
      {
         this.myPrivateChannelList.forceRefreshData();
      }
      
      private function selectChannelByIndex(index:int) : void
      {
         if(index < this.mData.length)
         {
            this.mSelectedUserId = this.mData[index].rawChannel.targetID;
            this.myPrivateChannelList.selectedIndex = index;
         }
      }
      
      private function onChannelChangedHandler() : void
      {
         var selectedIndex:int = int(this.myPrivateChannelList.selectedIndex);
         this.mSelectedUserId = this.mData[selectedIndex].rawChannel.targetID;
         if(null != this.mSelectionChangeCallback)
         {
            this.mSelectionChangeCallback(selectedIndex);
         }
      }
      
      private function onChannelClosedHandler(index:int) : void
      {
         if(this.mChannelCloseCallback != null)
         {
            this.mChannelCloseCallback(this.mData[index].rawChannel);
         }
      }
   }
}

