package codo.component.navigation
{
   import codo.component.factory.ButtonFactory;
   import codo.component.navigation.parts.NavigationButton;
   import codo.component.object.NavigationObj;
   import codo.cpp.IUiCppList;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class NavigationMenu extends Sprite implements IUiCppList, IUiCppListMutable
   {
      
      protected static const SLIDE_DURATION:Number = 0;
      
      protected static const SHOW_ANIM_DURATION:Number = 0.4;
      
      protected static const MASK_PADDING:Number = 40;
      
      public var myMenuBkg:Sprite;
      
      public var myMenuItemHolder:Sprite;
      
      public var myFocusGlow:MovieClip;
      
      public var myMask:Sprite;
      
      private var mItemClickCallback:Function;
      
      private var mSelectedIndex:uint;
      
      private var mUnfocusTimeout:uint;
      
      private var mShowTimeline:TimelineMax;
      
      protected var mNavButtonRenderMethod:Function = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
      
      protected var mNavButtonByIndex:Vector.<NavigationButton>;
      
      private var _uiCppData:Array = [];
      
      private var mShown:Boolean = false;
      
      public function NavigationMenu()
      {
         super();
         this.mNavButtonByIndex = new Vector.<NavigationButton>();
         this.mSelectedIndex = uint.MAX_VALUE;
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.myMenuBkg.y = -this.myMenuBkg.height;
         this.myFocusGlow.alpha = 0;
         this.myMenuItemHolder.y = 0;
      }
      
      public function set listItemClickCallback(callback:Function) : void
      {
         this.mItemClickCallback = callback;
      }
      
      public function setData(menuData:Vector.<NavigationObj>) : void
      {
         var item:NavigationButton = null;
         var prevItem:NavigationButton = null;
         var BAR_END_CAP:uint = 70;
         var i:uint = 0;
         var len:uint = menuData.length;
         this._uiCppData = [];
         while(this.menuItemHolder.numChildren > 0)
         {
            this.menuItemHolder.removeChildAt(0);
         }
         for(this.mNavButtonByIndex = new Vector.<NavigationButton>(0); i < len; )
         {
            item = this.mNavButtonRenderMethod();
            item.setData(menuData[i]);
            this._uiCppData.push(menuData[i]);
            this.menuItemHolder.addChild(item);
            item.setClickCallback(this.onMenuItemSelected);
            item.focusCallback = this.onMenuItemFocused;
            item.unFocusCallback = this.onMenuItemUnFocused;
            if(!this.isPrimaryNav())
            {
               item.prepareForShowAnim();
            }
            this.mNavButtonByIndex[menuData[i].index] = item;
            if(i > 0)
            {
               prevItem = this.menuItemHolder.getChildAt(i - 1) as NavigationButton;
               item.x = prevItem.x + prevItem.width + item.getButtonXOffset();
            }
            i++;
         }
         this.selectedIndex = 0;
         this.myFocusGlow.x = this.menuItemHolder.x + this.getNavButtonByIndex(0).x;
         this.myFocusGlow.width = this.selectedButton.width;
         if(!this.isPrimaryNav())
         {
            this.myMenuBkg.width = this.menuItemHolder.width + BAR_END_CAP;
            this.myMask.width = this.myMenuBkg.width + MASK_PADDING;
         }
      }
      
      protected function isPrimaryNav() : Boolean
      {
         return false;
      }
      
      public function showMenu() : void
      {
         var button:NavigationButton = null;
         if(this.mShown)
         {
            return;
         }
         this.disableTabs();
         if(null != this.mShowTimeline)
         {
            this.mShowTimeline.kill();
         }
         this.mShowTimeline = new TimelineMax();
         this.mShowTimeline.append(new TweenLite(this.myMenuBkg,SHOW_ANIM_DURATION,{
            "y":0,
            "ease":Strong.easeOut
         }));
         this.mShowTimeline.append(TweenLite.delayedCall(-0.5,this.animateFocusGlowFlicker));
         var len:int = int(this.mNavButtonByIndex.length);
         var tweens:Array = new Array();
         for(var i:int = 0; i < len; i++)
         {
            button = this.getNavButtonByIndex(i);
            button.prepareForShowAnim();
            tweens.push(TweenLite.delayedCall(-0.2,button.show));
         }
         this.mShowTimeline.insertMultiple(tweens,this.mShowTimeline.duration,null,0.05);
         this.mShowTimeline.addCallback(this.enableTabs,this.mShowTimeline.duration + 0.25);
         this.mShowTimeline.play();
         this.mShown = true;
      }
      
      public function hideMenu() : void
      {
         var button:NavigationButton = null;
         if(!this.mShown)
         {
            return;
         }
         this.disableTabs();
         if(null != this.mShowTimeline)
         {
            this.mShowTimeline.kill();
         }
         this.mShowTimeline = new TimelineMax();
         this.mShowTimeline.append(new TweenLite(this.myMenuBkg,SHOW_ANIM_DURATION,{
            "y":-this.myMenuBkg.height,
            "ease":Strong.easeOut
         }));
         this.mShowTimeline.append(TweenLite.delayedCall(0,this.animateFocusGlowFlicker));
         this.mShowTimeline.play();
         var len:int = int(this.mNavButtonByIndex.length);
         for(var i:int = 0; i < len; i++)
         {
            button = this.getNavButtonByIndex(i);
            button.hide();
         }
         this.mShown = false;
      }
      
      public function set marketReadyMode(isReady:Boolean) : void
      {
         var item:NavigationButton = null;
         var data:NavigationObj = null;
         var i:uint = 0;
         for(var len:uint = uint(this.menuItemHolder.numChildren); i < len; )
         {
            item = this.getNavButtonByIndex(i);
            data = item.getData() as NavigationObj;
            if(data.isMarketReadyRequiredToActive)
            {
               item.routingDisabled = !isReady;
            }
            i++;
         }
      }
      
      protected function get menuItemHolder() : Sprite
      {
         return this.myMenuItemHolder;
      }
      
      public function set selectedIndex(idx:uint) : void
      {
         if(idx == this.mSelectedIndex)
         {
            return;
         }
         if(this.selectedButton != null)
         {
            this.selectedButton.setToggled(false);
         }
         this.mSelectedIndex = idx;
         var e:NavigationButton = this.selectedButton;
         e.setToggled(true);
         this.animateFocusGlowToPoint(this.menuItemHolder.x + e.x,e.width);
      }
      
      public function clearSelectedIndex() : void
      {
         if(this.selectedButton != null)
         {
            this.selectedButton.setToggled(false);
         }
         this.mSelectedIndex = int.MAX_VALUE;
      }
      
      public function get selectedButton() : NavigationButton
      {
         if(this.mSelectedIndex < this.mNavButtonByIndex.length)
         {
            return this.mNavButtonByIndex[this.mSelectedIndex];
         }
         return null;
      }
      
      public function get selectedIndex() : uint
      {
         return this.mSelectedIndex;
      }
      
      public function get shown() : Boolean
      {
         return this.mShown;
      }
      
      public function onMenuItemSelected(e:NavigationButton) : void
      {
         if(e.index == this.mSelectedIndex)
         {
            return;
         }
         if(e.hasToggle)
         {
            this.selectedIndex = e.index;
            this.animateFocusGlowFlicker();
         }
         if(this.mItemClickCallback != null)
         {
            this.mItemClickCallback(e.getData());
         }
      }
      
      protected function onMenuItemFocused(e:NavigationButton) : void
      {
         clearTimeout(this.mUnfocusTimeout);
         this.animateFocusGlowToPoint(this.menuItemHolder.x + e.x,e.width);
      }
      
      protected function onMenuItemUnFocused(e:NavigationButton) : void
      {
         clearTimeout(this.mUnfocusTimeout);
         this.mUnfocusTimeout = setTimeout(this.unfocusTimeout,200);
      }
      
      private function unfocusTimeout() : void
      {
         TweenLite.killTweensOf(this.myFocusGlow);
         this.myFocusGlow.x = this.menuItemHolder.x + this.selectedButton.x;
         this.myFocusGlow.width = this.selectedButton.width;
      }
      
      private function animateFocusGlowToPoint(x:Number, width:Number) : void
      {
         TweenLite.to(this.myFocusGlow,SLIDE_DURATION,{
            "x":x,
            "width":width,
            "ease":Strong.easeOut
         });
      }
      
      protected function animateFocusGlowFlicker() : void
      {
         this.myFocusGlow.alpha = 0.5;
         this.myFocusGlow.gotoAndStop(0);
         this.myFocusGlow.play();
      }
      
      public function set navButtonRenderMethod(renderMethod:Function) : void
      {
         this.mNavButtonRenderMethod = renderMethod;
      }
      
      public function getNavButtonByIndex(index:uint) : NavigationButton
      {
         return this.mNavButtonByIndex[index];
      }
      
      private function disableTabs() : void
      {
         var btn:NavigationButton = null;
         var len:int = this.menuItemHolder.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            btn = this.getNavButtonByIndex(i);
            btn.enabled = false;
         }
         this.myFocusGlow.visible = false;
      }
      
      private function enableTabs() : void
      {
         var btn:NavigationButton = null;
         var len:int = this.menuItemHolder.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            btn = this.getNavButtonByIndex(i);
            btn.enabled = true;
         }
         this.myFocusGlow.visible = true;
      }
      
      public function uiCppGetListData() : Array
      {
         return this._uiCppData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.mSelectedIndex;
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
         this.setData(Vector.<NavigationObj>(data));
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
         this.selectedIndex = index;
      }
   }
}

