package codo.component.social
{
   import codo.objects.SocialTabSetting;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class SocialMainTab extends Sprite
   {
      
      private static const BG_WIDTH:int = 998;
      
      private static const BG_HEIGHT:int = 46;
      
      private var mTabBtnClass:String;
      
      public var myBg:MovieClip;
      
      private var mData:SocialTabSetting;
      
      private var mSelectedTabIndex:int = -1;
      
      private var mTabButtons:Vector.<SocialTabButton> = new Vector.<SocialTabButton>();
      
      private var mOnTabSelectChanged:Function;
      
      private var mTabType:int = SocialTabButton.TYPE_BIG;
      
      public function SocialMainTab()
      {
         super();
         this.myBg.width = BG_WIDTH;
         this.myBg.height = BG_HEIGHT;
         this.myBg.visible = false;
      }
      
      public function setTabBtnClass(tabBtnClass:String) : void
      {
         this.mTabBtnClass = tabBtnClass;
      }
      
      public function setData(data:SocialTabSetting) : void
      {
         var tabButton:SocialTabButton = null;
         var tabWidth:int = 0;
         this.reset();
         this.mData = data;
         this.mOnTabSelectChanged = data.tabSelectedCallback;
         var wholeWidth:Number = 0;
         var labels:Array = this.mData.labels;
         for(var i:int = 0; i < labels.length; i++)
         {
            if(i != 0)
            {
               wholeWidth += data.padding;
            }
            tabButton = this.buildTabButton();
            tabButton.setType(this.mTabType);
            this.mTabButtons.push(tabButton);
            tabButton.setClickCallback(this.onTabButtonClicked);
            tabButton.label = labels[i];
            addChild(tabButton);
            tabButton.x = wholeWidth;
            tabButton.y = 1;
            if(data.fixedTabWidth == -1)
            {
               tabWidth = tabButton.myLabel.textWidth + 30;
            }
            else
            {
               tabWidth = data.fixedTabWidth;
            }
            tabButton.setWidth(tabWidth);
            wholeWidth += tabWidth;
         }
         this.myBg.visible = this.mData.needBg;
      }
      
      public function setTabType(type:int) : void
      {
         this.mTabType = type;
         this.mTabBtnClass = this.mTabType == SocialTabButton.TYPE_BIG ? SocialTabButton.TYPE_BIG_CLASS_LINKAGE : SocialTabButton.TYPE_SMALL_CLASS_LINKAGE;
      }
      
      private function reset() : void
      {
         for(var i:int = 0; i < this.mTabButtons.length; i++)
         {
            if(Boolean(this.mTabButtons[i].parent))
            {
               removeChild(this.mTabButtons[i]);
            }
         }
         this.mTabButtons.splice(0,this.mTabButtons.length);
         this.mSelectedTabIndex = -1;
      }
      
      public function getSelectedTab() : int
      {
         return this.mSelectedTabIndex;
      }
      
      public function clearSelectedTab() : void
      {
         this.mSelectedTabIndex = -1;
         for(var i:int = 0; i < this.mTabButtons.length; i++)
         {
            this.mTabButtons[i].selected = false;
         }
      }
      
      private function buildTabButton() : SocialTabButton
      {
         var cls:Class = getDefinitionByName(this.mTabBtnClass) as Class;
         var itm:SocialTabButton = new cls() as SocialTabButton;
         itm.setDotCount(0);
         return itm;
      }
      
      public function selectTab(tabIndex:int) : void
      {
         if(tabIndex < 0 || tabIndex >= this.mTabButtons.length)
         {
            return;
         }
         this.changeTabSelection(tabIndex);
      }
      
      public function setTabRedDotCount(tabIndex:int, count:int) : void
      {
         this.mTabButtons[tabIndex].setDotCount(count);
      }
      
      private function onTabButtonClicked(target:SocialTabButton) : void
      {
         var buttonIndex:int = this.mTabButtons.indexOf(target);
         if(-1 == buttonIndex)
         {
            return;
         }
         this.changeTabSelection(buttonIndex);
      }
      
      private function changeTabSelection(tabIndex:int) : void
      {
         if(this.mSelectedTabIndex == tabIndex)
         {
            return;
         }
         if(this.mSelectedTabIndex >= 0 && this.mSelectedTabIndex < this.mTabButtons.length)
         {
            this.mTabButtons[this.mSelectedTabIndex].selected = false;
         }
         this.mSelectedTabIndex = tabIndex;
         this.mTabButtons[this.mSelectedTabIndex].selected = true;
         if(null != this.mOnTabSelectChanged)
         {
            this.mOnTabSelectChanged(this.mSelectedTabIndex);
         }
      }
   }
}

