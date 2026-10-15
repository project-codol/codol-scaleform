package fsg.shared
{
   import fsg.widgets.tabGeneric;
   
   public class TabBarDynamic extends TabBar
   {
      
      private var m_tabClass:Class;
      
      private var m_createdTabs:Vector.<TabBase>;
      
      public function TabBarDynamic()
      {
         if(!this.m_tabClass)
         {
            this.m_tabClass = tabGeneric;
         }
         this.m_createdTabs = new Vector.<TabBase>();
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.m_tabClass = null;
      }
      
      override protected function getTabClass() : Class
      {
         return this.m_tabClass;
      }
      
      public function set tabClass(myTabClass:Class) : void
      {
         this.m_tabClass = myTabClass;
      }
      
      override public function addTabs(tabDP:Array) : void
      {
         var tab:Object = null;
         for each(tab in tabDP)
         {
            this.addTab(tab.label || tab.name);
         }
      }
      
      override public function addTab(text:String) : TabBase
      {
         var newTab:TabBase = null;
         newTab = new (this.getTabClass())();
         newTab.visible = false;
         addChild(newTab);
         this.m_createdTabs.push(newTab);
         return super.addTab(text);
      }
      
      override public function clearTabs() : void
      {
         var tab:TabBase = null;
         super.clearTabs();
         for each(tab in this.m_createdTabs)
         {
            removeChild(tab);
            tab.dispose();
         }
         this.m_createdTabs = new Vector.<TabBase>();
      }
   }
}

