package codo.component
{
   import codo.component.factory.ButtonFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.component.object.NavigationObj;
   import codo.cpp.IUiCppListFilter;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppListFilter;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabbedScrollList extends Sprite implements IUiCppListFilter, IUiCppListMutable
   {
      
      private static const BACKGROUND_MARGIN:Number = 70;
      
      public var myScrollList:ScrollList;
      
      public var myButtonPanelHolder:Sprite;
      
      public var myBackground:MovieClip;
      
      private var mCurrentTabIndex:uint = 0;
      
      private var mTabButtons:Vector.<ScrollListTabButton>;
      
      private var mScrollItems:Vector.<MarketplaceItem>;
      
      private var mClickCallback:Function;
      
      protected var _uiCpp:UiCppListFilter;
      
      protected var _uiCppData:Array;
      
      protected var _uiCppCallback:Function;
      
      public function TabbedScrollList()
      {
         super();
         this.mTabButtons = new Vector.<ScrollListTabButton>(0);
         this.mScrollItems = new Vector.<MarketplaceItem>(0);
      }
      
      override public function get width() : Number
      {
         return this.myScrollList.width;
      }
      
      override public function get height() : Number
      {
         return this.myScrollList.height;
      }
      
      public function set tabButtons(tabs:Vector.<NavigationObj>) : void
      {
         var oldTab:ScrollListTabButton = null;
         var btn:ScrollListTabButton = null;
         var prevBtn:ScrollListTabButton = null;
         var tabData:NavigationObj = null;
         var totalWidth:Number = NaN;
         for each(oldTab in this.mTabButtons)
         {
            this.myButtonPanelHolder.removeChild(oldTab);
         }
         this.mTabButtons.length = 0;
         if(this.mCurrentTabIndex >= tabs.length)
         {
            this.mCurrentTabIndex = 0;
         }
         var i:uint = 0;
         var len:uint = tabs.length;
         for(totalWidth = 0; i < len; )
         {
            tabData = tabs[i];
            btn = ButtonFactory.BUILD_SCROLL_LIST_TAB_BUTTON(tabData.label);
            this.myButtonPanelHolder.addChild(btn);
            this.mTabButtons[i] = btn;
            btn.setData(tabData);
            btn.setClickCallback(this.onTabButtonClick);
            if(i > 0)
            {
               prevBtn = this.mTabButtons[i - 1];
               btn.x = prevBtn.x + prevBtn.width + 5;
            }
            totalWidth += btn.width;
            i++;
         }
         this.myBackground.visible = len > 0;
         this.myBackground.width = totalWidth + BACKGROUND_MARGIN;
         if(this.mCurrentTabIndex < this.mTabButtons.length)
         {
            this.mTabButtons[this.mCurrentTabIndex].enabled = false;
         }
      }
      
      private function onTabButtonClick(tabClicked:ScrollListTabButton) : void
      {
         if(this.mCurrentTabIndex == tabClicked.index)
         {
            return;
         }
         this.mTabButtons[this.mCurrentTabIndex].enabled = true;
         this.mCurrentTabIndex = tabClicked.index;
         this.mTabButtons[this.mCurrentTabIndex].enabled = false;
         if(this.mClickCallback != null)
         {
            this.mClickCallback(this.mCurrentTabIndex);
         }
         if(this._uiCppCallback != null)
         {
            this._uiCppCallback();
         }
      }
      
      public function set itemData(itemData:Vector.<Object>) : void
      {
         this.myScrollList.addItemsByVector(itemData);
      }
      
      public function set scrollListTabClickCallback(callback:Function) : void
      {
         this.mClickCallback = callback;
      }
      
      public function getTabIdx() : int
      {
         return this.mCurrentTabIndex;
      }
      
      public function setTabIdx(idx:int) : void
      {
         this.mCurrentTabIndex = idx;
      }
      
      public function getNumTabs() : uint
      {
         return this.mTabButtons.length;
      }
      
      public function makeUiCpp() : void
      {
         this._uiCpp = new UiCppListFilter(this);
      }
      
      public function getUiCpp() : UiCppListFilter
      {
         return this._uiCpp;
      }
      
      public function uiCppGetListData() : Array
      {
         return this._uiCppData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return 0;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this._uiCppData = data;
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
      }
      
      public function uiCppSetSelectableFilters(selectableFilters:Array) : void
      {
         var tabData:NavigationObj = null;
         var tabs:Vector.<NavigationObj> = new Vector.<NavigationObj>(0);
         var children:Array = this._uiCppData[this.uiCppGetSelectedIndex()].child;
         for(var i:int = 0; i < selectableFilters.length; i++)
         {
            if(Boolean(selectableFilters[i]))
            {
               tabData = new NavigationObj(tabs.length,children[i].label);
               tabData.dataIdx = i;
               tabs.push(tabData);
            }
         }
         this.tabButtons = tabs;
      }
      
      public function uiCppGetFilterStates() : Array
      {
         var selected:NavigationObj = null;
         var children:Array = this._uiCppData[this.uiCppGetSelectedIndex()].child;
         var states:Array = [];
         for(var i:int = 0; i < children.length; i++)
         {
            states[i] = false;
         }
         if(this.mCurrentTabIndex < this.mTabButtons.length)
         {
            selected = this.mTabButtons[this.mCurrentTabIndex].getData();
            states[selected.dataIdx] = true;
         }
         return states;
      }
      
      public function uiCppSetFilterStates(states:Array) : void
      {
      }
      
      public function uiCppInitFilterChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this._uiCppCallback = function():void
         {
            uiCpp[func]();
         };
      }
   }
}

