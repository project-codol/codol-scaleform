package codo.component.filter
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Breadcrumb;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.cpp.UiCppNewItems;
   import codo.objects.MatchSelectOptionObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import fsg.shared.BehaviourSelectable;
   
   public class FilterOption extends UIInteractiveComponent
   {
      
      protected static const ANIM_DURATION:Number = 0.2;
      
      private static const ARROW_SHOW_FRAME:String = "show";
      
      private static const ARROW_HIDE_FRAME:String = "hide";
      
      private static const NEW_TAG_PADDING_X:Number = 8;
      
      public var myLabel:TextField;
      
      public var myBackground:Sprite;
      
      public var myArrow:MovieClip;
      
      public var myNewTag:Sprite;
      
      public var myPurchaseIcon:Sprite;
      
      public var myLock:Sprite;
      
      public var myLockLabel:TextField;
      
      private var mSelectable:BehaviourSelectable;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mIndex:int = 0;
      
      private var mAllowReselect:Boolean = false;
      
      private var mLockedForPurchase:Boolean = false;
      
      private var mHighlightBackground:Boolean = false;
      
      private var mPurchaseIconFocusColor:ColorTransform;
      
      private var mPurchaseIconUnfocusColor:ColorTransform;
      
      private var mShowingArrow:Boolean;
      
      private var mBreadcrumbEnabled:Boolean = true;
      
      public function FilterOption()
      {
         super();
         isInteractiveEnabled = true;
         this.mSelectable = new BehaviourSelectable(mClickable,false);
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLockLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myLockLabel.alignment = TextStyle.HALIGN_RIGHT;
         this.myLockLabel.fontColor = GlobalGuide.WHITE;
         this.mWidth = myHitArea.width;
         this.mHeight = myHitArea.height;
         this.updateHighlightState();
         this.draw();
         this.myBackground.width = 0;
         this.myArrow.stop();
         this.myLabel.y = 7;
         this.myLockLabel.y = 7;
         this.myNewTag.visible = false;
         this.myPurchaseIcon.visible = false;
         this.myLock.visible = false;
         this.myLockLabel.visible = false;
      }
      
      public function set highlightBackground(b:Boolean) : void
      {
         this.mHighlightBackground = b;
      }
      
      public function set allowReselect(b:Boolean) : void
      {
         this.mAllowReselect = b;
      }
      
      public function get allowReselect() : Boolean
      {
         return this.mAllowReselect;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      public function set index(idx:int) : void
      {
         this.mIndex = idx;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      public function set checked(value:Boolean) : void
      {
         var newState:uint = value ? BehaviourSelectable.STATE_SELECTED : BehaviourSelectable.STATE_UNSELECTED;
         if(newState == this.mSelectable.state && false == this.mAllowReselect)
         {
            return;
         }
         this.mSelectable.state = newState;
         this.updateHighlightState();
      }
      
      public function get checked() : Boolean
      {
         return this.mSelectable.state == BehaviourSelectable.STATE_SELECTED;
      }
      
      public function set lockedForPurchase(l:Boolean) : void
      {
         this.mLockedForPurchase = l;
         this.myArrow.visible = !this.mLockedForPurchase;
         this.myPurchaseIcon.visible = this.mLockedForPurchase;
         if(true == this.myPurchaseIcon.visible)
         {
            this.mPurchaseIconFocusColor = new ColorTransform();
            this.mPurchaseIconFocusColor.color = GlobalGuide.WHITE;
            this.mPurchaseIconUnfocusColor = new ColorTransform();
            this.mPurchaseIconUnfocusColor.color = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myPurchaseIcon.transform.colorTransform = this.mPurchaseIconUnfocusColor;
         }
      }
      
      public function setAlternatingRowStyleEven() : void
      {
      }
      
      public function setAlternatingRowStyleOdd() : void
      {
      }
      
      public function get lockedForPurchase() : Boolean
      {
         return this.mLockedForPurchase;
      }
      
      public function addCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.addSelectedCallback(fnCallback,userData);
      }
      
      public function removeCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.removeSelectedCallback(fnCallback,userData);
      }
      
      public function addUncheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.addUnselectedCallback(fnCallback,userData);
      }
      
      public function removeUncheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.removeUnselectedCallback(fnCallback,userData);
      }
      
      public function set isNewCategory(b:Boolean) : void
      {
         this.myNewTag.visible = b;
      }
      
      public function get isNewCategory() : Boolean
      {
         return this.myNewTag.visible;
      }
      
      public function set label(label:String) : void
      {
         this.myLabel.text = label;
         this.myNewTag.x = this.myLabel.x + this.myLabel.textWidth + NEW_TAG_PADDING_X;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      override public function set enabled(inEnabled:Boolean) : void
      {
         super.enabled = inEnabled;
         this.updateHighlightState();
      }
      
      public function set breadcrumbEnabled(enabled:Boolean) : void
      {
         this.mBreadcrumbEnabled = enabled;
      }
      
      override public function setData(data:*) : void
      {
         var lock:String = null;
         super.setData(data);
         var matchOption:MatchSelectOptionObj = data as MatchSelectOptionObj;
         if(null != matchOption)
         {
            this.setLocked(matchOption.locked,matchOption.unlockLevel.toString());
         }
         else if(data.onboardLock != null)
         {
            lock = CFunctionCommonContainer.GetOnboardUnlockLevel(data.onboardLock);
            if(lock != null)
            {
               this.setLocked(true,lock);
            }
         }
         var breadcrumb:uint = data.breadcrumb != null && this.mBreadcrumbEnabled ? uint(data.breadcrumb) : UiCppNewItems.CRUMB_NULL;
         UiCppNewItems.instance.InitBreadcrumb(this,breadcrumb,Breadcrumb.DEFAULT_X,11);
      }
      
      public function setLocked(isLocked:Boolean, lockText:String = "") : void
      {
         this.myLock.visible = isLocked;
         this.myLockLabel.visible = isLocked;
         this.myLockLabel.text = lockText;
         if(this.myArrow.visible)
         {
            this.myArrow.visible = !isLocked;
         }
         this.myLabel.x = this.myLock.x + this.myLock.width + 10;
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         if(false == this.checked || this.mAllowReselect)
         {
            this.checked = true;
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.updateHighlightState();
         if(true == this.myPurchaseIcon.visible)
         {
            this.myPurchaseIcon.transform.colorTransform = this.mPurchaseIconFocusColor;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.updateHighlightState();
         if(true == this.myPurchaseIcon.visible)
         {
            this.myPurchaseIcon.transform.colorTransform = this.mPurchaseIconUnfocusColor;
         }
      }
      
      protected function updateHighlightState() : void
      {
         var showArrow:Boolean = false;
         if(!enabled)
         {
            this.myLabel.fontColor = GlobalGuide.CODO_GRAY_LIGHT;
         }
         else if(this.checked || _isFocused)
         {
            this.myLabel.fontColor = GlobalGuide.WHITE;
         }
         else
         {
            this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         }
         if(this.mHighlightBackground)
         {
            showArrow = _isFocused;
         }
         else
         {
            showArrow = this.checked;
         }
         if(this.mShowingArrow != showArrow)
         {
            this.mShowingArrow = showArrow;
            TweenLite.killTweensOf(this.myBackground);
            if(showArrow)
            {
               this.myBackground.visible = true;
               TweenLite.to(this.myBackground,ANIM_DURATION,{"width":this.mWidth});
               this.myArrow.gotoAndPlay(ARROW_SHOW_FRAME);
            }
            else
            {
               TweenLite.to(this.myBackground,ANIM_DURATION,{
                  "width":0,
                  "onComplete":this.onFinishTweenOut
               });
               this.myArrow.gotoAndPlay(ARROW_HIDE_FRAME);
            }
         }
      }
      
      protected function draw() : void
      {
         myHitArea.width = this.mWidth;
         this.myLabel.height = myHitArea.height = this.myBackground.height = this.mHeight;
         this.myLabel.width = this.mWidth - this.myLabel.x;
         this.myNewTag.x = this.myLabel.x + this.myLabel.textWidth + NEW_TAG_PADDING_X;
      }
      
      private function onFinishTweenOut() : void
      {
         this.myBackground.visible = false;
      }
   }
}

