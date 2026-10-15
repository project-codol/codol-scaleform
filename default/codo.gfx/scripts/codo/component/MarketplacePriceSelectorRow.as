package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.MarketplaceDiscountItemPromoTag;
   import codo.localization.Dict;
   import codo.objects.SKUObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import fsg.shared.BehaviourSelectable;
   
   public class MarketplacePriceSelectorRow extends UIInteractiveComponent
   {
      
      private static const GP_FRAME:int = 1;
      
      private static const CP_FRAME:int = 2;
      
      private static const HP_FRAME:int = 3;
      
      private static const EHP_FRAME:int = 4;
      
      public var myCheckBox:MovieClip;
      
      public var myCost:TextField;
      
      public var myDuration:TextField;
      
      public var myIcon:MovieClip;
      
      public var myDiscountTag:MarketplaceDiscountItemPromoTag;
      
      private var mChecked:Boolean = false;
      
      private var mSelectable:BehaviourSelectable;
      
      private var mIndex:int = 0;
      
      public function MarketplacePriceSelectorRow()
      {
         super();
         isInteractiveEnabled = true;
         this.myDiscountTag.visible = false;
         if(this.myDuration != null)
         {
            this.myDuration.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
            this.myDuration.alignment = TextStyle.HALIGN_RIGHT;
         }
         this.myCost.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         mClickable.stopClickEventPropogation = true;
         this.mSelectable = new BehaviourSelectable(mClickable,false);
      }
      
      override public function setData(data:*) : void
      {
         var duration:String = null;
         mData = data as SKUObj;
         if(mData.currency == Dict.CP)
         {
            this.myIcon.gotoAndStop(CP_FRAME);
         }
         else if(mData.currency == Dict.GP)
         {
            this.myIcon.gotoAndStop(GP_FRAME);
         }
         else if(mData.currency == Dict.HP)
         {
            this.myIcon.gotoAndStop(HP_FRAME);
         }
         else
         {
            this.myIcon.gotoAndStop(EHP_FRAME);
         }
         if(this.myDuration != null)
         {
            if(mData.duration == 0)
            {
               duration = LocalizeUtil.localize(Dict.FOREVER);
            }
            else
            {
               duration = mData.duration;
               if(Boolean(mData.stackable))
               {
                  duration += LocalizeUtil.localize("@SF_UI_STACKABLE_UNIT");
               }
               else
               {
                  duration += " " + LocalizeUtil.localize(Dict.DAY);
               }
            }
            this.myDuration.text = duration;
         }
         this.myCost.text = mData.price.toString();
         if(ItemUtil.ignoreFutureSku)
         {
            this.myCost.text += " SKU:" + mData.id;
            this.myCost.fontColor = this.getColor(GlobalGuide.CODO_BLUE_HIGHLIGHT);
         }
         var discountTxt:String = ItemUtil.getSkuSaleValue(mData);
         if(Boolean(mData.ignoreDiscount))
         {
            discountTxt = null;
            if(mData.originalPrice > 0)
            {
               this.myCost.text = mData.originalPrice.toString();
            }
         }
         if(discountTxt != null)
         {
            this.myDiscountTag.visible = true;
            this.myDiscountTag.discount = discountTxt;
         }
         else
         {
            this.myDiscountTag.visible = false;
         }
      }
      
      public function set checked(c:Boolean) : void
      {
         this.mChecked = c;
         this.myCheckBox.gotoAndStop(c ? 2 : 1);
         this.mSelectable.state = this.mChecked ? BehaviourSelectable.STATE_SELECTED : BehaviourSelectable.STATE_UNSELECTED;
         if(true == this.mChecked)
         {
            this.myCost.fontColor = this.getColor(GlobalGuide.WHITE);
            if(this.myDuration != null)
            {
               this.myDuration.fontColor = GlobalGuide.WHITE;
            }
         }
         else
         {
            this.myCost.fontColor = this.getColor(GlobalGuide.CODO_BLUE_HIGHLIGHT);
            if(this.myDuration != null)
            {
               this.myDuration.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            }
         }
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         alpha = enabled ? 1 : 0.5;
      }
      
      public function set index(i:int) : void
      {
         this.mIndex = i;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      public function addCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.addSelectedCallback(fnCallback,userData);
      }
      
      public function removeCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.removeSelectedCallback(fnCallback,userData);
      }
      
      override protected function onMouseOver() : void
      {
         if(false == this.mChecked)
         {
            super.onMouseOver();
            this.myCost.fontColor = this.getColor(GlobalGuide.WHITE);
            if(this.myDuration != null)
            {
               this.myDuration.fontColor = GlobalGuide.WHITE;
            }
         }
      }
      
      override protected function onMouseOut() : void
      {
         if(false == this.mChecked)
         {
            super.onMouseOut();
            this.myCost.fontColor = this.getColor(GlobalGuide.CODO_BLUE_HIGHLIGHT);
            if(this.myDuration != null)
            {
               this.myDuration.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            }
         }
      }
      
      private function getColor(c:uint) : uint
      {
         return ItemUtil.ignoreFutureSku && Boolean(mData.isInFuture) ? GlobalGuide.CODO_RED : c;
      }
   }
}

