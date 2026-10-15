package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.BackButton;
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import components.marketplace_part.MarketplaceCompareStatsPanel;
   import components.marketplace_part.MarketplaceCompareWeaponPanel;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class MarketplaceCompareView extends BaseView
   {
      
      public var weaponPanelLeft:MarketplaceCompareWeaponPanel;
      
      public var weaponPanelRight:MarketplaceCompareWeaponPanel;
      
      public var myLeftItem:MarketplaceItem;
      
      public var myRightItem:MarketplaceItem;
      
      public var weaponStatsComparePanel:MarketplaceCompareStatsPanel;
      
      public var myBackButton:BackButton;
      
      public var myLeftButton:Button;
      
      public var myRightButton:Button;
      
      public var myLeftBuyButton:CallToActionButton;
      
      public var myRightBuyButton:CallToActionButton;
      
      private var mLeftProd:ProductObj;
      
      private var mRightProd:ProductObj;
      
      public function MarketplaceCompareView()
      {
         super();
         this.myBackButton.registerClickEvent(this.onBackButtonClicked);
         this.myBackButton.doNotUseBackground();
         this.myLeftItem = MarketFactory.BUILD_MARKET_ITEM_LARGE_CARD() as MarketplaceItem;
         this.myLeftItem.isInteractiveEnabled = false;
         addChild(this.myLeftItem);
         this.myRightItem = MarketFactory.BUILD_MARKET_ITEM_LARGE_CARD() as MarketplaceItem;
         this.myRightItem.isInteractiveEnabled = false;
         addChild(this.myRightItem);
      }
      
      override public function set routeData(data:*) : void
      {
         this.mLeftProd = Boolean(data.prod1) ? data.prod1 : CFunctionCommonContainer.GetItemInfo(data.id1);
         this.mRightProd = Boolean(data.prod2) ? data.prod2 : CFunctionCommonContainer.GetItemInfo(data.id2);
         this.setData();
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(this.weaponStatsComparePanel.visible)
         {
            this.weaponStatsComparePanel.startAnimation();
         }
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      override protected function hideView() : void
      {
         this.cleanup();
         super.hideView();
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
      }
      
      private function onStageKeyHandle(e:KeyboardEvent) : void
      {
         if(e.type == KeyboardEvent.KEY_UP)
         {
            switch(e.keyCode)
            {
               case Keyboard.ESCAPE:
                  this.onBackButtonClicked();
            }
         }
      }
      
      private function onBackButtonClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
      
      private function setData() : void
      {
         var bComparingToBase:Boolean = false;
         var CARD_TOP_OFFSET:uint = 0;
         var BUTTON_BOTTOM_OFFSET:uint = 0;
         bComparingToBase = this.mLeftProd.id == this.mRightProd.baseID;
         this.weaponPanelLeft.data = this.mLeftProd;
         this.weaponPanelRight.data = this.mRightProd;
         if(this.weaponPanelLeft.myBackground.height < this.weaponPanelRight.myBackground.height)
         {
            this.weaponPanelLeft.myBackground.height = this.weaponPanelRight.myBackground.height;
         }
         else
         {
            this.weaponPanelRight.myBackground.height = this.weaponPanelLeft.myBackground.height;
         }
         this.weaponPanelLeft.x = bComparingToBase ? 440 : 310;
         this.weaponPanelRight.x = bComparingToBase ? 940 : 1200;
         this.weaponStatsComparePanel.visible = !bComparingToBase;
         if(!bComparingToBase)
         {
            this.weaponStatsComparePanel.setData(this.mLeftProd,this.mRightProd);
         }
         if(this.mLeftProd.equipUiEnabled())
         {
            this.myLeftButton.label = LocalizeUtil.localize(Dict.EQUIP_ITEM);
            this.myLeftButton.registerClickEvent(this.onEquipItem,this.mLeftProd.id);
            this.myLeftButton.visible = true;
            this.myLeftBuyButton.visible = false;
         }
         else if(this.mLeftProd.purchaseUiEnabled())
         {
            this.myLeftBuyButton.label = this.mLeftProd.isOwnedRental() ? DictMarket.EXTEND : LocalizeUtil.localize(DictMarket.BUY);
            this.myLeftBuyButton.registerClickEvent(this.onBuyItem,this.mLeftProd.id);
            this.myLeftBuyButton.visible = true;
            this.myLeftButton.visible = false;
         }
         else
         {
            this.myLeftButton.visible = false;
            this.myLeftBuyButton.visible = false;
         }
         if(this.mRightProd.equipUiEnabled())
         {
            this.myRightButton.label = LocalizeUtil.localize(Dict.EQUIP_ITEM);
            this.myRightButton.registerClickEvent(this.onEquipItem,this.mRightProd.id);
            this.myRightButton.visible = true;
            this.myRightBuyButton.visible = false;
         }
         else if(this.mRightProd.purchaseUiEnabled())
         {
            this.myRightBuyButton.label = this.mRightProd.isOwnedRental() ? DictMarket.EXTEND : LocalizeUtil.localize(DictMarket.BUY);
            this.myRightBuyButton.registerClickEvent(this.onBuyItem,this.mRightProd.id);
            this.myRightBuyButton.visible = true;
            this.myRightButton.visible = false;
         }
         else
         {
            this.myRightButton.visible = false;
            this.myRightBuyButton.visible = false;
         }
         if(ScaleformUtil.isScaleform)
         {
            this.myLeftItem.setData(this.mLeftProd);
            this.myRightItem.setData(this.mRightProd);
         }
         CARD_TOP_OFFSET = 6;
         BUTTON_BOTTOM_OFFSET = 10;
         this.myLeftItem.x = this.weaponPanelLeft.x;
         this.myLeftItem.y = this.weaponPanelLeft.y - CARD_TOP_OFFSET;
         this.myRightItem.x = this.weaponPanelRight.x;
         this.myRightItem.y = this.weaponPanelRight.y - CARD_TOP_OFFSET;
         this.myLeftButton.x = this.myLeftBuyButton.x = this.myLeftItem.x + this.myLeftItem.width - this.myLeftButton.width;
         this.myLeftButton.y = this.myLeftBuyButton.y = this.weaponPanelLeft.y + this.weaponPanelLeft.myBackground.height + BUTTON_BOTTOM_OFFSET;
         this.myRightButton.x = this.myRightBuyButton.x = this.myRightItem.x + this.myRightItem.width - this.myRightButton.width;
         this.myRightButton.y = this.myRightBuyButton.y = this.weaponPanelRight.y + this.weaponPanelRight.myBackground.height + BUTTON_BOTTOM_OFFSET;
      }
      
      private function onBuyItem(id:int) : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
         var item:ProductObj = id == this.mLeftProd.id ? this.weaponPanelLeft.data : this.weaponPanelRight.data;
         broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":item});
      }
      
      private function onEquipItem(id:int) : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
         var item:ProductObj = id == this.mLeftProd.id ? this.weaponPanelLeft.data : this.weaponPanelRight.data;
         broadcast(BCEvent.EVT_EQUIP,{"item":item});
      }
      
      private function cleanup() : void
      {
         this.myLeftButton.unRegisterClickEvent(this.onEquipItem,this.mLeftProd.id);
         this.myLeftBuyButton.unRegisterClickEvent(this.onBuyItem,this.mLeftProd.id);
         this.myRightButton.unRegisterClickEvent(this.onEquipItem,this.mRightProd.id);
         this.myRightBuyButton.unRegisterClickEvent(this.onBuyItem,this.mRightProd.id);
      }
   }
}

