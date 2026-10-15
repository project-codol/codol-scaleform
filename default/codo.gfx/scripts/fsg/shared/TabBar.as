package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class TabBar extends MovieClip implements IDisposable
   {
      
      protected var m_tabBar:BehaviourTabBar;
      
      protected var m_offset:Point;
      
      protected var m_gap:int;
      
      private var m_autoSizeTabs:Boolean;
      
      private var m_initialTabIndex:uint;
      
      public function TabBar()
      {
         super();
         this.m_tabBar = new BehaviourTabBar();
         this.m_offset = new Point(0,0);
         this.m_gap = 0;
         this.m_autoSizeTabs = false;
         this.m_initialTabIndex = 0;
         this.clearTabs();
      }
      
      public function dispose() : void
      {
         this.clearTabs();
         this.m_tabBar.dispose();
      }
      
      public function set tabStatesChangedCallback(callback:Function) : void
      {
         this.m_tabBar.tabStatesChangedCallback = callback;
      }
      
      public function set tabMouseOverCallback(callback:Function) : void
      {
         this.m_tabBar.tabMouseOverCallback = callback;
      }
      
      public function set tabMouseOutCallback(callback:Function) : void
      {
         this.m_tabBar.tabMouseOutCallback = callback;
      }
      
      protected function getTabClass() : Class
      {
         return getDefinitionByName(getQualifiedClassName(this.m_tabBar.getTab(0))) as Class;
      }
      
      [Inspectable(defaultValue="false")]
      public function set autoSizeTabs(value:Boolean) : void
      {
         this.m_autoSizeTabs = value;
      }
      
      public function get autoSizeTabs() : Boolean
      {
         return this.m_autoSizeTabs;
      }
      
      [Inspectable(name="X Offset",defaultValue="0")]
      public function set xOffset(value:int) : void
      {
         this.m_offset.x = value;
      }
      
      [Inspectable(name="Y Offset",defaultValue="0")]
      public function set yOffset(value:int) : void
      {
         this.m_offset.y = value;
      }
      
      [Inspectable(defaultValue="0")]
      public function set gap(value:int) : void
      {
         this.m_gap = value;
      }
      
      public function get offset() : Point
      {
         return this.m_offset;
      }
      
      [Inspectable(defaultValue="0")]
      public function set initialTabIndex(value:uint) : void
      {
         this.m_initialTabIndex = value;
      }
      
      public function set selectedTabIndex(value:uint) : void
      {
         this.m_tabBar.selectedTabIndex = value;
      }
      
      public function get selectedTabIndex() : uint
      {
         return this.m_tabBar.selectedTabIndex;
      }
      
      public function get numTabs() : uint
      {
         return this.m_tabBar.length;
      }
      
      public function setup() : void
      {
         this.refreshView();
         this.m_tabBar.selectedTabIndex = this.m_initialTabIndex;
      }
      
      public function addTabs(tabDP:Array) : void
      {
         var tabMC:TabBase = null;
         var child:DisplayObject = null;
         var cls:Class = null;
         if(tabDP == null || tabDP.length <= 0)
         {
            return;
         }
         var tabX:Number = this.m_offset.x;
         this.clearTabs();
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child is TabBase)
            {
               tabMC = child as TabBase;
               tabMC.visible = childIndex < tabDP.length;
               if(tabMC.visible)
               {
                  this.showTab(tabMC,tabDP[childIndex].label || tabDP[childIndex].name,tabX);
                  tabX += tabMC.myHitArea.width;
                  tabX += this.m_gap;
               }
            }
         }
         if(this.m_tabBar.length > 0 && this.m_tabBar.length < tabDP.length)
         {
            cls = this.getTabClass();
            for(childIndex = this.m_tabBar.length; childIndex < tabDP.length; childIndex++)
            {
               tabMC = new cls();
               if(Boolean(tabMC))
               {
                  addChild(tabMC);
                  this.showTab(tabMC,tabDP[childIndex].label || tabDP[childIndex].name,tabX);
                  tabX += tabMC.myHitArea.width;
                  tabX += this.m_gap;
               }
            }
         }
      }
      
      public function addTab(text:String) : TabBase
      {
         var tabMC:TabBase = null;
         var tabX:Number = this.m_offset.x;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            tabMC = getChildAt(childIndex) as TabBase;
            if(Boolean(tabMC))
            {
               if(tabMC.populated == false)
               {
                  this.showTab(tabMC,text,tabX);
                  return tabMC;
               }
               tabX += tabMC.myHitArea.width;
               tabX += this.m_gap;
            }
         }
         var cls:Class = this.getTabClass();
         var newTabMC:TabBase = new cls();
         if(Boolean(newTabMC))
         {
            addChild(newTabMC);
            this.showTab(newTabMC,text,tabX);
            tabX += newTabMC.myHitArea.width;
            tabX += this.m_gap;
         }
         return newTabMC;
      }
      
      public function addTabWithColumn(text:String, newLine:Boolean = false) : TabBase
      {
         var child:DisplayObject = null;
         var tabMC:TabBase = null;
         var tabX:Number = this.m_offset.x;
         var tabY:Number = this.m_offset.y;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child is TabBase)
            {
               tabMC = getChildAt(childIndex) as TabBase;
               if(tabMC.populated == false)
               {
                  if(newLine == true && childIndex != 0)
                  {
                     tabY += tabMC.myHitArea.height;
                     tabY += this.m_gap;
                     tabX = 0;
                  }
                  this.showTab(tabMC,text,tabX,tabY);
                  return tabMC;
               }
               tabX = tabMC.x;
               tabX += tabMC.myHitArea.width;
               tabX += this.m_gap;
               tabY = tabMC.y;
            }
         }
         return null;
      }
      
      public function unhideAllTabs() : void
      {
         var child:DisplayObject = null;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child != null)
            {
               child.visible = true;
            }
         }
         this.refreshView();
      }
      
      public function hideAllTabs() : void
      {
         var child:DisplayObject = null;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child != null)
            {
               child.visible = false;
            }
         }
      }
      
      public function hideTab(uIndex:int) : void
      {
         var child:DisplayObject = this.getTab(uIndex);
         if(child != null)
         {
            child.visible = false;
         }
      }
      
      public function unhideTab(uIndex:int) : void
      {
         var child:DisplayObject = this.getTab(uIndex);
         if(child != null)
         {
            child.visible = true;
         }
      }
      
      public function setTabEnabled(uIndex:int, enabled:Boolean) : void
      {
         this.m_tabBar.setEnabled(uIndex,enabled);
      }
      
      public function clearTabs() : void
      {
         var child:DisplayObject = null;
         var tab:TabBase = null;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child is TabBase)
            {
               child.visible = false;
               tab = child as TabBase;
               tab.populated = false;
               tab.ForceUnselect();
            }
         }
         this.m_tabBar.clear();
      }
      
      public function refreshView() : void
      {
         var child:DisplayObject = null;
         var tabMC:TabBase = null;
         var tabX:Number = this.m_offset.x;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child is TabBase)
            {
               tabMC = child as TabBase;
               tabMC.x = tabX;
               if(tabMC.visible)
               {
                  tabX += tabMC.myHitArea.width;
                  tabX += this.m_gap;
               }
            }
         }
      }
      
      protected function showTab(tabMC:TabBase, label:String, x:Number = 0, y:Number = 0) : void
      {
         if(Boolean(tabMC))
         {
            tabMC.visible = true;
            tabMC.populated = true;
            tabMC.x = x;
            tabMC.y = y;
            tabMC.tabTitle = label;
            tabMC.autoSize = this.m_autoSizeTabs;
            this.m_tabBar.push(tabMC);
         }
      }
      
      private function getTabIndex(cTabMC:MovieClip) : uint
      {
         var child:DisplayObject = null;
         var tabIndex:uint = 0;
         for(var childIndex:uint = 0; childIndex < numChildren; childIndex++)
         {
            child = getChildAt(childIndex);
            if(child is TabBase)
            {
               if(child == cTabMC)
               {
                  return tabIndex;
               }
               tabIndex++;
            }
         }
         return uint.MAX_VALUE;
      }
      
      public function getTab(uIndex:uint) : MovieClip
      {
         return this.m_tabBar.getTab(uIndex);
      }
   }
}

