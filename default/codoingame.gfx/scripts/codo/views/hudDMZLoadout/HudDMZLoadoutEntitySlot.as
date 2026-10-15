package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.constants.BCInGameEvent;
   import codo.constants.DMZLootItemSlotType;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudDMZLoadoutEntitySlot extends MovieClip
   {
      
      public var myDropButton:CloseButton;
      
      public var myHitArea:MovieClip;
      
      public var myOutline:MovieClip;
      
      public var myKeybind:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myBg:MovieClip;
      
      private var mType:int;
      
      private var mLootIndex:int;
      
      private var mWeaponLootIndex:int;
      
      private var mIsDraggable:Boolean;
      
      public function HudDMZLoadoutEntitySlot()
      {
         super();
         this.myDropButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDropButtonClick);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onItemMouseDown);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_UP,this.onItemMouseUp);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
         this.mType = DMZLootItemSlotType.NONE;
         this.mLootIndex = 0;
         this.mWeaponLootIndex = 0;
         this.mIsDraggable = true;
      }
      
      public function set type(type:int) : void
      {
         this.mType = type;
      }
      
      public function get type() : int
      {
         return this.mType;
      }
      
      public function get weaponLootIndex() : int
      {
         return this.mWeaponLootIndex;
      }
      
      public function set weaponLootIndex(weaponLootIndex:int) : void
      {
         this.mWeaponLootIndex = weaponLootIndex;
      }
      
      public function set lootIndex(lootIndex:int) : void
      {
         this.mLootIndex = lootIndex;
      }
      
      public function get lootIndex() : int
      {
         return this.mLootIndex;
      }
      
      public function set isDraggable(draggable:Boolean) : void
      {
         this.mIsDraggable = draggable;
      }
      
      private function onDropButtonClick(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","4_" + this.mType + "_" + this.mLootIndex + "_" + this.mWeaponLootIndex + "_" + "undefined");
      }
      
      private function onItemMouseDown(cEvt:MouseEvent) : void
      {
         if(!this.mIsDraggable)
         {
            return;
         }
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,{
            "type":this.mType,
            "lootIndex":this.mLootIndex,
            "weaponLootIndex":this.mWeaponLootIndex,
            "ammoType":"undefined"
         });
      }
      
      private function onItemMouseUp(cEvt:MouseEvent) : void
      {
         var dragParam:Object = DataManager.getInstance().getDP(DataID.DMZ_DRAGGING_ITEM_PARAM);
         if(dragParam.lootIndex == 0)
         {
            return;
         }
         switch(this.mType)
         {
            case DMZLootItemSlotType.EQUIPPED_ATTACHMENT:
               this.onDropOnEquippedAttachmentSlot(dragParam);
               break;
            case DMZLootItemSlotType.INVENTORY_ATTACHMENT:
               this.onDropOnInventoryAttachmentSlot(dragParam);
         }
      }
      
      private function onItemMouseOver(cEvt:MouseEvent) : void
      {
         if(!this.mIsDraggable)
         {
            return;
         }
         if(this.mLootIndex == 0)
         {
            return;
         }
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onItemMouseOut(cEvt:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onDropOnEquippedAttachmentSlot(dragParam:Object) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,{
            "type":DMZLootItemSlotType.NONE,
            "lootIndex":0,
            "weaponLootIndex":0,
            "ammoType":""
         });
         if(this.mWeaponLootIndex == 0)
         {
            return;
         }
         if(dragParam.type == DMZLootItemSlotType.INVENTORY_ATTACHMENT)
         {
            CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","1_" + this.mWeaponLootIndex + "_" + dragParam.lootIndex + "_0_undefined");
         }
         else if(dragParam.type == DMZLootItemSlotType.EQUIPPED_ATTACHMENT)
         {
            if(dragParam.weaponLootIndex != this.mWeaponLootIndex)
            {
               CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","3_" + dragParam.weaponLootIndex + "_" + this.mWeaponLootIndex + "_" + dragParam.lootIndex + "_undefined");
            }
         }
      }
      
      private function onDropOnInventoryAttachmentSlot(dragParam:Object) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,{
            "type":DMZLootItemSlotType.NONE,
            "lootIndex":0,
            "weaponLootIndex":0,
            "ammoType":"undefined"
         });
         if(dragParam.type != DMZLootItemSlotType.EQUIPPED_ATTACHMENT)
         {
            return;
         }
         if(dragParam.weaponLootIndex == 0)
         {
            return;
         }
         CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","2_" + dragParam.weaponLootIndex + "_" + dragParam.lootIndex + "_0_undefined");
      }
   }
}

