package codo.component.lobby
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutViewBadgesBase;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.utils.ScaleformUtil;
   
   public class LobbyLoadoutViewBadgesBase extends LoadoutViewBadgesBase
   {
      
      protected var renewBadges:Boolean = false;
      
      protected var mBadgeData:Vector.<Object>;
      
      protected var mConsumableData:Vector.<Object>;
      
      protected var mConsumableCount:int = 0;
      
      public function LobbyLoadoutViewBadgesBase()
      {
         super();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DataManager.getInstance().bind(DataID.ROOM_INFO,this.onRoomInfoUpdated,null,false,true,false);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().unbind(DataID.ROOM_INFO,this.onRoomInfoUpdated);
      }
      
      private function onRoomInfoUpdated() : void
      {
         repopulateList(myScrollGrid);
      }
      
      override public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         if(ScaleformUtil.isMe)
         {
            super.uiCppSetItems(list1,list2,ownedFirst);
            if(this.renewBadges)
            {
               this.renewBadges = false;
               EventManager.getInstance().broadcast(BCEvent.EVT_BADGE_REFRESH,CFunctionCommonContainer.GetPlayerBadgeInfo());
            }
         }
         else
         {
            repopulateList(myScrollGrid);
         }
      }
      
      protected function setDataForBadges(data:Vector.<Object>) : void
      {
         var productData:ProductObj = null;
         this.mBadgeData = data;
         myScrollGrid.addItemsByVector(data);
         for(var i:int = 0; i < 3; i++)
         {
            productData = i < data.length ? data[i] as ProductObj : new ProductObj();
            if(productData.id > 0)
            {
               (this["myBadgeSlot" + i] as LoadoutButton).setData(productData);
            }
            else
            {
               productData.isEmpty = true;
               productData.isEnable = true;
               productData.isLocked = !(CFunctionCommonContainer.WL_GetIsBadgeSlotUnlocked(i) as Boolean);
               productData.type = MarketMenuData.TYPE_CALLSIGN_BADGE;
               (this["myBadgeSlot" + i] as LoadoutButton).setData(productData);
            }
         }
      }
      
      protected function setDataForConsumable(data:Vector.<Object>) : void
      {
         var productData:ProductObj = null;
         this.mConsumableData = data;
         myScrollGrid.addItemsByVector(data);
         if(data.length > 0)
         {
            productData = data[0] as ProductObj;
            if(productData.stackable)
            {
               myConsumableSlot.setData(productData);
               myConsumableCount.text = "x" + this.mConsumableCount;
               if(myConsumableSlot.visible)
               {
                  myConsumableCount.visible = true;
               }
            }
            else
            {
               productData = new ProductObj();
               productData.isEmpty = true;
               productData.isEnable = true;
               myConsumableSlot.setData(productData);
               myConsumableCount.visible = false;
            }
         }
         else
         {
            productData = new ProductObj();
            productData.isEmpty = true;
            productData.isEnable = true;
            myConsumableSlot.setData(productData);
            myConsumableCount.visible = false;
         }
      }
      
      override protected function refreshBadge(cEvt:ParaEvent) : void
      {
         if(ScaleformUtil.isMe)
         {
            super.refreshBadge(cEvt);
         }
      }
   }
}

