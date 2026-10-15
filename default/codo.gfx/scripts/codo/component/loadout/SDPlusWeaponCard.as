package codo.component.loadout
{
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.core.ItemCardBase;
   import codo.constants.MarketMenuData;
   import codo.constants.SE_ID;
   import codo.localization.DictMarket;
   import codo.objects.SDPItemObj;
   import codo.style.GlobalGuide;
   import codo.utils.GraphicUtil;
   import codo.utils.SDPlusPvpUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.util.FsgUtil;
   
   public class SDPlusWeaponCard extends ItemCardBase
   {
      
      private static const CARD_WIDTH:Number = 221;
      
      private static const CARD_HEIGHT:Number = 187;
      
      public var myPurchaseButton:Button;
      
      public var mySellButton:Button;
      
      public var myTierColorBar:Sprite;
      
      public var myDisabledOverlay:Sprite;
      
      public var myPurchaseOverlay:Sprite;
      
      public var myFavoriteIndicator:Sprite;
      
      public var myAttachment0:SDPlusAttachSlot;
      
      public var myAttachment1:SDPlusAttachSlot;
      
      public var myAttachment2:SDPlusAttachSlot;
      
      public var myAttachment3:SDPlusAttachSlot;
      
      public var myAttachment4:SDPlusAttachSlot;
      
      public var myItemCostTF:TextField;
      
      private var mCanPurchase:Boolean;
      
      public function SDPlusWeaponCard()
      {
         super();
         isInteractiveEnabled = true;
         audioRef.overrideClickAudio(SE_ID.MUTE);
         mouseEnabled = mouseChildren = true;
         this.myPurchaseButton.width = CARD_WIDTH / 2;
         this.myPurchaseButton.height = 31;
         this.mySellButton.label = DictMarket.SELL_ITEM;
         this.mySellButton.width = this.mySellButton.x = CARD_WIDTH / 2;
         this.mySellButton.height = 31;
         this.mySellButton.upStateFrame = CallToActionButton.GREEN_UP_FRAME;
         this.mySellButton.registerClickEvent(this.onSell);
         this.myPurchaseOverlay.width = this.myDisabledOverlay.width = myHitArea.width = CARD_WIDTH;
         this.myPurchaseOverlay.height = this.myDisabledOverlay.height = myHitArea.height = CARD_HEIGHT;
         this.myFavoriteIndicator.visible = false;
      }
      
      override public function setData(data:*) : void
      {
         var itemData:SDPItemObj = null;
         var isFree:Boolean = false;
         var numAttach:uint = 0;
         mData = data;
         if(data == null)
         {
            visible = false;
            return;
         }
         itemData = data as SDPItemObj;
         isFree = itemData.cost == 0;
         myItemNameTF.text = itemData.nameLoc;
         myItemImageHolder.setImage(itemData.icon);
         if(!isFree)
         {
            this.myItemCostTF.text = "$" + FsgUtil.commaFormatNumber(itemData.cost);
            this.myPurchaseButton.label = DictMarket.BUY_AND_USE;
         }
         else
         {
            this.myItemCostTF.text = DictMarket.FREE;
            this.myPurchaseButton.label = DictMarket.USE;
         }
         this.myTierColorBar.width = myItemNameTF.textWidth + 20;
         myItemCategoryTF.visible = myAltText.visible = myItemIconHolder.visible = myAltTextShadow.visible = myAnimatedBackgroundMount.visible = myAnimatedEmblemMount.visible = false;
         if(itemData.group == MarketMenuData.TYPE_WEAPON)
         {
            numAttach = itemData.attachments.length;
            this.myAttachment0.setData(numAttach > 0 ? itemData.attachments[0] : {});
            this.myAttachment1.setData(numAttach > 1 ? itemData.attachments[1] : {});
            this.myAttachment2.setData(numAttach > 2 ? itemData.attachments[2] : {});
            this.myAttachment3.setData(numAttach > 3 ? itemData.attachments[3] : {});
            this.myAttachment4.setData(numAttach > 4 ? itemData.attachments[4] : {});
            this.myAttachment0.visible = this.myAttachment1.visible = this.myAttachment2.visible = this.myAttachment3.visible = this.myAttachment4.visible = true;
         }
         else
         {
            this.myAttachment0.visible = this.myAttachment1.visible = this.myAttachment2.visible = this.myAttachment3.visible = this.myAttachment4.visible = false;
         }
         this.myFavoriteIndicator.visible = itemData.favorite;
         this.mCanPurchase = itemData.numEquipped < itemData.limit && itemData.canAfford && !itemData.disabled;
         this.mySellButton.enabled = itemData.numEquipped > 0 && !isFree && !itemData.disabled;
         this.formatButtons(this.mCanPurchase,this.mySellButton.enabled);
         this.myPurchaseButton.forceEndHighlight();
         this.mySellButton.forceEndHighlight();
         this.myDisabledOverlay.visible = itemData.disabled;
         this.myItemCostTF.textColor = itemData.numEquipped < itemData.limit && !itemData.canAfford ? 15804205 : GlobalGuide.WHITE;
         this.myPurchaseOverlay.visible = false;
      }
      
      override public function get width() : Number
      {
         return CARD_WIDTH;
      }
      
      override public function get height() : Number
      {
         return CARD_HEIGHT;
      }
      
      private function formatButtons(canBuy:Boolean, canSell:Boolean) : void
      {
         if(canBuy)
         {
            this.myPurchaseButton.alpha = 1;
            GraphicUtil.desaturate(this.myPurchaseButton,false);
         }
         else
         {
            this.myPurchaseButton.alpha = 0.5;
            GraphicUtil.desaturate(this.myPurchaseButton);
         }
         if(canSell)
         {
            this.mySellButton.alpha = 1;
            GraphicUtil.desaturate(this.mySellButton,false);
         }
         else
         {
            this.mySellButton.alpha = 0.5;
            GraphicUtil.desaturate(this.mySellButton);
         }
      }
      
      override protected function onMouseOver() : void
      {
         if(!this.mCanPurchase)
         {
            return;
         }
         super.onMouseOver();
         this.myPurchaseButton.forceShowHighlight();
         this.myPurchaseOverlay.visible = true;
      }
      
      override protected function onMouseOut() : void
      {
         if(!this.mCanPurchase)
         {
            return;
         }
         super.onMouseOut();
         this.myPurchaseButton.forceEndHighlight();
         this.myPurchaseOverlay.visible = false;
      }
      
      override protected function onMouseClick() : void
      {
         if(!this.mCanPurchase)
         {
            return;
         }
         super.onMouseClick();
         var itemData:SDPItemObj = getData() as SDPItemObj;
         SDPlusPvpUtil.instance.executeTransaction(itemData,true);
      }
      
      private function onSell() : void
      {
         var itemData:SDPItemObj = getData() as SDPItemObj;
         SDPlusPvpUtil.instance.executeTransaction(itemData,false);
      }
   }
}

