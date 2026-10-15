package codo.component.social
{
   import codo.objects.PageListSettings;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class PageList extends MovieClip
   {
      
      protected static const PAGE_SELECTOR_GAP:int = 8;
      
      public var myPageListSelector:PageListSelector;
      
      protected var mCurrentPage:int;
      
      protected var mTotalPage:int;
      
      protected var mDataCount:int;
      
      protected var mSetting:PageListSettings;
      
      protected var mDataProvider:Array;
      
      protected var mRenderKeeper:Vector.<PageListBaseRender> = new Vector.<PageListBaseRender>();
      
      public function PageList()
      {
         super();
      }
      
      public function set settings(newSettings:PageListSettings) : void
      {
         this.mSetting = newSettings;
         this.doPrepare();
      }
      
      private function doPrepare() : void
      {
         var i:int = 0;
         var render:PageListBaseRender = null;
         var cls:Class = getDefinitionByName(this.mSetting.renderLinkName) as Class;
         this.mRenderKeeper.splice(0,this.mRenderKeeper.length);
         var lastRenderWidth:Number = 0;
         var lastRenderLeftX:Number = 0;
         var lastRenderRightDownY:Number = 0;
         for(i = 0; i < this.mSetting.itemCountPerPage; i++)
         {
            render = new cls() as PageListBaseRender;
            this.mRenderKeeper.push(render);
            render.index = i;
            render.x = 0;
            render.y = i * (render.height + this.mSetting.itemPadding);
            render.buttonClickHandler = this.buttonClickHandler;
            render.buttonMouseOverHandler = this.buttonMouseOverOutHandler;
            addChild(render);
            render.visible = false;
            lastRenderWidth = render.width;
            lastRenderLeftX = render.x;
            lastRenderRightDownY = render.y + render.height;
         }
         this.mCurrentPage = 0;
         this.myPageListSelector.hasPrevPage = false;
         this.myPageListSelector.hasNextPage = false;
         this.myPageListSelector.x = (lastRenderWidth - this.myPageListSelector.width) * 0.5 + lastRenderLeftX + 15;
         this.myPageListSelector.y = lastRenderRightDownY + PAGE_SELECTOR_GAP;
         this.myPageListSelector.registerClickedHandler(this.onPageListSelectorClicked);
      }
      
      private function buttonClickHandler(data:Object, whichButtonClicked:int) : void
      {
         if(null == this.mSetting.itemClickHandler)
         {
            return;
         }
         this.mSetting.itemClickHandler(data,whichButtonClicked);
      }
      
      private function buttonMouseOverOutHandler(data:Object, whichBehaviour:int) : void
      {
         if(null == this.mSetting.itemInteractiveHandler)
         {
            return;
         }
         this.mSetting.itemInteractiveHandler(data,whichBehaviour);
      }
      
      public function refresh() : void
      {
         this.tryInvokeGoingRefreshEvent();
         this.mTotalPage = Math.ceil(this.mDataProvider.length / this.mSetting.itemCountPerPage);
         var theFirstItemIndex:int = this.mCurrentPage * this.mSetting.itemCountPerPage;
         if(theFirstItemIndex >= this.mDataProvider.length)
         {
            this.mCurrentPage = Math.ceil(this.mDataProvider.length / this.mSetting.itemCountPerPage) - 1;
            if(this.mCurrentPage < 0)
            {
               this.mCurrentPage = 0;
            }
            theFirstItemIndex = this.mCurrentPage * this.mSetting.itemCountPerPage;
         }
         var renderShowCount:int = 0;
         var i:int = theFirstItemIndex;
         while(renderShowCount < this.mSetting.itemCountPerPage && i < this.mDataProvider.length)
         {
            this.mRenderKeeper[renderShowCount].setData(this.mDataProvider[i]);
            this.tryInvokeDataSet(this.mDataProvider[i],this.mRenderKeeper[renderShowCount]);
            this.mRenderKeeper[renderShowCount].visible = true;
            i++;
            renderShowCount++;
         }
         for(i = renderShowCount; i < this.mSetting.itemCountPerPage; i++)
         {
            this.mRenderKeeper[i].visible = false;
         }
         this.refreshPageSelector();
      }
      
      private function refreshPageSelector() : void
      {
         this.myPageListSelector.visible = this.mTotalPage > 1;
         var needShowPageSelector:Boolean = this.mDataProvider.length > this.mSetting.itemCountPerPage;
         this.myPageListSelector.hasPrevPage = needShowPageSelector;
         this.myPageListSelector.hasNextPage = needShowPageSelector;
         if(needShowPageSelector)
         {
            this.myPageListSelector.hasPrevPage = this.mCurrentPage > 0;
            this.myPageListSelector.hasNextPage = this.mCurrentPage + 1 < this.mTotalPage;
         }
      }
      
      public function set dataProvider(value:Array) : void
      {
         this.mDataProvider = value;
         this.mDataCount = this.mDataProvider.length;
         this.refresh();
      }
      
      public function get dataProvider() : Array
      {
         return this.mDataProvider;
      }
      
      public function get currentPage() : int
      {
         return this.mCurrentPage;
      }
      
      public function set hasPrevBtn(value:Boolean) : void
      {
         this.myPageListSelector.hasPrevPage = value;
      }
      
      public function set hasNextBtn(value:Boolean) : void
      {
         this.myPageListSelector.hasNextPage = value;
      }
      
      public function get totalPage() : int
      {
         return this.mTotalPage;
      }
      
      public function prevPage() : void
      {
         if(this.mSetting.customPageSelectorHandler != null)
         {
            this.mSetting.customPageSelectorHandler(PageListSelector.PREV_BTN_INDEX);
            return;
         }
         if(this.mCurrentPage <= 0)
         {
            return;
         }
         --this.mCurrentPage;
         this.refresh();
      }
      
      public function nextPage() : void
      {
         if(this.mSetting.customPageSelectorHandler != null)
         {
            this.mSetting.customPageSelectorHandler(PageListSelector.NEXT_BTN_INDEX);
            return;
         }
         if(this.mCurrentPage * this.mSetting.itemCountPerPage >= this.mDataProvider.length)
         {
            return;
         }
         ++this.mCurrentPage;
         this.refresh();
      }
      
      private function onPageListSelectorClicked(selectorIndex:int) : void
      {
         if(selectorIndex == PageListSelector.NEXT_BTN_INDEX)
         {
            this.nextPage();
         }
         else if(selectorIndex == PageListSelector.PREV_BTN_INDEX)
         {
            this.prevPage();
         }
      }
      
      private function tryInvokeGoingRefreshEvent() : void
      {
         if(this.mSetting.onGoingToRefreshHandler is Function)
         {
            this.mSetting.onGoingToRefreshHandler();
         }
      }
      
      private function tryInvokeDataSet(data:Object, item:PageListBaseRender) : void
      {
         if(this.mSetting.onDataSetHandler is Function)
         {
            this.mSetting.onDataSetHandler(data,item);
         }
      }
   }
}

