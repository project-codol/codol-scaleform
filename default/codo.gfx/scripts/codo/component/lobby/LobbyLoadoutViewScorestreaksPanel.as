package codo.component.lobby
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.component.loadout.LoadoutButton;
   import codo.component.loadout.LoadoutViewScorestreaksPanel;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.objects.ResultObj;
   import codo.objects.RoomMemberObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.utils.ItemUtil;
   import codo.utils.ScaleformUtil;
   import flash.events.Event;
   
   public class LobbyLoadoutViewScorestreaksPanel extends LoadoutViewScorestreaksPanel
   {
      
      public function LobbyLoadoutViewScorestreaksPanel()
      {
         super();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         EventManager.getInstance().listen(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberChanged);
         DataManager.getInstance().bind(DataID.ROOM_INFO,this.onRoomInfoUpdated,null,false,true,false);
         var paraEvent:ParaEvent = new ParaEvent(Event.COMPLETE,DataManager.getInstance().getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ));
         this.onSelectedMemberChanged(paraEvent);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().unlisten(BCEvent.EVT_SELECTED_MEMBER_MAYBE_CHANGED,this.onSelectedMemberChanged);
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
         }
         else
         {
            repopulateList(myScrollGrid);
         }
      }
      
      private function onSelectedMemberChanged(cEvt:ParaEvent) : void
      {
         var loadoutButton:LoadoutButton = null;
         var label:TextField = null;
         var prodData:ProductObj = null;
         var idx:int = 0;
         var loadout:WeaponLoadoutObj = null;
         var items:Vector.<Object> = null;
         var j:int = 0;
         var sortedStreaks:Array = null;
         var i:int = 0;
         var item:ProductObj = null;
         var currentMember:RoomMemberObj = cEvt.myPara;
         if(currentMember == null || currentMember.isMe)
         {
            mBindWeaponLoadoutSlotsData.bind();
            idx = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
            loadout = CFunctionCommonContainer.AS_RequestWeaponLoadout(idx) as WeaponLoadoutObj;
            DataManager.getInstance().setData(ResultObj.getObj(DataID.WEAPONLOADOUT_SLOTSDATA,loadout));
            onInit();
         }
         else
         {
            mBindWeaponLoadoutSlotsData.unbind();
            _itemsData = [currentMember.weaponloadObj.killStreakSlot_0,currentMember.weaponloadObj.killStreakSlot_1,currentMember.weaponloadObj.killStreakSlot_2];
            items = new Vector.<Object>();
            for(j = 0; j < _itemsData.length; j++)
            {
               if(_itemsData[j].item_id != 0)
               {
                  item = CFunctionCommonContainer.GetItemInfo(_itemsData[j].item_id);
                  item.isMe = false;
                  items.push(item);
               }
            }
            myScrollGrid.addItemsByVector(items);
            sortedStreaks = ItemUtil.sortStreaks([currentMember.weaponloadObj.killStreakSlot_0,currentMember.weaponloadObj.killStreakSlot_1,currentMember.weaponloadObj.killStreakSlot_2]);
            for(i = 0; i < sortedStreaks.length; i++)
            {
               loadoutButton = this["myStreak" + i];
               loadoutButton.setData(sortedStreaks[i].slot);
               loadoutButton.myClearButton.visible = false;
               label = this["myStreakCost" + i];
               prodData = sortedStreaks[i].item;
               label.text = Boolean(prodData.killsReq) ? prodData.killsReq.toString() : "";
            }
         }
      }
   }
}

