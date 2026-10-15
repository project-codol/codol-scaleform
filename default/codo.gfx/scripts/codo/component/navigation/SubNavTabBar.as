package codo.component.navigation
{
   import codo.component.Button;
   import codo.component.TabNavigation;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.Sprite;
   
   public class SubNavTabBar extends Sprite
   {
      
      public var myTabNav:TabNavigation;
      
      public var myTabNavBkg:Sprite;
      
      public var myTabNavSelectedBar:Sprite;
      
      private var mTabData:Array;
      
      private var mClickCallback:Function;
      
      private var mTabTextStyle:TextStyle;
      
      public function SubNavTabBar()
      {
         super();
         this.mTabData = [];
         this.mTabTextStyle = GlobalGuide.subNavTextStyle;
      }
      
      public function set customButtonStyle(customTextStyle:TextStyle) : void
      {
         this.mTabTextStyle = customTextStyle;
      }
      
      public function addTab(label:String) : int
      {
         return this.mTabData.push({
            "index":this.mTabData.length,
            "label":label
         }) - 1;
      }
      
      public function init(tabClickCallback:Function, btnHeight:Number = 0) : void
      {
         var tabConfig:Object = null;
         var PADDING:int = 4;
         this.mClickCallback = tabClickCallback;
         tabConfig = {
            "tabLinkage":"codo.shared.navigation.SubNavTabButton",
            "tabClickedCallback":this.setSelectedTab,
            "tabPadding":1,
            "textStyle":this.mTabTextStyle,
            "tabs":this.mTabData
         };
         this.myTabNav.setData(tabConfig);
         this.myTabNavBkg.width = this.myTabNav.x + this.myTabNav.width + PADDING;
         if(btnHeight > 0)
         {
            this.height = btnHeight;
         }
         this.myTabNavSelectedBar.y = height + 2;
         this.updateBarPosition();
      }
      
      override public function set height(val:Number) : void
      {
         var btn:SubNavTabButton = null;
         this.myTabNavBkg.height = val;
         for each(btn in this.myTabNav.tabs)
         {
            btn.height = btn.myHitArea.height = val - 8;
         }
      }
      
      public function getTabByIndex(index:int) : Button
      {
         return this.myTabNav.getTabByIndex(index);
      }
      
      public function setSelectedTab(tabIndex:int, remoteTriggered:Boolean = false) : void
      {
         if(remoteTriggered)
         {
            this.myTabNav.SetSelectedIndex(tabIndex);
         }
         else
         {
            this.mClickCallback(tabIndex);
         }
         this.updateBarPosition();
      }
      
      private function updateBarPosition() : void
      {
         var xPos:int = 0;
         var selectedTab:Button = this.myTabNav.tabs[this.myTabNav.currentTabIndex];
         this.myTabNavSelectedBar.width = selectedTab.myLabel.textWidth;
         xPos = int((selectedTab.width - this.myTabNavSelectedBar.width) * 0.5) + 3;
         this.myTabNavSelectedBar.x = selectedTab.x + xPos;
      }
   }
}

