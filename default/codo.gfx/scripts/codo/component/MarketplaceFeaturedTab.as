package codo.component
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionContainer;
   import codo.component.factory.MarketFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.WebImgData;
   import codo.event.ParaEvent;
   import codo.localization.DictMarket;
   import codo.objects.FeaturedAdObj;
   import codo.objects.FeaturedItemsObj;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.WebAdObj;
   import codo.views.marketplace_parts.MarketplaceFeaturedAdsContainer;
   import flash.display.MovieClip;
   
   public class MarketplaceFeaturedTab extends BaseSubElement
   {
      
      protected var mWidth:Number = 0;
      
      protected var mHeight:Number = 0;
      
      protected var mActive:Boolean;
      
      private var mFeatureDataArrays:Array;
      
      private var mCurrentListCategoryIndex:int = -1;
      
      private var mDefaultListCategoryIndex:int = 0;
      
      public var myItemList:MarketScrollGrid;
      
      public var myBackground:MovieClip;
      
      public var myFeaturedSlideShow:MarketplaceFeaturedAdsContainer;
      
      public var myToggleBtn0:FilterToggleButton;
      
      public var myToggleBtn1:FilterToggleButton;
      
      public var myToggleBtn2:FilterToggleButton;
      
      public var myToggleBtn3:FilterToggleButton;
      
      public var myListBackground:ContentContainer;
      
      public var myAdSlideShow0:MarketplaceFeaturedAdsContainer;
      
      public var myAdSlideShow1:MarketplaceFeaturedAdsContainer;
      
      public var myAdSlideShow2:MarketplaceFeaturedAdsContainer;
      
      public var myAdSlideShow3:MarketplaceFeaturedAdsContainer;
      
      public function MarketplaceFeaturedTab()
      {
         var gridSettings:ScrollGridSettings = null;
         super();
         this.myListBackground.width = 511;
         this.myListBackground.height = 791;
         this.myListBackground.showHalfAccentsLeft();
         gridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD;
         gridSettings.useNavArrows = false;
         this.myItemList.y -= 20;
         this.myItemList.initGrid(gridSettings,4,false,2);
         this.myToggleBtn0.label = DictMarket.MARKETPLACE_HOT;
         this.myToggleBtn1.label = DictMarket.MARKETPLACE_NEW_ITEM;
         this.myToggleBtn2.label = DictMarket.MARKETPLACE_RECOMMENDED;
         this.myToggleBtn3.label = DictMarket.MARKETPLACE_POPULAR;
         var BUTTON_GAP_X:Number = 10;
         this.myToggleBtn0.x = this.myItemList.x;
         this.myToggleBtn1.x = this.myToggleBtn0.x + this.myToggleBtn0.myBackground.width + BUTTON_GAP_X;
         this.myToggleBtn2.x = this.myToggleBtn1.x + this.myToggleBtn1.myBackground.width + BUTTON_GAP_X;
         this.myToggleBtn3.x = this.myToggleBtn2.x + this.myToggleBtn2.myBackground.width + BUTTON_GAP_X;
         this.myToggleBtn0.registerClickEvent(this.onSetTab,0);
         this.myToggleBtn1.registerClickEvent(this.onSetTab,1);
         this.myToggleBtn2.registerClickEvent(this.onSetTab,2);
         this.myToggleBtn3.registerClickEvent(this.onSetTab,3);
      }
      
      private function buildItemListData(data:Array, tabIndex:uint) : void
      {
         var obj:ProductObj = null;
         if(data == null)
         {
            return;
         }
         var productObjs:Vector.<Object> = new Vector.<Object>(0);
         for each(obj in data)
         {
            obj.showBreadcrumb = false;
            productObjs.push(obj);
         }
         if(productObjs.length > 0)
         {
            this.mFeatureDataArrays[tabIndex] = productObjs;
         }
      }
      
      override public function active() : void
      {
         this.mActive = true;
         this.mCurrentListCategoryIndex = this.mDefaultListCategoryIndex;
         this.mDefaultListCategoryIndex = 0;
         this.refreshList();
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryUpdated);
         bind(DataID.WEB_IMG_STATUS,this.bind_webImgStatus);
      }
      
      private function onInventoryUpdated(cEvt:ParaEvent) : void
      {
         this.refreshList();
      }
      
      private function refreshList() : void
      {
         this.mFeatureDataArrays = [];
         var MAX_TOP_SELLERS:int = 12;
         var featureData:FeaturedItemsObj = CFunctionContainer.MKT_GetFeaturedItems(MAX_TOP_SELLERS) as FeaturedItemsObj;
         if(Boolean(featureData))
         {
            this.buildItemListData(featureData.hotItems,0);
            this.buildItemListData(featureData.newItems,1);
            this.buildItemListData(featureData.popularItems,2);
            this.buildItemListData(featureData.recommendedItems,3);
            this.onSetTab(this.mCurrentListCategoryIndex,true);
         }
      }
      
      public function isActive() : Boolean
      {
         return this.mActive;
      }
      
      override public function deactive() : void
      {
         this.mActive = false;
         unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryUpdated);
         unbind(DataID.WEB_IMG_STATUS,this.bind_webImgStatus);
      }
      
      public function showTab() : void
      {
         this.visible = true;
         this.myFeaturedSlideShow.startTimer();
      }
      
      public function setDefaultTab(index:int) : void
      {
         this.mDefaultListCategoryIndex = index;
      }
      
      public function hideTab() : void
      {
         this.visible = false;
         this.myFeaturedSlideShow.stopTimer();
      }
      
      public function setListItemFocusCallback(func:Function) : void
      {
         this.myItemList.listItemFocusCallback = func;
      }
      
      public function setListItemUnfocusCallback(func:Function) : void
      {
         this.myItemList.listItemUnfocusCallback = func;
      }
      
      private function onSetTab(index:int, forceUpdate:Boolean = false) : void
      {
         if(forceUpdate || this.mCurrentListCategoryIndex != index)
         {
            this.mCurrentListCategoryIndex = index;
            this.myItemList.resetList();
            this.myItemList.addItemsByVector(this.mFeatureDataArrays[index]);
            this.myToggleBtn0.setBar(index == 0);
            this.myToggleBtn1.setBar(index == 1);
            this.myToggleBtn2.setBar(index == 2);
            this.myToggleBtn3.setBar(index == 3);
         }
      }
      
      private function bind_webImgStatus(cResult:Object) : void
      {
         var isAllImgReady:Boolean = false;
         var j:uint = 0;
         var images:Array = null;
         var imageVec:Vector.<FeaturedAdObj> = null;
         var imgCheckerData:Array = cResult.data;
         for(var i:uint = 0; i < imgCheckerData.length; i++)
         {
            if(imgCheckerData[i] == null)
            {
               continue;
            }
            isAllImgReady = true;
            for(j = 0; j < imgCheckerData[i].length; j++)
            {
               if(imgCheckerData[i][j].isReady == false)
               {
                  isAllImgReady = false;
                  break;
               }
            }
            if(!(isAllImgReady == true && imgCheckerData[i].length > 0))
            {
               continue;
            }
            switch(imgCheckerData[i][0].imgData.id)
            {
               case WebImgData.MARKET_AD1.id:
                  images = WebImgData.getWebImgURLs(WebImgData.MARKET_AD1.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oFeaturedAdClicked,"codo.shared.marketplace.marketWebAdSlide");
                  this.myFeaturedSlideShow.setData(imageVec);
                  break;
               case WebImgData.MARKET_AD2.id:
                  images = WebImgData.getWebImgURLs(WebImgData.MARKET_AD2.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd0Clicked,"codo.shared.marketplace.marketWebAdSlideSmall");
                  this.myAdSlideShow0.setData(imageVec);
                  break;
               case WebImgData.MARKET_AD3.id:
                  images = WebImgData.getWebImgURLs(WebImgData.MARKET_AD3.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd1Clicked,"codo.shared.marketplace.marketWebAdSlideSmall");
                  this.myAdSlideShow1.setData(imageVec);
                  break;
               case WebImgData.MARKET_AD4.id:
                  images = WebImgData.getWebImgURLs(WebImgData.MARKET_AD4.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd2Clicked,"codo.shared.marketplace.marketWebAdSlideSmall");
                  this.myAdSlideShow2.setData(imageVec);
                  break;
               case WebImgData.MARKET_AD5.id:
                  images = WebImgData.getWebImgURLs(WebImgData.MARKET_AD5.id,imgCheckerData[i].length);
                  imageVec = this.getFeaturedAdListFromWebImgs(images,this.oAd3Clicked,"codo.shared.marketplace.marketWebAdSlideSmall");
                  this.myAdSlideShow3.setData(imageVec);
            }
         }
      }
      
      private function getFeaturedAdListFromWebImgs(data:Array, callback:Function, linkage:String) : Vector.<FeaturedAdObj>
      {
         var featuredItem:FeaturedAdObj = null;
         var webAd:WebAdObj = null;
         var vec:Vector.<FeaturedAdObj> = new Vector.<FeaturedAdObj>();
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            webAd = new WebAdObj(data[i],callback);
            featuredItem = new FeaturedAdObj(linkage,webAd);
            vec.push(featuredItem);
         }
         return vec;
      }
      
      private function oFeaturedAdClicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_AD1,{"index":this.myFeaturedSlideShow.currentPage});
      }
      
      private function oAd0Clicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_AD2,{"index":this.myAdSlideShow0.currentPage});
      }
      
      private function oAd1Clicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_AD3,{"index":this.myAdSlideShow1.currentPage});
      }
      
      private function oAd2Clicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_AD4,{"index":this.myAdSlideShow2.currentPage});
      }
      
      private function oAd3Clicked() : void
      {
         broadcast(BCEvent.EVT_MARKET_AD5,{"index":this.myAdSlideShow3.currentPage});
      }
   }
}

