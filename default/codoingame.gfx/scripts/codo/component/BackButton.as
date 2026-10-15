package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Strong;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class BackButton extends UIInteractiveComponent
   {
      
      protected static const SHOW_ANIM_DURATION:Number = 0.4;
      
      protected static const BACKGROUND_MARGIN:Number = 120;
      
      protected static const MASK_MARGIN:Number = 40;
      
      protected static const LABEL_MAX_WIDTH:Number = 960;
      
      public var myLabel:TextField;
      
      public var myArrow:MovieClip;
      
      public var myMask:Sprite;
      
      public var myBackground:Sprite;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mIconColorOn:ColorTransform;
      
      private var mIconColorOff:ColorTransform;
      
      public function BackButton()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.width = LABEL_MAX_WIDTH;
         this.label = LocalizeUtil.localize(Dict.BACK_WITH_ESCAPE);
         this.mWidth = myHitArea.width;
         this.mHeight = myHitArea.height;
         this.mIconColorOn = new ColorTransform();
         this.mIconColorOn.color = GlobalGuide.WHITE;
         this.mIconColorOff = new ColorTransform();
         this.mIconColorOff.color = GlobalGuide.CODO_BLUE_LIGHT;
         this.myArrow.transform.colorTransform = this.mIconColorOff;
         this.myBackground.y = -this.myBackground.height;
         this.myLabel.y = this.myBackground.y + 13;
         this.myArrow.y = this.myBackground.y + 15;
         audioRef.overrideMouseOverAudio(SE_ID.UI_MARKET_BACK_HOVER);
         audioRef.overrideClickAudio(SE_ID.UI_MARKET_BACK_CLICK);
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l;
         this.myBackground.width = this.myLabel.x + this.myLabel.textWidth + BACKGROUND_MARGIN;
         this.myMask.width = this.myBackground.width + MASK_MARGIN;
         myHitArea.width = this.myMask.width;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function doNotUseBackground() : void
      {
         this.myBackground.y = 0;
         this.myBackground.visible = false;
         this.myLabel.y = 14;
         this.myArrow.y = 15;
      }
      
      public function show() : void
      {
         TweenLite.killTweensOf(this.myBackground);
         TweenLite.killTweensOf(this.myLabel);
         TweenLite.killTweensOf(this.myArrow);
         TweenLite.killTweensOf(myHitArea);
         TweenLite.to(this.myBackground,SHOW_ANIM_DURATION,{
            "y":0,
            "ease":Strong.easeOut
         });
         TweenLite.to(myHitArea,SHOW_ANIM_DURATION,{
            "y":0,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.myLabel,SHOW_ANIM_DURATION,{
            "y":14,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.myArrow,SHOW_ANIM_DURATION,{
            "y":15,
            "ease":Strong.easeOut
         });
      }
      
      public function hide() : void
      {
         TweenLite.killTweensOf(this.myBackground);
         TweenLite.killTweensOf(this.myLabel);
         TweenLite.killTweensOf(this.myArrow);
         TweenLite.killTweensOf(myHitArea);
         TweenLite.to(this.myBackground,SHOW_ANIM_DURATION,{
            "y":-this.myBackground.height,
            "ease":Strong.easeOut
         });
         TweenLite.to(myHitArea,SHOW_ANIM_DURATION,{
            "y":-this.myBackground.height,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.myLabel,SHOW_ANIM_DURATION,{
            "y":-this.myBackground.height + 13,
            "ease":Strong.easeOut
         });
         TweenLite.to(this.myArrow,SHOW_ANIM_DURATION,{
            "y":-this.myBackground.height + 15,
            "ease":Strong.easeOut
         });
      }
      
      override protected function onMouseOver() : void
      {
         this.myArrow.transform.colorTransform = this.mIconColorOn;
      }
      
      override protected function onMouseOut() : void
      {
         this.myArrow.transform.colorTransform = this.mIconColorOff;
      }
   }
}

