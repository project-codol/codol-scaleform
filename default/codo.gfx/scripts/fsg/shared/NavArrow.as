package fsg.shared
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   
   public class NavArrow extends Sprite
   {
      
      private static const ANIM_SPEED:Number = 0.5;
      
      public var myHitArea:MovieClip;
      
      public var myArrowIcon:MovieClip;
      
      public var myBkg:Sprite;
      
      private var mNavArrowClickable:BehaviourClickable;
      
      private var mNavArrowAudio:BehaviourAudio;
      
      private var mNavArrowAnimClickable:BehaviourAnimatedClickable;
      
      private var mIsEnabled:Boolean;
      
      private var mPreventFadeOutOnRollOut:Boolean = false;
      
      public function NavArrow()
      {
         super();
         this.mNavArrowClickable = new BehaviourClickable(this.myHitArea);
         this.mNavArrowAnimClickable = new BehaviourAnimatedClickable(this.myArrowIcon,this.mNavArrowClickable,1,2,3);
         this.mNavArrowAudio = new BehaviourAudio(this.mNavArrowClickable);
         this.mNavArrowClickable.addMouseOverCallback(this.onMouseOver);
         this.mNavArrowClickable.addMouseOutCallback(this.onMouseOut);
         this.enabled = false;
         alpha = 0;
      }
      
      public function setOrientRight() : void
      {
         var dropShadow:DropShadowFilter = null;
         dropShadow = this.myBkg.filters[0];
         rotation = 180;
         x = this.width;
         y = this.height;
         dropShadow.angle = 180;
         this.myBkg.filters = [dropShadow];
      }
      
      private function onMouseOver() : void
      {
         if(!this.mIsEnabled)
         {
            return;
         }
         TweenLite.to(this,ANIM_SPEED,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "overwrite":1
         });
      }
      
      private function onMouseOut() : void
      {
         if(!this.mIsEnabled || this.mPreventFadeOutOnRollOut)
         {
            return;
         }
         TweenLite.to(this,ANIM_SPEED,{
            "alpha":0,
            "ease":Cubic.easeOut,
            "overwrite":1
         });
      }
      
      public function set clickCallback(callback:Function) : void
      {
         this.mNavArrowClickable.addClickCallback(callback,this);
      }
      
      public function set preventFadeOutOnRollOut(preventFadeOut:Boolean) : void
      {
         this.mPreventFadeOutOnRollOut = preventFadeOut;
         alpha = 1;
         this.myBkg.visible = !preventFadeOut;
      }
      
      public function get enabled() : Boolean
      {
         return this.mIsEnabled;
      }
      
      public function set enabled(isEnabled:Boolean) : void
      {
         if(!isEnabled)
         {
            this.onMouseOut();
         }
         this.mIsEnabled = isEnabled;
         visible = isEnabled;
         this.mNavArrowAnimClickable.setEnabled(isEnabled);
      }
      
      public function set buttonWidth(btnWidth:uint) : void
      {
         this.myBkg.width = this.myHitArea.width = btnWidth;
         this.myArrowIcon.x = (btnWidth - this.myArrowIcon.width) * 0.5;
      }
      
      public function set buttonHeight(btnHeight:uint) : void
      {
         this.myBkg.height = this.myHitArea.height = btnHeight;
         this.myArrowIcon.y = (btnHeight - this.myArrowIcon.height) * 0.5;
      }
   }
}

