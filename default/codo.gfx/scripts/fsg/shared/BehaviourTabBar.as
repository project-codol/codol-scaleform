package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.MovieClip;
   
   public class BehaviourTabBar implements IDisposable
   {
      
      private var m_tabs:Vector.<TabBase>;
      
      private var m_hoverTabIndex:uint;
      
      private var m_selectedTabIndex:uint;
      
      private var m_tabMouseOverCallback:Function;
      
      private var m_tabMouseOutCallback:Function;
      
      private var m_tabStatesChangedCallback:Function;
      
      public function BehaviourTabBar()
      {
         super();
         this.m_tabs = new Vector.<TabBase>();
         this.m_hoverTabIndex = uint.MAX_VALUE;
         this.m_selectedTabIndex = uint.MAX_VALUE;
      }
      
      public function dispose() : void
      {
         this.clear();
         this.m_tabMouseOverCallback = null;
         this.m_tabMouseOutCallback = null;
         this.m_tabStatesChangedCallback = null;
      }
      
      public function set tabMouseOverCallback(callback:Function) : void
      {
         this.m_tabMouseOverCallback = callback;
      }
      
      public function set tabMouseOutCallback(callback:Function) : void
      {
         this.m_tabMouseOutCallback = callback;
      }
      
      public function set tabStatesChangedCallback(callback:Function) : void
      {
         this.m_tabStatesChangedCallback = callback;
      }
      
      public function set hoverTabIndex(value:uint) : void
      {
         this.m_hoverTabIndex = value;
         if(this.m_tabStatesChangedCallback != null)
         {
            this.m_tabStatesChangedCallback();
         }
      }
      
      public function set selectedTabIndex(value:uint) : void
      {
         var prevTabIndex:uint = 0;
         if(value < this.m_tabs.length && value != this.m_selectedTabIndex)
         {
            prevTabIndex = this.m_selectedTabIndex;
            this.m_selectedTabIndex = value;
            if(prevTabIndex < this.m_tabs.length)
            {
               this.setEnabled(prevTabIndex,true);
               this.m_tabs[prevTabIndex].ForceUnselect();
            }
            this.m_tabs[value].ForceSelect();
            this.setEnabled(value,false);
            if(this.m_tabStatesChangedCallback != null)
            {
               this.m_tabStatesChangedCallback();
            }
         }
      }
      
      public function get selectedTabIndex() : uint
      {
         return this.m_selectedTabIndex;
      }
      
      public function get hoverTabIndex() : uint
      {
         return this.m_hoverTabIndex;
      }
      
      public function get length() : uint
      {
         return this.m_tabs.length;
      }
      
      public function setEnabled(uIndex:uint, enabled:Boolean) : void
      {
         var tab:TabBase = this.getTab(uIndex) as TabBase;
         if(tab != null)
         {
            tab.myHitArea.mouseEnabled = enabled;
            tab.myHitArea.enabled = enabled;
         }
      }
      
      public function push(tab:TabBase) : uint
      {
         var position:uint = this.m_tabs.push(tab) - 1;
         tab.addSelectedCallback(this.tabSelected,position);
         tab.addMouseOverCallback(this.tabMouseOver,position);
         tab.addMouseOutCallback(this.tabMouseOut,position);
         return position;
      }
      
      public function clear() : void
      {
         var forEachFunc:Function = function(tab:TabBase, index:uint, vec:Vector.<TabBase>):void
         {
            tab.removeSelectedCallback(tabSelected,index);
            tab.removeMouseOverCallback(tabMouseOver,index);
            tab.removeMouseOutCallback(tabMouseOut,index);
            setEnabled(index,true);
         };
         this.m_tabs.forEach(forEachFunc);
         this.m_tabs = new Vector.<TabBase>();
         this.m_hoverTabIndex = uint.MAX_VALUE;
         this.m_selectedTabIndex = uint.MAX_VALUE;
      }
      
      public function getTab(uIndex:uint) : MovieClip
      {
         var tab:MovieClip = null;
         if(uIndex < this.length)
         {
            tab = this.m_tabs[uIndex];
         }
         return tab;
      }
      
      public function indexOf(item:MovieClip) : uint
      {
         return this.m_tabs.indexOf(item);
      }
      
      private function tabMouseOver(userData:Object = null) : void
      {
         if(this.m_tabMouseOverCallback != null)
         {
            this.m_tabMouseOverCallback(userData);
         }
      }
      
      private function tabMouseOut(userData:Object = null) : void
      {
         if(this.m_tabMouseOutCallback != null)
         {
            this.m_tabMouseOutCallback(userData);
         }
      }
      
      private function tabSelected(userData:Object) : void
      {
         this.selectedTabIndex = userData as uint;
      }
   }
}

