package codo.component
{
   import codo.style.ButtonGuide;
   import codo.style.TextStyle;
   import flash.display.Sprite;
   
   public class LockButton extends Button
   {
      
      private static const LOCK_MARGIN:int = 20;
      
      private static const LOCK_PADDING:int = 5;
      
      public var myLockLabel:TextField;
      
      public var myLock:Sprite;
      
      private var mLocked:Boolean = false;
      
      public function LockButton()
      {
         super();
         this.myLock.visible = false;
         this.myLockLabel.visible = false;
         this.myLockLabel.textStyle = ButtonGuide.styleButtonCommon;
         this.myLockLabel.alignment = TextStyle.HALIGN_LEFT;
         this.myLockLabel.fontColor = mTextUnfocusColor;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.name)
         {
            myLabel.text = data.name;
         }
         if(null != data.locked)
         {
            this.myLock.visible = data.locked;
            this.locked = data.locked;
         }
         if(data.unlockLevel > 0 && this.locked)
         {
            this.myLockLabel.text = String(data.unlockLevel);
            this.myLockLabel.visible = true;
         }
         this.draw();
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         myLabel.alpha = enabled ? 1 : 0.5;
         if(enabled && toggled)
         {
            myLabel.fontColor = mTextFocusColor;
            myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
         else
         {
            myLabel.fontColor = mTextUnfocusColor;
            myBackground.gotoAndStop(mUpStateFrame);
         }
      }
      
      public function get locked() : Boolean
      {
         return this.mLocked;
      }
      
      public function set locked(l:Boolean) : void
      {
         this.mLocked = l;
      }
      
      override public function draw() : void
      {
         super.draw();
         this.myLockLabel.width = mWidth;
         this.myLockLabel.height = mHeight;
         if(this.mLocked && !this.myLockLabel.visible)
         {
            this.myLock.x = myBackground.x + LOCK_MARGIN;
         }
         else if(this.mLocked && this.myLockLabel.visible)
         {
            this.myLock.x = this.myLockLabel.x + this.myLockLabel.textWidth + LOCK_PADDING;
         }
      }
      
      override protected function shouldShowHighlight() : Boolean
      {
         return !mToggled && !this.mLocked;
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         this.myLockLabel.fontColor = mTextFocusColor;
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         this.myLockLabel.fontColor = mTextUnfocusColor;
      }
      
      override protected function showClickState() : void
      {
         super.showClickState();
         this.myLockLabel.fontColor = mTextClickColor;
      }
   }
}

