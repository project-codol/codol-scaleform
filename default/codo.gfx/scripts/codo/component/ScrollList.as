package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.scrollgrid.parts.ScrollListNavArrow;
   import codo.cpp.IUiCppList;
   import codo.cpp.IUiCppListFocusable;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.interfaces.ISelectable;
   import codo.objects.ScrollListSettings;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class ScrollList extends MovieClip implements IUiCppList, IUiCppListMutable, IUiCppListFocusable
   {
      
      protected static const FLOOR:Function = Math.floor;
      
      private static const ITEM_HOLDER_OFFSET_X:Number = 4;
      
      public static const DEBUG_SCROLL:Boolean = false;
      
      public var myScrollBar:ScrollBar;
      
      public var myItemHolder:MovieClip;
      
      public var myHitArea:Sprite;
      
      public var myNavArrowRight:ScrollListNavArrow;
      
      public var myNavArrowLeft:ScrollListNavArrow;
      
      protected var mMaxVisibleItems:uint = 4;
      
      protected var mItems:Vector.<UIInteractiveComponent>;
      
      protected var mSettings:ScrollListSettings;
      
      protected var mWidth:Number = 0;
      
      protected var mHeight:Number = 0;
      
      private var mFocusChangeCallback:Function;
      
      private var mItemUnfocusedCallback:Function;
      
      private var mItemClickCallback:Function;
      
      private var mDoubleClickCallback:Function;
      
      private var mItemFooterClickCallback:Function;
      
      protected var mMask:Sprite;
      
      protected var _listData:Vector.<Object>;
      
      protected var _contentLength:Number;
      
      protected var _scrollByPage:Boolean;
      
      protected var _selectedIndex:uint = 4294967295;
      
      protected var _selectionChangeCallback:Function;
      
      protected var _allowNavArrow:Boolean = true;
      
      private var _uiCppData:Array;
      
      public function ScrollList()
      {
         super();
         this.settings = new ScrollListSettings();
         this._listData = new Vector.<Object>();
         this.mItems = new Vector.<UIInteractiveComponent>();
         this._scrollByPage = false;
         this.myNavArrowRight.setClickCallback(this.onNavArrowClick);
         this.myNavArrowLeft.setClickCallback(this.onNavArrowClick);
      }
      
      public function set listItemClickCallback(callback:Function) : void
      {
         this.mItemClickCallback = callback;
      }
      
      public function set listItemDoubleClickCallback(callback:Function) : void
      {
         this.mDoubleClickCallback = callback;
      }
      
      public function set listItemFooterClickCallback(callback:Function) : void
      {
         this.mItemFooterClickCallback = callback;
      }
      
      public function set listItemFocusCallback(callback:Function) : void
      {
         this.mFocusChangeCallback = callback;
      }
      
      public function set listItemUnfocusCallback(callback:Function) : void
      {
         this.mItemUnfocusedCallback = callback;
      }
      
      public function set selectionChangeCallback(callback:Function) : void
      {
         this._selectionChangeCallback = callback;
      }
      
      public function set settings(newSettings:ScrollListSettings) : void
      {
         this.mSettings = newSettings;
         var scrollBarSettings:Object = new Object();
         scrollBarSettings.hitArea = this;
         scrollBarSettings.scrollCallback = this.onScroll;
         this.myScrollBar.init(scrollBarSettings);
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
         {
            this.myScrollBar.rotation = 90;
            this.myNavArrowRight.rotation = 90;
            this.myNavArrowLeft.rotation = -90;
         }
         this.myNavArrowRight.setOrientRight();
         if(this.mMask == null && newSettings.useMask)
         {
            this.mMask = addChild(new Sprite()) as Sprite;
            this.mMask.mouseEnabled = false;
            if(!DEBUG_SCROLL)
            {
               this.myItemHolder.mask = this.mMask;
            }
         }
         else if(this.mMask != null && newSettings.useMask == false)
         {
            this.myItemHolder.mask = null;
            removeChild(this.mMask);
            this.mMask = null;
         }
      }
      
      public function get settings() : ScrollListSettings
      {
         return this.mSettings;
      }
      
      public function setScrollByPage(scrollByPage:Boolean) : void
      {
         this._scrollByPage = scrollByPage;
      }
      
      public function set maxVisibleItems(num:uint) : void
      {
         this.mMaxVisibleItems = num;
      }
      
      public function get listData() : Vector.<Object>
      {
         return this._listData;
      }
      
      public function get selectedData() : Object
      {
         if(this._selectedIndex < this._listData.length)
         {
            return this._listData[this._selectedIndex];
         }
         return null;
      }
      
      protected function onNavArrowClick(arrow:ScrollListNavArrow) : void
      {
         if(!arrow.enabled)
         {
            return;
         }
         this.doScroll(arrow == this.myNavArrowRight);
      }
      
      public function doScroll(forward:Boolean) : void
      {
         var delta:Number = 0.15;
         if(this._scrollByPage)
         {
            if(this._listData.length <= this.mMaxVisibleItems)
            {
               return;
            }
            delta = this.mMaxVisibleItems / (this._listData.length - this.mMaxVisibleItems);
         }
         var newPos:Number = this.myScrollBar.position + (forward ? delta : -delta);
         newPos = Math.max(0,Math.min(newPos,1));
         this.myScrollBar.setPosition(newPos,true);
      }
      
      public function resetIndex() : void
      {
         this._selectedIndex = uint.MAX_VALUE;
      }
      
      public function resetList() : void
      {
         this._listData.length = 0;
         this.resetIndex();
         this.resetItems();
         if(this.mSettings.autoSize)
         {
            this.mWidth = 0;
            this.mHeight = 0;
         }
         this._contentLength = 0;
      }
      
      protected function resetItems() : void
      {
         while(this.myItemHolder.numChildren > 0)
         {
            this.myItemHolder.removeChildAt(0);
         }
         this.mItems.length = 0;
         this.myScrollBar.setPosition(0,false);
      }
      
      protected function makeRenderer(itemLinkage:String) : UIInteractiveComponent
      {
         var item:UIInteractiveComponent = null;
         var cls:Class = null;
         if(itemLinkage != null)
         {
            cls = getDefinitionByName(itemLinkage) as Class;
            item = new cls() as UIInteractiveComponent;
         }
         else
         {
            item = this.mSettings.buildGridItemRenderMethod();
         }
         if(this.mFocusChangeCallback != null)
         {
            item.registerFocusEvent(this.onFocusChange,item);
         }
         if(this.mItemUnfocusedCallback != null)
         {
            item.registerUnfocusEvent(this.onItemUnfocused,item);
         }
         item.setClickCallback(this.onItemClick,this.mItems.length);
         this.myItemHolder.addChild(item);
         this.mItems.push(item);
         if(this.mItemClickCallback != null)
         {
            item.setClickCallback(this.mItemClickCallback);
         }
         if(this.mDoubleClickCallback != null)
         {
            item.setDoubleClickCallback(this.mDoubleClickCallback);
         }
         if(this.mItemFooterClickCallback != null)
         {
            item.clickFooterItemCallback = this.mItemFooterClickCallback;
         }
         return item;
      }
      
      public function getItem(index:uint) : UIInteractiveComponent
      {
         if(index < this.mItems.length)
         {
            return this.mItems[index];
         }
         return null;
      }
      
      public function get numberOfItems() : int
      {
         return this.mItems.length;
      }
      
      public function addItem(data:Object, itemLinkage:String = null) : UIInteractiveComponent
      {
         var item:UIInteractiveComponent = null;
         var numItems:int = 0;
         this._listData.push(data);
         item = this.makeRenderer(itemLinkage);
         item.setData(data);
         numItems = this.mItems.length - 1;
         var curPos:int = 0;
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_HORIZONTAL)
         {
            curPos = numItems > 0 ? int(this.mItems[numItems - 1].x + this.mItems[numItems - 1].width + this.mSettings.itemPadding) : 0;
            this._contentLength = curPos + item.width;
            if(numItems < this.mMaxVisibleItems && true == this.mSettings.autoSize)
            {
               this.mWidth = this._contentLength;
               if(numItems == 0)
               {
                  this.mHeight = item.height;
               }
            }
            item.x = item.initX = curPos;
         }
         else
         {
            curPos = numItems > 0 ? int(this.mItems[numItems - 1].y + this.mItems[numItems - 1].height + this.mSettings.itemPadding) : 0;
            this._contentLength = curPos + item.height;
            if(numItems < this.mMaxVisibleItems && true == this.mSettings.autoSize)
            {
               this.mHeight = this._contentLength;
               if(numItems == 0)
               {
                  this.mWidth = item.width;
               }
            }
            item.y = item.initY = curPos;
         }
         return item;
      }
      
      public function addItemsByVector(content:Vector.<Object>) : void
      {
         this.resetList();
         var len:uint = content.length;
         for(var i:uint = 0; i < len; )
         {
            this.addItem(content[i],this.mSettings.itemLinkage);
            i++;
         }
         this.refreshVisuals();
      }
      
      protected function onItemClick(index:uint) : void
      {
         this.selectedIndex = index;
      }
      
      public function getSelectedItem() : UIInteractiveComponent
      {
         if(this._selectedIndex < this.mItems.length)
         {
            return this.mItems[this._selectedIndex];
         }
         return null;
      }
      
      public function get selectedIndex() : uint
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(index:uint) : void
      {
         if(index == this._selectedIndex)
         {
            return;
         }
         var prev:ISelectable = this.getSelectedItem() as ISelectable;
         if(prev != null)
         {
            prev.selected = false;
         }
         this._selectedIndex = index;
         var item:ISelectable = this.getSelectedItem() as ISelectable;
         if(item != null)
         {
            item.selected = true;
         }
         if(this._selectionChangeCallback != null)
         {
            this._selectionChangeCallback();
         }
      }
      
      public function refreshVisuals() : void
      {
         var enableScrollBar:Boolean = false;
         var visibleScrollBar:Boolean = false;
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_HORIZONTAL)
         {
            enableScrollBar = this.mWidth < this._contentLength;
         }
         else if(this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
         {
            enableScrollBar = this.mHeight < this._contentLength;
         }
         visibleScrollBar = enableScrollBar && !this.settings.hideScrollBar;
         this.myScrollBar.visible = visibleScrollBar;
         this.myScrollBar.setEnabled(enableScrollBar);
         this.myHitArea.width = this.mWidth;
         this.myHitArea.height = this.mHeight;
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
         {
            this.myScrollBar.setBarLength(this.mHeight,this._contentLength);
         }
         if(false == this.mSettings.autoSize)
         {
            if(true == this.mSettings.autoSizeItems)
            {
               this.resizeListItems();
            }
            if(this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
            {
               this.myScrollBar.x = this.mWidth;
            }
            else
            {
               this.myScrollBar.x = this.myNavArrowLeft.x + this.myNavArrowLeft.width + ITEM_HOLDER_OFFSET_X;
            }
         }
         else if(this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
         {
            this.myScrollBar.x = this.mWidth + this.myScrollBar.height + this.mSettings.barOffsetX;
         }
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_HORIZONTAL)
         {
            this.myScrollBar.setBarLength(this.mWidth,this._contentLength);
            this.myScrollBar.y = this.mHeight + this.mSettings.barOffsetY;
            this.myItemHolder.x = this._allowNavArrow ? this.myNavArrowLeft.x + this.myNavArrowLeft.width + ITEM_HOLDER_OFFSET_X : 0;
            this.myNavArrowRight.x = this.myItemHolder.x + this.mWidth + ITEM_HOLDER_OFFSET_X + this.myNavArrowRight.width;
         }
         else
         {
            this.myScrollBar.y = 0;
            this.myItemHolder.x = 0;
            this.myItemHolder.y = 0;
         }
         if(this.mSettings.useMask)
         {
            this.buildListMask();
         }
         if(this._allowNavArrow && this.mSettings.useNavArrows && enableScrollBar)
         {
            this.myNavArrowLeft.visible = true;
            this.myNavArrowRight.visible = true;
         }
         else
         {
            this.myNavArrowLeft.visible = false;
            this.myNavArrowRight.visible = false;
         }
         this.checkEnableArrows(this.myScrollBar.position);
      }
      
      override public function get width() : Number
      {
         var scrollBarWidth:Number = 0;
         if(true == this.myScrollBar.visible)
         {
            scrollBarWidth = this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL ? this.myScrollBar.height : 0;
         }
         return this.mWidth + scrollBarWidth;
      }
      
      override public function get height() : Number
      {
         var scrollBarWidth:Number = 0;
         if(true == this.myScrollBar.visible)
         {
            scrollBarWidth = this.mSettings.orientation == ScrollListSettings.SCROLL_HORIZONTAL ? this.myScrollBar.width : 0;
         }
         return this.mHeight + scrollBarWidth;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
      }
      
      public function getContentLength() : Number
      {
         return this._contentLength;
      }
      
      protected function checkEnableArrows(pos:Number) : void
      {
         if(!this._allowNavArrow || !this.mSettings.useNavArrows)
         {
            return;
         }
         var ALPHA_DISABLED:Number = 0.6;
         var floatErrTolerance:Number = 0.001;
         this.myNavArrowRight.enabled = pos < 1 - floatErrTolerance;
         this.myNavArrowRight.alpha = this.myNavArrowRight.enabled ? 1 : ALPHA_DISABLED;
         this.myNavArrowLeft.enabled = pos > 0 + floatErrTolerance;
         this.myNavArrowLeft.alpha = this.myNavArrowLeft.enabled ? 1 : ALPHA_DISABLED;
      }
      
      protected function onScroll(position:Number) : void
      {
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_HORIZONTAL)
         {
            this.myItemHolder.x = FLOOR(-(this._contentLength - this.mWidth) * position) + this.myNavArrowLeft.width + ITEM_HOLDER_OFFSET_X;
         }
         else
         {
            this.myItemHolder.y = FLOOR(-(this._contentLength - this.mHeight) * position);
         }
         this.checkEnableArrows(this.myScrollBar.position);
      }
      
      private function buildListMask() : void
      {
         if(this.mItems.length < 1)
         {
            return;
         }
         var renderer:UIInteractiveComponent = this.mItems[0];
         var offsetWidth:Number = 0;
         var offsetHeight:Number = 0;
         var offsetX:Number = 0;
         var rendererOffsetWidth:Number = 0;
         var rendererOffsetHeight:Number = 0;
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_VERTICAL)
         {
            offsetWidth = rendererOffsetWidth * 2 + renderer.width;
            offsetHeight = rendererOffsetHeight * 2;
         }
         else
         {
            offsetWidth = rendererOffsetWidth * 2;
            offsetHeight = rendererOffsetHeight * 2 + renderer.height;
            offsetX = this._allowNavArrow ? this.myNavArrowLeft.width + ITEM_HOLDER_OFFSET_X : 0;
         }
         this.mMask.graphics.clear();
         this.mMask.graphics.beginFill(0,0.5);
         this.mMask.graphics.drawRect(-rendererOffsetWidth + offsetX,-rendererOffsetHeight,this.mWidth + offsetWidth,this.mHeight + offsetHeight);
         this.mMask.graphics.endFill();
      }
      
      private function resizeListItems() : void
      {
         var item:UIInteractiveComponent = null;
         var height:Number = NaN;
         var width:Number = NaN;
         if(this.mSettings.orientation == ScrollListSettings.SCROLL_HORIZONTAL)
         {
            height = true == this.myScrollBar.visible ? this.mHeight - this.myScrollBar.height : this.mHeight;
            for each(item in this.mItems)
            {
               item.height = height;
            }
         }
         else
         {
            width = true == this.myScrollBar.visible ? this.mWidth - this.myScrollBar.height : this.mWidth;
            for each(item in this.mItems)
            {
               item.width = width;
            }
         }
      }
      
      protected function onFocusChange(item:UIInteractiveComponent) : void
      {
         this.mFocusChangeCallback(item.getData());
      }
      
      protected function onItemUnfocused(item:UIInteractiveComponent) : void
      {
         this.mItemUnfocusedCallback(item.getData());
      }
      
      public function uiCppGetListData() : Array
      {
         return this._uiCppData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         this.mItemClickCallback = function(data:*):void
         {
            uiCpp[func]();
         };
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this._uiCppData = data;
         this.addItemsByVector(Vector.<Object>(data));
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
         this.selectedIndex = index;
      }
      
      public function uiCppInitFocusEvent(uiCpp:UiCpp, func:String) : void
      {
         this.mFocusChangeCallback = function(data:*):void
         {
            var idx:uint = _listData.indexOf(data);
            uiCpp[func](true,idx);
         };
         this.mItemUnfocusedCallback = function(data:*):void
         {
            uiCpp[func](false);
         };
      }
   }
}

