package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DMZLootItemSlotType;
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudDMZInventory extends MovieClip
   {
      
      public var myAttachTitle:TextField;
      
      public var myAttachSlot1:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot2:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot3:HudDMZLoadoutEntitySlot;
      
      public var myHealthPackTitle:TextField;
      
      public var myHealthPackSlot:HudDMZLoadoutEntitySlot;
      
      public var myOffHandTitle:TextField;
      
      public var myLethalSlot:HudDMZLoadoutEntitySlot;
      
      public var myTacticalSlot:HudDMZLoadoutEntitySlot;
      
      private var mAttachSlots:Vector.<HudDMZLoadoutEntitySlot>;
      
      public function HudDMZInventory()
      {
         super();
         this.mAttachSlots = new <HudDMZLoadoutEntitySlot>[this.myAttachSlot1,this.myAttachSlot2,this.myAttachSlot3];
         this.myAttachTitle.text = DictDmz.LOADOUT_ATTACHMENT_TITLE;
         this.myHealthPackTitle.text = DictDmz.LOADOUT_HEALTH_PACK_TITLE;
         this.myAttachSlot1.type = DMZLootItemSlotType.INVENTORY_ATTACHMENT;
         this.myAttachSlot2.type = DMZLootItemSlotType.INVENTORY_ATTACHMENT;
         this.myAttachSlot3.type = DMZLootItemSlotType.INVENTORY_ATTACHMENT;
         this.myAttachSlot1.myKeybind.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 1");
         this.myAttachSlot2.myKeybind.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 4");
         this.myAttachSlot3.myKeybind.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 3");
         this.myAttachSlot1.myDropButton.visible = false;
         this.myAttachSlot2.myDropButton.visible = false;
         this.myAttachSlot3.myDropButton.visible = false;
         this.myHealthPackSlot.type = DMZLootItemSlotType.HEALTH_PACK;
         this.myHealthPackSlot.myKeybind.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 2");
         this.myHealthPackSlot.myDropButton.visible = false;
         this.myOffHandTitle.text = DictDmz.LOADOUT_OFFHAND_TITLE;
         this.myLethalSlot.type = DMZLootItemSlotType.LETHAL;
         this.myLethalSlot.myKeybind.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+frag");
         this.myLethalSlot.myDropButton.visible = false;
         this.myTacticalSlot.type = DMZLootItemSlotType.TACTICAL;
         this.myTacticalSlot.myKeybind.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+tact");
         this.myTacticalSlot.myDropButton.visible = false;
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < this.mAttachSlots.length; i++)
         {
            this.setAttachment(i,0);
         }
      }
      
      public function setAttachment(slot:int, lootIndex:int) : void
      {
         var item:String = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(lootIndex);
         if(item == null || item == "")
         {
            this.mAttachSlots[slot].myImage.setImage(null);
            this.mAttachSlots[slot].lootIndex = 0;
            this.mAttachSlots[slot].myDropButton.visible = false;
            return;
         }
         var attachInfo:Object = CFunctionInGameContainer.AS_DMZ_GetAttachmentInfo(item);
         if(attachInfo == null)
         {
            this.mAttachSlots[slot].myImage.setImage(null);
            this.mAttachSlots[slot].lootIndex = 0;
            this.mAttachSlots[slot].myDropButton.visible = false;
            return;
         }
         this.mAttachSlots[slot].myImage.setImage(attachInfo.icon);
         this.mAttachSlots[slot].lootIndex = lootIndex;
         this.mAttachSlots[slot].myDropButton.visible = true;
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.mAttachSlots[slot].myDropButton.visible = false;
         }
      }
   }
}

