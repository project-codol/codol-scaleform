package codo.views.uitour.ingame
{
   import codo.component.tutorial.TourBaseComponent;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Elastic;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.shared.InputIconUtility;
   import scaleform.gfx.TextFieldEx;
   
   public class UITourInGameSharedObjectiveWindow extends TourBaseComponent
   {
      
      public var myObjectiveTF:TextField;
      
      public var myOverlayBkg:Sprite;
      
      public var myBracketTop:Sprite;
      
      public var myBracketBottom:Sprite;
      
      public var myOverlayMask:Sprite;
      
      public var myIcon:InputIconUtility;
      
      public var myBlankKey:Sprite;
      
      private var mFrameHeight:uint;
      
      private var mAnimComplete:Boolean = false;
      
      public function UITourInGameSharedObjectiveWindow()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myObjectiveTF,TextFieldEx.VALIGN_CENTER);
         deactive();
         this.myBlankKey.visible = false;
         if(!ScaleformUtil.isScaleform)
         {
            this.myObjectiveTF.border = true;
            this.objective = "SHOOT THE BADDIESS SD DSD SD S";
            this.objectiveIcon = "4";
            this.active();
         }
      }
      
      public function setKeyImageByRef(ref:String = null) : void
      {
         this.myIcon.clear();
         if(ref == null)
         {
            this.myIcon.visible = false;
            return;
         }
         this.myIcon.keyImage.setImage(ref);
         this.myIcon.visible = true;
         this.setFrameOffsetToFitIcon();
      }
      
      private function setFrameOffsetToFitIcon() : void
      {
         var frameOffset:uint = 65;
         var iconHeightOffset:uint = 60;
         this.myIcon.y = this.myObjectiveTF.y + this.myObjectiveTF.textHeight + iconHeightOffset;
         if(this.myBlankKey.visible)
         {
            this.myBlankKey.y = this.myIcon.y - (iconHeightOffset + 3);
         }
         this.mFrameHeight += frameOffset;
      }
      
      public function set objectiveIcon(key:String) : void
      {
         var overrideBlank:Boolean = false;
         if(key == null)
         {
            this.myBlankKey.visible = this.myIcon.visible = false;
            return;
         }
         this.myIcon.visible = true;
         if(ScaleformUtil.isScaleform)
         {
            overrideBlank = this.myIcon.setForCommand(key,GlobalGuide.BLACK);
            this.myBlankKey.visible = !overrideBlank;
            this.setFrameOffsetToFitIcon();
         }
      }
      
      public function set objective(txt:String) : void
      {
         this.myObjectiveTF.text = LocalizeUtil.localize(txt);
         this.mFrameHeight = this.myObjectiveTF.textHeight + 40;
         this.myObjectiveTF.height = this.mFrameHeight;
      }
      
      override public function reset() : void
      {
         TweenLite.killTweensOf(this.myOverlayMask);
         this.myObjectiveTF.alpha = this.myBracketTop.alpha = this.myBracketBottom.alpha = 0;
         this.myBracketTop.y = this.myBracketTop.height * 2;
         this.myBracketBottom.y = this.myBracketTop.y - this.myBracketBottom.height;
         this.myOverlayMask.width = 0;
         this.mAnimComplete = false;
      }
      
      override public function active() : void
      {
         var startBotY:uint = 0;
         super.active();
         var animDelay:Number = 0.3;
         startBotY = this.myOverlayBkg.y + this.mFrameHeight + 2;
         this.myOverlayBkg.height = this.mFrameHeight;
         this.myBracketTop.visible = this.myBracketBottom.visible = true;
         this.reset();
         this.myBracketTop.visible = this.myBracketBottom.visible = true;
         TweenLite.to(this.myBracketBottom,0.8,{
            "alpha":1,
            "y":startBotY - 35,
            "ease":Elastic.easeInOut
         });
         TweenLite.to(this.myBracketTop,0.8,{
            "alpha":1,
            "y":43,
            "ease":Elastic.easeInOut
         });
         TweenLite.to(this.myOverlayMask,0.4,{
            "width":238,
            "height":this.mFrameHeight,
            "ease":Cubic.easeOut,
            "delay":animDelay
         });
         TweenLite.to(this.myObjectiveTF,1,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "delay":0.5
         });
         this.mAnimComplete = true;
      }
      
      override protected function onAnimationComplete() : void
      {
      }
   }
}

