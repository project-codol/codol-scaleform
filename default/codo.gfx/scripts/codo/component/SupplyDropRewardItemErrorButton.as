package codo.component
{
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.style.GlobalGuide;
   import codo.style.SupplyDropGuide;
   import codo.style.TextStyle;
   import codo.utils.GraphicUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.Sprite;
   import fsg.util.ImageHolderSimple;
   
   public class SupplyDropRewardItemErrorButton extends Button
   {
      
      private static const FADE_DURATION:Number = 0.3;
      
      private static const BASE_ALPHA:Number = 0.5;
      
      public var myDependencyImage:ImageHolderSimple;
      
      public var myBkg:Sprite;
      
      public var myWarningIcon:Sprite;
      
      public function SupplyDropRewardItemErrorButton()
      {
         super();
         var style:TextStyle = SupplyDropGuide.styleSupplyDropFeatureItemButtonLabel;
         style.font = GlobalGuide.FONT_FACE_BOLD;
         myLabel.textStyle = style;
         myLabel.width = 128;
         this.myBkg.alpha = BASE_ALPHA;
         this.myWarningIcon.alpha = 0;
      }
      
      public function set dependencyItemImage(imageURL:String) : void
      {
         GraphicUtil.desaturate(this.myDependencyImage);
         this.myDependencyImage.setImage(imageURL);
         this.myDependencyImage.alpha = BASE_ALPHA;
      }
      
      public function set inError(bInError:Boolean) : void
      {
         gotoAndStop(bInError ? 1 : 2);
         this.myWarningIcon.visible = bInError;
         myLabel.text = bInError ? DictMarket.SUPPLY_DROP_REQUIRES_ADDITIONAL_ITEM : Dict.VIEW_DEPENDENCY;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         myLabel.fontColor = GlobalGuide.WHITE;
         TweenLite.to(this.myBkg,FADE_DURATION,{
            "alpha":1,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.myDependencyImage,FADE_DURATION,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "delay":0.1
         });
         if(this.myWarningIcon.visible)
         {
            TweenLite.to(this.myWarningIcon,FADE_DURATION,{
               "alpha":1,
               "ease":Cubic.easeOut,
               "delay":0.15
            });
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         TweenLite.to(this.myBkg,FADE_DURATION,{
            "alpha":BASE_ALPHA,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.myDependencyImage,FADE_DURATION,{
            "alpha":BASE_ALPHA,
            "ease":Cubic.easeOut,
            "delay":0.1
         });
         if(this.myWarningIcon.visible)
         {
            TweenLite.to(this.myWarningIcon,FADE_DURATION,{
               "alpha":0,
               "ease":Cubic.easeOut
            });
         }
      }
   }
}

