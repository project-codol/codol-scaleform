package codo.component.marketplaceitem.parts
{
   import codo.component.marketplaceitem.MarketplaceItemEquipEmoteIcon;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class MarketplaceItemCardCallToAction extends MovieClip
   {
      
      public var myBkg:Sprite;
      
      public var myIcon:MovieClip;
      
      public var myEquipEmoteIcon:MarketplaceItemEquipEmoteIcon;
      
      public var myLabelTF:TextField;
      
      protected var _isFocused:Boolean;
      
      protected var _enabled:Boolean;
      
      public function MarketplaceItemCardCallToAction()
      {
         super();
         this.myBkg.width = this.myBkg.height = 0;
         this.myLabelTF.text = LocalizeUtil.localize(Dict.EQUIP_ITEM);
      }
      
      public function setItemData(item:ProductObj) : void
      {
         var iconFrame:int = 0;
         var text:String = null;
         this.myIcon.visible = true;
         this.myLabelTF.visible = true;
         this.myEquipEmoteIcon.visible = false;
         this.myEquipEmoteIcon.setData(item);
         var action:uint = item.getPrimaryAction();
         this._enabled = false;
         if(action != ProductObj.ACTION_NONE)
         {
            this._enabled = true;
            if(action == ProductObj.ACTION_BUY)
            {
               iconFrame = 3;
               text = item.isOwnedRental() ? DictMarket.EXTEND : DictMarket.BUY;
            }
            else if(action == ProductObj.ACTION_UNEQUIP)
            {
               iconFrame = 1;
               text = Dict.UNEQUIP_ITEM;
            }
            else if(action == ProductObj.ACTION_EQUIP)
            {
               iconFrame = 1;
               text = Dict.EQUIP_ITEM;
               if(item.group == MarketMenuData.GRP_EMOTE)
               {
                  this.myIcon.visible = this.myLabelTF.visible = false;
                  this.myEquipEmoteIcon.visible = true;
               }
            }
            else if(action == ProductObj.ACTION_CONSUME)
            {
               iconFrame = 1;
               text = Dict.USE;
            }
            else if(action == ProductObj.ACTION_DETAILS)
            {
               iconFrame = 2;
               text = Dict.SHOW_ITEM_DETAIL_INFO;
            }
            else if(action == ProductObj.ACTION_DEPENDENCY)
            {
               iconFrame = 4;
               text = Dict.VIEW_DEPENDENCY;
            }
            this.myIcon.gotoAndStop(iconFrame);
            this.myLabelTF.text = text;
         }
         this.updateHighlight();
      }
      
      override public function set width(value:Number) : void
      {
         this.myBkg.width = value;
         this.myIcon.x = (value - this.myIcon.width) * 0.5;
         this.myLabelTF.x = this.myBkg.x;
         this.myLabelTF.width = value;
         this.myEquipEmoteIcon.x = (value - this.myEquipEmoteIcon.width) * 0.5;
      }
      
      override public function set height(value:Number) : void
      {
         this.myBkg.height = value;
         this.myIcon.y = (value - this.myIcon.height) * 0.5;
         this.myLabelTF.y = this.myIcon.y + this.myIcon.height + 5;
         this.myEquipEmoteIcon.y = (value - this.myEquipEmoteIcon.height) * 0.5;
      }
      
      public function setFocused(focused:Boolean) : void
      {
         this._isFocused = focused;
         this.updateHighlight();
      }
      
      protected function updateHighlight() : void
      {
         visible = this._isFocused && this._enabled;
      }
      
      public function mouseMove() : void
      {
         if(this._isFocused && this.myEquipEmoteIcon.visible)
         {
            this.myEquipEmoteIcon.mouseMove();
         }
      }
      
      public function getSelectedEmoteSlotIndex() : int
      {
         if(this._isFocused && this.myEquipEmoteIcon.visible)
         {
            return this.myEquipEmoteIcon.getCurrentSelectedIndex();
         }
         return -1;
      }
   }
}

