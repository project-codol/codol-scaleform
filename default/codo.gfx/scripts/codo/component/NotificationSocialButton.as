package codo.component
{
   import codo.style.GlobalGuide;
   import com.greensock.TweenMax;
   import fl.motion.Color;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class NotificationSocialButton extends SocialButton
   {
      
      public var myOutline:Sprite;
      
      private var mOutColor:Color = new Color();
      
      private var mPulseScale:TweenMax;
      
      public function NotificationSocialButton()
      {
         super();
         this.mOutColor.setTint(GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,1);
         this.myOutline.visible = false;
      }
      
      override protected function endHighlight() : void
      {
         if(this.myOutline.visible)
         {
            myIcon.transform.colorTransform = this.mOutColor;
         }
         else
         {
            super.endHighlight();
         }
      }
      
      public function setPulse(value:Boolean) : void
      {
         var notificationColor:ColorTransform = null;
         var wasPulsing:Boolean = this.mPulseScale != null;
         if(value == wasPulsing)
         {
            return;
         }
         if(value)
         {
            this.myOutline.visible = true;
            notificationColor = new ColorTransform();
            notificationColor.color = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
            myIcon.transform.colorTransform = notificationColor;
            this.mPulseScale = new TweenMax(this,0.3,{
               "scaleX":1.1,
               "scaleY":1.1,
               "yoyo":true,
               "repeat":-1
            });
            this.mPulseScale.play();
         }
         else
         {
            this.myOutline.visible = false;
            this.mPulseScale.complete();
            this.mPulseScale = null;
         }
      }
      
      public function handleInitClick() : void
      {
         if(!this.myOutline.visible)
         {
            return;
         }
         super.endHighlight();
         this.myOutline.visible = false;
         this.mPulseScale.complete();
         this.mPulseScale = null;
      }
   }
}

