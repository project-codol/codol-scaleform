package codo.component.navigation.parts
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.marketplaceitem.MarketplaceNewTag;
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.component.object.NavigationObj;
   import codo.cpp.UiCppNewItems;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.getDefinitionByName;
   
   public class NavigationButton extends Button
   {
      
      private static const LABEL_OFFSET_X:Number = 33;
      
      private static const TEXT_MARGIN:Number = 46;
      
      private static const MASK_MARGIN:Number = 3;
      
      private static const SHOW_DURATION:Number = 0.2;
      
      private static const ICON_SIZE:Number = 0.1625;
      
      private static const ICON_OFFSET_Y:Number = 2;
      
      public var mySelectedBar:Sprite;
      
      public var myDisabledIcon:Sprite;
      
      public var myWarningIcon:Sprite;
      
      public var myBarMask:MovieClip;
      
      public var myIcon:Sprite;
      
      public var myIconContainer:Sprite;
      
      public var myAltLabel:TextField;
      
      public var myLabelGlow:TextField;
      
      public var myNewTag:MarketplaceNewTag;
      
      public var myLockIcon:IconLock;
      
      private var mFocusCallback:Function;
      
      private var mUnFocusCallback:Function;
      
      private var mIconColorOn:ColorTransform;
      
      private var mIconColorOff:ColorTransform;
      
      private var mIconColorClick:ColorTransform;
      
      private var mButtonOffFilter:Array;
      
      private var mButtonOnFilter:Array;
      
      private var mGlowFilter:Array;
      
      private var mLabelOffset:Number;
      
      private var mTextMargin:Number;
      
      private var mButtonXOffset:Number = 0;
      
      private var mHasToggle:Boolean;
      
      public function NavigationButton()
      {
         super();
         this.mLabelOffset = LABEL_OFFSET_X;
         this.mTextMargin = TEXT_MARGIN;
         this.mButtonOffFilter = ButtonGuide.BUTTON_OFF_FILTER;
         this.mButtonOnFilter = ButtonGuide.BUTTON_ON_FILTER;
         this.mGlowFilter = ButtonGuide.BUTTON_BASE_GLOWFILTER;
         TweenPlugin.activate([ColorTransformPlugin]);
         mTextFocusColor = GlobalGuide.WHITE;
         mTextUnfocusColor = GlobalGuide.NAV_TEXT_BLUE;
         myLabel.filters = this.mButtonOffFilter;
         this.mySelectedBar.visible = this.myNewTag.visible = false;
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.mouseEnabled = this.myDisabledIcon.visible = false;
         }
         if(this.myWarningIcon != null)
         {
            this.myWarningIcon.mouseEnabled = this.myWarningIcon.visible = false;
         }
         if(null != this.myAltLabel)
         {
            this.myAltLabel.textStyle = ButtonGuide.styleButtonCommon;
            this.myAltLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
            this.myAltLabel.fontColor = mTextUnfocusColor;
            this.myAltLabel.text = "";
         }
      }
      
      public function set themeColor(col:uint) : void
      {
         this.mButtonOffFilter = [new DropShadowFilter(5,120,col,1,25,25)];
         this.mButtonOnFilter = this.mButtonOffFilter.concat([new GlowFilter(col,1,25,25)]);
         this.mGlowFilter = [new GlowFilter(col,1,5,5)];
         myLabel.filters = this.mButtonOffFilter;
      }
      
      public function setCustomizeFilter(buttonOffFilter:Array, buttonOnFilter:Array, glowFilter:Array) : void
      {
         this.mButtonOffFilter = buttonOffFilter;
         this.mButtonOnFilter = buttonOnFilter;
         this.mGlowFilter = glowFilter;
         myLabel.filters = this.mButtonOffFilter;
      }
      
      public function customizeLabelOffset(value:Number) : void
      {
         this.mLabelOffset = value;
      }
      
      public function customizeTextMargin(value:Number) : void
      {
         this.mTextMargin = value;
      }
      
      override public function setData(data:*) : void
      {
         var iconClass:Class = null;
         var icon:Sprite = null;
         var lockClass:Class = null;
         var lockClip:IconLock = null;
         var lockScale:Number = NaN;
         super.setData(data);
         var buttonData:NavigationObj = data as NavigationObj;
         index = buttonData.index;
         if(null != buttonData.iconLinkage && "" != buttonData.iconLinkage)
         {
            iconClass = getDefinitionByName(buttonData.iconLinkage) as Class;
            icon = new iconClass() as Sprite;
            this.myIconContainer = new Sprite();
            this.myIconContainer.addChild(icon);
            icon.scaleX = ICON_SIZE;
            icon.scaleY = ICON_SIZE;
            icon.x = -(icon.width * 0.5);
            icon.y = -(icon.height * 0.5);
            this.myIcon = addChild(this.myIconContainer) as Sprite;
            this.swapChildren(this.myIcon,myHitArea);
            myLabel.visible = false;
            this.myLabelGlow.visible = false;
            this.mIconColorOn = new ColorTransform();
            this.mIconColorOn.color = mTextFocusColor;
            this.mIconColorOff = new ColorTransform();
            this.mIconColorOff.color = mTextUnfocusColor;
            this.mIconColorClick = new ColorTransform();
            this.mIconColorClick.color = mTextClickColor;
            this.myIconContainer.getChildAt(0).transform.colorTransform = this.mIconColorOff;
            this.myIcon.filters = ButtonGuide.BUTTON_OFF_FILTER;
         }
         else
         {
            this.label = LocalizeUtil.localize(buttonData.label);
            myLabel.fontColor = mTextUnfocusColor;
            this.myLabelGlow.fontColor = mTextUnfocusColor;
         }
         if(null != buttonData.lockLevel)
         {
            lockClass = getDefinitionByName("codo.shared.IconLock") as Class;
            lockClip = new lockClass() as IconLock;
            addChild(lockClip);
            lockClip.setLockLevel(buttonData.lockLevel);
            lockScale = myLabel.textHeight / lockClip.height;
            lockClip.scaleX = lockClip.scaleY = lockScale;
            this.myLockIcon = lockClip;
            mTextFocusColor = GlobalGuide.GRAY_50;
            mTextUnfocusColor = GlobalGuide.GRAY_50;
            myLabel.fontColor = mTextUnfocusColor;
            this.myLabelGlow.fontColor = mTextUnfocusColor;
            mClickable.setEnabled(false);
            myHitArea.visible = false;
         }
         else if(UiCppNewItems.instance != null)
         {
            UiCppNewItems.instance.InitBreadcrumb(this,buttonData.breadcrumb);
         }
         this.mHasToggle = buttonData.toggle;
         this.draw();
      }
      
      override public function set label(label:String) : void
      {
         super.label = label;
         this.myLabelGlow.text = label;
      }
      
      override protected function onMouseOver() : void
      {
         if(this.myLockIcon != null)
         {
            return;
         }
         if(false == mToggled)
         {
            this.showFocus(true);
            CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
         if(null != this.mFocusCallback)
         {
            this.mFocusCallback(this);
         }
      }
      
      public function doNewItemCalloutAnim() : void
      {
      }
      
      private function onPostNewTagAnimComplete() : void
      {
         this.myNewTag.visible = false;
      }
      
      override protected function onMouseOut() : void
      {
         if(this.myLockIcon != null)
         {
            return;
         }
         if(false == mToggled)
         {
            this.showFocus(false);
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
         if(null != this.mUnFocusCallback)
         {
            this.mUnFocusCallback(this);
         }
      }
      
      override protected function onMouseClick() : void
      {
         if(this.myLockIcon != null)
         {
            return;
         }
         super.onMouseClick();
         var DELAY_SECONDS:uint = 2;
         if(null != this.myIcon)
         {
            this.myIconContainer.getChildAt(0).transform.colorTransform = this.mIconColorClick;
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         if(this.myLockIcon != null)
         {
            return;
         }
         super.onMouseClickUp();
         if(null != this.myIcon)
         {
            this.myIconContainer.getChildAt(0).transform.colorTransform = this.mIconColorOff;
         }
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         mToggled = toggled;
         this.mySelectedBar.visible = mToggled;
         if(true == mToggled)
         {
            this.showFocus(true);
            this.myBarMask.gotoAndStop(0);
            this.myBarMask.play();
         }
         else
         {
            this.showFocus(false);
         }
      }
      
      private function showFocus(focus:Boolean) : void
      {
         var iconFilters:Array = null;
         var iconColor:ColorTransform = null;
         var labelGlowFilters:Array = null;
         var labelColor:uint = 0;
         var scale:Number = NaN;
         if(focus)
         {
            iconFilters = this.mButtonOnFilter;
            iconColor = this.mIconColorOn;
            labelGlowFilters = this.mGlowFilter;
            labelColor = mTextFocusColor;
            scale = 1.1;
         }
         else
         {
            iconFilters = this.mButtonOffFilter;
            iconColor = this.mIconColorOff;
            labelGlowFilters = null;
            labelColor = mTextUnfocusColor;
            scale = 1;
         }
         if(null != this.myIcon)
         {
            GlobalGuide.TOGGLE_ITEM_FOCUS(this.myIcon,true,true,scale);
            this.myIcon.filters = iconFilters;
            this.myIconContainer.getChildAt(0).transform.colorTransform = iconColor;
         }
         else
         {
            this.myLabelGlow.filters = labelGlowFilters;
            myLabel.fontColor = labelColor;
            this.myLabelGlow.fontColor = labelColor;
            GlobalGuide.TOGGLE_ITEM_FOCUS(myLabel,true,true,scale);
            GlobalGuide.TOGGLE_ITEM_FOCUS(this.myLabelGlow,true,true,scale);
         }
      }
      
      public function set routingDisabled(isDisabled:Boolean) : void
      {
         mClickable.setEnabled(!isDisabled);
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.visible = isDisabled;
         }
         alpha = isDisabled ? GlobalGuide.UNFOCUS_ALPHA : 1;
      }
      
      public function get hasToggle() : Boolean
      {
         return this.mHasToggle;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      public function set textStyle(style:TextStyle) : void
      {
         myLabel.textStyle = style;
         this.myLabelGlow.textStyle = style;
      }
      
      public function set focusCallback(func:Function) : void
      {
         this.mFocusCallback = func;
      }
      
      public function set unFocusCallback(func:Function) : void
      {
         this.mUnFocusCallback = func;
      }
      
      public function set glowStyle(glow:GlowFilter) : void
      {
         this.mGlowFilter = [glow];
      }
      
      override public function draw() : void
      {
         if(null != myBackground)
         {
            myBackground.width = mWidth - BACKGROUND_SIZE_OFFSET;
            myBackground.height = mHeight - BACKGROUND_SIZE_OFFSET;
         }
         if(null != myOutline)
         {
            myOutline.width = mWidth;
            myOutline.height = mHeight;
         }
         myHitArea.width = mWidth;
         myHitArea.height = mHeight;
         if(null != this.myIcon)
         {
            this.mySelectedBar.width = myHitArea.width = this.myIcon.width + this.mTextMargin;
            this.myIcon.x = myHitArea.x + myHitArea.width * 0.5;
            this.myIcon.y = myHitArea.y + myHitArea.height * 0.5 + ICON_OFFSET_Y;
         }
         else
         {
            this.mySelectedBar.width = myHitArea.width = myLabel.textWidth + this.mTextMargin;
         }
         if(null != this.myLockIcon)
         {
            this.myLockIcon.x = myLabel.x + myLabel.textWidth - 32;
            this.myLockIcon.y = myLabel.y - 11;
            this.mySelectedBar.width = myHitArea.width = myLabel.x + myLabel.textWidth + this.myLockIcon.width;
         }
         this.myBarMask.width = this.mySelectedBar.width + MASK_MARGIN;
         this.myBarMask.y = this.mySelectedBar.y = myHitArea.y + myHitArea.height;
         this.myLabelGlow.x = myLabel.x = mWidth - this.mLabelOffset;
         this.myNewTag.x = (this.width - this.myNewTag.width) * 0.5;
      }
      
      public function prepareForShowAnim() : void
      {
         myLabel.alpha = 0;
         myLabel.scaleX = 0.2;
         myLabel.scaleY = 0.2;
         this.myLabelGlow.alpha = 0;
         this.myLabelGlow.scaleX = 0.2;
         this.myLabelGlow.scaleY = 0.2;
         this.mySelectedBar.alpha = 0;
         if(null != this.myLockIcon)
         {
            this.myLockIcon.alpha = 0;
         }
         if(null != this.myIcon)
         {
            this.myIcon.alpha = 0;
            this.myIcon.scaleX = 0.2;
            this.myIcon.scaleY = 0.2;
         }
         if(getBreadcrumb() != null)
         {
            getBreadcrumb().alpha = 0;
         }
      }
      
      public function setButtonXOffset(value:Number) : void
      {
         this.mButtonXOffset = value;
      }
      
      public function getButtonXOffset() : Number
      {
         return this.mButtonXOffset;
      }
      
      public function show() : void
      {
         if(null != this.myLockIcon)
         {
            TweenLite.to(this.myLockIcon,SHOW_DURATION,{"alpha":1});
         }
         if(null != this.myIcon)
         {
            TweenLite.to(this.myIcon,SHOW_DURATION,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            });
         }
         else
         {
            TweenLite.to(myLabel,SHOW_DURATION,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            });
            TweenLite.to(this.myLabelGlow,SHOW_DURATION,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1
            });
         }
         TweenLite.to(this.mySelectedBar,SHOW_DURATION,{"alpha":1});
         if(this.myWarningIcon != null)
         {
            TweenLite.to(this.myWarningIcon,SHOW_DURATION,{"alpha":1});
         }
         if(getBreadcrumb() != null)
         {
            TweenLite.to(getBreadcrumb(),SHOW_DURATION,{"alpha":1});
         }
      }
      
      public function hide() : void
      {
         if(null != this.myLockIcon)
         {
            TweenLite.to(this.myLockIcon,SHOW_DURATION,{"alpha":0});
         }
         if(null != this.myIcon)
         {
            TweenLite.to(this.myIcon,SHOW_DURATION,{
               "alpha":0,
               "scaleX":0.2,
               "scaleY":0.2
            });
         }
         else
         {
            TweenLite.to(myLabel,SHOW_DURATION,{
               "alpha":0,
               "scaleX":0.2,
               "scaleY":0.2
            });
            TweenLite.to(this.myLabelGlow,SHOW_DURATION,{
               "alpha":0,
               "scaleX":0.2,
               "scaleY":0.2
            });
         }
         TweenLite.to(this.mySelectedBar,SHOW_DURATION,{"alpha":0});
         if(this.myWarningIcon != null)
         {
            TweenLite.to(this.myWarningIcon,SHOW_DURATION,{"alpha":0});
         }
         if(getBreadcrumb() != null)
         {
            TweenLite.to(getBreadcrumb(),SHOW_DURATION,{"alpha":0});
         }
      }
   }
}

