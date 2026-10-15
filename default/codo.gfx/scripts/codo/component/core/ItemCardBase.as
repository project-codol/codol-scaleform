package codo.component.core
{
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.localization.DictCareer;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.CurrencyObj;
   import codo.objects.ItemBuffListObj;
   import codo.objects.ItemBuffObj;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   import fsg.util.ImageHolderSimple;
   
   public class ItemCardBase extends UIInteractiveComponent
   {
      
      private static const MAX_ICON_PER_COLUMN:int = 3;
      
      private static const ANIMATED_FRAME_WIDTH:int = 392;
      
      private static const ANIMATED_FRAME_HEIGHT:int = 74;
      
      protected static const BUFF_ICON_SIZE:int = 32;
      
      protected static const TEXT_FONT_SIZE:int = 15;
      
      public var myAltText:TextField;
      
      public var myAltTextShadow:TextField;
      
      public var myItemNameTF:TextField;
      
      public var myItemCategoryTF:TextField;
      
      public var myAnimatedEmblemMount:MovieClip;
      
      public var myAnimatedBackgroundMount:MovieClip;
      
      public var myItemIconHolder:ImageHolderSimple;
      
      public var myItemImageHolder:FsgImageHolder;
      
      public var myBuffs:Sprite;
      
      protected var mBufferInitX:Number = 0;
      
      protected var mBufferInitY:Number = 0;
      
      public function ItemCardBase()
      {
         super();
         isInteractiveEnabled = false;
         mouseEnabled = mouseChildren = false;
         var txtFmt:TextFormat = this.myItemCategoryTF.getTextFormat();
         txtFmt.size = TEXT_FONT_SIZE;
         this.myItemCategoryTF.setTextFormat(txtFmt);
         if(Boolean(this.myBuffs))
         {
            this.mBufferInitX = this.myBuffs.x;
            this.mBufferInitY = this.myBuffs.y;
         }
      }
      
      protected function onIconImageLoaded(e:Event) : void
      {
      }
      
      protected function checkUseIconHolderForImage() : Boolean
      {
         return ProductObj(mData).useIconHolderForImage();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var productData:ProductObj = data as ProductObj;
         var currencyData:CurrencyObj = data as CurrencyObj;
         if(null != productData)
         {
            this.setProductObj(productData);
         }
         if(null != currencyData)
         {
            this.setCurrencyObj(currencyData);
         }
      }
      
      protected function setProductObj(productData:ProductObj) : void
      {
         var size:Point = null;
         var animatedBackgroundLoadData:Object = null;
         var animatedIconLoadData:Object = null;
         var buffs:Vector.<ItemBuffObj> = null;
         var imgClass:Class = null;
         var imgHolder:FsgImageHolder = null;
         var maxColumn:int = 0;
         var maxRow:int = 0;
         var fullWidth:int = 0;
         var fullHeight:int = 0;
         var idx:int = 0;
         var buff:ItemBuffObj = null;
         var column:int = 0;
         var row:int = 0;
         var itemName:String = StringUtil.trim(LocalizeUtil.localize(productData.name));
         var useIconHolderForImage:Boolean = this.checkUseIconHolderForImage();
         var isAnimatedBackground:Boolean = productData.isAnimatedBackground();
         var isAnimatedEmblem:Boolean = productData.isAnimatedEmblem();
         var isAnimatedFrame:Boolean = productData.isAnimatedFrame();
         this.myItemNameTF.text = itemName;
         this.myItemImageHolder.visible = this.myAltText.visible = this.myItemIconHolder.visible = this.myAltTextShadow.visible = false;
         this.myAnimatedBackgroundMount.visible = false;
         this.myAnimatedEmblemMount.visible = false;
         if(productData.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myAltText.text = productData.name;
            this.myAltTextShadow.text = productData.name;
            this.myItemImageHolder.visible = false;
            this.myAltTextShadow.y = this.myAltText.y = height * 0.5 - this.myAltText.textHeight * 0.5;
            this.myItemNameTF.text = "";
            this.myAltText.visible = true;
            this.myAltTextShadow.visible = this.myAltText.visible;
         }
         else if(useIconHolderForImage)
         {
            this.myItemIconHolder.visible = true;
            this.myItemIconHolder.addEventListener(Event.COMPLETE,this.onIconImageLoaded);
            this.myItemIconHolder.setImage(productData.imageURL);
         }
         else if(isAnimatedBackground || isAnimatedFrame)
         {
            if(isAnimatedFrame)
            {
               size = new Point(ANIMATED_FRAME_WIDTH,ANIMATED_FRAME_HEIGHT);
            }
            animatedBackgroundLoadData = {
               "name":productData.imageURL,
               "holder":this.myAnimatedBackgroundMount,
               "size":size
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedBackgroundLoadData);
            this.myAnimatedBackgroundMount.visible = true;
         }
         else if(isAnimatedEmblem)
         {
            animatedIconLoadData = {
               "name":productData.imageURL,
               "holder":this.myAnimatedEmblemMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
            this.myAnimatedEmblemMount.visible = true;
         }
         else
         {
            this.myItemImageHolder.visible = true;
            this.myItemImageHolder.setImage(productData.imageURL);
         }
         this.myItemCategoryTF.visible = false;
         var categoryStr:String = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productData.group));
         if(!categoryStr)
         {
            categoryStr = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productData.type));
         }
         if(!StringUtil.isEmpty(categoryStr))
         {
            this.myItemCategoryTF.visible = true;
         }
         if(this.myItemCategoryTF.visible)
         {
            this.myItemCategoryTF.text = categoryStr;
         }
         if(0 < productData.killsReq)
         {
            this.myItemCategoryTF.text = LocalizeUtil.localize(DictCareer.CAREER_KILLS) + " " + productData.killsReq.toString();
            this.myItemCategoryTF.visible = true;
         }
         if(productData.stackable)
         {
            if(productData.stackDelta > 0)
            {
               this.myItemCategoryTF.text = LocalizeUtil.param(DictMarket.MARKET_ITEM_DELTA,[productData.stackDelta]);
               this.myItemCategoryTF.visible = true;
            }
            else if(productData.stackNumber > 0)
            {
               this.myItemCategoryTF.text = LocalizeUtil.param(DictMarket.MARKET_ITEM_QUANTITY,[productData.stackNumber]);
               this.myItemCategoryTF.visible = true;
            }
         }
         if(this.myBuffs != null)
         {
            buffs = ItemBuffListObj.getBuffs(productData);
            imgClass = getDefinitionByName("codo.shared.Size32ImageHolder") as Class;
            while(this.myBuffs.numChildren < buffs.length)
            {
               imgHolder = new imgClass() as FsgImageHolder;
               imgHolder.width = imgHolder.height = BUFF_ICON_SIZE;
               this.myBuffs.addChild(imgHolder);
            }
            maxColumn = Math.ceil(this.myBuffs.numChildren / MAX_ICON_PER_COLUMN) - 1;
            maxRow = MAX_ICON_PER_COLUMN - 1;
            fullWidth = (maxColumn + 1) * (BUFF_ICON_SIZE - 5);
            fullHeight = (maxRow + 1) * (BUFF_ICON_SIZE - 5);
            for(idx = 0; idx < this.myBuffs.numChildren; idx++)
            {
               imgHolder = this.myBuffs.getChildAt(idx) as FsgImageHolder;
               if(idx < buffs.length)
               {
                  imgHolder.visible = true;
                  buff = buffs[idx];
                  imgHolder.setImage(buff.icon);
                  column = Math.floor(idx / MAX_ICON_PER_COLUMN);
                  row = idx % MAX_ICON_PER_COLUMN;
                  imgHolder.x = (maxColumn - column) * (BUFF_ICON_SIZE - 5);
                  imgHolder.y = row * (BUFF_ICON_SIZE - 5);
               }
               else
               {
                  imgHolder.visible = false;
               }
            }
            this.myBuffs.x = this.mBufferInitX - fullWidth;
            this.myBuffs.y = this.mBufferInitY;
         }
      }
      
      protected function positionAnimatedEmblem(emblemClip:MovieClip) : void
      {
         this.myAnimatedEmblemMount.x = this.width / 2 - emblemClip.mySize.width / 2 * this.myAnimatedEmblemMount.scaleX;
      }
      
      protected function setCurrencyObj(currencyObj:CurrencyObj) : void
      {
         this.myAltText.visible = this.myAltTextShadow.visible = this.myAnimatedEmblemMount.visible = this.myAnimatedBackgroundMount.visible = this.myItemIconHolder.visible = this.myBuffs.visible = false;
         this.myItemNameTF.visible = this.myItemImageHolder.visible = this.myItemCategoryTF.visible = true;
         var itemName:String = StringUtil.trim(LocalizeUtil.localize(currencyObj.name));
         this.myItemNameTF.text = itemName;
         this.myItemImageHolder.setImage(currencyObj.image);
         this.myItemCategoryTF.text = LocalizeUtil.param(DictMarket.MARKET_ITEM_DELTA,[currencyObj.amount]);
      }
   }
}

