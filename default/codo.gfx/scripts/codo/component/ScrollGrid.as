package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   
   public class ScrollGrid extends ScrollList
   {
      
      private static const MIN_FRAME_HEIGHT:Number = 250;
      
      protected static const IDX_NULL:int = -1;
      
      protected static const HEADER_SPACING:Number = 10;
      
      protected var _columns:uint;
      
      protected var _rowsOrHeight:uint;
      
      protected var _calcHeightFromRows:Boolean;
      
      protected var _dataStartIdx:int;
      
      protected var _itemWidth:uint;
      
      protected var _itemHeight:uint;
      
      protected var _itemDataIndices:Vector.<int>;
      
      protected var _itemRects:Vector.<Rectangle>;
      
      protected var _headers:Vector.<ScrollListHeaderObj>;
      
      protected var _headerClips:Vector.<ListHeaderToggle>;
      
      protected var _headersOpened:Vector.<Boolean>;
      
      protected var _frame:Sprite;
      
      protected var _frameHeightOffset:Number;
      
      protected var _frameMinHeight:Number;
      
      public function ScrollGrid()
      {
         super();
         this._itemDataIndices = new Vector.<int>();
         this._itemRects = new Vector.<Rectangle>(0);
         this._headers = new Vector.<ScrollListHeaderObj>(0);
         this._headerClips = new Vector.<ListHeaderToggle>(0);
         this._headersOpened = new Vector.<Boolean>(0);
         maxVisibleItems = 0;
         _allowNavArrow = false;
      }
      
      public function setHeaders(headers:Vector.<ScrollListHeaderObj>) : void
      {
         this._headers = headers;
      }
      
      override public function addItem(data:Object, itemLinkage:String = null) : UIInteractiveComponent
      {
         return makeRenderer(itemLinkage);
      }
      
      override public function addItemsByVector(content:Vector.<Object>) : void
      {
         var i:int = 0;
         var visibleRows:uint = 0;
         CFunctionCommonContainer.Assert(this._rowsOrHeight > 0 && this._columns > 0,new Error("Grid un-inited"));
         var oldDataLen:uint = _listData.length;
         var oldContentLen:Number = _contentLength;
         this.resetList();
         var len:uint = content.length;
         for(i = 0; i < len; i++)
         {
            _listData.push(content[i]);
         }
         var tempItem:UIInteractiveComponent = mItems.length > 0 ? mItems[0] : makeRenderer(mSettings.itemLinkage);
         this._itemWidth = Math.round(tempItem.width);
         this._itemHeight = Math.round(tempItem.height);
         if(this._calcHeightFromRows)
         {
            visibleRows = this._rowsOrHeight;
         }
         else
         {
            mHeight = this._rowsOrHeight;
            visibleRows = Math.ceil(mHeight / (this._itemHeight + settings.itemPadding));
         }
         var neededRenderers:int = this._columns * (visibleRows + 1);
         neededRenderers = Math.min(neededRenderers,len);
         while(mItems.length > neededRenderers)
         {
            myItemHolder.removeChild(mItems.pop());
         }
         while(mItems.length < neededRenderers)
         {
            this.addItem(null,mSettings.itemLinkage);
         }
         if(mItems.length > 0)
         {
            mWidth = this._itemWidth * this._columns + settings.itemPadding * (this._columns - 1);
            if(this._calcHeightFromRows)
            {
               mHeight = this._itemHeight * visibleRows + settings.itemPadding * (visibleRows - 1);
            }
         }
         this._itemRects.length = _listData.length;
         this.layoutItems();
         this.layoutFrame();
         if(oldDataLen != _listData.length || oldContentLen != _contentLength)
         {
            myScrollBar.setPosition(0,false);
         }
         this.onScroll(myScrollBar.position);
      }
      
      protected function layoutFrame() : void
      {
         if(this._frame != null)
         {
            this._frame.height = Math.min(_contentLength,mHeight) + this._frameHeightOffset;
            this._frame.height = Math.max(this._frame.height,this._frameMinHeight);
         }
      }
      
      protected function layoutItems() : void
      {
         var i:int = 0;
         var header:ListHeaderToggle = null;
         var col:int = 0;
         var headerIdx:int = 0;
         var headerData:ScrollListHeaderObj = null;
         var row:int = 0;
         var len:uint = _listData.length;
         var posX:Number = 0;
         var posY:Number = 0;
         this._dataStartIdx = IDX_NULL;
         this._itemDataIndices.length = 0;
         _contentLength = 0;
         for(i = 0; i < mItems.length; i++)
         {
            this._itemDataIndices.push(_listData.length);
            this.setItemData(i,null);
         }
         if(mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
         {
            col = 0;
            headerIdx = 0;
            for(i = 0; i < len; i++)
            {
               if(headerIdx < this._headers.length)
               {
                  headerData = this._headers[headerIdx];
                  if(headerData.beforeIndex == i)
                  {
                     header = this.initHeader(headerIdx,headerData);
                     headerIdx++;
                     if(col != 0)
                     {
                        posY += this._itemHeight + settings.itemPadding;
                        posX = 0;
                        col = 0;
                     }
                     if(i > 0)
                     {
                        posY += HEADER_SPACING - settings.itemPadding;
                     }
                     header.y = posY;
                     _contentLength = header.y + header.height;
                     posY = _contentLength + HEADER_SPACING;
                  }
               }
               if(header != null && !header.toggled)
               {
                  this._itemRects[i] = null;
               }
               else
               {
                  this._itemRects[i] = new Rectangle(posX,posY,this._itemWidth,this._itemHeight);
                  _contentLength = this._itemRects[i].bottom;
                  posX += this._itemWidth + settings.itemPadding;
                  col++;
                  if(col == this._columns)
                  {
                     col = 0;
                     posX = 0;
                     posY += this._itemHeight + settings.itemPadding;
                  }
               }
            }
         }
         else
         {
            row = 0;
            for(i = 0; i < len; i++)
            {
               this._itemRects[i] = new Rectangle(posX,posY,this._itemWidth,this._itemHeight);
               _contentLength = this._itemRects[i].right;
               posY += this._itemHeight + settings.itemPadding;
               row++;
               if(row == this._rowsOrHeight)
               {
                  row = 0;
                  posX += this._itemWidth + settings.itemPadding;
                  posY = 0;
               }
            }
         }
         refreshVisuals();
      }
      
      protected function initHeader(index:uint, headerData:ScrollListHeaderObj) : ListHeaderToggle
      {
         var cls:Class = null;
         var header:ListHeaderToggle = null;
         if(index >= this._headerClips.length)
         {
            cls = getDefinitionByName(headerData.classLinkage) as Class;
            header = new cls() as ListHeaderToggle;
            header.toggled = this._headersOpened[index];
            header.registerClickEvent(this.onHeaderClick,index);
            myItemHolder.addChild(header);
            this._headerClips.push(header);
            header.setData(headerData);
            header.width = mWidth;
         }
         return this._headerClips[index];
      }
      
      override public function resetList() : void
      {
         var header:ListHeaderToggle = null;
         var i:int = 0;
         super.resetList();
         this._itemWidth = 1;
         this._itemHeight = 1;
         for each(header in this._headerClips)
         {
            myItemHolder.removeChild(header);
         }
         this._headerClips.length = 0;
         if(this._headersOpened.length != this._headers.length)
         {
            this._headersOpened.length = this._headers.length;
            for(i = 0; i < this._headers.length; i++)
            {
               this._headersOpened[i] = true;
            }
         }
      }
      
      override protected function resetItems() : void
      {
      }
      
      public function initGrid(newSettings:ScrollListSettings, rowsOrHeight:uint, prevArgIsHeight:Boolean, cols:uint) : void
      {
         if(mSettings != null)
         {
            if(mSettings.buildGridItemRenderMethod != newSettings.buildGridItemRenderMethod || mSettings.itemLinkage != newSettings.itemLinkage)
            {
               super.resetItems();
            }
         }
         settings = newSettings;
         this._rowsOrHeight = rowsOrHeight;
         this._calcHeightFromRows = !prevArgIsHeight;
         this._columns = cols;
      }
      
      override protected function onScroll(position:Number) : void
      {
         var dataStartIdx:int = 0;
         var i:int = 0;
         var curData:Object = null;
         var itemIdx:int = 0;
         var itemRect:Rectangle = null;
         var item:UIInteractiveComponent = null;
         super.onScroll(position);
         var maskRect:Rectangle = new Rectangle(mMask.x - myItemHolder.x,mMask.y - myItemHolder.y,mMask.width,mMask.height);
         for(i = 0; i < this._itemRects.length; i++)
         {
            if(this._itemRects[i] != null && maskRect.intersects(this._itemRects[i]))
            {
               dataStartIdx = i;
               break;
            }
         }
         if(this._dataStartIdx == dataStartIdx)
         {
            return;
         }
         this._dataStartIdx = dataStartIdx;
         var dataIdx:int = dataStartIdx;
         for(i = 0; i < mItems.length; i++)
         {
            while(dataIdx < _listData.length && this._itemRects[dataIdx] == null)
            {
               dataIdx++;
            }
            curData = null;
            if(dataIdx < _listData.length)
            {
               curData = _listData[dataIdx];
            }
            itemIdx = (dataStartIdx + i) % mItems.length;
            if(this._itemDataIndices[itemIdx] != dataIdx)
            {
               this._itemDataIndices[itemIdx] = dataIdx;
               this.setItemData(itemIdx,curData);
               if(dataIdx < this._itemRects.length)
               {
                  itemRect = this._itemRects[dataIdx];
                  item = mItems[itemIdx];
                  item.x = itemRect.x;
                  item.y = itemRect.y;
                  if(item is ISelectable)
                  {
                     (item as ISelectable).selected = _selectedIndex == dataIdx;
                  }
               }
            }
            if(dataIdx < _listData.length)
            {
               dataIdx++;
            }
         }
      }
      
      protected function setItemData(index:uint, data:Object) : UIInteractiveComponent
      {
         var item:UIInteractiveComponent = null;
         item = mItems[index];
         item.visible = data != null;
         item.setData(data);
         return item;
      }
      
      override protected function onItemClick(index:uint) : void
      {
         selectedIndex = this._itemDataIndices[index];
      }
      
      override public function getSelectedItem() : UIInteractiveComponent
      {
         if(_selectedIndex < _listData.length)
         {
            return mItems[_selectedIndex % mItems.length];
         }
         return null;
      }
      
      protected function onHeaderClick(index:uint) : void
      {
         this._headersOpened[index] = this._headerClips[index].toggled;
         this.layoutItems();
         var scrollPos:Number = 0;
         if(myScrollBar.getEnabled())
         {
            scrollPos = this._headerClips[index].y / _contentLength;
         }
         myScrollBar.setPosition(scrollPos,false);
         this.onScroll(myScrollBar.position);
         this.layoutFrame();
      }
      
      public function resetHeaderStates() : void
      {
         this._headersOpened.length = 0;
      }
      
      public function setFrame(frame:Sprite, heightOffset:Number, minHeight:Number = NaN) : void
      {
         this._frame = frame;
         this._frameHeightOffset = heightOffset;
         this._frameMinHeight = isNaN(minHeight) ? MIN_FRAME_HEIGHT : minHeight;
      }
   }
}

