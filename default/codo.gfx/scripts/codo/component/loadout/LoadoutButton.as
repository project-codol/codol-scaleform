package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.constants.MarketMenuData;
   import codo.cpp.UiCppNewItems;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class LoadoutButton extends UIInteractiveComponent
   {
      
      public static const UP_STATE_FRAME:int = 1;
      
      public static const OVER_STATE_FRAME:int = 2;
      
      protected static const LOCKED_STATE_FRAME:int = 3;
      
      protected static const DISABLED_STATE_FRAME:int = 4;
      
      public static const KILL_STATE_FRAME:int = 5;
      
      private static const DEFAULT_WIDTH:Number = 89;
      
      private static const DEFAULT_HEIGHT:Number = 90;
      
      private static const SHAPE_MARGIN:Number = 2;
      
      private static const CLEAR_BUTTON_MARGIN:Number = 2;
      
      private static const GROW_DURATION:Number = 0.2;
      
      private static const DISABLED_TAB_SIZE_OFFSET:Number = 30;
      
      private static const STREAK_TEXT_OFFSET_Y:Number = 29;
      
      public var myImage:FsgImageHolder;
      
      public var myMask:Sprite;
      
      public var myLock:Sprite;
      
      public var myDisabledTab:Sprite;
      
      public var myPlusSign:Sprite;
      
      public var myPurchaseIcon:Sprite;
      
      public var myBackground:MovieClip;
      
      public var myClearButton:CloseButton;
      
      public var myStreakText:TextField;
      
      public var myDisabledIcon:MovieClip;
      
      public var myLockWithLevel:IconLock;
      
      public var myHighlightOutline:Sprite;
      
      public var myEquippedIcon:MovieClip;
      
      private var mLocked:Boolean = false;
      
      private var mFixed:Boolean = false;
      
      private var mToggled:Boolean = false;
      
      private var mDisabled:Boolean = false;
      
      private var mClearCallback:Function;
      
      private var mIsExtraSlot:Boolean = false;
      
      private var mOnboardUnlockLevel:String;
      
      private var mIsSuggestedLoadout:Boolean;
      
      private var mIgnoreMouse:Boolean;
      
      protected var mWidth:Number = 89;
      
      protected var mHeight:Number = 90;
      
      public function LoadoutButton()
      {
         var item:MovieClip = null;
         super();
         isInteractiveEnabled = true;
         this.myClearButton.registerClickEvent(this.onClearClicked);
         this.myClearButton.visible = false;
         this.myDisabledTab.visible = false;
         this.myMask.visible = false;
         if(this.myHighlightOutline != null)
         {
            this.myHighlightOutline.visible = false;
         }
         this.draw();
         this.myPlusSign.scaleX = 0;
         this.myPlusSign.scaleY = 0;
         this.myStreakText.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myStreakText.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myStreakText.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myStreakText.visible = false;
         this.myImage.mouseEnabled = this.myImage.mouseChildren = false;
         this.myImage.keepWHRatio = true;
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.visible = false;
         }
         var defaultHiddenComps:Array = [this.myPurchaseIcon,this.myStreakText,this.myClearButton,this.myPlusSign,this.myLockWithLevel,this.myLock,this.myDisabledTab];
         for each(item in defaultHiddenComps)
         {
            if(Boolean(item))
            {
               item.visible = false;
            }
         }
      }
      
      public function setIsSuggestedLoadout() : void
      {
         if(this.mIsSuggestedLoadout)
         {
            return;
         }
         this.mIsSuggestedLoadout = true;
         var cls:Class = getDefinitionByName("codo.shared.marketplace.MarketplaceItemCardEquippedCheckmark") as Class;
         this.myEquippedIcon = new cls() as MovieClip;
         addChild(this.myEquippedIcon);
         this.myEquippedIcon.scaleX = this.myEquippedIcon.scaleY = 0.75;
         this.myEquippedIcon.y = CLEAR_BUTTON_MARGIN;
         this.myEquippedIcon.x = this.mWidth - this.myEquippedIcon.width - CLEAR_BUTTON_MARGIN;
      }
      
      override public function setData(data:*) : void
      {
         var lockClass:Class = null;
         var lockClip:IconLock = null;
         var prod:ProductObj = null;
         super.setData(data);
         if(null != this.myPurchaseIcon)
         {
            this.myPurchaseIcon.visible = false;
         }
         if(null != data.killsReq && 0 < data.killsReq)
         {
            this.myStreakText.text = data.killsReq.toString();
            this.myStreakText.visible = true;
         }
         else
         {
            this.myStreakText.visible = false;
         }
         this.myImage.clearImage();
         if(null != data.imageURL)
         {
            this.myImage.setImage(data.imageURL);
         }
         if(null != data.clearCallback)
         {
            this.mClearCallback = data.clearCallback;
         }
         if(this.mClearCallback != null && !data.isEmpty)
         {
            this.myClearButton.visible = true;
         }
         else
         {
            this.myClearButton.visible = false;
         }
         if(data.isEmpty == true && data.isLocked == false)
         {
            this.myPlusSign.visible = true;
            this.myPlusSign.scaleX = this.myPlusSign.scaleY = 0;
         }
         else
         {
            this.myPlusSign.visible = false;
         }
         if(this.myLockWithLevel != null)
         {
            this.myLockWithLevel.visible = false;
         }
         if(this.mOnboardUnlockLevel != null && !data.isLocked)
         {
            if(this.myLockWithLevel == null)
            {
               lockClass = getDefinitionByName("codo.shared.IconLock") as Class;
               lockClip = new lockClass() as IconLock;
               addChild(lockClip);
               lockClip.scaleX = lockClip.scaleY = 0.25;
               this.myLockWithLevel = lockClip;
               this.myLockWithLevel.x = this.mWidth * 0.5 - this.myLockWithLevel.width * 0.5;
               this.myLockWithLevel.y = this.mHeight * 0.5 - this.myLockWithLevel.height * 0.5;
               swapChildren(this.myLockWithLevel,myHitArea);
            }
            this.mLocked = true;
            this.myLockWithLevel.setLockLevel(this.mOnboardUnlockLevel);
            this.myLockWithLevel.visible = true;
            this.myLock.visible = false;
            this.myBackground.gotoAndStop(LOCKED_STATE_FRAME);
            this.myPlusSign.visible = false;
            this.myDisabledTab.visible = false;
            this.myImage.alpha = 0.3;
         }
         else if(null != data.isEnable && data.isEnable == false)
         {
            this.mLocked = true;
            this.myLock.visible = false;
            this.myBackground.gotoAndStop(LOCKED_STATE_FRAME);
            this.myPlusSign.visible = false;
            this.myLock.alpha = 0.5;
            this.myDisabledTab.visible = true;
         }
         else if(data.type == MarketMenuData.TYPE_CALLSIGN_BADGE && null != data.isLocked && Boolean(data.isLocked))
         {
            this.mLocked = this.myPurchaseIcon.visible = data.isLocked;
            this.myBackground.gotoAndStop(LOCKED_STATE_FRAME);
            this.myLock.visible = false;
            this.myPurchaseIcon.visible = true;
            this.myPlusSign.visible = false;
            this.myDisabledTab.visible = false;
            this.myPurchaseIcon.alpha = 0.5;
         }
         else if(null != data.isLocked && data.isLocked == true)
         {
            this.mLocked = this.myLock.visible = data.isLocked;
            this.myBackground.gotoAndStop(LOCKED_STATE_FRAME);
            this.myPlusSign.visible = false;
            this.myDisabledTab.visible = false;
            this.myLock.alpha = 0.5;
         }
         else if(this.mDisabled == true)
         {
            this.mLocked = this.myLock.visible = false;
            this.myBackground.gotoAndStop(KILL_STATE_FRAME);
            this.myPlusSign.visible = false;
            this.myDisabledTab.visible = false;
         }
         else
         {
            this.mLocked = this.myLock.visible = false;
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
            this.myDisabledTab.visible = false;
         }
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.visible = data.isBanned;
         }
         this.refreshBreadcrumbLock();
         if(this.mIsSuggestedLoadout)
         {
            this.myHighlightOutline.visible = false;
            this.myEquippedIcon.visible = false;
            this.mIgnoreMouse = true;
            if(data.imageURL != null && data.imageURL != "")
            {
               prod = CFunctionCommonContainer.GetItemInfo(data.item_id);
               this.myHighlightOutline.visible = !prod.isOwned();
               this.mIgnoreMouse = !this.myHighlightOutline.visible || !prod.purchaseUiEnabled();
               this.myEquippedIcon.visible = prod.isEquipped();
            }
         }
         this.mFixed = Boolean(data.hasOwnProperty("isFixed")) && data.isFixed != null ? Boolean(data.isFixed) : false;
         if(Boolean(data.isFixed))
         {
            this.mIgnoreMouse = true;
            this.myLock.visible = false;
            if(data.imageURL != null && data.imageURL != "")
            {
               this.myDisabledTab.visible = false;
            }
            else
            {
               this.myDisabledTab.visible = true;
               this.myBackground.gotoAndStop(DISABLED_STATE_FRAME);
            }
            this.myClearButton.visible = false;
         }
         alpha = 1;
         if(data.semiTransparent == true)
         {
            alpha = 0.5;
         }
      }
      
      public function scaleImage(scale:Number, useMask:Boolean = true) : void
      {
         this.myImage.scaleX = scale;
         this.myImage.scaleY = scale;
         this.myImage.x = this.mWidth * 0.5 - this.myImage.width * 0.5;
         this.myImage.y = this.mHeight * 0.5 - this.myImage.height * 0.5;
         if(useMask)
         {
            this.myMask.height = this.mHeight - 2;
            this.myMask.width = this.mWidth - 2;
            this.myMask.visible = true;
            this.myImage.mask = this.myMask;
         }
      }
      
      public function draw() : void
      {
         var clip:Sprite = null;
         myHitArea.width = this.myBackground.width = this.mWidth;
         myHitArea.height = this.myBackground.height = this.mHeight;
         if(this.myHighlightOutline != null)
         {
            this.myHighlightOutline.width = this.mWidth;
            this.myHighlightOutline.height = this.mHeight;
         }
         this.myClearButton.y = CLEAR_BUTTON_MARGIN;
         this.myClearButton.x = this.mWidth - this.myClearButton.width - CLEAR_BUTTON_MARGIN;
         var aspectSize:int = this.mHeight > this.mWidth ? int(this.mHeight) : int(this.mWidth);
         this.myImage.width = aspectSize;
         this.myImage.height = aspectSize;
         var halfWidth:Number = this.mWidth * 0.5;
         var halfHeight:Number = this.mHeight * 0.5;
         this.myLock.x = halfWidth - this.myLock.width * 0.5;
         this.myLock.y = halfHeight - this.myLock.height * 0.5;
         if(this.myPurchaseIcon != null && this.myPurchaseIcon.visible)
         {
            this.myPurchaseIcon.x = halfWidth - this.myPurchaseIcon.width * 0.5;
            this.myPurchaseIcon.y = halfHeight - this.myPurchaseIcon.height * 0.5;
         }
         this.myImage.x = halfWidth - this.myImage.width * 0.5;
         this.myImage.y = halfHeight - this.myImage.height * 0.5;
         this.myPlusSign.x = halfWidth;
         this.myPlusSign.y = halfHeight;
         this.myDisabledTab.scaleX = this.mWidth / DEFAULT_WIDTH;
         this.myDisabledTab.scaleY = this.mHeight / DEFAULT_HEIGHT;
         this.myDisabledTab.x = halfWidth - this.myDisabledTab.width * 0.5;
         this.myDisabledTab.y = halfHeight - this.myDisabledTab.height * 0.5;
         this.myStreakText.y = this.mHeight - STREAK_TEXT_OFFSET_Y;
         if(this.myDisabledIcon != null)
         {
            clip = this.myDisabledIcon["myBackground"];
            clip.width = this.mWidth - 4;
            clip = this.myDisabledIcon["myIcon"];
            clip.x = halfWidth - clip.width * 0.5;
            this.myDisabledIcon.y = this.mHeight * 0.5 - 45;
         }
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      public function get locked() : Boolean
      {
         return this.mLocked;
      }
      
      public function get fixed() : Boolean
      {
         return this.mFixed;
      }
      
      public function set toggled(t:Boolean) : void
      {
         if(this.mToggled != t)
         {
            this.mToggled = t;
         }
         if(true == this.mToggled)
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
         else
         {
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
         }
      }
      
      public function get toggled() : Boolean
      {
         return this.mToggled;
      }
      
      public function set streak(t:Boolean) : void
      {
         this.mDisabled = t;
         if(this.mDisabled == true)
         {
            this.myBackground.gotoAndStop(KILL_STATE_FRAME);
         }
         else
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
      }
      
      public function get streak() : Boolean
      {
         return this.mDisabled;
      }
      
      public function get isExtraSlot() : Boolean
      {
         return this.mIsExtraSlot;
      }
      
      public function set isExtraSlot(isExtraSlot:Boolean) : void
      {
         this.mIsExtraSlot = isExtraSlot;
      }
      
      public function setBreadcrumb(breadcrumb:uint) : void
      {
         UiCppNewItems.instance.InitBreadcrumb(this,breadcrumb,6);
         this.refreshBreadcrumbLock();
      }
      
      private function refreshBreadcrumbLock() : void
      {
         if(getBreadcrumb() != null)
         {
            getBreadcrumb().alpha = this.mLocked || this.mDisabled ? 0 : 1;
         }
      }
      
      public function setOnboardUnlockLevel(level:String) : void
      {
         this.mOnboardUnlockLevel = level;
      }
      
      public function registerClearCallback(f:Function) : void
      {
         if(null != f)
         {
            this.mClearCallback = f;
            if(this.mClearCallback != null && mData != null && mData.isEmpty == false)
            {
               this.myClearButton.visible = true;
            }
            else
            {
               this.myClearButton.visible = false;
            }
         }
      }
      
      public function unregisterClearCallback() : void
      {
         this.mClearCallback = null;
         this.myClearButton.visible = false;
      }
      
      private function onClearClicked() : void
      {
         if(null != this.mClearCallback)
         {
            this.mClearCallback(this);
         }
      }
      
      public function ignoringMouse() : Boolean
      {
         return this.mIgnoreMouse;
      }
      
      override protected function onMouseOver() : void
      {
         if(this.ignoringMouse())
         {
            return;
         }
         if(true == this.mLocked)
         {
            if(this.myPurchaseIcon != null && true == this.myPurchaseIcon.visible)
            {
               this.myPurchaseIcon.alpha = 1;
            }
            else
            {
               this.myLock.alpha = 1;
            }
         }
         if(!this.mLocked && !this.mToggled)
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
         if(true == this.myPlusSign.visible)
         {
            TweenLite.killTweensOf(this.myPlusSign);
            TweenLite.to(this.myPlusSign,GROW_DURATION,{
               "scaleX":1,
               "scaleY":1
            });
         }
      }
      
      override protected function onMouseOut() : void
      {
         if(this.ignoringMouse())
         {
            return;
         }
         if(true == this.mLocked)
         {
            if(this.myPurchaseIcon != null && true == this.myPurchaseIcon.visible)
            {
               this.myPurchaseIcon.alpha = 0.5;
            }
            else
            {
               this.myLock.alpha = 0.5;
            }
         }
         if(!this.mLocked && !this.mToggled)
         {
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
         }
         if(true == this.myPlusSign.visible)
         {
            TweenLite.killTweensOf(this.myPlusSign);
            TweenLite.to(this.myPlusSign,GROW_DURATION,{
               "scaleX":0,
               "scaleY":0
            });
         }
      }
   }
}

