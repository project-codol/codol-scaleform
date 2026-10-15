package codo.component
{
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.utils.CursorUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.utils.getDefinitionByName;
   
   public class ScrollListTabButton extends Button
   {
      
      private static const FRAME_UP:int = 2;
      
      private static const FRAME_TOGGLED:int = 3;
      
      private static const FRAME_OVER:int = 1;
      
      private static const LABEL_MARGIN:Number = 8;
      
      public var myFrame:MovieClip;
      
      public var myPurchaseIcon:Sprite;
      
      private var mLocked:Boolean = false;
      
      private var mPurchaseIconFocusColor:ColorTransform;
      
      private var mPurchaseIconUnfocusColor:ColorTransform;
      
      public function ScrollListTabButton()
      {
         super();
         mTextUnfocusColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         mTextFocusColor = GlobalGuide.CODO_BLACK;
         mTextClickColor = GlobalGuide.CODO_BLACK;
         myLabel.textStyle = ButtonGuide.styleScrollListTabButton;
         myLabel.height = myHitArea.height;
         myLabel.fontColor = mTextUnfocusColor;
         myLabel.alpha = 0.5;
         myLabel.allCaps = true;
         this.myFrame.gotoAndStop(FRAME_UP);
         this.myPurchaseIcon.visible = false;
         mHeight = 29;
         this.draw();
      }
      
      override public function set label(label:String) : void
      {
         myLabel.text = LocalizeUtil.localize(label).toUpperCase();
         this.position();
      }
      
      public function setLocked(locked:Boolean, level:String) : void
      {
         if(locked && level != null)
         {
            this.enabled = false;
            this.makeLevelLock();
         }
         this.mLocked = locked;
         this.myPurchaseIcon.visible = this.mLocked;
         if(true == this.myPurchaseIcon.visible)
         {
            this.mPurchaseIconFocusColor = new ColorTransform();
            this.mPurchaseIconFocusColor.color = GlobalGuide.BLACK;
            this.mPurchaseIconUnfocusColor = new ColorTransform();
            this.mPurchaseIconUnfocusColor.color = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            if(level != null)
            {
               IconLock(this.myPurchaseIcon).setLockLevel(level);
            }
            else
            {
               this.myPurchaseIcon.transform.colorTransform = this.mPurchaseIconUnfocusColor;
            }
         }
         this.position();
      }
      
      private function makeLevelLock() : void
      {
         var lockClass:Class = null;
         var lockClip:IconLock = null;
         if(this.myPurchaseIcon as IconLock == null)
         {
            lockClass = getDefinitionByName("codo.shared.IconLock") as Class;
            lockClip = new lockClass() as IconLock;
            addChild(lockClip);
            lockClip.x = this.myPurchaseIcon.x;
            lockClip.y = this.myPurchaseIcon.y;
            lockClip.scaleX = lockClip.scaleY = this.myPurchaseIcon.height / lockClip.height;
            this.myPurchaseIcon = lockClip;
            swapChildren(this.myPurchaseIcon,myHitArea);
         }
      }
      
      public function position() : void
      {
         var BTN_PADDING:uint = 20;
         var btnWidth:Number = myLabel.textWidth + BTN_PADDING;
         if(this.mLocked)
         {
            btnWidth += this.myPurchaseIcon.width;
         }
         if(true == this.myPurchaseIcon.visible)
         {
            myLabel.x = this.myFrame.x + LABEL_MARGIN;
         }
         else
         {
            myLabel.x = this.myFrame.x;
         }
         myLabel.width = btnWidth;
         myHitArea.width = btnWidth;
         this.myFrame.width = btnWidth;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         myLabel.fontColor = mTextFocusColor;
         if(true == mToggled)
         {
            myLabel.fontColor = GlobalGuide.WHITE;
            myLabel.alpha = 1;
            CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.myFrame.gotoAndStop(FRAME_TOGGLED);
         }
         else
         {
            myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            myLabel.alpha = 0.5;
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.myFrame.gotoAndStop(FRAME_UP);
         }
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.lockedForPurchase)
         {
            this.setLocked(Boolean(data.lockedForPurchase) || data.onboardLock != null,data.onboardLock);
         }
      }
      
      override protected function onMouseOver() : void
      {
         if(true == enabled && false == mToggled)
         {
            myLabel.fontColor = GlobalGuide.CODO_BLACK;
            myLabel.alpha = 1;
            CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.myFrame.gotoAndStop(FRAME_OVER);
         }
         if(this.myPurchaseIcon.visible && this.myPurchaseIcon as IconLock == null)
         {
            this.myPurchaseIcon.transform.colorTransform = this.mPurchaseIconFocusColor;
         }
      }
      
      override protected function onMouseOut() : void
      {
         if(true == enabled && false == mToggled)
         {
            myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            myLabel.alpha = 0.5;
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
            this.myFrame.gotoAndStop(FRAME_UP);
         }
         if(this.myPurchaseIcon.visible && this.myPurchaseIcon as IconLock == null)
         {
            this.myPurchaseIcon.transform.colorTransform = this.mPurchaseIconUnfocusColor;
         }
      }
      
      override public function set enabled(doEnable:Boolean) : void
      {
         super.enabled = doEnable;
         if(!doEnable)
         {
            myLabel.fontColor = GlobalGuide.WHITE;
            myLabel.alpha = 1;
            this.myFrame.gotoAndStop(FRAME_TOGGLED);
         }
         else
         {
            this.onMouseOut();
            this.myFrame.gotoAndStop(FRAME_UP);
         }
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function draw() : void
      {
         this.myFrame.height = mHeight;
         myHitArea.height = mHeight;
         this.myPurchaseIcon.y = myHitArea.y + mHeight * 0.5 - this.myPurchaseIcon.height * 0.5;
      }
   }
}

