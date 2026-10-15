package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.style.GlobalGuide;
   import codo.utils.ScaleformUtil;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class SocialButton extends UIInteractiveComponent
   {
      
      private static const SOCIAL_BTN_COLOR:uint = 4375548;
      
      public static const TYPE_MAIL:int = 1;
      
      public static const TYPE_LEADERBOARD:int = 2;
      
      public static const TYPE_FRIEND:int = 3;
      
      public static const TYPE_CLAN:int = 4;
      
      public static const TYPE_PARTY:int = 5;
      
      public static const TYPE_LIVE:int = 6;
      
      public static const TYPE_TEAMMATE_RECRUITMENT:int = 7;
      
      public static const TYPE_NOTIFICATIONS:int = 8;
      
      public static const TYPE_IN_PARTY:int = 9;
      
      public var myIcon:MovieClip;
      
      public var myNumber:flash.text.TextField;
      
      public var myRedDot:MovieClip;
      
      public var myStarBurst:MovieClip;
      
      public var myNumberBG:Sprite;
      
      public var myCornerNumber:flash.text.TextField;
      
      public var myAnimation:MovieClip;
      
      private var mLockIcon:IconLock;
      
      private var mToggled:Boolean = false;
      
      private var mSocialButtonColor:uint = 4375548;
      
      public function SocialButton()
      {
         super();
         this.isInteractiveEnabled = true;
         this.number = 0;
         this.myRedDot.visible = false;
         this.myStarBurst.visible = false;
         this.myNumberBG.visible = false;
         if(Boolean(this.myAnimation))
         {
            this.switchShowAnimation(false);
         }
      }
      
      override public function set isInteractiveEnabled(setEnabled:Boolean) : void
      {
         super.isInteractiveEnabled = setEnabled;
         this.myIcon.alpha = setEnabled ? 1 : 0.5;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!this.mToggled)
         {
            this.showHighlight();
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!this.mToggled)
         {
            this.endHighlight();
         }
      }
      
      public function set buttonColor(c:uint) : void
      {
         this.mSocialButtonColor = c;
         this.endHighlight();
      }
      
      public function set type(value:int) : void
      {
         this.myIcon.gotoAndStop(value);
      }
      
      public function set number(value:int) : void
      {
         this.myNumber.text = String(value);
         this.myNumber.visible = this.myNumberBG.visible = value != 0;
         this.myNumberBG.width = this.myNumberBG.height = Math.max(this.myNumber.textWidth,this.myNumber.textHeight) + 4;
      }
      
      public function switchShowAnimation(value:Boolean) : void
      {
         if(value)
         {
            this.myAnimation.visible = true;
            this.myAnimation.gotoAndPlay(1);
         }
         else
         {
            this.myAnimation.visible = false;
            this.myAnimation.stop();
         }
      }
      
      public function set cornerNumber(value:String) : void
      {
         this.myCornerNumber.text = value;
      }
      
      public function switchShowRedDot(show:Boolean) : void
      {
         this.myRedDot.visible = show;
      }
      
      public function setToggled(toggled:Boolean) : void
      {
         this.mToggled = toggled;
         if(this.mToggled)
         {
            this.showHighlight();
         }
         else
         {
            this.endHighlight();
         }
      }
      
      public function setIconLock() : void
      {
         var lockClass:Class = null;
         var lockClip:IconLock = null;
         if(this.mLockIcon == null)
         {
            lockClass = getDefinitionByName("codo.shared.IconLock") as Class;
            lockClip = new lockClass() as IconLock;
            addChild(lockClip);
            swapChildren(lockClip,myHitArea);
            lockClip.scaleX = lockClip.scaleY = 0.25;
            lockClip.myIcon.scaleX = 0.8;
            lockClip.myIcon.scaleY = 0.9;
            this.mLockIcon = lockClip;
            this.mLockIcon.x = myHitArea.x + (myHitArea.width - 15);
            this.mLockIcon.y = myHitArea.y - 5;
            this.mLockIcon.filters = [new DropShadowFilter(4,135,0,0.6,0.6,0.6,0.6)];
            this.iconTint = GlobalGuide.GRAY_50;
         }
      }
      
      public function setOnboardLock(sku:String) : void
      {
         var lockClass:Class = null;
         var lockClip:IconLock = null;
         var IS_DEBUG:Boolean = !ScaleformUtil.isScaleform;
         var lockLevel:String = IS_DEBUG ? "6" : CFunctionCommonContainer.GetOnboardUnlockLevel(sku);
         if(lockLevel == null && !IS_DEBUG)
         {
            return;
         }
         if(this.mLockIcon == null)
         {
            lockClass = getDefinitionByName("codo.shared.IconLock") as Class;
            lockClip = new lockClass() as IconLock;
            addChild(lockClip);
            swapChildren(lockClip,myHitArea);
            lockClip.scaleX = lockClip.scaleY = 0.25;
            lockClip.myIcon.scaleX = 0.8;
            lockClip.myIcon.scaleY = 0.9;
            this.mLockIcon = lockClip;
            this.mLockIcon.x = myHitArea.x + (myHitArea.width - 15);
            this.mLockIcon.y = myHitArea.y - 5;
            this.mLockIcon.filters = [new DropShadowFilter(4,135,0,0.6,0.6,0.6,0.6)];
            this.iconTint = GlobalGuide.GRAY_50;
         }
         this.mLockIcon.setLockLevel(lockLevel);
      }
      
      public function get lockedForLevel() : Boolean
      {
         return this.mLockIcon != null;
      }
      
      protected function showHighlight() : void
      {
         if(this.lockedForLevel)
         {
            return;
         }
         this.iconTint = GlobalGuide.WHITE;
      }
      
      protected function endHighlight() : void
      {
         if(this.lockedForLevel)
         {
            return;
         }
         this.iconTint = this.mSocialButtonColor;
      }
      
      private function set iconTint(color:uint) : void
      {
         var c:Color = new Color();
         c.setTint(color,1);
         this.myIcon.transform.colorTransform = c;
      }
   }
}

