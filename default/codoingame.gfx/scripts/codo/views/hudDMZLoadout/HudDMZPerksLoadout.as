package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DMZLootItemSlotType;
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudDMZPerksLoadout extends MovieClip
   {
      
      public var myTitle:TextField;
      
      public var myPerk1:HudDMZLoadoutEntitySlot;
      
      public var myPerk2:HudDMZLoadoutEntitySlot;
      
      public var myPerk3:HudDMZLoadoutEntitySlot;
      
      public var myPerk4:HudDMZLoadoutEntitySlot;
      
      public var myPerk5:HudDMZLoadoutEntitySlot;
      
      public var myPerk6:HudDMZLoadoutEntitySlot;
      
      public var myPerk7:HudDMZLoadoutEntitySlot;
      
      public var myPerk8:HudDMZLoadoutEntitySlot;
      
      public var myPerk9:HudDMZLoadoutEntitySlot;
      
      public var myPerk10:HudDMZLoadoutEntitySlot;
      
      public var myPerk11:HudDMZLoadoutEntitySlot;
      
      public var myPerk12:HudDMZLoadoutEntitySlot;
      
      private var mPerks:Vector.<HudDMZLoadoutEntitySlot>;
      
      public function HudDMZPerksLoadout()
      {
         var i:int = 0;
         super();
         this.mPerks = new <HudDMZLoadoutEntitySlot>[this.myPerk1,this.myPerk2,this.myPerk3,this.myPerk4,this.myPerk5,this.myPerk6,this.myPerk7,this.myPerk8,this.myPerk9,this.myPerk10,this.myPerk11,this.myPerk12];
         for(i = 0; i < this.mPerks.length; i++)
         {
            this.mPerks[i].myKeybind.visible = false;
            this.mPerks[i].type = DMZLootItemSlotType.PERK;
            this.mPerks[i].myBg.gotoAndStop(1);
            this.mPerks[i].myDropButton.visible = false;
         }
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < this.mPerks.length; i++)
         {
            this.setPerk(i,0);
         }
      }
      
      public function setPerk(slot:int, lootIndex:int) : void
      {
         var perk:String = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(lootIndex);
         if(perk == null || perk == "")
         {
            this.mPerks[slot].myImage.setImage(null);
            this.mPerks[slot].myDropButton.visible = false;
            this.mPerks[slot].lootIndex = 0;
            return;
         }
         var itemId:int = CFunctionCommonContainer.GetItemIDByName(perk);
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(itemId);
         if(prod != null)
         {
            this.mPerks[slot].myImage.setImage(prod.imageURL);
            this.mPerks[slot].myDropButton.visible = true;
         }
         else
         {
            this.mPerks[slot].myImage.setImage(null);
            this.mPerks[slot].myDropButton.visible = false;
         }
         this.mPerks[slot].lootIndex = lootIndex;
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.mPerks[slot].myDropButton.visible = false;
         }
      }
   }
}

