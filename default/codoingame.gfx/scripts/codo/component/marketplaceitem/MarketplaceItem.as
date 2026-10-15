package codo.component.marketplaceitem
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.ItemFooterButton;
   import codo.component.MarketScrollGrid;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.component.marketplaceitem.parts.MarketplaceItemTools;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.SE_ID;
   import codo.cpp.UiCppNewItems;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.CurrencyObj;
   import codo.objects.ProductObj;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.RenameConfirm;
   import flash.display.DisplayObjectContainer;
   
   public class MarketplaceItem extends UIInteractiveComponent
   {
      
      private var mMarketItemTools:MarketplaceItemTools;
      
      private var mWithCallToArms:Boolean;
      
      public var myMarketplaceItemCard:MarketplaceItemCard;
      
      public var isStandaloneDisplay:Boolean = false;
      
      public var hasPreviewPopup:Boolean = true;
      
      public function MarketplaceItem()
      {
         var testObj:ProductObj = null;
         super();
         isInteractiveEnabled = true;
         if(!ScaleformUtil.isScaleform)
         {
            testObj = new ProductObj();
            testObj.name = "AR14 RIFLE";
            testObj.groupName = "Assault Rifle";
            this.setCardStyle(3,true);
            this.myMarketplaceItemCard.myCallToAction.visible = true;
            this.setData(testObj);
         }
         this.myMarketplaceItemCard.myCallToAction.visible = false;
         mClickable.addClickCallback(this.onClicked);
         audioRef.overrideClickAudio(SE_ID.UI_Market_Select_Item_Appear);
      }
      
      override public function setData(data:*) : void
      {
         var productData:ProductObj = null;
         var currencyData:CurrencyObj = null;
         var toolHeight:uint = 0;
         super.setData(data);
         productData = data as ProductObj;
         currencyData = data as CurrencyObj;
         visible = false;
         if(productData != null)
         {
            this.myMarketplaceItemCard.setData(productData);
            visible = true;
         }
         if(currencyData != null)
         {
            this.myMarketplaceItemCard.setData(currencyData);
            visible = true;
         }
         if(visible == false)
         {
            return;
         }
         this.myMarketplaceItemCard.setData(productData);
         if(this.mMarketItemTools != null)
         {
            toolHeight = this.myMarketplaceItemCard.currentFrame == MarketItemUtil.ITEM_CARD_SMALL_FRAME ? 22 : 31;
            this.mMarketItemTools.arrangeButtons(productData,toolHeight);
         }
      }
      
      public function setCardStyle(frame:uint, withTools:Boolean, withCallToArms:Boolean = true) : void
      {
         this.myMarketplaceItemCard.setCardStyle(frame,withTools);
         if(withTools)
         {
            this.mMarketItemTools = addChild(MarketFactory.BUILD_MARKET_TOOLS(this.myMarketplaceItemCard.width)) as MarketplaceItemTools;
            this.mMarketItemTools.x = this.myMarketplaceItemCard.toolPosX + 1;
            this.mMarketItemTools.y = this.myMarketplaceItemCard.toolPosY;
            this.mMarketItemTools.cardWidth = this.myMarketplaceItemCard.width - 6;
            this.clickFooterItemCallback = this.onFooterClicked;
         }
         myHitArea.width = this.width;
         myHitArea.height = this.height;
         myHitArea.x = this.myMarketplaceItemCard.x;
         myHitArea.y = this.myMarketplaceItemCard.y;
         this.mWithCallToArms = withCallToArms;
      }
      
      override public function set clickFooterItemCallback(callback:Function) : void
      {
         var footerItem:ItemFooterButton = null;
         if(this.mMarketItemTools != null)
         {
            for each(footerItem in this.mMarketItemTools.getFooterButtons())
            {
               footerItem.registerClickUpEvent(callback,footerItem);
            }
         }
      }
      
      public function set withDiscountTag(withDiscount:Boolean) : void
      {
         this.myMarketplaceItemCard.withDiscountTag = withDiscount;
      }
      
      public function set withOwnStateHint(withHint:Boolean) : void
      {
         this.myMarketplaceItemCard.withOwnStateHint = withHint;
      }
      
      override protected function onMouseOver() : void
      {
         if(this.hasPreviewPopup)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":mData,
               "compare":true
            });
         }
         if(!this.mWithCallToArms)
         {
            return;
         }
         this.myMarketplaceItemCard.myCallToAction.setFocused(true);
         if(!this.isStandaloneDisplay)
         {
            parent.swapChildren(this,parent.getChildAt(parent.numChildren - 1));
         }
         var product:ProductObj = mData as ProductObj;
         if(product != null && product.showBreadcrumb)
         {
            UiCppNewItems.instance.ClearNew(product);
            product.showBreadcrumb = false;
            this.setData(product);
         }
      }
      
      override protected function onMouseOut() : void
      {
         if(this.hasPreviewPopup)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
         }
         if(!this.mWithCallToArms)
         {
            return;
         }
         if(!this.isStandaloneDisplay)
         {
            if(parent != null && parent.getChildAt(0) != null)
            {
               parent.swapChildren(this,parent.getChildAt(0));
            }
         }
         this.myMarketplaceItemCard.myCallToAction.setFocused(false);
      }
      
      override protected function onMouseMoved() : void
      {
         this.myMarketplaceItemCard.myCallToAction.mouseMove();
      }
      
      override public function get width() : Number
      {
         return this.myMarketplaceItemCard.width;
      }
      
      override public function get height() : Number
      {
         return this.myMarketplaceItemCard.height;
      }
      
      public function set withCallToArms(value:Boolean) : void
      {
         this.mWithCallToArms = value;
      }
      
      protected function onClicked() : void
      {
         if(!this.mWithCallToArms)
         {
            return;
         }
         var product:ProductObj = mData as ProductObj;
         var action:uint = product.getPrimaryAction();
         this.doAction(product,action);
      }
      
      protected function doAction(prod:ProductObj, action:uint, footer:ItemFooterButton = null) : void
      {
         var index:int = 0;
         var newCompareItem:ProductObj = null;
         var other:ProductObj = null;
         var dependencyData:ProductObj = null;
         if(action == ProductObj.ACTION_BUY)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prod});
         }
         else if(action == ProductObj.ACTION_UNEQUIP)
         {
            if(prod.type == MarketMenuData.TYPE_KILLSTREAK || prod.group == MarketMenuData.GRP_KNIFE)
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":prod});
            }
            else
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_UNEQUIP_ITEM_BY_ITEM,{"data":prod});
            }
         }
         else if(action == ProductObj.ACTION_EQUIP)
         {
            if(prod.group == MarketMenuData.GRP_EMOTE)
            {
               index = this.myMarketplaceItemCard.myCallToAction.getSelectedEmoteSlotIndex();
               if(index >= 0)
               {
                  EventManager.getInstance().broadcast(BCEvent.EVT_EQUIP,{
                     "item":prod,
                     "index":index
                  });
               }
            }
            else
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_EQUIP,{"item":prod});
            }
         }
         else if(action == ProductObj.ACTION_CONSUME)
         {
            if(prod.nameid == "cnc_token")
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_CHANGE_NAME_POPUP,{"type":RenameConfirm.RENAME_TYPE_PLAYER});
            }
            else if(prod.nameid == "stat_reset_token")
            {
               EventManager.getInstance().broadcast(BCEvent.EVT_REDEEM_STAT_RESET);
            }
         }
         else if(action == ProductObj.ACTION_DETAILS)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_SHOW_DETAILS,{"itemData":prod});
         }
         else if(action == ProductObj.ACTION_COMPARE)
         {
            if(!prod.beingCompared)
            {
               other = DataManager.getInstance().getDP(DataID.MARKET_COMPARE_ITEM) as ProductObj;
               if(other == null)
               {
                  newCompareItem = prod;
               }
               else
               {
                  EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_MARKET_COMPARE,{
                     "id1":other.id,
                     "id2":prod.id,
                     "prod1":other,
                     "prod2":prod
                  });
               }
            }
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_SET_COMPARE_ITEM,newCompareItem);
            this.refreshItemList();
         }
         else if(action == ProductObj.ACTION_PREVIEW)
         {
            if(prod.type != MarketMenuData.TYPE_CALLSIGN_CHANGE_NAME && prod.type != MarketMenuData.TYPE_CALLSIGN_TITLE && prod.type != MarketMenuData.TYPE_CALLSIGN_EMBLEM && prod.type != MarketMenuData.TYPE_CALLSIGN_BKG && prod.type != MarketMenuData.TYPE_CALLSIGN_NAMEPLATE && prod.type != MarketMenuData.TYPE_CALLSIGN_FRAME)
            {
               if(footer.isTypeToggle && !footer.toggled)
               {
                  EventManager.getInstance().broadcast(BCEvent.EVT_PREVIEW_REMOVE,{"item":prod});
               }
               else
               {
                  EventManager.getInstance().broadcast(BCEvent.EVT_EQUIP,{
                     "item":prod,
                     "isPreviewing":true
                  });
               }
            }
         }
         else if(action == ProductObj.ACTION_DEPENDENCY)
         {
            if(prod.itemDependencies.length > 0)
            {
               dependencyData = CFunctionCommonContainer.GetItemInfo(prod.itemDependencies[0]);
               EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP_DEPENDENCY_POPUP,{
                  "rewardItem":prod,
                  "dependency":dependencyData
               });
            }
         }
         else if(action == ProductObj.ACTION_NOTFORSALE)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_DO_NOTFORSALE_ACTION,prod);
         }
      }
      
      protected function onFooterClicked(footer:ItemFooterButton) : void
      {
         var data:ProductObj = footer.getData() as ProductObj;
         var action:uint = ProductObj.ACTION_NONE;
         switch(footer.index)
         {
            case MarketplaceItemTools.MARKET_TOOL_COMPARE:
               action = ProductObj.ACTION_COMPARE;
               break;
            case MarketplaceItemTools.MARKET_TOOL_PREVIEW:
               action = ProductObj.ACTION_PREVIEW;
               break;
            case MarketplaceItemTools.MARKET_TOOL_PURCHASE:
               action = ProductObj.ACTION_BUY;
               break;
            case MarketplaceItemTools.MARKET_TOOL_EQUIP:
               action = ProductObj.ACTION_EQUIP;
               break;
            case MarketplaceItemTools.MARKET_TOOL_DETAILS:
               action = ProductObj.ACTION_DETAILS;
               break;
            case MarketplaceItemTools.MARKET_TOOL_NOTFORSALE_ACTION:
               action = ProductObj.ACTION_NOTFORSALE;
         }
         this.doAction(data,action,footer);
      }
      
      protected function refreshItemList() : void
      {
         var list:MarketScrollGrid = null;
         var owner:DisplayObjectContainer = parent;
         while(owner != null)
         {
            list = owner as MarketScrollGrid;
            if(list != null)
            {
               list.refresh();
               return;
            }
            owner = owner.parent;
         }
      }
   }
}

