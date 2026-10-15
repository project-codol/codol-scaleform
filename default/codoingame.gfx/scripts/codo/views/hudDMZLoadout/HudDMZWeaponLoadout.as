package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DMZLootItemSlotType;
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   
   public class HudDMZWeaponLoadout extends MovieClip
   {
      
      public var myWeaponSlot:HudDMZLoadoutPickedWeaponSlot;
      
      public var myAttachSlot1:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot2:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot3:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot4:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot5:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot6:HudDMZLoadoutEntitySlot;
      
      public var myAttachSlot7:HudDMZLoadoutEntitySlot;
      
      private var mFixedAttachSlots:Vector.<HudDMZLoadoutEntitySlot>;
      
      private var mReplaceableAttachSlots:Vector.<HudDMZLoadoutEntitySlot>;
      
      public function HudDMZWeaponLoadout()
      {
         var i:int = 0;
         super();
         this.mFixedAttachSlots = new <HudDMZLoadoutEntitySlot>[this.myAttachSlot1,this.myAttachSlot2,this.myAttachSlot3,this.myAttachSlot4];
         this.mReplaceableAttachSlots = new <HudDMZLoadoutEntitySlot>[this.myAttachSlot5,this.myAttachSlot6,this.myAttachSlot7];
         for(i = 0; i < this.mFixedAttachSlots.length; i++)
         {
            this.mFixedAttachSlots[i].type = DMZLootItemSlotType.NONE;
            this.mFixedAttachSlots[i].myBg.gotoAndStop(2);
            this.mFixedAttachSlots[i].myKeybind.visible = false;
            this.mFixedAttachSlots[i].myDropButton.visible = false;
            this.mFixedAttachSlots[i].myDropButton.scaleX = 1 / this.mFixedAttachSlots[i].myDropButton.scaleX;
            this.mFixedAttachSlots[i].myDropButton.scaleY = 1 / this.mFixedAttachSlots[i].myDropButton.scaleY;
            this.mFixedAttachSlots[i].myOutline.visible = false;
            this.mFixedAttachSlots[i].isDraggable = false;
         }
         for(i = 0; i < this.mReplaceableAttachSlots.length; i++)
         {
            this.mReplaceableAttachSlots[i].type = DMZLootItemSlotType.EQUIPPED_ATTACHMENT;
            this.mReplaceableAttachSlots[i].myBg.gotoAndStop(1);
            this.mReplaceableAttachSlots[i].myKeybind.visible = false;
            this.mReplaceableAttachSlots[i].myDropButton.visible = false;
            this.mReplaceableAttachSlots[i].myDropButton.scaleX = 1 / this.mReplaceableAttachSlots[i].scaleX;
            this.mReplaceableAttachSlots[i].myDropButton.scaleY = 1 / this.mReplaceableAttachSlots[i].scaleY;
         }
      }
      
      public function setWeapon(lootIndex:int) : void
      {
         this.myWeaponSlot.setWeapon(lootIndex);
         for(var i:int = 0; i < this.mReplaceableAttachSlots.length; i++)
         {
            this.mReplaceableAttachSlots[i].weaponLootIndex = lootIndex;
         }
      }
      
      public function reset() : void
      {
         var i:int = 0;
         this.setWeapon(0);
         for(i = 0; i < this.mFixedAttachSlots.length; i++)
         {
            this.setFixedAttachment(i,null);
         }
         for(i = 0; i < this.mReplaceableAttachSlots.length; i++)
         {
            this.setReplaceableAttachment(i,0);
         }
      }
      
      public function setFixedAttachment(slot:int, prod:ProductObj) : void
      {
         this.mFixedAttachSlots[slot].myDropButton.visible = false;
         if(prod == null)
         {
            this.mFixedAttachSlots[slot].myImage.setImage(null);
            this.mFixedAttachSlots[slot].lootIndex = 0;
            return;
         }
         this.mFixedAttachSlots[slot].myImage.setImage(prod.imageURL);
         this.mFixedAttachSlots[slot].lootIndex = 0;
      }
      
      public function setReplaceableAttachment(slot:int, lootIndex:int) : void
      {
         var itemName:String = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(lootIndex);
         if(itemName == null)
         {
            this.mReplaceableAttachSlots[slot].myImage.setImage(null);
            this.mReplaceableAttachSlots[slot].lootIndex = 0;
            this.mReplaceableAttachSlots[slot].myDropButton.visible = false;
            return;
         }
         var attachInfo:Object = CFunctionInGameContainer.AS_DMZ_GetAttachmentInfo(itemName);
         if(attachInfo == null)
         {
            this.mReplaceableAttachSlots[slot].myImage.setImage(null);
            this.mReplaceableAttachSlots[slot].lootIndex = 0;
            this.mReplaceableAttachSlots[slot].myDropButton.visible = false;
            return;
         }
         this.mReplaceableAttachSlots[slot].myImage.setImage(attachInfo.icon);
         this.mReplaceableAttachSlots[slot].lootIndex = lootIndex;
         this.mReplaceableAttachSlots[slot].myDropButton.visible = true;
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.mReplaceableAttachSlots[slot].myDropButton.visible = false;
         }
      }
   }
}

