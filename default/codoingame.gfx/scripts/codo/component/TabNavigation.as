package codo.component
{
   import codo.component.factory.ButtonFactory;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class TabNavigation extends MovieClip
   {
      
      public var myTabMount:MovieClip;
      
      private var mItemLinkage:String = ButtonFactory.GENERIC_BUTTON_LINKAGE;
      
      private var mOnTabClickedCallback:Function;
      
      private var mCurrentTab:Button;
      
      private var mTabPadding:int = GlobalGuide.COMPONENT_PADDING;
      
      private var mTabs:Vector.<Button>;
      
      private var mCurrentTabIndex:int;
      
      private var mTabWidth:Number = 0;
      
      protected var _tabsData:Array;
      
      public function TabNavigation()
      {
         super();
      }
      
      public function setData(data:Object) : void
      {
         var tab:Button = null;
         var tabData:Object = null;
         this.clearTabs();
         if(null != data.tabLinkage)
         {
            this.mItemLinkage = data.tabLinkage;
         }
         if(null != data.tabClickedCallback)
         {
            this.mOnTabClickedCallback = data.tabClickedCallback;
         }
         if(null != data.tabPadding)
         {
            this.mTabPadding = data.tabPadding;
         }
         if(null != data.tabWidth)
         {
            this.mTabWidth = data.tabWidth;
         }
         else
         {
            this.mTabWidth = 0;
         }
         this._tabsData = data.tabs;
         var cls:Class = getDefinitionByName(this.mItemLinkage) as Class;
         var len:int = int(this._tabsData.length);
         var curX:int = 0;
         for(var i:int = 0; i < len; i++)
         {
            tab = new cls() as Button;
            tabData = this._tabsData[i];
            tab.labelFocusColor = GlobalGuide.WHITE;
            if(data.textStyle != null)
            {
               tab.myLabel.textStyle = data.textStyle;
            }
            if(Boolean(data.truncateText))
            {
               tab.myLabel.enableTruncate(true);
            }
            tab.setData(tabData);
            tab.registerClickEvent(this.onTabClicked,i);
            tab.registerFocusEvent(this.onTabFocused,i);
            tab.registerUnfocusEvent(this.onTabUnfocused,i);
            tab.setToggled(false);
            tab.x = curX;
            this.myTabMount.addChild(tab);
            if(this.mTabWidth > 0)
            {
               tab.width = this.mTabWidth;
            }
            curX += tab.width + this.mTabPadding;
            this.mTabs.push(tab);
         }
         this.mCurrentTabIndex = 0;
         this.mCurrentTab = this.mTabs[this.mCurrentTabIndex] as Button;
         this.mCurrentTab.setToggled(true);
         this.myTabMount.setChildIndex(this.mCurrentTab,this.myTabMount.numChildren - 1);
      }
      
      public function SetSelectedIndexById(id:int) : void
      {
         var length:int = int(this.mTabs.length);
         for(var i:int = 0; i < length; i++)
         {
            if(id == this.mTabs[i].getData().id)
            {
               this.onTabClicked(i);
               return;
            }
         }
      }
      
      public function SetSelectedIndex(index:int) : void
      {
         this.onTabClicked(index);
      }
      
      public function getTabsData() : Array
      {
         return this._tabsData;
      }
      
      public function get currentTabIndex() : int
      {
         return this.mCurrentTabIndex;
      }
      
      public function get currentTabId() : int
      {
         return this.mCurrentTab.getData().id;
      }
      
      public function get tabs() : Vector.<Button>
      {
         return this.mTabs;
      }
      
      public function getTabByIndex(index:int) : Button
      {
         return this.mTabs[index];
      }
      
      public function getTabById(id:int) : Button
      {
         var length:int = int(this.mTabs.length);
         for(var i:int = 0; i < length; i++)
         {
            if(id == this.mTabs[i].getData().id)
            {
               return this.mTabs[i];
            }
         }
         return null;
      }
      
      private function onTabClicked(tabIndex:int) : void
      {
         if(null != this.mOnTabClickedCallback)
         {
            if(tabIndex == this.mCurrentTabIndex)
            {
               return;
            }
            this.mCurrentTab.setToggled(false);
            this.mCurrentTab = this.mTabs[tabIndex];
            this.mCurrentTabIndex = tabIndex;
            this.mCurrentTab.setToggled(true);
            this.myTabMount.setChildIndex(this.mCurrentTab,this.myTabMount.numChildren - 1);
            this.mOnTabClickedCallback(tabIndex);
         }
      }
      
      private function onTabFocused(tabIndex:int) : void
      {
         var tab:Button = this.mTabs[tabIndex];
         this.myTabMount.setChildIndex(tab,this.myTabMount.numChildren - 1);
      }
      
      private function onTabUnfocused(tabIndex:int) : void
      {
         this.myTabMount.setChildIndex(this.mCurrentTab,this.myTabMount.numChildren - 1);
      }
      
      private function clearTabs() : void
      {
         while(this.myTabMount.numChildren > 0)
         {
            this.myTabMount.removeChildAt(0);
         }
         this.mCurrentTab = null;
         this.mTabs = new Vector.<Button>();
      }
   }
}

