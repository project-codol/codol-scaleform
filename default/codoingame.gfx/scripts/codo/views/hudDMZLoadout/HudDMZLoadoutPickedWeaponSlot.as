package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.CloseButton;
   import codo.constants.BCInGameEvent;
   import codo.constants.DMZLootItemSlotType;
   import codo.localization.DictDmz;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.TextUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudDMZLoadoutPickedWeaponSlot extends MovieClip
   {
      
      public var myDropButton:CloseButton;
      
      public var myTierColorAccent:MovieClip;
      
      public var myCategory:TextField;
      
      public var myName:TextField;
      
      public var myTierColorBarCap:MovieClip;
      
      public var myTierColorBar:MovieClip;
      
      public var myCategoryBG:MovieClip;
      
      public var myImage:FsgImageHolder;
      
      public var myActiveTag:MovieClip;
      
      private var mLootIndex:int;
      
      public function HudDMZLoadoutPickedWeaponSlot()
      {
         super();
         var activeTagText:TextField = this.myActiveTag.getChildByName("myText") as TextField;
         activeTagText.text = DictDmz.LOADOUT_ACTIVE_WEAPON;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle);
         this.myDropButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDropButtonClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
         this.setWeapon(0);
      }
      
      public function setWeapon(lootIndex:int) : void
      {
         this.mLootIndex = lootIndex;
         var itemName:String = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(lootIndex);
         var tier:int = CFunctionInGameContainer.AS_DMZ_GetTierByLootIndex(lootIndex);
         if(itemName == null || itemName == "")
         {
            this.myName.text = "";
            this.myImage.setImage(null);
            this.myCategory.text = "";
            this.myCategoryBG.visible = false;
            this.myTierColorAccent.gotoAndStop(1);
            this.myTierColorBarCap.visible = false;
            this.myTierColorBar.width = 0;
            this.myDropButton.visible = false;
            return;
         }
         var itemID:int = CFunctionCommonContainer.GetItemIDByName(itemName);
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(itemID);
         if(prod == null)
         {
            this.myName.text = "";
            this.myImage.setImage(null);
            this.myCategory.text = "";
            this.myCategoryBG.visible = false;
            this.myTierColorAccent.gotoAndStop(1);
            this.myTierColorBarCap.visible = false;
            this.myTierColorBar.width = 0;
            this.myDropButton.visible = false;
            return;
         }
         this.myName.text = LocalizeUtil.localize(prod.name);
         TextUtil.resizeTextToFitWidth(this.myName);
         this.myImage.setImage(prod.imageURL);
         this.myCategoryBG.visible = this.myCategory.visible = prod.group.length > 0;
         if(true == this.myCategory.visible)
         {
            this.myCategory.text = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(prod.group));
            this.myCategoryBG.width = this.myCategory.x + this.myCategory.textWidth + GlobalGuide.COMPONENT_PADDING;
         }
         this.myTierColorAccent.gotoAndStop(tier + 1);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[tier],new <DisplayObject>[this.myTierColorBar]);
         this.myTierColorBar.width = this.myName.x + this.myName.textWidth + this.myTierColorBarCap.width + 5;
         this.myTierColorBarCap.x = this.myTierColorBar.x + this.myTierColorBar.width - this.myTierColorBarCap.width;
         this.myTierColorBarCap.visible = true;
         this.myDropButton.visible = true;
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myDropButton.visible = false;
         }
      }
      
      public function getWeapon() : int
      {
         return this.mLootIndex;
      }
      
      private function onMouseDownHandle(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,{
            "type":DMZLootItemSlotType.WEAPON,
            "lootIndex":this.mLootIndex,
            "weaponLootIndex":this.mLootIndex,
            "ammoType":"undefined"
         });
      }
      
      private function onItemMouseOver(cEvt:MouseEvent) : void
      {
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
      
      private function onDropButtonClick(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","4_" + DMZLootItemSlotType.WEAPON + "_" + this.mLootIndex + "_" + this.mLootIndex + "_" + "undefined");
      }
   }
}

