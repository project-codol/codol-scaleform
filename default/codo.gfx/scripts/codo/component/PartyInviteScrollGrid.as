package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.views.party_parts.FriendItemForParty;
   
   public class PartyInviteScrollGrid extends ScrollGrid
   {
      
      private var mIsEnableCheckBox:Boolean = true;
      
      public function PartyInviteScrollGrid()
      {
         super();
      }
      
      public function enableCheckBox(isEnable:Boolean) : void
      {
         var item:FriendItemForParty = null;
         this.mIsEnableCheckBox = isEnable;
         var len:int = int(mItems.length);
         for(var i:int = 0; i < len; i++)
         {
            item = mItems[i] as FriendItemForParty;
            if(Boolean(item))
            {
               item.enableCheckBox(isEnable);
            }
         }
      }
      
      public function cleanAllCheckBox() : void
      {
         var item:FriendItemForParty = null;
         var len:int = int(mItems.length);
         for(var i:int = 0; i < len; i++)
         {
            item = mItems[i] as FriendItemForParty;
            if(Boolean(item))
            {
               item.selectCheckBox(false);
            }
         }
      }
      
      override protected function setItemData(index:uint, data:Object) : UIInteractiveComponent
      {
         var item:FriendItemForParty = super.setItemData(index,data) as FriendItemForParty;
         item.enableCheckBox(this.mIsEnableCheckBox);
         return item;
      }
   }
}

