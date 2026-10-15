package codo.views.hud.popups.HudSplashPopup_parts
{
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import fl.motion.easing.Linear;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudZhuntObtainConsumableSplashContent extends HudSplashPopupContent
   {
      
      public var myStack:TextField;
      
      public var myIcon:FsgImageHolder;
      
      public var myTitle:TextField;
      
      public var myDesc:TextField;
      
      public var myIconBg:MovieClip;
      
      public var myDarkBg:MovieClip;
      
      public function HudZhuntObtainConsumableSplashContent()
      {
         super();
      }
      
      override public function setData(icon:String, title:String, titleColor:int, description:String, param:String) : void
      {
         this.myStack.text = "x" + param;
         this.myIcon.setImage(icon);
         this.myTitle.textColor = titleColor;
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myTitle,title);
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myDesc,description);
         this.myStack.alpha = this.myTitle.alpha = this.myDesc.alpha = this.myIconBg.alpha = this.myDarkBg.alpha = 1;
      }
      
      public function killAllTweens() : void
      {
         TweenLite.killTweensOf(this);
         TweenLite.killTweensOf(this.myStack);
         TweenLite.killTweensOf(this.myIcon);
         TweenLite.killTweensOf(this.myTitle);
         TweenLite.killTweensOf(this.myDesc);
         TweenLite.killTweensOf(this.myIconBg);
         TweenLite.killTweensOf(this.myDarkBg);
      }
      
      public function iconBounce(duration:Number) : void
      {
         var timeLineLite1:TimelineLite = new TimelineLite();
         timeLineLite1.append(new TweenLite(this.myIcon,duration / 2,{
            "x":this.myIcon.x - this.myIcon.width * 0.25,
            "y":this.myIcon.y - this.myIcon.height * 0.25,
            "width":this.myIcon.width * 1.5,
            "height":this.myIcon.height * 1.5,
            "ease":Linear.easeIn
         }));
         timeLineLite1.append(new TweenLite(this.myIcon,duration / 2,{
            "x":this.myIcon.x,
            "y":this.myIcon.y,
            "width":this.myIcon.width,
            "height":this.myIcon.height,
            "ease":Linear.easeOut
         }));
         var timeLineLite2:TimelineLite = new TimelineLite();
         timeLineLite2.append(new TweenLite(this.myIconBg,duration / 2,{
            "x":this.myIconBg.x - this.myIconBg.width * 0.25,
            "y":this.myIconBg.y - this.myIconBg.height * 0.25,
            "width":this.myIconBg.width * 1.5,
            "height":this.myIconBg.height * 1.5,
            "ease":Linear.easeIn
         }));
         timeLineLite2.append(new TweenLite(this.myIconBg,duration / 2,{
            "x":this.myIconBg.x,
            "y":this.myIconBg.y,
            "width":this.myIconBg.width,
            "height":this.myIconBg.height,
            "ease":Linear.easeOut
         }));
      }
      
      public function fadeAllElementsExceptIcon(duration:Number) : void
      {
         TweenLite.to(this.myStack,duration,{"alpha":0});
         TweenLite.to(this.myTitle,duration,{"alpha":0});
         TweenLite.to(this.myDesc,duration,{"alpha":0});
         TweenLite.to(this.myIconBg,duration,{"alpha":0});
         TweenLite.to(this.myDarkBg,duration,{"alpha":0});
      }
      
      public function setDarkBackgroundVisibility(visible:Boolean) : void
      {
         this.myDarkBg.visible = visible;
      }
   }
}

