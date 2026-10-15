package codo.component.marketplaceitem.parts
{
   import codo.component.ItemFooterButton;
   import codo.component.ItemFooterIndicator;
   import codo.component.factory.MarketFactory;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.constants.SE_ID;
   import codo.localization.DictMarket;
   import codo.objects.NotForSaleObj;
   import codo.objects.ProductObj;
   import codo.utils.WarGodUtility;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class MarketplaceItemTools extends MovieClip
   {
      
      public static const MARKET_TOOL_COMPARE:uint = 0;
      
      public static const MARKET_TOOL_PREVIEW:uint = 1;
      
      public static const MARKET_TOOL_DETAILS:uint = 2;
      
      public static const MARKET_TOOL_PURCHASE:uint = 3;
      
      public static const MARKET_TOOL_EQUIP:uint = 4;
      
      public static const MARKET_TOOL_DISABLE_REASON:uint = 5;
      
      public static const MARKET_TOOL_NOTFORSALE_ACTION:uint = 6;
      
      private var mItemFooterButtons:Vector.<ItemFooterButton>;
      
      private var mCardWidth:Number;
      
      public function MarketplaceItemTools()
      {
         super();
         this.mItemFooterButtons = new Vector.<ItemFooterButton>(0);
      }
      
      public function arrangeButtons(data:ProductObj, setHeight:uint) : void
      {
         var i:uint = 0;
         var compareBtn:ItemFooterButton = null;
         var previewLock:Boolean = false;
         var previewItemType:String = null;
         var icon:Bitmap = null;
         var purchaseBtn:ItemFooterButton = null;
         var isOwnedRental:Boolean = false;
         var disableReasonBtn:ItemFooterIndicator = null;
         var extinctionIndicator:ItemFooterIndicator = null;
         var actionButton:ItemFooterButton = null;
         var numButtonsVisible:int = 0;
         for(var j:int = 0; j < this.mItemFooterButtons.length; j++)
         {
            this.mItemFooterButtons[j].enabled = false;
         }
         if(data.compareUiEnabled())
         {
            compareBtn = this.mItemFooterButtons[MARKET_TOOL_COMPARE];
            compareBtn.enabled = true;
            compareBtn.previewIcon = MarketFactory.BUILD_CHECKMARK_ICON();
            compareBtn.audioRef.overrideClickAudio(SE_ID.UI_MARKET_COMPARE_CLICK);
            numButtonsVisible++;
         }
         if(data.previewUiEnabled())
         {
            previewLock = data.group != MarketMenuData.GRP_EMOTE;
            this.mItemFooterButtons[MARKET_TOOL_PREVIEW].isTypeToggle = previewLock;
            this.mItemFooterButtons[MARKET_TOOL_PREVIEW].audioRef.overrideClickAudio(SE_ID.UI_MARKET_PREVIEW_CLICK);
            previewItemType = data.type == ItemType.WEAPON ? data.type : data.group;
            icon = MarketFactory.GET_ITEM_CATEGORY_ICON_BY_TYPE(previewItemType);
            if(icon != null)
            {
               this.mItemFooterButtons[MARKET_TOOL_PREVIEW].previewIcon = icon;
            }
            this.mItemFooterButtons[MARKET_TOOL_PREVIEW].enabled = true;
            numButtonsVisible++;
         }
         if(data.getPrimaryAction() != ProductObj.ACTION_DETAILS && data.detailsUiEnabled() && !data.isWarGodExclusive())
         {
            this.mItemFooterButtons[MARKET_TOOL_DETAILS].enabled = true;
            numButtonsVisible++;
         }
         if(data.purchaseUiEnabled())
         {
            purchaseBtn = this.mItemFooterButtons[MARKET_TOOL_PURCHASE];
            isOwnedRental = data.isOwnedRental();
            purchaseBtn.enabled = true;
            numButtonsVisible++;
            purchaseBtn.gotoAndStop(isOwnedRental ? 1 : 2);
            this.mItemFooterButtons[MARKET_TOOL_PURCHASE].label = data.isOwnedRental() ? DictMarket.EXTEND : DictMarket.BUY;
         }
         if(data.isWarGodExclusive() && !data.purchasable)
         {
            disableReasonBtn = this.mItemFooterButtons[MARKET_TOOL_DISABLE_REASON] as ItemFooterIndicator;
            disableReasonBtn.enabled = true;
            numButtonsVisible++;
            if(data.isBought && data.isPermanentHave)
            {
               disableReasonBtn.label = DictMarket.ITEM_TOOL_INFO_PERMANENT;
               disableReasonBtn.icon = ItemFooterIndicator.ICON_LINKAGE_CHECKED;
            }
            else if(data.purchasedTimes >= data.purchaseLimit)
            {
               disableReasonBtn.label = DictMarket.ITEM_TOOL_INFO_PURCHASE_LIMIT;
               disableReasonBtn.icon = ItemFooterIndicator.ICON_LINKAGE_INFO;
            }
            else
            {
               disableReasonBtn.label = WarGodUtility.getTierName(data.exclusiveUnlockRank - 1);
               disableReasonBtn.icon = ItemFooterIndicator.ICON_LINKAGE_LOCKED;
            }
         }
         if(data.isNotForSaleActionEnabled())
         {
            if(data.notForSaleObj.type == NotForSaleObj.NOT_FOR_SALE_TYPE_EXT)
            {
               extinctionIndicator = this.mItemFooterButtons[MARKET_TOOL_DISABLE_REASON] as ItemFooterIndicator;
               extinctionIndicator.enabled = true;
               extinctionIndicator.icon = ItemFooterIndicator.ICON_LINKAGE_INFO;
               extinctionIndicator.label = DictMarket.NOTSALE_MKT_EXTINCTION;
            }
            else
            {
               actionButton = this.mItemFooterButtons[MARKET_TOOL_NOTFORSALE_ACTION];
               actionButton.enabled = true;
               switch(data.notForSaleObj.type)
               {
                  case NotForSaleObj.NOT_FOR_SALE_TYPE_EVT:
                     actionButton.label = DictMarket.MARKET_ITEM_CHECK_EVENT;
                     break;
                  case NotForSaleObj.NOT_FOR_SALE_TYPE_PVP:
                  case NotForSaleObj.NOT_FOR_SALE_TYPE_PVE:
                     actionButton.label = DictMarket.MARKET_ITEM_GO_MODE;
                     break;
                  case NotForSaleObj.NOT_FOR_SALE_TYPE_OTH:
                     actionButton.label = DictMarket.MARKET_ITEM_CHECK;
               }
            }
            numButtonsVisible++;
         }
         var setX:int = 0;
         var setWidth:int = this.mCardWidth / numButtonsVisible;
         var len:uint = this.mItemFooterButtons.length;
         for(i = 0; i < len; )
         {
            if(this.mItemFooterButtons[i].enabled)
            {
               this.mItemFooterButtons[i].width = setWidth;
               this.mItemFooterButtons[i].height = setHeight;
               this.mItemFooterButtons[i].x = setX;
               this.mItemFooterButtons[i].setData(data);
               setX += this.mItemFooterButtons[i].width;
            }
            i++;
         }
         if(this.mItemFooterButtons[MARKET_TOOL_COMPARE].enabled)
         {
            this.mItemFooterButtons[MARKET_TOOL_COMPARE].setToggled(data.beingCompared);
         }
         if(this.mItemFooterButtons[MARKET_TOOL_PREVIEW].enabled)
         {
            this.mItemFooterButtons[MARKET_TOOL_PREVIEW].setToggled(data.beingPreviewed);
         }
      }
      
      public function set buttonHeight(value:uint) : void
      {
         for(var i:int = 0; i < this.mItemFooterButtons.length; i++)
         {
            if(this.mItemFooterButtons[i].enabled)
            {
               this.mItemFooterButtons[i].width = value;
            }
         }
      }
      
      public function addFooterButton(button:ItemFooterButton) : void
      {
         addChild(button);
         this.mItemFooterButtons.push(button);
      }
      
      public function getFooterButtons() : Vector.<ItemFooterButton>
      {
         return this.mItemFooterButtons;
      }
      
      public function set cardWidth(width:Number) : void
      {
         this.mCardWidth = width;
      }
   }
}

