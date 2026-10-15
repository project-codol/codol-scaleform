package codo.views.supplyDrop_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.MarketplaceDiscountItemPromoTag;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.style.SupplyDropGuide;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class SupplyDropItem extends UIInteractiveComponent
   {
      
      public static const TYPE_EVENT_CRATE_PATH:String = "badge_taunt_fireworks_bundle_icon";
      
      public static const TYPE_ADVANCED_CRATE_PATH:String = "badge_taunt_cash_bundle_icon";
      
      public static const TYPE_BASIC_CRATE_PATH:String = "badge_taunt_lightning_bundle_icon";
      
      public var myCallToAction:SupplyDropItemCallToAction;
      
      public var myDiscountTag:MarketplaceDiscountItemPromoTag;
      
      public var myNextDropProgressBar:SupplyDropRewardProgressBar;
      
      public var myNextDropLabelTF:TextField;
      
      public var myTitleTF:TextField;
      
      public var myQuantity:SupplyDropItemQuantity;
      
      public var myImage:FsgImageHolder;
      
      public var myOpenButton:SupplyDropItemOpenButton;
      
      public var myBuyButton:CallToActionButton;
      
      public var myBackground:Sprite;
      
      public var myLSDBackground:Sprite;
      
      private var mDropID:int;
      
      private var mQuantity:int;
      
      private var mDust:int;
      
      private var mProdObj:ProductObj;
      
      private var mToggleItemPreviewBoxHandler:Function;
      
      public function SupplyDropItem()
      {
         super();
         isInteractiveEnabled = true;
         this.mDropID = 0;
         this.mQuantity = 0;
         this.mDust = 0;
         this.myLSDBackground.visible = false;
         if(ScaleformUtil.isScaleform)
         {
            setClickCallback(this.onClickHandler);
            registerFocusEvent(this.onMouseOver);
            registerUnfocusEvent(this.onMouseOut);
         }
         this.myTitleTF.visible = false;
         this.myTitleTF.textStyle = SupplyDropGuide.styleSupplyDropItemTitle;
         this.myTitleTF.width = this.myBackground.width - 20;
         this.myCallToAction.visible = false;
         this.myDiscountTag.visible = false;
         this.myNextDropProgressBar.visible = false;
         this.myNextDropLabelTF.visible = false;
         this.myNextDropLabelTF.textStyle = SupplyDropGuide.styleSupplyDropItemNextDrop;
         this.myNextDropLabelTF.text = Dict.NEXT_SUPPLY_DROP;
         this.myOpenButton.visible = false;
         this.myOpenButton.label = LocalizeUtil.localize(Dict.OPEN);
         this.myOpenButton.registerClickEvent(this.onConsumeBtnClicked);
         this.myOpenButton.isInteractiveEnabled = true;
         this.myBuyButton.visible = false;
         this.myBuyButton.label = LocalizeUtil.localize(DictMarket.BUY);
         this.myBuyButton.registerClickEvent(this.onBuyBtnClicked);
         this.myBuyButton.isInteractiveEnabled = true;
         this.myQuantity.quantity = 0;
         this.progress = 0;
      }
      
      protected function onClickHandler() : void
      {
         if(this.mQuantity > 0)
         {
            this.onConsumeBtnClicked();
            return;
         }
         this.onBuyBtnClicked();
      }
      
      override protected function onMouseOver() : void
      {
         if(this.mQuantity > 0 || this.mProdObj != null)
         {
            this.myCallToAction.visible = true;
         }
         var prod:ProductObj = this.mProdObj;
         if(prod == null)
         {
            prod = CFunctionCommonContainer.GetItemInfo(this.mDropID);
         }
         this.mToggleItemPreviewBoxHandler(true,prod);
      }
      
      override protected function onMouseOut() : void
      {
         this.myCallToAction.visible = false;
         this.mToggleItemPreviewBoxHandler(false,null);
      }
      
      public function setProductObj(prod:ProductObj) : void
      {
         this.layoutConsumeAndOpenButtons();
         this.mProdObj = prod;
         if(this.mProdObj == null)
         {
            this.myDiscountTag.visible = false;
            return;
         }
         var discountTxt:String = ItemUtil.getItemSaleValueBySku(this.mProdObj.SKUs);
         if(!this.mProdObj.ignoreDiscount && discountTxt != null)
         {
            this.myDiscountTag.visible = true;
            this.myDiscountTag.discount = discountTxt;
         }
         else
         {
            this.myDiscountTag.visible = false;
         }
      }
      
      public function getProductObj() : ProductObj
      {
         return this.mProdObj;
      }
      
      public function setToggleItemPreviewBoxHandler(handler:Function) : void
      {
         this.mToggleItemPreviewBoxHandler = handler;
      }
      
      public function set title(txt:String) : void
      {
         this.myTitleTF.text = txt;
         this.myTitleTF.visible = true;
      }
      
      public function set itemImage(texturePath:String) : void
      {
         this.myImage.setImage(texturePath);
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      public function set dropID(val:int) : void
      {
         this.mDropID = val;
         if(CFunctionContainer.AS_GetSupplyDropDustExchangeRatio(this.mDropID) > 0)
         {
            this.myNextDropLabelTF.visible = true;
            this.myNextDropProgressBar.visible = true;
         }
      }
      
      public function get dropID() : int
      {
         return this.mDropID;
      }
      
      public function updateQuantityAndProgress() : void
      {
         var exchangeDustRequirement:int = DataManager.getInstance().getDP(DataID.GET_SUPPLY_DROP_EXCHANGE_DUST_NUM,[this.mDropID]);
         if(exchangeDustRequirement > 0)
         {
            this.myQuantity.quantity = this.mQuantity + Math.floor(this.mDust / exchangeDustRequirement);
            this.myOpenButton.count = this.myQuantity.quantity;
            this.progress = this.mDust % exchangeDustRequirement / 100;
         }
         else
         {
            this.myQuantity.quantity = this.mQuantity;
            this.myOpenButton.count = this.myQuantity.quantity;
            this.progress = 0;
         }
      }
      
      public function get quantity() : uint
      {
         return this.myQuantity.quantity;
      }
      
      public function set quantity(val:uint) : void
      {
         this.mQuantity = val;
         this.updateQuantityAndProgress();
         this.layoutConsumeAndOpenButtons();
      }
      
      public function set dust(val:uint) : void
      {
         this.mDust = val;
         this.updateQuantityAndProgress();
         this.layoutConsumeAndOpenButtons();
      }
      
      private function layoutConsumeAndOpenButtons() : void
      {
         var btn:Button = null;
         var availableButtons:Array = new Array();
         this.myOpenButton.visible = false;
         this.myBuyButton.visible = false;
         if(this.myQuantity.quantity > 0)
         {
            this.myOpenButton.visible = true;
            availableButtons.push(this.myOpenButton);
         }
         if(this.mProdObj != null)
         {
            this.myBuyButton.visible = true;
            availableButtons.push(this.myBuyButton);
         }
         var padding:int = 4;
         for(var i:int = 0; i < availableButtons.length; i++)
         {
            btn = availableButtons[i];
            btn.visible = true;
            btn.gotoAndStop(2);
            btn.width = availableButtons.length == 1 ? this.width : (this.width - (availableButtons.length - 1) * padding) / availableButtons.length;
            btn.x = i * (padding + btn.width);
         }
         if(this.mQuantity != 0)
         {
            this.myCallToAction.myLabelTF.text = ScaleformUtil.isScaleform ? Dict.OPEN : "OPEN";
         }
         else if(this.mProdObj != null)
         {
            this.myCallToAction.myLabelTF.text = ScaleformUtil.isScaleform ? DictMarket.BUY : "BUY";
         }
         else
         {
            this.myCallToAction.myLabelTF.text = "";
         }
      }
      
      public function consumeSupplyDrop(quantity:int) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_REWARD_CONSUME_SUPPLY_DROP_REQUEST,{
            "dropID":this.mDropID,
            "quantity":quantity,
            "gotoPrevPageIfFailed":false
         });
      }
      
      private function onConsumeBtnClicked() : void
      {
         if(this.mQuantity > 0)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_REWARD_CONSUME_SUPPLY_DROP_REQUEST,{
               "dropID":this.mDropID,
               "quantity":1,
               "gotoPrevPageIfFailed":false
            });
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_OPEN_DUST_EXCHANGED_SUPPLY_DROP,{
               "dropID":this.mDropID,
               "gotoPrevPageIfFailed":false
            });
         }
      }
      
      private function onBuyBtnClicked() : void
      {
         if(this.mProdObj != null)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":this.mProdObj});
         }
      }
      
      public function set progress(value:Number) : void
      {
         if(this.myNextDropProgressBar.progress != value)
         {
            this.myNextDropProgressBar.progress = value;
            this.myNextDropProgressBar.playAnimation();
         }
      }
      
      public function get progress() : Number
      {
         return this.myNextDropProgressBar.progress;
      }
   }
}

